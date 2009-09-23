From: akpm@linux-foundation.org
Subject: [merged] gpio-gpio-support-for-adp5520-adp5501-mfd-pmics.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:55 -0700
Message-ID: <200909231959.n8NJxtdt011999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZIWUB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, david-b@pacbell.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     gpio: gpio support for ADP5520/ADP5501 MFD PMICs
has been removed from the -mm tree.  Its filename was
     gpio-gpio-support-for-adp5520-adp5501-mfd-pmics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: gpio support for ADP5520/ADP5501 MFD PMICs
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |   10 +
 drivers/gpio/Makefile       |    1 
 drivers/gpio/adp5520-gpio.c |  206 ++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-gpio-support-for-adp5520-adp5501-mfd-pmics drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-gpio-support-for-adp5520-adp5501-mfd-pmics
+++ a/drivers/gpio/Kconfig
@@ -162,6 +162,16 @@ config GPIO_WM831X
 	  Say yes here to access the GPIO signals of WM831x power management
 	  chips from Wolfson Microelectronics.
 
+config GPIO_ADP5520
+	tristate "GPIO Support for ADP5520 PMIC"
+	depends on PMIC_ADP5520
+	help
+	  This option enables support for on-chip GPIO found
+	  on Analog Devices ADP5520 PMICs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called adp5520-gpio.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_BT8XX
diff -puN drivers/gpio/Makefile~gpio-gpio-support-for-adp5520-adp5501-mfd-pmics drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-gpio-support-for-adp5520-adp5501-mfd-pmics
+++ a/drivers/gpio/Makefile
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
+obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
diff -puN /dev/null drivers/gpio/adp5520-gpio.c
--- /dev/null
+++ a/drivers/gpio/adp5520-gpio.c
@@ -0,0 +1,206 @@
+/*
+ * GPIO driver for Analog Devices ADP5520 MFD PMICs
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/adp5520.h>
+
+#include <linux/gpio.h>
+
+struct adp5520_gpio {
+	struct device *master;
+	struct gpio_chip gpio_chip;
+	unsigned char lut[ADP5520_MAXGPIOS];
+	unsigned long output;
+};
+
+static int adp5520_gpio_get_value(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5520_gpio *dev;
+	uint8_t reg_val;
+
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	/*
+	 * There are dedicated registers for GPIO IN/OUT.
+	 * Make sure we return the right value, even when configured as output
+	 */
+
+	if (test_bit(off, &dev->output))
+		adp5520_read(dev->master, GPIO_OUT, &reg_val);
+	else
+		adp5520_read(dev->master, GPIO_IN, &reg_val);
+
+	return !!(reg_val & dev->lut[off]);
+}
+
+static void adp5520_gpio_set_value(struct gpio_chip *chip,
+		unsigned off, int val)
+{
+	struct adp5520_gpio *dev;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	if (val)
+		adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+	else
+		adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+}
+
+static int adp5520_gpio_direction_input(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5520_gpio *dev;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	clear_bit(off, &dev->output);
+
+	return adp5520_clr_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+}
+
+static int adp5520_gpio_direction_output(struct gpio_chip *chip,
+		unsigned off, int val)
+{
+	struct adp5520_gpio *dev;
+	int ret = 0;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	set_bit(off, &dev->output);
+
+	if (val)
+		ret |= adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+	else
+		ret |= adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+
+	ret |= adp5520_set_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+
+	return ret;
+}
+
+static int __devinit adp5520_gpio_probe(struct platform_device *pdev)
+{
+	struct adp5520_gpio_platfrom_data *pdata = pdev->dev.platform_data;
+	struct adp5520_gpio *dev;
+	struct gpio_chip *gc;
+	int ret, i, gpios;
+	unsigned char ctl_mask = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdev->id != ID_ADP5520) {
+		dev_err(&pdev->dev, "only ADP5520 supports GPIO\n");
+		return -ENODEV;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	dev->master = pdev->dev.parent;
+
+	for (gpios = 0, i = 0; i < ADP5520_MAXGPIOS; i++)
+		if (pdata->gpio_en_mask & (1 << i))
+			dev->lut[gpios++] = 1 << i;
+
+	if (gpios < 1) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	gc = &dev->gpio_chip;
+	gc->direction_input  = adp5520_gpio_direction_input;
+	gc->direction_output = adp5520_gpio_direction_output;
+	gc->get = adp5520_gpio_get_value;
+	gc->set = adp5520_gpio_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = pdata->gpio_start;
+	gc->ngpio = gpios;
+	gc->label = pdev->name;
+	gc->owner = THIS_MODULE;
+
+	ret = adp5520_clr_bits(dev->master, GPIO_CFG_1,
+		pdata->gpio_en_mask);
+
+	if (pdata->gpio_en_mask & GPIO_C3)
+		ctl_mask |= C3_MODE;
+
+	if (pdata->gpio_en_mask & GPIO_R3)
+		ctl_mask |= R3_MODE;
+
+	if (ctl_mask)
+		ret = adp5520_set_bits(dev->master, LED_CONTROL,
+			ctl_mask);
+
+	ret |= adp5520_set_bits(dev->master, GPIO_PULLUP,
+		pdata->gpio_pullup_mask);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to write\n");
+		goto err;
+	}
+
+	ret = gpiochip_add(&dev->gpio_chip);
+	if (ret)
+		goto err;
+
+	platform_set_drvdata(pdev, dev);
+	return 0;
+
+err:
+	kfree(dev);
+	return ret;
+}
+
+static int __devexit adp5520_gpio_remove(struct platform_device *pdev)
+{
+	struct adp5520_gpio *dev;
+	int ret;
+
+	dev = platform_get_drvdata(pdev);
+	ret = gpiochip_remove(&dev->gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+		return ret;
+	}
+
+	kfree(dev);
+	return 0;
+}
+
+static struct platform_driver adp5520_gpio_driver = {
+	.driver	= {
+		.name	= "adp5520-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_gpio_probe,
+	.remove		= __devexit_p(adp5520_gpio_remove),
+};
+
+static int __init adp5520_gpio_init(void)
+{
+	return platform_driver_register(&adp5520_gpio_driver);
+}
+module_init(adp5520_gpio_init);
+
+static void __exit adp5520_gpio_exit(void)
+{
+	platform_driver_unregister(&adp5520_gpio_driver);
+}
+module_exit(adp5520_gpio_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("GPIO ADP5520 Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:adp5520-gpio");
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch

