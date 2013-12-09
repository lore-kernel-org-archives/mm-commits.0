From: akpm@linux-foundation.org
Subject: + rtc-rtc-vr41xx-use-devm_-functions.patch added to -mm tree
Date: Mon, 09 Dec 2013 15:17:47 -0800
Message-ID: <52a64f9b.ofJXFvRXuHzNKOep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LIXRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 18:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuasa@linux-mips.org, grygorii.strashko@ti.com, jg1.han@samsung.com

Subject: + rtc-rtc-vr41xx-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com,grygorii.strashko@ti.com,yuasa@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 15:17:47 -0800


The patch titled
     Subject: drivers/rtc/rtc-vr41xx.c: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-vr41xx-use-devm_-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-vr41xx-use-devm_-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-vr41xx-use-devm_-functions.patch

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
Subject: drivers/rtc/rtc-vr41xx.c: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |   50 ++++++++-----------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-devm_-functions drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-devm_-functions
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -293,7 +293,7 @@ static int rtc_probe(struct platform_dev
 	if (!res)
 		return -EBUSY;
 
-	rtc1_base = ioremap(res->start, resource_size(res));
+	rtc1_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc1_base)
 		return -EBUSY;
 
@@ -303,13 +303,14 @@ static int rtc_probe(struct platform_dev
 		goto err_rtc1_iounmap;
 	}
 
-	rtc2_base = ioremap(res->start, resource_size(res));
+	rtc2_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc2_base) {
 		retval = -EBUSY;
 		goto err_rtc1_iounmap;
 	}
 
-	rtc = rtc_device_register(rtc_name, &pdev->dev, &vr41xx_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, rtc_name, &vr41xx_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		retval = PTR_ERR(rtc);
 		goto err_iounmap_all;
@@ -330,24 +331,24 @@ static int rtc_probe(struct platform_dev
 	aie_irq = platform_get_irq(pdev, 0);
 	if (aie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_device_unregister;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
-			     "elapsed_time", pdev);
+	retval = devm_request_irq(&pdev->dev, aie_irq, elapsedtime_interrupt, 0,
+				"elapsed_time", pdev);
 	if (retval < 0)
-		goto err_device_unregister;
+		goto err_iounmap_all;
 
 	pie_irq = platform_get_irq(pdev, 1);
 	if (pie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_free_irq;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
-			     "rtclong1", pdev);
+	retval = devm_request_irq(&pdev->dev, pie_irq, rtclong1_interrupt, 0,
+				"rtclong1", pdev);
 	if (retval < 0)
-		goto err_free_irq;
+		goto err_iounmap_all;
 
 	platform_set_drvdata(pdev, rtc);
 
@@ -358,47 +359,20 @@ static int rtc_probe(struct platform_dev
 
 	return 0;
 
-err_free_irq:
-	free_irq(aie_irq, pdev);
-
-err_device_unregister:
-	rtc_device_unregister(rtc);
-
 err_iounmap_all:
-	iounmap(rtc2_base);
 	rtc2_base = NULL;
 
 err_rtc1_iounmap:
-	iounmap(rtc1_base);
 	rtc1_base = NULL;
 
 	return retval;
 }
 
-static int rtc_remove(struct platform_device *pdev)
-{
-	struct rtc_device *rtc;
-
-	rtc = platform_get_drvdata(pdev);
-	if (rtc)
-		rtc_device_unregister(rtc);
-
-	free_irq(aie_irq, pdev);
-	free_irq(pie_irq, pdev);
-	if (rtc1_base)
-		iounmap(rtc1_base);
-	if (rtc2_base)
-		iounmap(rtc2_base);
-
-	return 0;
-}
-
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:RTC");
 
 static struct platform_driver rtc_platform_driver = {
 	.probe		= rtc_probe,
-	.remove		= rtc_remove,
 	.driver		= {
 		.name	= rtc_name,
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
backlight-jornada720-use-devm_backlight_device_register.patch
backlight-hp680_bl-use-devm_backlight_device_register.patch
backlight-omap1-use-devm_backlight_device_register.patch
backlight-ot200_bl-use-devm_backlight_device_register.patch
backlight-tosa-use-devm_backlight_device_register.patch
backlight-jornada720-use-devm_lcd_device_register.patch
backlight-l4f00242t03-use-devm_lcd_device_register.patch
backlight-tosa-use-devm_lcd_device_register.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

