From: akpm@linux-foundation.org
Subject: - ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:24 -0700
Message-ID: <200709212108.l8LL8OlD023572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761532AbXIUVJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ll_rw_blk: blk_cpu_notifier should be __cpuinitdata
has been removed from the -mm tree.  Its filename was
     ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ll_rw_blk: blk_cpu_notifier should be __cpuinitdata
From: Satyam Sharma <satyam@infradead.org>

blk_cpu_notifier is marked as __devinitdata, but __devinitdata need not
be __init even if HOTPLUG_CPU=n, which wastes space. It should be marked
__cpuinitdata, and the callback itself as __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN block/ll_rw_blk.c~ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata
+++ a/block/ll_rw_blk.c
@@ -3633,7 +3633,7 @@ static void blk_done_softirq(struct soft
 	}
 }
 
-static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
+static int __cpuinit blk_cpu_notify(struct notifier_block *self, unsigned long action,
 			  void *hcpu)
 {
 	/*
@@ -3654,7 +3654,7 @@ static int blk_cpu_notify(struct notifie
 }
 
 
-static struct notifier_block __devinitdata blk_cpu_notifier = {
+static struct notifier_block blk_cpu_notifier __cpuinitdata = {
 	.notifier_call	= blk_cpu_notify,
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
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
