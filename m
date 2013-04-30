From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mv-add-__init-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:50 -0700
Message-ID: <20130430185350.6F4DF5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52167 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:51 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86301yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mv: add __init annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mv-add-__init-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mv: add __init annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mv.c~rtc-rtc-mv-add-__init-annotation drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-rtc-mv-add-__init-annotation
+++ a/drivers/rtc/rtc-mv.c
@@ -217,7 +217,7 @@ static const struct rtc_class_ops mv_rtc
 	.alarm_irq_enable = mv_rtc_alarm_irq_enable,
 };
 
-static int mv_rtc_probe(struct platform_device *pdev)
+static int __init mv_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct rtc_plat_data *pdata;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

