From: akpm@linux-foundation.org
Subject: [folded] printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:36:31 -0700
Message-ID: <200909222136.n8MLaWHJ019379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZIVVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
has been removed from the -mm tree.  Its filename was
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch

This patch was dropped because it was folded into printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix include/linux/sysctl.h
--- a/include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
+++ a/include/linux/sysctl.h
@@ -163,7 +163,6 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
-	KERN_PRINTK_DELAY = 77,	/* int: tune printk delay*/
 };
 
 
diff -puN kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix kernel/sysctl.c
--- a/kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix
+++ a/kernel/sysctl.c
@@ -105,7 +105,9 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+#ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
+#endif
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -715,7 +717,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= KERN_PRINTK_DELAY,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "printk_delay",
 		.data		= &printk_delay_msec,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

