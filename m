From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:30 -0700
Message-ID: <200904071906.n37J6Ub0010864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760016AbZDGTLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: drop bogus cast and touchup dma label
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: drop bogus cast and touchup dma label
From: Mike Frysinger <vapier.adi@gmail.com>

Blackfin's related DMA callback API doesn't need void * cast, so drop it. 
And this driver is for all Blackfin processors not only for BF53x, we
update the DMA request label for more meaningful information.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1077,13 +1077,13 @@ static int setup(struct spi_device *spi)
 	 */
 	if (chip->enable_dma && !drv_data->dma_requested) {
 		/* register dma irq handler */
-		if (request_dma(drv_data->dma_channel, "BF53x_SPI_DMA") < 0) {
+		if (request_dma(drv_data->dma_channel, "BFIN_SPI_DMA") < 0) {
 			dev_dbg(&spi->dev,
 				"Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
 		if (set_dma_callback(drv_data->dma_channel,
-			(void *)dma_irq_handler, drv_data) < 0) {
+		    dma_irq_handler, drv_data) < 0) {
 			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

