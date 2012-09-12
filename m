From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-pwm_blc-use-devm_pwm_get.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:08:01 -0700
Message-ID: <20120912210802.186A55C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59656 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2ILVIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:08:04 -0400
Received: by weyr1 with SMTP id r1so146887wey.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:08:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/video/backlight/pwm_bl.c: use devm_pwm_get()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-pwm_blc-use-devm_pwm_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-pwm_blc-use-devm_pwm_get.patch
proc-use-null-instead-of-0-for-pointer.patch

