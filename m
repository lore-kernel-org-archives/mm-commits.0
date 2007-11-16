From: akpm@linux-foundation.org
Subject: + atmel_spi-chain-dma-transfers.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:07:28 -0800
Message-ID: <200711160307.lAG37S9I029373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXKPDHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:07:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slipszi@gmail.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: chain DMA transfers
has been added to the -mm tree.  Its filename is
     atmel_spi-chain-dma-transfers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi: chain DMA transfers
From: "Silvester Erdeg" <slipszi@gmail.com>

Add support for chained transfers in the atmel_spi driver, letting the DMA
controller switch to the next buffer pair without CPU intervention.  This
reduced I/O latencies by about 2% in one bulk I/O test.  It should also help
work around several interrelated errata affecting chipselect 0 on at91rm9200
chips.

Almost all of the changes are in the reworked atmel_spi_next_xfer() function. 
That's now called with the driver in one of three states:

 1. It isn't transferring anything (in which case the first transfer
    of the current message is going to be sent)
 2. It has finished transfering a non-chainable transfer (in which
    case it will go to the next transfer in the message)
 3. It has finished transfering a chained transfer (in which case the
    next transfer is already queued)

After that it will queue the next transfer if it can be chained.

Signed-off-by: Szilveszter Ordog <slipszi@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |  148 ++++++++++++++++++++++++++------------
 1 file changed, 102 insertions(+), 46 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-chain-dma-transfers drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-chain-dma-transfers
+++ a/drivers/spi/atmel_spi.c
@@ -51,7 +51,9 @@ struct atmel_spi {
 	u8			stopping;
 	struct list_head	queue;
 	struct spi_transfer	*current_transfer;
-	unsigned long		remaining_bytes;
+	unsigned long		current_remaining_bytes;
+	struct spi_transfer	*next_transfer;
+	unsigned long		next_remaining_bytes;
 
 	void			*buffer;
 	dma_addr_t		buffer_dma;
@@ -121,6 +123,48 @@ static void cs_deactivate(struct atmel_s
 		gpio_set_value(gpio, !active);
 }
 
+static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
+					struct spi_transfer *xfer)
+{
+	return msg->transfers.prev == &xfer->transfer_list;
+}
+
+static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
+{
+	return xfer->delay_usecs == 0 && !xfer->cs_change;
+}
+
+static void atmel_spi_next_xfer_data(struct spi_master *master,
+				struct spi_transfer *xfer,
+				dma_addr_t *tx_dma,
+				dma_addr_t *rx_dma,
+				u32 *plen)
+{
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	u32			len = *plen;
+
+	/* use scratch buffer only when rx or tx data is unspecified */
+	if (xfer->rx_buf)
+		*rx_dma = xfer->rx_dma + xfer->len - len;
+	else {
+		*rx_dma = as->buffer_dma;
+		if (len > BUFFER_SIZE)
+			len = BUFFER_SIZE;
+	}
+	if (xfer->tx_buf)
+		*tx_dma = xfer->tx_dma + xfer->len - len;
+	else {
+		*tx_dma = as->buffer_dma;
+		if (len > BUFFER_SIZE)
+			len = BUFFER_SIZE;
+		memset(as->buffer, 0, len);
+		dma_sync_single_for_device(&as->pdev->dev,
+				as->buffer_dma, len, DMA_TO_DEVICE);
+	}
+
+	*plen = len;
+}
+
 /*
  * Submit next transfer for DMA.
  * lock is held, spi irq is blocked
@@ -130,53 +174,68 @@ static void atmel_spi_next_xfer(struct s
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_transfer	*xfer;
-	u32			len;
+	u32			len, remaining, total;
 	dma_addr_t		tx_dma, rx_dma;
 
-	xfer = as->current_transfer;
-	if (!xfer || as->remaining_bytes == 0) {
-		if (xfer)
-			xfer = list_entry(xfer->transfer_list.next,
-					struct spi_transfer, transfer_list);
-		else
-			xfer = list_entry(msg->transfers.next,
-					struct spi_transfer, transfer_list);
-		as->remaining_bytes = xfer->len;
-		as->current_transfer = xfer;
+	if (!as->current_transfer)
+		xfer = list_entry(msg->transfers.next,
+				struct spi_transfer, transfer_list);
+	else if (!as->next_transfer)
+		xfer = list_entry(as->current_transfer->transfer_list.next,
+				struct spi_transfer, transfer_list);
+	else
+		xfer = NULL;
+
+	if (xfer) {
+		len = xfer->len;
+		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
+		remaining = xfer->len - len;
+
+		spi_writel(as, TPR, tx_dma);
+		spi_writel(as, RPR, rx_dma);
+
+		if (msg->spi->bits_per_word > 8)
+			len >>= 1;
+		spi_writel(as, TCR, len);
+		spi_writel(as, RCR, len);
+	} else {
+		xfer = as->next_transfer;
+		remaining = as->next_remaining_bytes;
 	}
 
-	len = as->remaining_bytes;
+	as->current_transfer = xfer;
+	as->current_remaining_bytes = remaining;
 
-	tx_dma = xfer->tx_dma + xfer->len - len;
-	rx_dma = xfer->rx_dma + xfer->len - len;
+	if (remaining > 0)
+		len = remaining;
+	else if (!atmel_spi_xfer_is_last(msg, xfer) &&
+		atmel_spi_xfer_can_be_chained(xfer)) {
+		xfer = list_entry(xfer->transfer_list.next,
+				struct spi_transfer, transfer_list);
+		len = xfer->len;
+	} else
+		xfer = NULL;
 
-	/* use scratch buffer only when rx or tx data is unspecified */
-	if (!xfer->rx_buf) {
-		rx_dma = as->buffer_dma;
-		if (len > BUFFER_SIZE)
-			len = BUFFER_SIZE;
-	}
-	if (!xfer->tx_buf) {
-		tx_dma = as->buffer_dma;
-		if (len > BUFFER_SIZE)
-			len = BUFFER_SIZE;
-		memset(as->buffer, 0, len);
-		dma_sync_single_for_device(&as->pdev->dev,
-				as->buffer_dma, len, DMA_TO_DEVICE);
-	}
+	as->next_transfer = xfer;
 
-	spi_writel(as, RPR, rx_dma);
-	spi_writel(as, TPR, tx_dma);
+	if (xfer) {
+		total = len;
+		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
+		as->next_remaining_bytes = total - len;
+
+		spi_writel(as, TNPR, tx_dma);
+		spi_writel(as, RNPR, rx_dma);
+
+		if (msg->spi->bits_per_word > 8)
+			len >>= 1;
+		spi_writel(as, TNCR, len);
+		spi_writel(as, RNCR, len);
+	} else {
+		spi_writel(as, TNCR, 0);
+		spi_writel(as, RNCR, 0);
+	}
 
-	as->remaining_bytes -= len;
-	if (msg->spi->bits_per_word > 8)
-		len >>= 1;
-
-	/* REVISIT: when xfer->delay_usecs == 0, the PDC "next transfer"
-	 * mechanism might help avoid the IRQ latency between transfers
-	 * (and improve the nCS0 errata handling on at91rm9200 chips)
-	 *
-	 * We're also waiting for ENDRX before we start the next
+	/* REVISIT: We're waiting for ENDRX before we start the next
 	 * transfer because we need to handle some difficult timing
 	 * issues otherwise. If we wait for ENDTX in one transfer and
 	 * then starts waiting for ENDRX in the next, it's difficult
@@ -186,8 +245,6 @@ static void atmel_spi_next_xfer(struct s
 	 *
 	 * It should be doable, though. Just not now...
 	 */
-	spi_writel(as, TNCR, 0);
-	spi_writel(as, RNCR, 0);
 	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
 
 	dev_dbg(&msg->spi->dev,
@@ -195,8 +252,6 @@ static void atmel_spi_next_xfer(struct s
 		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
 
-	spi_writel(as, TCR, len);
-	spi_writel(as, RCR, len);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
@@ -294,6 +349,7 @@ atmel_spi_msg_done(struct spi_master *ma
 	spin_lock(&as->lock);
 
 	as->current_transfer = NULL;
+	as->next_transfer = NULL;
 
 	/* continue if needed */
 	if (list_empty(&as->queue) || as->stopping)
@@ -377,7 +433,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 
 		spi_writel(as, IDR, pending);
 
-		if (as->remaining_bytes == 0) {
+		if (as->current_remaining_bytes == 0) {
 			msg->actual_length += xfer->len;
 
 			if (!msg->is_dma_mapped)
@@ -387,7 +443,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 			if (xfer->delay_usecs)
 				udelay(xfer->delay_usecs);
 
-			if (msg->transfers.prev == &xfer->transfer_list) {
+			if (atmel_spi_xfer_is_last(msg, xfer)) {
 				/* report completed message */
 				atmel_spi_msg_done(master, as, msg, 0,
 						xfer->cs_change);
_

Patches currently in -mm which might be from slipszi@gmail.com are

atmel_spi-chain-dma-transfers.patch
