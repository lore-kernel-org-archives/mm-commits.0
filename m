From: akpm@linux-foundation.org
Subject: + rtc-rtc-pm8xxx-use-devm_-functions.patch added to -mm tree
Date: Tue, 28 May 2013 15:22:06 -0700
Message-ID: <51a52e0e.IxiJl4UGPrzqgV48%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab3E1WWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-pm8xxx-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:22:06 -0700


The patch titled
     Subject: rtc: rtc-pm8xxx: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-pm8xxx-use-devm_-functions.patch

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
Subject: rtc: rtc-pm8xxx: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-use-devm_-functions drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-rtc-pm8xxx-use-devm_-functions
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -395,7 +395,7 @@ static int pm8xxx_rtc_probe(struct platf
 	if (pdata != NULL)
 		rtc_write_enable = pdata->rtc_write_enable;
 
-	rtc_dd = kzalloc(sizeof(*rtc_dd), GFP_KERNEL);
+	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate memory!\n");
 		return -ENOMEM;
@@ -407,16 +407,14 @@ static int pm8xxx_rtc_probe(struct platf
 	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
 							"pmic_rtc_base");
 	if (!(rtc_resource && rtc_resource->start)) {
 		dev_err(&pdev->dev, "RTC IO resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_dd->rtc_base = rtc_resource->start;
@@ -432,7 +430,7 @@ static int pm8xxx_rtc_probe(struct platf
 	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
-		goto fail_rtc_enable;
+		return rc;
 	}
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
@@ -442,7 +440,7 @@ static int pm8xxx_rtc_probe(struct platf
 		if (rc < 0) {
 			dev_err(&pdev->dev, "Write to RTC control register "
 								"failed\n");
-			goto fail_rtc_enable;
+			return rc;
 		}
 	}
 
@@ -453,13 +451,12 @@ static int pm8xxx_rtc_probe(struct platf
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
-	rtc_dd->rtc = rtc_device_register("pm8xxx_rtc", &pdev->dev,
+	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 				&pm8xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_dd->rtc)) {
 		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
 					__func__, PTR_ERR(rtc_dd->rtc));
-		rc = PTR_ERR(rtc_dd->rtc);
-		goto fail_rtc_enable;
+		return PTR_ERR(rtc_dd->rtc);
 	}
 
 	/* Request the alarm IRQ */
@@ -468,7 +465,7 @@ static int pm8xxx_rtc_probe(struct platf
 				 "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
-		goto fail_req_irq;
+		return rc;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -476,12 +473,6 @@ static int pm8xxx_rtc_probe(struct platf
 	dev_dbg(&pdev->dev, "Probe success !!\n");
 
 	return 0;
-
-fail_req_irq:
-	rtc_device_unregister(rtc_dd->rtc);
-fail_rtc_enable:
-	kfree(rtc_dd);
-	return rc;
 }
 
 static int pm8xxx_rtc_remove(struct platform_device *pdev)
@@ -490,8 +481,6 @@ static int pm8xxx_rtc_remove(struct plat
 
 	device_init_wakeup(&pdev->dev, 0);
 	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
-	rtc_device_unregister(rtc_dd->rtc);
-	kfree(rtc_dd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
backlight-add-devm_backlight_device_registerunregister.patch
lcd-add-devm_lcd_device_registerunregister.patch
maintainers-add-backlight-subsystem-co-maintainer.patch
rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
rtc-rtc-88pm860x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at32ap700x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91rm9200-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91sam9-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-au1xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bfin-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bq4802-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-coh901331-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9052-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9055-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-davinci-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-dm355evm-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ep93xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-jz4740-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lp8788-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lpc32xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ls1x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t59-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8925-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8998-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-msm6242-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mxc-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-nuc900-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pcap-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pm8xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sa1100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sh-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-spear-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-stmp3xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-twl-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vr41xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vt8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t86-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-puv3-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-rp5c01-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-tile-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch
rtc-rtc-ds1307-use-devm_-functions.patch
rtc-rtc-jz4740-use-devm_-functions.patch
rtc-rtc-mpc5121-use-devm_-functions.patch
rtc-rtc-m48t59-use-devm_-functions.patch
rtc-rtc-pm8xxx-use-devm_-functions.patch
rtc-rtc-pxa-use-devm_-functions.patch
rtc-rtc-rx8025-use-devm_-functions.patch
rtc-rtc-sh-use-devm_-functions.patch

