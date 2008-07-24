From: akpm@linux-foundation.org
Subject: - lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:53 -0700
Message-ID: <200807242332.m6ONWr1j011875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859AbYGXXd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     lcd: add lcd_device to check_fb() entry in lcd_ops
has been removed from the -mm tree.  Its filename was
     lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

