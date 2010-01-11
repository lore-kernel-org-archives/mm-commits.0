From: akpm@linux-foundation.org
Subject: [merged] gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:05 -0800
Message-ID: <201001112019.o0BKJ5Wt025532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183Ab0AKUgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, david-b@pacbell.net, khali@linux-fr.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     gpio: adp5588-gpio: new driver for ADP5588 GPIO expanders
has been removed from the -mm tree.  Its filename was
     gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: adp5588-gpio: new driver for ADP5588 GPIO expanders
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    9 +
 drivers/gpio/Makefile       |    1 
 drivers/gpio/adp5588-gpio.c |  266 ++++++++++++++++++++++++++++++++++
 include/linux/i2c/adp5588.h |   12 +
 4 files changed, 288 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders
+++ a/drivers/gpio/Kconfig
@@ -172,6 +172,15 @@ config GPIO_ADP5520
 	  To compile this driver as a module, choose M here: the module will
 	  be called adp5520-gpio.
 
+config GPIO_ADP5588
+	tristate "ADP5588 I2C GPIO expander"
+	depends on I2C
+	help
+	  This option enables support for 18 GPIOs found
+	  on Analog Devices ADP5588 GPIO Expanders.
+	  To compile this driver as a module, choose M here: the module will be
+	  called adp5588-gpio.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
diff -puN drivers/gpio/Makefile~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders
+++ a/drivers/gpio/Makefile
@@ -5,6 +5,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
+obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
diff -puN /dev/null drivers/gpio/adp5588-gpio.c
--- /dev/null
+++ a/drivers/gpio/adp5588-gpio.c
@@ -0,0 +1,266 @@
+/*
+ * GPIO Chip driver for Analog Devices
+ * ADP5588 I/O Expander and QWERTY Keypad Controller
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+
+#include <linux/i2c/adp5588.h>
+
+#define DRV_NAME		"adp5588-gpio"
+#define MAXGPIO			18
+#define ADP_BANK(offs)		((offs) >> 3)
+#define ADP_BIT(offs)		(1u << ((offs) & 0x7))
+
+struct adp5588_gpio {
+	struct i2c_client *client;
+	struct gpio_chip gpio_chip;
+	struct mutex lock;	/* protect cached dir, dat_out */
+	unsigned gpio_start;
+	uint8_t dat_out[3];
+	uint8_t dir[3];
+};
+
+static int adp5588_gpio_read(struct i2c_client *client, u8 reg)
+{
+	int ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "Read Error\n");
+
+	return ret;
+}
+
+static int adp5588_gpio_write(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret = i2c_smbus_write_byte_data(client, reg, val);
+
+	if (ret < 0)
+		dev_err(&client->dev, "Write Error\n");
+
+	return ret;
+}
+
+static int adp5588_gpio_get_value(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5588_gpio *dev =
+	    container_of(chip, struct adp5588_gpio, gpio_chip);
+
+	return !!(adp5588_gpio_read(dev->client, GPIO_DAT_STAT1 + ADP_BANK(off))
+		  & ADP_BIT(off));
+}
+
+static void adp5588_gpio_set_value(struct gpio_chip *chip,
+				   unsigned off, int val)
+{
+	unsigned bank, bit;
+	struct adp5588_gpio *dev =
+	    container_of(chip, struct adp5588_gpio, gpio_chip);
+
+	bank = ADP_BANK(off);
+	bit = ADP_BIT(off);
+
+	mutex_lock(&dev->lock);
+	if (val)
+		dev->dat_out[bank] |= bit;
+	else
+		dev->dat_out[bank] &= ~bit;
+
+	adp5588_gpio_write(dev->client, GPIO_DAT_OUT1 + bank,
+			   dev->dat_out[bank]);
+	mutex_unlock(&dev->lock);
+}
+
+static int adp5588_gpio_direction_input(struct gpio_chip *chip, unsigned off)
+{
+	int ret;
+	unsigned bank;
+	struct adp5588_gpio *dev =
+	    container_of(chip, struct adp5588_gpio, gpio_chip);
+
+	bank = ADP_BANK(off);
+
+	mutex_lock(&dev->lock);
+	dev->dir[bank] &= ~ADP_BIT(off);
+	ret = adp5588_gpio_write(dev->client, GPIO_DIR1 + bank, dev->dir[bank]);
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+static int adp5588_gpio_direction_output(struct gpio_chip *chip,
+					 unsigned off, int val)
+{
+	int ret;
+	unsigned bank, bit;
+	struct adp5588_gpio *dev =
+	    container_of(chip, struct adp5588_gpio, gpio_chip);
+
+	bank = ADP_BANK(off);
+	bit = ADP_BIT(off);
+
+	mutex_lock(&dev->lock);
+	dev->dir[bank] |= bit;
+
+	if (val)
+		dev->dat_out[bank] |= bit;
+	else
+		dev->dat_out[bank] &= ~bit;
+
+	ret = adp5588_gpio_write(dev->client, GPIO_DAT_OUT1 + bank,
+				 dev->dat_out[bank]);
+	ret |= adp5588_gpio_write(dev->client, GPIO_DIR1 + bank,
+				 dev->dir[bank]);
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+static int __devinit adp5588_gpio_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct adp5588_gpio_platform_data *pdata = client->dev.platform_data;
+	struct adp5588_gpio *dev;
+	struct gpio_chip *gc;
+	int ret, i, revid;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (!i2c_check_functionality(client->adapter,
+					I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
+		return -EIO;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&client->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	dev->client = client;
+
+	gc = &dev->gpio_chip;
+	gc->direction_input = adp5588_gpio_direction_input;
+	gc->direction_output = adp5588_gpio_direction_output;
+	gc->get = adp5588_gpio_get_value;
+	gc->set = adp5588_gpio_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = pdata->gpio_start;
+	gc->ngpio = MAXGPIO;
+	gc->label = client->name;
+	gc->owner = THIS_MODULE;
+
+	mutex_init(&dev->lock);
+
+
+	ret = adp5588_gpio_read(dev->client, DEV_ID);
+	if (ret < 0)
+		goto err;
+
+	revid = ret & ADP5588_DEVICE_ID_MASK;
+
+	for (i = 0, ret = 0; i <= ADP_BANK(MAXGPIO); i++) {
+		dev->dat_out[i] = adp5588_gpio_read(client, GPIO_DAT_OUT1 + i);
+		dev->dir[i] = adp5588_gpio_read(client, GPIO_DIR1 + i);
+		ret |= adp5588_gpio_write(client, KP_GPIO1 + i, 0);
+		ret |= adp5588_gpio_write(client, GPIO_PULL1 + i,
+				(pdata->pullup_dis_mask >> (8 * i)) & 0xFF);
+
+		if (ret)
+			goto err;
+	}
+
+	ret = gpiochip_add(&dev->gpio_chip);
+	if (ret)
+		goto err;
+
+	dev_info(&client->dev, "gpios %d..%d on a %s Rev. %d\n",
+			gc->base, gc->base + gc->ngpio - 1,
+			client->name, revid);
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, gc->base, gc->ngpio, pdata->context);
+		if (ret < 0)
+			dev_warn(&client->dev, "setup failed, %d\n", ret);
+	}
+
+	i2c_set_clientdata(client, dev);
+	return 0;
+
+err:
+	kfree(dev);
+	return ret;
+}
+
+static int __devexit adp5588_gpio_remove(struct i2c_client *client)
+{
+	struct adp5588_gpio_platform_data *pdata = client->dev.platform_data;
+	struct adp5588_gpio *dev = i2c_get_clientdata(client);
+	int ret;
+
+	if (pdata->teardown) {
+		ret = pdata->teardown(client,
+				      dev->gpio_chip.base, dev->gpio_chip.ngpio,
+				      pdata->context);
+		if (ret < 0) {
+			dev_err(&client->dev, "teardown failed %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = gpiochip_remove(&dev->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "gpiochip_remove failed %d\n", ret);
+		return ret;
+	}
+
+	kfree(dev);
+	return 0;
+}
+
+static const struct i2c_device_id adp5588_gpio_id[] = {
+	{DRV_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, adp5588_gpio_id);
+
+static struct i2c_driver adp5588_gpio_driver = {
+	.driver = {
+		   .name = DRV_NAME,
+		   },
+	.probe = adp5588_gpio_probe,
+	.remove = __devexit_p(adp5588_gpio_remove),
+	.id_table = adp5588_gpio_id,
+};
+
+static int __init adp5588_gpio_init(void)
+{
+	return i2c_add_driver(&adp5588_gpio_driver);
+}
+
+module_init(adp5588_gpio_init);
+
+static void __exit adp5588_gpio_exit(void)
+{
+	i2c_del_driver(&adp5588_gpio_driver);
+}
+
+module_exit(adp5588_gpio_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("GPIO ADP5588 Driver");
+MODULE_LICENSE("GPL");
diff -puN include/linux/i2c/adp5588.h~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders include/linux/i2c/adp5588.h
--- a/include/linux/i2c/adp5588.h~gpio-adp5588-gpio-new-driver-for-adp5588-gpio-expanders
+++ a/include/linux/i2c/adp5588.h
@@ -89,4 +89,16 @@ struct adp5588_kpad_platform_data {
 	unsigned short unlock_key2;	/* Unlock Key 2 */
 };
 
+struct adp5588_gpio_platform_data {
+	unsigned gpio_start;		/* GPIO Chip base # */
+	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
+	int	(*setup)(struct i2c_client *client,
+				int gpio, unsigned ngpio,
+				void *context);
+	int	(*teardown)(struct i2c_client *client,
+				int gpio, unsigned ngpio,
+				void *context);
+	void	*context;
+};
+
 #endif
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

