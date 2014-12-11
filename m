From: akpm@linux-foundation.org
Subject: + rtc-snvs-fix-build-with-config_pm_sleep-disabled.patch added to -mm tree
Date: Thu, 11 Dec 2014 11:45:56 -0800
Message-ID: <5489f474.7Fx+Oa7dcgZvOMPN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaLKTps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, a.zummo@towertech.it, maitysanchayan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: snvs: fix build with CONFIG_PM_SLEEP disabled
has been added to the -mm tree.  Its filename is
     rtc-snvs-fix-build-with-config_pm_sleep-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-snvs-fix-build-with-config_pm_sleep-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-snvs-fix-build-with-config_pm_sleep-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: rtc: snvs: fix build with CONFIG_PM_SLEEP disabled

Commit 7654e9d4fd8f ("drivers/rtc/rtc-snvs: fix suspend/resume") replaces
SIMPLE_DEV_PM_OPS with direct declaration of snvs_rtc_pm_ops, but does so
outside #ifdef CONFIG_PM_SLEEP.  This causes the driver build to fail if
CONFIG_PM_SLEEP is not configured.

Fixes: 7654e9d4fd8f ("drivers/rtc/rtc-snvs: fix suspend/resume")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-snvs.c~rtc-snvs-fix-build-with-config_pm_sleep-disabled drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~rtc-snvs-fix-build-with-config_pm_sleep-disabled
+++ a/drivers/rtc/rtc-snvs.c
@@ -344,13 +344,20 @@ static int snvs_rtc_resume(struct device
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops snvs_rtc_pm_ops = {
 	.suspend_noirq = snvs_rtc_suspend,
 	.resume_noirq = snvs_rtc_resume,
 };
 
+#define SNVS_RTC_PM_OPS	(&snvs_rtc_pm_ops)
+
+#else
+
+#define SNVS_RTC_PM_OPS	NULL
+
+#endif
+
 static const struct of_device_id snvs_dt_ids[] = {
 	{ .compatible = "fsl,sec-v4.0-mon-rtc-lp", },
 	{ /* sentinel */ }
@@ -361,7 +368,7 @@ static struct platform_driver snvs_rtc_d
 	.driver = {
 		.name	= "snvs_rtc",
 		.owner	= THIS_MODULE,
-		.pm	= &snvs_rtc_pm_ops,
+		.pm	= SNVS_RTC_PM_OPS,
 		.of_match_table = snvs_dt_ids,
 	},
 	.probe		= snvs_rtc_probe,
_

Patches currently in -mm which might be from linux@roeck-us.net are

origin.patch
rtc-snvs-fix-build-with-config_pm_sleep-disabled.patch
linux-next.patch

