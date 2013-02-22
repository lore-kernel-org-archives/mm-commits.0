From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:17 -0800
Message-ID: <20130222204417.C52385A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54141 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BVUoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:18 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103718vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-efi: use dev_err()/dev_warn()/pr_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-efi: use dev_err()/dev_warn()/pr_err() instead of printk()

Fix the checkpatch warnings as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
  WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk
+++ a/drivers/rtc/rtc-efi.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -47,7 +49,7 @@ compute_wday(efi_time_t *eft)
 	int ndays = 0;
 
 	if (eft->year < 1998) {
-		printk(KERN_ERR "efirtc: EFI year < 1998, invalid date\n");
+		pr_err("EFI year < 1998, invalid date\n");
 		return -1;
 	}
 
@@ -70,7 +72,7 @@ convert_to_efi_time(struct rtc_time *wti
 	eft->day	= wtime->tm_mday;
 	eft->hour	= wtime->tm_hour;
 	eft->minute	= wtime->tm_min;
-	eft->second 	= wtime->tm_sec;
+	eft->second	= wtime->tm_sec;
 	eft->nanosecond = 0;
 	eft->daylight	= wtime->tm_isdst ? EFI_ISDST : 0;
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
@@ -142,7 +144,7 @@ static int efi_set_alarm(struct device *
 	 */
 	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
 
-	printk(KERN_WARNING "write status is %d\n", (int)status);
+	dev_warn(dev, "write status is %d\n", (int)status);
 
 	return status == EFI_SUCCESS ? 0 : -EINVAL;
 }
@@ -157,7 +159,7 @@ static int efi_read_time(struct device *
 
 	if (status != EFI_SUCCESS) {
 		/* should never happen */
-		printk(KERN_ERR "efitime: can't read time\n");
+		dev_err(dev, "can't read time\n");
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

