From: akpm@linux-foundation.org
Subject: + gpio-rename-pca953x-symbols.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:45:17 -0800
Message-ID: <200802042245.m14MjHfJ021658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794AbYBDWpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     gpio: rename pca953x symbols
has been added to the -mm tree.  Its filename is
     gpio-rename-pca953x-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: rename pca953x symbols
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

This second part of an extension to support more pca953x chips renames the C
and Kconfig symbols.  All affected files were updated by sed, except for a
couple of obvious exceptions.  It also updates the Kconfig helptext.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |   11 +--
 drivers/gpio/Makefile       |    2 
 drivers/gpio/pca953x.c      |  110 +++++++++++++++++-----------------
 include/linux/i2c/pca953x.h |    2 
 4 files changed, 63 insertions(+), 62 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-rename-pca953x-symbols drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-rename-pca953x-symbols
+++ a/drivers/gpio/Kconfig
@@ -27,15 +27,16 @@ config DEBUG_GPIO
 
 comment "I2C GPIO expanders:"
 
-config GPIO_PCA9539
-	tristate "PCA9539 16-bit I/O port"
+config GPIO_PCA953X
+	tristate "PCA953x I/O ports"
 	depends on I2C
 	help
-	  Say yes here to support the PCA9539 16-bit I/O port. These
-	  parts are made by NXP and TI.
+	  Say yes here to support the PCA9534 (8-bit), PCA9535 (16-bit),
+	  PCA9536 (4-bit), PCA9537 (4-bit), PCA9538 (8-bit), and PCA9539
+	  (16-bit) I/O ports. These parts are made by NXP and TI.
 
 	  This driver can also be built as a module.  If so, the module
-	  will be called pca9539.
+	  will be called pca953x.
 
 config GPIO_PCF857X
 	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
diff -puN drivers/gpio/Makefile~gpio-rename-pca953x-symbols drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-rename-pca953x-symbols
+++ a/drivers/gpio/Makefile
@@ -5,5 +5,5 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
-obj-$(CONFIG_GPIO_PCA9539)	+= pca953x.o
+obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff -puN drivers/gpio/pca953x.c~gpio-rename-pca953x-symbols drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-rename-pca953x-symbols
+++ a/drivers/gpio/pca953x.c
@@ -1,5 +1,5 @@
 /*
- *  pca9539.c - 16-bit I/O port with interrupt and reset
+ *  pca953x.c - 16-bit I/O port with interrupt and reset
  *
  *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
  *  Copyright (C) 2007 Marvell International Ltd.
@@ -19,14 +19,14 @@
 #include <asm/gpio.h>
 
 
-#define NR_PCA9539_GPIOS	16
+#define NR_PCA953X_GPIOS	16
 
-#define PCA9539_INPUT		0
-#define PCA9539_OUTPUT		2
-#define PCA9539_INVERT		4
-#define PCA9539_DIRECTION	6
+#define PCA953X_INPUT		0
+#define PCA953X_OUTPUT		2
+#define PCA953X_INVERT		4
+#define PCA953X_DIRECTION	6
 
-struct pca9539_chip {
+struct pca953x_chip {
 	unsigned gpio_start;
 	uint16_t reg_output;
 	uint16_t reg_direction;
@@ -38,7 +38,7 @@ struct pca9539_chip {
 /* NOTE:  we can't currently rely on fault codes to come from SMBus
  * calls, so we map all errors to EIO here and return zero otherwise.
  */
-static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
 	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
 		return -EIO;
@@ -46,7 +46,7 @@ static int pca9539_write_reg(struct pca9
 		return 0;
 }
 
-static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
 {
 	int ret;
 
@@ -60,16 +60,16 @@ static int pca9539_read_reg(struct pca95
 	return 0;
 }
 
-static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
-	struct pca9539_chip *chip;
+	struct pca953x_chip *chip;
 	uint16_t reg_val;
 	int ret;
 
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	reg_val = chip->reg_direction | (1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
 		return ret;
 
@@ -77,14 +77,14 @@ static int pca9539_gpio_direction_input(
 	return 0;
 }
 
-static int pca9539_gpio_direction_output(struct gpio_chip *gc,
+static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		unsigned off, int val)
 {
-	struct pca9539_chip *chip;
+	struct pca953x_chip *chip;
 	uint16_t reg_val;
 	int ret;
 
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	/* set output level */
 	if (val)
@@ -92,7 +92,7 @@ static int pca9539_gpio_direction_output
 	else
 		reg_val = chip->reg_output & ~(1u << off);
 
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
 		return ret;
 
@@ -100,7 +100,7 @@ static int pca9539_gpio_direction_output
 
 	/* then direction */
 	reg_val = chip->reg_direction & ~(1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
 		return ret;
 
@@ -108,15 +108,15 @@ static int pca9539_gpio_direction_output
 	return 0;
 }
 
-static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
+static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 {
-	struct pca9539_chip *chip;
+	struct pca953x_chip *chip;
 	uint16_t reg_val;
 	int ret;
 
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
-	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
+	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
 	if (ret < 0) {
 		/* NOTE:  diagnostic already emitted; that's all we should
 		 * do unless gpio_*_value_cansleep() calls become different
@@ -128,55 +128,55 @@ static int pca9539_gpio_get_value(struct
 	return (reg_val & (1u << off)) ? 1 : 0;
 }
 
-static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 {
-	struct pca9539_chip *chip;
+	struct pca953x_chip *chip;
 	uint16_t reg_val;
 	int ret;
 
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	if (val)
 		reg_val = chip->reg_output | (1u << off);
 	else
 		reg_val = chip->reg_output & ~(1u << off);
 
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
 		return;
 
 	chip->reg_output = reg_val;
 }
 
-static int pca9539_init_gpio(struct pca9539_chip *chip)
+static int pca953x_init_gpio(struct pca953x_chip *chip)
 {
 	struct gpio_chip *gc;
 
 	gc = &chip->gpio_chip;
 
-	gc->direction_input  = pca9539_gpio_direction_input;
-	gc->direction_output = pca9539_gpio_direction_output;
-	gc->get = pca9539_gpio_get_value;
-	gc->set = pca9539_gpio_set_value;
+	gc->direction_input  = pca953x_gpio_direction_input;
+	gc->direction_output = pca953x_gpio_direction_output;
+	gc->get = pca953x_gpio_get_value;
+	gc->set = pca953x_gpio_set_value;
 
 	gc->base = chip->gpio_start;
-	gc->ngpio = NR_PCA9539_GPIOS;
-	gc->label = "pca9539";
+	gc->ngpio = NR_PCA953X_GPIOS;
+	gc->label = "pca953x";
 
 	return gpiochip_add(gc);
 }
 
-static int __devinit pca9539_probe(struct i2c_client *client)
+static int __devinit pca953x_probe(struct i2c_client *client)
 {
-	struct pca9539_platform_data *pdata;
-	struct pca9539_chip *chip;
+	struct pca953x_platform_data *pdata;
+	struct pca953x_chip *chip;
 	int ret;
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
 		return -ENODEV;
 
-	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
+	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
@@ -187,20 +187,20 @@ static int __devinit pca9539_probe(struc
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
-	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
+	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
 		goto out_failed;
 
-	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
+	ret = pca953x_read_reg(chip, PCA953X_DIRECTION, &chip->reg_direction);
 	if (ret)
 		goto out_failed;
 
 	/* set platform specific polarity inversion */
-	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+	ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
 	if (ret)
 		goto out_failed;
 
-	ret = pca9539_init_gpio(chip);
+	ret = pca953x_init_gpio(chip);
 	if (ret)
 		goto out_failed;
 
@@ -219,10 +219,10 @@ out_failed:
 	return ret;
 }
 
-static int pca9539_remove(struct i2c_client *client)
+static int pca953x_remove(struct i2c_client *client)
 {
-	struct pca9539_platform_data *pdata = client->dev.platform_data;
-	struct pca9539_chip *chip = i2c_get_clientdata(client);
+	struct pca953x_platform_data *pdata = client->dev.platform_data;
+	struct pca953x_chip *chip = i2c_get_clientdata(client);
 	int ret = 0;
 
 	if (pdata->teardown) {
@@ -246,26 +246,26 @@ static int pca9539_remove(struct i2c_cli
 	return 0;
 }
 
-static struct i2c_driver pca9539_driver = {
+static struct i2c_driver pca953x_driver = {
 	.driver = {
-		.name	= "pca9539",
+		.name	= "pca953x",
 	},
-	.probe		= pca9539_probe,
-	.remove		= pca9539_remove,
+	.probe		= pca953x_probe,
+	.remove		= pca953x_remove,
 };
 
-static int __init pca9539_init(void)
+static int __init pca953x_init(void)
 {
-	return i2c_add_driver(&pca9539_driver);
+	return i2c_add_driver(&pca953x_driver);
 }
-module_init(pca9539_init);
+module_init(pca953x_init);
 
-static void __exit pca9539_exit(void)
+static void __exit pca953x_exit(void)
 {
-	i2c_del_driver(&pca9539_driver);
+	i2c_del_driver(&pca953x_driver);
 }
-module_exit(pca9539_exit);
+module_exit(pca953x_exit);
 
 MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
-MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
+MODULE_DESCRIPTION("GPIO expander driver for PCA953x");
 MODULE_LICENSE("GPL");
diff -puN include/linux/i2c/pca953x.h~gpio-rename-pca953x-symbols include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~gpio-rename-pca953x-symbols
+++ a/include/linux/i2c/pca953x.h
@@ -1,6 +1,6 @@
 /* platform data for the PCA9539 16-bit I/O expander driver */
 
-struct pca9539_platform_data {
+struct pca953x_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

git-dvb.patch
gpio-rename-pca9539-driver.patch
gpio-rename-pca953x-symbols.patch
gpio-handle-pca95345678-too.patch
