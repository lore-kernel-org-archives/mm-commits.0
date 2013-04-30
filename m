From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps80031-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:26 -0700
Message-ID: <20130430185626.660C131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63150 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab3D3S41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:27 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87039vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps80031: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps80031-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps80031: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-use-devm_rtc_device_register drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tps80031.c
@@ -277,7 +277,7 @@ static int tps80031_rtc_probe(struct pla
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			       &tps80031_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -292,7 +292,6 @@ static int tps80031_rtc_probe(struct pla
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request IRQ:%d failed, err = %d\n",
 			 rtc->irq, ret);
-		rtc_device_unregister(rtc->rtc);
 		return ret;
 	}
 	device_set_wakeup_capable(&pdev->dev, 1);
@@ -301,9 +300,6 @@ static int tps80031_rtc_probe(struct pla
 
 static int tps80031_rtc_remove(struct platform_device *pdev)
 {
-	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
