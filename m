From: akpm@linux-foundation.org
Subject: + rtc-rtc-sh-use-devm_-functions.patch added to -mm tree
Date: Tue, 28 May 2013 15:22:09 -0700
Message-ID: <51a52e11.WIL8FWFAyt0MAOJC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab3E1WWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-sh-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:22:09 -0700


The patch titled
     Subject: rtc: rtc-sh: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-sh-use-devm_-functions.patch

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
Subject: rtc: rtc-sh: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sh.c |   74 ++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 52 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-devm_-functions drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-devm_-functions
+++ a/drivers/rtc/rtc-sh.c
@@ -593,7 +593,7 @@ static int __init sh_rtc_probe(struct pl
 	char clk_name[6];
 	int clk_id, ret;
 
-	rtc = kzalloc(sizeof(struct sh_rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
 
@@ -602,9 +602,8 @@ static int __init sh_rtc_probe(struct pl
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
 	if (unlikely(ret <= 0)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->periodic_irq = ret;
@@ -613,24 +612,21 @@ static int __init sh_rtc_probe(struct pl
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (unlikely(res == NULL)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IO resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->regsize = resource_size(res);
 
-	rtc->res = request_mem_region(res->start, rtc->regsize, pdev->name);
-	if (unlikely(!rtc->res)) {
-		ret = -EBUSY;
-		goto err_badres;
-	}
-
-	rtc->regbase = ioremap_nocache(rtc->res->start, rtc->regsize);
-	if (unlikely(!rtc->regbase)) {
-		ret = -EINVAL;
-		goto err_badmap;
-	}
+	rtc->res = devm_request_mem_region(&pdev->dev, res->start,
+					rtc->regsize, pdev->name);
+	if (unlikely(!rtc->res))
+		return -EBUSY;
+
+	rtc->regbase = devm_ioremap_nocache(&pdev->dev, rtc->res->start,
+					rtc->regsize);
+	if (unlikely(!rtc->regbase))
+		return -EINVAL;
 
 	clk_id = pdev->id;
 	/* With a single device, the clock id is still "rtc0" */
@@ -639,7 +635,7 @@ static int __init sh_rtc_probe(struct pl
 
 	snprintf(clk_name, sizeof(clk_name), "rtc%d", clk_id);
 
-	rtc->clk = clk_get(&pdev->dev, clk_name);
+	rtc->clk = devm_clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(rtc->clk)) {
 		/*
 		 * No error handling for rtc->clk intentionally, not all
@@ -665,8 +661,8 @@ static int __init sh_rtc_probe(struct pl
 
 	if (rtc->carry_irq <= 0) {
 		/* register shared periodic/carry/alarm irq */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_shared,
-				  0, "sh-rtc", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_shared, 0, "sh-rtc", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request IRQ failed with %d, IRQ %d\n", ret,
@@ -675,8 +671,8 @@ static int __init sh_rtc_probe(struct pl
 		}
 	} else {
 		/* register periodic/carry/alarm irqs */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_periodic,
-				  0, "sh-rtc period", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_periodic, 0, "sh-rtc period", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request period IRQ failed with %d, IRQ %d\n",
@@ -684,24 +680,21 @@ static int __init sh_rtc_probe(struct pl
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->carry_irq, sh_rtc_interrupt,
-				  0, "sh-rtc carry", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->carry_irq,
+				sh_rtc_interrupt, 0, "sh-rtc carry", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request carry IRQ failed with %d, IRQ %d\n",
 				ret, rtc->carry_irq);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->alarm_irq, sh_rtc_alarm,
-				  0, "sh-rtc alarm", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->alarm_irq,
+				sh_rtc_alarm, 0, "sh-rtc alarm", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request alarm IRQ failed with %d, IRQ %d\n",
 				ret, rtc->alarm_irq);
-			free_irq(rtc->carry_irq, rtc);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 	}
@@ -714,13 +707,10 @@ static int __init sh_rtc_probe(struct pl
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	rtc->rtc_dev = rtc_device_register("sh", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "sh",
 					   &sh_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
-		free_irq(rtc->periodic_irq, rtc);
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
 		goto err_unmap;
 	}
 
@@ -737,12 +727,6 @@ static int __init sh_rtc_probe(struct pl
 
 err_unmap:
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
-	iounmap(rtc->regbase);
-err_badmap:
-	release_mem_region(rtc->res->start, rtc->regsize);
-err_badres:
-	kfree(rtc);
 
 	return ret;
 }
@@ -751,26 +735,12 @@ static int __exit sh_rtc_remove(struct p
 {
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(rtc->rtc_dev);
 	sh_rtc_irq_set_state(&pdev->dev, 0);
 
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	free_irq(rtc->periodic_irq, rtc);
-
-	if (rtc->carry_irq > 0) {
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
-	}
-
-	iounmap(rtc->regbase);
-	release_mem_region(rtc->res->start, rtc->regsize);
-
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
-
-	kfree(rtc);
 
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

