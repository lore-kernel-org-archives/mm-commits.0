From: akpm@linux-foundation.org
Subject: - leds-add-wm8350-led-driver.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:47:51 -0800
Message-ID: <200812012247.mB1MlpuV028343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYLAWse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:48:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, rpurdie@linux.intel.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add WM8350 LED driver
has been removed from the -mm tree.  Its filename was
     leds-add-wm8350-led-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add WM8350 LED driver
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The voltage and current regulators on the WM8350 AudioPlus PMIC can be
used in concert to provide a power efficient LED driver.  This driver
implements support for this within the standard LED class.

Platform initialisation code should configure the LED hardware in the init
callback provided by the WM8350 core driver.  The callback should use
wm8350_isink_set_flash(), wm8350_dcdc25_set_mode() and
wm8350_dcdc_set_slot() to configure the operating parameters of the
regulators for their hardware and then then use wm8350_register_led() to
instantiate the LED driver.

This driver was originally written by Liam Girdwood, though it has been
extensively modified since then.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig                 |    7 
 drivers/leds/Makefile                |    1 
 drivers/leds/leds-wm8350.c           |  324 +++++++++++++++++++++++++
 drivers/mfd/wm8350-core.c            |    3 
 drivers/regulator/wm8350-regulator.c |   89 ++++++
 include/linux/mfd/wm8350/pmic.h      |   35 ++
 6 files changed, 459 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-wm8350-led-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-wm8350-led-driver
+++ a/drivers/leds/Kconfig
@@ -164,6 +164,13 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
+config LEDS_WM8350
+	tristate "LED Support for WM8350 AudioPlus PMIC"
+	depends on LEDS_CLASS && MFD_WM8350
+	help
+	  This option enables support for LEDs driven by the Wolfson
+	  Microelectronics WM8350 AudioPlus PMIC.
+
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
 	depends on LEDS_CLASS && PMIC_DA903X
diff -puN drivers/leds/Makefile~leds-add-wm8350-led-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-wm8350-led-driver
+++ a/drivers/leds/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
+obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -puN /dev/null drivers/leds/leds-wm8350.c
--- /dev/null
+++ a/drivers/leds/leds-wm8350.c
@@ -0,0 +1,324 @@
+/*
+ * LED driver for WM8350 driven LEDS.
+ *
+ * Copyright(C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/mfd/wm8350/pmic.h>
+#include <linux/regulator/consumer.h>
+
+/* Microamps */
+static const int isink_cur[] = {
+	4,
+	5,
+	6,
+	7,
+	8,
+	10,
+	11,
+	14,
+	16,
+	19,
+	23,
+	27,
+	32,
+	39,
+	46,
+	54,
+	65,
+	77,
+	92,
+	109,
+	130,
+	154,
+	183,
+	218,
+	259,
+	308,
+	367,
+	436,
+	518,
+	616,
+	733,
+	872,
+	1037,
+	1233,
+	1466,
+	1744,
+	2073,
+	2466,
+	2933,
+	3487,
+	4147,
+	4932,
+	5865,
+	6975,
+	8294,
+	9864,
+	11730,
+	13949,
+	16589,
+	19728,
+	23460,
+	27899,
+	33178,
+	39455,
+	46920,
+	55798,
+	66355,
+	78910,
+	93840,
+	111596,
+	132710,
+	157820,
+	187681,
+	223191
+};
+
+#define to_wm8350_led(led_cdev) \
+	container_of(led_cdev, struct wm8350_led, cdev)
+
+static void wm8350_led_enable(struct wm8350_led *led)
+{
+	int ret;
+
+	if (led->enabled)
+		return;
+
+	ret = regulator_enable(led->isink);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to enable ISINK: %d\n", ret);
+		return;
+	}
+
+	ret = regulator_enable(led->dcdc);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to enable DCDC: %d\n", ret);
+		regulator_disable(led->isink);
+		return;
+	}
+
+	led->enabled = 1;
+}
+
+static void wm8350_led_disable(struct wm8350_led *led)
+{
+	int ret;
+
+	if (!led->enabled)
+		return;
+
+	ret = regulator_disable(led->dcdc);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to disable DCDC: %d\n", ret);
+		return;
+	}
+
+	ret = regulator_disable(led->isink);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n", ret);
+		regulator_enable(led->isink);
+		return;
+	}
+
+	led->enabled = 0;
+}
+
+static void led_work(struct work_struct *work)
+{
+	struct wm8350_led *led = container_of(work, struct wm8350_led, work);
+	int ret;
+	int uA;
+
+	mutex_lock(&led->mutex);
+
+	if (led->value == LED_OFF) {
+		wm8350_led_disable(led);
+		goto out;
+	}
+
+	/* This scales linearly into the index of valid current
+	 * settings which results in a linear scaling of perceived
+	 * brightness due to the non-linear settings.
+	 */
+	uA = (led->max_uA_index * led->value) / LED_FULL;
+	BUG_ON(uA > ARRAY_SIZE(isink_cur));
+	ret = regulator_set_current_limit(led->isink, isink_cur[uA],
+					  isink_cur[uA]);
+	if (ret != 0)
+		dev_err(led->cdev.dev, "Failed to set %duA: %d\n",
+			isink_cur[uA], ret);
+
+	wm8350_led_enable(led);
+
+out:
+	mutex_unlock(&led->mutex);
+}
+
+static void wm8350_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct wm8350_led *led = to_wm8350_led(led_cdev);
+
+	led->value = value;
+	schedule_work(&led->work);
+}
+
+#ifdef CONFIG_PM
+static int wm8350_led_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct wm8350_led *led =
+	    (struct wm8350_led *)platform_get_drvdata(pdev);
+
+	led_classdev_suspend(&led->cdev);
+	return 0;
+}
+
+static int wm8350_led_resume(struct platform_device *pdev)
+{
+	struct wm8350_led *led =
+	    (struct wm8350_led *)platform_get_drvdata(pdev);
+
+	led_classdev_resume(&led->cdev);
+	return 0;
+}
+#else
+#define wm8350_led_suspend NULL
+#define wm8350_led_resume NULL
+#endif
+
+static void wm8350_led_shutdown(struct platform_device *pdev)
+{
+	struct wm8350_led *led =
+	    (struct wm8350_led *)platform_get_drvdata(pdev);
+
+	mutex_lock(&led->mutex);
+	led->value = LED_OFF;
+	wm8350_led_disable(led);
+	mutex_unlock(&led->mutex);
+}
+
+static int wm8350_led_probe(struct platform_device *pdev)
+{
+	struct regulator *isink, *dcdc;
+	struct wm8350_led *led;
+	struct wm8350_led_platform_data *pdata = pdev->dev.platform_data;
+	int ret, i;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdata->max_uA < isink_cur[0]) {
+		dev_err(&pdev->dev, "Invalid maximum current %duA\n",
+			pdata->max_uA);
+		return -EINVAL;
+	}
+
+	isink = regulator_get(&pdev->dev, "led_isink");
+	if (IS_ERR(isink) || isink == NULL) {
+		printk(KERN_ERR "%s: cant get ISINK\n", __func__);
+		return PTR_ERR(isink);
+	}
+
+	dcdc = regulator_get(&pdev->dev, "led_vcc");
+	if (IS_ERR(dcdc) || dcdc == NULL) {
+		printk(KERN_ERR "%s: cant get DCDC\n", __func__);
+		regulator_put(isink);
+		return PTR_ERR(dcdc);
+	}
+
+	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	if (led == NULL) {
+		regulator_put(isink);
+		regulator_put(dcdc);
+		return -ENOMEM;
+	}
+
+	led->cdev.brightness_set = wm8350_led_set;
+	led->cdev.default_trigger = (char *)pdata->default_trigger;
+	led->cdev.name = pdata->name;
+	led->enabled = regulator_is_enabled(isink);
+	led->isink = isink;
+	led->dcdc = dcdc;
+
+	for (i = 0; i < ARRAY_SIZE(isink_cur); i++)
+		if (isink_cur[i] >= pdata->max_uA)
+			break;
+	led->max_uA_index = i;
+	if (pdata->max_uA != isink_cur[i])
+		dev_warn(&pdev->dev,
+			 "Maximum current %duA is not directly supported,"
+			 " check platform data\n",
+			 pdata->max_uA);
+
+	mutex_init(&led->mutex);
+	INIT_WORK(&led->work, led_work);
+	led->value = LED_OFF;
+	platform_set_drvdata(pdev, led);
+
+	ret = led_classdev_register(&pdev->dev, &led->cdev);
+	if (ret < 0) {
+		regulator_put(isink);
+		regulator_put(dcdc);
+		kfree(led);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int wm8350_led_remove(struct platform_device *pdev)
+{
+	struct wm8350_led *led =
+	    (struct wm8350_led *)platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&led->cdev);
+	schedule_work(&led->work);
+	flush_scheduled_work();
+	wm8350_led_disable(led);
+	regulator_put(led->dcdc);
+	regulator_put(led->isink);
+	kfree(led);
+	return 0;
+}
+
+static struct platform_driver wm8350_led_driver = {
+	.driver = {
+		   .name = "wm8350-led",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = wm8350_led_probe,
+	.remove = wm8350_led_remove,
+	.shutdown = wm8350_led_shutdown,
+	.suspend = wm8350_led_suspend,
+	.resume = wm8350_led_resume,
+};
+
+static int __devinit wm8350_led_init(void)
+{
+	return platform_driver_register(&wm8350_led_driver);
+}
+module_init(wm8350_led_init);
+
+static void wm8350_led_exit(void)
+{
+	platform_driver_unregister(&wm8350_led_driver);
+}
+module_exit(wm8350_led_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM8350 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-led");
diff -puN drivers/mfd/wm8350-core.c~leds-add-wm8350-led-driver drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~leds-add-wm8350-led-driver
+++ a/drivers/mfd/wm8350-core.c
@@ -1345,6 +1345,9 @@ void wm8350_device_exit(struct wm8350 *w
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(wm8350->pmic.led); i++)
+		platform_device_unregister(wm8350->pmic.led[i].pdev);
+
 	for (i = 0; i < ARRAY_SIZE(wm8350->pmic.pdev); i++)
 		platform_device_unregister(wm8350->pmic.pdev[i]);
 
diff -puN drivers/regulator/wm8350-regulator.c~leds-add-wm8350-led-driver drivers/regulator/wm8350-regulator.c
--- a/drivers/regulator/wm8350-regulator.c~leds-add-wm8350-led-driver
+++ a/drivers/regulator/wm8350-regulator.c
@@ -1405,6 +1405,95 @@ int wm8350_register_regulator(struct wm8
 }
 EXPORT_SYMBOL_GPL(wm8350_register_regulator);
 
+/**
+ * wm8350_register_led - Register a WM8350 LED output
+ *
+ * @param wm8350 The WM8350 device to configure.
+ * @param lednum LED device index to create.
+ * @param dcdc The DCDC to use for the LED.
+ * @param isink The ISINK to use for the LED.
+ * @param pdata Configuration for the LED.
+ *
+ * The WM8350 supports the use of an ISINK together with a DCDC to
+ * provide a power-efficient LED driver.  This function registers the
+ * regulators and instantiates the platform device for a LED.  The
+ * operating modes for the LED regulators must be configured using
+ * wm8350_isink_set_flash(), wm8350_dcdc25_set_mode() and
+ * wm8350_dcdc_set_slot() prior to calling this function.
+ */
+int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
+			struct wm8350_led_platform_data *pdata)
+{
+	struct wm8350_led *led = &wm8350->pmic.led[lednum];
+	struct platform_device *pdev;
+	int ret;
+
+	if (lednum > ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
+		dev_err(wm8350->dev, "Invalid LED index %d\n", lednum);
+		return -ENODEV;
+	}
+
+	if (led->pdev) {
+		dev_err(wm8350->dev, "LED %d already allocated\n", lednum);
+		return -EINVAL;
+	}
+
+	pdev = platform_device_alloc("wm8350-led", lednum);
+	if (pdev == NULL) {
+		dev_err(wm8350->dev, "Failed to allocate LED %d\n", lednum);
+		return -ENOMEM;
+	}
+
+	led->isink_consumer.dev = &pdev->dev;
+	led->isink_consumer.supply = "led_isink";
+	led->isink_init.num_consumer_supplies = 1;
+	led->isink_init.consumer_supplies = &led->isink_consumer;
+	led->isink_init.constraints.min_uA = 0;
+	led->isink_init.constraints.max_uA = pdata->max_uA;
+	led->isink_init.constraints.valid_ops_mask = REGULATOR_CHANGE_CURRENT;
+	led->isink_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
+	ret = wm8350_register_regulator(wm8350, isink, &led->isink_init);
+	if (ret != 0) {
+		platform_device_put(pdev);
+		return ret;
+	}
+
+	led->dcdc_consumer.dev = &pdev->dev;
+	led->dcdc_consumer.supply = "led_vcc";
+	led->dcdc_init.num_consumer_supplies = 1;
+	led->dcdc_init.consumer_supplies = &led->dcdc_consumer;
+	led->dcdc_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
+	ret = wm8350_register_regulator(wm8350, dcdc, &led->dcdc_init);
+	if (ret != 0) {
+		platform_device_put(pdev);
+		return ret;
+	}
+
+	switch (isink) {
+	case WM8350_ISINK_A:
+		wm8350->pmic.isink_A_dcdc = dcdc;
+		break;
+	case WM8350_ISINK_B:
+		wm8350->pmic.isink_B_dcdc = dcdc;
+		break;
+	}
+
+	pdev->dev.platform_data = pdata;
+	pdev->dev.parent = wm8350->dev;
+	ret = platform_device_add(pdev);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to register LED %d: %d\n",
+			lednum, ret);
+		platform_device_put(pdev);
+		return ret;
+	}
+
+	led->pdev = pdev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wm8350_register_led);
+
 static struct platform_driver wm8350_regulator_driver = {
 	.probe = wm8350_regulator_probe,
 	.remove = wm8350_regulator_remove,
diff -puN include/linux/mfd/wm8350/pmic.h~leds-add-wm8350-led-driver include/linux/mfd/wm8350/pmic.h
--- a/include/linux/mfd/wm8350/pmic.h~leds-add-wm8350-led-driver
+++ a/include/linux/mfd/wm8350/pmic.h
@@ -13,6 +13,10 @@
 #ifndef __LINUX_MFD_WM8350_PMIC_H
 #define __LINUX_MFD_WM8350_PMIC_H
 
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/regulator/machine.h>
+
 /*
  * Register values.
  */
@@ -700,6 +704,32 @@ struct wm8350;
 struct platform_device;
 struct regulator_init_data;
 
+/*
+ * WM8350 LED platform data
+ */
+struct wm8350_led_platform_data {
+	const char *name;
+	const char *default_trigger;
+	int max_uA;
+};
+
+struct wm8350_led {
+	struct platform_device *pdev;
+	struct mutex mutex;
+	struct work_struct work;
+	enum led_brightness value;
+	struct led_classdev cdev;
+	int max_uA_index;
+	int enabled;
+
+	struct regulator *isink;
+	struct regulator_consumer_supply isink_consumer;
+	struct regulator_init_data isink_init;
+	struct regulator *dcdc;
+	struct regulator_consumer_supply dcdc_consumer;
+	struct regulator_init_data dcdc_init;
+};
+
 struct wm8350_pmic {
 	/* ISINK to DCDC mapping */
 	int isink_A_dcdc;
@@ -713,10 +743,15 @@ struct wm8350_pmic {
 
 	/* regulator devices */
 	struct platform_device *pdev[NUM_WM8350_REGULATORS];
+
+	/* LED devices */
+	struct wm8350_led led[2];
 };
 
 int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
 			      struct regulator_init_data *initdata);
+int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
+			struct wm8350_led_platform_data *pdata);
 
 /*
  * Additional DCDC control not supported via regulator API
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
leds-add-wm8350-led-driver.patch

