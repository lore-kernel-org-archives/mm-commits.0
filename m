From: akpm@linux-foundation.org
Subject: [merged] omap4-mmc-driver-support-on-omap4.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:12 -0700
Message-ID: <200909231956.n8NJuC48004363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZIWUHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:07:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kishore.kadiyala@ti.com, Hiroshi.DOYU@nokia.com, jarkko.lavinen@nokia.com, linux-mmc@vger.kernel.org, linux@arm.linux.org.uk, madhu.cr@ti.com, sakari.ailus@maxwell.research.nokia.com


The patch titled
     omap4: mmc driver support on OMAP4
has been removed from the -mm tree.  Its filename was
     omap4-mmc-driver-support-on-omap4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap4: mmc driver support on OMAP4
From: "kishore kadiyala" <kishore.kadiyala@ti.com>

Add basic support for all 5 MMC controllers on OMAP4.

This patch doesn't include mmc-regulator support

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/devices.c          |   42 ++++++++++++++++++++---
 arch/arm/plat-omap/include/mach/irqs.h |    2 +
 arch/arm/plat-omap/include/mach/mmc.h  |    9 ++++
 drivers/mmc/host/Kconfig               |    6 +--
 drivers/mmc/host/omap_hsmmc.c          |   10 +++++
 5 files changed, 60 insertions(+), 9 deletions(-)

diff -puN arch/arm/mach-omap2/devices.c~omap4-mmc-driver-support-on-omap4 arch/arm/mach-omap2/devices.c
--- a/arch/arm/mach-omap2/devices.c~omap4-mmc-driver-support-on-omap4
+++ a/arch/arm/mach-omap2/devices.c
@@ -397,7 +397,7 @@ static inline void omap_init_sha1_md5(vo
 
 /*-------------------------------------------------------------------------*/
 
-#ifdef CONFIG_ARCH_OMAP3
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
 
 #define MMCHS_SYSCONFIG			0x0010
 #define MMCHS_SYSCONFIG_SWRESET		(1 << 1)
@@ -424,8 +424,8 @@ static struct platform_device dummy_pdev
  **/
 static void __init omap_hsmmc_reset(void)
 {
-	u32 i, nr_controllers = cpu_is_omap34xx() ? OMAP34XX_NR_MMC :
-		OMAP24XX_NR_MMC;
+	u32 i, nr_controllers = cpu_is_omap44xx() ? OMAP44XX_NR_MMC :
+		(cpu_is_omap34xx() ? OMAP34XX_NR_MMC : OMAP24XX_NR_MMC);
 
 	for (i = 0; i < nr_controllers; i++) {
 		u32 v, base = 0;
@@ -442,8 +442,21 @@ static void __init omap_hsmmc_reset(void
 		case 2:
 			base = OMAP3_MMC3_BASE;
 			break;
+		case 3:
+			if (!cpu_is_omap44xx())
+				return;
+			base = OMAP4_MMC4_BASE;
+			break;
+		case 4:
+			if (!cpu_is_omap44xx())
+				return;
+			base = OMAP4_MMC5_BASE;
+			break;
 		}
 
+		if (cpu_is_omap44xx())
+			base += OMAP4_MMC_REG_OFFSET;
+
 		dummy_pdev.id = i;
 		dev_set_name(&dummy_pdev.dev, "mmci-omap-hs.%d", i);
 		iclk = clk_get(dev, "ick");
@@ -581,11 +594,23 @@ void __init omap2_init_mmc(struct omap_m
 			irq = INT_24XX_MMC2_IRQ;
 			break;
 		case 2:
-			if (!cpu_is_omap34xx())
+			if (!cpu_is_omap44xx() && !cpu_is_omap34xx())
 				return;
 			base = OMAP3_MMC3_BASE;
 			irq = INT_34XX_MMC3_IRQ;
 			break;
+		case 3:
+			if (!cpu_is_omap44xx())
+				return;
+			base = OMAP4_MMC4_BASE + OMAP4_MMC_REG_OFFSET;
+			irq = INT_44XX_MMC4_IRQ;
+			break;
+		case 4:
+			if (!cpu_is_omap44xx())
+				return;
+			base = OMAP4_MMC5_BASE + OMAP4_MMC_REG_OFFSET;
+			irq = INT_44XX_MMC5_IRQ;
+			break;
 		default:
 			continue;
 		}
@@ -593,8 +618,15 @@ void __init omap2_init_mmc(struct omap_m
 		if (cpu_is_omap2420()) {
 			size = OMAP2420_MMC_SIZE;
 			name = "mmci-omap";
+		} else if (cpu_is_omap44xx()) {
+			if (i < 3) {
+				base += OMAP4_MMC_REG_OFFSET;
+				irq += IRQ_GIC_START;
+			}
+			size = OMAP4_HSMMC_SIZE;
+			name = "mmci-omap-hs";
 		} else {
-			size = HSMMC_SIZE;
+			size = OMAP3_HSMMC_SIZE;
 			name = "mmci-omap-hs";
 		}
 		omap_mmc_add(name, i, base, size, irq, mmc_data[i]);
diff -puN arch/arm/plat-omap/include/mach/irqs.h~omap4-mmc-driver-support-on-omap4 arch/arm/plat-omap/include/mach/irqs.h
--- a/arch/arm/plat-omap/include/mach/irqs.h~omap4-mmc-driver-support-on-omap4
+++ a/arch/arm/plat-omap/include/mach/irqs.h
@@ -503,6 +503,7 @@
 #define INT_44XX_FPKA_READY_IRQ	(50 + IRQ_GIC_START)
 #define INT_44XX_SHA1MD51_IRQ	(51 + IRQ_GIC_START)
 #define INT_44XX_RNG_IRQ	(52 + IRQ_GIC_START)
+#define INT_44XX_MMC5_IRQ	(59 + IRQ_GIC_START)
 #define INT_44XX_I2C3_IRQ	(61 + IRQ_GIC_START)
 #define INT_44XX_FPKA_ERROR_IRQ	(64 + IRQ_GIC_START)
 #define INT_44XX_PBIAS_IRQ	(75 + IRQ_GIC_START)
@@ -511,6 +512,7 @@
 #define INT_44XX_TLL_IRQ	(78 + IRQ_GIC_START)
 #define INT_44XX_PARTHASH_IRQ	(79 + IRQ_GIC_START)
 #define INT_44XX_MMC3_IRQ	(94 + IRQ_GIC_START)
+#define INT_44XX_MMC4_IRQ	(96 + IRQ_GIC_START)
 
 
 /* Max. 128 level 2 IRQs (OMAP1610), 192 GPIOs (OMAP730/850) and
diff -puN arch/arm/plat-omap/include/mach/mmc.h~omap4-mmc-driver-support-on-omap4 arch/arm/plat-omap/include/mach/mmc.h
--- a/arch/arm/plat-omap/include/mach/mmc.h~omap4-mmc-driver-support-on-omap4
+++ a/arch/arm/plat-omap/include/mach/mmc.h
@@ -25,11 +25,18 @@
 
 #define OMAP24XX_NR_MMC		2
 #define OMAP34XX_NR_MMC		3
+#define OMAP44XX_NR_MMC		5
 #define OMAP2420_MMC_SIZE	OMAP1_MMC_SIZE
-#define HSMMC_SIZE		0x200
+#define OMAP3_HSMMC_SIZE	0x200
+#define OMAP4_HSMMC_SIZE	0x1000
 #define OMAP2_MMC1_BASE		0x4809c000
 #define OMAP2_MMC2_BASE		0x480b4000
 #define OMAP3_MMC3_BASE		0x480ad000
+#define OMAP4_MMC4_BASE		0x480d1000
+#define OMAP4_MMC5_BASE		0x480d5000
+#define OMAP4_MMC_REG_OFFSET	0x100
+#define HSMMC5			(1 << 4)
+#define HSMMC4			(1 << 3)
 #define HSMMC3			(1 << 2)
 #define HSMMC2			(1 << 1)
 #define HSMMC1			(1 << 0)
diff -puN drivers/mmc/host/Kconfig~omap4-mmc-driver-support-on-omap4 drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~omap4-mmc-driver-support-on-omap4
+++ a/drivers/mmc/host/Kconfig
@@ -132,11 +132,11 @@ config MMC_OMAP
 
 config MMC_OMAP_HS
 	tristate "TI OMAP High Speed Multimedia Card Interface support"
-	depends on ARCH_OMAP2430 || ARCH_OMAP3
+	depends on ARCH_OMAP2430 || ARCH_OMAP3 || ARCH_OMAP4
 	help
 	  This selects the TI OMAP High Speed Multimedia card Interface.
-	  If you have an OMAP2430 or OMAP3 board with a Multimedia Card slot,
-	  say Y or M here.
+	  If you have an OMAP2430 or OMAP3 board or OMAP4 board with a
+	  Multimedia Card slot, say Y or M here.
 
 	  If unsure, say N.
 
diff -puN drivers/mmc/host/omap_hsmmc.c~omap4-mmc-driver-support-on-omap4 drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap4-mmc-driver-support-on-omap4
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -109,6 +109,8 @@
 #define OMAP_MMC1_DEVID		0
 #define OMAP_MMC2_DEVID		1
 #define OMAP_MMC3_DEVID		2
+#define OMAP_MMC4_DEVID		3
+#define OMAP_MMC5_DEVID		4
 
 #define MMC_TIMEOUT_MS		20
 #define OMAP_MMC_MASTER_CLOCK	96000000
@@ -1758,6 +1760,14 @@ static int __init omap_hsmmc_probe(struc
 		host->dma_line_tx = OMAP34XX_DMA_MMC3_TX;
 		host->dma_line_rx = OMAP34XX_DMA_MMC3_RX;
 		break;
+	case OMAP_MMC4_DEVID:
+		host->dma_line_tx = OMAP44XX_DMA_MMC4_TX;
+		host->dma_line_rx = OMAP44XX_DMA_MMC4_RX;
+		break;
+	case OMAP_MMC5_DEVID:
+		host->dma_line_tx = OMAP44XX_DMA_MMC5_TX;
+		host->dma_line_rx = OMAP44XX_DMA_MMC5_RX;
+		break;
 	default:
 		dev_err(mmc_dev(host->mmc), "Invalid MMC id\n");
 		goto err_irq;
_

Patches currently in -mm which might be from kishore.kadiyala@ti.com are

origin.patch

