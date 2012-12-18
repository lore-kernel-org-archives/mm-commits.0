From: akpm@linux-foundation.org
Subject: [merged] backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:42 -0800
Message-ID: <20121218200542.A38BC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50032 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:43 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so125522vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lcd.c: return ENXIO when ops functions cannot be called
has been removed from the -mm tree.  Its filename was
     backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lcd.c: return ENXIO when ops functions cannot be called

Previously, when ops functions cannot be called, lcd_show_contrast() and
lcd_store_contrast() returned 0, instead of ENXIO.

Thus, in this case, a local variable 'rc' for return value should be
initialized as ENXIO, after kstrtoul() is called.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lcd.c~backlight-lcd-return-enxio-when-ops-functions-cannot-be-called drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-lcd-return-enxio-when-ops-functions-cannot-be-called
+++ a/drivers/video/backlight/lcd.c
@@ -108,7 +108,7 @@ static ssize_t lcd_show_power(struct dev
 static ssize_t lcd_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long power;
 
@@ -116,6 +116,8 @@ static ssize_t lcd_store_power(struct de
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
 		pr_debug("set power to %lu\n", power);
@@ -144,7 +146,7 @@ static ssize_t lcd_show_contrast(struct 
 static ssize_t lcd_store_contrast(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long contrast;
 
@@ -152,6 +154,8 @@ static ssize_t lcd_store_contrast(struct
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
 		pr_debug("set contrast to %lu\n", contrast);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

