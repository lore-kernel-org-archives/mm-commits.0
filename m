From: akpm@linux-foundation.org
Subject: + blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch added to -mm tree
Date: Sun, 29 Apr 2007 01:33:53 -0700
Message-ID: <200704290833.l3T8XrUf012128@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbXD2Id5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 04:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin spi controller driver: update according to David Brownell's review
has been added to the -mm tree.  Its filename is
     blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin spi controller driver: update according to David Brownell's review
From: Bryan Wu <bryan.wu@analog.com>

(http://lkml.org/lkml/2007/4/16/333)

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig       |   11 -
 drivers/spi/Makefile      |    4 
 drivers/spi/spi_bfin5xx.c |  337 +++++++++++++++++++-----------------
 3 files changed, 189 insertions(+), 163 deletions(-)

diff -puN drivers/spi/Kconfig~blackfin-spi-controller-driver-update-according-to-david-brownells-review drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~blackfin-spi-controller-driver-update-according-to-david-brownells-review
+++ a/drivers/spi/Kconfig
@@ -58,6 +58,12 @@ config SPI_ATMEL
 	  This selects a driver for the Atmel SPI Controller, present on
 	  many AT32 (AVR32) and AT91 (ARM) chips.
 
+config SPI_BFIN
+	tristate "SPI controller driver for ADI Blackfin5xx"
+	depends on SPI_MASTER && BFIN
+	help
+	  This is the SPI controller master driver for Blackfin 5xx processor.
+
 config SPI_BITBANG
 	tristate "Bitbanging SPI master"
 	depends on SPI_MASTER && EXPERIMENTAL
@@ -156,11 +162,6 @@ config SPI_AT25
 #
 # Add new SPI protocol masters in alphabetical order above this line
 #
-config SPI_BFIN
-	tristate "SPI controller driver for ADI Blackfin5xx"
-	depends on SPI_MASTER && BFIN
-	help
-	  This is the SPI controller master driver for Blackfin 5xx processor.
 
 # (slave support would go here)
 
diff -puN drivers/spi/Makefile~blackfin-spi-controller-driver-update-according-to-david-brownells-review drivers/spi/Makefile
--- a/drivers/spi/Makefile~blackfin-spi-controller-driver-update-according-to-david-brownells-review
+++ a/drivers/spi/Makefile
@@ -11,8 +11,9 @@ endif
 obj-$(CONFIG_SPI_MASTER)		+= spi.o
 
 # SPI master controller drivers (bus)
-obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
 obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
+obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
+obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
@@ -20,7 +21,6 @@ obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uw
 obj-$(CONFIG_SPI_MPC83xx)		+= spi_mpc83xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
-obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-controller-driver-update-according-to-david-brownells-review drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-controller-driver-update-according-to-david-brownells-review
+++ a/drivers/spi/spi_bfin5xx.c
@@ -76,7 +76,6 @@ DEFINE_SPI_REG(SHAW, 0x18)
 #define QUEUE_RUNNING 0
 #define QUEUE_STOPPED 1
 int dma_requested;
-char chip_select_flag;
 
 struct driver_data {
 	/* Driver model hookup */
@@ -175,8 +174,9 @@ static int flush(struct driver_data *drv
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	do {
-	} while (!(read_STAT() & BIT_STAT_SPIF) && limit--);
+	while (!(read_STAT() & BIT_STAT_SPIF) && limit--)
+		continue;
+
 	write_STAT(BIT_STAT_CLR);
 
 	return limit;
@@ -192,42 +192,50 @@ static void restore_state(struct driver_
 	bfin_spi_disable(drv_data);
 	pr_debug("restoring spi ctl state\n");
 
-#if defined(CONFIG_BF534)||defined(CONFIG_BF536)||defined(CONFIG_BF537)
-	if (chip->chip_select_num == 1) {
-		pr_debug("set for chip select 1\n");
+#if defined(CONFIG_BF534) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
+	pr_debug("chip select number is %d\n", chip->chip_select_num);
+
+	switch (chip->chip_select_num) {
+	case 1:
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3c00);
 		SSYNC();
+		break;
 
-	} else if (chip->chip_select_num == 2 || chip->chip_select_num == 3) {
-		pr_debug("set for chip select 2\n");
+	case 2:
+	case 3:
 		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJSE_SPI);
 		SSYNC();
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
 		SSYNC();
+		break;
 
-	} else if (chip->chip_select_num == 4) {
+	case 4:
 		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS4E_SPI);
 		SSYNC();
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3840);
 		SSYNC();
+		break;
 
-	} else if (chip->chip_select_num == 5) {
+	case 5:
 		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS5E_SPI);
 		SSYNC();
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3820);
 		SSYNC();
+		break;
 
-	} else if (chip->chip_select_num == 6) {
+	case 6:
 		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS6E_SPI);
 		SSYNC();
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3810);
 		SSYNC();
+		break;
 
-	} else if (chip->chip_select_num == 7) {
+	case 7:
 		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJCE_SPI);
 		SSYNC();
 		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
 		SSYNC();
+		break;
 	}
 #endif
 
@@ -251,8 +259,8 @@ static void null_writer(struct driver_da
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(0);
-		do {
-		} while ((read_STAT() & BIT_STAT_TXS));
+		while ((read_STAT() & BIT_STAT_TXS))
+			continue;
 		drv_data->tx += n_bytes;
 	}
 }
@@ -263,8 +271,8 @@ static void null_reader(struct driver_da
 	dummy_read();
 
 	while (drv_data->rx < drv_data->rx_end) {
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		dummy_read();
 		drv_data->rx += n_bytes;
 	}
@@ -275,14 +283,14 @@ static void u8_writer(struct driver_data
 	pr_debug("cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
-		do {
-		} while (read_STAT() & BIT_STAT_TXS);
+		while (read_STAT() & BIT_STAT_TXS)
+			continue;
 		++drv_data->tx;
 	}
 
 	/* poll for SPI completion before returning */
-	do {
-	} while (!(read_STAT() & BIT_STAT_SPIF));
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u8_cs_chg_writer(struct driver_data *drv_data)
@@ -294,10 +302,10 @@ static void u8_cs_chg_writer(struct driv
 		SSYNC();
 
 		write_TDBR(*(u8 *) (drv_data->tx));
-		do {
-		} while (read_STAT() & BIT_STAT_TXS);
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
+		while (read_STAT() & BIT_STAT_TXS)
+			continue;
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
@@ -318,13 +326,14 @@ static void u8_reader(struct driver_data
 	dummy_read();
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 	}
-	do {
-	} while (!(read_STAT() & BIT_STAT_RXS));
+
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
 	*(u8 *) (drv_data->rx) = read_SHAW();
 	++drv_data->rx;
 }
@@ -338,10 +347,10 @@ static void u8_cs_chg_reader(struct driv
 		SSYNC();
 
 		read_RDBR();	/* kick off */
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
@@ -358,10 +367,10 @@ static void u8_duplex(struct driver_data
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		++drv_data->rx;
 		++drv_data->tx;
@@ -377,10 +386,10 @@ static void u8_cs_chg_duplex(struct driv
 		SSYNC();
 
 		write_TDBR(*(u8 *) (drv_data->tx));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
@@ -398,14 +407,14 @@ static void u16_writer(struct driver_dat
 	pr_debug("cr16 is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
-		do {
-		} while ((read_STAT() & BIT_STAT_TXS));
+		while ((read_STAT() & BIT_STAT_TXS))
+			continue;
 		drv_data->tx += 2;
 	}
 
 	/* poll for SPI completion before returning */
-	do {
-	} while (!(read_STAT() & BIT_STAT_SPIF));
+	while (!(read_STAT() & BIT_STAT_SPIF))
+		continue;
 }
 
 static void u16_cs_chg_writer(struct driver_data *drv_data)
@@ -417,10 +426,10 @@ static void u16_cs_chg_writer(struct dri
 		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
-		do {
-		} while ((read_STAT() & BIT_STAT_TXS));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
+		while ((read_STAT() & BIT_STAT_TXS))
+			continue;
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
 		if (chip->cs_chg_udelay)
@@ -437,13 +446,14 @@ static void u16_reader(struct driver_dat
 	dummy_read();
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 	}
-	do {
-	} while (!(read_STAT() & BIT_STAT_RXS));
+
+	while (!(read_STAT() & BIT_STAT_RXS))
+		continue;
 	*(u16 *) (drv_data->rx) = read_SHAW();
 	drv_data->rx += 2;
 }
@@ -457,10 +467,10 @@ static void u16_cs_chg_reader(struct dri
 		SSYNC();
 
 		read_RDBR();	/* kick off */
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
@@ -477,10 +487,10 @@ static void u16_duplex(struct driver_dat
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u16 *) (drv_data->tx));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		drv_data->rx += 2;
 		drv_data->tx += 2;
@@ -496,10 +506,10 @@ static void u16_cs_chg_duplex(struct dri
 		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
-		do {
-		} while (!(read_STAT() & BIT_STAT_SPIF));
-		do {
-		} while (!(read_STAT() & BIT_STAT_RXS));
+		while (!(read_STAT() & BIT_STAT_SPIF))
+			continue;
+		while (!(read_STAT() & BIT_STAT_RXS))
+			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
 		SSYNC();
@@ -528,8 +538,9 @@ static void *next_transfer(struct driver
 		return DONE_STATE;
 }
 
-/* caller already set message->status; dma and pio irqs are blocked
- * give finished message back
+/*
+ * caller already set message->status;
+ * dma and pio irqs are blocked give finished message back
  */
 static void giveback(struct driver_data *drv_data)
 {
@@ -549,6 +560,7 @@ static void giveback(struct driver_data 
 				   struct spi_transfer, transfer_list);
 
 	msg->state = NULL;
+
 	/* disable chip select signal. And not stop spi in autobuffer mode */
 	if (drv_data->tx_dma != 0xFFFF) {
 		write_FLAG(0xFF00);
@@ -567,15 +579,19 @@ static irqreturn_t dma_irq_handler(int i
 	pr_debug("in dma_irq_handler\n");
 	clear_dma_irqstat(CH_SPI);
 
-	/* wait for the last transaction shifted out.  yes, these two
+	/*
+	 * wait for the last transaction shifted out.  yes, these two
 	 * while loops are supposed to be the same (see the HRM).
 	 */
 	if (drv_data->tx != NULL) {
-		while (bfin_read_SPI_STAT() & TXS) ;
-		while (bfin_read_SPI_STAT() & TXS) ;
+		while (bfin_read_SPI_STAT() & TXS)
+			continue;
+		while (bfin_read_SPI_STAT() & TXS)
+			continue;
 	}
 
-	while (!(bfin_read_SPI_STAT() & SPIF)) ;
+	while (!(bfin_read_SPI_STAT() & SPIF))
+		continue;
 
 	bfin_spi_disable(drv_data);
 
@@ -609,8 +625,11 @@ static void pump_transfers(unsigned long
 	transfer = drv_data->cur_transfer;
 	chip = drv_data->cur_chip;
 
-	/* if msg is error or done, report it back using complete() callback */
-	/* Handle for abort */
+	/*
+	 * if msg is error or done, report it back using complete() callback
+	 */
+
+	 /* Handle for abort */
 	if (message->state == ERROR_STATE) {
 		message->status = -EIO;
 		giveback(drv_data);
@@ -676,7 +695,6 @@ static void pump_transfers(unsigned long
 	     drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
-
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
@@ -690,8 +708,12 @@ static void pump_transfers(unsigned long
 
 	pr_debug("now pumping a transfer: width is %d, len is %d\n", width,
 		 transfer->len);
-	/* Try to map dma buffer and do a dma transfer if successful */
-	/* use different way to r/w according to drv_data->cur_chip->enable_dma */
+
+	/*
+	 * Try to map dma buffer and do a dma transfer if
+	 * successful use different way to r/w according to
+	 * drv_data->cur_chip->enable_dma
+	 */
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
 		write_STAT(BIT_STAT_CLR);
@@ -699,8 +721,8 @@ static void pump_transfers(unsigned long
 		clear_dma_irqstat(CH_SPI);
 		bfin_spi_disable(drv_data);
 
-		pr_debug("doing dma transfer\n");
 		/* config dma channel */
+		pr_debug("doing dma transfer\n");
 		if (width == CFG_SPI_WORDSIZE16) {
 			set_dma_x_count(CH_SPI, drv_data->len);
 			set_dma_x_modify(CH_SPI, 2);
@@ -711,9 +733,8 @@ static void pump_transfers(unsigned long
 			dma_width = WDSIZE_8;
 		}
 
-		/* Go baby, go */
 		/* set transfer width,direction. And enable spi */
-		cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
+		cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
@@ -727,6 +748,7 @@ static void pump_transfers(unsigned long
 			enable_dma(CH_SPI);
 			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) |
 				   (CFG_SPI_ENABLE << 14));
+
 			/* just return here, there can only be one transfer in this mode */
 			message->status = 0;
 			giveback(drv_data);
@@ -760,6 +782,7 @@ static void pump_transfers(unsigned long
 			write_CTRL(cr);
 		} else if (drv_data->tx != NULL) {
 			pr_debug("doing DMA out.\n");
+
 			/* start dma */
 			dma_enable_irq(CH_SPI);
 			dma_config = (RESTART | dma_width | DI_EN);
@@ -771,13 +794,14 @@ static void pump_transfers(unsigned long
 				   (CFG_SPI_ENABLE << 14));
 
 		}
-	} else {		/* IO mode write then read */
-		/* Go baby, go */
+	} else {
+		/* IO mode write then read */
 		pr_debug("doing IO transfer\n");
 
 		write_STAT(BIT_STAT_CLR);
 
-		if (drv_data->tx != NULL && drv_data->rx != NULL) {	/* full duplex mode */
+		if (drv_data->tx != NULL && drv_data->rx != NULL) {
+			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
@@ -793,7 +817,8 @@ static void pump_transfers(unsigned long
 
 			if (drv_data->tx != drv_data->tx_end)
 				tranf_success = 0;
-		} else if (drv_data->tx != NULL) {	/* write only half duplex */
+		} else if (drv_data->tx != NULL) {
+			/* write only half duplex */
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
 			cr |=
 			    CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE <<
@@ -807,8 +832,8 @@ static void pump_transfers(unsigned long
 
 			if (drv_data->tx != drv_data->tx_end)
 				tranf_success = 0;
-		} else if (drv_data->rx != NULL) {	/* read only half duplex */
-
+		} else if (drv_data->rx != NULL) {
+			/* read only half duplex */
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* cleare the TIMOD bits */
 			cr |=
 			    CFG_SPI_READ | (width << 8) | (CFG_SPI_ENABLE <<
@@ -887,7 +912,10 @@ static void pump_messages(struct work_st
 	spin_unlock_irqrestore(&drv_data->lock, flags);
 }
 
-/* got a msg to transfer, queue it in drv_data->queue. And kick off message pumper */
+/*
+ * got a msg to transfer, queue it in drv_data->queue.
+ * And kick off message pumper
+ */
 static int transfer(struct spi_device *spi, struct spi_message *msg)
 {
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
@@ -923,16 +951,15 @@ static int setup(struct spi_device *spi)
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
 	u8 spi_flg;
 
-	if (chip_select_flag & (1 << (spi->chip_select))) {
-		printk(KERN_ERR
-		       "spi_bfin: error: %s is using the same chip selection as another device.\n",
-		       spi->modalias);
-		return -ENODEV;
+	/* Abort device setup if requested features are not supported */
+	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
+		dev_err(&spi->dev, "requested mode not fully supported\n");
+		return -EINVAL;
 	}
-	chip_select_flag |= (1 << (spi->chip_select));
 
+	/* Zero (the default) here means 8 bits */
 	if (!spi->bits_per_word)
-		spi->bits_per_word = 16;
+		spi->bits_per_word = 8;
 
 	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
 		return -EINVAL;
@@ -958,13 +985,20 @@ static int setup(struct spi_device *spi)
 		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
 	}
 
+	/* translate common spi framework into our register */
 	if (spi->mode & SPI_CPOL)
-		chip->ctl_reg &= CPOL;
+		chip->ctl_reg |= CPOL;
 	if (spi->mode & SPI_CPHA)
-		chip->ctl_reg &= CPHA;
-
-	/* if any one SPI chip is registered and wants DMA, request the
-	   DMA channel for it */
+		chip->ctl_reg |= CPHA;
+	if (spi->mode & SPI_LSB_FIRST)
+		chip->ctl_reg |= LSBF;
+	/* we dont support running in slave mode (yet?) */
+	chip->ctl_reg |= MSTR;
+
+	/*
+	 * if any one SPI chip is registered and wants DMA, request the
+	 * DMA channel for it
+	 */
 	if (chip->enable_dma && !dma_requested) {
 		/* register dma irq handler */
 		if (request_dma(CH_SPI, "BF53x_SPI_DMA") < 0) {
@@ -981,50 +1015,59 @@ static int setup(struct spi_device *spi)
 		dma_requested = 1;
 	}
 
-	/* Notice: for blackfin, the speed_hz is the value of register
-	   SPI_BAUD, not the real baudrate */
+	/*
+	 * Notice: for blackfin, the speed_hz is the value of register
+	 * SPI_BAUD, not the real baudrate
+	 */
 	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
 	spi_flg = ~(1 << (spi->chip_select));
 	chip->flag = ((u16) spi_flg << 8) | (1 << (spi->chip_select));
 	chip->chip_select_num = spi->chip_select;
 
-	if (chip->bits_per_word <= 8) {
+	switch (chip->bits_per_word) {
+	case 8:
 		chip->n_bytes = 1;
 		chip->width = CFG_SPI_WORDSIZE8;
-		chip->read =
-		    chip->cs_change_per_word ? u8_cs_chg_reader : u8_reader;
-		chip->write =
-		    chip->cs_change_per_word ? u8_cs_chg_writer : u8_writer;
-		chip->duplex =
-		    chip->cs_change_per_word ? u8_cs_chg_duplex : u8_duplex;
-		pr_debug("8bit: chip->write is %p, u8_writer is %p\n",
-			 chip->write, u8_writer);
-	} else if (spi->bits_per_word <= 16) {
+		chip->read = chip->cs_change_per_word ?
+			u8_cs_chg_reader : u8_reader;
+		chip->write = chip->cs_change_per_word ?
+			u8_cs_chg_writer : u8_writer;
+		chip->duplex = chip->cs_change_per_word ?
+			u8_cs_chg_duplex : u8_duplex;
+		break;
+
+	case 16:
 		chip->n_bytes = 2;
 		chip->width = CFG_SPI_WORDSIZE16;
-		chip->read =
-		    chip->cs_change_per_word ? u16_cs_chg_reader : u16_reader;
-		chip->write =
-		    chip->cs_change_per_word ? u16_cs_chg_writer : u16_writer;
-		chip->duplex =
-		    chip->cs_change_per_word ? u16_cs_chg_duplex : u16_duplex;
-		pr_debug("16bit: chip->write is %p, u16_writer is %p\n",
-			 chip->write, u16_writer);
-	} else {
-		dev_err(&spi->dev, "invalid wordsize\n");
+		chip->read = chip->cs_change_per_word ?
+			u16_cs_chg_reader : u16_reader;
+		chip->write = chip->cs_change_per_word ?
+			u16_cs_chg_writer : u16_writer;
+		chip->duplex = chip->cs_change_per_word ?
+			u16_cs_chg_duplex : u16_duplex;
+		break;
+
+	default:
+		dev_err(&spi->dev, "%d bits_per_word is not supported\n",
+				chip->bits_per_word);
 		kfree(chip);
 		return -ENODEV;
 	}
-	pr_debug
-	    ("setup spi chip %s, width is %d, dma is %d, ctl_reg is 0x%x, flag_reg is 0x%x\n",
-	     spi->modalias, chip->width, chip->enable_dma, chip->ctl_reg,
-	     chip->flag);
+
+	pr_debug("setup spi chip %s, width is %d, dma is %d,",
+			spi->modalias, chip->width, chip->enable_dma);
+	pr_debug("ctl_reg is 0x%x, flag_reg is 0x%x\n",
+			chip->ctl_reg, chip->flag);
+
 	spi_set_ctldata(spi, chip);
 
 	return 0;
 }
 
-/* callback for spi framework. clean driver specific data */
+/*
+ * callback for spi framework.
+ * clean driver specific data
+ */
 static void cleanup(const struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
@@ -1032,7 +1075,7 @@ static void cleanup(const struct spi_dev
 	kfree(chip);
 }
 
-static int init_queue(struct driver_data *drv_data)
+static inline int init_queue(struct driver_data *drv_data)
 {
 	INIT_LIST_HEAD(&drv_data->queue);
 	spin_lock_init(&drv_data->lock);
@@ -1054,7 +1097,7 @@ static int init_queue(struct driver_data
 	return 0;
 }
 
-static int start_queue(struct driver_data *drv_data)
+static inline int start_queue(struct driver_data *drv_data)
 {
 	unsigned long flags;
 
@@ -1076,7 +1119,7 @@ static int start_queue(struct driver_dat
 	return 0;
 }
 
-static int stop_queue(struct driver_data *drv_data)
+static inline int stop_queue(struct driver_data *drv_data)
 {
 	unsigned long flags;
 	unsigned limit = 500;
@@ -1084,10 +1127,12 @@ static int stop_queue(struct driver_data
 
 	spin_lock_irqsave(&drv_data->lock, flags);
 
-	/* This is a bit lame, but is optimized for the common execution path.
+	/*
+	 * This is a bit lame, but is optimized for the common execution path.
 	 * A wait_queue on the drv_data->busy could be used, but then the common
 	 * execution path (pump_messages) would be required to call wake_up or
-	 * friends on every SPI message. Do this instead */
+	 * friends on every SPI message. Do this instead
+	 */
 	drv_data->run = QUEUE_STOPPED;
 	while (!list_empty(&drv_data->queue) && drv_data->busy && limit--) {
 		spin_unlock_irqrestore(&drv_data->lock, flags);
@@ -1103,7 +1148,7 @@ static int stop_queue(struct driver_data
 	return status;
 }
 
-static int destroy_queue(struct driver_data *drv_data)
+static inline int destroy_queue(struct driver_data *drv_data)
 {
 	int status;
 
@@ -1116,7 +1161,7 @@ static int destroy_queue(struct driver_d
 	return 0;
 }
 
-static int bfin5xx_spi_probe(struct platform_device *pdev)
+static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct bfin5xx_spi_master *platform_info;
@@ -1126,7 +1171,7 @@ static int bfin5xx_spi_probe(struct plat
 
 	platform_info = dev->platform_data;
 
-	/* Allocate master with space for drv_data and null dma buffer */
+	/* Allocate master with space for drv_data */
 	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);
 	if (!master) {
 		dev_err(&pdev->dev, "can not alloc spi_master\n");
@@ -1172,7 +1217,7 @@ static int bfin5xx_spi_probe(struct plat
 }
 
 /* stop hardware and remove the driver */
-static int bfin5xx_spi_remove(struct platform_device *pdev)
+static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int status = 0;
@@ -1203,31 +1248,12 @@ static int bfin5xx_spi_remove(struct pla
 	return 0;
 }
 
-/* PM, do nothing now */
 #ifdef CONFIG_PM
-static int suspend_devices(struct device *dev, void *pm_message)
-{
-	pm_message_t *state = pm_message;
-
-	if (dev->power.power_state.event != state->event && dev->driver != NULL) {
-		dev_warn(dev, "pm state does not match request\n");
-		return -1;
-	}
-
-	return 0;
-}
-
 static int bfin5xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int status = 0;
 
-	/* Check all childern for current power state */
-	if (device_for_each_child(&pdev->dev, &state, suspend_devices) != 0) {
-		dev_warn(&pdev->dev, "suspend aborted\n");
-		return -1;
-	}
-
 	status = stop_queue(drv_data);
 	if (status != 0)
 		return status;
@@ -1260,7 +1286,7 @@ static int bfin5xx_spi_resume(struct pla
 #define bfin5xx_spi_resume NULL
 #endif				/* CONFIG_PM */
 
-static struct platform_driver driver = {
+static struct platform_driver bfin5xx_spi_driver = {
 	.driver = {
 		   .name = "bfin-spi-master",
 		   .bus = &platform_bus_type,
@@ -1274,15 +1300,14 @@ static struct platform_driver driver = {
 
 static int __init bfin5xx_spi_init(void)
 {
-	platform_driver_register(&driver);
-	return 0;
+	return platform_driver_register(&bfin5xx_spi_driver);
 }
 
 module_init(bfin5xx_spi_init);
 
 static void __exit bfin5xx_spi_exit(void)
 {
-	platform_driver_unregister(&driver);
+	platform_driver_unregister(&bfin5xx_spi_driver);
 }
 
 module_exit(bfin5xx_spi_exit);
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
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
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
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
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
