From: akpm@linux-foundation.org
Subject: - spi-spi_bfin-relocate-spin-waits.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:29 -0800
Message-ID: <200712080129.lB81TT9g013402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbXLHBjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin: relocate spin/waits
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin-relocate-spin-waits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: spi_bfin: relocate spin/waits
From: Sonic Zhang <sonic.zhang@analog.com>

Move spin/waits to more correct locations in bfin SPI driver.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   84 ++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-relocate-spin-waits drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-relocate-spin-waits
+++ a/drivers/spi/spi_bfin5xx.c
@@ -276,22 +276,26 @@ static void u8_writer(struct driver_data
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -304,10 +308,6 @@ static void u8_cs_chg_writer(struct driv
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_reader(struct driver_data *drv_data)
@@ -315,6 +315,10 @@ static void u8_reader(struct driver_data
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -337,6 +341,10 @@ static void u8_cs_chg_reader(struct driv
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -365,6 +373,10 @@ static void u8_cs_chg_reader(struct driv
 
 static void u8_duplex(struct driver_data *drv_data)
 {
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -376,16 +388,16 @@ static void u8_duplex(struct driver_data
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u8_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(chip);
 
@@ -402,10 +414,6 @@ static void u8_cs_chg_duplex(struct driv
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -413,22 +421,26 @@ static void u16_writer(struct driver_dat
 	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -441,10 +453,6 @@ static void u16_cs_chg_writer(struct dri
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -452,6 +460,10 @@ static void u16_reader(struct driver_dat
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-16 is 0x%x\n", read_STAT());
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -474,6 +486,10 @@ static void u16_cs_chg_reader(struct dri
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
@@ -502,6 +518,10 @@ static void u16_cs_chg_reader(struct dri
 
 static void u16_duplex(struct driver_data *drv_data)
 {
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
@@ -513,16 +533,16 @@ static void u16_duplex(struct driver_dat
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 static void u16_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
+	/* poll for SPI completion before start */
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
+
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(chip);
 
@@ -539,10 +559,6 @@ static void u16_cs_chg_duplex(struct dri
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-
-	/* poll for SPI completion before returning */
-	while (!(read_STAT() & BIT_STAT_SPIF))
-		continue;
 }
 
 /* test if ther is more transfer to be done */
@@ -765,6 +781,10 @@ static void pump_transfers(unsigned long
 			dma_width = WDSIZE_8;
 		}
 
+		/* poll for SPI completion before start */
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
 			dev_dbg(&drv_data->pdev->dev,
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
