From: akpm@linux-foundation.org
Subject: [obsolete] drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch removed from -mm tree
Date: Tue, 18 Dec 2012 11:37:07 -0800
Message-ID: <20121218193708.9BA44200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60580 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2LRThL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 14:37:11 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so62434lag.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 11:37:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/hp680_bl.c: add missing __devexit macros for remove
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/hp680_bl.c: add missing __devexit macros for remove

The __devexit macros is added to remove function.  The macro moves the
remove function to devexit section.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hp680_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/hp680_bl.c~drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove
+++ a/drivers/video/backlight/hp680_bl.c
@@ -124,7 +124,7 @@ static int hp680bl_probe(struct platform
 	return 0;
 }
 
-static int hp680bl_remove(struct platform_device *pdev)
+static int __devexit hp680bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -139,7 +139,7 @@ static int hp680bl_remove(struct platfor
 
 static struct platform_driver hp680bl_driver = {
 	.probe		= hp680bl_probe,
-	.remove		= hp680bl_remove,
+	.remove		= __devexit_p(hp680bl_remove),
 	.suspend	= hp680bl_suspend,
 	.resume		= hp680bl_resume,
 	.driver		= {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch
backlight-add-of_find_backlight_by_node-function.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch
drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch
backlight-corgi_lcd-use-gpio_set_value_cansleep-to-avoid-warn_on.patch
checkpatch-extend-line-continuation-test.patch

