From: akpm@linux-foundation.org
Subject: + gpiolib-allow-user-selection-update.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:42:09 -0700
Message-ID: <200807111847.m6BIlnQT031061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976AbYGKSti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, benh@kernel.crashing.org, bunk@stusta.de, david-b@pacbell.net, galak@gate.crashing.org, hskinnemoen@atmel.com, jesper.nilsson@axis.com, khali@linux-fr.org, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, sam@ravnborg.org, sameo@openedhand.com, sfr@canb.auug.org.au, tglx@linutronix.de


The patch titled
     gpiolib: allow user-selection (update)
has been added to the -mm tree.  Its filename is
     gpiolib-allow-user-selection-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: allow user-selection (update)
From: Michael Buesch <mb@bu3sch.de>

The defconfig patching was removed since the last version of the patch.
defconfigs will automatically get updated.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/am200epdkit_defconfig          |    2 +-
 arch/arm/configs/xm_x270_defconfig              |    2 +-
 arch/avr32/configs/atngw100_defconfig           |    2 +-
 arch/avr32/configs/atstk1002_defconfig          |    2 +-
 arch/avr32/configs/atstk1003_defconfig          |    2 +-
 arch/avr32/configs/atstk1004_defconfig          |    2 +-
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig |    2 +-
 arch/x86/Kconfig                                |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/arm/configs/am200epdkit_defconfig~gpiolib-allow-user-selection-update arch/arm/configs/am200epdkit_defconfig
--- a/arch/arm/configs/am200epdkit_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/arm/configs/am200epdkit_defconfig
@@ -668,7 +668,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/arm/configs/xm_x270_defconfig~gpiolib-allow-user-selection-update arch/arm/configs/xm_x270_defconfig
--- a/arch/arm/configs/xm_x270_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/arm/configs/xm_x270_defconfig
@@ -970,7 +970,7 @@ CONFIG_I2C_PXA=y
 # CONFIG_I2C_DEBUG_BUS is not set
 # CONFIG_I2C_DEBUG_CHIP is not set
 # CONFIG_SPI is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atngw100_defconfig~gpiolib-allow-user-selection-update arch/avr32/configs/atngw100_defconfig
--- a/arch/avr32/configs/atngw100_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/avr32/configs/atngw100_defconfig
@@ -646,7 +646,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1002_defconfig~gpiolib-allow-user-selection-update arch/avr32/configs/atstk1002_defconfig
--- a/arch/avr32/configs/atstk1002_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/avr32/configs/atstk1002_defconfig
@@ -664,7 +664,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1003_defconfig~gpiolib-allow-user-selection-update arch/avr32/configs/atstk1003_defconfig
--- a/arch/avr32/configs/atstk1003_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/avr32/configs/atstk1003_defconfig
@@ -614,7 +614,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/avr32/configs/atstk1004_defconfig~gpiolib-allow-user-selection-update arch/avr32/configs/atstk1004_defconfig
--- a/arch/avr32/configs/atstk1004_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/avr32/configs/atstk1004_defconfig
@@ -390,7 +390,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~gpiolib-allow-user-selection-update arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig~gpiolib-allow-user-selection-update
+++ a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -703,7 +703,7 @@ CONFIG_SPI_MPC83xx=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=y
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_HAVE_GPIO_LIB=y
 
 #
 # GPIO Support
diff -puN arch/x86/Kconfig~gpiolib-allow-user-selection-update arch/x86/Kconfig
--- a/arch/x86/Kconfig~gpiolib-allow-user-selection-update
+++ a/arch/x86/Kconfig
@@ -21,9 +21,9 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
+	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 	select HAVE_KRETPROBES
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
some-unchangelogged-un-signed-off-but-important-looking-ide-cd-fix.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

