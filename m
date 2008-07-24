From: akpm@linux-foundation.org
Subject: - spi-au1550_spi-improve-pio-transfer-mode.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:38 -0700
Message-ID: <200807242328.m6ONScTb011288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbYGXX2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: au1550_spi: improve pio transfer mode
has been removed from the -mm tree.  Its filename was
     spi-au1550_spi-improve-pio-transfer-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: au1550_spi: improve pio transfer mode
From: Jan Nikitenko <jan.nikitenko@gmail.com>

Improve PIO transfer mode of au1550 spi controller by continuing of spi
transfer, instead of aborting transfer when transmit underflow interrupt
occurrs.

Verified by oscilloscope that the spi clock pauses on trasmit underflow,
so transfer continuation is perfectly valid even though au1550 datasheet
says that on tx underflow zeroes will be transfered.

Also make some error messages more specific.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/au1550_spi.c |   69 ++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff -puN drivers/spi/au1550_spi.c~spi-au1550_spi-improve-pio-transfer-mode drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-au1550_spi-improve-pio-transfer-mode
+++ a/drivers/spi/au1550_spi.c
@@ -484,9 +484,13 @@ static irqreturn_t au1550_spi_dma_irq_ca
 		au1xxx_dbdma_reset(hw->dma_tx_ch);
 		au1550_spi_reset_fifos(hw);
 
-		dev_err(hw->dev,
-			"Unexpected SPI error: event=0x%x stat=0x%x!\n",
-			evnt, stat);
+		if (evnt == PSC_SPIEVNT_RO)
+			dev_err(hw->dev,
+				"dma transfer: receive FIFO overflow!\n");
+		else
+			dev_err(hw->dev,
+				"dma transfer: unexpected SPI error "
+				"(event=0x%x stat=0x%x)!\n", evnt, stat);
 
 		complete(&hw->master_done);
 		return IRQ_HANDLED;
@@ -596,17 +600,17 @@ static irqreturn_t au1550_spi_pio_irq_ca
 
 	if ((evnt & (PSC_SPIEVNT_MM | PSC_SPIEVNT_RO
 				| PSC_SPIEVNT_RU | PSC_SPIEVNT_TO
-				| PSC_SPIEVNT_TU | PSC_SPIEVNT_SD))
+				| PSC_SPIEVNT_SD))
 			!= 0) {
-		dev_err(hw->dev,
-			"Unexpected SPI error: event=0x%x stat=0x%x!\n",
-			evnt, stat);
 		/*
 		 * due to an error we consider transfer as done,
 		 * so mask all events until before next transfer start
 		 */
 		au1550_spi_mask_ack_all(hw);
 		au1550_spi_reset_fifos(hw);
+		dev_err(hw->dev,
+			"pio transfer: unexpected SPI error "
+			"(event=0x%x stat=0x%x)!\n", evnt, stat);
 		complete(&hw->master_done);
 		return IRQ_HANDLED;
 	}
@@ -620,27 +624,50 @@ static irqreturn_t au1550_spi_pio_irq_ca
 		stat = hw->regs->psc_spistat;
 		au_sync();
 
-		if ((stat & PSC_SPISTAT_RE) == 0 && hw->rx_count < hw->len) {
+		/*
+		 * Take care to not let the Rx FIFO overflow.
+		 *
+		 * We only write a byte if we have read one at least. Initially,
+		 * the write fifo is full, so we should read from the read fifo
+		 * first.
+		 * In case we miss a word from the read fifo, we should get a
+		 * RO event and should back out.
+		 */
+		if (!(stat & PSC_SPISTAT_RE) && hw->rx_count < hw->len) {
 			hw->rx_word(hw);
-			/* ack the receive request event */
-			hw->regs->psc_spievent = PSC_SPIEVNT_RR;
-			au_sync();
 			busy = 1;
-		}
 
-		if ((stat & PSC_SPISTAT_TF) == 0 && hw->tx_count < hw->len) {
-			hw->tx_word(hw);
-			/* ack the transmit request event */
-			hw->regs->psc_spievent = PSC_SPIEVNT_TR;
-			au_sync();
-			busy = 1;
+			if (!(stat & PSC_SPISTAT_TF) && hw->tx_count < hw->len)
+				hw->tx_word(hw);
 		}
 	} while (busy);
 
-	evnt = hw->regs->psc_spievent;
+	hw->regs->psc_spievent = PSC_SPIEVNT_RR | PSC_SPIEVNT_TR;
 	au_sync();
 
-	if (hw->rx_count >= hw->len || (evnt & PSC_SPIEVNT_MD) != 0) {
+	/*
+	 * Restart the SPI transmission in case of a transmit underflow.
+	 * This seems to work despite the notes in the Au1550 data book
+	 * of Figure 8-4 with flowchart for SPI master operation:
+	 *
+	 * """Note 1: An XFR Error Interrupt occurs, unless masked,
+	 * for any of the following events: Tx FIFO Underflow,
+	 * Rx FIFO Overflow, or Multiple-master Error
+	 *    Note 2: In case of a Tx Underflow Error, all zeroes are
+	 * transmitted."""
+	 *
+	 * By simply restarting the spi transfer on Tx Underflow Error,
+	 * we assume that spi transfer was paused instead of zeroes
+	 * transmittion mentioned in the Note 2 of Au1550 data book.
+	 */
+	if (evnt & PSC_SPIEVNT_TU) {
+		hw->regs->psc_spievent = PSC_SPIEVNT_TU | PSC_SPIEVNT_MD;
+		au_sync();
+		hw->regs->psc_spipcr = PSC_SPIPCR_MS;
+		au_sync();
+	}
+
+	if (hw->rx_count >= hw->len) {
 		/* transfer completed successfully */
 		au1550_spi_mask_ack_all(hw);
 		complete(&hw->master_done);
@@ -729,6 +756,8 @@ static void __init au1550_spi_setup_psc_
 		stat = hw->regs->psc_spistat;
 		au_sync();
 	} while ((stat & PSC_SPISTAT_DR) == 0);
+
+	au1550_spi_reset_fifos(hw);
 }
 
 
_

Patches currently in -mm which might be from jan.nikitenko@gmail.com are

origin.patch

