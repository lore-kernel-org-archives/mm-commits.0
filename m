From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:30 -0700
Message-ID: <20130430185830.72F785A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60606 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab3D3S6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:31 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86719yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps65910: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps65910: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-tps65910.c
@@ -320,9 +320,8 @@ static int tps65910_rtc_resume(struct de
 }
 #endif
 
-static const struct dev_pm_ops tps65910_rtc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps65910_rtc_suspend, tps65910_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(tps65910_rtc_pm_ops, tps65910_rtc_suspend,
+			tps65910_rtc_resume);
 
 static struct platform_driver tps65910_rtc_driver = {
 	.probe		= tps65910_rtc_probe,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

