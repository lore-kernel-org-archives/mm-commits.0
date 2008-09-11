From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-dma-bugfixes.patch added to -mm tree
Date: Wed, 10 Sep 2008 19:25:21 -0700
Message-ID: <200809110225.m8B2PLF5006344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYIKCZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 22:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nforrester@whoi.edu, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, vernoninhand@gmail.com


The patch titled
     pxa2xx_spi: dma bugfixes
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-dma-bugfixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: dma bugfixes
From: Ned Forrester <nforrester@whoi.edu>

Fixes two DMA bugs in the pxa2xx_spi driver.  The first bug is in all
versions of this driver; the second was introduced in the 2.6.20 kernel,
and prevents using the driver with chips like m25p16 flash (which can
issue large DMA reads).

 1. Zero length transfers are permitted for use to insert timing,
    but pxa2xx_spi.c will fail if this is requested in DMA mode.
    Fixed by using programmed I/O (PIO) mode for such transfers.

 2. Transfers larger than 8191 are not permitted in DMA mode.  A
    test for length rejects all large transfers regardless of DMA
    or PIO mode.  Worked around by rejecting only large transfers
    with DMA mapped buffers, and forcing all other transfers
    larger than 8191 to use PIO mode.  A rate limited warning is
    issued for DMA transfers forced to PIO mode.

This patch should apply to all kernels back to and including 2.6.20;
it was test patched against 2.6.20.  An additional patch would be
required for older kernels, but those versions are very buggy anyway.

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Cc: Vernon Sauder <vernoninhand@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |   57 +++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-dma-bugfixes drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-dma-bugfixes
+++ a/drivers/spi/pxa2xx_spi.c
@@ -47,9 +47,10 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define MAX_BUSES 3
 
-#define DMA_INT_MASK (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
-#define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
+#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
+#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+#define IS_DMA_ALIGNED(x)	(((x) & 0x07) == 0)
+#define MAX_DMA_LEN		8191
 
 /*
  * for testing SSCR1 changes that require SSP restart, basically
@@ -887,14 +888,27 @@ static void pump_transfers(unsigned long
 			drv_data->cs_control(PXA2XX_CS_DEASSERT);
 	}
 
-	/* Check transfer length */
-	if (transfer->len > 8191)
-	{
-		dev_warn(&drv_data->pdev->dev, "pump_transfers: transfer "
-				"length greater than 8191\n");
-		message->status = -EINVAL;
-		giveback(drv_data);
-		return;
+	/* Check for transfers that need multiple DMA segments */
+	if (transfer->len > MAX_DMA_LEN && chip->enable_dma) {
+
+		/* reject already-mapped transfers; PIO won't always work */
+		if (message->is_dma_mapped
+				|| transfer->rx_dma || transfer->tx_dma) {
+			dev_err(&drv_data->pdev->dev,
+				"pump_transfers: mapped transfer length "
+				"of %lu is greater than %d\n",
+				transfer->len, MAX_DMA_LEN);
+			message->status = -EINVAL;
+			giveback(drv_data);
+			return;
+		}
+
+		/* warn ... we force this to PIO mode */
+		if (printk_ratelimit())
+			dev_warn(&message->spi->dev, "pump_transfers: "
+				"DMA disabled for transfer length %ld "
+				"greater than %d\n",
+				(long)drv_data->len, MAX_DMA_LEN);
 	}
 
 	/* Setup the transfer state based on the type of transfer */
@@ -962,7 +976,7 @@ static void pump_transfers(unsigned long
 							&dma_thresh))
 				if (printk_ratelimit())
 					dev_warn(&message->spi->dev,
-						"pump_transfer: "
+						"pump_transfers: "
 						"DMA burst size reduced to "
 						"match bits_per_word\n");
 		}
@@ -976,8 +990,23 @@ static void pump_transfers(unsigned long
 
 	message->state = RUNNING_STATE;
 
-	/* Try to map dma buffer and do a dma transfer if successful */
-	if ((drv_data->dma_mapped = map_dma_buffers(drv_data))) {
+	/* Try to map dma buffer and do a dma transfer if successful, but
+	 * only if the length is non-zero and less than MAX_DMA_LEN.
+	 *
+	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
+	 * of PIO instead.  Care is needed above because the transfer may
+	 * have have been passed with buffers that are already dma mapped.
+	 * A zero-length transfer in PIO mode will not try to write/read
+	 * to/from the buffers
+	 *
+	 * REVISIT large transfers are exactly where we most want to be
+	 * using DMA.  If this happens much, split those transfers into
+	 * multiple DMA segments rather than forcing PIO.
+	 */
+	drv_data->dma_mapped = 0;
+	if (drv_data->len > 0 && drv_data->len <= MAX_DMA_LEN)
+		drv_data->dma_mapped = map_dma_buffers(drv_data);
+	if (drv_data->dma_mapped) {
 
 		/* Ensure we have the correct interrupt handler */
 		drv_data->transfer_handler = dma_transfer;
_

Patches currently in -mm which might be from nforrester@whoi.edu are

pxa2xx_spi-chipselect-bugfixes.patch
pxa2xx_spi-dma-bugfixes.patch

