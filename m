From: akpm@linux-foundation.org
Subject: [merged] rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:25 -0700
Message-ID: <200904061933.n36JXPKi011127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbZDFTgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-v3020: add ability to access v3020 chip with GPIOs
has been removed from the -mm tree.  Its filename was
     rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-v3020: add ability to access v3020 chip with GPIOs
From: Mike Rapoport <mike@compulab.co.il>

The v3020 RTC can be connected to GPIOs as well as to memory-like
interface.  Add ability to use GPIO bit-bang for v3020 read-write access.

[akpm@linux-foundation.org: fix off-by-one in error path]
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-v3020.c   |  190 ++++++++++++++++++++++++++++++++----
 include/linux/rtc-v3020.h |    6 +
 2 files changed, 176 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-v3020.c~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios
+++ a/drivers/rtc/rtc-v3020.c
@@ -27,17 +27,162 @@
 #include <linux/bcd.h>
 #include <linux/rtc-v3020.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 
 #include <linux/io.h>
 
 #undef DEBUG
 
+struct v3020;
+
+struct v3020_chip_ops {
+	int (*map_io)(struct v3020 *chip, struct platform_device *pdev,
+		      struct v3020_platform_data *pdata);
+	void (*unmap_io)(struct v3020 *chip);
+	unsigned char (*read_bit)(struct v3020 *chip);
+	void (*write_bit)(struct v3020 *chip, unsigned char bit);
+};
+
+#define V3020_CS	0
+#define V3020_WR	1
+#define V3020_RD	2
+#define V3020_IO	3
+
+struct v3020_gpio {
+	const char *name;
+	unsigned int gpio;
+};
+
 struct v3020 {
+	/* MMIO access */
 	void __iomem *ioaddress;
 	int leftshift;
+
+	/* GPIO access */
+	struct v3020_gpio *gpio;
+
+	struct v3020_chip_ops *ops;
+
 	struct rtc_device *rtc;
 };
 
+
+static int v3020_mmio_map(struct v3020 *chip, struct platform_device *pdev,
+			  struct v3020_platform_data *pdata)
+{
+	if (pdev->num_resources != 1)
+		return -EBUSY;
+
+	if (pdev->resource[0].flags != IORESOURCE_MEM)
+		return -EBUSY;
+
+	chip->leftshift = pdata->leftshift;
+	chip->ioaddress = ioremap(pdev->resource[0].start, 1);
+	if (chip->ioaddress == NULL)
+		return -EBUSY;
+
+	return 0;
+}
+
+static void v3020_mmio_unmap(struct v3020 *chip)
+{
+	iounmap(chip->ioaddress);
+}
+
+static void v3020_mmio_write_bit(struct v3020 *chip, unsigned char bit)
+{
+	writel(bit << chip->leftshift, chip->ioaddress);
+}
+
+static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
+{
+	return readl(chip->ioaddress) & (1 << chip->leftshift);
+}
+
+static struct v3020_chip_ops v3020_mmio_ops = {
+	.map_io		= v3020_mmio_map,
+	.unmap_io	= v3020_mmio_unmap,
+	.read_bit	= v3020_mmio_read_bit,
+	.write_bit	= v3020_mmio_write_bit,
+};
+
+static struct v3020_gpio v3020_gpio[] = {
+	{ "RTC CS", 0 },
+	{ "RTC WR", 0 },
+	{ "RTC RD", 0 },
+	{ "RTC IO", 0 },
+};
+
+static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
+			  struct v3020_platform_data *pdata)
+{
+	int i, err;
+
+	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
+	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
+	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
+	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
+
+	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
+		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
+		if (err)
+			goto err_request;
+
+		gpio_direction_output(v3020_gpio[i].gpio, 1);
+	}
+
+	chip->gpio = v3020_gpio;
+
+	return 0;
+
+err_request:
+	while (--i >= 0)
+		gpio_free(v3020_gpio[i].gpio);
+
+	return err;
+}
+
+static void v3020_gpio_unmap(struct v3020 *chip)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++)
+		gpio_free(v3020_gpio[i].gpio);
+}
+
+static void v3020_gpio_write_bit(struct v3020 *chip, unsigned char bit)
+{
+	gpio_direction_output(chip->gpio[V3020_IO].gpio, bit);
+	gpio_set_value(chip->gpio[V3020_CS].gpio, 0);
+	gpio_set_value(chip->gpio[V3020_WR].gpio, 0);
+	udelay(1);
+	gpio_set_value(chip->gpio[V3020_WR].gpio, 1);
+	gpio_set_value(chip->gpio[V3020_CS].gpio, 1);
+}
+
+static unsigned char v3020_gpio_read_bit(struct v3020 *chip)
+{
+	int bit;
+
+	gpio_direction_input(chip->gpio[V3020_IO].gpio);
+	gpio_set_value(chip->gpio[V3020_CS].gpio, 0);
+	gpio_set_value(chip->gpio[V3020_RD].gpio, 0);
+	udelay(1);
+	bit = !!gpio_get_value(chip->gpio[V3020_IO].gpio);
+	udelay(1);
+	gpio_set_value(chip->gpio[V3020_RD].gpio, 1);
+	gpio_set_value(chip->gpio[V3020_CS].gpio, 1);
+
+	return bit;
+}
+
+static struct v3020_chip_ops v3020_gpio_ops = {
+	.map_io		= v3020_gpio_map,
+	.unmap_io	= v3020_gpio_unmap,
+	.read_bit	= v3020_gpio_read_bit,
+	.write_bit	= v3020_gpio_write_bit,
+};
+
 static void v3020_set_reg(struct v3020 *chip, unsigned char address,
 			unsigned char data)
 {
@@ -46,7 +191,7 @@ static void v3020_set_reg(struct v3020 *
 
 	tmp = address;
 	for (i = 0; i < 4; i++) {
-		writel((tmp & 1) << chip->leftshift, chip->ioaddress);
+		chip->ops->write_bit(chip, (tmp & 1));
 		tmp >>= 1;
 		udelay(1);
 	}
@@ -54,7 +199,7 @@ static void v3020_set_reg(struct v3020 *
 	/* Commands dont have data */
 	if (!V3020_IS_COMMAND(address)) {
 		for (i = 0; i < 8; i++) {
-			writel((data & 1) << chip->leftshift, chip->ioaddress);
+			chip->ops->write_bit(chip, (data & 1));
 			data >>= 1;
 			udelay(1);
 		}
@@ -67,14 +212,14 @@ static unsigned char v3020_get_reg(struc
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		writel((address & 1) << chip->leftshift, chip->ioaddress);
+		chip->ops->write_bit(chip, (address & 1));
 		address >>= 1;
 		udelay(1);
 	}
 
 	for (i = 0; i < 8; i++) {
 		data >>= 1;
-		if (readl(chip->ioaddress) & (1 << chip->leftshift))
+		if (chip->ops->read_bit(chip))
 			data |= 0x80;
 		udelay(1);
 	}
@@ -164,25 +309,23 @@ static int rtc_probe(struct platform_dev
 	int i;
 	int temp;
 
-	if (pdev->num_resources != 1)
-		return -EBUSY;
-
-	if (pdev->resource[0].flags != IORESOURCE_MEM)
-		return -EBUSY;
-
 	chip = kzalloc(sizeof *chip, GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
-	chip->leftshift = pdata->leftshift;
-	chip->ioaddress = ioremap(pdev->resource[0].start, 1);
-	if (chip->ioaddress == NULL)
+	if (pdata->use_gpio)
+		chip->ops = &v3020_gpio_ops;
+	else
+		chip->ops = &v3020_mmio_ops;
+
+	retval = chip->ops->map_io(chip, pdev, pdata);
+	if (retval)
 		goto err_chip;
 
 	/* Make sure the v3020 expects a communication cycle
 	 * by reading 8 times */
 	for (i = 0; i < 8; i++)
-		temp = readl(chip->ioaddress);
+		temp = chip->ops->read_bit(chip);
 
 	/* Test chip by doing a write/read sequence
 	 * to the chip ram */
@@ -196,10 +339,17 @@ static int rtc_probe(struct platform_dev
 	 * are all disabled */
 	v3020_set_reg(chip, V3020_STATUS_0, 0x0);
 
-	dev_info(&pdev->dev, "Chip available at physical address 0x%llx,"
-		"data connected to D%d\n",
-		(unsigned long long)pdev->resource[0].start,
-		chip->leftshift);
+	if (pdata->use_gpio)
+		dev_info(&pdev->dev, "Chip available at GPIOs "
+			 "%d, %d, %d, %d\n",
+			 chip->gpio[V3020_CS].gpio, chip->gpio[V3020_WR].gpio,
+			 chip->gpio[V3020_RD].gpio, chip->gpio[V3020_IO].gpio);
+	else
+		dev_info(&pdev->dev, "Chip available at "
+			 "physical address 0x%llx,"
+			 "data connected to D%d\n",
+			 (unsigned long long)pdev->resource[0].start,
+			 chip->leftshift);
 
 	platform_set_drvdata(pdev, chip);
 
@@ -214,7 +364,7 @@ static int rtc_probe(struct platform_dev
 	return 0;
 
 err_io:
-	iounmap(chip->ioaddress);
+	chip->ops->unmap_io(chip);
 err_chip:
 	kfree(chip);
 
@@ -229,7 +379,7 @@ static int rtc_remove(struct platform_de
 	if (rtc)
 		rtc_device_unregister(rtc);
 
-	iounmap(chip->ioaddress);
+	chip->ops->unmap_io(chip);
 	kfree(chip);
 
 	return 0;
diff -puN include/linux/rtc-v3020.h~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios include/linux/rtc-v3020.h
--- a/include/linux/rtc-v3020.h~rtc-v3020-add-ability-to-access-v3020-chip-with-gpios
+++ a/include/linux/rtc-v3020.h
@@ -14,6 +14,12 @@
  * is used depends on the board. */
 struct v3020_platform_data {
 	int leftshift; /* (1<<(leftshift)) & readl() */
+
+	int use_gpio:1;
+	unsigned int gpio_cs;
+	unsigned int gpio_wr;
+	unsigned int gpio_rd;
+	unsigned int gpio_io;
 };
 
 #define V3020_STATUS_0	0x00
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
linux-next.patch
spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch
spi-add-dma_alignment-field-to-spi_master.patch
pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch
spi_imx-set-spi_masterdma_alignment-=-4.patch

