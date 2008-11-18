From: akpm@linux-foundation.org
Subject: + spi_imx-full-duplex-dma-corruption-bugfix.patch added to -mm tree
Date: Tue, 18 Nov 2008 14:14:16 -0800
Message-ID: <200811182214.mAIMEGLA018290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYKRWO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 17:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.paterniani@swapp-eng.it, dbrownell@users.sourceforge.net


The patch titled
     spi_imx: full duplex dma corruption bugfix
has been added to the -mm tree.  Its filename is
     spi_imx-full-duplex-dma-corruption-bugfix.patch

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
Subject: spi_imx: full duplex dma corruption bugfix
From: Andrea Paterniani <a.paterniani@swapp-eng.it>

Fix unsafe order in dma mapping operation: always flush data from the
cache *BEFORE* invalidating it, to allow full duplex transfers where the
same buffer may be used for both writes and reads.

Signed-off-by: Andrea Paterniani <a.paterniani@swapp-eng.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |   45 +++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi_imx-full-duplex-dma-corruption-bugfix drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi_imx-full-duplex-dma-corruption-bugfix
+++ a/drivers/spi/spi_imx.c
@@ -506,20 +506,6 @@ static int map_dma_buffers(struct driver
 	if (!IS_DMA_ALIGNED(drv_data->rx) || !IS_DMA_ALIGNED(drv_data->tx))
 		return -1;
 
-	/* NULL rx means write-only transfer and no map needed
-	   since rx DMA will not be used */
-	if (drv_data->rx) {
-		buf = drv_data->rx;
-		drv_data->rx_dma = dma_map_single(
-					dev,
-					buf,
-					drv_data->len,
-					DMA_FROM_DEVICE);
-		if (dma_mapping_error(dev, drv_data->rx_dma))
-			return -1;
-		drv_data->rx_dma_needs_unmap = 1;
-	}
-
 	if (drv_data->tx == NULL) {
 		/* Read only message --> use drv_data->dummy_dma_buf for dummy
 		   writes to achive reads */
@@ -533,18 +519,31 @@ static int map_dma_buffers(struct driver
 					buf,
 					drv_data->tx_map_len,
 					DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, drv_data->tx_dma)) {
-		if (drv_data->rx_dma) {
-			dma_unmap_single(dev,
-					drv_data->rx_dma,
-					drv_data->len,
-					DMA_FROM_DEVICE);
-			drv_data->rx_dma_needs_unmap = 0;
-		}
+	if (dma_mapping_error(dev, drv_data->tx_dma))
 		return -1;
-	}
 	drv_data->tx_dma_needs_unmap = 1;
 
+	/* NULL rx means write-only transfer and no map needed
+	 * since rx DMA will not be used */
+	if (drv_data->rx) {
+		buf = drv_data->rx;
+		drv_data->rx_dma = dma_map_single(dev,
+						buf,
+						drv_data->len,
+						DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev, drv_data->rx_dma)) {
+			if (drv_data->tx_dma) {
+				dma_unmap_single(dev,
+						drv_data->tx_dma,
+						drv_data->tx_map_len,
+						DMA_TO_DEVICE);
+				drv_data->tx_dma_needs_unmap = 0;
+			}
+			return -1;
+		}
+		drv_data->rx_dma_needs_unmap = 1;
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from a.paterniani@swapp-eng.it are

spi_imx-full-duplex-dma-corruption-bugfix.patch

