From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-resequence-dma-start-stop.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:51:15 -0700
Message-ID: <200710302251.l9UMpO0w032076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbXJ3Wvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin: resequence DMA start/stop
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-resequence-dma-start-stop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin: resequence DMA start/stop
From: Sonic Zhang <sonic.zhang@analog.com>

Set correct baud for spi mmc and enable SPI only after DMA is started.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-resequence-dma-start-stop drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-resequence-dma-start-stop
+++ a/drivers/spi/spi_bfin5xx.c
@@ -231,13 +231,13 @@ static int restore_state(struct driver_d
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	cs_deactive(drv_data, chip);
 	write_BAUD(drv_data, chip->baud);
 	chip->ctl_reg &= (~BIT_CTL_TIMOD);
 	chip->ctl_reg |= (chip->width << 8);
 	write_CTRL(drv_data, chip->ctl_reg);
 
 	bfin_spi_enable(drv_data);
+	cs_active(drv_data, chip);
 
 	if (ret)
 		dev_dbg(&drv_data->pdev->dev,
@@ -767,6 +767,7 @@ static void pump_transfers(unsigned long
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
+		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -789,9 +790,6 @@ static void pump_transfers(unsigned long
 			dev_dbg(&drv_data->pdev->dev,
 				"doing autobuffer DMA out.\n");
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_DMAWRITE));
-
 			/* no irq in autobuffer mode */
 			dma_config =
 			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
@@ -800,7 +798,13 @@ static void pump_transfers(unsigned long
 					(unsigned long)drv_data->tx);
 			enable_dma(drv_data->dma_channel);
 
-			/* just return here, there can only be one transfer in this mode */
+			/* start SPI transfer */
+			write_CTRL(drv_data,
+				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
+
+			/* just return here, there can only be one transfer
+			 * in this mode
+			 */
 			message->status = 0;
 			giveback(drv_data);
 			return;
@@ -811,9 +815,6 @@ static void pump_transfers(unsigned long
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_DMAREAD));
-
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
@@ -827,12 +828,13 @@ static void pump_transfers(unsigned long
 					(unsigned long)drv_data->rx);
 			enable_dma(drv_data->dma_channel);
 
+			/* start SPI transfer */
+			write_CTRL(drv_data,
+				(cr | CFG_SPI_DMAREAD | BIT_CTL_ENABLE));
+
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
-			/* set SPI transfer mode */
-			write_CTRL(drv_data, (cr | CFG_SPI_DMAWRITE));
-
 			/* start dma */
 			dma_enable_irq(drv_data->dma_channel);
 			dma_config = (RESTART | dma_width | DI_EN);
@@ -840,6 +842,10 @@ static void pump_transfers(unsigned long
 			set_dma_start_addr(drv_data->dma_channel,
 					(unsigned long)drv_data->tx);
 			enable_dma(drv_data->dma_channel);
+
+			/* start SPI transfer */
+			write_CTRL(drv_data,
+				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
 		}
 	} else {
 		/* IO mode write then read */
@@ -1142,6 +1148,8 @@ static int setup(struct spi_device *spi)
 		peripheral_request(ssel[spi->master->bus_num]
 			[chip->chip_select_num-1], DRV_NAME);
 
+	cs_deactive(drv_data, chip);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-resequence-dma-start-stop.patch
