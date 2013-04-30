From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1374c-add-config_pm_sleep-to-suspend-resume-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:40 -0700
Message-ID: <20130430185840.711CF31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:47785 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355Ab3D3S6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:41 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77679ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1374.c: add CONFIG_PM_SLEEP to suspend/resume functions
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1374c-add-config_pm_sleep-to-suspend-resume-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-ds1374.c: add CONFIG_PM_SLEEP to suspend/resume functions

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following build
warning when CONFIG_PM_SLEEP is not selected.  This is because sleep PM
callbacks defined by SIMPLE_DEV_PM_OPS are only used when the
CONFIG_PM_SLEEP is enabled.

drivers/rtc/rtc-ds1374.c:413:12: warning: 'ds1374_suspend' defined but not used [-Wunused-function]
drivers/rtc/rtc-ds1374.c:422:12: warning: 'ds1374_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-add-config_pm_sleep-to-suspend-resume-functions drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-add-config_pm_sleep-to-suspend-resume-functions
+++ a/drivers/rtc/rtc-ds1374.c
@@ -409,7 +409,7 @@ static int ds1374_remove(struct i2c_clie
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ds1374_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -427,19 +427,15 @@ static int ds1374_resume(struct device *
 		disable_irq_wake(client->irq);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ds1374_pm, ds1374_suspend, ds1374_resume);
 
-#define DS1374_PM (&ds1374_pm)
-#else
-#define DS1374_PM NULL
-#endif
