From: akpm@linux-foundation.org
Subject: + backlight-platform_lcd-remove-unnecessary-ifdefs.patch added to -mm tree
Date: Mon, 25 Feb 2013 14:21:08 -0800
Message-ID: <20130225222108.A204831C233@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:37864 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3BYWVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 17:21:10 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so359995vea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 14:21:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs
has been added to the -mm tree.  Its filename is
     backlight-platform_lcd-remove-unnecessary-ifdefs.patch

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
backlight-ams369fg06-make-power_on-call-optional.patch
lib-devresc-fix-misplaced-endif.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

