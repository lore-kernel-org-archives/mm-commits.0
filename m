From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-use-devm_kzalloc.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:16 -0700
Message-ID: <20130430185416.6E63C31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:50056 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab3D3SyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:17 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77168veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: use devm_kzalloc()

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-devm_kzalloc drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-devm_kzalloc
+++ a/drivers/rtc/rtc-max77686.c
@@ -505,7 +505,8 @@ static int max77686_rtc_probe(struct pla
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
-	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max77686_rtc_info),
+				GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -519,7 +520,6 @@ static int max77686_rtc_probe(struct pla
 		ret = PTR_ERR(info->max77686->rtc_regmap);
 		dev_err(info->max77686->dev, "Failed to allocate register map: %d\n",
 				ret);
-		kfree(info);
 		return ret;
 	}
 	platform_set_drvdata(pdev, info);
@@ -563,11 +563,7 @@ static int max77686_rtc_probe(struct pla
 		goto err_rtc;
 	}
 
-	goto out;
 err_rtc:
-	kfree(info);
-	return ret;
-out:
 	return ret;
 }
 
@@ -578,7 +574,6 @@ static int max77686_rtc_remove(struct pl
 	if (info) {
 		free_irq(info->virq, info);
 		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

