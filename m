From: akpm@linux-foundation.org
Subject: [merged] backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:41 -0700
Message-ID: <20120531191841.67C65A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59318 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2EaTSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:44 -0400
Received: by lbbgp10 with SMTP id gp10so85912lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: use pr_warn() and pr_debug() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: use pr_warn() and pr_debug() instead of printk()

Use pr_warn() and pr_debug() instead of printk to allow dynamic debugging.
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings
as below:

WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   11 ++++++-----
 drivers/video/backlight/lcd.c       |   10 ++++++----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-use-pr_warn-and-pr_debug-instead-of-printk drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-use-pr_warn-and-pr_debug-instead-of-printk
+++ a/drivers/video/backlight/backlight.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -123,7 +125,7 @@ static ssize_t backlight_store_power(str
 	rc = -ENXIO;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops) {
-		pr_debug("backlight: set power to %lu\n", power);
+		pr_debug("set power to %lu\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
 			backlight_update_status(bd);
@@ -161,8 +163,7 @@ static ssize_t backlight_store_brightnes
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
-			pr_debug("backlight: set brightness to %lu\n",
-				 brightness);
+			pr_debug("set brightness to %lu\n", brightness);
 			bd->props.brightness = brightness;
 			backlight_update_status(bd);
 			rc = count;
@@ -378,8 +379,8 @@ static int __init backlight_class_init(v
 {
 	backlight_class = class_create(THIS_MODULE, "backlight");
 	if (IS_ERR(backlight_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(backlight_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(backlight_class));
 		return PTR_ERR(backlight_class);
 	}
 
diff -puN drivers/video/backlight/lcd.c~backlight-use-pr_warn-and-pr_debug-instead-of-printk drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-use-pr_warn-and-pr_debug-instead-of-printk
+++ a/drivers/video/backlight/lcd.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -116,7 +118,7 @@ static ssize_t lcd_store_power(struct de
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
-		pr_debug("lcd: set power to %lu\n", power);
+		pr_debug("set power to %lu\n", power);
 		ld->ops->set_power(ld, power);
 		rc = count;
 	}
@@ -152,7 +154,7 @@ static ssize_t lcd_store_contrast(struct
 
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
-		pr_debug("lcd: set contrast to %lu\n", contrast);
+		pr_debug("set contrast to %lu\n", contrast);
 		ld->ops->set_contrast(ld, contrast);
 		rc = count;
 	}
@@ -263,8 +265,8 @@ static int __init lcd_class_init(void)
 {
 	lcd_class = class_create(THIS_MODULE, "lcd");
 	if (IS_ERR(lcd_class)) {
-		printk(KERN_WARNING "Unable to create backlight class; errno = %ld\n",
-				PTR_ERR(lcd_class));
+		pr_warn("Unable to create backlight class; errno = %ld\n",
+			PTR_ERR(lcd_class));
 		return PTR_ERR(lcd_class);
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

