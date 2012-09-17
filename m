From: akpm@linux-foundation.org
Subject: + rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch added to -mm tree
Date: Mon, 17 Sep 2012 12:56:38 -0700
Message-ID: <20120917195639.055D120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:64547 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2IQT4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 15:56:41 -0400
Received: by lbbge1 with SMTP id ge1so421631lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 12:56:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, David@Fries.net


The patch titled
     Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix
has been added to the -mm tree.  Its filename is
     rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix

drivers/rtc/class.c: In function 'rtc_init':
drivers/rtc/class.c:261:23: error: 'rtc_suspend' undeclared (first use in t=
his function)
drivers/rtc/class.c:261:23: note: each undeclared identifier is reported on=
ly once for each function it appears in
drivers/rtc/class.c:262:22: error: 'rtc_resume' undeclared (first use in th=
is function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Fries <David@Fries.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix
+++ a/drivers/rtc/class.c
@@ -34,8 +34,9 @@ static void rtc_device_release(struct de
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
 /* Result of the last RTC to system clock attempt. */
 int rtc_hctosys_ret = -ENODEV;
+#endif
 
-#ifdef CONFIG_PM
+#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -129,7 +130,6 @@ static int rtc_resume(struct device *dev
 #define rtc_suspend	NULL
 #define rtc_resume	NULL
 #endif
-#endif
 
 
 /**
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
rbtree-empty-nodes-have-no-color-fix.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch

