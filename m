From: akpm@linux-foundation.org
Subject: [merged] backlight-da903x_bl-use-bl_core_suspendresume-option.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:23 -0700
Message-ID: <20130430185223.738E731C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35224 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3SwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:24 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86385vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, lars@metafoo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: da903x_bl: use BL_CORE_SUSPENDRESUME option
has been removed from the -mm tree.  Its filename was
     backlight-da903x_bl-use-bl_core_suspendresume-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: da903x_bl: use BL_CORE_SUSPENDRESUME option

Use BL_CORE_SUSPENDRESUME option to support suspend/resume.
It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x_bl.c |   30 ++++----------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff -puN drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-bl_core_suspendresume-option drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-bl_core_suspendresume-option
+++ a/drivers/video/backlight/da903x_bl.c
@@ -88,16 +88,21 @@ static int da903x_backlight_update_statu
 	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
 		brightness = 0;
 
+	if (bl->props.state & BL_CORE_SUSPENDED)
+		brightness = 0;
+
 	return da903x_backlight_set(bl, brightness);
 }
 
 static int da903x_backlight_get_brightness(struct backlight_device *bl)
 {
 	struct da903x_backlight_data *data = bl_get_data(bl);
+
 	return data->current_brightness;
 }
 
 static const struct backlight_ops da903x_backlight_ops = {
+	.options	= BL_CORE_SUSPENDRESUME,
 	.update_status	= da903x_backlight_update_status,
 	.get_brightness	= da903x_backlight_get_brightness,
 };
@@ -161,35 +166,10 @@ static int da903x_backlight_remove(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int da903x_backlight_suspend(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	return da903x_backlight_set(bl, 0);
-}
-
-static int da903x_backlight_resume(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	backlight_update_status(bl);
-	return 0;
-}
-
-static const struct dev_pm_ops da903x_backlight_pm_ops = {
-	.suspend	= da903x_backlight_suspend,
-	.resume		= da903x_backlight_resume,
-};
-#endif
