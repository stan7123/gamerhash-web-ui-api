@echo off

call environment.bat

if "%1"=="/run-latest-release" goto :checkout_latest_release
if "%1"=="/run-specific-release" goto :checkout_specific_release
goto :checkout_master


:checkout_specific_release
if "%2"=="" (
	echo Specify release version: %~nx0 ^/run-specific-release ^<release_version^>
	exit /b 1
)
set release_version=%2
echo Checking out %release_version%...
git -C "%~dp0webui" checkout %release_version%
if %ERRORLEVEL% == 0 goto :done
echo Error occured. Trying to check out on master branch.
goto :checkout_master

:checkout_latest_release
echo Checking out latest release...
for /f %%a in ('git -C "%~dp0webui" describe --tags --abbrev^=0 origin/master') do git -C "%~dp0webui" checkout %%a
if %ERRORLEVEL% == 0 goto :done
echo Error occured. Trying to check out on master branch.
goto :checkout_master

:checkout_master
echo Checking out master...
git -C "%~dp0webui" checkout master
git -C "%~dp0webui" pull
if %ERRORLEVEL% == 0 goto :done
goto :checkout_default

:checkout_default
git -C "%~dp0webui" checkout master
git -C "%~dp0webui" reset --hard
git -C "%~dp0webui" pull

:done
pause
