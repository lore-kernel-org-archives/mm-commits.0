From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:04:31 -0700
Message-ID: <20121030220432.3D0B0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52911 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934844Ab2J3WEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:04:33 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so89622qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:04:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kzalloc'd data
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch

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
Subject: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kzalloc'd data

devm_kfree() allocates memory that is released when a driver detaches. 
Thus, there is no reason to explicitly call devm_kfree in probe or remove
functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/max8925_bl.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/max8925_bl.c~drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data
+++ a/drivers/video/backlight/max8925_bl.c
@@ -120,15 +120,13 @@ static int __devinit max8925_backlight_p
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for mode control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_mode_cntl = res->start;
 	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_cntl = res->start;
 
@@ -142,8 +140,7 @@ static int __devinit max8925_backlight_p
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out;
+		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
 
@@ -166,8 +163,6 @@ static int __devinit max8925_backlight_p
 	return 0;
 out_brt:
 	backlight_device_unregister(bl);
-out:
-	devm_kfree(&pdev->dev, data);
 	return ret;
 }
 
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

