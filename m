From: akpm@linux-foundation.org
Subject: - therm_throtc-fix-section-mismatch.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:13 -0700
Message-ID: <200709202117.l8KLHDJj003063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbXITV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     therm_throt.c: Fix section mismatch
has been removed from the -mm tree.  Its filename was
     therm_throtc-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: therm_throt.c: Fix section mismatch
From: Satyam Sharma <satyam@infradead.org>

Fix bugzilla #8679

WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')

comes because struct notifier_block thermal_throttle_cpu_notifier in
arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but the
notifier callback function itself has been marked __cpuinit which becomes
__init == .init.text when HOTPLUG_CPU=n.  The warning is bogus because the
callback will never be called out if HOTPLUG_CPU=n in the first place (as
one can see from kernel/cpu.c, the cpu_chain itself is __cpuinitdata :-)

So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
the section mismatch warning.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/mcheck/therm_throt.c~therm_throtc-fix-section-mismatch arch/i386/kernel/cpu/mcheck/therm_throt.c
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c~therm_throtc-fix-section-mismatch
+++ a/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -152,7 +152,7 @@ static __cpuinit int thermal_throttle_cp
 	return NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier =
+static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
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
