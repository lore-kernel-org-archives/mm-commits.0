From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-da9055-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:34 -0700
Message-ID: <20130430185534.70D935A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54420 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3D3Szf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:35 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so86677yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-da9055: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-da9055-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-da9055: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9055.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-da9055.c~rtc-rtc-da9055-use-devm_rtc_device_register drivers/rtc/rtc-da9055.c
--- a/drivers/rtc/rtc-da9055.c~rtc-rtc-da9055-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-da9055.c
@@ -294,7 +294,7 @@ static int da9055_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&da9055_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -317,9 +317,6 @@ err_rtc:
 
 static int da9055_rtc_remove(struct platform_device *pdev)
 {
-	struct da9055_rtc *rtc = pdev->dev.platform_data;
