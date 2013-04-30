From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-imxdi-add-__init-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:57 -0700
Message-ID: <20130430185357.6F35C31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:50967 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3D3Sx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:58 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86599qea.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-imxdi: add __init/__exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-imxdi-add-__init-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-imxdi: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-add-__init-__exit-annotation drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-imxdi.c
@@ -369,7 +369,7 @@ static void dryice_work(struct work_stru
 /*
  * probe for dryice rtc device
  */
-static int dryice_rtc_probe(struct platform_device *pdev)
+static int __init dryice_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct imxdi_dev *imxdi;
@@ -479,7 +479,7 @@ err:
 	return rc;
 }
 
-static int dryice_rtc_remove(struct platform_device *pdev)
+static int __exit dryice_rtc_remove(struct platform_device *pdev)
 {
 	struct imxdi_dev *imxdi = platform_get_drvdata(pdev);
 
@@ -510,7 +510,7 @@ static struct platform_driver dryice_rtc
 		   .owner = THIS_MODULE,
 		   .of_match_table = of_match_ptr(dryice_dt_ids),
 		   },
-	.remove = dryice_rtc_remove,
+	.remove = __exit_p(dryice_rtc_remove),
 };
 
 static int __init dryice_rtc_init(void)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

