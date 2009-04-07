From: akpm@linux-foundation.org
Subject: [merged] spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:05 -0700
Message-ID: <200904071907.n37J75RQ011124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759316AbZDGTK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     spi: pxa2xx_spi: introduce chipselect GPIO to simplify the common cases
has been removed from the -mm tree.  Its filename was
     spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi: introduce chipselect GPIO to simplify the common cases
From: Eric Miao <eric.miao@marvell.com>

Most SPI peripherals use GPIOs as their chip selects, introduce .gpio_cs
for this.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/include/mach/pxa2xx_spi.h |    1 
 drivers/spi/pxa2xx_spi.c                    |   96 ++++++++++++++----
 2 files changed, 79 insertions(+), 18 deletions(-)

diff -puN arch/arm/mach-pxa/include/mach/pxa2xx_spi.h~spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases arch/arm/mach-pxa/include/mach/pxa2xx_spi.h
--- a/arch/arm/mach-pxa/include/mach/pxa2xx_spi.h~spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases
+++ a/arch/arm/mach-pxa/include/mach/pxa2xx_spi.h
@@ -38,6 +38,7 @@ struct pxa2xx_spi_chip {
 	u8 dma_burst_size;
 	u32 timeout;
 	u8 enable_loopback;
+	int gpio_cs;
 	void (*cs_control)(u32 command);
 };
 
diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases
+++ a/drivers/spi/pxa2xx_spi.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
+#include <linux/gpio.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -166,6 +167,8 @@ struct chip_data {
 	u8 enable_dma;
 	u8 bits_per_word;
 	u32 speed_hz;
+	int gpio_cs;
+	int gpio_cs_inverted;
 	int (*write)(struct driver_data *drv_data);
 	int (*read)(struct driver_data *drv_data);
 	void (*cs_control)(u32 command);
@@ -173,6 +176,32 @@ struct chip_data {
 
 static void pump_messages(struct work_struct *work);
 
+static void cs_assert(struct driver_data *drv_data)
+{
+	struct chip_data *chip = drv_data->cur_chip;
+
+	if (chip->cs_control) {
+		chip->cs_control(PXA2XX_CS_ASSERT);
+		return;
+	}
+
+	if (gpio_is_valid(chip->gpio_cs))
+		gpio_set_value(chip->gpio_cs, chip->gpio_cs_inverted);
+}
+
+static void cs_deassert(struct driver_data *drv_data)
+{
+	struct chip_data *chip = drv_data->cur_chip;
+
+	if (chip->cs_control) {
+		chip->cs_control(PXA2XX_CS_ASSERT);
+		return;
+	}
+
+	if (gpio_is_valid(chip->gpio_cs))
+		gpio_set_value(chip->gpio_cs, !chip->gpio_cs_inverted);
+}
+
 static int flush(struct driver_data *drv_data)
 {
 	unsigned long limit = loops_per_jiffy << 1;
@@ -189,10 +218,6 @@ static int flush(struct driver_data *drv
 	return limit;
 }
 
-static void null_cs_control(u32 command)
-{
-}
-
 static int null_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
@@ -400,7 +425,6 @@ static void giveback(struct driver_data 
 	msg = drv_data->cur_msg;
 	drv_data->cur_msg = NULL;
 	drv_data->cur_transfer = NULL;
-	drv_data->cur_chip = NULL;
 	queue_work(drv_data->workqueue, &drv_data->pump_messages);
 	spin_unlock_irqrestore(&drv_data->lock, flags);
 
@@ -416,7 +440,7 @@ static void giveback(struct driver_data 
 	 * a message with an error, or next message is for another chip
 	 */
 	if (!last_transfer->cs_change)
-		drv_data->cs_control(PXA2XX_CS_DEASSERT);
+		cs_deassert(drv_data);
 	else {
 		struct spi_message *next_msg;
 
@@ -445,12 +469,14 @@ static void giveback(struct driver_data 
 		if (next_msg && next_msg->spi != msg->spi)
 			next_msg = NULL;
 		if (!next_msg || msg->state == ERROR_STATE)
-			drv_data->cs_control(PXA2XX_CS_DEASSERT);
+			cs_deassert(drv_data);
 	}
 
 	msg->state = NULL;
 	if (msg->complete)
 		msg->complete(msg->context);
+
+	drv_data->cur_chip = NULL;
 }
 
 static int wait_ssp_rx_stall(void const __iomem *ioaddr)
@@ -887,7 +913,7 @@ static void pump_transfers(unsigned long
 
 		/* Drop chip select only if cs_change is requested */
 		if (previous->cs_change)
-			drv_data->cs_control(PXA2XX_CS_DEASSERT);
+			cs_deassert(drv_data);
 	}
 
 	/* Check for transfers that need multiple DMA segments */
@@ -922,7 +948,6 @@ static void pump_transfers(unsigned long
 	}
 	drv_data->n_bytes = chip->n_bytes;
 	drv_data->dma_width = chip->dma_width;
-	drv_data->cs_control = chip->cs_control;
 	drv_data->tx = (void *)transfer->tx_buf;
 	drv_data->tx_end = drv_data->tx + transfer->len;
 	drv_data->rx = transfer->rx_buf;
@@ -1084,11 +1109,7 @@ static void pump_transfers(unsigned long
 			write_SSTO(chip->timeout, reg);
 	}
 
-	/* FIXME, need to handle cs polarity,
-	 * this driver uses struct pxa2xx_spi_chip.cs_control to
-	 * specify a CS handling function, and it ignores most
-	 * struct spi_device.mode[s], including SPI_CS_HIGH */
-	drv_data->cs_control(PXA2XX_CS_ASSERT);
+	cs_assert(drv_data);
 
 	/* after chip select, release the data by enabling service
 	 * requests and interrupts, without changing any mode bits */
@@ -1166,6 +1187,44 @@ static int transfer(struct spi_device *s
 /* the spi->mode bits understood by this driver: */
 #define MODEBITS (SPI_CPOL | SPI_CPHA)
 
+static int setup_cs(struct spi_device *spi, struct chip_data *chip,
+		    struct pxa2xx_spi_chip *chip_info)
+{
+	int err = 0;
+
+	if (chip == NULL || chip_info == NULL)
+		return 0;
+
+	/* NOTE: setup() can be called multiple times, possibly with
+	 * different chip_info, release previously requested GPIO
+	 */
+	if (gpio_is_valid(chip->gpio_cs))
+		gpio_free(chip->gpio_cs);
+
+	/* If (*cs_control) is provided, ignore GPIO chip select */
+	if (chip_info->cs_control) {
+		chip->cs_control = chip_info->cs_control;
+		return 0;
+	}
+
+	if (gpio_is_valid(chip_info->gpio_cs)) {
+		err = gpio_request(chip_info->gpio_cs, "SPI_CS");
+		if (err) {
+			dev_err(&spi->dev, "failed to request chip select "
+					"GPIO%d\n", chip_info->gpio_cs);
+			return err;
+		}
+
+		chip->gpio_cs = chip_info->gpio_cs;
+		chip->gpio_cs_inverted = spi->mode & SPI_CS_HIGH;
+
+		err = gpio_direction_output(chip->gpio_cs,
+					!chip->gpio_cs_inverted);
+	}
+
+	return err;
+}
+
 static int setup(struct spi_device *spi)
 {
 	struct pxa2xx_spi_chip *chip_info = NULL;
@@ -1211,7 +1270,7 @@ static int setup(struct spi_device *spi)
 			return -ENOMEM;
 		}
 
-		chip->cs_control = null_cs_control;
+		chip->gpio_cs = -1;
 		chip->enable_dma = 0;
 		chip->timeout = TIMOUT_DFLT;
 		chip->dma_burst_size = drv_data->master_info->enable_dma ?
@@ -1225,8 +1284,6 @@ static int setup(struct spi_device *spi)
 	/* chip_info isn't always needed */
 	chip->cr1 = 0;
 	if (chip_info) {
-		if (chip_info->cs_control)
-			chip->cs_control = chip_info->cs_control;
 		if (chip_info->timeout)
 			chip->timeout = chip_info->timeout;
 		if (chip_info->tx_threshold)
@@ -1308,13 +1365,16 @@ static int setup(struct spi_device *spi)
 
 	spi_set_ctldata(spi, chip);
 
-	return 0;
+	return setup_cs(spi, chip, chip_info);
 }
 
 static void cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if (gpio_is_valid(chip->gpio_cs))
+		gpio_free(chip->gpio_cs);
+
 	kfree(chip);
 }
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
linux-next.patch
input-ads7846-introduce-platform-specific-way-to-synchronize-sampling.patch

