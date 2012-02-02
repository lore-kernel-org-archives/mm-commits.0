From: akpm@linux-foundation.org
Subject: + drivers-leds-add-driver-for-pca9663-i2c-chip.patch added to -mm tree
Date: Thu, 02 Feb 2012 14:08:44 -0800
Message-ID: <20120202220846.163AAA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49250 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab2BBWIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 17:08:49 -0500
Received: by wicr5 with SMTP id r5so120258wic.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 14:08:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.meerwald@bct-electronic.com, lars@metafoo.de, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds: add driver for PCA9663 I2C chip
has been added to the -mm tree.  Its filename is
     drivers-leds-add-driver-for-pca9663-i2c-chip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Meerwald <p.meerwald@bct-electronic.com>
Subject: drivers/leds: add driver for PCA9663 I2C chip

Driver for the PCA9633 I2C chip supporting four LEDs and 255 brightness
levels.

Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig        |    8 +
 drivers/leds/Makefile       |    1 
 drivers/leds/leds-pca9633.c |  195 ++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)

diff -puN drivers/leds/Kconfig~drivers-leds-add-driver-for-pca9663-i2c-chip drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~drivers-leds-add-driver-for-pca9663-i2c-chip
+++ a/drivers/leds/Kconfig
@@ -234,6 +234,14 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
+config LEDS_PCA9663
+	tristate "LED support for PCA9663 I2C chip"
+	depends on LEDS_CLASS
+	depends on I2C
+	help
+	  This option enables support for LEDs connected to the PCA9663
+	  LED driver chip accessed via the I2C bus.
+
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~drivers-leds-add-driver-for-pca9663-i2c-chip drivers/leds/Makefile
--- a/drivers/leds/Makefile~drivers-leds-add-driver-for-pca9663-i2c-chip
+++ a/drivers/leds/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.
 obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
+obj-$(CONFIG_LEDS_PCA9633)		+= leds-pca9633.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
diff -puN /dev/null drivers/leds/leds-pca9633.c
--- /dev/null
+++ a/drivers/leds/leds-pca9633.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright 2011 bct electronic GmbH
+ *
+ * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
+ *
+ * Based on leds-pca955x.c
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
+ *
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
+#include <linux/slab.h>
+
+/* LED select registers determine the source that drives LED outputs */
+#define PCA9633_LED_OFF		0x0	/* LED driver off */
+#define PCA9633_LED_ON		0x1	/* LED driver on */
+#define PCA9633_LED_PWM		0x2	/* Controlled through PWM */
+#define PCA9633_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
+
+#define PCA9633_MODE1		0x00
+#define PCA9633_MODE2		0x01
+#define PCA9633_PWM_BASE	0x02
+#define PCA9633_LEDOUT		0x08
+
+static const struct i2c_device_id pca9633_id[] = {
+	{ "pca9633", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pca9633_id);
+
+struct pca9633_led {
+	struct i2c_client *client;
+	struct work_struct work;
+	enum led_brightness brightness;
+	struct led_classdev led_cdev;
+	int led_num; /* 0 .. 3 potentially */
+	char name[32];
+};
+
+static void pca9633_led_work(struct work_struct *work)
+{
+	struct pca9633_led *pca9633 = container_of(work,
+		struct pca9633_led, work);
+	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
+	int shift = 2 * pca9633->led_num;
+	u8 mask = 0x3 << shift;
+
+	switch (pca9633->brightness) {
+	case LED_FULL:
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			(ledout & ~mask) | (PCA9633_LED_ON << shift));
+		break;
+	case LED_OFF:
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			ledout & ~mask);
+		break;
+	default:
+		i2c_smbus_write_byte_data(pca9633->client,
+			PCA9633_PWM_BASE + pca9633->led_num,
+			pca9633->brightness);
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
+		break;
+	}
+}
+
+static void pca9633_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct pca9633_led *pca9633;
+
+	pca9633 = container_of(led_cdev, struct pca9633_led, led_cdev);
+
+	pca9633->brightness = value;
+
+	/*
+	 * Must use workqueue for the actual I/O since I2C operations
+	 * can sleep.
+	 */
+	schedule_work(&pca9633->work);
+}
+
+static int __devinit pca9633_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct pca9633_led *pca9633;
+	struct i2c_adapter *adapter;
+	struct led_platform_data *pdata;
+	int i, err;
+
+	adapter = to_i2c_adapter(client->dev.parent);
+	pdata = client->dev.platform_data;
+
+	if (pdata) {
+		if (pdata->num_leds <= 0 || pdata->num_leds > 4) {
+			dev_err(&client->dev, "board info must claim at most 4 LEDs");
+			return -EINVAL;
+		}
+	}
+
+	pca9633 = kcalloc(sizeof(*pca9633) * 4, GFP_KERNEL);
+	if (!pca9633)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pca9633);
+
+	for (i = 0; i < 4; i++) {
+		pca9633[i].client = client;
+		pca9633[i].led_num = i;
+
+		/* Platform data can specify LED names and default triggers */
+		if (pdata && i < pdata->num_leds) {
+			if (pdata->leds[i].name)
+				snprintf(pca9633[i].name,
+					 sizeof(pca9633[i].name), "pca9633:%s",
+					 pdata->leds[i].name);
+			if (pdata->leds[i].default_trigger)
+				pca9633[i].led_cdev.default_trigger =
+					pdata->leds[i].default_trigger;
+		} else {
+			snprintf(pca9633[i].name, sizeof(pca9633[i].name),
+				 "pca9633:%d", i);
+		}
+
+		pca9633[i].led_cdev.name = pca9633[i].name;
+		pca9633[i].led_cdev.brightness_set = pca9633_led_set;
+
+		INIT_WORK(&pca9633[i].work, pca9633_led_work);
+
+		err = led_classdev_register(&client->dev, &pca9633[i].led_cdev);
+		if (err < 0)
+			goto exit;
+	}
+
+	/* Disable LED all-call address and set normal mode */
+	i2c_smbus_write_byte_data(client, PCA9633_MODE1, 0x00);
+
+	/* Turn off LEDs */
+	i2c_smbus_write_byte_data(client, PCA9633_LEDOUT, 0x00);
+
+	return 0;
+
+exit:
+	while (i--) {
+		led_classdev_unregister(&pca9633[i].led_cdev);
+		cancel_work_sync(&pca9633[i].work);
+	}
+
+	kfree(pca9633);
+
+	return err;
+}
+
+static int __devexit pca9633_remove(struct i2c_client *client)
+{
+	struct pca9633_led *pca9633 = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		led_classdev_unregister(&pca9633[i].led_cdev);
+		cancel_work_sync(&pca9633[i].work);
+	}
+
+	kfree(pca9633);
+
+	return 0;
+}
+
+static struct i2c_driver pca9633_driver = {
+	.driver = {
+		.name	= "leds-pca9633",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pca9633_probe,
+	.remove	= __devexit_p(pca9633_remove),
+	.id_table = pca9633_id,
+};
+
+module_i2c_driver(pca9633_driver);
+
+MODULE_AUTHOR("Peter Meerwald <p.meerwald@bct-electronic.com>");
+MODULE_DESCRIPTION("PCA9633 LED driver");
+MODULE_LICENSE("GPL v2");
_
Subject: Subject: drivers/leds: add driver for PCA9663 I2C chip

Patches currently in -mm which might be from p.meerwald@bct-electronic.com are

drivers-leds-add-driver-for-pca9663-i2c-chip.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch

