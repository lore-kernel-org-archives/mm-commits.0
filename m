From: akpm@linux-foundation.org
Subject: + leds-add-support-for-philips-pca955x-i2c-led-drivers.patch added to -mm tree
Date: Mon, 19 May 2008 21:10:21 -0700
Message-ID: <200805200410.m4K4ALBL004198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070AbYETEKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 00:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ncase@xes-inc.com, rpurdie@rpsys.net


The patch titled
     leds: add support for Philips PCA955x I2C LED drivers
has been added to the -mm tree.  Its filename is
     leds-add-support-for-philips-pca955x-i2c-led-drivers.patch

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
Subject: leds: add support for Philips PCA955x I2C LED drivers
From: Nate Case <ncase@xes-inc.com>

This driver supports the PCA9550, PCA9551, PCA9552, and PCA9553
LED driver chips.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig        |    8 
 drivers/leds/Makefile       |    1 
 drivers/leds/leds-pca955x.c |  401 ++++++++++++++++++++++++++++++++++
 include/linux/leds.h        |   14 +
 4 files changed, 424 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-support-for-philips-pca955x-i2c-led-drivers drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-support-for-philips-pca955x-i2c-led-drivers
+++ a/drivers/leds/Kconfig
@@ -155,6 +155,14 @@ config LEDS_CLEVO_MAIL
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
 
+config LEDS_PCA955X
+	tristate "LED Support for PCA955x I2C chips"
+	depends on LEDS_CLASS && I2C
+	help
+	  This option enables support for LEDs connected to PCA955x
+	  LED driver chips accessed via the I2C bus.  Supported
+	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff -puN drivers/leds/Makefile~leds-add-support-for-philips-pca955x-i2c-led-drivers drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-support-for-philips-pca955x-i2c-led-drivers
+++ a/drivers/leds/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_LEDS_CM_X270)              
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
+obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -puN /dev/null drivers/leds/leds-pca955x.c
--- /dev/null
+++ a/drivers/leds/leds-pca955x.c
@@ -0,0 +1,401 @@
+/*
+ * drivers/leds/leds-pca955x.c
+ *
+ * Copyright 2007-2008 Extreme Engineering Solutions, Inc.
+ *
+ * Author: Nate Case <ncase@xes-inc.com>
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for various PCA955x I2C LED drivers
+ *
+ * Supported devices:
+ *
+ *	Device		Description		7-bit slave address
+ *	------		-----------		-------------------
+ *	PCA9550		2-bit driver		0x60 .. 0x61
+ *	PCA9551		8-bit driver		0x60 .. 0x67
+ *	PCA9552		16-bit driver		0x60 .. 0x67
+ *	PCA9553/01	4-bit driver		0x62
+ *	PCA9553/02	4-bit driver		0x63
+ *
+ * Philips PCA955x LED driver chips follow a register map as shown below:
+ *
+ *	Control Register		Description
+ *	----------------		-----------
+ *	0x0				Input register 0
+ *					..
+ *	NUM_INPUT_REGS - 1		Last Input register X
+ *
+ *	NUM_INPUT_REGS			Frequency prescaler 0
+ *	NUM_INPUT_REGS + 1		PWM register 0
+ *	NUM_INPUT_REGS + 2		Frequency prescaler 1
+ *	NUM_INPUT_REGS + 3		PWM register 1
+ *
+ *	NUM_INPUT_REGS + 4		LED selector 0
+ *	NUM_INPUT_REGS + 4
+ *	    + NUM_LED_REGS - 1		Last LED selector
+ *
+ *  where NUM_INPUT_REGS and NUM_LED_REGS vary depending on how many
+ *  bits the chip supports.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(x...) printk(KERN_INFO "leds-pca955x: " x)
+#else
+#define DBG(x...)
+#endif
+
+/* LED select registers determine the source that drives LED outputs */
+#define PCA955X_LS_LED_ON	0x0	/* Output LOW */
+#define PCA955X_LS_LED_OFF	0x1	/* Output HI-Z */
+#define PCA955X_LS_BLINK0	0x2	/* Blink at PWM0 rate */
+#define PCA955X_LS_BLINK1	0x3	/* Blink at PWM1 rate */
+
+enum pca955x_type {
+	pca9550,
+	pca9551,
+	pca9552,
+	pca9553,
+};
+
+struct pca955x_chipdef {
+	int			bits;
+	u8			slv_addr;	/* 7-bit slave address mask */
+	int			slv_addr_shift;	/* Number of bits to ignore */
+};
+
+static struct pca955x_chipdef pca955x_chipdefs[] = {
+	[pca9550] = {
+		.bits		= 2,
+		.slv_addr	= /* 110000x */ 0x60,
+		.slv_addr_shift	= 1,
+	},
+	[pca9551] = {
+		.bits		= 8,
+		.slv_addr	= /* 1100xxx */ 0x60,
+		.slv_addr_shift	= 3,
+	},
+	[pca9552] = {
+		.bits		= 16,
+		.slv_addr	= /* 1100xxx */ 0x60,
+		.slv_addr_shift	= 3,
+	},
+	[pca9553] = {
+		.bits		= 4,
+		.slv_addr	= /* 110001x */ 0x62,
+		.slv_addr_shift	= 1,
+	},
+};
+
+static const struct i2c_device_id pca955x_id[] = {
+	{ "pca9550", pca9550 },
+	{ "pca9551", pca9551 },
+	{ "pca9552", pca9552 },
+	{ "pca9553", pca9553 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pca955x_id);
+
+struct pca955x_led {
+	struct pca955x_chipdef	*chipdef;
+	struct i2c_client	*client;
+	struct work_struct	work;
+	spinlock_t		lock;
+	enum led_brightness	brightness;
+	struct led_classdev	led_cdev;
+	int			led_num;	/* 0 .. 15 potentially */
+	char			name[32];
+};
+
+/* 8 bits per input register */
+static inline int pca95xx_num_input_regs(int bits)
+{
+	return (bits + 7) / 8;
+}
+
+/* 4 bits per LED selector register */
+static inline int pca95xx_num_led_regs(int bits)
+{
+	return (bits + 3)  / 4;
+}
+
+/*
+ * Return an LED selector register value based on an existing one, with
+ * the appropriate 2-bit state value set for the given LED number (0-3).
+ */
+static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
+{
+	return (oldval & (~(0x3 << (led_num << 1)))) |
+		((state & 0x3) << (led_num << 1));
+}
+
+/*
+ * Write to frequency prescaler register, used to program the
+ * period of the PWM output.  period = (PSCx + 1) / 38
+ */
+static void pca955x_write_psc(struct i2c_client *client, int n, u8 val)
+{
+	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+
+	i2c_smbus_write_byte_data(client,
+		pca95xx_num_input_regs(pca955x->chipdef->bits) + 2*n,
+		val);
+}
+
+/*
+ * Write to PWM register, which determines the duty cycle of the
+ * output.  LED is OFF when the count is less than the value of this
+ * register, and ON when it is greater.  If PWMx == 0, LED is always OFF.
+ *
+ * Duty cycle is (256 - PWMx) / 256
+ */
+static void pca955x_write_pwm(struct i2c_client *client, int n, u8 val)
+{
+	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+
+	i2c_smbus_write_byte_data(client,
+		pca95xx_num_input_regs(pca955x->chipdef->bits) + 1 + 2*n,
+		val);
+}
+
+/*
+ * Write to LED selector register, which determines the source that
+ * drives the LED output.
+ */
+static void pca955x_write_ls(struct i2c_client *client, int n, u8 val)
+{
+	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+
+	i2c_smbus_write_byte_data(client,
+		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n,
+		val);
+}
+
+/*
+ * Read the LED selector register, which determines the source that
+ * drives the LED output.
+ */
+static u8 pca955x_read_ls(struct i2c_client *client, int n)
+{
+	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+
+	return (u8) i2c_smbus_read_byte_data(client,
+		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n);
+}
+
+static void pca955x_led_work(struct work_struct *work)
+{
+	struct pca955x_led *pca955x;
+	u8 ls;
+	int chip_ls;	/* which LSx to use (0-3 potentially) */
+	int ls_led;	/* which set of bits within LSx to use (0-3) */
+
+	pca955x = container_of(work, struct pca955x_led, work);
+	chip_ls = pca955x->led_num / 4;
+	ls_led = pca955x->led_num % 4;
+
+	ls = pca955x_read_ls(pca955x->client, chip_ls);
+
+	switch (pca955x->brightness) {
+	case LED_FULL:
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_ON);
+		break;
+	case LED_OFF:
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_OFF);
+		break;
+	case LED_HALF:
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK0);
+		break;
+	default:
+		/*
+		 * Use PWM1 for all other values.  This has the unwanted
+		 * side effect of making all LEDs on the chip share the
+		 * same brightness level if set to a value other than
+		 * OFF, HALF, or FULL.  But, this is probably better than
+		 * just turning off for all other values.
+		 */
+		pca955x_write_pwm(pca955x->client, 1, 255-pca955x->brightness);
+		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK1);
+		break;
+	}
+
+	pca955x_write_ls(pca955x->client, chip_ls, ls);
+}
+
+void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
+{
+	struct pca955x_led *pca955x;
+
+	pca955x = container_of(led_cdev, struct pca955x_led, led_cdev);
+
+	spin_lock(&pca955x->lock);
+	pca955x->brightness = value;
+
+	/*
+	 * Must use workqueue for the actual I/O since I2C operations
+	 * can sleep.
+	 */
+	schedule_work(&pca955x->work);
+
+	spin_unlock(&pca955x->lock);
+}
+
+static int __devinit pca955x_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct pca955x_led *pca955x;
+	int i;
+	int err = -ENODEV;
+	struct pca955x_chipdef *chip;
+	struct i2c_adapter *adapter;
+	struct led_platform_data *pdata;
+
+	chip = &pca955x_chipdefs[id->driver_data];
+	adapter = to_i2c_adapter(client->dev.parent);
+	pdata = client->dev.platform_data;
+
+	DBG("probe() enter: chip 0x%02x, with type='%s'\n", client->addr,
+			id->name);
+
+	/* Make sure the slave address / chip type combo given is possible */
+	if ((client->addr & ~((1 << chip->slv_addr_shift) - 1)) !=
+	    chip->slv_addr) {
+		dev_err(&client->dev, "invalid slave address %02x\n",
+				client->addr);
+		return -ENODEV;
+	}
+
+	printk(KERN_INFO "leds-pca955x: Using %s %d-bit LED driver at "
+			"slave address 0x%02x\n",
+			id->name, chip->bits, client->addr);
+
+	DBG("probe() checking i2c functionality\n");
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+		return -EIO;
+
+	if (pdata) {
+		if (pdata->num_leds != chip->bits) {
+			dev_err(&client->dev, "board info claims %d LEDs"
+					" on a %d-bit chip\n",
+					pdata->num_leds, chip->bits);
+			return -ENODEV;
+		}
+	}
+
+	for (i = 0; i < chip->bits; i++) {
+		pca955x = kzalloc(sizeof(struct pca955x_led), GFP_KERNEL);
+		if (!pca955x) {
+			err = -ENOMEM;
+			goto exit;
+		}
+
+		pca955x->chipdef = chip;
+		pca955x->client = client;
+		pca955x->led_num = i;
+		/* Platform data can specify LED names and default triggers */
+		if (pdata) {
+			if (pdata->leds[i].name)
+				snprintf(pca955x->name, 32, "pca955x:%s",
+							pdata->leds[i].name);
+			if (pdata->leds[i].default_trigger)
+				pca955x->led_cdev.default_trigger =
+					pdata->leds[i].default_trigger;
+		} else {
+			snprintf(pca955x->name, 32, "pca955x:%d", i);
+		}
+		spin_lock_init(&pca955x->lock);
+
+		pca955x->led_cdev.name = pca955x->name;
+		pca955x->led_cdev.brightness_set =
+				pca955x_led_set;
+
+		/*
+		 * Client data is a pointer to the _first_ pca955x_led
+		 * struct
+		 */
+		if (i == 0)
+			i2c_set_clientdata(client, pca955x);
+
+		INIT_WORK(&(pca955x->work), pca955x_led_work);
+
+		led_classdev_register(&client->dev, &(pca955x->led_cdev));
+	}
+
+	/* Turn off LEDs */
+	for (i = 0; i < pca95xx_num_led_regs(chip->bits); i++)
+		pca955x_write_ls(client, i, 0x55);
+
+	/* PWM0 is used for half brightness or 50% duty cycle */
+	pca955x_write_pwm(client, 0, 255-LED_HALF);
+
+	/* PWM1 is used for variable brightness, default to OFF */
+	pca955x_write_pwm(client, 1, 0);
+
+	/* Set to fast frequency so we do not see flashing */
+	pca955x_write_psc(client, 0, 0);
+	pca955x_write_psc(client, 1, 0);
+
+	DBG("probe() returning\n");
+
+	return 0;
+exit:
+	return err;
+}
+
+static int __devexit pca955x_remove(struct i2c_client *client)
+{
+	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	int leds = pca955x->chipdef->bits;
+	int i;
+
+	for (i = 0; i < leds; i++) {
+		led_classdev_unregister(&(pca955x->led_cdev));
+		cancel_work_sync(&(pca955x->work));
+		kfree(pca955x);
+		pca955x = pca955x + 1;
+	}
+
+	return 0;
+}
+
+static struct i2c_driver pca955x_driver = {
+	.driver = {
+		.name	= "leds-pca955x",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pca955x_probe,
+	.remove	= __devexit_p(pca955x_remove),
+	.id_table = pca955x_id,
+};
+
+static int __init pca955x_leds_init(void)
+{
+	DBG("init() adding i2c driver\n");
+	return i2c_add_driver(&pca955x_driver);
+}
+
+static void __exit pca955x_leds_exit(void)
+{
+	i2c_del_driver(&pca955x_driver);
+}
+
+module_init(pca955x_leds_init);
+module_exit(pca955x_leds_exit);
+
+MODULE_AUTHOR("Nate Case <ncase@xes-inc.com>");
+MODULE_DESCRIPTION("PCA955x LED driver");
+MODULE_LICENSE("GPL v2");
diff -puN include/linux/leds.h~leds-add-support-for-philips-pca955x-i2c-led-drivers include/linux/leds.h
--- a/include/linux/leds.h~leds-add-support-for-philips-pca955x-i2c-led-drivers
+++ a/include/linux/leds.h
@@ -118,6 +118,20 @@ extern void ledtrig_ide_activity(void);
 #define ledtrig_ide_activity() do {} while(0)
 #endif
 
+/*
+ * Generic LED platform data for describing LED names and default triggers.
+ */
+struct led_info {
+	const char	*name;
+	char		*default_trigger;
+	int		flags;
+};
+
+struct led_platform_data {
+	int		num_leds;
+	struct led_info	*leds;
+};
+
 /* For the leds-gpio driver */
 struct gpio_led {
 	const char *name;
_

Patches currently in -mm which might be from ncase@xes-inc.com are

linux-next.patch
leds-add-support-for-philips-pca955x-i2c-led-drivers.patch

