From: akpm@linux-foundation.org
Subject: + sched-use-show_regs-to-improve-__schedule_bug-output.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:49:19 -0700
Message-ID: <200709130749.l8D7nJYX008415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbXIMHuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, mingo@elte.hu


The patch titled
     sched: Use show_regs() to improve __schedule_bug() output
has been added to the -mm tree.  Its filename is
     sched-use-show_regs-to-improve-__schedule_bug-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -64,6 +64,7 @@
 #include <linux/unistd.h>
 
 #include <asm/tlb.h>
+#include <asm/irq_regs.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -3402,12 +3403,19 @@ EXPORT_SYMBOL(sub_preempt_count);
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

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
