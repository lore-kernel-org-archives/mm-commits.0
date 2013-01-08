From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:04:03 -0800
Message-ID: <20130108220404.238BB820071@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:64681 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3AHWEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:04:05 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so139999yen.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:04:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: use sleep_pm_ops macro for initialising suspend/resume callbacks
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 static struct platform_driver tps65910_rtc_driver = {
 	.probe		= tps65910_rtc_probe,
 	.remove		= tps65910_rtc_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "tps65910-rtc",
-		.pm	= DEV_PM_OPS,
+		.pm	= &tps65910_rtc_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch
drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch
drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch
drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

