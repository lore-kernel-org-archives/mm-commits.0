From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-dm355evm-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:07 -0700
Message-ID: <20130430185707.7060A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52938 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab3D3S5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:08 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77422ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-dm355evm: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-dm355evm-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-dm355evm: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dm355evm.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-dm355evm.c~rtc-rtc-dm355evm-use-devm_rtc_device_register drivers/rtc/rtc-dm355evm.c
--- a/drivers/rtc/rtc-dm355evm.c~rtc-rtc-dm355evm-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-dm355evm.c
@@ -127,8 +127,8 @@ static int dm355evm_rtc_probe(struct pla
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &dm355evm_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&dm355evm_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 			PTR_ERR(rtc));
@@ -141,9 +141,6 @@ static int dm355evm_rtc_probe(struct pla
 
 static int dm355evm_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
