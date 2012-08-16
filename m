From: akpm@linux-foundation.org
Subject: [nacked] backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch removed from -mm tree
Date: Thu, 16 Aug 2012 11:31:53 -0700
Message-ID: <20120816183154.3FE9320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34913 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2HPSb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:31:56 -0400
Received: by eaac1 with SMTP id c1so147464eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:31:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: remove goto err_free_mem
has been removed from the -mm tree.  Its filename was
     backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/atmel-pwm-bl.c: remove goto err_free_mem

Remove goto err_free_mem, which makes code a bit smaller.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-goto-err_free_mem drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-goto-err_free_mem
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -135,24 +135,20 @@ static int atmel_pwm_bl_probe(struct pla
 	pwmbl->pdev = pdev;
 
 	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		retval = -ENODEV;
-		goto err_free_mem;
-	}
+	if (!pdata)
+		return -ENODEV;
 
 	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
 			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0) {
-		retval = -EINVAL;
-		goto err_free_mem;
-	}
+			pdata->pwm_frequency == 0)
+		return -EINVAL;
 
 	pwmbl->pdata = pdata;
 	pwmbl->gpio_on = pdata->gpio_on;
 
 	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
 	if (retval)
-		goto err_free_mem;
+		return retval;
 
 	if (pwmbl->gpio_on != -1) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
@@ -200,7 +196,6 @@ err_free_bl_dev:
 	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
-err_free_mem:
 	return retval;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

