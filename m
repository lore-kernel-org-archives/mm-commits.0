From: akpm@linux-foundation.org
Subject: + backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:08 -0700
Message-ID: <20120516195508.ECEB5A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62630 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458Ab2EPTzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:11 -0400
Received: by wibhn6 with SMTP id hn6so67179wib.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, joe@perches.com, kristoffer.ericson@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: jornada720: use pr_err()/pr_info() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch

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
Subject: backlight: jornada720: use pr_err()/pr_info() instead of printk()

Use pr_err()/pr_info() instead of printk() to allow dynamic debugging. 
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings as
below:

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c  |   14 ++++++++------
 drivers/video/backlight/jornada720_lcd.c |    8 +++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "jornada720_bl: " fmt
+
 #include <linux/backlight.h>
 #include <linux/device.h>
 #include <linux/fb.h>
@@ -38,7 +40,7 @@ static int jornada_bl_get_brightness(str
 	ret = jornada_ssp_byte(GETBRIGHTNESS);
 
 	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
-		printk(KERN_ERR "bl : get brightness timeout\n");
+		pr_err("get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else /* exchange txdummy for value */
@@ -59,7 +61,7 @@ static int jornada_bl_update_status(stru
 	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
-			printk(KERN_INFO "bl : brightness off timeout\n");
+			pr_info("brightness off timeout\n");
 			/* turn off backlight */
 			PPSR &= ~PPC_LDD1;
 			PPDR |= PPC_LDD1;
@@ -70,7 +72,7 @@ static int jornada_bl_update_status(stru
 
 		/* send command to our mcu */
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
-			printk(KERN_INFO "bl : failed to set brightness\n");
+			pr_info("failed to set brightness\n");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -81,7 +83,7 @@ static int jornada_bl_update_status(stru
 		   but due to physical layout it is equal to 0, so we simply
 		   invert the value (MAX VALUE - NEW VALUE). */
 		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
-			printk(KERN_ERR "bl : set brightness failed\n");
+			pr_err("set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
@@ -113,7 +115,7 @@ static int jornada_bl_probe(struct platf
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		printk(KERN_ERR "bl : failed to register device, err=%x\n", ret);
+		pr_err("failed to register device, err=%x\n", ret);
 		return ret;
 	}
 
@@ -125,7 +127,7 @@ static int jornada_bl_probe(struct platf
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
-	printk(KERN_INFO "HP Jornada 700 series backlight driver\n");
+	pr_info("HP Jornada 700 series backlight driver\n");
 
 	return 0;
 }
diff -puN drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-pr_err-pr_info-instead-of-printk
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "jornada720_lcd: " fmt
+
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
@@ -44,7 +46,7 @@ static int jornada_lcd_get_contrast(stru
 	jornada_ssp_start();
 
 	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		printk(KERN_ERR "lcd: get contrast failed\n");
+		pr_err("get contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else {
@@ -65,7 +67,7 @@ static int jornada_lcd_set_contrast(stru
 
 	/* push the new value */
 	if (jornada_ssp_byte(value) != TXDUMMY) {
-		printk(KERN_ERR "lcd : set contrast failed\n");
+		pr_err("set contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	}
@@ -103,7 +105,7 @@ static int jornada_lcd_probe(struct plat
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-		printk(KERN_ERR "lcd : failed to register device\n");
+		pr_err("failed to register device\n");
 		return ret;
 	}
 
_
Subject: Subject: backlight: jornada720: use pr_err()/pr_info() instead of printk()

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch

