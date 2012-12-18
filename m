From: akpm@linux-foundation.org
Subject: [obsolete] drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch removed from -mm tree
Date: Tue, 18 Dec 2012 11:37:01 -0800
Message-ID: <20121218193703.69862200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:48920 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2LRThH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 14:37:07 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so62275wgb.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 11:37:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, hsweeten@visionengravers.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ep93xx_bl.c: fix section mismatch
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ep93xx_bl.c: fix section mismatch

Fix section mismatch warning as below:

WARNING: drivers/video/backlight/built-in.o(.data+0x110): Section mismatch in reference from the variable ep93xxbl_driver to the
function .init.text:ep93xxbl_probe()
The variable ep93xxbl_driver references
the function __init ep93xxbl_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-fix-section-mismatch drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~drivers-video-backlight-ep93xx_blc-fix-section-mismatch
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xx
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int __devinit ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
@@ -106,7 +106,7 @@ static int __init ep93xxbl_probe(struct 
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
+static int __devexit ep93xxbl_remove(struct platform_device *dev)
 {
 	struct backlight_device *bl = platform_get_drvdata(dev);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch
backlight-add-of_find_backlight_by_node-function.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch
drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch
backlight-corgi_lcd-use-gpio_set_value_cansleep-to-avoid-warn_on.patch
checkpatch-extend-line-continuation-test.patch

