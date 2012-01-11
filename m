From: akpm@linux-foundation.org
Subject: [merged] backlight-use-kstrtoul.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:00 -0800
Message-ID: <20120111213000.ED6265C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33294 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab2AKVaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:02 -0500
Received: by mail-we0-f202.google.com with SMTP id f1so53608wer.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: use kstrtoul()
has been removed from the -mm tree.  Its filename was
     backlight-use-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

