From: akpm@linux-foundation.org
Subject: [merged]
 backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:40:58 -0800
Message-ID: <5283e3da.MFV0eIZYPh2xdx/9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3KMUlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:58 -0800


The patch titled
     Subject: backlight: atmel-pwm-bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: atmel-pwm-bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-devm_backlight_device_register drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -171,8 +171,9 @@ static int atmel_pwm_bl_probe(struct pla
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
-	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
-					  &atmel_pwm_bl_ops, &props);
+	bldev = devm_backlight_device_register(&pdev->dev, "atmel-pwm-bl",
+					&pdev->dev, pwmbl, &atmel_pwm_bl_ops,
+					&props);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
 		goto err_free_pwm;
@@ -188,14 +189,12 @@ static int atmel_pwm_bl_probe(struct pla
 
 	retval = atmel_pwm_bl_init_pwm(pwmbl);
 	if (retval)
-		goto err_free_bl_dev;
+		goto err_free_pwm;
 
 	atmel_pwm_bl_set_intensity(bldev);
 
 	return 0;
 
-err_free_bl_dev:
-	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
@@ -210,7 +209,6 @@ static int atmel_pwm_bl_remove(struct pl
 		gpio_set_value(pwmbl->gpio_on, 0);
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
-	backlight_device_unregister(pwmbl->bldev);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

