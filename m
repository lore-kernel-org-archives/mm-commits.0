From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-handles-spi_transfercs_change.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:41:07 -0700
Message-ID: <200710302241.l9UMf7Ah031650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbXJ3WlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin handles spi_transfer.cs_change
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-handles-spi_transfercs_change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin handles spi_transfer.cs_change
From: Bryan Wu <bryan.wu@analog.com>

Respect per-transfer cs_change field (protocol tweaking support) by
adding and using cs_active/cs_deactive functions.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   76 +++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-handles-spi_transfercs_change drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-handles-spi_transfercs_change
+++ a/drivers/spi/spi_bfin5xx.c
@@ -115,6 +115,7 @@ struct driver_data {
 	size_t rx_map_len;
 	size_t tx_map_len;
 	u8 n_bytes;
+	int cs_change;
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -179,6 +180,26 @@ static int flush(struct driver_data *drv
 	return limit;
 }
 
+/* Chip select operation functions for cs_change flag */
+static void cs_active(struct chip_data *chip)
+{
+	u16 flag = read_FLAG();
+
+	flag |= chip->flag;
+	flag &= ~(chip->flag << 8);
+
+	write_FLAG(flag);
+}
+
+static void cs_deactive(struct chip_data *chip)
+{
+	u16 flag = read_FLAG();
+
+	flag |= (chip->flag << 8);
+
+	write_FLAG(flag);
+}
+
 #define MAX_SPI0_SSEL	7
 
 /* stop controller and re-config current chip*/
@@ -198,7 +219,7 @@ static int restore_state(struct driver_d
 	/* Load the registers */
 	write_CTRL(chip->ctl_reg);
 	write_BAUD(chip->baud);
-	write_FLAG(chip->flag);
+	cs_active(chip);
 
 	if (!chip->chip_select_requested) {
 		int i = chip->chip_select_num;
@@ -273,20 +294,20 @@ static void u8_cs_chg_writer(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
 			continue;
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 
 }
 
@@ -318,7 +339,7 @@ static void u8_cs_chg_reader(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -326,13 +347,13 @@ static void u8_cs_chg_reader(struct driv
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 
 }
 
@@ -356,7 +377,7 @@ static void u8_cs_chg_duplex(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -365,15 +386,14 @@ static void u8_cs_chg_duplex(struct driv
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
-	write_FLAG(0xFF00);
-
+	cs_deactive(chip);
 }
 
 static void u16_writer(struct driver_data *drv_data)
@@ -398,20 +418,20 @@ static void u16_cs_chg_writer(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
 			continue;
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -438,7 +458,7 @@ static void u16_cs_chg_reader(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -446,13 +466,13 @@ static void u16_cs_chg_reader(struct dri
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -475,7 +495,7 @@ static void u16_cs_chg_duplex(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_FLAG(chip->flag);
+		cs_active(chip);
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -483,14 +503,14 @@ static void u16_cs_chg_duplex(struct dri
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00 | chip->flag);
+		cs_deactive(chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
-	write_FLAG(0xFF00);
+	cs_deactive(chip);
 }
 
 /* test if ther is more transfer to be done */
@@ -515,6 +535,7 @@ static void *next_transfer(struct driver
  */
 static void giveback(struct driver_data *drv_data)
 {
+	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_transfer *last_transfer;
 	unsigned long flags;
 	struct spi_message *msg;
@@ -534,10 +555,13 @@ static void giveback(struct driver_data 
 
 	/* disable chip select signal. And not stop spi in autobuffer mode */
 	if (drv_data->tx_dma != 0xFFFF) {
-		write_FLAG(0xFF00);
+		cs_deactive(chip);
 		bfin_spi_disable(drv_data);
 	}
 
+	if (!drv_data->cs_change)
+		cs_deactive(chip);
+
 	if (msg->complete)
 		msg->complete(msg->context);
 }
@@ -546,6 +570,7 @@ static irqreturn_t dma_irq_handler(int i
 {
 	struct driver_data *drv_data = dev_id;
 	struct spi_message *msg = drv_data->cur_msg;
+	struct chip_data *chip = drv_data->cur_chip;
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
 	clear_dma_irqstat(CH_SPI);
@@ -573,6 +598,9 @@ static irqreturn_t dma_irq_handler(int i
 
 	msg->actual_length += drv_data->len_in_bytes;
 
+	if (drv_data->cs_change)
+		cs_deactive(chip);
+
 	/* Move to next transfer */
 	msg->state = next_transfer(drv_data);
 
@@ -659,6 +687,7 @@ static void pump_transfers(unsigned long
 	drv_data->rx_dma = transfer->rx_dma;
 	drv_data->tx_dma = transfer->tx_dma;
 	drv_data->len_in_bytes = transfer->len;
+	drv_data->cs_change = transfer->cs_change;
 
 	width = chip->width;
 	if (width == CFG_SPI_WORDSIZE16) {
@@ -683,7 +712,7 @@ static void pump_transfers(unsigned long
 	} else {
 		write_BAUD(chip->baud);
 	}
-	write_FLAG(chip->flag);
+	cs_active(chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -834,6 +863,9 @@ static void pump_transfers(unsigned long
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len;
 
+			if (drv_data->cs_change)
+				cs_deactive(chip);
+
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
 		}
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
spi-initial-bf54x-spi-support.patch
spi-bfin-spi-uses-portmux-calls.patch
spi-spi_bfin-cleanups-error-handling.patch
spi-spi_bfin-handles-spi_transfercs_change.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
spi-spi_bfin-uses-platform-device-resources.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-handle-multiple-spi_masters.patch
spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
spi-spi_bfin-update-handling-of-delay-after-deselect.patch
spi-spi_bfin-resequence-dma-start-stop.patch
