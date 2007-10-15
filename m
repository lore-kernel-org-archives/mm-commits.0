From: akpm@linux-foundation.org
Subject: + spi-doesnt-need-class_device.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:10:01 -0700
Message-ID: <200710152310.l9FNA1nH030107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbXJOXKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyj@suse.de, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     spi doesn't need class_device
has been added to the -mm tree.  Its filename is
     spi-doesnt-need-class_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi doesn't need class_device
From: Tony Jones <tonyj@suse.de>

Make the SPI framework and drivers stop using class_device.  Update docs
accordingly ...  highlighting just which sysfs paths should be
"safe"/stable.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mmc_spi.c    |    4 ++--
 drivers/spi/atmel_spi.c       |   14 +++++++-------
 drivers/spi/mpc52xx_psc_spi.c |    2 +-
 drivers/spi/pxa2xx_spi.c      |    2 +-
 drivers/spi/spi_bfin5xx.c     |    2 +-
 drivers/spi/spi_imx.c         |    2 +-
 drivers/spi/spi_txx9.c        |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/mmc/host/mmc_spi.c~spi-doesnt-need-class_device drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-doesnt-need-class_device
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1280,8 +1280,8 @@ static int mmc_spi_probe(struct spi_devi
 	if (!host->data)
 		goto fail_nobuf1;
 
-	if (spi->master->cdev.dev->dma_mask) {
-		struct device	*dev = spi->master->cdev.dev;
+	if (spi->master->dev.parent->dma_mask) {
+		struct device	*dev = spi->master->dev.parent;
 
 		host->dma_dev = dev;
 		host->ones_dma = dma_map_single(dev, ones,
diff -puN drivers/spi/atmel_spi.c~spi-doesnt-need-class_device drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/atmel_spi.c
@@ -211,7 +211,7 @@ static void atmel_spi_next_message(struc
 	msg = list_entry(as->queue.next, struct spi_message, queue);
 	spi = msg->spi;
 
-	dev_dbg(master->cdev.dev, "start message %p for %s\n",
+	dev_dbg(master->dev.parent, "start message %p for %s\n",
 			msg, spi->dev.bus_id);
 
 	/* select chip if it's not still active */
@@ -266,10 +266,10 @@ static void atmel_spi_dma_unmap_xfer(str
 				     struct spi_transfer *xfer)
 {
 	if (xfer->tx_dma != INVALID_DMA_ADDRESS)
-		dma_unmap_single(master->cdev.dev, xfer->tx_dma,
+		dma_unmap_single(master->dev.parent, xfer->tx_dma,
 				 xfer->len, DMA_TO_DEVICE);
 	if (xfer->rx_dma != INVALID_DMA_ADDRESS)
-		dma_unmap_single(master->cdev.dev, xfer->rx_dma,
+		dma_unmap_single(master->dev.parent, xfer->rx_dma,
 				 xfer->len, DMA_FROM_DEVICE);
 }
 
@@ -285,7 +285,7 @@ atmel_spi_msg_done(struct spi_master *ma
 	list_del(&msg->queue);
 	msg->status = status;
 
-	dev_dbg(master->cdev.dev,
+	dev_dbg(master->dev.parent,
 		"xfer complete: %u bytes transferred\n",
 		msg->actual_length);
 
@@ -348,7 +348,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 		if (xfer->delay_usecs)
 			udelay(xfer->delay_usecs);
 
-		dev_warn(master->cdev.dev, "fifo overrun (%u/%u remaining)\n",
+		dev_warn(master->dev.parent, "fifo overrun (%u/%u remaining)\n",
 			 spi_readl(as, TCR), spi_readl(as, RCR));
 
 		/*
@@ -363,7 +363,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 			if (spi_readl(as, SR) & SPI_BIT(TXEMPTY))
 				break;
 		if (!timeout)
-			dev_warn(master->cdev.dev,
+			dev_warn(master->dev.parent,
 				 "timeout waiting for TXEMPTY");
 		while (spi_readl(as, SR) & SPI_BIT(RDRF))
 			spi_readl(as, RDR);
@@ -526,7 +526,7 @@ static int atmel_spi_transfer(struct spi
 	struct atmel_spi	*as;
 	struct spi_transfer	*xfer;
 	unsigned long		flags;
-	struct device		*controller = spi->master->cdev.dev;
+	struct device		*controller = spi->master->dev.parent;
 
 	as = spi_master_get_devdata(spi->master);
 
diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-doesnt-need-class_device drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -503,7 +503,7 @@ static int __init mpc52xx_psc_spi_do_pro
 	INIT_LIST_HEAD(&mps->queue);
 
 	mps->workqueue = create_singlethread_workqueue(
-		master->cdev.dev->bus_id);
+		master->dev.parent->bus_id);
 	if (mps->workqueue == NULL) {
 		ret = -EBUSY;
 		goto free_irq;
diff -puN drivers/spi/pxa2xx_spi.c~spi-doesnt-need-class_device drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-doesnt-need-class_device
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1242,7 +1242,7 @@ static int __init init_queue(struct driv
 
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+					drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi_bfin5xx.c~spi-doesnt-need-class_device drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1106,7 +1106,7 @@ static inline int init_queue(struct driv
 	/* init messages workqueue */
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue =
-	    create_singlethread_workqueue(drv_data->master->cdev.dev->bus_id);
+	    create_singlethread_workqueue(drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi_imx.c~spi-doesnt-need-class_device drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_imx.c
@@ -1374,7 +1374,7 @@ static int __init init_queue(struct driv
 
 	INIT_WORK(&drv_data->work, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+					drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff -puN drivers/spi/spi_txx9.c~spi-doesnt-need-class_device drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-doesnt-need-class_device
+++ a/drivers/spi/spi_txx9.c
@@ -400,7 +400,7 @@ static int __init txx9spi_probe(struct p
 		goto exit;
 	}
 
-	c->workqueue = create_singlethread_workqueue(master->cdev.dev->bus_id);
+	c->workqueue = create_singlethread_workqueue(master->dev.parent->bus_id);
 	if (!c->workqueue)
 		goto exit;
 	c->last_chipselect = -1;
_

Patches currently in -mm which might be from tonyj@suse.de are

origin.patch
spi-doesnt-need-class_device.patch
