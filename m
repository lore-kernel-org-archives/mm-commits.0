From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:41:15 -0700
Message-ID: <20121030224116.36BFA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35277 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2J3WlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:41:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so92737qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:41:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/hp680_bl.c: add missing __devexit macros for remove
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch

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
@@ -124,7 +124,7 @@ static int __devinit hp680bl_probe(struc
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

