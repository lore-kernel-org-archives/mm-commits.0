From: akpm@linux-foundation.org
Subject: + kernel-time-timekeepingc-cleanups.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:56:25 -0700
Message-ID: <200708162056.l7GKuP0P006293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757215AbXHPU5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     kernel/time/timekeeping.c: cleanups
has been added to the -mm tree.  Its filename is
     kernel-time-timekeepingc-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/time/timekeeping.c: cleanups
From: Adrian Bunk <bunk@kernel.org>

- remove the no longer required __attribute__((weak)) of xtime_lock
- remove the following no longer used EXPORT_SYMBOL's:
  - xtime
  - xtime_lock

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    2 +-
 kernel/time/timekeeping.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/time.h~kernel-time-timekeepingc-cleanups include/linux/time.h
--- a/include/linux/time.h~kernel-time-timekeepingc-cleanups
+++ a/include/linux/time.h
@@ -92,7 +92,7 @@ static inline struct timespec timespec_s
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock __attribute__((weak));
+extern seqlock_t xtime_lock;
 
 extern unsigned long read_persistent_clock(void);
 extern int update_persistent_clock(struct timespec now);
diff -puN kernel/time/timekeeping.c~kernel-time-timekeepingc-cleanups kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~kernel-time-timekeepingc-cleanups
+++ a/kernel/time/timekeeping.c
@@ -24,9 +24,7 @@
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime and avenrun.
  */
-__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-EXPORT_SYMBOL(xtime_lock);
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 
 /*
@@ -47,7 +45,6 @@ EXPORT_SYMBOL(xtime_lock);
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
-EXPORT_SYMBOL(xtime);
 
 
 #ifdef CONFIG_NO_HZ
_

Patches currently in -mm which might be from bunk@kernel.org are

alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
