From: akpm@linux-foundation.org
Subject: [merged] spi-mcspi-support-for-omap4.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:39 -0700
Message-ID: <200909231958.n8NJwdY1009355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbZIWT7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rafiuddin.syed@ti.com, dbrownell@users.sourceforge.net, khilman@deeprootsystems.com, santosh.shilimkar@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     spi: McSPI support for OMAP4
has been removed from the -mm tree.  Its filename was
     spi-mcspi-support-for-omap4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: McSPI support for OMAP4
From: Syed Rafiuddin <rafiuddin.syed@ti.com>

tAdd adds McSPI support for OMAP4430 SDP platform.  All the base addresses
are changed between OMAP1/2/3 and OMAP4.  The fields of the resource
structures are filled at runtime to have McSPI support on OMAP4.

Signed-off-by: Syed Rafiuddin <rafiuddin.syed@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/devices.c |   29 +++++++++++++++++++++++------
 drivers/spi/omap2_mcspi.c     |   10 ++++++----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-omap2/devices.c~spi-mcspi-support-for-omap4 arch/arm/mach-omap2/devices.c
--- a/arch/arm/mach-omap2/devices.c~spi-mcspi-support-for-omap4
+++ a/arch/arm/mach-omap2/devices.c
@@ -257,6 +257,11 @@ static inline void omap_init_sti(void) {
 #define OMAP2_MCSPI3_BASE		0x480b8000
 #define OMAP2_MCSPI4_BASE		0x480ba000
 
+#define OMAP4_MCSPI1_BASE		0x48098100
+#define OMAP4_MCSPI2_BASE		0x4809a100
+#define OMAP4_MCSPI3_BASE		0x480b8100
+#define OMAP4_MCSPI4_BASE		0x480ba100
+
 static struct omap2_mcspi_platform_config omap2_mcspi1_config = {
 	.num_cs		= 4,
 };
@@ -301,7 +306,8 @@ static struct platform_device omap2_mcsp
 	},
 };
 
-#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3)
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3) || \
+	defined(CONFIG_ARCH_OMAP4)
 static struct omap2_mcspi_platform_config omap2_mcspi3_config = {
 	.num_cs		= 2,
 };
@@ -325,7 +331,7 @@ static struct platform_device omap2_mcsp
 };
 #endif
 
-#ifdef CONFIG_ARCH_OMAP3
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
 static struct omap2_mcspi_platform_config omap2_mcspi4_config = {
 	.num_cs		= 1,
 };
@@ -351,14 +357,25 @@ static struct platform_device omap2_mcsp
 
 static void omap_init_mcspi(void)
 {
+	if (cpu_is_omap44xx()) {
+		omap2_mcspi1_resources[0].start	= OMAP4_MCSPI1_BASE;
+		omap2_mcspi1_resources[0].end	= OMAP4_MCSPI1_BASE + 0xff;
+		omap2_mcspi2_resources[0].start	= OMAP4_MCSPI2_BASE;
+		omap2_mcspi2_resources[0].end	= OMAP4_MCSPI2_BASE + 0xff;
+		omap2_mcspi3_resources[0].start	= OMAP4_MCSPI3_BASE;
+		omap2_mcspi3_resources[0].end	= OMAP4_MCSPI3_BASE + 0xff;
+		omap2_mcspi4_resources[0].start	= OMAP4_MCSPI4_BASE;
+		omap2_mcspi4_resources[0].end	= OMAP4_MCSPI4_BASE + 0xff;
+	}
 	platform_device_register(&omap2_mcspi1);
 	platform_device_register(&omap2_mcspi2);
-#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3)
-	if (cpu_is_omap2430() || cpu_is_omap343x())
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3) || \
+	defined(CONFIG_ARCH_OMAP4)
+	if (cpu_is_omap2430() || cpu_is_omap343x() || cpu_is_omap44xx())
 		platform_device_register(&omap2_mcspi3);
 #endif
-#ifdef CONFIG_ARCH_OMAP3
-	if (cpu_is_omap343x())
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
+	if (cpu_is_omap343x() || cpu_is_omap44xx())
 		platform_device_register(&omap2_mcspi4);
 #endif
 }
diff -puN drivers/spi/omap2_mcspi.c~spi-mcspi-support-for-omap4 drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-mcspi-support-for-omap4
+++ a/drivers/spi/omap2_mcspi.c
@@ -1014,7 +1014,8 @@ static u8 __initdata spi2_txdma_id[] = {
 	OMAP24XX_DMA_SPI2_TX1,
 };
 
-#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP34XX)
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP34XX) \
+	|| defined(CONFIG_ARCH_OMAP4)
 static u8 __initdata spi3_rxdma_id[] = {
 	OMAP24XX_DMA_SPI3_RX0,
 	OMAP24XX_DMA_SPI3_RX1,
@@ -1026,7 +1027,7 @@ static u8 __initdata spi3_txdma_id[] = {
 };
 #endif
 
-#ifdef CONFIG_ARCH_OMAP3
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
 static u8 __initdata spi4_rxdma_id[] = {
 	OMAP34XX_DMA_SPI4_RX0,
 };
@@ -1056,14 +1057,15 @@ static int __init omap2_mcspi_probe(stru
 		txdma_id = spi2_txdma_id;
 		num_chipselect = 2;
 		break;
-#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3)
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3) \
+	|| defined(CONFIG_ARCH_OMAP4)
 	case 3:
 		rxdma_id = spi3_rxdma_id;
 		txdma_id = spi3_txdma_id;
 		num_chipselect = 2;
 		break;
 #endif
-#ifdef CONFIG_ARCH_OMAP3
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
 	case 4:
 		rxdma_id = spi4_rxdma_id;
 		txdma_id = spi4_txdma_id;
_

Patches currently in -mm which might be from rafiuddin.syed@ti.com are

origin.patch

