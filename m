From: akpm@linux-foundation.org
Subject: [folded] backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch removed from -mm tree
Date: Tue, 29 May 2012 14:50:00 -0700
Message-ID: <20120529215000.BE101A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50336 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2E2VuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:50:01 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so456381vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:50:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lm3533: replace als attribute with als_channel and als_en
has been removed from the -mm tree.  Its filename was
     backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch

This patch was dropped because it was folded into backlight-add-lm3533-backlight-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight: lm3533: replace als attribute with als_channel and als_en

Replace the als attribute with two separate attributes for selecting ALS
channel and enabling ALS-current-control mode.

This change is needed to reflect changes made to the ALS sub-driver which
now uses 0-indexed current output channels (rather than 1-indexed
ALS-mapper target sets).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533 |   19 ++-
 drivers/video/backlight/lm3533_bl.c                           |   48 +++++-----
 2 files changed, 37 insertions(+), 30 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en
+++ a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
@@ -1,13 +1,20 @@
-What:		/sys/class/backlight/<backlight>/als
-Date:		April 2012
+What:		/sys/class/backlight/<backlight>/als_channel
+Date:		May 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0..2), where
+		Get the ALS output channel used as input in
+		ALS-current-control mode (0, 1), where
+
+		0 - out_current0 (backlight 0)
+		1 - out_current1 (backlight 1)
 
-		0 - disabled
-		1 - ALS-mapper 1 (backlight 0)
-		2 - ALS-mapper 2 (backlight 1)
+What:		/sys/class/backlight/<backlight>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
 
 What:		/sys/class/backlight/<backlight>/id
 Date:		April 2012
diff -puN drivers/video/backlight/lm3533_bl.c~backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -79,55 +79,52 @@ static ssize_t show_id(struct device *de
 	return scnprintf(buf, PAGE_SIZE, "%d\n", bl->id);
 }
 
-/*
- * ALS-control setting:
- *
- *   0 - ALS disabled
- *   1 - ALS-mapper 1 (backlight 0)
- *   2 - ALS-mapper 2 (backlight 1)
- */
-static ssize_t show_als(struct device *dev,
+static ssize_t show_als_channel(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	unsigned channel = lm3533_bl_get_ctrlbank_id(bl);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
+}
+
+static ssize_t show_als_en(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
 	u8 val;
 	u8 mask;
-	int als;
+	bool enable;
 	int ret;
 
 	ret = lm3533_read(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, &val);
 	if (ret)
 		return ret;
 
-	mask = 2 * ctrlbank;
-	als = val & mask;
-	if (als)
-		als = ctrlbank + 1;
+	mask = 1 << (2 * ctrlbank);
+	enable = val & mask;
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", als);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", enable);
 }
 
-static ssize_t store_als(struct device *dev,
+static ssize_t store_als_en(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
-	int als;
+	int enable;
 	u8 val;
 	u8 mask;
 	int ret;
 
-	if (kstrtoint(buf, 0, &als))
-		return -EINVAL;
-
-	if (als != 0 && (als != ctrlbank + 1))
+	if (kstrtoint(buf, 0, &enable))
 		return -EINVAL;
 
 	mask = 1 << (2 * ctrlbank);
 
-	if (als)
+	if (enable)
 		val = mask;
 	else
 		val = 0;
@@ -224,13 +221,15 @@ static ssize_t store_pwm(struct device *
 	return len;
 }
 
-static LM3533_ATTR_RW(als);
+static LM3533_ATTR_RO(als_channel);
+static LM3533_ATTR_RW(als_en);
 static LM3533_ATTR_RO(id);
 static LM3533_ATTR_RW(linear);
 static LM3533_ATTR_RW(pwm);
 
 static struct attribute *lm3533_bl_attributes[] = {
-	&dev_attr_als.attr,
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
 	&dev_attr_id.attr,
 	&dev_attr_linear.attr,
 	&dev_attr_pwm.attr,
@@ -244,7 +243,8 @@ static umode_t lm3533_bl_attr_is_visible
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	umode_t mode = attr->mode;
 
-	if (attr == &dev_attr_als.attr) {
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
 		if (!bl->lm3533->have_als)
 			mode = 0;
 	}
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
backlight-add-lm3533-backlight-driver.patch
leds-add-lm3533-led-driver.patch
leds-add-lm3533-led-driver-fix.patch
leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch

