From: akpm@linux-foundation.org
Subject: [merged] spi-omap2_mcspi-rxdma-bugfix.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:35:08 -0700
Message-ID: <200907302035.n6UKZ8H3007621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbZG3Uf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-eero.nurkkala@nokia.com, aaro.koskinen@nokia.com, dbrownell@users.sourceforge.net, juuso.oikarinen@nokia.com, mm-commits@vger.kernel.org


The patch titled
     spi: omap2_mcspi rxdma bugfix
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-rxdma-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: omap2_mcspi rxdma bugfix
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>

When data is read through DMA, the last element must be read separately
through the RX register.  It cannot be transferred by the DMA.  For
further details see e.g.  OMAP35x TRM (table 19-16).

Without the fix the driver causes extra clocks to be clocked to the bus
after DMA RX operations.  This can cause interesting behaviour with some
devices.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
[aaro.koskinen@nokia.com: Simplified the patch while keeping the idea.]
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-rxdma-bugfix drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-rxdma-bugfix
+++ a/drivers/spi/omap2_mcspi.c
@@ -272,7 +272,7 @@ omap2_mcspi_txrx_dma(struct spi_device *
 
 	if (rx != NULL) {
 		omap_set_dma_transfer_params(mcspi_dma->dma_rx_channel,
-				data_type, element_count, 1,
+				data_type, element_count - 1, 1,
 				OMAP_DMA_SYNC_ELEMENT,
 				mcspi_dma->dma_rx_sync_dev, 1);
 
@@ -303,6 +303,25 @@ omap2_mcspi_txrx_dma(struct spi_device *
 	if (rx != NULL) {
 		wait_for_completion(&mcspi_dma->dma_rx_completion);
 		dma_unmap_single(NULL, xfer->rx_dma, count, DMA_FROM_DEVICE);
+		omap2_mcspi_set_enable(spi, 0);
+		if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
+				& OMAP2_MCSPI_CHSTAT_RXS)) {
+			u32 w;
+
+			w = mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
+			if (word_len <= 8)
+				((u8 *)xfer->rx_buf)[element_count - 1] = w;
+			else if (word_len <= 16)
+				((u16 *)xfer->rx_buf)[element_count - 1] = w;
+			else /* word_len <= 32 */
+				((u32 *)xfer->rx_buf)[element_count - 1] = w;
+		} else {
+			dev_err(&spi->dev, "DMA RX last word empty");
+			count -= (word_len <= 8)  ? 1 :
+				 (word_len <= 16) ? 2 :
+			       /* word_len <= 32 */ 4;
+		}
+		omap2_mcspi_set_enable(spi, 1);
 	}
 	return count;
 }
_

Patches currently in -mm which might be from ext-eero.nurkkala@nokia.com are

origin.patch

