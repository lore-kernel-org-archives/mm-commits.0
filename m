From: akpm@linux-foundation.org
Subject: - kernel-time-timekeepingc-cleanups.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:25 -0700
Message-ID: <200710180656.l9I6uP6V030699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760017AbXJRH2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/time/timekeeping.c: cleanups
has been removed from the -mm tree.  Its filename was
     kernel-time-timekeepingc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 static inline void update_xtime_cache(u64 nsec)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
