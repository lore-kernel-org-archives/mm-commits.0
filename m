From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:10 -0700
Message-ID: <20130430185810.729BB5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:44568 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab3D3S6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:11 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so87086yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-at91rm9200: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at91rm9200: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -337,7 +337,7 @@ static int __exit at91_rtc_remove(struct
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 /* AT91RM9200 RTC Power management control */
 
@@ -369,24 +369,16 @@ static int at91_rtc_resume(struct device
 	}
 	return 0;
 }
-
-static const struct dev_pm_ops at91_rtc_pm = {
-	.suspend =	at91_rtc_suspend,
-	.resume =	at91_rtc_resume,
-};
-
-#define at91_rtc_pm_ptr	&at91_rtc_pm
-
-#else
-#define at91_rtc_pm_ptr	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
+
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
-		.pm	= at91_rtc_pm_ptr,
+		.pm	= &at91_rtc_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

