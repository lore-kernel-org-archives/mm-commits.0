From: akpm@linux-foundation.org
Subject: + rtc-rtc-vt8500-use-devm_-functions.patch added to -mm tree
Date: Thu, 21 Feb 2013 13:51:27 -0800
Message-ID: <20130221215128.12FBE31C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63197 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3BUVv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 16:51:29 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so1436vbi.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 13:51:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-vt8500: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-vt8500-use-devm_-functions.patch

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
Subject: rtc: rtc-vt8500: use devm_*() functions

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_-functions drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_-functions
+++ a/drivers/rtc/rtc-vt8500.c
@@ -231,20 +231,21 @@ static int vt8500_rtc_probe(struct platf
 		return -ENXIO;
 	}
 
-	vt8500_rtc->res = request_mem_region(vt8500_rtc->res->start,
-					     resource_size(vt8500_rtc->res),
-					     "vt8500-rtc");
+	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
+					vt8500_rtc->res->start,
+					resource_size(vt8500_rtc->res),
+					"vt8500-rtc");
 	if (vt8500_rtc->res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
 		return -EBUSY;
 	}
 
-	vt8500_rtc->regbase = ioremap(vt8500_rtc->res->start,
+	vt8500_rtc->regbase = devm_ioremap(&pdev->dev, vt8500_rtc->res->start,
 				      resource_size(vt8500_rtc->res));
 	if (!vt8500_rtc->regbase) {
 		dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
 		ret = -EBUSY;
-		goto err_release;
+		goto err_return;
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
@@ -257,11 +258,11 @@ static int vt8500_rtc_probe(struct platf
 		ret = PTR_ERR(vt8500_rtc->rtc);
 		dev_err(&pdev->dev,
 			"Failed to register RTC device -> %d\n", ret);
-		goto err_unmap;
+		goto err_return;
 	}
 
-	ret = request_irq(vt8500_rtc->irq_alarm, vt8500_rtc_irq, 0,
-			  "rtc alarm", vt8500_rtc);
+	ret = devm_request_irq(&pdev->dev, vt8500_rtc->irq_alarm,
+				vt8500_rtc_irq, 0, "rtc alarm", vt8500_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
@@ -272,11 +273,7 @@ static int vt8500_rtc_probe(struct platf
 
 err_unreg:
 	rtc_device_unregister(vt8500_rtc->rtc);
-err_unmap:
-	iounmap(vt8500_rtc->regbase);
-err_release:
-	release_mem_region(vt8500_rtc->res->start,
-			   resource_size(vt8500_rtc->res));
+err_return:
 	return ret;
 }
 
@@ -284,15 +281,10 @@ static int vt8500_rtc_remove(struct plat
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	free_irq(vt8500_rtc->irq_alarm, vt8500_rtc);
-
 	rtc_device_unregister(vt8500_rtc->rtc);
 
 	/* Disable alarm matching */
 	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
-	iounmap(vt8500_rtc->regbase);
-	release_mem_region(vt8500_rtc->res->start,
-			   resource_size(vt8500_rtc->res));
 
 	platform_set_drvdata(pdev, NULL);
 
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

