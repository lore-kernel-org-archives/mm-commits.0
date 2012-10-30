From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:41:11 -0700
Message-ID: <20121030224112.A25045C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60958 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2J3WlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:41:15 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so51656lah.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:41:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, hsweeten@visionengravers.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/ep93xx_bl.c: fix section mismatch
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch

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

linux-next.patch
backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch
drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch
drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch
drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch

