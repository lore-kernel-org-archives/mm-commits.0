From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-da9052-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:32 -0700
Message-ID: <20130430185532.6BA5331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:48840 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab3D3Szd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:33 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77297veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-da9052: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-da9052-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-da9052: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-use-devm_rtc_device_register drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-da9052.c
@@ -247,7 +247,7 @@ static int da9052_rtc_probe(struct platf
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				       &da9052_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc))
 		return PTR_ERR(rtc->rtc);
@@ -257,9 +257,6 @@ static int da9052_rtc_probe(struct platf
 
 static int da9052_rtc_remove(struct platform_device *pdev)
 {
-	struct da9052_rtc *rtc = pdev->dev.platform_data;
