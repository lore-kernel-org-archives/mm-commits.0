From: akpm@linux-foundation.org
Subject: - spi-spi_imx-updates.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:57 -0700
Message-ID: <200804282155.m3SLtvqv018171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935555AbYD1V4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.paterniani@swapp-eng.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_imx updates
has been removed from the -mm tree.  Its filename was
     spi-spi_imx-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_imx updates
From: Andrea Paterniani <a.paterniani@swapp-eng.it>

Updates to the i.MX SPI controller driver:

 1) Some comments changed and/or added.

 2) End of transfers is now managed on TXFIFO empty interrupt after the
    last write to TXFIFO.  This speeds interrupt execution by removing
    the wait for TXFIFO to become empty.  On TXFIFO empty interrupt the
    handler needs only to poll for the end of the ongoing transaction
    (SPI_CONTROL_XCH) to close the transfer.
     (2.1) Write only transfers are closed flushing RXFIFO.
     (2.2) Read transfers are closed reading trailing bytes from RXFIFO.
     (2.3) Read transfers where RXFIFO overrun occurred are closed by
           flushing RXFIFO and aborting the message.

 3) Fifos are now flushed via SPI disable after the end of ongoing
    transaction.

Signed-off-by: Andrea Paterniani <a.paterniani@swapp-eng.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |  223 ++++++++++++++++++++--------------------
 1 file changed, 114 insertions(+), 109 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-spi_imx-updates drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-spi_imx-updates
+++ a/drivers/spi/spi_imx.c
@@ -270,19 +270,26 @@ struct chip_data {
 
 static void pump_messages(struct work_struct *work);
 
-static int flush(struct driver_data *drv_data)
+static void flush(struct driver_data *drv_data)
 {
-	unsigned long limit = loops_per_jiffy << 1;
 	void __iomem *regs = drv_data->regs;
-	volatile u32 d;
+	u32 control;
 
 	dev_dbg(&drv_data->pdev->dev, "flush\n");
+
+	/* Wait for end of transaction */
 	do {
-		while (readl(regs + SPI_INT_STATUS) & SPI_STATUS_RR)
-			d = readl(regs + SPI_RXDATA);
-	} while ((readl(regs + SPI_CONTROL) & SPI_CONTROL_XCH) && limit--);
+		control = readl(regs + SPI_CONTROL);
+	} while (control & SPI_CONTROL_XCH);
+
+	/* Release chip select if requested, transfer delays are
+	   handled in pump_transfers */
+	if (drv_data->cs_change)
+		drv_data->cs_control(SPI_CS_DEASSERT);
 
-	return limit;
+	/* Disable SPI to flush FIFOs */
+	writel(control & ~SPI_CONTROL_SPIEN, regs + SPI_CONTROL);
+	writel(control, regs + SPI_CONTROL);
 }
 
 static void restore_state(struct driver_data *drv_data)
@@ -570,6 +577,7 @@ static void giveback(struct spi_message 
 	writel(0, regs + SPI_INT_STATUS);
 	writel(0, regs + SPI_DMA);
 
+	/* Unconditioned deselct */
 	drv_data->cs_control(SPI_CS_DEASSERT);
 
 	message->state = NULL;
@@ -592,13 +600,10 @@ static void dma_err_handler(int channel,
 	/* Disable both rx and tx dma channels */
 	imx_dma_disable(drv_data->rx_channel);
 	imx_dma_disable(drv_data->tx_channel);
-
-	if (flush(drv_data) == 0)
-		dev_err(&drv_data->pdev->dev,
-				"dma_err_handler - flush failed\n");
-
 	unmap_dma_buffers(drv_data);
 
+	flush(drv_data);
+
 	msg->state = ERROR_STATE;
 	tasklet_schedule(&drv_data->pump_transfers);
 }
@@ -612,8 +617,7 @@ static void dma_tx_handler(int channel, 
 	imx_dma_disable(channel);
 
 	/* Now waits for TX FIFO empty */
-	writel(readl(drv_data->regs + SPI_INT_STATUS) | SPI_INTEN_TE,
-			drv_data->regs + SPI_INT_STATUS);
+	writel(SPI_INTEN_TE, drv_data->regs + SPI_INT_STATUS);
 }
 
 static irqreturn_t dma_transfer(struct driver_data *drv_data)
@@ -621,19 +625,18 @@ static irqreturn_t dma_transfer(struct d
 	u32 status;
 	struct spi_message *msg = drv_data->cur_msg;
 	void __iomem *regs = drv_data->regs;
-	unsigned long limit;
 
 	status = readl(regs + SPI_INT_STATUS);
 
-	if ((status & SPI_INTEN_RO) && (status & SPI_STATUS_RO)) {
+	if ((status & (SPI_INTEN_RO | SPI_STATUS_RO))
+			== (SPI_INTEN_RO | SPI_STATUS_RO)) {
 		writel(status & ~SPI_INTEN, regs + SPI_INT_STATUS);
 
+		imx_dma_disable(drv_data->tx_channel);
 		imx_dma_disable(drv_data->rx_channel);
 		unmap_dma_buffers(drv_data);
 
-		if (flush(drv_data) == 0)
-			dev_err(&drv_data->pdev->dev,
-				"dma_transfer - flush failed\n");
+		flush(drv_data);
 
 		dev_warn(&drv_data->pdev->dev,
 				"dma_transfer - fifo overun\n");
@@ -649,20 +652,17 @@ static irqreturn_t dma_transfer(struct d
 
 		if (drv_data->rx) {
 			/* Wait end of transfer before read trailing data */
-			limit = loops_per_jiffy << 1;
-			while ((readl(regs + SPI_CONTROL) & SPI_CONTROL_XCH) &&
-					limit--);
-
-			if (limit == 0)
-				dev_err(&drv_data->pdev->dev,
-					"dma_transfer - end of tx failed\n");
-			else
-				dev_dbg(&drv_data->pdev->dev,
-					"dma_transfer - end of tx\n");
+			while (readl(regs + SPI_CONTROL) & SPI_CONTROL_XCH)
+				cpu_relax();
 
 			imx_dma_disable(drv_data->rx_channel);
 			unmap_dma_buffers(drv_data);
 
+			/* Release chip select if requested, transfer delays are
+			   handled in pump_transfers() */
+			if (drv_data->cs_change)
+				drv_data->cs_control(SPI_CS_DEASSERT);
+
 			/* Calculate number of trailing data and read them */
 			dev_dbg(&drv_data->pdev->dev,
 				"dma_transfer - test = 0x%08X\n",
@@ -676,19 +676,12 @@ static irqreturn_t dma_transfer(struct d
 			/* Write only transfer */
 			unmap_dma_buffers(drv_data);
 
-			if (flush(drv_data) == 0)
-				dev_err(&drv_data->pdev->dev,
-					"dma_transfer - flush failed\n");
+			flush(drv_data);
 		}
 
 		/* End of transfer, update total byte transfered */
 		msg->actual_length += drv_data->len;
 
-		/* Release chip select if requested, transfer delays are
-		   handled in pump_transfers() */
-		if (drv_data->cs_change)
-			drv_data->cs_control(SPI_CS_DEASSERT);
-
 		/* Move to next transfer */
 		msg->state = next_transfer(drv_data);
 
@@ -711,44 +704,43 @@ static irqreturn_t interrupt_wronly_tran
 
 	status = readl(regs + SPI_INT_STATUS);
 
-	while (status & SPI_STATUS_TH) {
+	if (status & SPI_INTEN_TE) {
+		/* TXFIFO Empty Interrupt on the last transfered word */
+		writel(status & ~SPI_INTEN, regs + SPI_INT_STATUS);
 		dev_dbg(&drv_data->pdev->dev,
-			"interrupt_wronly_transfer - status = 0x%08X\n", status);
+			"interrupt_wronly_transfer - end of tx\n");
 
-		/* Pump data */
-		if (write(drv_data)) {
-			writel(readl(regs + SPI_INT_STATUS) & ~SPI_INTEN,
-				regs + SPI_INT_STATUS);
+		flush(drv_data);
 
-			dev_dbg(&drv_data->pdev->dev,
-				"interrupt_wronly_transfer - end of tx\n");
+		/* Update total byte transfered */
+		msg->actual_length += drv_data->len;
 
-			if (flush(drv_data) == 0)
-				dev_err(&drv_data->pdev->dev,
-					"interrupt_wronly_transfer - "
-					"flush failed\n");
+		/* Move to next transfer */
+		msg->state = next_transfer(drv_data);
 
-			/* End of transfer, update total byte transfered */
-			msg->actual_length += drv_data->len;
+		/* Schedule transfer tasklet */
+		tasklet_schedule(&drv_data->pump_transfers);
 
-			/* Release chip select if requested, transfer delays are
-			   handled in pump_transfers */
-			if (drv_data->cs_change)
-				drv_data->cs_control(SPI_CS_DEASSERT);
+		return IRQ_HANDLED;
+	} else {
+		while (status & SPI_STATUS_TH) {
+			dev_dbg(&drv_data->pdev->dev,
+				"interrupt_wronly_transfer - status = 0x%08X\n",
+				status);
 
-			/* Move to next transfer */
-			msg->state = next_transfer(drv_data);
+			/* Pump data */
+			if (write(drv_data)) {
+				/* End of TXFIFO writes,
+				   now wait until TXFIFO is empty */
+				writel(SPI_INTEN_TE, regs + SPI_INT_STATUS);
+				return IRQ_HANDLED;
+			}
 
-			/* Schedule transfer tasklet */
-			tasklet_schedule(&drv_data->pump_transfers);
+			status = readl(regs + SPI_INT_STATUS);
 
-			return IRQ_HANDLED;
+			/* We did something */
+			handled = IRQ_HANDLED;
 		}
-
-		status = readl(regs + SPI_INT_STATUS);
-
-		/* We did something */
-		handled = IRQ_HANDLED;
 	}
 
 	return handled;
@@ -758,45 +750,31 @@ static irqreturn_t interrupt_transfer(st
 {
 	struct spi_message *msg = drv_data->cur_msg;
 	void __iomem *regs = drv_data->regs;
-	u32 status;
+	u32 status, control;
 	irqreturn_t handled = IRQ_NONE;
 	unsigned long limit;
 
 	status = readl(regs + SPI_INT_STATUS);
 
-	while (status & (SPI_STATUS_TH | SPI_STATUS_RO)) {
+	if (status & SPI_INTEN_TE) {
+		/* TXFIFO Empty Interrupt on the last transfered word */
+		writel(status & ~SPI_INTEN, regs + SPI_INT_STATUS);
 		dev_dbg(&drv_data->pdev->dev,
-			"interrupt_transfer - status = 0x%08X\n", status);
-
-		if (status & SPI_STATUS_RO) {
-			writel(readl(regs + SPI_INT_STATUS) & ~SPI_INTEN,
-				regs + SPI_INT_STATUS);
-
-			dev_warn(&drv_data->pdev->dev,
-				"interrupt_transfer - fifo overun\n"
-				"    data not yet written = %d\n"
-				"    data not yet read    = %d\n",
-				data_to_write(drv_data),
-				data_to_read(drv_data));
-
-			if (flush(drv_data) == 0)
-				dev_err(&drv_data->pdev->dev,
-					"interrupt_transfer - flush failed\n");
-
-			msg->state = ERROR_STATE;
-			tasklet_schedule(&drv_data->pump_transfers);
+			"interrupt_transfer - end of tx\n");
 
-			return IRQ_HANDLED;
-		}
-
-		/* Pump data */
-		read(drv_data);
-		if (write(drv_data)) {
-			writel(readl(regs + SPI_INT_STATUS) & ~SPI_INTEN,
-				regs + SPI_INT_STATUS);
+		if (msg->state == ERROR_STATE) {
+			/* RXFIFO overrun was detected and message aborted */
+			flush(drv_data);
+		} else {
+			/* Wait for end of transaction */
+			do {
+				control = readl(regs + SPI_CONTROL);
+			} while (control & SPI_CONTROL_XCH);
 
-			dev_dbg(&drv_data->pdev->dev,
-				"interrupt_transfer - end of tx\n");
+			/* Release chip select if requested, transfer delays are
+			   handled in pump_transfers */
+			if (drv_data->cs_change)
+				drv_data->cs_control(SPI_CS_DEASSERT);
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
@@ -810,27 +788,54 @@ static irqreturn_t interrupt_transfer(st
 				dev_dbg(&drv_data->pdev->dev,
 					"interrupt_transfer - end of rx\n");
 
-			/* End of transfer, update total byte transfered */
+			/* Update total byte transfered */
 			msg->actual_length += drv_data->len;
 
-			/* Release chip select if requested, transfer delays are
-			   handled in pump_transfers */
-			if (drv_data->cs_change)
-				drv_data->cs_control(SPI_CS_DEASSERT);
-
 			/* Move to next transfer */
 			msg->state = next_transfer(drv_data);
+		}
 
-			/* Schedule transfer tasklet */
-			tasklet_schedule(&drv_data->pump_transfers);
+		/* Schedule transfer tasklet */
+		tasklet_schedule(&drv_data->pump_transfers);
 
-			return IRQ_HANDLED;
-		}
+		return IRQ_HANDLED;
+	} else {
+		while (status & (SPI_STATUS_TH | SPI_STATUS_RO)) {
+			dev_dbg(&drv_data->pdev->dev,
+				"interrupt_transfer - status = 0x%08X\n",
+				status);
+
+			if (status & SPI_STATUS_RO) {
+				/* RXFIFO overrun, abort message end wait
+				   until TXFIFO is empty */
+				writel(SPI_INTEN_TE, regs + SPI_INT_STATUS);
+
+				dev_warn(&drv_data->pdev->dev,
+					"interrupt_transfer - fifo overun\n"
+					"    data not yet written = %d\n"
+					"    data not yet read    = %d\n",
+					data_to_write(drv_data),
+					data_to_read(drv_data));
+
+				msg->state = ERROR_STATE;
+
+				return IRQ_HANDLED;
+			}
 
-		status = readl(regs + SPI_INT_STATUS);
+			/* Pump data */
+			read(drv_data);
+			if (write(drv_data)) {
+				/* End of TXFIFO writes,
+				   now wait until TXFIFO is empty */
+				writel(SPI_INTEN_TE, regs + SPI_INT_STATUS);
+				return IRQ_HANDLED;
+			}
 
-		/* We did something */
-		handled = IRQ_HANDLED;
+			status = readl(regs + SPI_INT_STATUS);
+
+			/* We did something */
+			handled = IRQ_HANDLED;
+		}
 	}
 
 	return handled;
_

Patches currently in -mm which might be from a.paterniani@swapp-eng.it are

origin.patch

