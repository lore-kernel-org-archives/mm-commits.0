From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-nuc900-add-__init-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:00 -0700
Message-ID: <20130430185400.700B631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:56794 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab3D3SyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:01 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86586qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-nuc900: add __init/__exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-nuc900-add-__init-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-nuc900: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-add-__init-__exit-annotation drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-nuc900.c
@@ -222,7 +222,7 @@ static struct rtc_class_ops nuc900_rtc_o
 	.alarm_irq_enable = nuc900_alarm_irq_enable,
 };
 
-static int nuc900_rtc_probe(struct platform_device *pdev)
+static int __init nuc900_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct nuc900_rtc *nuc900_rtc;
@@ -284,7 +284,7 @@ fail1:	kfree(nuc900_rtc);
 	return err;
 }
 
-static int nuc900_rtc_remove(struct platform_device *pdev)
+static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
 	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -304,7 +304,7 @@ static int nuc900_rtc_remove(struct plat
 }
 
 static struct platform_driver nuc900_rtc_driver = {
-	.remove		= nuc900_rtc_remove,
+	.remove		= __exit_p(nuc900_rtc_remove),
 	.driver		= {
 		.name	= "nuc900-rtc",
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

