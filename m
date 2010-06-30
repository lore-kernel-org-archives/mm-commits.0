From: akpm@linux-foundation.org
Subject: + rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:40:52 -0700
Message-ID: <201006301940.o5UJeq9f022483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0F3Tlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it


The patch titled
     rtc/nuc900:  modify enable/disable IRQs and driver data setting location
has been added to the -mm tree.  Its filename is
     rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc/nuc900:  modify enable/disable IRQs and driver data setting location
From: Wan ZongShun <mcuos.com@gmail.com>

This patch does two modifications:

(1) Adjust enable/disable IRQs location,enable it after rtc
    registration and disable it prior to unregistration.

(2) Put 'platform_set_drvdata(pdev, nuc900_rtc)' in front of rtc
    registration still be safety, though there is no need to do this, when
    I move enable irq after rtc registration, I think still put
    'platform_set_drvdata' before rtc registration that would be a good
    habit.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location
+++ a/drivers/rtc/rtc-nuc900.c
@@ -269,29 +269,30 @@ static int __devinit nuc900_rtc_probe(st
 		goto fail2;
 	}
 
-	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
-	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
-				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
-		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
-		err = -EBUSY;
-		goto fail3;
-	}
+	platform_set_drvdata(pdev, nuc900_rtc);
 
 	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
 		dev_err(&pdev->dev, "rtc device register faild\n");
 		err = PTR_ERR(nuc900_rtc->rtcdev);
-		goto fail4;
+		goto fail3;
 	}
 
-	platform_set_drvdata(pdev, nuc900_rtc);
 	__raw_writel(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_TSSR) | MODE24,
 					nuc900_rtc->rtc_reg + REG_RTC_TSSR);
 
+	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
+	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
+				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
+		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
+		err = -EBUSY;
+		goto fail4;
+	}
+
 	return 0;
 
-fail4:	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+fail4:	rtc_device_unregister(nuc900_rtc->rtcdev);
 fail3:	iounmap(nuc900_rtc->rtc_reg);
 fail2:	release_mem_region(res->start, resource_size(res));
 fail1:	kfree(nuc900_rtc);
@@ -303,8 +304,8 @@ static int __devexit nuc900_rtc_remove(s
 	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	rtc_device_unregister(nuc900_rtc->rtcdev);
 	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+	rtc_device_unregister(nuc900_rtc->rtcdev);
 	iounmap(nuc900_rtc->rtc_reg);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

rtc-fix-ds1388-time-corruption.patch
drivers-video-nuc900fbc-fix-lcd-build-error.patch
linux-next.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch
rtc-add-intersil-isl12022-rtc-driver.patch
rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch
rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-m48t86-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-nuc900-make-returning-time-checking-function-valid.patch
rtc-nuc900-modify-enable-disable-irqs-and-driver-data-setting-location.patch
rtc-nuc900-fix-build-warning.patch

