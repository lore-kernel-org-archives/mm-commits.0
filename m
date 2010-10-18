From: akpm@linux-foundation.org
Subject: + gpio-adp5588-gpio-support-interrupt-controller.patch added to -mm tree
Date: Mon, 18 Oct 2010 16:09:51 -0700
Message-ID: <201010182309.o9IN9pNw007261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab0JRXKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 19:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     gpio: adp5588-gpio: support interrupt controller
has been added to the -mm tree.  Its filename is
     gpio-adp5588-gpio-support-interrupt-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: adp5588-gpio: support interrupt controller
From: Michael Hennerich <michael.hennerich@analog.com>

Implement irq_chip functionality on ADP5588/5587 GPIO expanders.  Only
level sensitive interrupts are supported.  Interrupts provided by this
irq_chip must be requested using request_threaded_irq().

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    7 
 drivers/gpio/adp5588-gpio.c |  252 +++++++++++++++++++++++++++++++++-
 include/linux/i2c/adp5588.h |    1 
 3 files changed, 253 insertions(+), 7 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-adp5588-gpio-support-interrupt-controller drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-adp5588-gpio-support-interrupt-controller
+++ a/drivers/gpio/Kconfig
@@ -284,6 +284,13 @@ config GPIO_ADP5588
 	  To compile this driver as a module, choose M here: the module will be
 	  called adp5588-gpio.
 
+config GPIO_ADP5588_IRQ
+	bool "Interrupt controller support for ADP5588"
+	depends on GPIO_ADP5588=y
+	help
+	  Say yes here to enable the adp5588 to be used as an interrupt
+	  controller. It requires the driver to be built in the kernel.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
diff -puN drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-support-interrupt-controller drivers/gpio/adp5588-gpio.c
--- a/drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-support-interrupt-controller
+++ a/drivers/gpio/adp5588-gpio.c
@@ -1,8 +1,8 @@
 /*
  * GPIO Chip driver for Analog Devices
- * ADP5588 I/O Expander and QWERTY Keypad Controller
+ * ADP5588/ADP5587 I/O Expander and QWERTY Keypad Controller
  *
- * Copyright 2009 Analog Devices Inc.
+ * Copyright 2009-2010 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -13,21 +13,50 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <linux/i2c/adp5588.h>
 
+ /* Configuration Register1 */
+#define AUTO_INC	(1 << 7)
+#define GPIEM_CFG	(1 << 6)
+#define OVR_FLOW_M	(1 << 5)
+#define INT_CFG		(1 << 4)
+#define OVR_FLOW_IEN	(1 << 3)
+#define K_LCK_IM	(1 << 2)
+#define GPI_IEN		(1 << 1)
+#define KE_IEN		(1 << 0)
+
+/* Interrupt Status Register */
+#define GPI_INT		(1 << 1)
+#define KE_INT		(1 << 0)
+
 #define DRV_NAME		"adp5588-gpio"
 #define MAXGPIO			18
 #define ADP_BANK(offs)		((offs) >> 3)
 #define ADP_BIT(offs)		(1u << ((offs) & 0x7))
 
+/*
+ * Early pre 4.0 Silicon required to delay readout by at least 25ms,
+ * since the Event Counter Register updated 25ms after the interrupt
+ * asserted.
+ */
+#define WA_DELAYED_READOUT_REVID(rev)		((rev) < 4)
+
 struct adp5588_gpio {
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
 	struct mutex lock;	/* protect cached dir, dat_out */
+	struct mutex irq_lock;	/* P: IRQ */
 	unsigned gpio_start;
+	unsigned irq_base;
 	uint8_t dat_out[3];
 	uint8_t dir[3];
+	uint8_t int_lvl[3];
+	uint8_t int_en[3];
+	uint8_t irq_mask[3];
+	uint8_t irq_stat[3];
 };
 
 static int adp5588_gpio_read(struct i2c_client *client, u8 reg)
@@ -125,6 +154,200 @@ static int adp5588_gpio_direction_output
 	return ret;
 }
 
+#ifdef CONFIG_GPIO_ADP5588_IRQ
+static int adp5588_gpio_to_irq(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5588_gpio *dev =
+		container_of(chip, struct adp5588_gpio, gpio_chip);
+	return dev->irq_base + off;
+}
+
+static void adp5588_irq_bus_lock(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	mutex_lock(&dev->irq_lock);
+}
+
+static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i <= ADP_BANK(MAXGPIO); i++)
+		if (dev->int_en[i] ^ dev->irq_mask[i]) {
+			dev->int_en[i] = dev->irq_mask[i];
+			adp5588_gpio_write(dev->client, GPIO_INT_EN1 + i,
+					   dev->int_en[i]);
+		}
+
+	mutex_unlock(&dev->irq_lock);
+}
+
+static void adp5588_irq_mask(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	unsigned gpio = irq - dev->irq_base;
+
+	dev->irq_mask[ADP_BANK(gpio)] &= ~ADP_BIT(gpio);
+}
+
+static void adp5588_irq_unmask(unsigned int irq)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	unsigned gpio = irq - dev->irq_base;
+
+	dev->irq_mask[ADP_BANK(gpio)] |= ADP_BIT(gpio);
+}
+
+static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	uint16_t gpio = irq - dev->irq_base;
+	unsigned bank, bit;
+
+	if ((type & IRQ_TYPE_EDGE_BOTH)) {
+		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
+			irq, type);
+		return -EINVAL;
+	}
+
+	bank = ADP_BANK(gpio);
+	bit = ADP_BIT(gpio);
+
+	if (type & IRQ_TYPE_LEVEL_HIGH)
+		dev->int_lvl[bank] |= bit;
+	else if (type & IRQ_TYPE_LEVEL_LOW)
+		dev->int_lvl[bank] &= ~bit;
+	else
+		return -EINVAL;
+
+	might_sleep();
+
+	adp5588_gpio_direction_input(&dev->gpio_chip, gpio);
+	adp5588_gpio_write(dev->client, GPIO_INT_LVL1 + bank,
+			   dev->int_lvl[bank]);
+
+	return 0;
+}
+
+static struct irq_chip adp5588_irq_chip = {
+	.name			= "adp5588",
+	.mask			= adp5588_irq_mask,
+	.unmask			= adp5588_irq_unmask,
+	.bus_lock		= adp5588_irq_bus_lock,
+	.bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
+	.set_type		= adp5588_irq_set_type,
+};
+
+static int adp5588_gpio_read_intstat(struct i2c_client *client, u8 *buf)
+{
+	int ret = i2c_smbus_read_i2c_block_data(client, GPIO_INT_STAT1, 3, buf);
+
+	if (ret < 0)
+		dev_err(&client->dev, "Read INT_STAT Error\n");
+
+	return ret;
+}
+
+static irqreturn_t adp5588_irq_handler(int irq, void *devid)
+{
+	struct adp5588_gpio *dev = devid;
+	unsigned status, bank, bit, pending;
+	int ret;
+	status = adp5588_gpio_read(dev->client, INT_STAT);
+
+	if (status & GPI_INT) {
+		ret = adp5588_gpio_read_intstat(dev->client, dev->irq_stat);
+		if (ret < 0)
+			memset(dev->irq_stat, 0, ARRAY_SIZE(dev->irq_stat));
+
+		for (bank = 0; bank <= ADP_BANK(MAXGPIO); bank++, bit = 0) {
+			pending = dev->irq_stat[bank] & dev->irq_mask[bank];
+
+			while (pending) {
+				if (pending & (1 << bit)) {
+					handle_nested_irq(dev->irq_base +
+							  (bank << 3) + bit);
+					pending &= ~(1 << bit);
+
+				}
+				bit++;
+			}
+		}
+	}
+
+	adp5588_gpio_write(dev->client, INT_STAT, status); /* Status is W1C */
+
+	return IRQ_HANDLED;
+}
+
+static int adp5588_irq_setup(struct adp5588_gpio *dev)
+{
+	struct i2c_client *client = dev->client;
+	struct adp5588_gpio_platform_data *pdata = client->dev.platform_data;
+	unsigned gpio;
+	int ret;
+
+	adp5588_gpio_write(client, CFG, AUTO_INC);
+	adp5588_gpio_write(client, INT_STAT, -1); /* status is W1C */
+	adp5588_gpio_read_intstat(client, dev->irq_stat); /* read to clear */
+
+	dev->irq_base = pdata->irq_base;
+	mutex_init(&dev->irq_lock);
+
+	for (gpio = 0; gpio < dev->gpio_chip.ngpio; gpio++) {
+		int irq = gpio + dev->irq_base;
+		set_irq_chip_data(irq, dev);
+		set_irq_chip_and_handler(irq, &adp5588_irq_chip,
+					 handle_level_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	ret = request_threaded_irq(client->irq,
+				   NULL,
+				   adp5588_irq_handler,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   dev_name(&client->dev), dev);
+	if (ret) {
+		dev_err(&client->dev, "failed to request irq %d\n",
+			client->irq);
+		goto out;
+	}
+
+	dev->gpio_chip.to_irq = adp5588_gpio_to_irq;
+	adp5588_gpio_write(client, CFG, AUTO_INC | INT_CFG | GPI_INT);
+
+	return 0;
+
+out:
+	dev->irq_base = 0;
+	return ret;
+}
+static void adp5588_irq_teardown(struct adp5588_gpio *dev)
+{
+	if (dev->irq_base)
+		free_irq(dev->client->irq, dev);
+}
+
+#else
+static int adp5588_irq_setup(struct adp5588_gpio *dev)
+{
+	struct i2c_client *client = dev->client;
+	dev_warn(&client->dev, "interrupt support not compiled in\n");
+
+	return 0;
+}
+
+static void adp5588_irq_teardown(struct adp5588_gpio *dev)
+{
+}
+#endif /* CONFIG_GPIO_ADP5588_IRQ */
+
 static int __devinit adp5588_gpio_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -166,7 +389,6 @@ static int __devinit adp5588_gpio_probe(
 
 	mutex_init(&dev->lock);
 
-
 	ret = adp5588_gpio_read(dev->client, DEV_ID);
 	if (ret < 0)
 		goto err;
@@ -179,18 +401,28 @@ static int __devinit adp5588_gpio_probe(
 		ret |= adp5588_gpio_write(client, KP_GPIO1 + i, 0);
 		ret |= adp5588_gpio_write(client, GPIO_PULL1 + i,
 				(pdata->pullup_dis_mask >> (8 * i)) & 0xFF);
-
+		ret |= adp5588_gpio_write(client, GPIO_INT_EN1 + i, 0);
 		if (ret)
 			goto err;
 	}
 
+	if (pdata->irq_base) {
+		if (WA_DELAYED_READOUT_REVID(revid)) {
+			dev_warn(&client->dev, "GPIO int not supported\n");
+		} else {
+			ret = adp5588_irq_setup(dev);
+			if (ret)
+				goto err;
+		}
+	}
+
 	ret = gpiochip_add(&dev->gpio_chip);
 	if (ret)
-		goto err;
+		goto err_irq;
 
-	dev_info(&client->dev, "gpios %d..%d on a %s Rev. %d\n",
+	dev_info(&client->dev, "gpios %d..%d (IRQ Base %d) on a %s Rev. %d\n",
 			gc->base, gc->base + gc->ngpio - 1,
-			client->name, revid);
+			pdata->irq_base, client->name, revid);
 
 	if (pdata->setup) {
 		ret = pdata->setup(client, gc->base, gc->ngpio, pdata->context);
@@ -199,8 +431,11 @@ static int __devinit adp5588_gpio_probe(
 	}
 
 	i2c_set_clientdata(client, dev);
+
 	return 0;
 
+err_irq:
+	adp5588_irq_teardown(dev);
 err:
 	kfree(dev);
 	return ret;
@@ -222,6 +457,9 @@ static int __devexit adp5588_gpio_remove
 		}
 	}
 
+	if (dev->irq_base)
+		free_irq(dev->client->irq, dev);
+
 	ret = gpiochip_remove(&dev->gpio_chip);
 	if (ret) {
 		dev_err(&client->dev, "gpiochip_remove failed %d\n", ret);
diff -puN include/linux/i2c/adp5588.h~gpio-adp5588-gpio-support-interrupt-controller include/linux/i2c/adp5588.h
--- a/include/linux/i2c/adp5588.h~gpio-adp5588-gpio-support-interrupt-controller
+++ a/include/linux/i2c/adp5588.h
@@ -128,6 +128,7 @@ struct adp5588_kpad_platform_data {
 
 struct adp5588_gpio_platform_data {
 	unsigned gpio_start;		/* GPIO Chip base # */
+	unsigned irq_base;		/* interrupt base # */
 	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
 	int	(*setup)(struct i2c_client *client,
 				int gpio, unsigned ngpio,
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch

