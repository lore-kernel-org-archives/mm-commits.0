From: akpm@linux-foundation.org
Subject: + spi-au1550_spi-full-duplex-dma-fix.patch added to -mm tree
Date: Sat, 22 Nov 2008 13:13:28 -0800
Message-ID: <200811222113.mAMLDSF2022949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYKVVNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Nov 2008 16:13:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi: au1550_spi full duplex dma fix
has been added to the -mm tree.  Its filename is
     spi-au1550_spi-full-duplex-dma-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

spi-au1550_spi-full-duplex-dma-fix.patch

