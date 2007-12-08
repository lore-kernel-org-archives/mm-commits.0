From: akpm@linux-foundation.org
Subject: - spi-spi_bfin-change-handling-of-communication-parameters.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:23 -0800
Message-ID: <200712080129.lB81TNvn013399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbXLHBjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin: change handling of communication parameters
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin-change-handling-of-communication-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: spi_bfin: change handling of communication parameters
From: Sonic Zhang <sonic.zhang@analog.com>

Fix SPI driver to work with SPI flash ST M25P16 on bf548

Currently the SPI driver enables the SPI controller and sets the SPI baud
register for each SPI transfer.  But they should never be changed within a SPI
message session, in which several SPI transfers are pumped.

This patch moves SPI setting to the begining of a message session, and
never disables SPI controller until an error occurs.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  162 +++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 75 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-change-handling-of-communication-parameters drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-change-handling-of-communication-parameters
+++ a/drivers/spi/spi_bfin5xx.c
@@ -222,9 +222,13 @@ static int restore_state(struct driver_d
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	write_CTRL(chip->ctl_reg);
+	cs_deactive(chip);
 	write_BAUD(chip->baud);
-	cs_active(chip);
+	chip->ctl_reg &= (~BIT_CTL_TIMOD);
+	chip->ctl_reg |= (chip->width << 8);
+	write_CTRL(chip->ctl_reg);
+
+	bfin_spi_enable(drv_data);
 
 	if (ret)
 		dev_dbg(&drv_data->pdev->dev,
@@ -271,6 +275,7 @@ static void u8_writer(struct driver_data
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -293,16 +298,16 @@ static void u8_cs_chg_writer(struct driv
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-	cs_deactive(chip);
 
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -314,6 +319,7 @@ static void u8_reader(struct driver_data
 	write_TDBR(0xFFFF);
 
 	dummy_read();
+
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -331,23 +337,30 @@ static void u8_cs_chg_reader(struct driv
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(chip);
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
 
-		read_RDBR();	/* kick off */
-		while (!(read_STAT() & BIT_STAT_RXS))
-			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
-		*(u8 *) (drv_data->rx) = read_SHAW();
+	cs_active(chip);
+	dummy_read();
+
+	while (drv_data->rx < drv_data->rx_end - 1) {
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
+
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		cs_active(chip);
+		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 	}
 	cs_deactive(chip);
 
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
+	*(u8 *) (drv_data->rx) = read_SHAW();
+	++drv_data->rx;
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -355,7 +368,7 @@ static void u8_duplex(struct driver_data
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -363,6 +376,10 @@ static void u8_duplex(struct driver_data
 		++drv_data->rx;
 		++drv_data->tx;
 	}
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u8_cs_chg_duplex(struct driver_data *drv_data)
@@ -372,9 +389,8 @@ static void u8_cs_chg_duplex(struct driv
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(chip);
 
-
 		write_TDBR(*(u8 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -386,7 +402,10 @@ static void u8_cs_chg_duplex(struct driv
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -416,21 +435,26 @@ static void u16_cs_chg_writer(struct dri
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-16 is 0x%x\n", read_STAT());
+
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
+
 	dummy_read();
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
@@ -450,22 +474,30 @@ static void u16_cs_chg_reader(struct dri
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
-	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(chip);
+	/* clear TDBR buffer before read(else it will be shifted out) */
+	write_TDBR(0xFFFF);
 
-		read_RDBR();	/* kick off */
-		while (!(read_STAT() & BIT_STAT_RXS))
-			continue;
-		while (!(read_STAT() & BIT_STAT_SPIF))
-			continue;
-		*(u16 *) (drv_data->rx) = read_SHAW();
+	cs_active(chip);
+	dummy_read();
+
+	while (drv_data->rx < drv_data->rx_end) {
 		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
+
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		cs_active(chip);
+		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 	}
 	cs_deactive(chip);
+
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
+	*(u16 *) (drv_data->rx) = read_SHAW();
+	drv_data->rx += 2;
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -473,7 +505,7 @@ static void u16_duplex(struct driver_dat
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -481,6 +513,10 @@ static void u16_duplex(struct driver_dat
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_cs_chg_duplex(struct driver_data *drv_data)
@@ -491,7 +527,7 @@ static void u16_cs_chg_duplex(struct dri
 		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -503,7 +539,10 @@ static void u16_cs_chg_duplex(struct dri
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-	cs_deactive(chip);
+
+	/* poll for SPI completion before returning */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 /* test if ther is more transfer to be done */
@@ -587,8 +626,6 @@ static irqreturn_t dma_irq_handler(int i
 	while (!(read_STAT() & SPIF))
 		continue;
 
-	bfin_spi_disable(drv_data);
-
 	msg->actual_length += drv_data->len_in_bytes;
 
 	if (drv_data->cs_change)
@@ -698,12 +735,8 @@ static void pump_transfers(unsigned long
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
-	/* restore spi status for each spi transfer */
-	if (transfer->speed_hz) {
-		write_BAUD(hz_to_spi_baud(transfer->speed_hz));
-	} else {
-		write_BAUD(chip->baud);
-	}
+	write_STAT(BIT_STAT_CLR);
+	cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 	cs_active(chip);
 
 	dev_dbg(&drv_data->pdev->dev,
@@ -717,10 +750,8 @@ static void pump_transfers(unsigned long
 	 */
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
-		write_STAT(BIT_STAT_CLR);
 		disable_dma(spi_dma_ch);
 		clear_dma_irqstat(spi_dma_ch);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -734,14 +765,14 @@ static void pump_transfers(unsigned long
 			dma_width = WDSIZE_8;
 		}
 
-		/* set transfer width,direction. And enable spi */
-		cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
 			dev_dbg(&drv_data->pdev->dev,
 				"doing autobuffer DMA out.\n");
 
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAWRITE);
+
 			/* no irq in autobuffer mode */
 			dma_config =
 			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
@@ -749,8 +780,6 @@ static void pump_transfers(unsigned long
 			set_dma_start_addr(spi_dma_ch,
 					(unsigned long)drv_data->tx);
 			enable_dma(spi_dma_ch);
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
-				   (CFG_SPI_ENABLE << 14));
 
 			/* just return here, there can only be one transfer in this mode */
 			message->status = 0;
@@ -763,11 +792,11 @@ static void pump_transfers(unsigned long
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
-			/* disable SPI before write to TDBR */
-			write_CTRL(cr & ~BIT_CTL_ENABLE);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAREAD);
 
 			/* clear tx reg soformer data is not shifted out */
-			write_TDBR(0xFF);
+			write_TDBR(0xFFFF);
 
 			set_dma_x_count(spi_dma_ch, drv_data->len);
 
@@ -779,14 +808,12 @@ static void pump_transfers(unsigned long
 					(unsigned long)drv_data->rx);
 			enable_dma(spi_dma_ch);
 
-			cr |=
-			    CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE <<
-							      14);
-			/* set transfer mode, and enable SPI */
-			write_CTRL(cr);
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_DMAWRITE);
+
 			/* start dma */
 			dma_enable_irq(spi_dma_ch);
 			dma_config = (RESTART | dma_width | DI_EN);
@@ -794,28 +821,20 @@ static void pump_transfers(unsigned long
 			set_dma_start_addr(spi_dma_ch,
 					(unsigned long)drv_data->tx);
 			enable_dma(spi_dma_ch);
-
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
-				   (CFG_SPI_ENABLE << 14));
-
 		}
 	} else {
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
-		write_STAT(BIT_STAT_CLR);
-
 		if (drv_data->tx != NULL && drv_data->rx != NULL) {
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_WRITE | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO duplex: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_WRITE);
 
 			drv_data->duplex(drv_data);
 
@@ -823,13 +842,11 @@ static void pump_transfers(unsigned long
 				tranf_success = 0;
 		} else if (drv_data->tx != NULL) {
 			/* write only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_WRITE | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_WRITE);
 
 			drv_data->write(drv_data);
 
@@ -837,13 +854,11 @@ static void pump_transfers(unsigned long
 				tranf_success = 0;
 		} else if (drv_data->rx != NULL) {
 			/* read only half duplex */
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-			cr |= CFG_SPI_READ | (width << 8) |
-				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
-			write_CTRL(cr);
+			/* set SPI transfer mode */
+			write_CTRL(cr | CFG_SPI_READ);
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -858,9 +873,6 @@ static void pump_transfers(unsigned long
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len;
 
-			if (drv_data->cs_change)
-				cs_deactive(chip);
-
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
 		}
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
