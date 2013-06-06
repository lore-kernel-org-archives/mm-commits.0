From: akpm@linux-foundation.org
Subject: [failures]
 drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch removed
 from -mm tree
Date: Thu, 06 Jun 2013 13:07:22 -0700
Message-ID: <51b0ebfa.WdIuCjilk99wdLZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3FFUHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 16:07:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuahkhan@gmail.com, jg1.han@samsung.com, a.zummo@towertech.it, shuah.kh@samsung.com

Subject: [failures] drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch removed from -mm tree
To: shuah.kh@samsung.com,a.zummo@towertech.it,jg1.han@samsung.com,shuahkhan@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 13:07:22 -0700


The patch titled
     Subject: drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops

Convert drivers/rtc/class to use dev_pm_ops for power management and
remove Legacy PM ops hooks.  With this change, rtc class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume.  When __device_suspend() runs call-backs, it will
find class->pm ops for the rtc class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops drivers/rtc/class.c
--- a/drivers/rtc/class.c~drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops
+++ a/drivers/rtc/class.c
@@ -47,7 +47,7 @@ int rtc_hctosys_ret = -ENODEV;
 static struct timespec old_rtc, old_system, old_delta;
 
 
-static int rtc_suspend(struct device *dev, pm_message_t mesg)
+static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
@@ -135,9 +135,9 @@ static int rtc_resume(struct device *dev
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
 #else
-#define rtc_suspend	NULL
-#define rtc_resume	NULL
+#define rtc_class_dev_pm_ops	NULL
 #endif
 
 
@@ -336,8 +336,7 @@ static int __init rtc_init(void)
 		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
-	rtc_class->suspend = rtc_suspend;
-	rtc_class->resume = rtc_resume;
+	rtc_class->pm = &rtc_class_dev_pm_ops;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

linux-next.patch
backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

