From: akpm@linux-foundation.org
Subject: + mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:19:45 -0700
Message-ID: <200909292119.n8TLJjwa024526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZI2VVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, sameo@linux.intel.com, vapier@gentoo.org


The patch titled
     mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
has been added to the -mm tree.  Its filename is
     mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver.patch

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
Subject: mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
From: Michael Hennerich <michael.hennerich@analog.com>

Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs

Subdevs:
LCD Backlight   : drivers/video/backlight/adp5520_bl
LEDs            : drivers/led/leds-adp5520
GPIO            : drivers/gpio/adp5520-gpio (ADP5520 only)
Keys            : drivers/input/keyboard/adp5520-keys (ADP5520 only)

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig         |   10 
 drivers/mfd/Makefile        |    1 
 drivers/mfd/adp5520.c       |  371 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/adp5520.h |  303 +++++++++++++++++++++++++++
 4 files changed, 685 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver
+++ a/drivers/mfd/Kconfig
@@ -160,6 +160,16 @@ config PMIC_DA903X
 	  individual components like LCD backlight, voltage regulators,
 	  LEDs and battery-charger under the corresponding menus.
 
+config PMIC_ADP5520
+	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
+	depends on I2C=y
+	help
+	  Say yes here to add support for Analog Devices AD5520 and ADP5501,
+	  Multifunction Power Management IC. This includes
+	  the I2C driver and the core APIs _only_, you have to select
+	  individual components like LCD backlight, LEDs, GPIOs and Kepad
+	  under the corresponding menus.
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff -puN drivers/mfd/Makefile~mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver
+++ a/drivers/mfd/Makefile
@@ -50,3 +50,4 @@ obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-a
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
+obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
diff -puN /dev/null drivers/mfd/adp5520.c
--- /dev/null
+++ a/drivers/mfd/adp5520.c
@@ -0,0 +1,371 @@
+/*
+ * Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
+ * LCD Backlight: drivers/video/backlight/adp5520_bl
+ * LEDs		: drivers/led/leds-adp5520
+ * GPIO		: drivers/gpio/adp5520-gpio (ADP5520 only)
+ * Keys		: drivers/input/keyboard/adp5520-keys (ADP5520 only)
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Derived from da903x:
+ * Copyright (C) 2008 Compulab, Ltd.
+ * 	Mike Rapoport <mike@compulab.co.il>
+ *
+ * Copyright (C) 2006-2008 Marvell International Ltd.
+ * 	Eric Miao <eric.miao@marvell.com>
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/adp5520.h>
+
+struct adp5520_chip {
+	struct i2c_client *client;
+	struct device *dev;
+	struct mutex lock;
+	struct work_struct irq_work;
+	struct blocking_notifier_head notifier_list;
+	int irq;
+};
+
+static int __adp5520_read(struct i2c_client *client,
+				int reg, uint8_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
+		return ret;
+	}
+
+	*val = (uint8_t)ret;
+	return 0;
+}
+
+static int __adp5520_write(struct i2c_client *client,
+				 int reg, uint8_t val)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
+				val, reg);
+		return ret;
+	}
+	return 0;
+}
+
+int __adp5520_ack_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
+{
+	struct adp5520_chip *chip = i2c_get_clientdata(client);
+	uint8_t reg_val;
+	int ret;
+
+	mutex_lock(&chip->lock);
+
+	ret = __adp5520_read(client, reg, &reg_val);
+
+	if (!ret) {
+		reg_val |= bit_mask;
+		ret = __adp5520_write(client, reg, reg_val);
+	}
+
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+int adp5520_write(struct device *dev, int reg, uint8_t val)
+{
+	return __adp5520_write(to_i2c_client(dev), reg, val);
+}
+EXPORT_SYMBOL_GPL(adp5520_write);
+
+int adp5520_read(struct device *dev, int reg, uint8_t *val)
+{
+	return __adp5520_read(to_i2c_client(dev), reg, val);
+}
+EXPORT_SYMBOL_GPL(adp5520_read);
+
+int adp5520_set_bits(struct device *dev, int reg, uint8_t bit_mask)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
+	uint8_t reg_val;
+	int ret;
+
+	mutex_lock(&chip->lock);
+
+	ret = __adp5520_read(chip->client, reg, &reg_val);
+
+	if (!ret && ((reg_val & bit_mask) == 0)) {
+		reg_val |= bit_mask;
+		ret = __adp5520_write(chip->client, reg, reg_val);
+	}
+
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adp5520_set_bits);
+
+int adp5520_clr_bits(struct device *dev, int reg, uint8_t bit_mask)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
+	uint8_t reg_val;
+	int ret;
+
+	mutex_lock(&chip->lock);
+
+	ret = __adp5520_read(chip->client, reg, &reg_val);
+
+	if (!ret && (reg_val & bit_mask)) {
+		reg_val &= ~bit_mask;
+		ret = __adp5520_write(chip->client, reg, reg_val);
+	}
+
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adp5520_clr_bits);
+
+int adp5520_register_notifier(struct device *dev, struct notifier_block *nb,
+				unsigned int events)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
+
+	if (chip->irq) {
+		adp5520_set_bits(chip->dev, INTERRUPT_ENABLE,
+			events & (KP_IEN | KR_IEN | OVP_IEN | CMPR_IEN));
+
+		return blocking_notifier_chain_register(&chip->notifier_list,
+			 nb);
+	}
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(adp5520_register_notifier);
+
+int adp5520_unregister_notifier(struct device *dev, struct notifier_block *nb,
+				unsigned int events)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(dev);
+
+	adp5520_clr_bits(chip->dev, INTERRUPT_ENABLE,
+		events & (KP_IEN | KR_IEN | OVP_IEN | CMPR_IEN));
+
+	return blocking_notifier_chain_unregister(&chip->notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(adp5520_unregister_notifier);
+
+static void adp5520_irq_work(struct work_struct *work)
+{
+	struct adp5520_chip *chip =
+		container_of(work, struct adp5520_chip, irq_work);
+	unsigned int events;
+	uint8_t reg_val;
+	int ret;
+
+	ret = __adp5520_read(chip->client, MODE_STATUS, &reg_val);
+	if (ret)
+		goto out;
+
+	events =  reg_val & (OVP_INT | CMPR_INT | GPI_INT | KR_INT | KP_INT);
+
+	blocking_notifier_call_chain(&chip->notifier_list, events, NULL);
+	/* ACK, Sticky bits are W1C */
+	__adp5520_ack_bits(chip->client, MODE_STATUS, events);
+
+out:
+	enable_irq(chip->client->irq);
+}
+
+static irqreturn_t adp5520_irq_handler(int irq, void *data)
+{
+	struct adp5520_chip *chip = data;
+
+	disable_irq_nosync(irq);
+	schedule_work(&chip->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static int __remove_subdev(struct device *dev, void *unused)
+{
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
+static int adp5520_remove_subdevs(struct adp5520_chip *chip)
+{
+	return device_for_each_child(chip->dev, NULL, __remove_subdev);
+}
+
+static int __devinit adp5520_add_subdevs(struct adp5520_chip *chip,
+					struct adp5520_platform_data *pdata)
+{
+	struct adp5520_subdev_info *subdev;
+	struct platform_device *pdev;
+	int i, ret = 0;
+
+	for (i = 0; i < pdata->num_subdevs; i++) {
+		subdev = &pdata->subdevs[i];
+
+		pdev = platform_device_alloc(subdev->name, subdev->id);
+
+		pdev->dev.parent = chip->dev;
+		pdev->dev.platform_data = subdev->platform_data;
+
+		ret = platform_device_add(pdev);
+		if (ret)
+			goto failed;
+	}
+	return 0;
+
+failed:
+	adp5520_remove_subdevs(chip);
+	return ret;
+}
+
+static int __devinit adp5520_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct adp5520_platform_data *pdata = client->dev.platform_data;
+	struct adp5520_chip *chip;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter,
+					I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS Word Data not Supported\n");
+		return -EIO;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, chip);
+	chip->client = client;
+
+	chip->dev = &client->dev;
+	chip->irq = client->irq;
+	mutex_init(&chip->lock);
+
+	if (chip->irq) {
+		INIT_WORK(&chip->irq_work, adp5520_irq_work);
+		BLOCKING_INIT_NOTIFIER_HEAD(&chip->notifier_list);
+
+		ret = request_irq(chip->irq, adp5520_irq_handler,
+				IRQF_DISABLED | IRQF_TRIGGER_LOW,
+				"adp5520", chip);
+		if (ret) {
+			dev_err(&client->dev, "failed to request irq %d\n",
+					chip->irq);
+			goto out_free_chip;
+		}
+	}
+
+	ret = adp5520_write(chip->dev, MODE_STATUS, nSTNBY);
+	if (ret) {
+		dev_err(&client->dev, "failed to write\n");
+		goto out_free_irq;
+	}
+
+	ret = adp5520_add_subdevs(chip, pdata);
+
+	if (!ret)
+		return ret;
+
+out_free_irq:
+	if (chip->irq)
+		free_irq(chip->irq, chip);
+
+out_free_chip:
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+
+	return ret;
+}
+
+static int __devexit adp5520_remove(struct i2c_client *client)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+
+	if (chip->irq)
+		free_irq(chip->irq, chip);
+
+	adp5520_remove_subdevs(chip);
+	adp5520_write(chip->dev, MODE_STATUS, 0);
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int adp5520_suspend(struct i2c_client *client,
+				 pm_message_t state)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+
+	adp5520_clr_bits(chip->dev, MODE_STATUS, nSTNBY);
+	return 0;
+}
+
+static int adp5520_resume(struct i2c_client *client)
+{
+	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
+
+	adp5520_set_bits(chip->dev, MODE_STATUS, nSTNBY);
+	return 0;
+}
+#else
+#define adp5520_suspend	NULL
+#define adp5520_resume	NULL
+#endif
+
+static const struct i2c_device_id adp5520_id[] = {
+	{ "pmic-adp5520", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adp5520_id);
+
+static struct i2c_driver adp5520_driver = {
+	.driver = {
+		.name	= "adp5520",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_probe,
+	.remove		= __devexit_p(adp5520_remove),
+	.suspend	= adp5520_suspend,
+	.resume		= adp5520_resume,
+	.id_table 	= adp5520_id,
+};
+
+static int __init adp5520_init(void)
+{
+	return i2c_add_driver(&adp5520_driver);
+}
+module_init(adp5520_init);
+
+static void __exit adp5520_exit(void)
+{
+	i2c_del_driver(&adp5520_driver);
+}
+module_exit(adp5520_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/mfd/adp5520.h
--- /dev/null
+++ a/include/linux/mfd/adp5520.h
@@ -0,0 +1,303 @@
+/*
+ * Definitions and platfrom data for Analog Devices
+ * ADP5520/ADP5501 MFD PMICs (Backlight, LED, GPIO and Keys)
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+
+#ifndef __LINUX_MFD_ADP5520_H
+#define __LINUX_MFD_ADP5520_H
+
+#define ID_ADP5520		5520
+#define ID_ADP5501		5501
+
+/*
+ * ADP5520/ADP5501 Register Map
+ */
+
+#define MODE_STATUS 		0x00
+#define INTERRUPT_ENABLE 	0x01
+#define BL_CONTROL 		0x02
+#define BL_TIME 		0x03
+#define BL_FADE 		0x04
+#define DAYLIGHT_MAX 		0x05
+#define DAYLIGHT_DIM 		0x06
+#define OFFICE_MAX 		0x07
+#define OFFICE_DIM 		0x08
+#define DARK_MAX 		0x09
+#define DARK_DIM 		0x0A
+#define BL_VALUE 		0x0B
+#define ALS_CMPR_CFG 		0x0C
+#define L2_TRIP 		0x0D
+#define L2_HYS 			0x0E
+#define L3_TRIP 		0x0F
+#define L3_HYS 			0x10
+#define LED_CONTROL 		0x11
+#define LED_TIME 		0x12
+#define LED_FADE 		0x13
+#define LED1_CURRENT 		0x14
+#define LED2_CURRENT 		0x15
+#define LED3_CURRENT 		0x16
+
+/*
+ * ADP5520 Register Map
+ */
+
+#define GPIO_CFG_1 		0x17
+#define GPIO_CFG_2 		0x18
+#define GPIO_IN 		0x19
+#define GPIO_OUT 		0x1A
+#define GPIO_INT_EN 		0x1B
+#define GPIO_INT_STAT 		0x1C
+#define GPIO_INT_LVL 		0x1D
+#define GPIO_DEBOUNCE 		0x1E
+#define GPIO_PULLUP 		0x1F
+#define KP_INT_STAT_1 		0x20
+#define KP_INT_STAT_2 		0x21
+#define KR_INT_STAT_1 		0x22
+#define KR_INT_STAT_2 		0x23
+#define KEY_STAT_1 		0x24
+#define KEY_STAT_2 		0x25
+
+/*
+ * MODE_STATUS bits
+ */
+
+#define nSTNBY		(1 << 7)
+#define BL_EN           (1 << 6)
+#define DIM_EN          (1 << 5)
+#define OVP_INT         (1 << 4)
+#define CMPR_INT        (1 << 3)
+#define GPI_INT         (1 << 2)
+#define KR_INT          (1 << 1)
+#define KP_INT          (1 << 0)
+
+/*
+ * INTERRUPT_ENABLE bits
+ */
+
+#define AUTO_LD_EN      (1 << 4)
+#define CMPR_IEN        (1 << 3)
+#define OVP_IEN         (1 << 2)
+#define KR_IEN          (1 << 1)
+#define KP_IEN          (1 << 0)
+
+/*
+ * BL_CONTROL bits
+ */
+
+#define BL_LVL          ((x) << 5)
+#define BL_LAW          ((x) << 4)
+#define BL_AUTO_ADJ     (1 << 3)
+#define OVP_EN          (1 << 2)
+#define FOVR            (1 << 1)
+#define KP_BL_EN        (1 << 0)
+
+/*
+ * ALS_CMPR_CFG bits
+ */
+
+#define L3_OUT		(1 << 3)
+#define L2_OUT		(1 << 2)
+#define L3_EN		(1 << 1)
+
+#define ADP5020_MAX_BRIGHTNESS	0x7F
+
+#define FADE_VAL(in, out)	((0xF & (in)) | ((0xF & (out)) << 4))
+#define BL_CTRL_VAL(law, auto)	(((1 & (auto)) << 3) | ((0x3 & (law)) << 4))
+#define ALS_CMPR_CFG_VAL(filt, l3_en)	(((0x7 & filt) << 5) | l3_en)
+
+/*
+ * LEDs subdevice bits and masks
+ */
+
+#define ADP5520_01_MAXLEDS 3
+
+#define FLAG_LED_MASK 		0x3
+#define FLAG_OFFT_SHIFT 	8
+#define FLAG_OFFT_MASK 		0x3
+
+#define R3_MODE		(1 << 5)
+#define C3_MODE		(1 << 4)
+#define LED_LAW		(1 << 3)
+#define LED3_EN		(1 << 2)
+#define LED2_EN		(1 << 1)
+#define LED1_EN		(1 << 0)
+
+/*
+ * GPIO subdevice bits and masks
+ */
+
+#define ADP5520_MAXGPIOS	8
+
+#define GPIO_C3		(1 << 7)	/* LED2 or GPIO7 aka C3 */
+#define GPIO_C2		(1 << 6)
+#define GPIO_C1		(1 << 5)
+#define GPIO_C0		(1 << 4)
+#define GPIO_R3		(1 << 3)	/* LED3 or GPIO3 aka R3 */
+#define GPIO_R2		(1 << 2)
+#define GPIO_R1		(1 << 1)
+#define GPIO_R0		(1 << 0)
+
+struct adp5520_gpio_platfrom_data {
+	unsigned gpio_start;
+	u8 gpio_en_mask;
+	u8 gpio_pullup_mask;
+};
+
+/*
+ * Keypad subdevice bits and masks
+ */
+
+#define ADP5520_MAXKEYS	16
+
+#define COL_C3 		(1 << 7)	/* LED2 or GPIO7 aka C3 */
+#define COL_C2		(1 << 6)
+#define COL_C1		(1 << 5)
+#define COL_C0		(1 << 4)
+#define ROW_R3		(1 << 3)	/* LED3 or GPIO3 aka R3 */
+#define ROW_R2		(1 << 2)
+#define ROW_R1		(1 << 1)
+#define ROW_R0		(1 << 0)
+
+#define KEY(row, col) (col + row * 4)
+#define ADP5520_KEYMAPSIZE	ADP5520_MAXKEYS
+
+struct adp5520_keys_platfrom_data {
+	int rows_en_mask;		/* Number of rows */
+	int cols_en_mask;		/* Number of columns */
+	const unsigned short *keymap;	/* Pointer to keymap */
+	unsigned short keymapsize;	/* Keymap size */
+	unsigned repeat:1;		/* Enable key repeat */
+};
+
+
+/*
+ * LEDs subdevice platfrom data
+ */
+
+#define FLAG_ID_ADP5520_LED1_ADP5501_LED0 	1	/* ADP5520 PIN ILED */
+#define FLAG_ID_ADP5520_LED2_ADP5501_LED1 	2	/* ADP5520 PIN C3 */
+#define FLAG_ID_ADP5520_LED3_ADP5501_LED2 	3	/* ADP5520 PIN R3 */
+
+#define LED_DIS_BLINK	(0 << FLAG_OFFT_SHIFT)
+#define LED_OFFT_600ms	(1 << FLAG_OFFT_SHIFT)
+#define LED_OFFT_800ms	(2 << FLAG_OFFT_SHIFT)
+#define LED_OFFT_1200ms	(3 << FLAG_OFFT_SHIFT)
+
+#define LED_ONT_200ms	0
+#define LED_ONT_600ms	1
+#define LED_ONT_800ms	2
+#define LED_ONT_1200ms	3
+
+struct adp5520_leds_platfrom_data {
+	int num_leds;
+	struct led_info	*leds;
+	u8 fade_in;		/* Backlight Fade-In Timer */
+	u8 fade_out;		/* Backlight Fade-Out Timer */
+	u8 led_on_time;
+};
+
+/*
+ * Backlight subdevice platfrom data
+ */
+
+#define FADE_T_DIS	0	/* Fade Timer Disabled */
+#define FADE_T_300ms	1	/* 0.3 Sec */
+#define FADE_T_600ms	2
+#define FADE_T_900ms	3
+#define FADE_T_1200ms	4
+#define FADE_T_1500ms	5
+#define FADE_T_1800ms	6
+#define FADE_T_2100ms	7
+#define FADE_T_2400ms	8
+#define FADE_T_2700ms	9
+#define FADE_T_3000ms	10
+#define FADE_T_3500ms	11
+#define FADE_T_4000ms	12
+#define FADE_T_4500ms	13
+#define FADE_T_5000ms	14
+#define FADE_T_5500ms	15	/* 5.5 Sec */
+
+#define BL_LAW_LINEAR 	0
+#define BL_LAW_SQUARE 	1
+#define BL_LAW_CUBIC1 	2
+#define BL_LAW_CUBIC2 	3
+
+#define BL_AMBL_FILT_80ms 	0	/* Light sensor filter time */
+#define BL_AMBL_FILT_160ms 	1
+#define BL_AMBL_FILT_320ms 	2
+#define BL_AMBL_FILT_640ms 	3
+#define BL_AMBL_FILT_1280ms 	4
+#define BL_AMBL_FILT_2560ms 	5
+#define BL_AMBL_FILT_5120ms 	6
+#define BL_AMBL_FILT_10240ms 	7	/* 10.24 sec */
+
+	/*
+	 * Blacklight current 0..30mA
+	 */
+#define BL_CUR_mA(I)		((I * 127) / 30)
+
+	/*
+	 * L2 comparator current 0..1000uA
+	 */
+#define L2_COMP_CURR_uA(I)	((I * 255) / 1000)
+
+	/*
+	 * L3 comparator current 0..127uA
+	 */
+#define L3_COMP_CURR_uA(I)	((I * 255) / 127)
+
+struct adp5520_backlight_platfrom_data {
+	u8 fade_in;		/* Backlight Fade-In Timer */
+	u8 fade_out;		/* Backlight Fade-Out Timer */
+	u8 fade_led_law;	/* fade-on/fade-off transfer characteristic */
+
+	u8 en_ambl_sens;	/* 1 = enable ambient light sensor */
+	u8 abml_filt;		/* Light sensor filter time */
+	u8 l1_daylight_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l1_daylight_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l2_office_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l2_office_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l3_dark_max;		/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l3_dark_dim;		/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l2_trip;		/* use L2_COMP_CURR_uA(I) 0 <= I <= 1000 uA */
+	u8 l2_hyst;		/* use L2_COMP_CURR_uA(I) 0 <= I <= 1000 uA */
+	u8 l3_trip;		/* use L3_COMP_CURR_uA(I) 0 <= I <= 127 uA */
+	u8 l3_hyst;		/* use L3_COMP_CURR_uA(I) 0 <= I <= 127 uA */
+};
+
+/*
+ * MFD chip platfrom data
+ */
+
+struct adp5520_subdev_info {
+	int		id;
+	const char	*name;
+	void		*platform_data;
+};
+
+struct adp5520_platform_data {
+	int num_subdevs;
+	struct adp5520_subdev_info *subdevs;
+};
+
+/*
+ * MFD chip functions
+ */
+
+extern int adp5520_read(struct device *dev, int reg, uint8_t *val);
+extern int adp5520_write(struct device *dev, int reg, u8 val);
+extern int adp5520_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
+extern int adp5520_set_bits(struct device *dev, int reg, uint8_t bit_mask);
+
+extern int adp5520_register_notifier(struct device *dev,
+		 struct notifier_block *nb, unsigned int events);
+
+extern int adp5520_unregister_notifier(struct device *dev,
+		struct notifier_block *nb, unsigned int events);
+
+#endif /* __LINUX_MFD_ADP5520_H */
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
mfd-adp5520-multifunction-lcd-backlight-and-keypad-input-device-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

