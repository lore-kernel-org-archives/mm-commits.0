From: akpm@linux-foundation.org
Subject: [merged] sdhci-of-reorganize-driver-to-support-additional-hardware.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:48 -0800
Message-ID: <200912182026.nBIKQmZb016555__35710.5341194712$1261168104$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568AbZLRU0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdhci-of: reorganize driver to support additional hardware
has been removed from the -mm tree.  Its filename was
     sdhci-of-reorganize-driver-to-support-additional-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci-of: reorganize driver to support additional hardware
From: Albert Herranz <albert_herranz@yahoo.es>

This patch breaks down sdhci-of into a core portion and a eSDHC portion,
clearing the path to easily support additional hardware using the same OF
driver.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig          |   26 ++++-
 drivers/mmc/host/Makefile         |    1 
 drivers/mmc/host/sdhci-of-core.c  |  140 +++------------------------
 drivers/mmc/host/sdhci-of-esdhc.c |  143 ++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-of.h       |   41 ++++++++
 5 files changed, 224 insertions(+), 127 deletions(-)

diff -puN drivers/mmc/host/Kconfig~sdhci-of-reorganize-driver-to-support-additional-hardware drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~sdhci-of-reorganize-driver-to-support-additional-hardware
+++ a/drivers/mmc/host/Kconfig
@@ -44,6 +44,19 @@ config MMC_SDHCI_IO_ACCESSORS
 	  This is silent Kconfig symbol that is selected by the drivers that
 	  need to overwrite SDHCI IO memory accessors.
 
+config MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+	bool
+	select MMC_SDHCI_IO_ACCESSORS
+	help
+	  This option is selected by drivers running on big endian hosts
+	  and performing I/O to a SDHCI controller through a bus that
+	  implements a hardware byte swapper using a 32-bit datum.
+	  This endian mapping mode is called "data invariance" and
+	  has the effect of scrambling the addresses and formats of data
+	  accessed in sizes other than the datum size.
+
+	  This is the case for the Freescale eSDHC.
+
 config MMC_SDHCI_PCI
 	tristate "SDHCI support on PCI bus"
 	depends on MMC_SDHCI && PCI
@@ -75,11 +88,18 @@ config MMC_RICOH_MMC
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
 	depends on MMC_SDHCI && PPC_OF
-	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the OF support for Secure Digital Host Controller
-	  Interfaces. So far, only the Freescale eSDHC controller is known
-	  to exist on OF platforms.
+	  Interfaces.
+
+	  If unsure, say N.
+
+config MMC_SDHCI_OF_ESDHC
+	bool "SDHCI OF support for the Freescale eSDHC controller"
+	depends on MMC_SDHCI_OF
+	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+	help
+	  This selects the Freescale eSDHC controller support.
 
 	  If unsure, say N.
 
diff -puN drivers/mmc/host/Makefile~sdhci-of-reorganize-driver-to-support-additional-hardware drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~sdhci-of-reorganize-driver-to-support-additional-hardware
+++ a/drivers/mmc/host/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_SDH_BFIN)		+= bfin_sdh.o
 
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 sdhci-of-y				:= sdhci-of-core.o
+sdhci-of-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff -puN drivers/mmc/host/sdhci-of-core.c~sdhci-of-reorganize-driver-to-support-additional-hardware drivers/mmc/host/sdhci-of-core.c
--- a/drivers/mmc/host/sdhci-of-core.c~sdhci-of-reorganize-driver-to-support-additional-hardware
+++ a/drivers/mmc/host/sdhci-of-core.c
@@ -22,62 +22,37 @@
 #include <linux/of_platform.h>
 #include <linux/mmc/host.h>
 #include <asm/machdep.h>
+#include "sdhci-of.h"
 #include "sdhci.h"
 
-struct sdhci_of_data {
-	unsigned int quirks;
-	struct sdhci_ops ops;
-};
-
-struct sdhci_of_host {
-	unsigned int clock;
-	u16 xfer_mode_shadow;
-};
+#ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
 
 /*
- * Ops and quirks for the Freescale eSDHC controller.
+ * These accessors are designed for big endian hosts doing I/O to
+ * little endian controllers incorporating a 32-bit hardware byte swapper.
  */
 
-#define ESDHC_DMA_SYSCTL	0x40c
-#define ESDHC_DMA_SNOOP		0x00000040
-
-#define ESDHC_SYSTEM_CONTROL	0x2c
-#define ESDHC_CLOCK_MASK	0x0000fff0
-#define ESDHC_PREDIV_SHIFT	8
-#define ESDHC_DIVIDER_SHIFT	4
-#define ESDHC_CLOCK_PEREN	0x00000004
-#define ESDHC_CLOCK_HCKEN	0x00000002
-#define ESDHC_CLOCK_IPGEN	0x00000001
-
-#define ESDHC_HOST_CONTROL_RES	0x05
-
-static u32 esdhc_readl(struct sdhci_host *host, int reg)
+u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg)
 {
 	return in_be32(host->ioaddr + reg);
 }
 
-static u16 esdhc_readw(struct sdhci_host *host, int reg)
+u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg)
 {
-	u16 ret;
-
-	if (unlikely(reg == SDHCI_HOST_VERSION))
-		ret = in_be16(host->ioaddr + reg);
-	else
-		ret = in_be16(host->ioaddr + (reg ^ 0x2));
-	return ret;
+	return in_be16(host->ioaddr + (reg ^ 0x2));
 }
 
-static u8 esdhc_readb(struct sdhci_host *host, int reg)
+u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg)
 {
 	return in_8(host->ioaddr + (reg ^ 0x3));
 }
 
-static void esdhc_writel(struct sdhci_host *host, u32 val, int reg)
+void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg)
 {
 	out_be32(host->ioaddr + reg, val);
 }
 
-static void esdhc_writew(struct sdhci_host *host, u16 val, int reg)
+void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
 {
 	struct sdhci_of_host *of_host = sdhci_priv(host);
 	int base = reg & ~0x3;
@@ -92,106 +67,21 @@ static void esdhc_writew(struct sdhci_ho
 		of_host->xfer_mode_shadow = val;
 		return;
 	case SDHCI_COMMAND:
-		esdhc_writel(host, val << 16 | of_host->xfer_mode_shadow,
-			     SDHCI_TRANSFER_MODE);
+		sdhci_be32bs_writel(host, val << 16 | of_host->xfer_mode_shadow,
+				    SDHCI_TRANSFER_MODE);
 		return;
-	case SDHCI_BLOCK_SIZE:
-		/*
-		 * Two last DMA bits are reserved, and first one is used for
-		 * non-standard blksz of 4096 bytes that we don't support
-		 * yet. So clear the DMA boundary bits.
-		 */
-		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
-		/* fall through */
 	}
 	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
 }
 
-static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
+void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
 {
 	int base = reg & ~0x3;
 	int shift = (reg & 0x3) * 8;
 
-	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
-	if (reg == SDHCI_HOST_CONTROL)
-		val &= ~ESDHC_HOST_CONTROL_RES;
-
 	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
 }
-
-static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
-{
-	int pre_div = 2;
-	int div = 1;
-
-	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
-		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN | ESDHC_CLOCK_MASK);
-
-	if (clock == 0)
-		goto out;
-
-	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
-		pre_div *= 2;
-
-	while (host->max_clk / pre_div / div > clock && div < 16)
-		div++;
-
-	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
-		clock, host->max_clk / pre_div / div);
-
-	pre_div >>= 1;
-	div--;
-
-	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
-		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
-		  div << ESDHC_DIVIDER_SHIFT | pre_div << ESDHC_PREDIV_SHIFT);
-	mdelay(100);
-out:
-	host->clock = clock;
-}
-
-static int esdhc_enable_dma(struct sdhci_host *host)
-{
-	setbits32(host->ioaddr + ESDHC_DMA_SYSCTL, ESDHC_DMA_SNOOP);
-	return 0;
-}
-
-static unsigned int esdhc_get_max_clock(struct sdhci_host *host)
-{
-	struct sdhci_of_host *of_host = sdhci_priv(host);
-
-	return of_host->clock;
-}
-
-static unsigned int esdhc_get_min_clock(struct sdhci_host *host)
-{
-	struct sdhci_of_host *of_host = sdhci_priv(host);
-
-	return of_host->clock / 256 / 16;
-}
-
-static struct sdhci_of_data sdhci_esdhc = {
-	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
-		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
-		  SDHCI_QUIRK_NO_BUSY_IRQ |
-		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
-		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
-		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
-		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
-		  SDHCI_QUIRK_NO_CARD_NO_RESET,
-	.ops = {
-		.readl = esdhc_readl,
-		.readw = esdhc_readw,
-		.readb = esdhc_readb,
-		.writel = esdhc_writel,
-		.writew = esdhc_writew,
-		.writeb = esdhc_writeb,
-		.set_clock = esdhc_set_clock,
-		.enable_dma = esdhc_enable_dma,
-		.get_max_clock = esdhc_get_max_clock,
-		.get_min_clock = esdhc_get_min_clock,
-	},
-};
+#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
 
 #ifdef CONFIG_PM
 
@@ -301,9 +191,11 @@ static int __devexit sdhci_of_remove(str
 }
 
 static const struct of_device_id sdhci_of_match[] = {
+#ifdef CONFIG_MMC_SDHCI_OF_ESDHC
 	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc, },
 	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
 	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc, },
+#endif
 	{ .compatible = "generic-sdhci", },
 	{},
 };
diff -puN /dev/null drivers/mmc/host/sdhci-of-esdhc.c
--- /dev/null
+++ a/drivers/mmc/host/sdhci-of-esdhc.c
@@ -0,0 +1,143 @@
+/*
+ * Freescale eSDHC controller driver.
+ *
+ * Copyright (c) 2007 Freescale Semiconductor, Inc.
+ * Copyright (c) 2009 MontaVista Software, Inc.
+ *
+ * Authors: Xiaobo Xie <X.Xie@freescale.com>
+ *	    Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/mmc/host.h>
+#include "sdhci-of.h"
+#include "sdhci.h"
+
+/*
+ * Ops and quirks for the Freescale eSDHC controller.
+ */
+
+#define ESDHC_DMA_SYSCTL	0x40c
+#define ESDHC_DMA_SNOOP		0x00000040
+
+#define ESDHC_SYSTEM_CONTROL	0x2c
+#define ESDHC_CLOCK_MASK	0x0000fff0
+#define ESDHC_PREDIV_SHIFT	8
+#define ESDHC_DIVIDER_SHIFT	4
+#define ESDHC_CLOCK_PEREN	0x00000004
+#define ESDHC_CLOCK_HCKEN	0x00000002
+#define ESDHC_CLOCK_IPGEN	0x00000001
+
+#define ESDHC_HOST_CONTROL_RES	0x05
+
+static u16 esdhc_readw(struct sdhci_host *host, int reg)
+{
+	u16 ret;
+
+	if (unlikely(reg == SDHCI_HOST_VERSION))
+		ret = in_be16(host->ioaddr + reg);
+	else
+		ret = sdhci_be32bs_readw(host, reg);
+	return ret;
+}
+
+static void esdhc_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	if (reg == SDHCI_BLOCK_SIZE) {
+		/*
+		 * Two last DMA bits are reserved, and first one is used for
+		 * non-standard blksz of 4096 bytes that we don't support
+		 * yet. So clear the DMA boundary bits.
+		 */
+		val &= ~SDHCI_MAKE_BLKSZ(0x7, 0);
+	}
+	sdhci_be32bs_writew(host, val, reg);
+}
+
+static void esdhc_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	/* Prevent SDHCI core from writing reserved bits (e.g. HISPD). */
+	if (reg == SDHCI_HOST_CONTROL)
+		val &= ~ESDHC_HOST_CONTROL_RES;
+	sdhci_be32bs_writeb(host, val, reg);
+}
+
+static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	int pre_div = 2;
+	int div = 1;
+
+	clrbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
+		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN | ESDHC_CLOCK_MASK);
+
+	if (clock == 0)
+		goto out;
+
+	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
+		pre_div *= 2;
+
+	while (host->max_clk / pre_div / div > clock && div < 16)
+		div++;
+
+	dev_dbg(mmc_dev(host->mmc), "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / pre_div / div);
+
+	pre_div >>= 1;
+	div--;
+
+	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
+		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
+		  div << ESDHC_DIVIDER_SHIFT | pre_div << ESDHC_PREDIV_SHIFT);
+	mdelay(100);
+out:
+	host->clock = clock;
+}
+
+static int esdhc_enable_dma(struct sdhci_host *host)
+{
+	setbits32(host->ioaddr + ESDHC_DMA_SYSCTL, ESDHC_DMA_SNOOP);
+	return 0;
+}
+
+static unsigned int esdhc_get_max_clock(struct sdhci_host *host)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+
+	return of_host->clock;
+}
+
+static unsigned int esdhc_get_min_clock(struct sdhci_host *host)
+{
+	struct sdhci_of_host *of_host = sdhci_priv(host);
+
+	return of_host->clock / 256 / 16;
+}
+
+struct sdhci_of_data sdhci_esdhc = {
+	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
+		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
+		  SDHCI_QUIRK_NO_BUSY_IRQ |
+		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
+		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
+		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
+		  SDHCI_QUIRK_NO_CARD_NO_RESET,
+	.ops = {
+		.readl = sdhci_be32bs_readl,
+		.readw = esdhc_readw,
+		.readb = sdhci_be32bs_readb,
+		.writel = sdhci_be32bs_writel,
+		.writew = esdhc_writew,
+		.writeb = esdhc_writeb,
+		.set_clock = esdhc_set_clock,
+		.enable_dma = esdhc_enable_dma,
+		.get_max_clock = esdhc_get_max_clock,
+		.get_min_clock = esdhc_get_min_clock,
+	},
+};
diff -puN /dev/null drivers/mmc/host/sdhci-of.h
--- /dev/null
+++ a/drivers/mmc/host/sdhci-of.h
@@ -0,0 +1,41 @@
+/*
+ * OpenFirmware bindings for Secure Digital Host Controller Interface.
+ *
+ * Copyright (c) 2007 Freescale Semiconductor, Inc.
+ * Copyright (c) 2009 MontaVista Software, Inc.
+ *
+ * Authors: Xiaobo Xie <X.Xie@freescale.com>
+ *	    Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#ifndef __SDHCI_OF_H
+#define __SDHCI_OF_H
+
+#include <linux/types.h>
+#include "sdhci.h"
+
+struct sdhci_of_data {
+	unsigned int quirks;
+	struct sdhci_ops ops;
+};
+
+struct sdhci_of_host {
+	unsigned int clock;
+	u16 xfer_mode_shadow;
+};
+
+extern u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg);
+extern u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg);
+extern u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg);
+extern void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg);
+extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
+extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
+
+extern struct sdhci_of_data sdhci_esdhc;
+
+#endif /* __SDHCI_OF_H */
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

sdio-recognize-io-card-without-powercycle.patch

