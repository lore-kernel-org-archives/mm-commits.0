From: akpm@linux-foundation.org
Subject: - sched-use-show_regs-to-improve-__schedule_bug-output.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:22:56 -0700
Message-ID: <200710010722.l917MueU004893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbXJAHXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: Use show_regs() to improve __schedule_bug() output
has been removed from the -mm tree.  Its filename was
     sched-use-show_regs-to-improve-__schedule_bug-output.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sched: Use show_regs() to improve __schedule_bug() output
From: Satyam Sharma <satyam@infradead.org>

A full register dump along with stack backtrace would make the "scheduling
while atomic" message more helpful.  Use show_regs() instead of
dump_stack() for this.  We already know we're atomic in here (that is why
this function was called) so show_regs()'s atomicity expectations are
guaranteed.

Also, modify the output of the "BUG: scheduling while atomic:" header a bit
to keep task->comm and task->pid together and preempt_count() after them.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-use-show_regs-to-improve-__schedule_bug-output kernel/sched.c
--- a/kernel/sched.c~sched-use-show_regs-to-improve-__schedule_bug-output
+++ a/kernel/sched.c
@@ -63,6 +63,7 @@
 #include <linux/unistd.h>
 
 #include <asm/tlb.h>
+#include <asm/irq_regs.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -3398,12 +3399,19 @@ EXPORT_SYMBOL(sub_preempt_count);
  */
 static noinline void __schedule_bug(struct task_struct *prev)
 {
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/0x%08x/%d\n",
-		prev->comm, preempt_count(), prev->pid);
+	struct pt_regs *regs = get_irq_regs();
+
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
+		prev->comm, prev->pid, preempt_count());
+
 	debug_show_held_locks(prev);
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
-	dump_stack();
+
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
 }
 
 /*
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
git-scsi-misc.patch
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
