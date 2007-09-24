From: akpm@linux-foundation.org
Subject: + on_each_cpu-debugging.patch added to -mm tree
Date: Mon, 24 Sep 2007 12:39:40 -0700
Message-ID: <200709241939.l8OJdeSl014217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbXIXTkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 15:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, kamalesh@linux.vnet.ibm.com


The patch titled
     on_each_cpu() debugging
has been added to the -mm tree.  Its filename is
     on_each_cpu-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: on_each_cpu() debugging
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

On Mon, 24 Sep 2007 22:38:03 +0530 Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:

> Peter Zijlstra wrote:
> > On Mon, 24 Sep 2007 09:44:48 -0700 Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >
> >> On Mon, 24 Sep 2007 18:43:33 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> >>
> >>> Hi Andrew,
> >>>
> >>> Kernel BUG over x86_64 (AMD Opteron(tm) Processor 844).
> >>>
> >>> Similar kernel Bug was reported for 2.6.23-rc2-mm1
> >>> at http://lkml.org/lkml/2007/8/10/20 and the
> >>> mm-dirty-balancing-for-tasks.patch was dropped from 2.6.23-rc2-mm2.
> >>> And the same patch is in this -mm version, suspect whether is it the
> >>> same patch triggering this Bug.
> >>>
> >>> BUG: soft lockup - CPU#0 stuck for 11s! [events/0:15]
> >>> CPU 0:
> >>> Modules linked in:
> >>> Pid: 15, comm: events/0 Tainted: G      D 2.6.23-rc7-mm1-autokern1 #1
> >>> RIP: 0010:[<ffffffff8021be46>]  [<ffffffff8021be46>] __smp_call_function_mask+0x9a/0xc4
> >>> RSP: 0000:ffff8100017add80  EFLAGS: 00000297
> >>> RAX: 00000000000000fc RBX: ffff8100017adde0 RCX: 0000000000000001
> >>> RDX: 00000000000008fc RSI: 00000000000000fc RDI: 000000000000000e
> >>> RBP: ffffc20002d11000 R08: ffff8100017ac000 R09: ffffffff80675e38
> >>> R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000f
> >>> R13: ffffffff8021bcfe R14: 0000000000000000 R15: 0000000000000001
> >>> FS:  0000000000000000(0000) GS:ffffffff8065a000(0000) knlGS:00000000556aa2a0
> >>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> >>> CR2: ffffc20002d11008 CR3: 0000000000201000 CR4: 00000000000006e0
> >>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >>>
> >>> Call Trace:
> >>> Inexact backtrace:
> >>>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
> >>>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
> >>>  [<ffffffff8021becf>] smp_call_function_mask+0x5f/0x72
> >>>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
> >>>  [<ffffffff8021bf82>] smp_call_function+0x19/0x1b
> >>>  [<ffffffff8023a773>] on_each_cpu+0x16/0x2b
> >>>  [<ffffffff802158a2>] mcheck_timer+0x0/0x7c
> >>>  [<ffffffff802158c0>] mcheck_timer+0x1e/0x7c
> >>>  [<ffffffff802444b9>] run_workqueue+0x88/0x109
> >>>  [<ffffffff8024453a>] worker_thread+0x0/0xf4
> >>>  [<ffffffff80244623>] worker_thread+0xe9/0xf4
> >>>  [<ffffffff8024841d>] autoremove_wake_function+0x0/0x37
> >>>  [<ffffffff8024841d>] autoremove_wake_function+0x0/0x37
> >>>  [<ffffffff80247e5c>] kthread+0x44/0x6d
> >>>  [<ffffffff8020c5a8>] child_rip+0xa/0x12
> >>>  [<ffffffff80247e18>] kthread+0x0/0x6d
> >>>  [<ffffffff8020c59e>] child_rip+0x0/0x12
> >> hm, I thought we'd fixed the problems in that patchset.  Peter, were
> >> you aware of this one?
> >
> > Nope, and the stacktrace is utterly puzzling.
> >
> > /me goes read the lkml.org link
> >
> > Kamalesh Babulal: do you still get:
> >   BUG: spinlock bad magic on
> >
> > msgs?
> >
> > Because those I could reproduce using fsx, and I fixed all that.
> Hi Peter,
>
> I do not get BUG: spinlock bad magic messages any more, but the softlock message is
> thrown more than 30 time, while running the ltp runall.

It would be good to know what function on_each_cpu is executing, could
you try something like:

Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c    |    5 +++++
 kernel/softlockup.c |    7 +++++++
 2 files changed, 12 insertions(+)

diff -puN kernel/softirq.c~on_each_cpu-debugging kernel/softirq.c
--- a/kernel/softirq.c~on_each_cpu-debugging
+++ a/kernel/softirq.c
@@ -645,6 +645,8 @@ __init int spawn_ksoftirqd(void)
 }
 
 #ifdef CONFIG_SMP
+
+DEFINE_PER_CPU(void (*)(void *info), last_on_each_cpu);
 /*
  * Call a function on all processors
  */
@@ -653,6 +655,9 @@ int on_each_cpu(void (*func) (void *info
 	int ret = 0;
 
 	preempt_disable();
+
+	per_cpu(last_on_each_cpu, smp_processor_id()) = func;
+
 	ret = smp_call_function(func, info, retry, wait);
 	local_irq_disable();
 	func(info);
diff -puN kernel/softlockup.c~on_each_cpu-debugging kernel/softlockup.c
--- a/kernel/softlockup.c~on_each_cpu-debugging
+++ a/kernel/softlockup.c
@@ -15,6 +15,8 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/kgdb.h>
+#include <linux/percpu.h>
+#include <linux/kallsyms.h>
 
 #include <asm/irq_regs.h>
 
@@ -71,6 +73,8 @@ void touch_all_softlockup_watchdogs(void
 }
 EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
+DECLARE_PER_CPU(void (*)(void *), last_on_each_cpu);
+
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
@@ -122,6 +126,9 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+	printk(KERN_ERR " last_on_each_cpu: [<%p>] ",
+			per_cpu(last_on_each_cpu, this_cpu));
+	print_symbol("%s\n", (unsigned long)per_cpu(last_on_each_cpu, this_cpu));
 	if (regs)
 		show_regs(regs);
 	else
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

git-powerpc-galak.patch
git-sched.patch
radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter_sub.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
lib-floating-proportions.patch
mm-per-device-dirty-threshold.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-per-device-dirty-threshold-fix.patch
mm-dirty-balancing-for-tasks.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
debug-sysfs-files-for-the-current-ratio-size-total.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
on_each_cpu-debugging.patch
