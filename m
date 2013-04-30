From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-vt8500-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:30 -0700
Message-ID: <20130430185630.6FA145A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:42900 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab3D3S4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:31 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86910yen.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-vt8500: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-vt8500-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-vt8500: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_rtc_device_register drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-vt8500.c
@@ -252,7 +252,7 @@ static int vt8500_rtc_probe(struct platf
 	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
-	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
+	vt8500_rtc->rtc = devm_rtc_device_register(&pdev->dev, "vt8500-rtc",
 					      &vt8500_rtc_ops, THIS_MODULE);
 	if (IS_ERR(vt8500_rtc->rtc)) {
 		ret = PTR_ERR(vt8500_rtc->rtc);
@@ -266,13 +266,11 @@ static int vt8500_rtc_probe(struct platf
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
-		goto err_unreg;
+		goto err_return;
 	}
 
 	return 0;
 
-err_unreg:
-	rtc_device_unregister(vt8500_rtc->rtc);
 err_return:
 	return ret;
 }
@@ -281,8 +279,6 @@ static int vt8500_rtc_remove(struct plat
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(vt8500_rtc->rtc);
