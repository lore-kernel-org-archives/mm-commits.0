From: akpm@linux-foundation.org
Subject: [obsolete] drivers-video-backlight-pwm_blc-use-devm_pwm_get.patch removed from -mm tree
Date: Thu, 13 Sep 2012 12:28:04 -0700
Message-ID: <20120913192804.ED3FC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33301 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2IMT2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 15:28:08 -0400
Received: by lbbge1 with SMTP id ge1so215751lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:28:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/pwm_bl.c: use devm_pwm_get()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-pwm_blc-use-devm_pwm_get.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/pwm_bl.c: use devm_pwm_get()

This file already makes use of device managed functions.  Convert
pwm_get() to use it as well.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~drivers-video-backlight-pwm_blc-use-devm_pwm_get drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~drivers-video-backlight-pwm_blc-use-devm_pwm_get
+++ a/drivers/video/backlight/pwm_bl.c
@@ -218,7 +218,7 @@ static int pwm_backlight_probe(struct pl
 	pb->exit = data->exit;
 	pb->dev = &pdev->dev;
 
-	pb->pwm = pwm_get(&pdev->dev, NULL);
+	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
 
@@ -251,7 +251,7 @@ static int pwm_backlight_probe(struct pl
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
-		goto err_bl;
+		goto err_alloc;
 	}
 
 	bl->props.brightness = data->dft_brightness;
@@ -260,8 +260,6 @@ static int pwm_backlight_probe(struct pl
 	platform_set_drvdata(pdev, bl);
 	return 0;
 
-err_bl:
-	pwm_put(pb->pwm);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
@@ -276,7 +274,6 @@ static int pwm_backlight_remove(struct p
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
-	pwm_put(pb->pwm);
 	if (pb->exit)
 		pb->exit(&pdev->dev);
 	return 0;
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
proc-use-null-instead-of-0-for-pointer.patch

