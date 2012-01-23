From: akpm@linux-foundation.org
Subject: [merged] leds-add-led-driver-for-bachmanns-ot200.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:20 -0800
Message-ID: <20120123202120.C970F1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36712 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2AWUVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:23 -0500
Received: by yenr8 with SMTP id r8so303222yen.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, christian.gmeiner@gmail.com, lars@metafoo.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: add led driver for Bachmann's ot200
has been removed from the -mm tree.  Its filename was
     leds-add-led-driver-for-bachmanns-ot200.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: leds: add led driver for Bachmann's ot200

Add support for leds on Bachmann's ot200 visualisation device.  The device
has three leds on the back panel (led_err, led_init and led_run) and can
handle up to seven leds on the front panel.

The driver was written by Linutronix on behalf of Bachmann electronic
GmbH.  It incorporates feedback from Lars-Peter Clausen

[akpm@linux-foundation.org: add dependency on HAS_IOMEM]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig      |    7 +
 drivers/leds/Makefile     |    1 
 drivers/leds/leds-ot200.c |  171 ++++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-led-driver-for-bachmanns-ot200 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-led-driver-for-bachmanns-ot200
+++ a/drivers/leds/Kconfig
@@ -403,6 +403,13 @@ config LEDS_MAX8997
 	  This option enables support for on-chip LED drivers on
 	  MAXIM MAX8997 PMIC.
 
+config LEDS_OT200
+	tristate "LED support for the Bachmann OT200"
+	depends on LEDS_CLASS && HAS_IOMEM
+	help
+	  This option enables support for the LEDs on the Bachmann OT200.
+	  Say Y to enable LEDs on the Bachmann OT200.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~leds-add-led-driver-for-bachmanns-ot200 drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-led-driver-for-bachmanns-ot200
+++ a/drivers/leds/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_LEDS_LP5523)		+= leds-lp552
 obj-$(CONFIG_LEDS_TCA6507)		+= leds-tca6507.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
+obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
diff -puN /dev/null drivers/leds/leds-ot200.c
--- /dev/null
+++ a/drivers/leds/leds-ot200.c
@@ -0,0 +1,171 @@
+/*
+ * Bachmann ot200 leds driver.
+ *
+ * Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
+ *         Christian Gmeiner <christian.gmeiner@gmail.com>
+ *
+ * License: GPL as published by the FSF.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+
+struct ot200_led {
+	struct led_classdev cdev;
+	const char *name;
+	unsigned long port;
+	u8 mask;
+};
+
+/*
+ * The device has three leds on the back panel (led_err, led_init and led_run)
+ * and can handle up to seven leds on the front panel.
+ */
+
+static struct ot200_led leds[] = {
+	{
+		.name = "led_run",
+		.port = 0x5a,
+		.mask = BIT(0),
+	},
+	{
+		.name = "led_init",
+		.port = 0x5a,
+		.mask = BIT(1),
+	},
+	{
+		.name = "led_err",
+		.port = 0x5a,
+		.mask = BIT(2),
+	},
+	{
+		.name = "led_1",
+		.port = 0x49,
+		.mask = BIT(7),
+	},
+	{
+		.name = "led_2",
+		.port = 0x49,
+		.mask = BIT(6),
+	},
+	{
+		.name = "led_3",
+		.port = 0x49,
+		.mask = BIT(5),
+	},
+	{
+		.name = "led_4",
+		.port = 0x49,
+		.mask = BIT(4),
+	},
+	{
+		.name = "led_5",
+		.port = 0x49,
+		.mask = BIT(3),
+	},
+	{
+		.name = "led_6",
+		.port = 0x49,
+		.mask = BIT(2),
+	},
+	{
+		.name = "led_7",
+		.port = 0x49,
+		.mask = BIT(1),
+	}
+};
+
+static DEFINE_SPINLOCK(value_lock);
+
+/*
+ * we need to store the current led states, as it is not
+ * possible to read the current led state via inb().
+ */
+static u8 leds_back;
+static u8 leds_front;
+
+static void ot200_led_brightness_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	struct ot200_led *led = container_of(led_cdev, struct ot200_led, cdev);
+	u8 *val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&value_lock, flags);
+
+	if (led->port == 0x49)
+		val = &leds_front;
+	else if (led->port == 0x5a)
+		val = &leds_back;
+	else
+		BUG();
+
+	if (value == LED_OFF)
+		*val &= ~led->mask;
+	else
+		*val |= led->mask;
+
+	outb(*val, led->port);
+	spin_unlock_irqrestore(&value_lock, flags);
+}
+
+static int __devinit ot200_led_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(leds); i++) {
+
+		leds[i].cdev.name = leds[i].name;
+		leds[i].cdev.brightness_set = ot200_led_brightness_set;
+
+		ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
+		if (ret < 0)
+			goto err;
+	}
+
+	leds_front = 0;		/* turn off all front leds */
+	leds_back = BIT(1);	/* turn on init led */
+	outb(leds_front, 0x49);
+	outb(leds_back, 0x5a);
+
+	return 0;
+
+err:
+	for (i = i - 1; i >= 0; i--)
+		led_classdev_unregister(&leds[i].cdev);
+
+	return ret;
+}
+
+static int __devexit ot200_led_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(leds); i++)
+		led_classdev_unregister(&leds[i].cdev);
+
+	return 0;
+}
+
+static struct platform_driver ot200_led_driver = {
+	.probe		= ot200_led_probe,
+	.remove		= __devexit_p(ot200_led_remove),
+	.driver		= {
+		.name	= "leds-ot200",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(ot200_led_driver);
+
+MODULE_AUTHOR("Sebastian A. Siewior <bigeasy@linutronix.de>");
+MODULE_DESCRIPTION("ot200 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-ot200");
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

origin.patch

