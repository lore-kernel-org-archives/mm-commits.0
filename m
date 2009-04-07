From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:54 -0700
Message-ID: <200904071906.n37J6smm011036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760819AbZDGTKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: use bfin_spi_ prefix on all functions
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: use bfin_spi_ prefix on all functions
From: Mike Frysinger <vapier.adi@gmail.com>

Do this because when things crash, we get simple names like "setup" and
"start_queue" which is pretty difficult to trace back to the real thing:
the spi driver

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  223 ++++++++++++++++++------------------
 1 file changed, 112 insertions(+), 111 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions
+++ a/drivers/spi/spi_bfin5xx.c
@@ -29,7 +29,7 @@
 
 #define DRV_NAME	"bfin-spi"
 #define DRV_AUTHOR	"Bryan Wu, Luke Yang"
-#define DRV_DESC	"Blackfin BF5xx on-chip SPI Controller Driver"
+#define DRV_DESC	"Blackfin on-chip SPI Controller Driver"
 #define DRV_VERSION	"1.0"
 
 MODULE_AUTHOR(DRV_AUTHOR);
@@ -161,7 +161,7 @@ static u16 hz_to_spi_baud(u32 speed_hz)
 	return spi_baud;
 }
 
-static int flush(struct driver_data *drv_data)
+static int bfin_spi_flush(struct driver_data *drv_data)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
@@ -175,7 +175,7 @@ static int flush(struct driver_data *drv
 }
 
 /* Chip select operation functions for cs_change flag */
-static void cs_active(struct driver_data *drv_data, struct chip_data *chip)
+static void bfin_spi_cs_active(struct driver_data *drv_data, struct chip_data *chip)
 {
 	u16 flag = read_FLAG(drv_data);
 
@@ -185,7 +185,7 @@ static void cs_active(struct driver_data
 	write_FLAG(drv_data, flag);
 }
 
-static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
+static void bfin_spi_cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 {
 	u16 flag = read_FLAG(drv_data);
 
@@ -200,7 +200,7 @@ static void cs_deactive(struct driver_da
 }
 
 /* stop controller and re-config current chip*/
-static void restore_state(struct driver_data *drv_data)
+static void bfin_spi_restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
@@ -214,18 +214,18 @@ static void restore_state(struct driver_
 	write_BAUD(drv_data, chip->baud);
 
 	bfin_spi_enable(drv_data);
-	cs_active(drv_data, chip);
+	bfin_spi_cs_active(drv_data, chip);
 }
 
 /* used to kick off transfer in rx mode */
-static unsigned short dummy_read(struct driver_data *drv_data)
+static unsigned short bfin_spi_dummy_read(struct driver_data *drv_data)
 {
 	unsigned short tmp;
 	tmp = read_RDBR(drv_data);
 	return tmp;
 }
 
-static void null_writer(struct driver_data *drv_data)
+static void bfin_spi_null_writer(struct driver_data *drv_data)
 {
 	u8 n_bytes = drv_data->n_bytes;
 
@@ -237,20 +237,20 @@ static void null_writer(struct driver_da
 	}
 }
 
-static void null_reader(struct driver_data *drv_data)
+static void bfin_spi_null_reader(struct driver_data *drv_data)
 {
 	u8 n_bytes = drv_data->n_bytes;
-	dummy_read(drv_data);
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		dummy_read(drv_data);
+		bfin_spi_dummy_read(drv_data);
 		drv_data->rx += n_bytes;
 	}
 }
 
-static void u8_writer(struct driver_data *drv_data)
+static void bfin_spi_u8_writer(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT(drv_data));
@@ -267,12 +267,12 @@ static void u8_writer(struct driver_data
 		cpu_relax();
 }
 
-static void u8_cs_chg_writer(struct driver_data *drv_data)
+static void bfin_spi_u8_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
@@ -280,13 +280,13 @@ static void u8_cs_chg_writer(struct driv
 		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		++drv_data->tx;
 	}
 }
 
-static void u8_reader(struct driver_data *drv_data)
+static void bfin_spi_u8_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT(drv_data));
@@ -298,7 +298,7 @@ static void u8_reader(struct driver_data
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
 
-	dummy_read(drv_data);
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
@@ -313,12 +313,12 @@ static void u8_reader(struct driver_data
 	++drv_data->rx;
 }
 
-static void u8_cs_chg_reader(struct driver_data *drv_data)
+static void bfin_spi_u8_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 		read_RDBR(drv_data);	/* kick off */
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
@@ -327,13 +327,13 @@ static void u8_cs_chg_reader(struct driv
 			cpu_relax();
 
 		*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		++drv_data->rx;
 	}
 }
 
-static void u8_duplex(struct driver_data *drv_data)
+static void bfin_spi_u8_duplex(struct driver_data *drv_data)
 {
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
@@ -348,12 +348,12 @@ static void u8_duplex(struct driver_data
 	}
 }
 
-static void u8_cs_chg_duplex(struct driver_data *drv_data)
+static void bfin_spi_u8_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 
@@ -363,14 +363,14 @@ static void u8_cs_chg_duplex(struct driv
 			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		++drv_data->rx;
 		++drv_data->tx;
 	}
 }
 
-static void u16_writer(struct driver_data *drv_data)
+static void bfin_spi_u16_writer(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT(drv_data));
@@ -387,12 +387,12 @@ static void u16_writer(struct driver_dat
 		cpu_relax();
 }
 
-static void u16_cs_chg_writer(struct driver_data *drv_data)
+static void bfin_spi_u16_cs_chg_writer(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
@@ -400,13 +400,13 @@ static void u16_cs_chg_writer(struct dri
 		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			cpu_relax();
 
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		drv_data->tx += 2;
 	}
 }
 
-static void u16_reader(struct driver_data *drv_data)
+static void bfin_spi_u16_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
 		"cr-16 is 0x%x\n", read_STAT(drv_data));
@@ -418,7 +418,7 @@ static void u16_reader(struct driver_dat
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
 
-	dummy_read(drv_data);
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
@@ -433,7 +433,7 @@ static void u16_reader(struct driver_dat
 	drv_data->rx += 2;
 }
 
-static void u16_cs_chg_reader(struct driver_data *drv_data)
+static void bfin_spi_u16_cs_chg_reader(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
@@ -444,19 +444,19 @@ static void u16_cs_chg_reader(struct dri
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
 
-	cs_active(drv_data, chip);
-	dummy_read(drv_data);
+	bfin_spi_cs_active(drv_data, chip);
+	bfin_spi_dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end - 2) {
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			cpu_relax();
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
-	cs_deactive(drv_data, chip);
+	bfin_spi_cs_deactive(drv_data, chip);
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 		cpu_relax();
@@ -464,7 +464,7 @@ static void u16_cs_chg_reader(struct dri
 	drv_data->rx += 2;
 }
 
-static void u16_duplex(struct driver_data *drv_data)
+static void bfin_spi_u16_duplex(struct driver_data *drv_data)
 {
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
@@ -479,12 +479,12 @@ static void u16_duplex(struct driver_dat
 	}
 }
 
-static void u16_cs_chg_duplex(struct driver_data *drv_data)
+static void bfin_spi_u16_cs_chg_duplex(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
@@ -493,7 +493,7 @@ static void u16_cs_chg_duplex(struct dri
 			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 		drv_data->rx += 2;
 		drv_data->tx += 2;
@@ -501,7 +501,7 @@ static void u16_cs_chg_duplex(struct dri
 }
 
 /* test if ther is more transfer to be done */
-static void *next_transfer(struct driver_data *drv_data)
+static void *bfin_spi_next_transfer(struct driver_data *drv_data)
 {
 	struct spi_message *msg = drv_data->cur_msg;
 	struct spi_transfer *trans = drv_data->cur_transfer;
@@ -520,7 +520,7 @@ static void *next_transfer(struct driver
  * caller already set message->status;
  * dma and pio irqs are blocked give finished message back
  */
-static void giveback(struct driver_data *drv_data)
+static void bfin_spi_giveback(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_transfer *last_transfer;
@@ -541,7 +541,7 @@ static void giveback(struct driver_data 
 	msg->state = NULL;
 
 	if (!drv_data->cs_change)
-		cs_deactive(drv_data, chip);
+		bfin_spi_cs_deactive(drv_data, chip);
 
 	/* Not stop spi in autobuffer mode */
 	if (drv_data->tx_dma != 0xFFFF)
@@ -551,7 +551,7 @@ static void giveback(struct driver_data 
 		msg->complete(msg->context);
 }
 
-static irqreturn_t dma_irq_handler(int irq, void *dev_id)
+static irqreturn_t bfin_spi_dma_irq_handler(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
@@ -601,10 +601,10 @@ static irqreturn_t dma_irq_handler(int i
 		msg->actual_length += drv_data->len_in_bytes;
 
 		if (drv_data->cs_change)
-			cs_deactive(drv_data, chip);
+			bfin_spi_cs_deactive(drv_data, chip);
 
 		/* Move to next transfer */
-		msg->state = next_transfer(drv_data);
+		msg->state = bfin_spi_next_transfer(drv_data);
 	}
 
 	/* Schedule transfer tasklet */
@@ -619,7 +619,7 @@ static irqreturn_t dma_irq_handler(int i
 	return IRQ_HANDLED;
 }
 
-static void pump_transfers(unsigned long data)
+static void bfin_spi_pump_transfers(unsigned long data)
 {
 	struct driver_data *drv_data = (struct driver_data *)data;
 	struct spi_message *message = NULL;
@@ -644,7 +644,7 @@ static void pump_transfers(unsigned long
 	if (message->state == ERROR_STATE) {
 		dev_dbg(&drv_data->pdev->dev, "transfer: we've hit an error\n");
 		message->status = -EIO;
-		giveback(drv_data);
+		bfin_spi_giveback(drv_data);
 		return;
 	}
 
@@ -652,7 +652,7 @@ static void pump_transfers(unsigned long
 	if (message->state == DONE_STATE) {
 		dev_dbg(&drv_data->pdev->dev, "transfer: all done!\n");
 		message->status = 0;
-		giveback(drv_data);
+		bfin_spi_giveback(drv_data);
 		return;
 	}
 
@@ -666,10 +666,10 @@ static void pump_transfers(unsigned long
 	}
 
 	/* Setup the transfer state based on the type of transfer */
-	if (flush(drv_data) == 0) {
+	if (bfin_spi_flush(drv_data) == 0) {
 		dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
 		message->status = -EIO;
-		giveback(drv_data);
+		bfin_spi_giveback(drv_data);
 		return;
 	}
 
@@ -703,31 +703,31 @@ static void pump_transfers(unsigned long
 		drv_data->n_bytes = 1;
 		width = CFG_SPI_WORDSIZE8;
 		drv_data->read = chip->cs_change_per_word ?
-			u8_cs_chg_reader : u8_reader;
+			bfin_spi_u8_cs_chg_reader : bfin_spi_u8_reader;
 		drv_data->write = chip->cs_change_per_word ?
-			u8_cs_chg_writer : u8_writer;
+			bfin_spi_u8_cs_chg_writer : bfin_spi_u8_writer;
 		drv_data->duplex = chip->cs_change_per_word ?
-			u8_cs_chg_duplex : u8_duplex;
+			bfin_spi_u8_cs_chg_duplex : bfin_spi_u8_duplex;
 		break;
 
 	case 16:
 		drv_data->n_bytes = 2;
 		width = CFG_SPI_WORDSIZE16;
 		drv_data->read = chip->cs_change_per_word ?
-			u16_cs_chg_reader : u16_reader;
+			bfin_spi_u16_cs_chg_reader : bfin_spi_u16_reader;
 		drv_data->write = chip->cs_change_per_word ?
-			u16_cs_chg_writer : u16_writer;
+			bfin_spi_u16_cs_chg_writer : bfin_spi_u16_writer;
 		drv_data->duplex = chip->cs_change_per_word ?
-			u16_cs_chg_duplex : u16_duplex;
+			bfin_spi_u16_cs_chg_duplex : bfin_spi_u16_duplex;
 		break;
 
 	default:
 		/* No change, the same as default setting */
 		drv_data->n_bytes = chip->n_bytes;
 		width = chip->width;
-		drv_data->write = drv_data->tx ? chip->write : null_writer;
-		drv_data->read = drv_data->rx ? chip->read : null_reader;
-		drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
+		drv_data->write = drv_data->tx ? chip->write : bfin_spi_null_writer;
+		drv_data->read = drv_data->rx ? chip->read : bfin_spi_null_reader;
+		drv_data->duplex = chip->duplex ? chip->duplex : bfin_spi_null_writer;
 		break;
 	}
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
@@ -741,7 +741,7 @@ static void pump_transfers(unsigned long
 	}
 	dev_dbg(&drv_data->pdev->dev,
 		"transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
-		drv_data->write, chip->write, null_writer);
+		drv_data->write, chip->write, bfin_spi_null_writer);
 
 	/* speed and width has been set on per message */
 	message->state = RUNNING_STATE;
@@ -756,7 +756,7 @@ static void pump_transfers(unsigned long
 	write_STAT(drv_data, BIT_STAT_CLR);
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
 	if (drv_data->cs_change)
-		cs_active(drv_data, chip);
+		bfin_spi_cs_active(drv_data, chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -811,7 +811,7 @@ static void pump_transfers(unsigned long
 			 * in this mode
 			 */
 			message->status = 0;
-			giveback(drv_data);
+			bfin_spi_giveback(drv_data);
 			return;
 		}
 
@@ -919,9 +919,9 @@ static void pump_transfers(unsigned long
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len_in_bytes;
 			/* Move to next transfer of this msg */
-			message->state = next_transfer(drv_data);
+			message->state = bfin_spi_next_transfer(drv_data);
 			if (drv_data->cs_change)
-				cs_deactive(drv_data, chip);
+				bfin_spi_cs_deactive(drv_data, chip);
 		}
 		/* Schedule next transfer tasklet */
 		tasklet_schedule(&drv_data->pump_transfers);
@@ -930,7 +930,7 @@ static void pump_transfers(unsigned long
 }
 
 /* pop a msg from queue and kick off real transfer */
-static void pump_messages(struct work_struct *work)
+static void bfin_spi_pump_messages(struct work_struct *work)
 {
 	struct driver_data *drv_data;
 	unsigned long flags;
@@ -958,7 +958,7 @@ static void pump_messages(struct work_st
 
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	restore_state(drv_data);
+	bfin_spi_restore_state(drv_data);
 
 	list_del_init(&drv_data->cur_msg->queue);
 
@@ -987,7 +987,7 @@ static void pump_messages(struct work_st
  * got a msg to transfer, queue it in drv_data->queue.
  * And kick off message pumper
  */
-static int transfer(struct spi_device *spi, struct spi_message *msg)
+static int bfin_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 {
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
 	unsigned long flags;
@@ -1031,7 +1031,7 @@ static u16 ssel[][MAX_SPI_SSEL] = {
 };
 
 /* first setup for new devices */
-static int setup(struct spi_device *spi)
+static int bfin_spi_setup(struct spi_device *spi)
 {
 	struct bfin5xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
@@ -1105,7 +1105,7 @@ static int setup(struct spi_device *spi)
 			return -ENODEV;
 		}
 		if (set_dma_callback(drv_data->dma_channel,
-		    dma_irq_handler, drv_data) < 0) {
+		    bfin_spi_dma_irq_handler, drv_data) < 0) {
 			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
@@ -1126,28 +1126,29 @@ static int setup(struct spi_device *spi)
 		chip->n_bytes = 1;
 		chip->width = CFG_SPI_WORDSIZE8;
 		chip->read = chip->cs_change_per_word ?
-			u8_cs_chg_reader : u8_reader;
+			bfin_spi_u8_cs_chg_reader : bfin_spi_u8_reader;
 		chip->write = chip->cs_change_per_word ?
-			u8_cs_chg_writer : u8_writer;
+			bfin_spi_u8_cs_chg_writer : bfin_spi_u8_writer;
 		chip->duplex = chip->cs_change_per_word ?
-			u8_cs_chg_duplex : u8_duplex;
+			bfin_spi_u8_cs_chg_duplex : bfin_spi_u8_duplex;
 		break;
 
 	case 16:
 		chip->n_bytes = 2;
 		chip->width = CFG_SPI_WORDSIZE16;
 		chip->read = chip->cs_change_per_word ?
-			u16_cs_chg_reader : u16_reader;
+			bfin_spi_u16_cs_chg_reader : bfin_spi_u16_reader;
 		chip->write = chip->cs_change_per_word ?
-			u16_cs_chg_writer : u16_writer;
+			bfin_spi_u16_cs_chg_writer : bfin_spi_u16_writer;
 		chip->duplex = chip->cs_change_per_word ?
-			u16_cs_chg_duplex : u16_duplex;
+			bfin_spi_u16_cs_chg_duplex : bfin_spi_u16_duplex;
 		break;
 
 	default:
 		dev_err(&spi->dev, "%d bits_per_word is not supported\n",
 				chip->bits_per_word);
-		kfree(chip);
+		if (chip_info)
+			kfree(chip);
 		return -ENODEV;
 	}
 
@@ -1164,7 +1165,7 @@ static int setup(struct spi_device *spi)
 		peripheral_request(ssel[spi->master->bus_num]
 			[chip->chip_select_num-1], spi->modalias);
 
-	cs_deactive(drv_data, chip);
+	bfin_spi_cs_deactive(drv_data, chip);
 
 	return 0;
 }
@@ -1173,7 +1174,7 @@ static int setup(struct spi_device *spi)
  * callback for spi framework.
  * clean driver specific data
  */
-static void cleanup(struct spi_device *spi)
+static void bfin_spi_cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
@@ -1185,7 +1186,7 @@ static void cleanup(struct spi_device *s
 	kfree(chip);
 }
 
-static inline int init_queue(struct driver_data *drv_data)
+static inline int bfin_spi_init_queue(struct driver_data *drv_data)
 {
 	INIT_LIST_HEAD(&drv_data->queue);
 	spin_lock_init(&drv_data->lock);
@@ -1195,10 +1196,10 @@ static inline int init_queue(struct driv
 
 	/* init transfer tasklet */
 	tasklet_init(&drv_data->pump_transfers,
-		     pump_transfers, (unsigned long)drv_data);
+		     bfin_spi_pump_transfers, (unsigned long)drv_data);
 
 	/* init messages workqueue */
-	INIT_WORK(&drv_data->pump_messages, pump_messages);
+	INIT_WORK(&drv_data->pump_messages, bfin_spi_pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
 				dev_name(drv_data->master->dev.parent));
 	if (drv_data->workqueue == NULL)
@@ -1207,7 +1208,7 @@ static inline int init_queue(struct driv
 	return 0;
 }
 
-static inline int start_queue(struct driver_data *drv_data)
+static inline int bfin_spi_start_queue(struct driver_data *drv_data)
 {
 	unsigned long flags;
 
@@ -1229,7 +1230,7 @@ static inline int start_queue(struct dri
 	return 0;
 }
 
-static inline int stop_queue(struct driver_data *drv_data)
+static inline int bfin_spi_stop_queue(struct driver_data *drv_data)
 {
 	unsigned long flags;
 	unsigned limit = 500;
@@ -1258,11 +1259,11 @@ static inline int stop_queue(struct driv
 	return status;
 }
 
-static inline int destroy_queue(struct driver_data *drv_data)
+static inline int bfin_spi_destroy_queue(struct driver_data *drv_data)
 {
 	int status;
 
-	status = stop_queue(drv_data);
+	status = bfin_spi_stop_queue(drv_data);
 	if (status != 0)
 		return status;
 
@@ -1271,7 +1272,7 @@ static inline int destroy_queue(struct d
 	return 0;
 }
 
-static int __init bfin5xx_spi_probe(struct platform_device *pdev)
+static int __init bfin_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bfin5xx_spi_master *platform_info;
@@ -1297,9 +1298,9 @@ static int __init bfin5xx_spi_probe(stru
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
-	master->cleanup = cleanup;
-	master->setup = setup;
-	master->transfer = transfer;
+	master->cleanup = bfin_spi_cleanup;
+	master->setup = bfin_spi_setup;
+	master->transfer = bfin_spi_transfer;
 
 	/* Find and map our resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1324,13 +1325,13 @@ static int __init bfin5xx_spi_probe(stru
 	}
 
 	/* Initial and start queue */
-	status = init_queue(drv_data);
+	status = bfin_spi_init_queue(drv_data);
 	if (status != 0) {
 		dev_err(dev, "problem initializing queue\n");
 		goto out_error_queue_alloc;
 	}
 
-	status = start_queue(drv_data);
+	status = bfin_spi_start_queue(drv_data);
 	if (status != 0) {
 		dev_err(dev, "problem starting queue\n");
 		goto out_error_queue_alloc;
@@ -1356,7 +1357,7 @@ static int __init bfin5xx_spi_probe(stru
 	return status;
 
 out_error_queue_alloc:
-	destroy_queue(drv_data);
+	bfin_spi_destroy_queue(drv_data);
 out_error_no_dma_ch:
 	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
@@ -1367,7 +1368,7 @@ out_error_get_res:
 }
 
 /* stop hardware and remove the driver */
-static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
+static int __devexit bfin_spi_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int status = 0;
@@ -1376,7 +1377,7 @@ static int __devexit bfin5xx_spi_remove(
 		return 0;
 
 	/* Remove the queue */
-	status = destroy_queue(drv_data);
+	status = bfin_spi_destroy_queue(drv_data);
 	if (status != 0)
 		return status;
 
@@ -1401,12 +1402,12 @@ static int __devexit bfin5xx_spi_remove(
 }
 
 #ifdef CONFIG_PM
-static int bfin5xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_spi_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int status = 0;
 
-	status = stop_queue(drv_data);
+	status = bfin_spi_stop_queue(drv_data);
 	if (status != 0)
 		return status;
 
@@ -1416,7 +1417,7 @@ static int bfin5xx_spi_suspend(struct pl
 	return 0;
 }
 
-static int bfin5xx_spi_resume(struct platform_device *pdev)
+static int bfin_spi_resume(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int status = 0;
@@ -1425,7 +1426,7 @@ static int bfin5xx_spi_resume(struct pla
 	bfin_spi_enable(drv_data);
 
 	/* Start the queue running */
-	status = start_queue(drv_data);
+	status = bfin_spi_start_queue(drv_data);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem starting queue (%d)\n", status);
 		return status;
@@ -1434,29 +1435,29 @@ static int bfin5xx_spi_resume(struct pla
 	return 0;
 }
 #else
-#define bfin5xx_spi_suspend NULL
-#define bfin5xx_spi_resume NULL
+#define bfin_spi_suspend NULL
+#define bfin_spi_resume NULL
 #endif				/* CONFIG_PM */
 
 MODULE_ALIAS("platform:bfin-spi");
-static struct platform_driver bfin5xx_spi_driver = {
+static struct platform_driver bfin_spi_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
-	.suspend	= bfin5xx_spi_suspend,
-	.resume		= bfin5xx_spi_resume,
-	.remove		= __devexit_p(bfin5xx_spi_remove),
+	.suspend	= bfin_spi_suspend,
+	.resume		= bfin_spi_resume,
+	.remove		= __devexit_p(bfin_spi_remove),
 };
 
-static int __init bfin5xx_spi_init(void)
+static int __init bfin_spi_init(void)
 {
-	return platform_driver_probe(&bfin5xx_spi_driver, bfin5xx_spi_probe);
+	return platform_driver_probe(&bfin_spi_driver, bfin_spi_probe);
 }
-module_init(bfin5xx_spi_init);
+module_init(bfin_spi_init);
 
-static void __exit bfin5xx_spi_exit(void)
+static void __exit bfin_spi_exit(void)
 {
-	platform_driver_unregister(&bfin5xx_spi_driver);
+	platform_driver_unregister(&bfin_spi_driver);
 }
-module_exit(bfin5xx_spi_exit);
+module_exit(bfin_spi_exit);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

