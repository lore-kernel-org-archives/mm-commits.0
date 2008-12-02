From: akpm@linux-foundation.org
Subject: - spi-au1550_spi-full-duplex-dma-fix.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:38 -0800
Message-ID: <200812021838.mB2Iccih007047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbYLBSin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: au1550_spi full duplex dma fix
has been removed from the -mm tree.  Its filename was
     spi-au1550_spi-full-duplex-dma-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: au1550_spi full duplex dma fix
From: Jan Nikitenko <jan.nikitenko@gmail.com>

Fix unsafe order in dma mapping operation: always flush data from the
cache *BEFORE* invalidating it, to allow full duplex transfers where the
same buffer may be used for both writes and reads.  Tested with mmc-spi.

Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/au1550_spi.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/spi/au1550_spi.c~spi-au1550_spi-full-duplex-dma-fix drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-au1550_spi-full-duplex-dma-fix
+++ a/drivers/spi/au1550_spi.c
@@ -369,10 +369,23 @@ static int au1550_spi_dma_txrxb(struct s
 	dma_rx_addr = t->rx_dma;
 
 	/*
-	 * check if buffers are already dma mapped, map them otherwise
+	 * check if buffers are already dma mapped, map them otherwise:
+	 * - first map the TX buffer, so cache data gets written to memory
+	 * - then map the RX buffer, so that cache entries (with
+	 *   soon-to-be-stale data) get removed
 	 * use rx buffer in place of tx if tx buffer was not provided
 	 * use temp rx buffer (preallocated or realloc to fit) for rx dma
 	 */
+	if (t->tx_buf) {
+		if (t->tx_dma == 0) {	/* if DMA_ADDR_INVALID, map it */
+			dma_tx_addr = dma_map_single(hw->dev,
+					(void *)t->tx_buf,
+					t->len, DMA_TO_DEVICE);
+			if (dma_mapping_error(hw->dev, dma_tx_addr))
+				dev_err(hw->dev, "tx dma map error\n");
+		}
+	}
+
 	if (t->rx_buf) {
 		if (t->rx_dma == 0) {	/* if DMA_ADDR_INVALID, map it */
 			dma_rx_addr = dma_map_single(hw->dev,
@@ -396,15 +409,8 @@ static int au1550_spi_dma_txrxb(struct s
 		dma_sync_single_for_device(hw->dev, dma_rx_addr,
 			t->len, DMA_FROM_DEVICE);
 	}
-	if (t->tx_buf) {
-		if (t->tx_dma == 0) {	/* if DMA_ADDR_INVALID, map it */
-			dma_tx_addr = dma_map_single(hw->dev,
-					(void *)t->tx_buf,
-					t->len, DMA_TO_DEVICE);
-			if (dma_mapping_error(hw->dev, dma_tx_addr))
-				dev_err(hw->dev, "tx dma map error\n");
-		}
-	} else {
+
+	if (!t->tx_buf) {
 		dma_sync_single_for_device(hw->dev, dma_rx_addr,
 				t->len, DMA_BIDIRECTIONAL);
 		hw->tx = hw->rx;
_

Patches currently in -mm which might be from jan.nikitenko@gmail.com are


