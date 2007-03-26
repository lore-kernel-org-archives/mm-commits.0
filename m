From: akpm@linux-foundation.org
Subject: + blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:10:46 -0700
Message-ID: <200703262110.l2QLAks9030667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbXCZVKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin: spi driver cleanup and coding style fixing
has been added to the -mm tree.  Its filename is
     blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin: spi driver cleanup and coding style fixing
From: "Wu, Bryan" <bryan.wu@analog.com>

This patch cleanup blackfin SPI driver code and fix some coding style
problems.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  322 ++++++++++++++++++++----------------
 1 files changed, 179 insertions(+), 143 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing
+++ a/drivers/spi/spi_bfin5xx.c
@@ -7,8 +7,6 @@
  * Description:  SPI controller driver for Blackfin 5xx
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
- * Rev:          $Id: spi_bfin5xx.c 2508 2006-12-06 07:35:43Z sonicz $
- *
  * Modified:
  *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
  *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
@@ -55,17 +53,6 @@ MODULE_AUTHOR("Luke Yang");
 MODULE_DESCRIPTION("Blackfin 5xx SPI Contoller");
 MODULE_LICENSE("GPL");
 
-#ifdef DEBUG
-#define ASSERT(expr) \
-	if (!(expr)) { \
-		printk(KERN_DEBUG "assertion failed! %s[%d]: %s\n", \
-		       __FUNCTION__, __LINE__, #expr); \
-		panic(KERN_DEBUG "%s", __FUNCTION__); \
-	}
-#else
-#define ASSERT(expr)
-#endif
-
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
 #define DEFINE_SPI_REG(reg, off) \
@@ -82,15 +69,12 @@ DEFINE_SPI_REG(TDBR, 0x0C)
 DEFINE_SPI_REG(RDBR, 0x10)
 DEFINE_SPI_REG(BAUD, 0x14)
 DEFINE_SPI_REG(SHAW, 0x18)
-
 #define START_STATE ((void*)0)
 #define RUNNING_STATE ((void*)1)
 #define DONE_STATE ((void*)2)
 #define ERROR_STATE ((void*)-1)
-
 #define QUEUE_RUNNING 0
 #define QUEUE_STOPPED 1
-
 int dma_requested;
 char chip_select_flag;
 
@@ -175,12 +159,13 @@ void bfin_spi_disable(struct driver_data
 static u16 hz_to_spi_baud(u32 speed_hz)
 {
 	u_long sclk = get_sclk();
-	u16 spi_baud = (sclk / (2*speed_hz));
+	u16 spi_baud = (sclk / (2 * speed_hz));
 
-	if ((sclk % (2*speed_hz)) > 0)
+	if ((sclk % (2 * speed_hz)) > 0)
 		spi_baud++;
 
-	pr_debug("sclk = %ld, speed_hz = %d, spi_baud = %d\n", sclk, speed_hz, spi_baud);
+	pr_debug("sclk = %ld, speed_hz = %d, spi_baud = %d\n", sclk, speed_hz,
+		 spi_baud);
 
 	return spi_baud;
 }
@@ -190,7 +175,8 @@ static int flush(struct driver_data *drv
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	do {} while (!(read_STAT() & BIT_STAT_SPIF) && limit--);
+	do {
+	} while (!(read_STAT() & BIT_STAT_SPIF) && limit--);
 	write_STAT(BIT_STAT_CLR);
 
 	return limit;
@@ -265,7 +251,8 @@ static void null_writer(struct driver_da
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(0);
-		do {} while ((read_STAT() & BIT_STAT_TXS));
+		do {
+		} while ((read_STAT() & BIT_STAT_TXS));
 		drv_data->tx += n_bytes;
 	}
 }
@@ -276,7 +263,8 @@ static void null_reader(struct driver_da
 	dummy_read();
 
 	while (drv_data->rx < drv_data->rx_end) {
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
 		dummy_read();
 		drv_data->rx += n_bytes;
 	}
@@ -286,13 +274,15 @@ static void u8_writer(struct driver_data
 {
 	pr_debug("cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u8 *)(drv_data->tx));
-		do {} while (read_STAT() & BIT_STAT_TXS);
+		write_TDBR(*(u8 *) (drv_data->tx));
+		do {
+		} while (read_STAT() & BIT_STAT_TXS);
 		++drv_data->tx;
 	}
 
-	// poll for SPI completion before returning
-	do {} while (!(read_STAT() & BIT_STAT_SPIF));
+	/* poll for SPI completion before returning */
+	do {
+	} while (!(read_STAT() & BIT_STAT_SPIF));
 }
 
 static void u8_cs_chg_writer(struct driver_data *drv_data)
@@ -303,10 +293,12 @@ static void u8_cs_chg_writer(struct driv
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		write_TDBR(*(u8 *)(drv_data->tx));
-		do {} while (read_STAT() & BIT_STAT_TXS);
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		write_FLAG(0xFF00|chip->flag);
+		write_TDBR(*(u8 *) (drv_data->tx));
+		do {
+		} while (read_STAT() & BIT_STAT_TXS);
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -320,18 +312,20 @@ static void u8_reader(struct driver_data
 {
 	pr_debug("cr-8 is 0x%x\n", read_STAT());
 
-	// clear TDBR buffer before read(else it will be shifted out)
+	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(0xFFFF);
 
 	dummy_read();
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u8 *)(drv_data->rx) = read_RDBR();
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 	}
-	do {} while (!(read_STAT() & BIT_STAT_RXS));
-	*(u8 *)(drv_data->rx) = read_SHAW();
+	do {
+	} while (!(read_STAT() & BIT_STAT_RXS));
+	*(u8 *) (drv_data->rx) = read_SHAW();
 	++drv_data->rx;
 }
 
@@ -343,11 +337,13 @@ static void u8_cs_chg_reader(struct driv
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		read_RDBR(); /* kick off */
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		*(u8 *)(drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00|chip->flag);
+		read_RDBR();	/* kick off */
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		*(u8 *) (drv_data->rx) = read_SHAW();
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -361,11 +357,12 @@ static void u8_duplex(struct driver_data
 {
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
-		write_TDBR(*(u8 *)(drv_data->tx));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u8 *)(drv_data->rx) = read_RDBR();
-		//if (*(u8 *)(drv_data->rx)) pr_debug(KERN_NOTICE "u8_duplex: %c\n", *(u8 *)(drv_data->rx));
+		write_TDBR(*(u8 *) (drv_data->tx));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 		++drv_data->tx;
 	}
@@ -379,11 +376,13 @@ static void u8_cs_chg_duplex(struct driv
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		write_TDBR(*(u8 *)(drv_data->tx));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u8 *)(drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00|chip->flag);
+		write_TDBR(*(u8 *) (drv_data->tx));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u8 *) (drv_data->rx) = read_RDBR();
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -398,13 +397,15 @@ static void u16_writer(struct driver_dat
 {
 	pr_debug("cr16 is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u16 *)(drv_data->tx));
-		do {} while ((read_STAT() & BIT_STAT_TXS));
+		write_TDBR(*(u16 *) (drv_data->tx));
+		do {
+		} while ((read_STAT() & BIT_STAT_TXS));
 		drv_data->tx += 2;
 	}
 
-	// poll for SPI completion before returning
-	do {} while (!(read_STAT() & BIT_STAT_SPIF));
+	/* poll for SPI completion before returning */
+	do {
+	} while (!(read_STAT() & BIT_STAT_SPIF));
 }
 
 static void u16_cs_chg_writer(struct driver_data *drv_data)
@@ -415,10 +416,12 @@ static void u16_cs_chg_writer(struct dri
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		write_TDBR(*(u16 *)(drv_data->tx));
-		do {} while ((read_STAT() & BIT_STAT_TXS));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		write_FLAG(0xFF00|chip->flag);
+		write_TDBR(*(u16 *) (drv_data->tx));
+		do {
+		} while ((read_STAT() & BIT_STAT_TXS));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -434,12 +437,14 @@ static void u16_reader(struct driver_dat
 	dummy_read();
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u16 *)(drv_data->rx) = read_RDBR();
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 	}
-	do {} while (!(read_STAT() & BIT_STAT_RXS));
-	*(u16 *)(drv_data->rx) = read_SHAW();
+	do {
+	} while (!(read_STAT() & BIT_STAT_RXS));
+	*(u16 *) (drv_data->rx) = read_SHAW();
 	drv_data->rx += 2;
 }
 
@@ -451,11 +456,13 @@ static void u16_cs_chg_reader(struct dri
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		read_RDBR();  /* kick off */
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		*(u16 *)(drv_data->rx) = read_SHAW();
-		write_FLAG(0xFF00|chip->flag);
+		read_RDBR();	/* kick off */
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		*(u16 *) (drv_data->rx) = read_SHAW();
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -469,10 +476,12 @@ static void u16_duplex(struct driver_dat
 {
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u16 *)(drv_data->tx));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u16 *)(drv_data->rx) = read_RDBR();
+		write_TDBR(*(u16 *) (drv_data->tx));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
@@ -486,11 +495,13 @@ static void u16_cs_chg_duplex(struct dri
 		write_FLAG(chip->flag);
 		SSYNC();
 
-		write_TDBR(*(u16 *)(drv_data->tx));
-		do {} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {} while (!(read_STAT() & BIT_STAT_RXS));
-		*(u16 *)(drv_data->rx) = read_RDBR();
-		write_FLAG(0xFF00|chip->flag);
+		write_TDBR(*(u16 *) (drv_data->tx));
+		do {
+		} while (!(read_STAT() & BIT_STAT_SPIF));
+		do {
+		} while (!(read_STAT() & BIT_STAT_RXS));
+		*(u16 *) (drv_data->rx) = read_RDBR();
+		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -510,9 +521,8 @@ static void *next_transfer(struct driver
 	/* Move to next transfer */
 	if (trans->transfer_list.next != &msg->transfers) {
 		drv_data->cur_transfer =
-			list_entry(trans->transfer_list.next,
-					struct spi_transfer,
-					transfer_list);
+		    list_entry(trans->transfer_list.next,
+			       struct spi_transfer, transfer_list);
 		return RUNNING_STATE;
 	} else
 		return DONE_STATE;
@@ -536,8 +546,7 @@ static void giveback(struct driver_data 
 	spin_unlock_irqrestore(&drv_data->lock, flags);
 
 	last_transfer = list_entry(msg->transfers.prev,
-					struct spi_transfer,
-					transfer_list);
+				   struct spi_transfer, transfer_list);
 
 	msg->state = NULL;
 	/* disable chip select signal. And not stop spi in autobuffer mode */
@@ -562,14 +571,11 @@ static irqreturn_t dma_irq_handler(int i
 	 * while loops are supposed to be the same (see the HRM).
 	 */
 	if (drv_data->tx != NULL) {
-		while (bfin_read_SPI_STAT() & TXS)
-			;
-		while (bfin_read_SPI_STAT() & TXS)
-			;
+		while (bfin_read_SPI_STAT() & TXS) ;
+		while (bfin_read_SPI_STAT() & TXS) ;
 	}
 
-	while (!(bfin_read_SPI_STAT() & SPIF))
-		;
+	while (!(bfin_read_SPI_STAT() & SPIF)) ;
 
 	bfin_spi_disable(drv_data);
 
@@ -621,8 +627,7 @@ static void pump_transfers(unsigned long
 	/* Delay if requested at end of transfer */
 	if (message->state == RUNNING_STATE) {
 		previous = list_entry(transfer->transfer_list.prev,
-					struct spi_transfer,
-					transfer_list);
+				      struct spi_transfer, transfer_list);
 		if (previous->delay_usecs)
 			udelay(previous->delay_usecs);
 	}
@@ -638,7 +643,8 @@ static void pump_transfers(unsigned long
 	if (transfer->tx_buf != NULL) {
 		drv_data->tx = (void *)transfer->tx_buf;
 		drv_data->tx_end = drv_data->tx + transfer->len;
-		pr_debug("tx_buf is %p, tx_end is %p\n", transfer->tx_buf, drv_data->tx_end);
+		pr_debug("tx_buf is %p, tx_end is %p\n", transfer->tx_buf,
+			 drv_data->tx_end);
 	} else {
 		drv_data->tx = NULL;
 	}
@@ -646,7 +652,8 @@ static void pump_transfers(unsigned long
 	if (transfer->rx_buf != NULL) {
 		drv_data->rx = transfer->rx_buf;
 		drv_data->rx_end = drv_data->rx + transfer->len;
-		pr_debug("rx_buf is %p, rx_end is %p\n", transfer->rx_buf, drv_data->rx_end);
+		pr_debug("rx_buf is %p, rx_end is %p\n", transfer->rx_buf,
+			 drv_data->rx_end);
 	} else {
 		drv_data->rx = NULL;
 	}
@@ -664,8 +671,9 @@ static void pump_transfers(unsigned long
 	drv_data->write = drv_data->tx ? chip->write : null_writer;
 	drv_data->read = drv_data->rx ? chip->read : null_reader;
 	drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
-	pr_debug("transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
-	       drv_data->write, chip->write, null_writer);
+	pr_debug
+	    ("transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
+	     drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
 
@@ -680,7 +688,8 @@ static void pump_transfers(unsigned long
 	}
 	write_FLAG(chip->flag);
 
-	pr_debug("now pumping a transfer: width is %d, len is %d\n",width,transfer->len);
+	pr_debug("now pumping a transfer: width is %d, len is %d\n", width,
+		 transfer->len);
 	/* Try to map dma buffer and do a dma transfer if successful */
 	/* use different way to r/w according to drv_data->cur_chip->enable_dma */
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
@@ -711,23 +720,25 @@ static void pump_transfers(unsigned long
 			pr_debug("doing autobuffer DMA out.\n");
 
 			/* no irq in autobuffer mode */
-			dma_config = (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
+			dma_config =
+			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
 			set_dma_config(CH_SPI, dma_config);
 			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
 			enable_dma(CH_SPI);
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) | (CFG_SPI_ENABLE << 14));
-			/* just return here, there can only be one transfer in this mode*/
+			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
+				   (CFG_SPI_ENABLE << 14));
+			/* just return here, there can only be one transfer in this mode */
 			message->status = 0;
 			giveback(drv_data);
 			return;
 		}
 
-		/* In dma mode, rx or tx must be NULL in one transfer*/
+		/* In dma mode, rx or tx must be NULL in one transfer */
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
 			pr_debug("doing DMA in.\n");
 
-			/* disable SPI before write to TDBR*/
+			/* disable SPI before write to TDBR */
 			write_CTRL(cr & ~BIT_CTL_ENABLE);
 
 			/* clear tx reg soformer data is not shifted out */
@@ -735,14 +746,16 @@ static void pump_transfers(unsigned long
 
 			set_dma_x_count(CH_SPI, drv_data->len);
 
-			/* start dma*/
+			/* start dma */
 			dma_enable_irq(CH_SPI);
 			dma_config = (WNR | RESTART | dma_width | DI_EN);
 			set_dma_config(CH_SPI, dma_config);
 			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->rx);
 			enable_dma(CH_SPI);
 
-			cr |= CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE << 14);
+			cr |=
+			    CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE <<
+							      14);
 			/* set transfer mode, and enable SPI */
 			write_CTRL(cr);
 		} else if (drv_data->tx != NULL) {
@@ -754,7 +767,8 @@ static void pump_transfers(unsigned long
 			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
 			enable_dma(CH_SPI);
 
-			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) | (CFG_SPI_ENABLE << 14));
+			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
+				   (CFG_SPI_ENABLE << 14));
 
 		}
 	} else {		/* IO mode write then read */
@@ -763,10 +777,13 @@ static void pump_transfers(unsigned long
 
 		write_STAT(BIT_STAT_CLR);
 
-		if (drv_data->tx != NULL && drv_data->rx != NULL) { /* full duplex mode */
-			ASSERT((drv_data->tx_end - drv_data->tx) == (drv_data->rx_end - drv_data->rx));
+		if (drv_data->tx != NULL && drv_data->rx != NULL) {	/* full duplex mode */
+			BUG_ON((drv_data->tx_end - drv_data->tx) !=
+			       (drv_data->rx_end - drv_data->rx));
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
-			cr |= CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE << 14);
+			cr |=
+			    CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE <<
+							    14);
 			pr_debug("IO duplex: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -776,9 +793,11 @@ static void pump_transfers(unsigned long
 
 			if (drv_data->tx != drv_data->tx_end)
 				tranf_success = 0;
-		} else if (drv_data->tx != NULL) {        /* write only half duplex */
+		} else if (drv_data->tx != NULL) {	/* write only half duplex */
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
-			cr |= CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE << 14);
+			cr |=
+			    CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE <<
+							    14);
 			pr_debug("IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -788,10 +807,12 @@ static void pump_transfers(unsigned long
 
 			if (drv_data->tx != drv_data->tx_end)
 				tranf_success = 0;
-		} else if (drv_data->rx != NULL) {        /* read only half duplex */
+		} else if (drv_data->rx != NULL) {	/* read only half duplex */
 
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* cleare the TIMOD bits */
-			cr |= CFG_SPI_READ | (width << 8) | (CFG_SPI_ENABLE << 14);
+			cr |=
+			    CFG_SPI_READ | (width << 8) | (CFG_SPI_ENABLE <<
+							   14);
 			pr_debug("IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -809,7 +830,7 @@ static void pump_transfers(unsigned long
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len;
 
-			/* Move to next transfer of this msg*/
+			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
 		}
 
@@ -842,20 +863,21 @@ static void pump_messages(struct work_st
 
 	/* Extract head of queue */
 	drv_data->cur_msg = list_entry(drv_data->queue.next,
-					struct spi_message, queue);
+				       struct spi_message, queue);
 	list_del_init(&drv_data->cur_msg->queue);
 
-	/* Initial message state*/
+	/* Initial message state */
 	drv_data->cur_msg->state = START_STATE;
 	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
-						struct spi_transfer,
-						transfer_list);
+					    struct spi_transfer, transfer_list);
 
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
 	restore_state(drv_data);
-	pr_debug("got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
-	       drv_data->cur_chip->baud, drv_data->cur_chip->flag, drv_data->cur_chip->ctl_reg);
+	pr_debug
+	    ("got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
+	     drv_data->cur_chip->baud, drv_data->cur_chip->flag,
+	     drv_data->cur_chip->ctl_reg);
 	pr_debug("the first transfer len is %d\n", drv_data->cur_transfer->len);
 
 	/* Mark as busy and launch transfers */
@@ -902,7 +924,9 @@ static int setup(struct spi_device *spi)
 	u8 spi_flg;
 
 	if (chip_select_flag & (1 << (spi->chip_select))) {
-		printk(KERN_ERR "spi_bfin: error: %s is using the same chip selection as another device.\n", spi->modalias);
+		printk(KERN_ERR
+		       "spi_bfin: error: %s is using the same chip selection as another device.\n",
+		       spi->modalias);
 		return -ENODEV;
 	}
 	chip_select_flag |= (1 << (spi->chip_select));
@@ -927,7 +951,7 @@ static int setup(struct spi_device *spi)
 	/* chip_info isn't always needed */
 	if (chip_info) {
 		chip->enable_dma = chip_info->enable_dma != 0
-					&& drv_data->master_info->enable_dma;
+		    && drv_data->master_info->enable_dma;
 		chip->ctl_reg = chip_info->ctl_reg;
 		chip->bits_per_word = chip_info->bits_per_word;
 		chip->cs_change_per_word = chip_info->cs_change_per_word;
@@ -944,10 +968,12 @@ static int setup(struct spi_device *spi)
 	if (chip->enable_dma && !dma_requested) {
 		/* register dma irq handler */
 		if (request_dma(CH_SPI, "BF53x_SPI_DMA") < 0) {
-			pr_debug("Unable to request BlackFin SPI DMA channel\n");
+			pr_debug
+			    ("Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
-		if (set_dma_callback(CH_SPI, (void *)dma_irq_handler, drv_data) < 0) {
+		if (set_dma_callback(CH_SPI, (void *)dma_irq_handler, drv_data)
+		    < 0) {
 			pr_debug("Unable to set dma callback\n");
 			return -EPERM;
 		}
@@ -959,30 +985,40 @@ static int setup(struct spi_device *spi)
 	   SPI_BAUD, not the real baudrate */
 	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
 	spi_flg = ~(1 << (spi->chip_select));
-	chip->flag = ((u16)spi_flg << 8 ) | (1 << (spi->chip_select));
+	chip->flag = ((u16) spi_flg << 8) | (1 << (spi->chip_select));
 	chip->chip_select_num = spi->chip_select;
 
 	if (chip->bits_per_word <= 8) {
 		chip->n_bytes = 1;
 		chip->width = CFG_SPI_WORDSIZE8;
-		chip->read = chip->cs_change_per_word? u8_cs_chg_reader: u8_reader;
-		chip->write = chip->cs_change_per_word? u8_cs_chg_writer: u8_writer;
-		chip->duplex = chip->cs_change_per_word? u8_cs_chg_duplex: u8_duplex;
-		pr_debug("8bit: chip->write is %p, u8_writer is %p\n", chip->write, u8_writer);
+		chip->read =
+		    chip->cs_change_per_word ? u8_cs_chg_reader : u8_reader;
+		chip->write =
+		    chip->cs_change_per_word ? u8_cs_chg_writer : u8_writer;
+		chip->duplex =
+		    chip->cs_change_per_word ? u8_cs_chg_duplex : u8_duplex;
+		pr_debug("8bit: chip->write is %p, u8_writer is %p\n",
+			 chip->write, u8_writer);
 	} else if (spi->bits_per_word <= 16) {
 		chip->n_bytes = 2;
 		chip->width = CFG_SPI_WORDSIZE16;
-		chip->read = chip->cs_change_per_word? u16_cs_chg_reader: u16_reader;
-		chip->write = chip->cs_change_per_word? u16_cs_chg_writer: u16_writer;
-		chip->duplex = chip->cs_change_per_word? u16_cs_chg_duplex: u16_duplex;
-		pr_debug("16bit: chip->write is %p, u16_writer is %p\n", chip->write, u16_writer);
+		chip->read =
+		    chip->cs_change_per_word ? u16_cs_chg_reader : u16_reader;
+		chip->write =
+		    chip->cs_change_per_word ? u16_cs_chg_writer : u16_writer;
+		chip->duplex =
+		    chip->cs_change_per_word ? u16_cs_chg_duplex : u16_duplex;
+		pr_debug("16bit: chip->write is %p, u16_writer is %p\n",
+			 chip->write, u16_writer);
 	} else {
 		dev_err(&spi->dev, "invalid wordsize\n");
 		kfree(chip);
 		return -ENODEV;
 	}
-	pr_debug("setup spi chip %s, width is %d, dma is %d, ctl_reg is 0x%x, flag_reg is 0x%x\n",
-	       spi->modalias, chip->width, chip->enable_dma, chip->ctl_reg, chip->flag);
+	pr_debug
+	    ("setup spi chip %s, width is %d, dma is %d, ctl_reg is 0x%x, flag_reg is 0x%x\n",
+	     spi->modalias, chip->width, chip->enable_dma, chip->ctl_reg,
+	     chip->flag);
 	spi_set_ctldata(spi, chip);
 
 	return 0;
@@ -1006,12 +1042,12 @@ static int init_queue(struct driver_data
 
 	/* init transfer tasklet */
 	tasklet_init(&drv_data->pump_transfers,
-			pump_transfers,	(unsigned long)drv_data);
+		     pump_transfers, (unsigned long)drv_data);
 
 	/* init messages workqueue */
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
-	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+	drv_data->workqueue =
+	    create_singlethread_workqueue(drv_data->master->cdev.dev->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
@@ -1129,7 +1165,7 @@ static int bfin5xx_spi_probe(struct plat
 	pr_debug("controller probe successfully\n");
 	return status;
 
-out_error_queue_alloc:
+      out_error_queue_alloc:
 	destroy_queue(drv_data);
 	spi_master_put(master);
 	return status;
@@ -1181,8 +1217,7 @@ static int suspend_devices(struct device
 {
 	pm_message_t *state = pm_message;
 
-	if (dev->power.power_state.event != state->event &&
-	    dev->driver != NULL) {
+	if (dev->power.power_state.event != state->event && dev->driver != NULL) {
 		dev_warn(dev, "pm state does not match request\n");
 		return -1;
 	}
@@ -1231,15 +1266,14 @@ static int bfin5xx_spi_resume(struct pla
 #else
 #define bfin5xx_spi_suspend NULL
 #define bfin5xx_spi_resume NULL
-#endif /* CONFIG_PM */
-
+#endif				/* CONFIG_PM */
 
 static struct platform_driver driver = {
 	.driver = {
-		.name = "bfin-spi-master",
-		.bus = &platform_bus_type,
-		.owner = THIS_MODULE,
-	},
+		   .name = "bfin-spi-master",
+		   .bus = &platform_bus_type,
+		   .owner = THIS_MODULE,
+		   },
 	.probe = bfin5xx_spi_probe,
 	.remove = __devexit_p(bfin5xx_spi_remove),
 	.shutdown = bfin5xx_spi_shutdown,
@@ -1252,10 +1286,12 @@ static int __init bfin5xx_spi_init(void)
 	platform_driver_register(&driver);
 	return 0;
 }
+
 module_init(bfin5xx_spi_init);
 
 static void __exit bfin5xx_spi_exit(void)
 {
 	platform_driver_unregister(&driver);
 }
+
 module_exit(bfin5xx_spi_exit);
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
