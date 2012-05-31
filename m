From: akpm@linux-foundation.org
Subject: [merged] leds-add-lm3533-led-driver.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:54 -0700
Message-ID: <20120531191954.83E4FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38235 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab2EaTTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:55 -0400
Received: by yenl3 with SMTP id l3so138431yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, FlorianSchandinat@gmx.de, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, bryan.wu@canonical.com, gregkh@linuxfoundation.org, jic23@cam.ac.uk, rob@landley.net, rpurdie@rpsys.net, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: add LM3533 LED driver
has been removed from the -mm tree.  Its filename was
     leds-add-lm3533-led-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: leds: add LM3533 LED driver

Add sub-driver for the LEDs on National Semiconductor / TI LM3533 lighting
power chips.

The chip provides 256 brightness levels, hardware accelerated blinking as
well as ambient-light-sensor and pwm input control.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Landley <rob@landley.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-led-driver-lm3533 |   65 
 drivers/leds/Kconfig                                    |   13 
 drivers/leds/Makefile                                   |    1 
 drivers/leds/leds-lm3533.c                              |  785 ++++++++++
 4 files changed, 864 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-led-driver-lm3533
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
@@ -0,0 +1,65 @@
+What:		/sys/class/leds/<led>/als_channel
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the ALS output channel to use as input in
+		ALS-current-control mode (1, 2), where
+
+		1 - out_current1
+		2 - out_current2
+
+What:		/sys/class/leds/<led>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
+
+What:		/sys/class/leds/<led>/falltime
+What:		/sys/class/leds/<led>/risetime
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the pattern generator fall and rise times (0..7), where
+
+		0 - 2048 us
+		1 - 262 ms
+		2 - 524 ms
+		3 - 1.049 s
+		4 - 2.097 s
+		5 - 4.194 s
+		6 - 8.389 s
+		7 - 16.78 s
+
+What:		/sys/class/leds/<led>/id
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Get the id of this led (0..3).
+
+What:		/sys/class/leds/<led>/linear
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the brightness-mapping mode (0, 1), where
+
+		0 - exponential mode
+		1 - linear mode
+
+What:		/sys/class/leds/<led>/pwm
+Date:		April 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Set the PWM-input control mask (5 bits), where
+
+		bit 5 - PWM-input enabled in Zone 4
+		bit 4 - PWM-input enabled in Zone 3
+		bit 3 - PWM-input enabled in Zone 2
+		bit 2 - PWM-input enabled in Zone 1
+		bit 1 - PWM-input enabled in Zone 0
+		bit 0 - PWM-input enabled
diff -puN drivers/leds/Kconfig~leds-add-lm3533-led-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-lm3533-led-driver
+++ a/drivers/leds/Kconfig
@@ -50,6 +50,19 @@ config LEDS_LM3530
 	  controlled manually or using PWM input or using ambient
 	  light automatically.
 
+config LEDS_LM3533
+	tristate "LED support for LM3533"
+	depends on LEDS_CLASS
+	depends on MFD_LM3533
+	help
+	  This option enables support for the LEDs on National Semiconductor /
+	  TI LM3533 Lighting Power chips.
+
+	  The LEDs can be controlled directly, through PWM input, or by the
+	  ambient-light-sensor interface. The chip supports
+	  hardware-accelerated blinking with maximum on and off periods of 9.8
+	  and 77 seconds respectively.
+
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~leds-add-lm3533-led-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-lm3533-led-driver
+++ a/drivers/leds/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-at
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
+obj-$(CONFIG_LEDS_LM3533)		+= leds-lm3533.o
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
diff -puN /dev/null drivers/leds/leds-lm3533.c
--- /dev/null
+++ a/drivers/leds/leds-lm3533.c
@@ -0,0 +1,785 @@
+/*
+ * leds-lm3533.c -- LM3533 LED driver
+ *
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * Author: Johan Hovold <jhovold@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under  the terms of the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/mfd/core.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#include <linux/mfd/lm3533.h>
+
+
+#define LM3533_LVCTRLBANK_MIN		2
+#define LM3533_LVCTRLBANK_MAX		5
+#define LM3533_LVCTRLBANK_COUNT		4
+#define LM3533_RISEFALLTIME_MAX		7
+#define LM3533_ALS_CHANNEL_LV_MIN	1
+#define LM3533_ALS_CHANNEL_LV_MAX	2
+
+#define LM3533_REG_CTRLBANK_BCONF_BASE		0x1b
+#define LM3533_REG_PATTERN_ENABLE		0x28
+#define LM3533_REG_PATTERN_LOW_TIME_BASE	0x71
+#define LM3533_REG_PATTERN_HIGH_TIME_BASE	0x72
+#define LM3533_REG_PATTERN_RISETIME_BASE	0x74
+#define LM3533_REG_PATTERN_FALLTIME_BASE	0x75
+
+#define LM3533_REG_PATTERN_STEP			0x10
+
+#define LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK		0x04
+#define LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK		0x02
+#define LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK	0x01
+
+#define LM3533_LED_FLAG_PATTERN_ENABLE		1
+
+
+struct lm3533_led {
+	struct lm3533 *lm3533;
+	struct lm3533_ctrlbank cb;
+	struct led_classdev cdev;
+	int id;
+
+	struct mutex mutex;
+	unsigned long flags;
+
+	struct work_struct work;
+	u8 new_brightness;
+};
+
+
+static inline struct lm3533_led *to_lm3533_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct lm3533_led, cdev);
+}
+
+static inline int lm3533_led_get_ctrlbank_id(struct lm3533_led *led)
+{
+	return led->id + 2;
+}
+
+static inline u8 lm3533_led_get_lv_reg(struct lm3533_led *led, u8 base)
+{
+	return base + led->id;
+}
+
+static inline u8 lm3533_led_get_pattern(struct lm3533_led *led)
+{
+	return led->id;
+}
+
+static inline u8 lm3533_led_get_pattern_reg(struct lm3533_led *led,
+								u8 base)
+{
+	return base + lm3533_led_get_pattern(led) * LM3533_REG_PATTERN_STEP;
+}
+
+static int lm3533_led_pattern_enable(struct lm3533_led *led, int enable)
+{
+	u8 mask;
+	u8 val;
+	int pattern;
+	int state;
+	int ret = 0;
+
+	dev_dbg(led->cdev.dev, "%s - %d\n", __func__, enable);
+
+	mutex_lock(&led->mutex);
+
+	state = test_bit(LM3533_LED_FLAG_PATTERN_ENABLE, &led->flags);
+	if ((enable && state) || (!enable && !state))
+		goto out;
+
+	pattern = lm3533_led_get_pattern(led);
+	mask = 1 << (2 * pattern);
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(led->lm3533, LM3533_REG_PATTERN_ENABLE, val, mask);
+	if (ret) {
+		dev_err(led->cdev.dev, "failed to enable pattern %d (%d)\n",
+							pattern, enable);
+		goto out;
+	}
+
+	__change_bit(LM3533_LED_FLAG_PATTERN_ENABLE, &led->flags);
+out:
+	mutex_unlock(&led->mutex);
+
+	return ret;
+}
+
+static void lm3533_led_work(struct work_struct *work)
+{
+	struct lm3533_led *led = container_of(work, struct lm3533_led, work);
+
+	dev_dbg(led->cdev.dev, "%s - %u\n", __func__, led->new_brightness);
+
+	if (led->new_brightness == 0)
+		lm3533_led_pattern_enable(led, 0);	/* disable blink */
+
+	lm3533_ctrlbank_set_brightness(&led->cb, led->new_brightness);
+}
+
+static void lm3533_led_set(struct led_classdev *cdev,
+						enum led_brightness value)
+{
+	struct lm3533_led *led = to_lm3533_led(cdev);
+
+	dev_dbg(led->cdev.dev, "%s - %d\n", __func__, value);
+
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+static enum led_brightness lm3533_led_get(struct led_classdev *cdev)
+{
+	struct lm3533_led *led = to_lm3533_led(cdev);
+	u8 val;
+	int ret;
+
+	ret = lm3533_ctrlbank_get_brightness(&led->cb, &val);
+	if (ret)
+		return ret;
+
+	dev_dbg(led->cdev.dev, "%s - %u\n", __func__, val);
+
+	return val;
+}
+
+/* Pattern generator defines (delays in us). */
+#define LM3533_LED_DELAY1_VMIN	0x00
+#define LM3533_LED_DELAY2_VMIN	0x3d
+#define LM3533_LED_DELAY3_VMIN	0x80
+
+#define LM3533_LED_DELAY1_VMAX	(LM3533_LED_DELAY2_VMIN - 1)
+#define LM3533_LED_DELAY2_VMAX	(LM3533_LED_DELAY3_VMIN - 1)
+#define LM3533_LED_DELAY3_VMAX	0xff
+
+#define LM3533_LED_DELAY1_TMIN	16384U
+#define LM3533_LED_DELAY2_TMIN	1130496U
+#define LM3533_LED_DELAY3_TMIN	10305536U
+
+#define LM3533_LED_DELAY1_TMAX	999424U
+#define LM3533_LED_DELAY2_TMAX	9781248U
+#define LM3533_LED_DELAY3_TMAX	76890112U
+
+/* t_step = (t_max - t_min) / (v_max - v_min) */
+#define LM3533_LED_DELAY1_TSTEP	16384
+#define LM3533_LED_DELAY2_TSTEP	131072
+#define LM3533_LED_DELAY3_TSTEP	524288
+
+/* Delay limits for hardware accelerated blinking (in ms). */
+#define LM3533_LED_DELAY_ON_MAX \
+	((LM3533_LED_DELAY2_TMAX + LM3533_LED_DELAY2_TSTEP / 2) / 1000)
+#define LM3533_LED_DELAY_OFF_MAX \
+	((LM3533_LED_DELAY3_TMAX + LM3533_LED_DELAY3_TSTEP / 2) / 1000)
+
+/*
+ * Returns linear map of *t from [t_min,t_max] to [v_min,v_max] with a step
+ * size of t_step, where
+ *
+ *	t_step = (t_max - t_min) / (v_max - v_min)
+ *
+ * and updates *t to reflect the mapped value.
+ */
+static u8 time_to_val(unsigned *t, unsigned t_min, unsigned t_step,
+							u8 v_min, u8 v_max)
+{
+	unsigned val;
+
+	val = (*t + t_step / 2 - t_min) / t_step + v_min;
+
+	*t = t_step * (val - v_min) + t_min;
+
+	return (u8)val;
+}
+
+/*
+ * Returns time code corresponding to *delay (in ms) and updates *delay to
+ * reflect actual hardware delay.
+ *
+ * Hardware supports 256 discrete delay times, divided into three groups with
+ * the following ranges and step-sizes:
+ *
+ *	[   16,   999]	[0x00, 0x3e]	step  16 ms
+ *	[ 1130,  9781]	[0x3d, 0x7f]	step 131 ms
+ *	[10306, 76890]	[0x80, 0xff]	step 524 ms
+ *
+ * Note that delay group 3 is only available for delay_off.
+ */
+static u8 lm3533_led_get_hw_delay(unsigned *delay)
+{
+	unsigned t;
+	u8 val;
+
+	t = *delay * 1000;
+
+	if (t >= (LM3533_LED_DELAY2_TMAX + LM3533_LED_DELAY3_TMIN) / 2) {
+		t = clamp(t, LM3533_LED_DELAY3_TMIN, LM3533_LED_DELAY3_TMAX);
+		val = time_to_val(&t,	LM3533_LED_DELAY3_TMIN,
+					LM3533_LED_DELAY3_TSTEP,
+					LM3533_LED_DELAY3_VMIN,
+					LM3533_LED_DELAY3_VMAX);
+	} else if (t >= (LM3533_LED_DELAY1_TMAX + LM3533_LED_DELAY2_TMIN) / 2) {
+		t = clamp(t, LM3533_LED_DELAY2_TMIN, LM3533_LED_DELAY2_TMAX);
+		val = time_to_val(&t,	LM3533_LED_DELAY2_TMIN,
+					LM3533_LED_DELAY2_TSTEP,
+					LM3533_LED_DELAY2_VMIN,
+					LM3533_LED_DELAY2_VMAX);
+	} else {
+		t = clamp(t, LM3533_LED_DELAY1_TMIN, LM3533_LED_DELAY1_TMAX);
+		val = time_to_val(&t,	LM3533_LED_DELAY1_TMIN,
+					LM3533_LED_DELAY1_TSTEP,
+					LM3533_LED_DELAY1_VMIN,
+					LM3533_LED_DELAY1_VMAX);
+	}
+
+	*delay = (t + 500) / 1000;
+
+	return val;
+}
+
+/*
+ * Set delay register base to *delay (in ms) and update *delay to reflect
+ * actual hardware delay used.
+ */
+static u8 lm3533_led_delay_set(struct lm3533_led *led, u8 base,
+							unsigned long *delay)
+{
+	unsigned t;
+	u8 val;
+	u8 reg;
+	int ret;
+
+	t = (unsigned)*delay;
+
+	/* Delay group 3 is only available for low time (delay off). */
+	if (base != LM3533_REG_PATTERN_LOW_TIME_BASE)
+		t = min(t, LM3533_LED_DELAY2_TMAX / 1000);
+
+	val = lm3533_led_get_hw_delay(&t);
+
+	dev_dbg(led->cdev.dev, "%s - %lu: %u (0x%02x)\n", __func__,
+							*delay, t, val);
+	reg = lm3533_led_get_pattern_reg(led, base);
+	ret = lm3533_write(led->lm3533, reg, val);
+	if (ret)
+		dev_err(led->cdev.dev, "failed to set delay (%02x)\n", reg);
+
+	*delay = t;
+
+	return ret;
+}
+
+static int lm3533_led_delay_on_set(struct lm3533_led *led, unsigned long *t)
+{
+	return lm3533_led_delay_set(led, LM3533_REG_PATTERN_HIGH_TIME_BASE, t);
+}
+
+static int lm3533_led_delay_off_set(struct lm3533_led *led, unsigned long *t)
+{
+	return lm3533_led_delay_set(led, LM3533_REG_PATTERN_LOW_TIME_BASE, t);
+}
+
+static int lm3533_led_blink_set(struct led_classdev *cdev,
+				unsigned long *delay_on,
+				unsigned long *delay_off)
+{
+	struct lm3533_led *led = to_lm3533_led(cdev);
+	int ret;
+
+	dev_dbg(led->cdev.dev, "%s - on = %lu, off = %lu\n", __func__,
+							*delay_on, *delay_off);
+
+	if (*delay_on > LM3533_LED_DELAY_ON_MAX ||
+					*delay_off > LM3533_LED_DELAY_OFF_MAX)
+		return -EINVAL;
+
+	if (*delay_on == 0 && *delay_off == 0) {
+		*delay_on = 500;
+		*delay_off = 500;
+	}
+
+	ret = lm3533_led_delay_on_set(led, delay_on);
+	if (ret)
+		return ret;
+
+	ret = lm3533_led_delay_off_set(led, delay_off);
+	if (ret)
+		return ret;
+
+	return lm3533_led_pattern_enable(led, 1);
+}
+
+static ssize_t show_id(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", led->id);
+}
+
+/*
+ * Pattern generator rise/fall times:
+ *
+ *   0 - 2048 us (default)
+ *   1 - 262 ms
+ *   2 - 524 ms
+ *   3 - 1.049 s
+ *   4 - 2.097 s
+ *   5 - 4.194 s
+ *   6 - 8.389 s
+ *   7 - 16.78 s
+ */
+static ssize_t show_risefalltime(struct device *dev,
+					struct device_attribute *attr,
+					char *buf, u8 base)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	ssize_t ret;
+	u8 reg;
+	u8 val;
+
+	reg = lm3533_led_get_pattern_reg(led, base);
+	ret = lm3533_read(led->lm3533, reg, &val);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%x\n", val);
+}
+
+static ssize_t show_risetime(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return show_risefalltime(dev, attr, buf,
+					LM3533_REG_PATTERN_RISETIME_BASE);
+}
+
+static ssize_t show_falltime(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return show_risefalltime(dev, attr, buf,
+					LM3533_REG_PATTERN_FALLTIME_BASE);
+}
+
+static ssize_t store_risefalltime(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len, u8 base)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	u8 val;
+	u8 reg;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val) || val > LM3533_RISEFALLTIME_MAX)
+		return -EINVAL;
+
+	reg = lm3533_led_get_pattern_reg(led, base);
+	ret = lm3533_write(led->lm3533, reg, val);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t store_risetime(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	return store_risefalltime(dev, attr, buf, len,
+					LM3533_REG_PATTERN_RISETIME_BASE);
+}
+
+static ssize_t store_falltime(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	return store_risefalltime(dev, attr, buf, len,
+					LM3533_REG_PATTERN_FALLTIME_BASE);
+}
+
+static ssize_t show_als_channel(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned channel;
+	u8 reg;
+	u8 val;
+	int ret;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	ret = lm3533_read(led->lm3533, reg, &val);
+	if (ret)
+		return ret;
+
+	channel = (val & LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK) + 1;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
+}
+
+static ssize_t store_als_channel(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned channel;
+	u8 reg;
+	u8 val;
+	u8 mask;
+	int ret;
+
+	if (kstrtouint(buf, 0, &channel))
+		return -EINVAL;
+
+	if (channel < LM3533_ALS_CHANNEL_LV_MIN ||
+					channel > LM3533_ALS_CHANNEL_LV_MAX)
+		return -EINVAL;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	mask = LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK;
+	val = channel - 1;
+
+	ret = lm3533_update(led->lm3533, reg, val, mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_als_en(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	bool enable;
+	u8 reg;
+	u8 val;
+	int ret;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	ret = lm3533_read(led->lm3533, reg, &val);
+	if (ret)
+		return ret;
+
+	enable = val & LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", enable);
+}
+
+static ssize_t store_als_en(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned enable;
+	u8 reg;
+	u8 mask;
+	u8 val;
+	int ret;
+
+	if (kstrtouint(buf, 0, &enable))
+		return -EINVAL;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	mask = LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK;
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(led->lm3533, reg, val, mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_linear(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	u8 reg;
+	u8 val;
+	int linear;
+	int ret;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	ret = lm3533_read(led->lm3533, reg, &val);
+	if (ret)
+		return ret;
+
+	if (val & LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK)
+		linear = 1;
+	else
+		linear = 0;
+
+	return scnprintf(buf, PAGE_SIZE, "%x\n", linear);
+}
+
+static ssize_t store_linear(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned long linear;
+	u8 reg;
+	u8 mask;
+	u8 val;
+	int ret;
+
+	if (kstrtoul(buf, 0, &linear))
+		return -EINVAL;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	mask = LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK;
+
+	if (linear)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(led->lm3533, reg, val, mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_pwm(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	u8 val;
+	int ret;
+
+	ret = lm3533_ctrlbank_get_pwm(&led->cb, &val);
+	if (ret)
+		return ret;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t store_pwm(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	u8 val;
+	int ret;
+
+	if (kstrtou8(buf, 0, &val))
+		return -EINVAL;
+
+	ret = lm3533_ctrlbank_set_pwm(&led->cb, val);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static LM3533_ATTR_RW(als_channel);
+static LM3533_ATTR_RW(als_en);
+static LM3533_ATTR_RW(falltime);
+static LM3533_ATTR_RO(id);
+static LM3533_ATTR_RW(linear);
+static LM3533_ATTR_RW(pwm);
+static LM3533_ATTR_RW(risetime);
+
+static struct attribute *lm3533_led_attributes[] = {
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
+	&dev_attr_falltime.attr,
+	&dev_attr_id.attr,
+	&dev_attr_linear.attr,
+	&dev_attr_pwm.attr,
+	&dev_attr_risetime.attr,
+	NULL,
+};
+
+static umode_t lm3533_led_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	umode_t mode = attr->mode;
+
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
+		if (!led->lm3533->have_als)
+			mode = 0;
+	}
+
+	return mode;
+};
+
+static struct attribute_group lm3533_led_attribute_group = {
+	.is_visible	= lm3533_led_attr_is_visible,
+	.attrs		= lm3533_led_attributes
+};
+
+static int __devinit lm3533_led_setup(struct lm3533_led *led,
+					struct lm3533_led_platform_data *pdata)
+{
+	int ret;
+
+	ret = lm3533_ctrlbank_set_max_current(&led->cb, pdata->max_current);
+	if (ret)
+		return ret;
+
+	return lm3533_ctrlbank_set_pwm(&led->cb, pdata->pwm);
+}
+
+static int __devinit lm3533_led_probe(struct platform_device *pdev)
+{
+	struct lm3533 *lm3533;
+	struct lm3533_led_platform_data *pdata;
+	struct lm3533_led *led;
+	int ret;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533 = dev_get_drvdata(pdev->dev.parent);
+	if (!lm3533)
+		return -EINVAL;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	if (pdev->id < 0 || pdev->id >= LM3533_LVCTRLBANK_COUNT) {
+		dev_err(&pdev->dev, "illegal LED id %d\n", pdev->id);
+		return -EINVAL;
+	}
+
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->lm3533 = lm3533;
+	led->cdev.name = pdata->name;
+	led->cdev.default_trigger = pdata->default_trigger;
+	led->cdev.brightness_set = lm3533_led_set;
+	led->cdev.brightness_get = lm3533_led_get;
+	led->cdev.blink_set = lm3533_led_blink_set;
+	led->cdev.brightness = LED_OFF;
+	led->id = pdev->id;
+
+	mutex_init(&led->mutex);
+	INIT_WORK(&led->work, lm3533_led_work);
+
+	/* The class framework makes a callback to get brightness during
+	 * registration so use parent device (for error reporting) until
+	 * registered.
+	 */
+	led->cb.lm3533 = lm3533;
+	led->cb.id = lm3533_led_get_ctrlbank_id(led);
+	led->cb.dev = lm3533->dev;
+
+	platform_set_drvdata(pdev, led);
+
+	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
+		return ret;
+	}
+
+	led->cb.dev = led->cdev.dev;
+
+	ret = sysfs_create_group(&led->cdev.dev->kobj,
+						&lm3533_led_attribute_group);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
+		goto err_unregister;
+	}
+
+	ret = lm3533_led_setup(led, pdata);
+	if (ret)
+		goto err_sysfs_remove;
+
+	ret = lm3533_ctrlbank_enable(&led->cb);
+	if (ret)
+		goto err_sysfs_remove;
+
+	return 0;
+
+err_sysfs_remove:
+	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
+err_unregister:
+	led_classdev_unregister(&led->cdev);
+	flush_work_sync(&led->work);
+
+	return ret;
+}
+
+static int __devexit lm3533_led_remove(struct platform_device *pdev)
+{
+	struct lm3533_led *led = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533_ctrlbank_disable(&led->cb);
+	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
+	led_classdev_unregister(&led->cdev);
+	flush_work_sync(&led->work);
+
+	return 0;
+}
+
+static void lm3533_led_shutdown(struct platform_device *pdev)
+{
+
+	struct lm3533_led *led = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	lm3533_ctrlbank_disable(&led->cb);
+	lm3533_led_set(&led->cdev, LED_OFF);		/* disable blink */
+	flush_work_sync(&led->work);
+}
+
+static struct platform_driver lm3533_led_driver = {
+	.driver = {
+		.name = "lm3533-leds",
+		.owner = THIS_MODULE,
+	},
+	.probe		= lm3533_led_probe,
+	.remove		= __devexit_p(lm3533_led_remove),
+	.shutdown	= lm3533_led_shutdown,
+};
+module_platform_driver(lm3533_led_driver);
+
+MODULE_AUTHOR("Johan Hovold <jhovold@gmail.com>");
+MODULE_DESCRIPTION("LM3533 LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lm3533-leds");
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch

