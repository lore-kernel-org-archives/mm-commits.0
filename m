From: akpm@linux-foundation.org
Subject: + spi-kconfig-simplifications.patch added to -mm tree
Date: Mon, 12 May 2008 17:14:46 -0700
Message-ID: <200805130014.m4D0Eku5016175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183AbYEMAPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dbrownell@users.sourceforge.net


The patch titled
     SPI Kconfig simplifications
has been added to the -mm tree.  Its filename is
     spi-kconfig-simplifications.patch

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
Subject: SPI Kconfig simplifications
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Use "if SPI_MASTER" to remove numerous dependencies.

[dbrownell@users.sourceforge.net: remove a couple now-needless EXPERIMENTAL dependencies too]
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |   45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN drivers/spi/Kconfig~spi-kconfig-simplifications drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-kconfig-simplifications
+++ a/drivers/spi/Kconfig
@@ -49,25 +49,26 @@ config SPI_MASTER
 	  controller and the protocol drivers for the SPI slave chips
 	  that are connected.
 
+if SPI_MASTER
+
 comment "SPI Master Controller Drivers"
-	depends on SPI_MASTER
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
-	depends on (ARCH_AT91 || AVR32) && SPI_MASTER
+	depends on (ARCH_AT91 || AVR32)
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
 	  many AT32 (AVR32) and AT91 (ARM) chips.
 
 config SPI_BFIN
 	tristate "SPI controller driver for ADI Blackfin5xx"
-	depends on SPI_MASTER && BLACKFIN
+	depends on BLACKFIN
 	help
 	  This is the SPI controller master driver for Blackfin 5xx processor.
 
 config SPI_AU1550
 	tristate "Au1550/Au12x0 SPI Controller"
-	depends on SPI_MASTER && (SOC_AU1550 || SOC_AU1200) && EXPERIMENTAL
+	depends on (SOC_AU1550 || SOC_AU1200) && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  If you say yes to this option, support will be included for the
@@ -78,7 +79,6 @@ config SPI_AU1550
 
 config SPI_BITBANG
 	tristate "Bitbanging SPI master"
-	depends on SPI_MASTER && EXPERIMENTAL
 	help
 	  With a few GPIO pins, your system can bitbang the SPI protocol.
 	  Select this to get SPI support through I/O pins (GPIO, parallel
@@ -92,7 +92,7 @@ config SPI_BITBANG
 
 config SPI_BUTTERFLY
 	tristate "Parallel port adapter for AVR Butterfly (DEVELOPMENT)"
-	depends on SPI_MASTER && PARPORT && EXPERIMENTAL
+	depends on PARPORT
 	select SPI_BITBANG
 	help
 	  This uses a custom parallel port cable to connect to an AVR
@@ -102,14 +102,14 @@ config SPI_BUTTERFLY
 
 config SPI_IMX
 	tristate "Freescale iMX SPI controller"
-	depends on SPI_MASTER && ARCH_IMX && EXPERIMENTAL
+	depends on ARCH_IMX && EXPERIMENTAL
 	help
 	  This enables using the Freescale iMX SPI controller in master
 	  mode.
 
 config SPI_LM70_LLP
 	tristate "Parallel port adapter for LM70 eval board (DEVELOPMENT)"
-	depends on SPI_MASTER && PARPORT && EXPERIMENTAL
+	depends on PARPORT && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  This driver supports the NS LM70 LLP Evaluation Board,
@@ -118,14 +118,14 @@ config SPI_LM70_LLP
 
 config SPI_MPC52xx_PSC
 	tristate "Freescale MPC52xx PSC SPI controller"
-	depends on SPI_MASTER && PPC_MPC52xx && EXPERIMENTAL
+	depends on PPC_MPC52xx && EXPERIMENTAL
 	help
 	  This enables using the Freescale MPC52xx Programmable Serial
 	  Controller in master SPI mode.
 
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
-	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
+	depends on (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
 	help
 	  This enables using the Freescale MPC83xx and QUICC Engine SPI
 	  controllers in master mode.
@@ -137,21 +137,21 @@ config SPI_MPC83xx
 
 config SPI_OMAP_UWIRE
 	tristate "OMAP1 MicroWire"
-	depends on SPI_MASTER && ARCH_OMAP1
+	depends on ARCH_OMAP1
 	select SPI_BITBANG
 	help
 	  This hooks up to the MicroWire controller on OMAP1 chips.
 
 config SPI_OMAP24XX
 	tristate "McSPI driver for OMAP24xx/OMAP34xx"
-	depends on SPI_MASTER && (ARCH_OMAP24XX || ARCH_OMAP34XX)
+	depends on ARCH_OMAP24XX || ARCH_OMAP34XX
 	help
 	  SPI master controller for OMAP24xx/OMAP34xx Multichannel SPI
 	  (McSPI) modules.
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on SPI_MASTER && ARCH_PXA && EXPERIMENTAL
+	depends on ARCH_PXA && EXPERIMENTAL
 	select PXA_SSP
 	help
 	  This enables using a PXA2xx SSP port as a SPI master controller.
@@ -160,14 +160,14 @@ config SPI_PXA2XX
 
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
-	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	depends on ARCH_S3C2410 && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
 
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
-	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	depends on ARCH_S3C2410 && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs using
@@ -177,20 +177,20 @@ config SPI_S3C24XX_GPIO
 
 config SPI_SH_SCI
 	tristate "SuperH SCI SPI controller"
-	depends on SPI_MASTER && SUPERH
+	depends on SUPERH
 	select SPI_BITBANG
 	help
 	  SPI driver for SuperH SCI blocks.
 
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
-	depends on SPI_MASTER && GENERIC_GPIO && CPU_TX49XX
+	depends on GENERIC_GPIO && CPU_TX49XX
 	help
 	  SPI driver for Toshiba TXx9 MIPS SoCs
 
 config SPI_XILINX
 	tristate "Xilinx SPI controller"
-	depends on SPI_MASTER && XILINX_VIRTEX && EXPERIMENTAL
+	depends on XILINX_VIRTEX && EXPERIMENTAL
 	select SPI_BITBANG
 	help
 	  This exposes the SPI controller IP from the Xilinx EDK.
@@ -207,11 +207,10 @@ config SPI_XILINX
 # being probably the most widely used ones.
 #
 comment "SPI Protocol Masters"
-	depends on SPI_MASTER
 
 config SPI_AT25
 	tristate "SPI EEPROMs from most vendors"
-	depends on SPI_MASTER && SYSFS
+	depends on SYSFS
 	help
 	  Enable this driver to get read/write support to most SPI EEPROMs,
 	  after you configure the board init code to know about each eeprom
@@ -222,7 +221,7 @@ config SPI_AT25
 
 config SPI_SPIDEV
 	tristate "User mode SPI device driver support"
-	depends on SPI_MASTER && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  This supports user mode SPI protocol drivers.
 
@@ -231,7 +230,7 @@ config SPI_SPIDEV
 
 config SPI_TLE62X0
 	tristate "Infineon TLE62X0 (for power switching)"
-	depends on SPI_MASTER && SYSFS
+	depends on SYSFS
 	help
 	  SPI driver for Infineon TLE62X0 series line driver chips,
 	  such as the TLE6220, TLE6230 and TLE6240.  This provides a
@@ -242,6 +241,8 @@ config SPI_TLE62X0
 # Add new SPI protocol masters in alphabetical order above this line
 #
 
+endif # SPI_MASTER
+
 # (slave support would go here)
 
 endif # SPI
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
mn10300-replace-deprecated-topdir-with-newer-srctree.patch
linux-next.patch
macintosh-replace-deprecated-__initcall-with-device_initcall.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
spi-kconfig-simplifications.patch

