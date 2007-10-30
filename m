From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-rearrange-portmux-calls.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:42:58 -0700
Message-ID: <200710302242.l9UMgwAV031711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbXJ3WnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin, rearrange portmux calls
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-rearrange-portmux-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin, rearrange portmux calls
From: Sonic Zhang <sonic.zhang@analog.com>

Move pin muxing to setup and cleanup methods.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   53 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-rearrange-portmux-calls drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-rearrange-portmux-calls
+++ a/drivers/spi/spi_bfin5xx.c
@@ -136,7 +136,6 @@ struct chip_data {
 	u16 flag;
 
 	u8 chip_select_num;
-	u8 chip_select_requested;
 	u8 n_bytes;
 	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
@@ -216,19 +215,7 @@ static int restore_state(struct driver_d
 {
 	struct chip_data *chip = drv_data->cur_chip;
 	int ret = 0;
-	u16 ssel[3][MAX_SPI_SSEL] = {
-		{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
-		P_SPI0_SSEL4, P_SPI0_SSEL5,
-		P_SPI0_SSEL6, P_SPI0_SSEL7},
-
-		{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
-		P_SPI1_SSEL4, P_SPI1_SSEL5,
-		P_SPI1_SSEL6, P_SPI1_SSEL7},
-
-		{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
-		P_SPI2_SSEL4, P_SPI2_SSEL5,
-		P_SPI2_SSEL6, P_SPI2_SSEL7},
-	};
+
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
@@ -239,17 +226,6 @@ static int restore_state(struct driver_d
 	write_BAUD(chip->baud);
 	cs_active(chip);
 
-	if (!chip->chip_select_requested) {
-		int i = chip->chip_select_num;
-
-		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
-		if ((i > 0) && (i <= MAX_SPI_SSEL))
-			ret = peripheral_request(
-				ssel[drv_data->master->bus_num][i-1], DRV_NAME);
-
-		chip->chip_select_requested = 1;
-	}
-
 	if (ret)
 		dev_dbg(&drv_data->pdev->dev,
 			": request chip select number %d failed\n",
@@ -983,6 +959,22 @@ static int transfer(struct spi_device *s
 	return 0;
 }
 
+#define MAX_SPI_SSEL	7
+
+static u16 ssel[3][MAX_SPI_SSEL] = {
+	{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+	P_SPI0_SSEL4, P_SPI0_SSEL5,
+	P_SPI0_SSEL6, P_SPI0_SSEL7},
+
+	{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
+	P_SPI1_SSEL4, P_SPI1_SSEL5,
+	P_SPI1_SSEL6, P_SPI1_SSEL7},
+
+	{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
+	P_SPI2_SSEL4, P_SPI2_SSEL5,
+	P_SPI2_SSEL6, P_SPI2_SSEL7},
+};
+
 /* first setup for new devices */
 static int setup(struct spi_device *spi)
 {
@@ -1113,6 +1105,12 @@ static int setup(struct spi_device *spi)
 
 	spi_set_ctldata(spi, chip);
 
+	dev_dbg(&spi->dev, "chip select number is %d\n", chip->chip_select_num);
+	if ((chip->chip_select_num > 0)
+		&& (chip->chip_select_num <= spi->master->num_chipselect))
+		peripheral_request(ssel[spi->master->bus_num]
+			[chip->chip_select_num-1], DRV_NAME);
+
 	return 0;
 }
 
@@ -1124,6 +1122,11 @@ static void cleanup(struct spi_device *s
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if ((chip->chip_select_num > 0)
+		&& (chip->chip_select_num <= spi->master->num_chipselect))
+		peripheral_free(ssel[spi->master->bus_num]
+					[chip->chip_select_num-1]);
+
 	kfree(chip);
 }
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-resequence-dma-start-stop.patch
