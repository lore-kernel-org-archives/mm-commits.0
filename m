From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:32 -0700
Message-ID: <200904071906.n37J6WBO010869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760383AbZDGTKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: add a few more DMA debug messages
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: add a few more DMA debug messages
From: Mike Frysinger <vapier.adi@gmail.com>

Because of DMA hardware issue, we were trying to use software workaround. 
This patch add some useful debug messages to help us debugging the DMA
code.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-a-few-more-dma-debug-messages drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-a-few-more-dma-debug-messages
+++ a/drivers/spi/spi_bfin5xx.c
@@ -559,9 +559,13 @@ static irqreturn_t dma_irq_handler(int i
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
 	u16 spistat = read_STAT(drv_data);
 
-	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
+	dev_dbg(&drv_data->pdev->dev,
+		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
+		dmastat, spistat);
+
 	clear_dma_irqstat(drv_data->dma_channel);
 
 	/* Wait for DMA to complete */
@@ -631,6 +635,7 @@ static void pump_transfers(unsigned long
 
 	 /* Handle for abort */
 	if (message->state == ERROR_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: we've hit an error\n");
 		message->status = -EIO;
 		giveback(drv_data);
 		return;
@@ -638,6 +643,7 @@ static void pump_transfers(unsigned long
 
 	/* Handle end of message */
 	if (message->state == DONE_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: all done!\n");
 		message->status = 0;
 		giveback(drv_data);
 		return;
@@ -645,6 +651,7 @@ static void pump_transfers(unsigned long
 
 	/* Delay if requested at end of transfer */
 	if (message->state == RUNNING_STATE) {
+		dev_dbg(&drv_data->pdev->dev, "transfer: still running ...\n");
 		previous = list_entry(transfer->transfer_list.prev,
 				      struct spi_transfer, transfer_list);
 		if (previous->delay_usecs)
@@ -806,7 +813,8 @@ static void pump_transfers(unsigned long
 		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
-			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
+			dev_dbg(&drv_data->pdev->dev, "doing DMA in to %p (size %zx)\n",
+				drv_data->rx, drv_data->len_in_bytes);
 
 			/* invalidate caches, if needed */
 			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

