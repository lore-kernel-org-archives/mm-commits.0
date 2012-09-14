From: akpm@linux-foundation.org
Subject: + rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch added to -mm tree
Date: Fri, 14 Sep 2012 13:03:09 -0700
Message-ID: <20120914200309.A34AB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47584 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2INUDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 16:03:10 -0400
Received: by qafl39 with SMTP id l39so27102qaf.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 13:03:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, David@Fries.net, sfr@canb.auug.org.au


The patch titled
     Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix
has been added to the -mm tree.  Its filename is
     rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch

