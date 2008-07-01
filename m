From: akpm@linux-foundation.org
Subject: + spi-au1550_spi-proper-platform-device.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:30:16 -0700
Message-ID: <200807010830.m618UG2s017483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbYGAIdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mano@roarinelk.homelinux.net, dbrownell@users.sourceforge.net, jan.nikitenko@gmail.com


The patch titled
     spi: au1550_spi: proper platform device
has been added to the -mm tree.  Its filename is
     spi-au1550_spi-proper-platform-device.patch

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
Subject: spi: au1550_spi: proper platform device
From: Manuel Lauss <mano@roarinelk.homelinux.net>

Remove the Au1550 resource table and instead extract MMIO/IRQ/DMA
resources from platform resource information like any well-behaved
platform driver.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/au1550_spi.c                  |  136 ++++++++++----------
 include/asm-mips/mach-au1x00/au1550_spi.h |    1 
 2 files changed, 73 insertions(+), 64 deletions(-)

diff -puN drivers/spi/au1550_spi.c~spi-au1550_spi-proper-platform-device drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-au1550_spi-proper-platform-device
+++ a/drivers/spi/au1550_spi.c
@@ -26,6 +26,7 @@
 #include <linux/errno.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/resource.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 #include <linux/dma-mapping.h>
@@ -81,6 +82,7 @@ struct au1550_spi {
 	struct spi_master *master;
 	struct device *dev;
 	struct au1550_spi_info *pdata;
+	struct resource *ioarea;
 };
 
 
@@ -96,6 +98,8 @@ static dbdev_tab_t au1550_spi_mem_dbdev 
 	.dev_intpolarity	= 0
 };
 
+static int ddma_memid;	/* id to above mem dma device */
+
 static void au1550_spi_bits_handlers_set(struct au1550_spi *hw, int bpw);
 
 
@@ -732,6 +736,7 @@ static int __init au1550_spi_probe(struc
 {
 	struct au1550_spi *hw;
 	struct spi_master *master;
+	struct resource *r;
 	int err = 0;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(struct au1550_spi));
@@ -753,76 +758,64 @@ static int __init au1550_spi_probe(struc
 		goto err_no_pdata;
 	}
 
-	platform_set_drvdata(pdev, hw);
-
-	init_completion(&hw->master_done);
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no IRQ\n");
+		err = -ENODEV;
+		goto err_no_iores;
+	}
+	hw->irq = r->start;
 
-	hw->bitbang.master = hw->master;
-	hw->bitbang.setup_transfer = au1550_spi_setupxfer;
-	hw->bitbang.chipselect = au1550_spi_chipsel;
-	hw->bitbang.master->setup = au1550_spi_setup;
-	hw->bitbang.txrx_bufs = au1550_spi_txrx_bufs;
+	hw->usedma = 0;
+	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (r) {
+		hw->dma_tx_id = r->start;
+		r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+		if (r) {
+			hw->dma_rx_id = r->start;
+			if (usedma && ddma_memid) {
+				if (pdev->dev.dma_mask == NULL)
+					dev_warn(&pdev->dev, "no dma mask\n");
+				else
+					hw->usedma = 1;
+			}
+		}
+	}
 
-	switch (hw->pdata->bus_num) {
-	case 0:
-		hw->irq = AU1550_PSC0_INT;
-		hw->regs = (volatile psc_spi_t *)PSC0_BASE_ADDR;
-		hw->dma_rx_id = DSCR_CMD0_PSC0_RX;
-		hw->dma_tx_id = DSCR_CMD0_PSC0_TX;
-		break;
-	case 1:
-		hw->irq = AU1550_PSC1_INT;
-		hw->regs = (volatile psc_spi_t *)PSC1_BASE_ADDR;
-		hw->dma_rx_id = DSCR_CMD0_PSC1_RX;
-		hw->dma_tx_id = DSCR_CMD0_PSC1_TX;
-		break;
-	case 2:
-		hw->irq = AU1550_PSC2_INT;
-		hw->regs = (volatile psc_spi_t *)PSC2_BASE_ADDR;
-		hw->dma_rx_id = DSCR_CMD0_PSC2_RX;
-		hw->dma_tx_id = DSCR_CMD0_PSC2_TX;
-		break;
-	case 3:
-		hw->irq = AU1550_PSC3_INT;
-		hw->regs = (volatile psc_spi_t *)PSC3_BASE_ADDR;
-		hw->dma_rx_id = DSCR_CMD0_PSC3_RX;
-		hw->dma_tx_id = DSCR_CMD0_PSC3_TX;
-		break;
-	default:
-		dev_err(&pdev->dev, "Wrong bus_num of SPI\n");
-		err = -ENOENT;
-		goto err_no_pdata;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no mmio resource\n");
+		err = -ENODEV;
+		goto err_no_iores;
 	}
 
-	if (request_mem_region((unsigned long)hw->regs, sizeof(psc_spi_t),
-			pdev->name) == NULL) {
+	hw->ioarea = request_mem_region(r->start, sizeof(psc_spi_t),
+					pdev->name);
+	if (!hw->ioarea) {
 		dev_err(&pdev->dev, "Cannot reserve iomem region\n");
 		err = -ENXIO;
 		goto err_no_iores;
 	}
 
-
-	if (usedma) {
-		if (pdev->dev.dma_mask == NULL)
-			dev_warn(&pdev->dev, "no dma mask\n");
-		else
-			hw->usedma = 1;
+	hw->regs = (psc_spi_t __iomem *)ioremap(r->start, sizeof(psc_spi_t));
+	if (!hw->regs) {
+		dev_err(&pdev->dev, "cannot ioremap\n");
+		err = -ENXIO;
+		goto err_ioremap;
 	}
 
-	if (hw->usedma) {
-		/*
-		 * create memory device with 8 bits dev_devwidth
-		 * needed for proper byte ordering to spi fifo
-		 */
-		int memid = au1xxx_ddma_add_device(&au1550_spi_mem_dbdev);
-		if (!memid) {
-			dev_err(&pdev->dev,
-				"Cannot create dma 8 bit mem device\n");
-			err = -ENXIO;
-			goto err_dma_add_dev;
-		}
+	platform_set_drvdata(pdev, hw);
+
+	init_completion(&hw->master_done);
+
+	hw->bitbang.master = hw->master;
+	hw->bitbang.setup_transfer = au1550_spi_setupxfer;
+	hw->bitbang.chipselect = au1550_spi_chipsel;
+	hw->bitbang.master->setup = au1550_spi_setup;
+	hw->bitbang.txrx_bufs = au1550_spi_txrx_bufs;
 
-		hw->dma_tx_ch = au1xxx_dbdma_chan_alloc(memid,
+	if (hw->usedma) {
+		hw->dma_tx_ch = au1xxx_dbdma_chan_alloc(ddma_memid,
 			hw->dma_tx_id, NULL, (void *)hw);
 		if (hw->dma_tx_ch == 0) {
 			dev_err(&pdev->dev,
@@ -841,7 +834,7 @@ static int __init au1550_spi_probe(struc
 
 
 		hw->dma_rx_ch = au1xxx_dbdma_chan_alloc(hw->dma_rx_id,
-			memid, NULL, (void *)hw);
+			ddma_memid, NULL, (void *)hw);
 		if (hw->dma_rx_ch == 0) {
 			dev_err(&pdev->dev,
 				"Cannot allocate rx dma channel\n");
@@ -874,7 +867,7 @@ static int __init au1550_spi_probe(struc
 		goto err_no_irq;
 	}
 
-	master->bus_num = hw->pdata->bus_num;
+	master->bus_num = pdev->id;
 	master->num_chipselect = hw->pdata->num_chipselect;
 
 	/*
@@ -924,8 +917,11 @@ err_no_txdma_descr:
 		au1xxx_dbdma_chan_free(hw->dma_tx_ch);
 
 err_no_txdma:
-err_dma_add_dev:
-	release_mem_region((unsigned long)hw->regs, sizeof(psc_spi_t));
+	iounmap((void __iomem *)hw->regs);
+
+err_ioremap:
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
 
 err_no_iores:
 err_no_pdata:
@@ -944,7 +940,9 @@ static int __exit au1550_spi_remove(stru
 
 	spi_bitbang_stop(&hw->bitbang);
 	free_irq(hw->irq, hw);
-	release_mem_region((unsigned long)hw->regs, sizeof(psc_spi_t));
+	iounmap((void __iomem *)hw->regs);
+	release_resource(hw->ioarea);
+	kfree(hw->ioarea);
 
 	if (hw->usedma) {
 		au1550_spi_dma_rxtmp_free(hw);
@@ -971,12 +969,24 @@ static struct platform_driver au1550_spi
 
 static int __init au1550_spi_init(void)
 {
+	/*
+	 * create memory device with 8 bits dev_devwidth
+	 * needed for proper byte ordering to spi fifo
+	 */
+	if (usedma) {
+		ddma_memid = au1xxx_ddma_add_device(&au1550_spi_mem_dbdev);
+		if (!ddma_memid)
+			printk(KERN_ERR "au1550-spi: cannot add memory"
+					"dbdma device\n");
+	}
 	return platform_driver_probe(&au1550_spi_drv, au1550_spi_probe);
 }
 module_init(au1550_spi_init);
 
 static void __exit au1550_spi_exit(void)
 {
+	if (usedma && ddma_memid)
+		au1xxx_ddma_del_device(ddma_memid);
 	platform_driver_unregister(&au1550_spi_drv);
 }
 module_exit(au1550_spi_exit);
diff -puN include/asm-mips/mach-au1x00/au1550_spi.h~spi-au1550_spi-proper-platform-device include/asm-mips/mach-au1x00/au1550_spi.h
--- a/include/asm-mips/mach-au1x00/au1550_spi.h~spi-au1550_spi-proper-platform-device
+++ a/include/asm-mips/mach-au1x00/au1550_spi.h
@@ -6,7 +6,6 @@
 #define _AU1550_SPI_H_
 
 struct au1550_spi_info {
-	s16 bus_num;		/* defines which PSC and IRQ to use */
 	u32 mainclk_hz;		/* main input clock frequency of PSC */
 	u16 num_chipselect;	/* number of chipselects supported */
 	void (*activate_cs)(struct au1550_spi_info *spi, int cs, int polarity);
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

au1xmmc-remove-custom-carddetect-poll-implementation.patch
spi-au1550_spi-proper-platform-device.patch

