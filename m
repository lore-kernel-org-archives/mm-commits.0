From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps65910-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:23 -0700
Message-ID: <20130430185623.809BC31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:48984 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3S4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:24 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77374veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps65910: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps65910-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps65910: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~rtc-rtc-tps65910-use-devm_rtc_device_register drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~rtc-rtc-tps65910-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tps65910.c
@@ -276,7 +276,7 @@ static int tps65910_rtc_probe(struct pla
 	tps_rtc->irq = irq;
 	device_set_wakeup_capable(&pdev->dev, 1);
 
-	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	tps_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 		&tps65910_rtc_ops, THIS_MODULE);
 	if (IS_ERR(tps_rtc->rtc)) {
 		ret = PTR_ERR(tps_rtc->rtc);
@@ -295,12 +295,8 @@ static int tps65910_rtc_probe(struct pla
  */
 static int tps65910_rtc_remove(struct platform_device *pdev)
 {
-	/* leave rtc running, but disable irqs */
-	struct tps65910_rtc *tps_rtc = platform_get_drvdata(pdev);
