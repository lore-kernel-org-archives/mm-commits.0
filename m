From: akpm@linux-foundation.org
Subject: [to-be-updated] sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch removed from -mm tree
Date: Tue, 29 Sep 2009 15:57:54 -0700
Message-ID: <200909292257.n8TMvscD027199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZI2W6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org, matt@console-pimps.org, philipl@overt.org, philipp.zabel@gmail.com, pierre@ossman.eu, roberto.fogli


The patch titled
     sh: switch Migo-R to use the tmio MMC driver instead of SPI
has been removed from the -mm tree.  Its filename was
     sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: switch Migo-R to use the tmio MMC driver instead of SPI
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Allow tmio_mmc driver to be used on SuperH systems and add platform bindngs to
the SH7722 Migo-R platform.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <damm@opensource.se>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/mach-migor/setup.c |   48 ++++++++++++++++++++++------
 drivers/mmc/host/Kconfig          |    4 +-
 2 files changed, 41 insertions(+), 11 deletions(-)

diff -puN arch/sh/boards/mach-migor/setup.c~sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi arch/sh/boards/mach-migor/setup.c
--- a/arch/sh/boards/mach-migor/setup.c~sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi
+++ a/arch/sh/boards/mach-migor/setup.c
@@ -30,6 +30,8 @@
 #include <asm/sh_keysc.h>
 #include <mach/migor.h>
 #include <cpu/sh7722.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tmio.h>
 
 /* Address     IRQ  Size  Bus  Description
  * 0x00000000       64MB  16   NOR Flash (SP29PL256N)
@@ -390,17 +392,35 @@ static struct platform_device migor_ceu_
 	},
 };
 
-struct spi_gpio_platform_data sdcard_cn9_platform_data = {
-	.sck = GPIO_PTD0,
-	.mosi = GPIO_PTD1,
-	.miso = GPIO_PTD2,
-	.num_chipselect = 1,
+static struct resource sdhi_cn9_resources[] = {
+	[0] = {
+		.name	= "MMC",
+		.start	= 0x04ce0000,
+		.end	= 0x04ce01ff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 101,
+		.end	= 101,
+		.flags  = IORESOURCE_IRQ,
+	},
 };
 
-static struct platform_device sdcard_cn9_device = {
-	.name		= "spi_gpio",
+static struct tmio_mmc_data sdhi_cn9_driver_data = {
+	.hclk = 24000000,
+	.clk_name = "sdhi0",
+};
+
+struct mfd_cell sdhi_cn9_platform_data = {
+	.driver_data = &sdhi_cn9_driver_data,
+};
+
+static struct platform_device sdhi_cn9_device = {
+	.name		= "tmio-mmc",
+	.num_resources	= ARRAY_SIZE(sdhi_cn9_resources),
+	.resource	= sdhi_cn9_resources,
 	.dev	= {
-		.platform_data	= &sdcard_cn9_platform_data,
+		.platform_data	= &sdhi_cn9_platform_data,
 	},
 };
 
@@ -467,7 +487,7 @@ static struct platform_device *migor_dev
 	&migor_ceu_device,
 	&migor_nor_flash_device,
 	&migor_nand_flash_device,
-	&sdcard_cn9_device,
+	&sdhi_cn9_device,
 	&migor_camera[0],
 	&migor_camera[1],
 };
@@ -525,6 +545,16 @@ static int __init migor_devices_setup(vo
 	gpio_request(GPIO_PTA1, NULL);
 	gpio_direction_input(GPIO_PTA1);
 
+	/* SDHI */
+	gpio_request(GPIO_FN_SDHICD, NULL);
+	gpio_request(GPIO_FN_SDHIWP, NULL);
+	gpio_request(GPIO_FN_SDHID3, NULL);
+	gpio_request(GPIO_FN_SDHID2, NULL);
+	gpio_request(GPIO_FN_SDHID1, NULL);
+	gpio_request(GPIO_FN_SDHID0, NULL);
+	gpio_request(GPIO_FN_SDHICMD, NULL);
+	gpio_request(GPIO_FN_SDHICLK, NULL);
+
 	/* Touch Panel */
 	gpio_request(GPIO_FN_IRQ6, NULL);
 
diff -puN drivers/mmc/host/Kconfig~sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi
+++ a/drivers/mmc/host/Kconfig
@@ -288,10 +288,10 @@ config MMC_SDRICOH_CS
 
 config MMC_TMIO
 	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
-	depends on MFD_TMIO || MFD_ASIC3
+	depends on MFD_TMIO || MFD_ASIC3 || SUPERH
 	help
 	  This provides support for the SD/MMC cell found in TC6393XB,
-	  T7L66XB and also HTC ASIC3
+	  T7L66XB, HTC ASIC3 and also SuperH
 
 config MMC_CB710
 	tristate "ENE CB710 MMC/SD Interface support"
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch

