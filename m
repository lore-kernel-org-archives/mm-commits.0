From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max77686-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:54 -0700
Message-ID: <20130430185554.6F38631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35226 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab3D3Szz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:55 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so86711yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max77686: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max77686-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max77686: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler. Also, this patch uses devm_request_threaded_irq().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-rtc-max77686-use-devm_rtc_device_register drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-rtc-max77686-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-max77686.c
@@ -538,8 +538,8 @@ static int max77686_rtc_probe(struct pla
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max77686-rtc", &pdev->dev,
-			&max77686_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max77686-rtc",
+					&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		dev_info(&pdev->dev, "%s: fail\n", __func__);
@@ -555,8 +555,8 @@ static int max77686_rtc_probe(struct pla
 		goto err_rtc;
 	info->virq = virq;
 
-	ret = request_threaded_irq(virq, NULL, max77686_rtc_alarm_irq, 0,
-			"rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
+				max77686_rtc_alarm_irq, 0, "rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
@@ -569,13 +569,6 @@ err_rtc:
 
 static int max77686_rtc_remove(struct platform_device *pdev)
 {
-	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info) {
-		free_irq(info->virq, info);
-		rtc_device_unregister(info->rtc_dev);
-	}
