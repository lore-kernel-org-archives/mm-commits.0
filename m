From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-lpc32xx-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:52 -0700
Message-ID: <20130430185552.6F5735A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:49516 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab3D3Szx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:53 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86758qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-lpc32xx: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-lpc32xx-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-lpc32xx: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lpc32xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-lpc32xx.c~rtc-rtc-lpc32xx-use-devm_rtc_device_register drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~rtc-rtc-lpc32xx-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -273,8 +273,8 @@ static int lpc32xx_rtc_probe(struct plat
 
 	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
-		THIS_MODULE);
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, RTC_NAME,
+					&lpc32xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_err(&pdev->dev, "Can't get RTC\n");
 		platform_set_drvdata(pdev, NULL);
@@ -307,7 +307,6 @@ static int lpc32xx_rtc_remove(struct pla
 		device_init_wakeup(&pdev->dev, 0);
 
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc->rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

