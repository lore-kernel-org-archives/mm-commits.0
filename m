From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-get-dma-working-for-spi-flashes.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:40 -0700
Message-ID: <200904071906.n37J6eiN010945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756140AbZDGUCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: get dma working for SPI flashes
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-get-dma-working-for-spi-flashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: get dma working for SPI flashes
From: Mike Frysinger <vapier.adi@gmail.com>

When using a BF533-STAMP here with a W25X10 SPI flash.  It works fine when
enable_dma is disabled, but doesn't work at all when turning DMA on.  We
get just 0xff bytes back when trying to read the device.

Change the code around so that it programs the SPI first and then enables
DMA, it seems to work a lot better ...

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-get-dma-working-for-spi-flashes drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-get-dma-working-for-spi-flashes
+++ a/drivers/spi/spi_bfin5xx.c
@@ -761,11 +761,10 @@ static void pump_transfers(unsigned long
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
-		unsigned long dma_start_addr;
+		unsigned long dma_start_addr, flags;
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -796,8 +795,7 @@ static void pump_transfers(unsigned long
 			enable_dma(drv_data->dma_channel);
 
 			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
+			write_CTRL(drv_data, cr | BIT_CTL_TIMOD_DMA_TX);
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -842,14 +840,22 @@ static void pump_transfers(unsigned long
 		} else
 			BUG();
 
-		/* start dma */
-		dma_enable_irq(drv_data->dma_channel);
-		set_dma_config(drv_data->dma_channel, dma_config);
+		/* oh man, here there be monsters ... and i dont mean the
+		 * fluffy cute ones from pixar, i mean the kind that'll eat
+		 * your data, kick your dog, and love it all.  do *not* try
+		 * and change these lines unless you (1) heavily test DMA
+		 * with SPI flashes on a loaded system (e.g. ping floods),
+		 * (2) know just how broken the DMA engine interaction with
+		 * the SPI peripheral is, and (3) have someone else to blame
+		 * when you screw it all up anyways.
+		 */
 		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		local_irq_save(flags);
 		enable_dma(drv_data->dma_channel);
