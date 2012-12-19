From: akpm@linux-foundation.org
Subject: [merged] backlight-locomolcd-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:15 -0800
Message-ID: <20121219203916.5DB91200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:52758 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2LSUjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:18 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so133989wey.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: locomolcd: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-locomolcd-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: locomolcd: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: space prohibited between function name and open parenthesis '('
ERROR: trailing statements should be on next line

Also, long comments are fixed for the preferred style and unnecessary
lines are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/locomolcd.c |   38 +++++++++++++++++---------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff -puN drivers/video/backlight/locomolcd.c~backlight-locomolcd-fix-checkpatch-error-and-warning drivers/video/backlight/locomolcd.c
--- a/drivers/video/backlight/locomolcd.c~backlight-locomolcd-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/locomolcd.c
@@ -107,7 +107,6 @@ void locomolcd_power(int on)
 }
 EXPORT_SYMBOL(locomolcd_power);
 
-
 static int current_intensity;
 
 static int locomolcd_set_intensity(struct backlight_device *bd)
@@ -122,13 +121,25 @@ static int locomolcd_set_intensity(struc
 		intensity = 0;
 
 	switch (intensity) {
-	/* AC and non-AC are handled differently, but produce same results in sharp code? */
-	case 0: locomo_frontlight_set(locomolcd_dev, 0, 0, 161); break;
-	case 1: locomo_frontlight_set(locomolcd_dev, 117, 0, 161); break;
-	case 2: locomo_frontlight_set(locomolcd_dev, 163, 0, 148); break;
-	case 3: locomo_frontlight_set(locomolcd_dev, 194, 0, 161); break;
-	case 4: locomo_frontlight_set(locomolcd_dev, 194, 1, 161); break;
-
+	/*
+	 * AC and non-AC are handled differently,
+	 * but produce same results in sharp code?
+	 */
+	case 0:
+		locomo_frontlight_set(locomolcd_dev, 0, 0, 161);
+		break;
+	case 1:
+		locomo_frontlight_set(locomolcd_dev, 117, 0, 161);
+		break;
+	case 2:
+		locomo_frontlight_set(locomolcd_dev, 163, 0, 148);
+		break;
+	case 3:
+		locomo_frontlight_set(locomolcd_dev, 194, 0, 161);
+		break;
+	case 4:
+		locomo_frontlight_set(locomolcd_dev, 194, 1, 161);
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -175,9 +186,11 @@ static int locomolcd_probe(struct locomo
 
 	locomo_gpio_set_dir(ldev->dev.parent, LOCOMO_GPIO_FL_VR, 0);
 
-	/* the poodle_lcd_power function is called for the first time
+	/*
+	 * the poodle_lcd_power function is called for the first time
 	 * from fs_initcall, which is before locomo is activated.
-	 * We need to recall poodle_lcd_power here*/
+	 * We need to recall poodle_lcd_power here
+	 */
 	if (machine_is_poodle())
 		locomolcd_power(1);
 
@@ -190,8 +203,8 @@ static int locomolcd_probe(struct locomo
 							&ldev->dev, NULL,
 							&locomobl_data, &props);
 
-	if (IS_ERR (locomolcd_bl_device))
-		return PTR_ERR (locomolcd_bl_device);
+	if (IS_ERR(locomolcd_bl_device))
+		return PTR_ERR(locomolcd_bl_device);
 
 	/* Set up frontlight so that screen is readable */
 	locomolcd_bl_device->props.brightness = 2;
@@ -226,7 +239,6 @@ static struct locomo_driver poodle_lcd_d
 	.resume = locomolcd_resume,
 };
 
