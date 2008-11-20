From: akpm@linux-foundation.org
Subject: - pxa2xx_spi-bugfix-full-duplex-dma-data-corruption.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:36 -0800
Message-ID: <200811202042.mAKKga9I007005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbYKTUn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nforrester@whoi.edu, dbrownell@users.sourceforge.net, merrij3@rpi.edu, stable@kernel.org, vernoninhand@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: bugfix full duplex dma data corruption
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-bugfix-full-duplex-dma-data-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: bugfix full duplex dma data corruption
From: Ned Forrester <nforrester@whoi.edu>

Fixes a data corruption bug in pxa2xx_spi.c when operating in full duplex
mode with DMA and using buffers that overlap.

SPI transmit and receive buffers are allowed to be the same or to overlap.
 However, this driver fails if such overlap is attempted in DMA mode
because it maps the rx and tx buffers in the wrong order.  By mapping
DMA_FROM_DEVICE (read) before DMA_TO_DEVICE (write), it invalidates the
cache before flushing it, thus discarding data which should have been
transmitted.

The patch corrects the order of mapping.  This bug exists in all versions
of pxa2xx_spi.c; similar bugs are in the drivers for two other SPI
controllers (au1500, imx).

A version of this patch has been tested on kernel 2.6.20 using
verification of loopback data with: random transfer length, random
bits-per-word, random positive offsets (both larger and smaller than
transfer length) between the start of the rx and tx buffers, and varying
clock rates.

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Cc: J. Scott Merritt <merrij3@rpi.edu>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-bugfix-full-duplex-dma-data-corruption drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-bugfix-full-duplex-dma-data-corruption
+++ a/drivers/spi/pxa2xx_spi.c
@@ -352,21 +352,21 @@ static int map_dma_buffers(struct driver
 	} else
 		drv_data->tx_map_len = drv_data->len;
 
-	/* Stream map the rx buffer */
-	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
-						drv_data->rx_map_len,
-						DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, drv_data->rx_dma))
-		return 0;
-
-	/* Stream map the tx buffer */
+	/* Stream map the tx buffer. Always do DMA_TO_DEVICE first
+	 * so we flush the cache *before* invalidating it, in case
+	 * the tx and rx buffers overlap.
+	 */
 	drv_data->tx_dma = dma_map_single(dev, drv_data->tx,
-						drv_data->tx_map_len,
-						DMA_TO_DEVICE);
+					drv_data->tx_map_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, drv_data->tx_dma))
+		return 0;
 
-	if (dma_mapping_error(dev, drv_data->tx_dma)) {
-		dma_unmap_single(dev, drv_data->rx_dma,
+	/* Stream map the rx buffer */
+	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
 					drv_data->rx_map_len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, drv_data->rx_dma)) {
+		dma_unmap_single(dev, drv_data->tx_dma,
+					drv_data->tx_map_len, DMA_TO_DEVICE);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from nforrester@whoi.edu are

origin.patch

