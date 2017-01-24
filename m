From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
 removed from -mm tree
Date: Tue, 24 Jan 2017 15:13:13 -0800
Message-ID: <5887df89.F67JXtu+WVzm7JAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdAXXNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atomlin@redhat.com, dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch

This patch was dropped because it was folded into kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix

s/park_in_progress/watchdog_park_in_progress/

Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h   |    2 +-
 kernel/watchdog.c     |    8 ++++----
 kernel/watchdog_hld.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/nmi.h~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix include/linux/nmi.h
--- a/include/linux/nmi.h~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix
+++ a/include/linux/nmi.h
@@ -110,7 +110,7 @@ extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long watchdog_enabled;
 extern unsigned long *watchdog_cpumask_bits;
-extern atomic_t park_in_progress;
+extern atomic_t watchdog_park_in_progress;
 #ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
 extern int sysctl_hardlockup_all_cpu_backtrace;
diff -puN kernel/watchdog.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix
+++ a/kernel/watchdog.c
@@ -49,7 +49,7 @@ unsigned long *watchdog_cpumask_bits = c
 #define for_each_watchdog_cpu(cpu) \
 	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
-atomic_t park_in_progress = ATOMIC_INIT(0);
+atomic_t watchdog_park_in_progress = ATOMIC_INIT(0);
 
 /*
  * The 'watchdog_running' variable is set to 1 when the watchdog threads
@@ -262,7 +262,7 @@ static enum hrtimer_restart watchdog_tim
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
 
-	if (atomic_read(&park_in_progress) != 0)
+	if (atomic_read(&watchdog_park_in_progress) != 0)
 		return HRTIMER_NORESTART;
 
 	/* kick the hardlockup detector */
@@ -472,7 +472,7 @@ static int watchdog_park_threads(void)
 {
 	int cpu, ret = 0;
 
-	atomic_set(&park_in_progress, 1);
+	atomic_set(&watchdog_park_in_progress, 1);
 
 	for_each_watchdog_cpu(cpu) {
 		ret = kthread_park(per_cpu(softlockup_watchdog, cpu));
@@ -480,7 +480,7 @@ static int watchdog_park_threads(void)
 			break;
 	}
 
-	atomic_set(&park_in_progress, 0);
+	atomic_set(&watchdog_park_in_progress, 0);
 
 	return ret;
 }
diff -puN kernel/watchdog_hld.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix
+++ a/kernel/watchdog_hld.c
@@ -84,7 +84,7 @@ static void watchdog_overflow_callback(s
 	/* Ensure the watchdog never gets throttled */
 	event->hw.interrupts = 0;
 
-	if (atomic_read(&park_in_progress) != 0)
+	if (atomic_read(&watchdog_park_in_progress) != 0)
 		return;
 
 	if (__this_cpu_read(watchdog_nmi_touch) == true) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

