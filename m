From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-handle-multiple-spi_masters.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:50:12 -0700
Message-ID: <200710302250.l9UMoD2b032055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834AbXJ3WuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin: handle multiple spi_masters
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-handle-multiple-spi_masters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin: handle multiple spi_masters
From: Bryan Wu <bryan.wu@analog.com>

Move global SPI regs_base and dma_ch to struct driver_data.  Test on BF54x SPI
Flash with 2 spi_master devices enabled.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |  371 ++++++++++++++++++------------------
 1 file changed, 189 insertions(+), 182 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-handle-multiple-spi_masters drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-handle-multiple-spi_masters
+++ a/drivers/spi/spi_bfin5xx.c
@@ -61,31 +61,14 @@ MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
 
-#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
+#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07) == 0)
 
-static u32 spi_dma_ch;
-static u32 spi_regs_base;
-
-#define DEFINE_SPI_REG(reg, off) \
-static inline u16 read_##reg(void) \
-	{ return bfin_read16(spi_regs_base + off); } \
-static inline void write_##reg(u16 v) \
-	{bfin_write16(spi_regs_base + off, v); }
-
-DEFINE_SPI_REG(CTRL, 0x00)
-DEFINE_SPI_REG(FLAG, 0x04)
-DEFINE_SPI_REG(STAT, 0x08)
-DEFINE_SPI_REG(TDBR, 0x0C)
-DEFINE_SPI_REG(RDBR, 0x10)
-DEFINE_SPI_REG(BAUD, 0x14)
-DEFINE_SPI_REG(SHAW, 0x18)
-#define START_STATE ((void*)0)
-#define RUNNING_STATE ((void*)1)
-#define DONE_STATE ((void*)2)
-#define ERROR_STATE ((void*)-1)
-#define QUEUE_RUNNING 0
-#define QUEUE_STOPPED 1
-int dma_requested;
+#define START_STATE	((void *)0)
+#define RUNNING_STATE	((void *)1)
+#define DONE_STATE	((void *)2)
+#define ERROR_STATE	((void *)-1)
+#define QUEUE_RUNNING	0
+#define QUEUE_STOPPED	1
 
 struct driver_data {
 	/* Driver model hookup */
@@ -94,6 +77,9 @@ struct driver_data {
 	/* SPI framework hookup */
 	struct spi_master *master;
 
+	/* Regs base of SPI controller */
+	u32 regs_base;
+
 	/* BFIN hookup */
 	struct bfin5xx_spi_master *master_info;
 
@@ -118,9 +104,14 @@ struct driver_data {
 	void *tx_end;
 	void *rx;
 	void *rx_end;
+
+	/* DMA stuffs */
+	int dma_channel;
 	int dma_mapped;
+	int dma_requested;
 	dma_addr_t rx_dma;
 	dma_addr_t tx_dma;
+
 	size_t rx_map_len;
 	size_t tx_map_len;
 	u8 n_bytes;
@@ -147,20 +138,34 @@ struct chip_data {
 	void (*duplex) (struct driver_data *);
 };
 
+#define DEFINE_SPI_REG(reg, off) \
+static inline u16 read_##reg(struct driver_data *drv_data) \
+	{ return bfin_read16(drv_data->regs_base + off); } \
+static inline void write_##reg(struct driver_data *drv_data, u16 v) \
+	{ bfin_write16(drv_data->regs_base + off, v); }
+
+DEFINE_SPI_REG(CTRL, 0x00)
+DEFINE_SPI_REG(FLAG, 0x04)
+DEFINE_SPI_REG(STAT, 0x08)
+DEFINE_SPI_REG(TDBR, 0x0C)
+DEFINE_SPI_REG(RDBR, 0x10)
+DEFINE_SPI_REG(BAUD, 0x14)
+DEFINE_SPI_REG(SHAW, 0x18)
+
 static void bfin_spi_enable(struct driver_data *drv_data)
 {
 	u16 cr;
 
-	cr = read_CTRL();
-	write_CTRL(cr | BIT_CTL_ENABLE);
+	cr = read_CTRL(drv_data);
+	write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
 }
 
 static void bfin_spi_disable(struct driver_data *drv_data)
 {
 	u16 cr;
 
-	cr = read_CTRL();
-	write_CTRL(cr & (~BIT_CTL_ENABLE));
+	cr = read_CTRL(drv_data);
+	write_CTRL(drv_data, (cr & (~BIT_CTL_ENABLE)));
 }
 
 /* Caculate the SPI_BAUD register value based on input HZ */
@@ -180,32 +185,32 @@ static int flush(struct driver_data *drv
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	while (!(read_STAT() & BIT_STAT_SPIF) && limit--)
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
 		continue;
 
-	write_STAT(BIT_STAT_CLR);
+	write_STAT(drv_data, BIT_STAT_CLR);
 
 	return limit;
 }
 
 /* Chip select operation functions for cs_change flag */
-static void cs_active(struct chip_data *chip)
+static void cs_active(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG();
+	u16 flag = read_FLAG(drv_data);
 
 	flag |= chip->flag;
 	flag &= ~(chip->flag << 8);
 
-	write_FLAG(flag);
+	write_FLAG(drv_data, flag);
 }
 
-static void cs_deactive(struct chip_data *chip)
+static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG();
+	u16 flag = read_FLAG(drv_data);
 
 	flag |= (chip->flag << 8);
 
-	write_FLAG(flag);
+	write_FLAG(drv_data, flag);
 }
 
 #define MAX_SPI_SSEL	7
@@ -217,16 +222,16 @@ static int restore_state(struct driver_d
 	int ret = 0;
 
 	/* Clear status and disable clock */
-	write_STAT(BIT_STAT_CLR);
+	write_STAT(drv_data, BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	cs_deactive(chip);
-	write_BAUD(chip->baud);
+	cs_deactive(drv_data, chip);
+	write_BAUD(drv_data, chip->baud);
 	chip->ctl_reg &= (~BIT_CTL_TIMOD);
 	chip->ctl_reg |= (chip->width << 8);
-	write_CTRL(chip->ctl_reg);
+	write_CTRL(drv_data, chip->ctl_reg);
 
 	bfin_spi_enable(drv_data);
 
@@ -239,10 +244,10 @@ static int restore_state(struct driver_d
 }
 
 /* used to kick off transfer in rx mode */
-static unsigned short dummy_read(void)
+static unsigned short dummy_read(struct driver_data *drv_data)
 {
 	unsigned short tmp;
-	tmp = read_RDBR();
+	tmp = read_RDBR(drv_data);
 	return tmp;
 }
 
@@ -251,8 +256,8 @@ static void null_writer(struct driver_da
 	u8 n_bytes = drv_data->n_bytes;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(0);
-		while ((read_STAT() & BIT_STAT_TXS))
+		write_TDBR(drv_data, 0);
+		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			continue;
 		drv_data->tx += n_bytes;
 	}
@@ -261,12 +266,12 @@ static void null_writer(struct driver_da
 static void null_reader(struct driver_data *drv_data)
 {
 	u8 n_bytes = drv_data->n_bytes;
-	dummy_read();
+	dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end) {
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		dummy_read();
+		dummy_read(drv_data);
 		drv_data->rx += n_bytes;
 	}
 }
@@ -274,15 +279,15 @@ static void null_reader(struct driver_da
 static void u8_writer(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
-		"cr8-s is 0x%x\n", read_STAT());
+		"cr8-s is 0x%x\n", read_STAT(drv_data));
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u8 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
 		++drv_data->tx;
 	}
@@ -293,16 +298,16 @@ static void u8_cs_chg_writer(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(chip);
+		cs_active(drv_data, chip);
 
-		write_TDBR(*(u8 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -313,27 +318,27 @@ static void u8_cs_chg_writer(struct driv
 static void u8_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
-		"cr-8 is 0x%x\n", read_STAT());
+		"cr-8 is 0x%x\n", read_STAT(drv_data));
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(0xFFFF);
+	write_TDBR(drv_data, 0xFFFF);
 
-	dummy_read();
+	dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u8 *) (drv_data->rx) = read_RDBR();
+		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
 
-	while (!(read_STAT() & BIT_STAT_RXS))
+	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 		continue;
-	*(u8 *) (drv_data->rx) = read_SHAW();
+	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
 
@@ -342,49 +347,49 @@ static void u8_cs_chg_reader(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(0xFFFF);
+	write_TDBR(drv_data, 0xFFFF);
 
-	cs_active(chip);
-	dummy_read();
+	cs_active(drv_data, chip);
+	dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		cs_active(chip);
-		*(u8 *) (drv_data->rx) = read_RDBR();
+		cs_active(drv_data, chip);
+		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
-	cs_deactive(chip);
+	cs_deactive(drv_data, chip);
 
-	while (!(read_STAT() & BIT_STAT_RXS))
+	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 		continue;
-	*(u8 *) (drv_data->rx) = read_SHAW();
+	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
 
 static void u8_duplex(struct driver_data *drv_data)
 {
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
-		write_TDBR(*(u8 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u8 *) (drv_data->rx) = read_RDBR();
+		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
@@ -395,19 +400,19 @@ static void u8_cs_chg_duplex(struct driv
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->rx < drv_data->rx_end) {
-		cs_active(chip);
+		cs_active(drv_data, chip);
 
-		write_TDBR(*(u8 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u8 *) (drv_data->rx) = read_RDBR();
-		cs_deactive(chip);
+		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -419,15 +424,15 @@ static void u8_cs_chg_duplex(struct driv
 static void u16_writer(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
-		"cr16 is 0x%x\n", read_STAT());
+		"cr16 is 0x%x\n", read_STAT(drv_data));
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u16 *) (drv_data->tx));
-		while ((read_STAT() & BIT_STAT_TXS))
+		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			continue;
 		drv_data->tx += 2;
 	}
@@ -438,16 +443,16 @@ static void u16_cs_chg_writer(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(chip);
+		cs_active(drv_data, chip);
 
-		write_TDBR(*(u16 *) (drv_data->tx));
-		while ((read_STAT() & BIT_STAT_TXS))
+		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			continue;
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -458,27 +463,27 @@ static void u16_cs_chg_writer(struct dri
 static void u16_reader(struct driver_data *drv_data)
 {
 	dev_dbg(&drv_data->pdev->dev,
-		"cr-16 is 0x%x\n", read_STAT());
+		"cr-16 is 0x%x\n", read_STAT(drv_data));
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(0xFFFF);
+	write_TDBR(drv_data, 0xFFFF);
 
-	dummy_read();
+	dummy_read(drv_data);
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u16 *) (drv_data->rx) = read_RDBR();
+		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
 
-	while (!(read_STAT() & BIT_STAT_RXS))
+	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 		continue;
-	*(u16 *) (drv_data->rx) = read_SHAW();
+	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
 
@@ -487,49 +492,49 @@ static void u16_cs_chg_reader(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
-	write_TDBR(0xFFFF);
+	write_TDBR(drv_data, 0xFFFF);
 
-	cs_active(chip);
-	dummy_read();
+	cs_active(drv_data, chip);
+	dummy_read(drv_data);
 
 	while (drv_data->rx < drv_data->rx_end) {
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		cs_active(chip);
-		*(u16 *) (drv_data->rx) = read_RDBR();
+		cs_active(drv_data, chip);
+		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
-	cs_deactive(chip);
+	cs_deactive(drv_data, chip);
 
-	while (!(read_STAT() & BIT_STAT_RXS))
+	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 		continue;
-	*(u16 *) (drv_data->rx) = read_SHAW();
+	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
 
 static void u16_duplex(struct driver_data *drv_data)
 {
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
-		write_TDBR(*(u16 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u16 *) (drv_data->rx) = read_RDBR();
+		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
@@ -540,19 +545,19 @@ static void u16_cs_chg_duplex(struct dri
 	struct chip_data *chip = drv_data->cur_chip;
 
 	/* poll for SPI completion before start */
-	while (!(read_STAT() & BIT_STAT_SPIF))
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 		continue;
 
 	while (drv_data->tx < drv_data->tx_end) {
-		cs_active(chip);
+		cs_active(drv_data, chip);
 
-		write_TDBR(*(u16 *) (drv_data->tx));
-		while (read_STAT() & BIT_STAT_TXS)
+		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
+		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
-		while (!(read_STAT() & BIT_STAT_RXS))
+		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
-		*(u16 *) (drv_data->rx) = read_RDBR();
-		cs_deactive(chip);
+		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
@@ -603,12 +608,12 @@ static void giveback(struct driver_data 
 
 	/* disable chip select signal. And not stop spi in autobuffer mode */
 	if (drv_data->tx_dma != 0xFFFF) {
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 		bfin_spi_disable(drv_data);
 	}
 
 	if (!drv_data->cs_change)
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 	if (msg->complete)
 		msg->complete(msg->context);
@@ -617,14 +622,14 @@ static void giveback(struct driver_data 
 static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
 	struct driver_data *drv_data = dev_id;
-	struct spi_message *msg = drv_data->cur_msg;
 	struct chip_data *chip = drv_data->cur_chip;
+	struct spi_message *msg = drv_data->cur_msg;
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
-	clear_dma_irqstat(spi_dma_ch);
+	clear_dma_irqstat(drv_data->dma_channel);
 
 	/* Wait for DMA to complete */
-	while (get_dma_curr_irqstat(spi_dma_ch) & DMA_RUN)
+	while (get_dma_curr_irqstat(drv_data->dma_channel) & DMA_RUN)
 		continue;
 
 	/*
@@ -634,18 +639,18 @@ static irqreturn_t dma_irq_handler(int i
 	 * register until it goes low for 2 successive reads
 	 */
 	if (drv_data->tx != NULL) {
-		while ((read_STAT() & TXS) ||
-		       (read_STAT() & TXS))
+		while ((read_STAT(drv_data) & TXS) ||
+		       (read_STAT(drv_data) & TXS))
 			continue;
 	}
 
-	while (!(read_STAT() & SPIF))
+	while (!(read_STAT(drv_data) & SPIF))
 		continue;
 
 	msg->actual_length += drv_data->len_in_bytes;
 
 	if (drv_data->cs_change)
-		cs_deactive(chip);
+		cs_deactive(drv_data, chip);
 
 	/* Move to next transfer */
 	msg->state = next_transfer(drv_data);
@@ -656,8 +661,8 @@ static irqreturn_t dma_irq_handler(int i
 	/* free the irq handler before next transfer */
 	dev_dbg(&drv_data->pdev->dev,
 		"disable dma channel irq%d\n",
-		spi_dma_ch);
-	dma_disable_irq(spi_dma_ch);
+		drv_data->dma_channel);
+	dma_disable_irq(drv_data->dma_channel);
 
 	return IRQ_HANDLED;
 }
@@ -751,9 +756,9 @@ static void pump_transfers(unsigned long
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
-	write_STAT(BIT_STAT_CLR);
-	cr = (read_CTRL() & (~BIT_CTL_TIMOD));
-	cs_active(chip);
+	write_STAT(drv_data, BIT_STAT_CLR);
+	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
+	cs_active(drv_data, chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -766,23 +771,23 @@ static void pump_transfers(unsigned long
 	 */
 	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
 
-		disable_dma(spi_dma_ch);
-		clear_dma_irqstat(spi_dma_ch);
+		disable_dma(drv_data->dma_channel);
+		clear_dma_irqstat(drv_data->dma_channel);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
 		if (width == CFG_SPI_WORDSIZE16) {
-			set_dma_x_count(spi_dma_ch, drv_data->len);
-			set_dma_x_modify(spi_dma_ch, 2);
+			set_dma_x_count(drv_data->dma_channel, drv_data->len);
+			set_dma_x_modify(drv_data->dma_channel, 2);
 			dma_width = WDSIZE_16;
 		} else {
-			set_dma_x_count(spi_dma_ch, drv_data->len);
-			set_dma_x_modify(spi_dma_ch, 1);
+			set_dma_x_count(drv_data->dma_channel, drv_data->len);
+			set_dma_x_modify(drv_data->dma_channel, 1);
 			dma_width = WDSIZE_8;
 		}
 
 		/* poll for SPI completion before start */
-		while (!(read_STAT() & BIT_STAT_SPIF))
+		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
 			continue;
 
 		/* dirty hack for autobuffer DMA mode */
@@ -791,15 +796,15 @@ static void pump_transfers(unsigned long
 				"doing autobuffer DMA out.\n");
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_DMAWRITE);
+			write_CTRL(drv_data, (cr | CFG_SPI_DMAWRITE));
 
 			/* no irq in autobuffer mode */
 			dma_config =
 			    (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
-			set_dma_config(spi_dma_ch, dma_config);
-			set_dma_start_addr(spi_dma_ch,
+			set_dma_config(drv_data->dma_channel, dma_config);
+			set_dma_start_addr(drv_data->dma_channel,
 					(unsigned long)drv_data->tx);
-			enable_dma(spi_dma_ch);
+			enable_dma(drv_data->dma_channel);
 
 			/* just return here, there can only be one transfer in this mode */
 			message->status = 0;
@@ -813,34 +818,34 @@ static void pump_transfers(unsigned long
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_DMAREAD);
+			write_CTRL(drv_data, (cr | CFG_SPI_DMAREAD));
 
 			/* clear tx reg soformer data is not shifted out */
-			write_TDBR(0xFFFF);
+			write_TDBR(drv_data, 0xFFFF);
 
-			set_dma_x_count(spi_dma_ch, drv_data->len);
+			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 
 			/* start dma */
-			dma_enable_irq(spi_dma_ch);
+			dma_enable_irq(drv_data->dma_channel);
 			dma_config = (WNR | RESTART | dma_width | DI_EN);
-			set_dma_config(spi_dma_ch, dma_config);
-			set_dma_start_addr(spi_dma_ch,
+			set_dma_config(drv_data->dma_channel, dma_config);
+			set_dma_start_addr(drv_data->dma_channel,
 					(unsigned long)drv_data->rx);
-			enable_dma(spi_dma_ch);
+			enable_dma(drv_data->dma_channel);
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_DMAWRITE);
+			write_CTRL(drv_data, (cr | CFG_SPI_DMAWRITE));
 
 			/* start dma */
-			dma_enable_irq(spi_dma_ch);
+			dma_enable_irq(drv_data->dma_channel);
 			dma_config = (RESTART | dma_width | DI_EN);
-			set_dma_config(spi_dma_ch, dma_config);
-			set_dma_start_addr(spi_dma_ch,
+			set_dma_config(drv_data->dma_channel, dma_config);
+			set_dma_start_addr(drv_data->dma_channel,
 					(unsigned long)drv_data->tx);
-			enable_dma(spi_dma_ch);
+			enable_dma(drv_data->dma_channel);
 		}
 	} else {
 		/* IO mode write then read */
@@ -854,7 +859,7 @@ static void pump_transfers(unsigned long
 				"IO duplex: cr is 0x%x\n", cr);
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_WRITE);
+			write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
 
 			drv_data->duplex(drv_data);
 
@@ -866,7 +871,7 @@ static void pump_transfers(unsigned long
 				"IO write: cr is 0x%x\n", cr);
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_WRITE);
+			write_CTRL(drv_data, (cr | CFG_SPI_WRITE));
 
 			drv_data->write(drv_data);
 
@@ -878,7 +883,7 @@ static void pump_transfers(unsigned long
 				"IO read: cr is 0x%x\n", cr);
 
 			/* set SPI transfer mode */
-			write_CTRL(cr | CFG_SPI_READ);
+			write_CTRL(drv_data, (cr | CFG_SPI_READ));
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -1075,20 +1080,20 @@ static int setup(struct spi_device *spi)
 	 * if any one SPI chip is registered and wants DMA, request the
 	 * DMA channel for it
 	 */
-	if (chip->enable_dma && !dma_requested) {
+	if (chip->enable_dma && !drv_data->dma_requested) {
 		/* register dma irq handler */
-		if (request_dma(spi_dma_ch, "BF53x_SPI_DMA") < 0) {
+		if (request_dma(drv_data->dma_channel, "BF53x_SPI_DMA") < 0) {
 			dev_dbg(&spi->dev,
 				"Unable to request BlackFin SPI DMA channel\n");
 			return -ENODEV;
 		}
-		if (set_dma_callback(spi_dma_ch, (void *)dma_irq_handler,
-			drv_data) < 0) {
+		if (set_dma_callback(drv_data->dma_channel,
+			(void *)dma_irq_handler, drv_data) < 0) {
 			dev_dbg(&spi->dev, "Unable to set dma callback\n");
 			return -EPERM;
 		}
-		dma_disable_irq(spi_dma_ch);
-		dma_requested = 1;
+		dma_disable_irq(drv_data->dma_channel);
+		drv_data->dma_requested = 1;
 	}
 
 	/*
@@ -1304,15 +1309,16 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error_get_res;
 	}
 
-	spi_regs_base = (u32) ioremap(res->start, (res->end - res->start)+1);
-	if (!spi_regs_base) {
+	drv_data->regs_base = (u32) ioremap(res->start,
+					(res->end - res->start + 1));
+	if (!drv_data->regs_base) {
 		dev_err(dev, "Cannot map IO\n");
 		status = -ENXIO;
 		goto out_error_ioremap;
 	}
 
-	spi_dma_ch = platform_get_irq(pdev, 0);
-	if (spi_dma_ch < 0) {
+	drv_data->dma_channel = platform_get_irq(pdev, 0);
+	if (drv_data->dma_channel < 0) {
 		dev_err(dev, "No DMA channel specified\n");
 		status = -ENOENT;
 		goto out_error_no_dma_ch;
@@ -1344,14 +1350,15 @@ static int __init bfin5xx_spi_probe(stru
 		goto out_error;
 	}
 
-	dev_info(dev, "%s, Version %s, regs_base @ 0x%08x\n",
-		DRV_DESC, DRV_VERSION, spi_regs_base);
+	dev_info(dev, "%s, Version %s, regs_base@0x%08x, dma channel@%d\n",
+		DRV_DESC, DRV_VERSION, drv_data->regs_base,
+		drv_data->dma_channel);
 	return status;
 
 out_error_queue_alloc:
 	destroy_queue(drv_data);
 out_error_no_dma_ch:
-	iounmap((void *) spi_regs_base);
+	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
 out_error_get_res:
 out_error:
@@ -1379,8 +1386,8 @@ static int __devexit bfin5xx_spi_remove(
 
 	/* Release DMA */
 	if (drv_data->master_info->enable_dma) {
-		if (dma_channel_active(spi_dma_ch))
-			free_dma(spi_dma_ch);
+		if (dma_channel_active(drv_data->dma_channel))
+			free_dma(drv_data->dma_channel);
 	}
 
 	/* Disconnect from the SPI framework */
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
