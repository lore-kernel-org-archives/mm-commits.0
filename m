From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:47 -0800
Message-ID: <20130222204347.A61A15A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:65068 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BVUns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:48 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so104212vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: use sleep_pm_ops macro for initialising suspend/resume callbacks
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: use sleep_pm_ops macro for initialising suspend/resume callbacks

Use SET_SYSTEM_SLEEP_PM_OPS for setting suspend/resume callbacks for
dev_pm_ops.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks
+++ a/drivers/rtc/rtc-tps65910.c
@@ -22,6 +22,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tps65910.h>
 
@@ -304,7 +305,6 @@ static int tps65910_rtc_remove(struct pl
 }
 
 #ifdef CONFIG_PM_SLEEP
-
 static int tps65910_rtc_suspend(struct device *dev)
 {
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
@@ -322,24 +322,19 @@ static int tps65910_rtc_resume(struct de
 		disable_irq_wake(tps_rtc->irq);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops tps65910_rtc_pm_ops = {
-	.suspend	= tps65910_rtc_suspend,
-	.resume		= tps65910_rtc_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(tps65910_rtc_suspend, tps65910_rtc_resume)
 };
 
-#define DEV_PM_OPS     (&tps65910_rtc_pm_ops)
-#else
-#define DEV_PM_OPS     NULL
-#endif
