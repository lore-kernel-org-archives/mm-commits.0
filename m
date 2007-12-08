From: akpm@linux-foundation.org
Subject: - spi-spi_bfin-uses-platform-device-resources.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:14 -0800
Message-ID: <200712080129.lB81TETN013390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223AbXLHBj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin uses platform device resources
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin-uses-platform-device-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: spi_bfin uses platform device resources
From: Bryan Wu <bryan.wu@analog.com>

Update spi driver to support multi-ports by using platform resources; tested
on STAMP537+SPI_MMC, other boards need more testing.  Plus other minor
updates.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  124 ++++++++++++++++++++++++------------
 1 file changed, 83 insertions(+), 41 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-uses-platform-device-resources drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-uses-platform-device-resources
+++ a/drivers/spi/spi_bfin5xx.c
@@ -13,6 +13,8 @@
  *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
  *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
  *      July  17, 2007  add support for BF54x SPI0 controller (Bryan Wu)
+ *      July  30, 2007  add platfrom_resource interface to support multi-port
+ *                      SPI controller (Bryan Wu)
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
@@ -50,18 +52,25 @@
 #include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
 
-MODULE_AUTHOR("Bryan Wu, Luke Yang");
-MODULE_DESCRIPTION("Blackfin BF5xx SPI Contoller Driver");
+#define DRV_NAME	"bfin-spi"
+#define DRV_AUTHOR	"Bryan Wu, Luke Yang"
+#define DRV_DESC	"Blackfin BF5xx on-chip SPI Contoller Driver"
+#define DRV_VERSION	"1.0"
+
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
 
-#define DRV_NAME	"bfin-spi-master"
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
+static u32 spi_dma_ch;
+static u32 spi_regs_base;
+
 #define DEFINE_SPI_REG(reg, off) \
 static inline u16 read_##reg(void) \
-	{ return bfin_read16(SPI0_REGBASE + off); } \
+	{ return bfin_read16(spi_regs_base + off); } \
 static inline void write_##reg(u16 v) \
-	{bfin_write16(SPI0_REGBASE + off, v); }
+	{bfin_write16(spi_regs_base + off, v); }
 
 DEFINE_SPI_REG(CTRL, 0x00)
 DEFINE_SPI_REG(FLAG, 0x04)
@@ -573,10 +582,10 @@ static irqreturn_t dma_irq_handler(int i
 	struct chip_data *chip = drv_data->cur_chip;
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
-	clear_dma_irqstat(CH_SPI);
+	clear_dma_irqstat(spi_dma_ch);
 
 	/* Wait for DMA to complete */
-	while (get_dma_curr_irqstat(CH_SPI) & DMA_RUN)
+	while (get_dma_curr_irqstat(spi_dma_ch) & DMA_RUN)
 		continue;
 
 	/*
@@ -586,12 +595,12 @@ static irqreturn_t dma_irq_handler(int i
 	 * register until it goes low for 2 successive reads
 	 */
 	if (drv_data->tx != NULL) {
-		while ((bfin_read_SPI_STAT() & TXS) ||
-		       (bfin_read_SPI_STAT() & TXS))
+		while ((read_STAT() & TXS) ||
+		       (read_STAT() & TXS))
 			continue;
 	}
 
-	while (!(bfin_read_SPI_STAT() & SPIF))
+	while (!(read_STAT() & SPIF))
 		continue;
 
 	bfin_spi_disable(drv_data);
@@ -610,8 +619,8 @@ static irqreturn_t dma_irq_handler(int i
 	/* free the irq handler before next transfer */
 	dev_dbg(&drv_data->pdev->dev,
 		"disable dma channel irq%d\n",
-		CH_SPI);
-	dma_disable_irq(CH_SPI);
+		spi_dma_ch);
+	dma_disable_irq(spi_dma_ch);
 
 	return IRQ_HANDLED;
 }
@@ -726,19 +735,19 @@ static void pump_transfers(unsigned long
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
 		write_STAT(BIT_STAT_CLR);
-		disable_dma(CH_SPI);
-		clear_dma_irqstat(CH_SPI);
+		disable_dma(spi_dma_ch);
+		clear_dma_irqstat(spi_dma_ch);
 		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
 		if (width == CFG_SPI_WORDSIZE16) {
-			set_dma_x_count(CH_SPI, drv_data->len);
-			set_dma_x_modify(CH_SPI, 2);
+			set_dma_x_count(spi_dma_ch, drv_data->len);
+			set_dma_x_modify(spi_dma_ch, 2);
 			dma_width = WDSIZE_16;
 		} else {
-			set_dma_x_count(CH_SPI, drv_data->len);
-			set_dma_x_modify(CH_SPI, 1);
+			set_dma_x_count(spi_dma_ch, drv_data->len);
+			set_dma_x_modify(spi_dma_ch, 1);
 			dma_width = WDSIZE_8;
 		}
 
@@ -753,9 +762,10 @@ static void pump_transfers(unsigned long
 			/* no irq in autobuffer mode */
 			dma_config =
 			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
-			set_dma_config(CH_SPI, dma_config);
-			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
-			enable_dma(CH_SPI);
+			set_dma_config(spi_dma_ch, dma_config);
+			set_dma_start_addr(spi_dma_ch,
+					(unsigned long)drv_data->tx);
+			enable_dma(spi_dma_ch);
 			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
 				   (CFG_SPI_ENABLE << 14));
 
@@ -776,14 +786,15 @@ static void pump_transfers(unsigned long
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(0xFF);
 
-			set_dma_x_count(CH_SPI, drv_data->len);
+			set_dma_x_count(spi_dma_ch, drv_data->len);
 
 			/* start dma */
-			dma_enable_irq(CH_SPI);
+			dma_enable_irq(spi_dma_ch);
 			dma_config = (WNR | RESTART | dma_width | DI_EN);
-			set_dma_config(CH_SPI, dma_config);
-			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->rx);
-			enable_dma(CH_SPI);
+			set_dma_config(spi_dma_ch, dma_config);
+			set_dma_start_addr(spi_dma_ch,
+					(unsigned long)drv_data->rx);
+			enable_dma(spi_dma_ch);
 
 			cr |=
 			    CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE <<
@@ -794,11 +805,12 @@ static void pump_transfers(unsigned long
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
 			/* start dma */
-			dma_enable_irq(CH_SPI);
+			dma_enable_irq(spi_dma_ch);
 			dma_config = (RESTART | dma_width | DI_EN);
-			set_dma_config(CH_SPI, dma_config);
-			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
-			enable_dma(CH_SPI);
+			set_dma_config(spi_dma_ch, dma_config);
+			set_dma_start_addr(spi_dma_ch,
+					(unsigned long)drv_data->tx);
+			enable_dma(spi_dma_ch);
 
 			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
 				   (CFG_SPI_ENABLE << 14));
@@ -1034,17 +1046,17 @@ static int setup(struct spi_device *spi)
 	 */
 	if (chip->enable_dma && !dma_requested) {
 		/* register dma irq handler */
-		if (request_dma(CH_SPI, "BF53x_SPI_DMA") < 0) {
+		if (request_dma(spi_dma_ch, "BF53x_SPI_DMA") < 0) {
 			dev_dbg(&spi->dev,
 				"Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
-		if (set_dma_callback(CH_SPI, (void *)dma_irq_handler, drv_data)
-		    < 0) {
+		if (set_dma_callback(spi_dma_ch, (void *)dma_irq_handler,
+			drv_data) < 0) {
 			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
-		dma_disable_irq(CH_SPI);
+		dma_disable_irq(spi_dma_ch);
 		dma_requested = 1;
 	}
 
@@ -1215,6 +1227,7 @@ static int __init bfin5xx_spi_probe(stru
 	struct bfin5xx_spi_master *platform_info;
 	struct spi_master *master;
 	struct driver_data *drv_data = 0;
+	struct resource *res;
 	int status = 0;
 
 	platform_info = dev->platform_data;
@@ -1242,15 +1255,38 @@ static int __init bfin5xx_spi_probe(stru
 	master->setup = setup;
 	master->transfer = transfer;
 
+	/* Find and map our resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "Cannot get IORESOURCE_MEM\n");
+		status = -ENOENT;
+		goto out_error_get_res;
+	}
+
+	spi_regs_base = (u32) ioremap(res->start, (res->end - res->start)+1);
+	if (!spi_regs_base) {
+		dev_err(dev, "Cannot map IO\n");
+		status = -ENXIO;
+		goto out_error_ioremap;
+	}
+
+	spi_dma_ch = platform_get_irq(pdev, 0);
+	if (spi_dma_ch < 0) {
+		dev_err(dev, "No DMA channel specified\n");
+		status = -ENOENT;
+		goto out_error_no_dma_ch;
+	}
+
 	/* Initial and start queue */
 	status = init_queue(drv_data);
 	if (status != 0) {
-		dev_err(&pdev->dev, "problem initializing queue\n");
+		dev_err(dev, "problem initializing queue\n");
 		goto out_error_queue_alloc;
 	}
+
 	status = start_queue(drv_data);
 	if (status != 0) {
-		dev_err(&pdev->dev, "problem starting queue\n");
+		dev_err(dev, "problem starting queue\n");
 		goto out_error_queue_alloc;
 	}
 
@@ -1258,14 +1294,20 @@ static int __init bfin5xx_spi_probe(stru
 	platform_set_drvdata(pdev, drv_data);
 	status = spi_register_master(master);
 	if (status != 0) {
-		dev_err(&pdev->dev, "problem registering spi master\n");
+		dev_err(dev, "problem registering spi master\n");
 		goto out_error_queue_alloc;
 	}
-	dev_dbg(&pdev->dev, "controller probe successfully\n");
+
+	dev_info(dev, "%s, Version %s, regs_base @ 0x%08x\n",
+		DRV_DESC, DRV_VERSION, spi_regs_base);
 	return status;
 
 out_error_queue_alloc:
 	destroy_queue(drv_data);
+out_error_no_dma_ch:
+	iounmap((void *) spi_regs_base);
+out_error_ioremap:
+out_error_get_res:
 out_error:
 	spi_master_put(master);
 
@@ -1291,8 +1333,8 @@ static int __devexit bfin5xx_spi_remove(
 
 	/* Release DMA */
 	if (drv_data->master_info->enable_dma) {
-		if (dma_channel_active(CH_SPI))
-			free_dma(CH_SPI);
+		if (dma_channel_active(spi_dma_ch))
+			free_dma(spi_dma_ch);
 	}
 
 	/* Disconnect from the SPI framework */
@@ -1347,7 +1389,7 @@ static int bfin5xx_spi_resume(struct pla
 MODULE_ALIAS("bfin-spi-master");	/* for platform bus hotplug */
 static struct platform_driver bfin5xx_spi_driver = {
 	.driver	= {
-		.name	= "bfin-spi-master",
+		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
 	.suspend	= bfin5xx_spi_suspend,
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
