@echo off
cls
Title Creating MediaPortal Israel DVB-T Logos Installer

:: Check for modification
svn status .. | findstr "^M"
if ERRORLEVEL 1 (
	echo No modifications in source folder.
) else (
	echo There are modifications in source folder. Aborting.
	pause
	exit 1
)

if "%programfiles(x86)%XXX"=="XXX" goto 32BIT
	:: 64-bit
	set PROGS=%programfiles(x86)%
	goto CONT
:32BIT
	set PROGS=%ProgramFiles%	
:CONT

:: set version
SET version=1.2.0.0

:: Temp xmp2 file
copy IsraelLogos.xmp2 IsraelLogosTemp.xmp2

:: Sed "update-{VERSION}.xml" from xmp2 file
Tools\sed.exe -i "s/update-{VERSION}.xml/update-%version%.xml/g" IsraelLogosTemp.xmp2

:: Build MPE1
"%PROGS%\Team MediaPortal\MediaPortal\MPEMaker.exe" IsraelLogosTemp.xmp2 /B /V=%version% /UpdateXML

:: Cleanup
del IsraelLogosTemp.xmp2

:: Sed "IsraelLogos-{VERSION}.MPE1" from update.xml
Tools\sed.exe -i "s/IsraelLogos-{VERSION}.MPE1/IsraelLogos-%version%.MPE1/g" update-%version%.xml

:: Parse version (Might be needed in the futute)
FOR /F "tokens=1-4 delims=." %%i IN ("%version%") DO ( 
	SET major=%%i
	SET minor=%%j
	SET build=%%k
	SET revision=%%l
)

:: Rename MPE1
if exist "..\builds\IsraelLogos-%major%.%minor%.%build%.%revision%.MPE1" del "..\builds\IsraelLogos-%major%.%minor%.%build%.%revision%.MPE1"
rename ..\builds\IsraelLogos-MAJOR.MINOR.BUILD.REVISION.MPE1 "IsraelLogos-%major%.%minor%.%build%.%revision%.MPE1"
