From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch added to
 -mm tree
Date: Mon, 10 Jun 2013 16:37:56 -0700
Message-ID: <51b66354.VH3up3XsHNqJonFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FJXh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 19:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuahkhan@gmail.com, jg1.han@samsung.com, a.zummo@towertech.it, shuah.kh@samsung.com

Subject: + drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch added to -mm tree
To: shuah.kh@samsung.com,a.zummo@towertech.it,jg1.han@samsung.com,shuahkhan@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 16:37:56 -0700


The patch titled
     Subject: drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops
has been added to the -mm tree.  Its filename is
     drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops

Convert drivers/rtc/class to use dev_pm_ops for power management and
remove Legacy PM ops hooks.  With this change, rtc class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume.  When __device_suspend() runs call-backs, it will
find class->pm ops for the rtc class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/class.c~drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops drivers/rtc/class.c
--- a/drivers/rtc/class.c~drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops
+++ a/drivers/rtc/class.c
@@ -38,7 +38,7 @@ static void rtc_device_release(struct de
 int rtc_hctosys_ret = -ENODEV;
 #endif
 
-#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -47,7 +47,7 @@ int rtc_hctosys_ret = -ENODEV;
 static struct timespec old_rtc, old_system, old_delta;
 
 
-static int rtc_suspend(struct device *dev, pm_message_t mesg)
+static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
@@ -135,9 +135,10 @@ static int rtc_resume(struct device *dev
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
+#define RTC_CLASS_DEV_PM_OPS	(&rtc_class_dev_pm_ops)
 #else
-#define rtc_suspend	NULL
-#define rtc_resume	NULL
+#define RTC_CLASS_DEV_PM_OPS	NULL
 #endif
 
 
@@ -336,8 +337,7 @@ static int __init rtc_init(void)
 		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
-	rtc_class->suspend = rtc_suspend;
-	rtc_class->resume = rtc_resume;
+	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

linux-next.patch
backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch
drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

