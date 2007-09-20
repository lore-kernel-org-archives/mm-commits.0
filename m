From: akpm@linux-foundation.org
Subject: - i386-cpuid_count-fix-argument-signedness-warnings.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:15 -0700
Message-ID: <200709202117.l8KLHFEp003066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbXITV2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 cpuid_count: fix argument signedness warnings
has been removed from the -mm tree.  Its filename was
     i386-cpuid_count-fix-argument-signedness-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 cpuid_count: fix argument signedness warnings
From: Satyam Sharma <satyam@infradead.org>

In file included from include/asm/thread_info.h:16,
from include/linux/thread_info.h:21,
from include/linux/preempt.h:9,
from include/linux/spinlock.h:49,
from include/linux/vmalloc.h:4,
from arch/i386/boot/compressed/misc.c:14:
include/asm/processor.h: In function `cpuid_count':
include/asm/processor.h:615: warning: pointer targets in passing argument 1 of `native_cpuid' differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 2 of `native_cpuid' differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 3 of `native_cpuid' differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 4 of `native_cpuid' differ in signedness

come because the arguments have been specified as pointers to (signed) int
types, not unsigned.  So let's specify those as unsigned.  Do some
codingstyle here and there while at it.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/processor.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/processor.h~i386-cpuid_count-fix-argument-signedness-warnings include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-cpuid_count-fix-argument-signedness-warnings
+++ a/include/asm-i386/processor.h
@@ -599,7 +599,9 @@ static inline void load_esp0(struct tss_
  * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
  * resulting in stale register contents being returned.
  */
-static inline void cpuid(unsigned int op, unsigned int *eax, unsigned int *ebx, unsigned int *ecx, unsigned int *edx)
+static inline void cpuid(unsigned int op,
+			 unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
 {
 	*eax = op;
 	*ecx = 0;
@@ -607,8 +609,9 @@ static inline void cpuid(unsigned int op
 }
 
 /* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
-			       int *edx)
+static inline void cpuid_count(unsigned int op, int count,
+			       unsigned int *eax, unsigned int *ebx,
+			       unsigned int *ecx, unsigned int *edx)
 {
 	*eax = op;
 	*ecx = count;
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
mpt-fusion-shut-up-uninitialized-variable.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
