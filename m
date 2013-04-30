From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:32 -0700
Message-ID: <20130430185832.7157E5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:40439 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab3D3S6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:33 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77563veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps80031: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps80031: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-tps80031.c
@@ -323,9 +323,8 @@ static int tps80031_rtc_resume(struct de
 };
 #endif
 
-static const struct dev_pm_ops tps80031_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps80031_rtc_suspend, tps80031_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(tps80031_pm_ops, tps80031_rtc_suspend,
+			tps80031_rtc_resume);
 
 static struct platform_driver tps80031_rtc_driver = {
 	.driver	= {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

