From: akpm@linux-foundation.org
Subject: + gpio-rename-pca9539-driver.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:45:14 -0800
Message-ID: <200802042245.m14MjEjd021655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855AbYBDWpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     gpio: rename pca9539 driver
has been added to the -mm tree.  Its filename is
     gpio-rename-pca9539-driver.patch

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
Subject: gpio: rename pca9539 driver
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

First part of an extension to let the pca9539 driver support more chips,
starting with pca9534, pca9535, pca9536, pca9537, and pca9538.

This renames the files and modifies the Makefile.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Makefile       |    2 
 drivers/gpio/pca9539.c      |  271 ----------------------------------
 drivers/gpio/pca953x.c      |  271 ++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 --
 include/linux/i2c/pca953x.h |   18 ++
 5 files changed, 290 insertions(+), 290 deletions(-)

diff -puN drivers/gpio/Makefile~gpio-rename-pca9539-driver drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-rename-pca9539-driver
+++ a/drivers/gpio/Makefile
@@ -5,5 +5,5 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
-obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff -puN drivers/gpio/pca9539.c~gpio-rename-pca9539-driver /dev/null
--- a/drivers/gpio/pca9539.c
+++ /dev/null
@@ -1,271 +0,0 @@
-/*
- *  pca9539.c - 16-bit I/O port with interrupt and reset
- *
- *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
- *  Copyright (C) 2007 Marvell International Ltd.
- *
- *  Derived from drivers/i2c/chips/pca9539.c
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/i2c/pca9539.h>
-
-#include <asm/gpio.h>
-
-
-#define NR_PCA9539_GPIOS	16
-
-#define PCA9539_INPUT		0
-#define PCA9539_OUTPUT		2
-#define PCA9539_INVERT		4
-#define PCA9539_DIRECTION	6
-
-struct pca9539_chip {
-	unsigned gpio_start;
-	uint16_t reg_output;
-	uint16_t reg_direction;
-
-	struct i2c_client *client;
-	struct gpio_chip gpio_chip;
-};
-
-/* NOTE:  we can't currently rely on fault codes to come from SMBus
- * calls, so we map all errors to EIO here and return zero otherwise.
- */
-static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
-{
-	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
-		return -EIO;
-	else
-		return 0;
-}
-
-static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
-{
-	int ret;
-
-	ret = i2c_smbus_read_word_data(chip->client, reg);
-	if (ret < 0) {
-		dev_err(&chip->client->dev, "failed reading register\n");
-		return -EIO;
-	}
-
-	*val = (uint16_t)ret;
-	return 0;
-}
-
-static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	reg_val = chip->reg_direction | (1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_direction = reg_val;
-	return 0;
-}
-
-static int pca9539_gpio_direction_output(struct gpio_chip *gc,
-		unsigned off, int val)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	/* set output level */
-	if (val)
-		reg_val = chip->reg_output | (1u << off);
-	else
-		reg_val = chip->reg_output & ~(1u << off);
-
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_output = reg_val;
-
-	/* then direction */
-	reg_val = chip->reg_direction & ~(1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_direction = reg_val;
-	return 0;
-}
-
-static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
-	if (ret < 0) {
-		/* NOTE:  diagnostic already emitted; that's all we should
-		 * do unless gpio_*_value_cansleep() calls become different
-		 * from their nonsleeping siblings (and report faults).
-		 */
-		return 0;
-	}
-
-	return (reg_val & (1u << off)) ? 1 : 0;
-}
-
-static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	if (val)
-		reg_val = chip->reg_output | (1u << off);
-	else
-		reg_val = chip->reg_output & ~(1u << off);
-
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
-	if (ret)
-		return;
-
-	chip->reg_output = reg_val;
-}
-
-static int pca9539_init_gpio(struct pca9539_chip *chip)
-{
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
-
-	gc->direction_input  = pca9539_gpio_direction_input;
-	gc->direction_output = pca9539_gpio_direction_output;
-	gc->get = pca9539_gpio_get_value;
-	gc->set = pca9539_gpio_set_value;
-
-	gc->base = chip->gpio_start;
-	gc->ngpio = NR_PCA9539_GPIOS;
-	gc->label = "pca9539";
-
-	return gpiochip_add(gc);
-}
-
-static int __devinit pca9539_probe(struct i2c_client *client)
-{
-	struct pca9539_platform_data *pdata;
-	struct pca9539_chip *chip;
-	int ret;
-
-	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
-
-	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
-
-	chip->client = client;
-
-	chip->gpio_start = pdata->gpio_base;
-
-	/* initialize cached registers from their original values.
-	 * we can't share this chip with another i2c master.
-	 */
-	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
-	if (ret)
-		goto out_failed;
-
-	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
-	if (ret)
-		goto out_failed;
-
-	/* set platform specific polarity inversion */
-	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
-	if (ret)
-		goto out_failed;
-
-	ret = pca9539_init_gpio(chip);
-	if (ret)
-		goto out_failed;
-
-	if (pdata->setup) {
-		ret = pdata->setup(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0)
-			dev_warn(&client->dev, "setup failed, %d\n", ret);
-	}
-
-	i2c_set_clientdata(client, chip);
-	return 0;
-
-out_failed:
-	kfree(chip);
-	return ret;
-}
-
-static int pca9539_remove(struct i2c_client *client)
-{
-	struct pca9539_platform_data *pdata = client->dev.platform_data;
-	struct pca9539_chip *chip = i2c_get_clientdata(client);
-	int ret = 0;
-
-	if (pdata->teardown) {
-		ret = pdata->teardown(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0) {
-			dev_err(&client->dev, "%s failed, %d\n",
-					"teardown", ret);
-			return ret;
-		}
-	}
-
-	ret = gpiochip_remove(&chip->gpio_chip);
-	if (ret) {
-		dev_err(&client->dev, "%s failed, %d\n",
-				"gpiochip_remove()", ret);
-		return ret;
-	}
-
-	kfree(chip);
-	return 0;
-}
-
-static struct i2c_driver pca9539_driver = {
-	.driver = {
-		.name	= "pca9539",
-	},
-	.probe		= pca9539_probe,
-	.remove		= pca9539_remove,
-};
-
-static int __init pca9539_init(void)
-{
-	return i2c_add_driver(&pca9539_driver);
-}
-module_init(pca9539_init);
-
-static void __exit pca9539_exit(void)
-{
-	i2c_del_driver(&pca9539_driver);
-}
-module_exit(pca9539_exit);
-
-MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
-MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
-MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/gpio/pca953x.c
--- /dev/null
+++ a/drivers/gpio/pca953x.c
@@ -0,0 +1,271 @@
+/*
+ *  pca9539.c - 16-bit I/O port with interrupt and reset
+ *
+ *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *  Copyright (C) 2007 Marvell International Ltd.
+ *
+ *  Derived from drivers/i2c/chips/pca9539.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
+
+#include <asm/gpio.h>
+
+
+#define NR_PCA9539_GPIOS	16
+
+#define PCA9539_INPUT		0
+#define PCA9539_OUTPUT		2
+#define PCA9539_INVERT		4
+#define PCA9539_DIRECTION	6
+
+struct pca9539_chip {
+	unsigned gpio_start;
+	uint16_t reg_output;
+	uint16_t reg_direction;
+
+	struct i2c_client *client;
+	struct gpio_chip gpio_chip;
+};
+
+/* NOTE:  we can't currently rely on fault codes to come from SMBus
+ * calls, so we map all errors to EIO here and return zero otherwise.
+ */
+static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+{
+	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
+		return -EIO;
+	else
+		return 0;
+}
+
+static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed reading register\n");
+		return -EIO;
+	}
+
+	*val = (uint16_t)ret;
+	return 0;
+}
+
+static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	reg_val = chip->reg_direction | (1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_direction_output(struct gpio_chip *gc,
+		unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	/* set output level */
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_output = reg_val;
+
+	/* then direction */
+	reg_val = chip->reg_direction & ~(1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
+	if (ret < 0) {
+		/* NOTE:  diagnostic already emitted; that's all we should
+		 * do unless gpio_*_value_cansleep() calls become different
+		 * from their nonsleeping siblings (and report faults).
+		 */
+		return 0;
+	}
+
+	return (reg_val & (1u << off)) ? 1 : 0;
+}
+
+static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return;
+
+	chip->reg_output = reg_val;
+}
+
+static int pca9539_init_gpio(struct pca9539_chip *chip)
+{
+	struct gpio_chip *gc;
+
+	gc = &chip->gpio_chip;
+
+	gc->direction_input  = pca9539_gpio_direction_input;
+	gc->direction_output = pca9539_gpio_direction_output;
+	gc->get = pca9539_gpio_get_value;
+	gc->set = pca9539_gpio_set_value;
+
+	gc->base = chip->gpio_start;
+	gc->ngpio = NR_PCA9539_GPIOS;
+	gc->label = "pca9539";
+
+	return gpiochip_add(gc);
+}
+
+static int __devinit pca9539_probe(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata;
+	struct pca9539_chip *chip;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->gpio_start = pdata->gpio_base;
+
+	/* initialize cached registers from their original values.
+	 * we can't share this chip with another i2c master.
+	 */
+	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
+	if (ret)
+		goto out_failed;
+
+	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
+	if (ret)
+		goto out_failed;
+
+	/* set platform specific polarity inversion */
+	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+	if (ret)
+		goto out_failed;
+
+	ret = pca9539_init_gpio(chip);
+	if (ret)
+		goto out_failed;
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_warn(&client->dev, "setup failed, %d\n", ret);
+	}
+
+	i2c_set_clientdata(client, chip);
+	return 0;
+
+out_failed:
+	kfree(chip);
+	return ret;
+}
+
+static int pca9539_remove(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata = client->dev.platform_data;
+	struct pca9539_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	if (pdata->teardown) {
+		ret = pdata->teardown(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0) {
+			dev_err(&client->dev, "%s failed, %d\n",
+					"teardown", ret);
+			return ret;
+		}
+	}
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+		return ret;
+	}
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_driver pca9539_driver = {
+	.driver = {
+		.name	= "pca9539",
+	},
+	.probe		= pca9539_probe,
+	.remove		= pca9539_remove,
+};
+
+static int __init pca9539_init(void)
+{
+	return i2c_add_driver(&pca9539_driver);
+}
+module_init(pca9539_init);
+
+static void __exit pca9539_exit(void)
+{
+	i2c_del_driver(&pca9539_driver);
+}
+module_exit(pca9539_exit);
+
+MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
+MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
+MODULE_LICENSE("GPL");
diff -puN include/linux/i2c/pca9539.h~gpio-rename-pca9539-driver /dev/null
--- a/include/linux/i2c/pca9539.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* platform data for the PCA9539 16-bit I/O expander driver */
-
-struct pca9539_platform_data {
-	/* number of the first GPIO */
-	unsigned	gpio_base;
-
-	/* initial polarity inversion setting */
-	uint16_t	invert;
-
-	void		*context;	/* param to setup/teardown */
-
-	int		(*setup)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-	int		(*teardown)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-};
diff -puN /dev/null include/linux/i2c/pca953x.h
--- /dev/null
+++ a/include/linux/i2c/pca953x.h
@@ -0,0 +1,18 @@
+/* platform data for the PCA9539 16-bit I/O expander driver */
+
+struct pca9539_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	/* initial polarity inversion setting */
+	uint16_t	invert;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+	int		(*teardown)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+};
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

git-dvb.patch
gpio-rename-pca9539-driver.patch
gpio-rename-pca953x-symbols.patch
gpio-handle-pca95345678-too.patch
