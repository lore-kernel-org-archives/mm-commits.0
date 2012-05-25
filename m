From: akpm@linux-foundation.org
Subject: + backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch added to -mm tree
Date: Fri, 25 May 2012 16:08:56 -0700
Message-ID: <20120525230856.584D2A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37732 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2EYXI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 19:08:57 -0400
Received: by vcbfl13 with SMTP id fl13so114112vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 16:08:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: lm3533: replace als attribute with als_channel and als_en
has been added to the -mm tree.  Its filename is
     backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: backlight: lm3533: replace als attribute with als_channel and als_en

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
linux-next.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-add-lm3533-backlight-driver-v4.patch
backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch
leds-add-lm3533-led-driver.patch
leds-add-lm3533-led-driver-fix.patch
leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch

