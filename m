From: akpm@linux-foundation.org
Subject: + rtc-rtc-coh901331-use-devm_clk_get.patch added to -mm tree
Date: Thu, 21 Feb 2013 13:51:29 -0800
Message-ID: <20130221215130.2DC7F5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39452 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3BUVvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 16:51:31 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so1467ves.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 13:51:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-coh901331: use devm_clk_get()
has been added to the -mm tree.  Its filename is
     rtc-rtc-coh901331-use-devm_clk_get.patch

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
Subject: rtc: rtc-coh901331: use devm_clk_get()

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_clk_get drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_clk_get
+++ a/drivers/rtc/rtc-coh901331.c
@@ -157,7 +157,6 @@ static int __exit coh901331_remove(struc
 	if (rtap) {
 		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
-		clk_put(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
 
@@ -196,7 +195,7 @@ static int __init coh901331_probe(struct
 			     "RTC COH 901 331 Alarm", rtap))
 		return -EIO;
 
-	rtap->clk = clk_get(&pdev->dev, NULL);
+	rtap->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtap->clk)) {
 		ret = PTR_ERR(rtap->clk);
 		dev_err(&pdev->dev, "could not get clock\n");
@@ -207,7 +206,7 @@ static int __init coh901331_probe(struct
 	ret = clk_prepare_enable(rtap->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "could not enable clock\n");
-		goto out_no_clk_prepenable;
+		return ret;
 	}
 	clk_disable(rtap->clk);
 
@@ -224,8 +223,6 @@ static int __init coh901331_probe(struct
  out_no_rtc:
 	platform_set_drvdata(pdev, NULL);
 	clk_unprepare(rtap->clk);
- out_no_clk_prepenable:
-	clk_put(rtap->clk);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
video-s3c-fb-use-arch_-dependancy.patch
video-s3c-fb-remove-duplicated-s3c_fb_max_win.patch
video-s3c-fb-remove-unnecessary-brackets.patch
video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601.patch
video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch
video-exynos_dp-add-missing-of_node_put.patch
video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch
backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata.patch
pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch
backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch
drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch
drivers-video-backlight-makefile-cleanup.patch
backlight-add-an-as3711-pmic-backlight-driver.patch
backlight-88pm860x_bl-add-missing-of_node_put.patch
backlight-s6e63m0-report-gamma_table_count-correctly.patch
drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register.patch
backlight-lp855x_bl-introduce-device-configuration-flow.patch
backlight-lp855x_bl-support-new-lp8557-device.patch
backlight-lp855x_bl-simplify-bl_get_brightness.patch
rtc-max77686-add-missing-variable-initialization.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch
rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk.patch
rtc-max77686-use-dev_info-instead-of-printk.patch
rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk.patch
rtc-rtc-ds2404-use-dev_err-instead-of-printk.patch
rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug.patch
rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch
rtc-rtc-rs5c313-use-pr_err-instead-of-printk.patch
rtc-rtc-vr41xx-use-dev_info-instead-of-printk.patch
rtc-rtc-sun4v-use-pr_warn-instead-of-printk.patch
rtc-rtc-pcf8583-use-dev_warn-instead-of-printk.patch
rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug.patch
rtc-rtc-imxdi-use-devm_clk_get.patch
rtc-rtc-tps6586x-use-devm_request_threaded_irq.patch
rtc-rtc-vt8500-use-devm_-functions.patch
rtc-rtc-coh901331-use-devm_clk_get.patch
rtc-rtc-lp8788-use-devm_request_threaded_irq.patch
rtc-rtc-tps80031-use-devm_request_threaded_irq.patch
rtc-rtc-wm831x-use-devm_request_threaded_irq.patch
rtc-rtc-da9052-use-devm_request_threaded_irq.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch
rtc-rtc-max8907-use-devm_request_threaded_irq.patch
rtc-rtc-max8997-use-devm_request_threaded_irq.patch
rtc-rtc-davinci-use-devm_-functions.patch

