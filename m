From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-snvs-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:12 -0700
Message-ID: <20130430185612.6F3C75A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51526 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3D3S4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:14 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86689ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-snvs: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-snvs-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-snvs: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-snvs.c~rtc-rtc-snvs-use-devm_rtc_device_register drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~rtc-rtc-snvs-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-snvs.c
@@ -283,7 +283,7 @@ static int snvs_rtc_probe(struct platfor
 		return ret;
 	}
 
-	data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&snvs_rtc_ops, THIS_MODULE);
 	if (IS_ERR(data->rtc)) {
 		ret = PTR_ERR(data->rtc);
@@ -296,10 +296,6 @@ static int snvs_rtc_probe(struct platfor
 
 static int snvs_rtc_remove(struct platform_device *pdev)
 {
-	struct snvs_rtc_data *data = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(data->rtc);
