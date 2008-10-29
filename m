From: akpm@linux-foundation.org
Subject: - led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch removed from -mm tree
Date: Wed, 29 Oct 2008 15:08:07 -0700
Message-ID: <200810292208.m9TM87VX005332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYJ2WIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 18:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: const@tltsu.ru, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     led: driver for LEDs on PCEngines ALIX.2 and ALIX.3 boards
has been removed from the -mm tree.  Its filename was
     led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led: driver for LEDs on PCEngines ALIX.2 and ALIX.3 boards
From: Constantin Baranov <const@tltsu.ru>

Driver for LEDs on PCEngines ALIX.2 and ALIX.3 system boards.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Constantin Baranov <const@tltsu.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig     |    6 +
 drivers/leds/Makefile    |    1 
 drivers/leds/leds-alix.c |  153 +++++++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)

diff -puN drivers/leds/Kconfig~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards
+++ a/drivers/leds/Kconfig
@@ -63,6 +63,12 @@ config LEDS_WRAP
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
+config LEDS_ALIX
+	tristate "LED support for ALIX series"
+	depends on LEDS_CLASS && X86
+	help
+	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
+
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends on LEDS_CLASS && ARCH_H1940
diff -puN drivers/leds/Makefile~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards drivers/leds/Makefile
--- a/drivers/leds/Makefile~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards
+++ a/drivers/leds/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c2
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
+obj-$(CONFIG_LEDS_ALIX)			+= leds-alix.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
diff -puN /dev/null drivers/leds/leds-alix.c
--- /dev/null
+++ a/drivers/leds/leds-alix.c
@@ -0,0 +1,153 @@
+/*
+ * LEDs driver for PCEngines ALIX.2 and ALIX.3
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@tltsu.ru>
+ */
+
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+
+struct alix_led {
+	struct led_classdev cdev;
+	unsigned short port;
+	unsigned int on_value;
+	unsigned int off_value;
+};
+
+static void alix_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness brightness)
+{
+	struct alix_led *led_dev =
+		container_of(led_cdev, struct alix_led, cdev);
+
+	if (brightness)
+		outl(led_dev->on_value, led_dev->port);
+	else
+		outl(led_dev->off_value, led_dev->port);
+}
+
+static struct alix_led alix_leds[] = {
+	{
+		.cdev = {
+			.name = "alix:1",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6100,
+		.on_value = 1 << 22,
+		.off_value = 1 << 6,
+	},
+	{
+		.cdev = {
+			.name = "alix:2",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 25,
+		.off_value = 1 << 9,
+	},
+	{
+		.cdev = {
+			.name = "alix:3",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 27,
+		.off_value = 1 << 11,
+	},
+};
+
+#ifdef CONFIG_PM
+
+static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_suspend(&alix_leds[i].cdev);
+	return 0;
+}
+
+static int alix_led_resume(struct platform_device *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_resume(&alix_leds[i].cdev);
+	return 0;
+}
+
+#else
+
+#define alix_led_suspend NULL
+#define alix_led_resume NULL
+
+#endif
+
+static int __init alix_led_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
+		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
+		if (ret < 0)
+			goto fail;
+	}
+	return 0;
+
+fail:
+	while (--i >= 0)
+		led_classdev_unregister(&alix_leds[i].cdev);
+	return ret;
+}
+
+static int alix_led_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_unregister(&alix_leds[i].cdev);
+	return 0;
+}
+
+static struct platform_driver alix_led_driver = {
+	.remove = alix_led_remove,
+	.suspend = alix_led_suspend,
+	.resume = alix_led_resume,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct platform_device *pdev;
+
+static int __init alix_led_init(void)
+{
+	int ret;
+
+	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
+	if (!IS_ERR(pdev)) {
+		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
+		if (ret)
+			platform_device_unregister(pdev);
+	} else
+		ret = PTR_ERR(pdev);
+	return ret;
+}
+
+static void __exit alix_led_exit(void)
+{
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&alix_led_driver);
+}
+
+module_init(alix_led_init);
+module_exit(alix_led_exit);
+
+MODULE_AUTHOR("Constantin Baranov <const@tltsu.ru>");
+MODULE_DESCRIPTION("PCEngines ALIX LED driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from const@tltsu.ru are

led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch

