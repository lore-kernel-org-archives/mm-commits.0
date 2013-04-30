From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-88pm80xc-add-config_pm_sleep-to-suspend-resume-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:42 -0700
Message-ID: <20130430185842.738665A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46637 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378Ab3D3S6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:43 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so87063qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-88pm80x.c: add CONFIG_PM_SLEEP to suspend/resume functions
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-88pm80xc-add-config_pm_sleep-to-suspend-resume-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-88pm80x.c: add CONFIG_PM_SLEEP to suspend/resume functions

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following build
warning when CONFIG_PM_SLEEP is not selected.  This is because sleep PM
callbacks defined by SIMPLE_DEV_PM_OPS are only used when the
CONFIG_PM_SLEEP is enabled.

drivers/rtc/rtc-88pm80x.c:238:12: warning: 'pm80x_rtc_suspend' defined but not used [-Wunused-function]
drivers/rtc/rtc-88pm80x.c:243:12: warning: 'pm80x_rtc_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-88pm80x.c~drivers-rtc-rtc-88pm80xc-add-config_pm_sleep-to-suspend-resume-functions drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~drivers-rtc-rtc-88pm80xc-add-config_pm_sleep-to-suspend-resume-functions
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -234,7 +234,7 @@ static const struct rtc_class_ops pm80x_
 	.alarm_irq_enable = pm80x_rtc_alarm_irq_enable,
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pm80x_rtc_suspend(struct device *dev)
 {
 	return pm80x_dev_suspend(dev);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

