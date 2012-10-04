From: akpm@linux-foundation.org
Subject: [folded-dropped] rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:59:51 -0700
Message-ID: <20121004235952.5C1D15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:33188 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2JDX7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:59:54 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so75212bkw.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:59:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, David@Fries.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix
has been removed from the -mm tree.  Its filename was
     rtc_sysfs_show_hctosys-return-0-if-resume-failed-fix-fix.patch

This patch was dropped because it was folded into rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

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

origin.patch
idr-rename-max_level-to-max_idr_level.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch
coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch
compat-move-compat_siginfo_t-definition-to-asm-compath.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

