From: akpm@linux-foundation.org
Subject: + lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:09:46 -0700
Message-ID: <200806240709.m5O79kcT005973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYFXHKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     lcd: add lcd_device to check_fb() entry in lcd_ops
has been added to the -mm tree.  Its filename is
     lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lcd: add lcd_device to check_fb() entry in lcd_ops
From: Ben Dooks <ben-linux@fluff.org>

Add the lcd_device being checked to the check_fb entry of lcd_ops.  This
ensures that any driver using this to check against it's own state can do
so, and also makes all the calls in lcd_ops more orthogonal in their
arguments.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c    |    2 +-
 drivers/video/bf54x-lq043fb.c    |    2 +-
 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 include/linux/lcd.h              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/lcd.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops
+++ a/drivers/video/backlight/lcd.c
@@ -33,7 +33,7 @@ static int fb_notifier_callback(struct n
 	ld = container_of(self, struct lcd_device, fb_notif);
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops)
-		if (!ld->ops->check_fb || ld->ops->check_fb(evdata->info))
+		if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info))
 			ld->ops->set_power(ld, *(int *)evdata->data);
 	mutex_unlock(&ld->ops_lock);
 	return 0;
diff -puN drivers/video/bf54x-lq043fb.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops
+++ a/drivers/video/bf54x-lq043fb.c
@@ -478,7 +478,7 @@ static int bfin_lcd_set_contrast(struct 
 	return 0;
 }
 
-static int bfin_lcd_check_fb(struct fb_info *fi)
+static int bfin_lcd_check_fb(struct lcd_device *dev, struct fb_info *fi)
 {
 	if (!fi || (fi == &bfin_bf54x_fb))
 		return 1;
diff -puN drivers/video/bfin-t350mcqb-fb.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -396,7 +396,7 @@ static int bfin_lcd_set_contrast(struct 
 	return 0;
 }
 
-static int bfin_lcd_check_fb(struct fb_info *fi)
+static int bfin_lcd_check_fb(struct lcd_device *dev, struct fb_info *fi)
 {
 	if (!fi || (fi == &bfin_t350mcqb_fb))
 		return 1;
diff -puN include/linux/lcd.h~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops include/linux/lcd.h
--- a/include/linux/lcd.h~lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops
+++ a/include/linux/lcd.h
@@ -47,7 +47,7 @@ struct lcd_ops {
         int (*set_contrast)(struct lcd_device *, int contrast);
 	/* Check if given framebuffer device is the one LCD is bound to;
 	   return 0 if not, !=0 if it is. If NULL, lcd always matches the fb. */
-	int (*check_fb)(struct fb_info *);
+	int (*check_fb)(struct lcd_device *, struct fb_info *);
 };
 
 struct lcd_device {
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

