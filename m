From: akpm@linux-foundation.org
Subject: [merged] backlight-platform_lcd-remove-unnecessary-ifdefs.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:13 -0700
Message-ID: <20130430185113.6EADE31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:44428 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:14 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86290qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs
has been removed from the -mm tree.  Its filename was
     backlight-platform_lcd-remove-unnecessary-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs

When the macro such as SIMPLE_DEV_PM_OPS is used, there is no need to use
'#ifdef CONFIG_PM' to prevent build error.  Thus, this patch removes
unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-remove-unnecessary-ifdefs drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform_lcd-remove-unnecessary-ifdefs
+++ a/drivers/video/backlight/platform_lcd.c
@@ -121,7 +121,7 @@ static int platform_lcd_remove(struct pl
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int platform_lcd_suspend(struct device *dev)
 {
 	struct platform_lcd *plcd = dev_get_drvdata(dev);
@@ -141,10 +141,10 @@ static int platform_lcd_resume(struct de
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
 			platform_lcd_resume);
-#endif
 
 #ifdef CONFIG_OF
 static const struct of_device_id platform_lcd_of_match[] = {
@@ -158,9 +158,7 @@ static struct platform_driver platform_l
 	.driver		= {
 		.name	= "platform-lcd",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &platform_lcd_pm_ops,
-#endif
 		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

