From: akpm@linux-foundation.org
Subject: [folded] leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch removed from -mm tree
Date: Tue, 29 May 2012 14:55:06 -0700
Message-ID: <20120529215506.9F08AA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51191 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2E2VzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:55:09 -0400
Received: by faaa25 with SMTP id a25so263300faa.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: lm3533: replace als attribute with als_channel and als_en
has been removed from the -mm tree.  Its filename was
     leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch

This patch was dropped because it was folded into leds-add-lm3533-led-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: leds: lm3533: replace als attribute with als_channel and als_en

Replace the als attribute with two separate attributes for selecting ALS
channel and enabling ALS-current-control mode.

This change is needed to reflect changes made to the ALS sub-driver
which now uses 0-indexed current output channels (rather than 1-indexed
ALS-mapper target sets).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-led-driver-lm3533 |   19 +
 drivers/leds/leds-lm3533.c                              |   98 +++++++---
 2 files changed, 87 insertions(+), 30 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-led-driver-lm3533~leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en Documentation/ABI/testing/sysfs-class-led-driver-lm3533
--- a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533~leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en
+++ a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
@@ -1,13 +1,20 @@
-What:		/sys/class/leds/<led>/als
-Date:		April 2012
+What:		/sys/class/leds/<led>/als_channel
+Date:		May 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0, 2, 3), where
+		Set the ALS output channel to use as input in
+		ALS-current-control mode (1, 2), where
+
+		1 - out_current1
+		2 - out_current2
 
-		0 - disabled
-		2 - ALS-mapper 2
-		3 - ALS-mapper 3
+What:		/sys/class/leds/<led>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
 
 What:		/sys/class/leds/<led>/falltime
 What:		/sys/class/leds/<led>/risetime
diff -puN drivers/leds/leds-lm3533.c~leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en drivers/leds/leds-lm3533.c
--- a/drivers/leds/leds-lm3533.c~leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en
+++ a/drivers/leds/leds-lm3533.c
@@ -27,8 +27,8 @@
 #define LM3533_LVCTRLBANK_MAX		5
 #define LM3533_LVCTRLBANK_COUNT		4
 #define LM3533_RISEFALLTIME_MAX		7
-#define LM3533_ALS_LV_MIN		2
-#define LM3533_ALS_LV_MAX		3
+#define LM3533_ALS_CHANNEL_LV_MIN	1
+#define LM3533_ALS_CHANNEL_LV_MAX	2
 
 #define LM3533_REG_CTRLBANK_BCONF_BASE		0x1b
 #define LM3533_REG_PATTERN_ENABLE		0x28
@@ -39,8 +39,9 @@
 
 #define LM3533_REG_PATTERN_STEP			0x10
 
-#define LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK	0x04
-#define LM3533_REG_CTRLBANK_BCONF_ALS_MASK	0x03
+#define LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK		0x04
+#define LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK		0x02
+#define LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK	0x01
 
 #define LM3533_LED_FLAG_PATTERN_ENABLE		1
 
@@ -416,21 +417,14 @@ static ssize_t store_falltime(struct dev
 					LM3533_REG_PATTERN_FALLTIME_BASE);
 }
 
-/*
- * ALS-control setting:
- *
- *   0 - ALS disabled
- *   2 - ALS-mapper 2
- *   3 - ALS-mapper 3
- */
-static ssize_t show_als(struct device *dev,
+static ssize_t show_als_channel(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned channel;
 	u8 reg;
 	u8 val;
-	int als;
 	int ret;
 
 	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
@@ -438,32 +432,85 @@ static ssize_t show_als(struct device *d
 	if (ret)
 		return ret;
 
-	als = val & LM3533_REG_CTRLBANK_BCONF_ALS_MASK;
+	channel = (val & LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK) + 1;
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", als);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
 }
 
-static ssize_t store_als(struct device *dev,
+static ssize_t store_als_channel(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
-	u8 als;
+	unsigned channel;
 	u8 reg;
+	u8 val;
 	u8 mask;
 	int ret;
 
-	if (kstrtou8(buf, 0, &als))
+	if (kstrtouint(buf, 0, &channel))
 		return -EINVAL;
 
-	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
+	if (channel < LM3533_ALS_CHANNEL_LV_MIN ||
+					channel > LM3533_ALS_CHANNEL_LV_MAX)
 		return -EINVAL;
 
 	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
-	mask = LM3533_REG_CTRLBANK_BCONF_ALS_MASK;
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
 
-	ret = lm3533_update(led->lm3533, reg, als, mask);
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
 	if (ret)
 		return ret;
 
@@ -558,7 +605,8 @@ static ssize_t store_pwm(struct device *
 	return len;
 }
 
-static LM3533_ATTR_RW(als);
+static LM3533_ATTR_RW(als_channel);
+static LM3533_ATTR_RW(als_en);
 static LM3533_ATTR_RW(falltime);
 static LM3533_ATTR_RO(id);
 static LM3533_ATTR_RW(linear);
@@ -566,7 +614,8 @@ static LM3533_ATTR_RW(pwm);
 static LM3533_ATTR_RW(risetime);
 
 static struct attribute *lm3533_led_attributes[] = {
-	&dev_attr_als.attr,
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
 	&dev_attr_falltime.attr,
 	&dev_attr_id.attr,
 	&dev_attr_linear.attr,
@@ -583,7 +632,8 @@ static umode_t lm3533_led_attr_is_visibl
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
 	umode_t mode = attr->mode;
 
-	if (attr == &dev_attr_als.attr) {
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
 		if (!led->lm3533->have_als)
 			mode = 0;
 	}
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
backlight-add-lm3533-backlight-driver.patch
leds-add-lm3533-led-driver.patch

