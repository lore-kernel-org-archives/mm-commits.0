From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:28 -0700
Message-ID: <200904071906.n37J6Sgl010853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756919AbZDGUDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: unify duplicated code in dma read/write paths
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: unify duplicated code in dma read/write paths
From: Mike Frysinger <vapier.adi@gmail.com>

For DMA TX/RX operation in pump_transfers, DMA contriguration code in TX
and RX paths are almost the same.  This patch unify the duplicated DMA
code to make it more readable.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   47 ++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths
+++ a/drivers/spi/spi_bfin5xx.c
@@ -756,18 +756,19 @@ static void pump_transfers(unsigned long
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
+		unsigned long dma_start_addr;
+
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
 		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
+		set_dma_x_count(drv_data->dma_channel, drv_data->len);
 		if (width == CFG_SPI_WORDSIZE16) {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 2);
 			dma_width = WDSIZE_16;
 		} else {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 1);
 			dma_width = WDSIZE_8;
 		}
@@ -802,6 +803,7 @@ static void pump_transfers(unsigned long
 		}
 
 		/* In dma mode, rx or tx must be NULL in one transfer */
+		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
@@ -815,19 +817,9 @@ static void pump_transfers(unsigned long
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
-
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (WNR | RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->rx);
-			enable_dma(drv_data->dma_channel);
-
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAREAD | BIT_CTL_ENABLE));
+			dma_config |= WNR;
+			dma_start_addr = (unsigned long)drv_data->rx;
+			cr |= CFG_SPI_DMAREAD;
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
@@ -838,18 +830,21 @@ static void pump_transfers(unsigned long
 						(unsigned long) (drv_data->tx +
 						drv_data->len_in_bytes));
 
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->tx);
-			enable_dma(drv_data->dma_channel);
+			dma_start_addr = (unsigned long)drv_data->tx;
+			cr |= CFG_SPI_DMAWRITE;
+
+		} else
+			BUG();
+
+		/* start dma */
+		dma_enable_irq(drv_data->dma_channel);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		enable_dma(drv_data->dma_channel);
+
+		/* start SPI transfer */
+		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
 
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
-		}
 	} else {
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

