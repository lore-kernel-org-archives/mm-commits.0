From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:58 -0700
Message-ID: <200904071906.n37J6w4Z011096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbZDGTLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: Add GPIO controlled SPI Slave Select support
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: Add GPIO controlled SPI Slave Select support
From: Michael Hennerich <michael.hennerich@analog.com>

Add support for GPIO controlled SPI Chip Selects.  To make use of this
feature, set chip_select = 0 and add a proper cs_gpio to your
controller_data.

struct spi_board_info
        .chip_select = 0

struct bfin5xx_spi_chip
        .cs_gpio = GPIO_P###

There are various SPI devices that require SPI MODE_0, and need to have
the Chip Selects asserted during the entire transfer.  Consider using
SPI_MODE_3 (SPI_CPHA | SPI_CPOL) if your device allows it.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/bfin5xx_spi.h |    1 
 drivers/spi/spi_bfin5xx.c               |   40 +++++++++++++++++-----
 2 files changed, 33 insertions(+), 8 deletions(-)

diff -puN arch/blackfin/include/asm/bfin5xx_spi.h~blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support arch/blackfin/include/asm/bfin5xx_spi.h
--- a/arch/blackfin/include/asm/bfin5xx_spi.h~blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support
+++ a/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -124,6 +124,7 @@ struct bfin5xx_spi_chip {
 	u8 bits_per_word;
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay; /* Some devices require 16-bit delays */
+	u32 cs_gpio;
 };
 
 #endif /* _SPI_CHANNEL_H_ */
diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support
+++ a/drivers/spi/spi_bfin5xx.c
@@ -111,6 +111,7 @@ struct chip_data {
 	u8 bits_per_word;	/* 8 or 16 */
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
+	u32 cs_gpio;
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -177,22 +178,30 @@ static int bfin_spi_flush(struct driver_
 /* Chip select operation functions for cs_change flag */
 static void bfin_spi_cs_active(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG(drv_data);
+	if (likely(chip->chip_select_num)) {
+		u16 flag = read_FLAG(drv_data);
 
-	flag |= chip->flag;
-	flag &= ~(chip->flag << 8);
+		flag |= chip->flag;
+		flag &= ~(chip->flag << 8);
 
-	write_FLAG(drv_data, flag);
+		write_FLAG(drv_data, flag);
+	} else {
+		gpio_set_value(chip->cs_gpio, 0);
+	}
 }
 
 static void bfin_spi_cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG(drv_data);
+	if (likely(chip->chip_select_num)) {
+		u16 flag = read_FLAG(drv_data);
 
-	flag &= ~chip->flag;
-	flag |= (chip->flag << 8);
+		flag &= ~chip->flag;
+		flag |= (chip->flag << 8);
 
-	write_FLAG(drv_data, flag);
+		write_FLAG(drv_data, flag);
+	} else {
+		gpio_set_value(chip->cs_gpio, 1);
+	}
 
 	/* Move delay here for consistency */
 	if (chip->cs_chg_udelay)
@@ -1036,6 +1045,7 @@ static int bfin_spi_setup(struct spi_dev
 	struct bfin5xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	int ret;
 
 	/* Abort device setup if requested features are not supported */
 	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
@@ -1081,6 +1091,7 @@ static int bfin_spi_setup(struct spi_dev
 		chip->bits_per_word = chip_info->bits_per_word;
 		chip->cs_change_per_word = chip_info->cs_change_per_word;
 		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
+		chip->cs_gpio = chip_info->cs_gpio;
 	}
 
 	/* translate common spi framework into our register */
@@ -1121,6 +1132,16 @@ static int bfin_spi_setup(struct spi_dev
 	chip->flag = 1 << (spi->chip_select);
 	chip->chip_select_num = spi->chip_select;
 
+	if (chip->chip_select_num == 0) {
+		ret = gpio_request(chip->cs_gpio, spi->modalias);
+		if (ret) {
+			if (drv_data->dma_requested)
+				free_dma(drv_data->dma_channel);
+			return ret;
+		}
+		gpio_direction_output(chip->cs_gpio, 1);
+	}
+
 	switch (chip->bits_per_word) {
 	case 8:
 		chip->n_bytes = 1;
@@ -1186,6 +1207,9 @@ static void bfin_spi_cleanup(struct spi_
 		peripheral_free(ssel[spi->master->bus_num]
 					[chip->chip_select_num-1]);
 
+	if (chip->chip_select_num == 0)
+		gpio_free(chip->cs_gpio);
+
 	kfree(chip);
 }
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch

