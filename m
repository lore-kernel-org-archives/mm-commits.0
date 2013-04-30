From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh90133-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:29 -0700
Message-ID: <20130430185529.71E7931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41809 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219Ab3D3Sza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:30 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86783qea.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-coh90133: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh90133-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh90133: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh90133-use-devm_rtc_device_register drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh90133-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-coh901331.c
@@ -155,7 +155,6 @@ static int __exit coh901331_remove(struc
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
 	if (rtap) {
-		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
@@ -211,8 +210,8 @@ static int __init coh901331_probe(struct
 	clk_disable(rtap->clk);
 
 	platform_set_drvdata(pdev, rtap);
-	rtap->rtc = rtc_device_register("coh901331", &pdev->dev, &coh901331_ops,
-					 THIS_MODULE);
+	rtap->rtc = devm_rtc_device_register(&pdev->dev, "coh901331",
+					&coh901331_ops, THIS_MODULE);
 	if (IS_ERR(rtap->rtc)) {
 		ret = PTR_ERR(rtap->rtc);
 		goto out_no_rtc;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

