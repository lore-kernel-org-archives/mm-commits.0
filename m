From: akpm@linux-foundation.org
Subject: [merged] rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:11 -0800
Message-ID: <20130222204411.AEFD25A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47691 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BVUoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:12 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so104363yhr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: use dev_warn()/dev_dbg()/pr_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: use dev_warn()/dev_dbg()/pr_err() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c   |    4 +++-
 drivers/rtc/rtc-dev.c |   11 ++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/class.c~rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk
+++ a/drivers/rtc/class.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
@@ -261,7 +263,7 @@ static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
 	if (IS_ERR(rtc_class)) {
-		printk(KERN_ERR "%s: couldn't create class\n", __FILE__);
+		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
 	rtc_class->suspend = rtc_suspend;
diff -puN drivers/rtc/rtc-dev.c~rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk
+++ a/drivers/rtc/rtc-dev.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
@@ -462,7 +464,7 @@ void rtc_dev_prepare(struct rtc_device *
 		return;
 
 	if (rtc->id >= RTC_DEV_MAX) {
-		pr_debug("%s: too many RTC devices\n", rtc->name);
+		dev_dbg(&rtc->dev, "%s: too many RTC devices\n", rtc->name);
 		return;
 	}
 
@@ -480,10 +482,10 @@ void rtc_dev_prepare(struct rtc_device *
 void rtc_dev_add_device(struct rtc_device *rtc)
 {
 	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
-		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
+		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
 			rtc->name, MAJOR(rtc_devt), rtc->id);
 	else
-		pr_debug("%s: dev (%d:%d)\n", rtc->name,
+		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
 			MAJOR(rtc_devt), rtc->id);
 }
 
@@ -499,8 +501,7 @@ void __init rtc_dev_init(void)
 
 	err = alloc_chrdev_region(&rtc_devt, 0, RTC_DEV_MAX, "rtc");
 	if (err < 0)
-		printk(KERN_ERR "%s: failed to allocate char dev region\n",
-			__FILE__);
+		pr_err("failed to allocate char dev region\n");
 }
 
 void __exit rtc_dev_exit(void)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

