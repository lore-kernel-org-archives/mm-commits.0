From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rc5t583-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:44 -0700
Message-ID: <20130430185744.709D95A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38561 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab3D3S5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:45 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87078vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rc5t583: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rc5t583-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rc5t583: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rc5t583.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-use-devm_rtc_device_register drivers/rtc/rtc-rc5t583.c
--- a/drivers/rtc/rtc-rc5t583.c~rtc-rtc-rc5t583-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-rc5t583.c
@@ -256,7 +256,7 @@ static int rc5t583_rtc_probe(struct plat
 	}
 	device_init_wakeup(&pdev->dev, 1);
 
-	ricoh_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	ricoh_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 		&rc5t583_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ricoh_rtc->rtc)) {
 		ret = PTR_ERR(ricoh_rtc->rtc);
@@ -276,8 +276,6 @@ static int rc5t583_rtc_remove(struct pla
 	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(&pdev->dev);
 
 	rc5t583_rtc_alarm_irq_enable(&rc5t583_rtc->rtc->dev, 0);
