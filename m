From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1302-add-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:55 -0700
Message-ID: <20130430185355.6EFA25A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53087 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3D3Sx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:56 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86507ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1302: add __exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1302-add-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1302: add __exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-add-__exit-annotation drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-add-__exit-annotation
+++ a/drivers/rtc/rtc-ds1302.c
@@ -234,7 +234,7 @@ static int __init ds1302_rtc_probe(struc
 	return 0;
 }
 
-static int ds1302_rtc_remove(struct platform_device *pdev)
+static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -249,7 +249,7 @@ static struct platform_driver ds1302_pla
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
-	.remove		= ds1302_rtc_remove,
+	.remove		= __exit_p(ds1302_rtc_remove),
 };
 
 static int __init ds1302_rtc_init(void)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

