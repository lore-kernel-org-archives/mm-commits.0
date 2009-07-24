From: akpm@linux-foundation.org
Subject: + davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch added to -mm tree
Date: Fri, 24 Jul 2009 14:23:51 -0700
Message-ID: <200907242123.n6OLNpgQ015394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZGXVY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com


The patch titled
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
has been added to the -mm tree.  Its filename is
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Since the previous version, return values in ioctl() function have been
modified.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Signed-off-by: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Signed-off-by: Steve Chen <schen@mvista.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4 drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
+++ a/drivers/video/da8xx-fb.c
@@ -201,14 +201,13 @@ static int lcd_disable_raster(struct da8
 		ret = wait_event_interruptible_timeout(par->da8xx_wq,
 						!lcdc_read(LCD_STAT_REG) &
 						LCD_END_OF_FRAME0, WSI_TIMEOUT);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			ret = -ETIMEDOUT;
 	}
 
-	if (ret < 0)
-		return ret;
-	if (ret == 0)
-		return -ETIMEDOUT;
-
-	return 0;
+	return ret;
 }
 
 static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
@@ -634,11 +633,11 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_BRIGHTNESS:
 	case FBIGET_COLOR:
 	case FBIPUT_COLOR:
-		return -EINVAL;
+		return -ENOTTY;
 	case FBIPUT_HSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_horizontal_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
@@ -646,7 +645,7 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_VSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_vertical_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

linux-next.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch

