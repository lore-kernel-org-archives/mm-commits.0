From: akpm@linux-foundation.org
Subject: + backlight-use-kstrtoul.patch added to -mm tree
Date: Tue, 27 Dec 2011 15:04:51 -0800
Message-ID: <20111227230451.A014C10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58899 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1L0XEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 18:04:52 -0500
Received: by yenm5 with SMTP id m5so1512095yen.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 15:04:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: use kstrtoul()
has been added to the -mm tree.  Its filename is
     backlight-use-kstrtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: use kstrtoul()

The usage of simple_strtoul() or strict_strtoul() is not preferred.  Thus,
kstrtoul should be used.

This patch also fixes checkpatch error as follows:
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    6 +++---
 drivers/video/backlight/lcd.c       |   26 ++++++++++----------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-use-kstrtoul drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-use-kstrtoul
+++ a/drivers/video/backlight/backlight.c
@@ -102,7 +102,7 @@ static void backlight_generate_event(str
 }
 
 static ssize_t backlight_show_power(struct device *dev,
-		struct device_attribute *attr,char *buf)
+		struct device_attribute *attr, char *buf)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
@@ -116,7 +116,7 @@ static ssize_t backlight_store_power(str
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long power;
 
-	rc = strict_strtoul(buf, 0, &power);
+	rc = kstrtoul(buf, 0, &power);
 	if (rc)
 		return rc;
 
@@ -150,7 +150,7 @@ static ssize_t backlight_store_brightnes
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long brightness;
 
-	rc = strict_strtoul(buf, 0, &brightness);
+	rc = kstrtoul(buf, 0, &brightness);
 	if (rc)
 		return rc;
 
diff -puN drivers/video/backlight/lcd.c~backlight-use-kstrtoul drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-use-kstrtoul
+++ a/drivers/video/backlight/lcd.c
@@ -97,19 +97,16 @@ static ssize_t lcd_store_power(struct de
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc = -ENXIO;
-	char *endp;
 	struct lcd_device *ld = to_lcd_device(dev);
-	int power = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long power;
 
-	if (isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = kstrtoul(buf, 0, &power);
+	if (rc)
+		return rc;
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
-		pr_debug("lcd: set power to %d\n", power);
+		pr_debug("lcd: set power to %lu\n", power);
 		ld->ops->set_power(ld, power);
 		rc = count;
 	}
@@ -136,19 +133,16 @@ static ssize_t lcd_store_contrast(struct
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc = -ENXIO;
-	char *endp;
 	struct lcd_device *ld = to_lcd_device(dev);
-	int contrast = simple_strtoul(buf, &endp, 0);
-	size_t size = endp - buf;
+	unsigned long contrast;
 
-	if (isspace(*endp))
-		size++;
-	if (size != count)
-		return -EINVAL;
+	rc = kstrtoul(buf, 0, &contrast);
+	if (rc)
+		return rc;
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
-		pr_debug("lcd: set contrast to %d\n", contrast);
+		pr_debug("lcd: set contrast to %lu\n", contrast);
 		ld->ops->set_contrast(ld, contrast);
 		rc = count;
 	}
_
Subject: Subject: backlight: use kstrtoul()

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-ep93xx_blc-remove-duplicated-header-include.patch
backlight-use-kstrtoul.patch

