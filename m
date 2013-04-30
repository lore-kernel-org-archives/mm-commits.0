From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-bfin-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:58 -0700
Message-ID: <20130430185958.6F96031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47614 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3D3S77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:59 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88589qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-bfin: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-bfin-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-bfin: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-rtc-bfin-use-devm_-functions drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-rtc-bfin-use-devm_-functions
+++ a/drivers/rtc/rtc-bfin.c
@@ -352,14 +352,14 @@ static int bfin_rtc_probe(struct platfor
 	dev_dbg_stamp(dev);
 
 	/* Allocate memory for our RTC struct */
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
 	platform_set_drvdata(pdev, rtc);
 	device_init_wakeup(dev, 1);
 
 	/* Register our RTC with the RTC framework */
-	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops,
+	rtc->rtc_dev = devm_rtc_device_register(dev, pdev->name, &bfin_rtc_ops,
 						THIS_MODULE);
 	if (unlikely(IS_ERR(rtc->rtc_dev))) {
 		ret = PTR_ERR(rtc->rtc_dev);
@@ -367,9 +367,10 @@ static int bfin_rtc_probe(struct platfor
 	}
 
 	/* Grab the IRQ and init the hardware */
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, 0, pdev->name, dev);
+	ret = devm_request_irq(dev, IRQ_RTC, bfin_rtc_interrupt, 0,
+				pdev->name, dev);
 	if (unlikely(ret))
-		goto err_reg;
+		goto err;
 	/* sometimes the bootloader touched things, but the write complete was not
 	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
 	 */
@@ -381,23 +382,16 @@ static int bfin_rtc_probe(struct platfor
 
 	return 0;
 
-err_reg:
-	rtc_device_unregister(rtc->rtc_dev);
 err:
-	kfree(rtc);
 	return ret;
 }
 
 static int bfin_rtc_remove(struct platform_device *pdev)
 {
-	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
 
 	bfin_rtc_reset(dev, 0);
-	free_irq(IRQ_RTC, dev);
-	rtc_device_unregister(rtc->rtc_dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

