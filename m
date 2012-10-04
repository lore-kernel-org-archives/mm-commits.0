From: akpm@linux-foundation.org
Subject: [folded-dropped] rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:59:48 -0700
Message-ID: <20121004235948.A07AE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35458 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JDX7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:59:49 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so90702yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:59:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, David@Fries.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix
has been removed from the -mm tree.  Its filename was
     rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch

This patch was dropped because it was folded into rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

------------------------------------------------------
From: David Fries <david@fries.net>
Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix

fix build

Signed-off-by: David Fries <David@Fries.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix
+++ a/drivers/rtc/class.c
@@ -31,16 +31,18 @@ static void rtc_device_release(struct de
 	kfree(rtc);
 }
 
-#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
+/* Result of the last RTC to system clock attempt. */
+int rtc_hctosys_ret = -ENODEV;
 
+#ifdef CONFIG_PM
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
  */
 
 static struct timespec old_rtc, old_system, old_delta;
-/* Result of the last RTC to system clock attempt. */
-int rtc_hctosys_ret = -ENODEV;
+
 
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
@@ -127,6 +129,7 @@ static int rtc_resume(struct device *dev
 #define rtc_suspend	NULL
 #define rtc_resume	NULL
 #endif
+#endif
 
 
 /**
_

Patches currently in -mm which might be from david@fries.net are

rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

