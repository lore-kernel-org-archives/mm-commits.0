From: akpm@linux-foundation.org
Subject: - lockdep-annotate-kprobes-irq-fiddling.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:18:02 -0700
Message-ID: <200710160218.l9G2I27D004259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422AbXJPCSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mingo@elte.hu, prasanna@in.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate kprobes irq fiddling
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-kprobes-irq-fiddling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: annotate kprobes irq fiddling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

kprobes disables irqs for jprobes, but does not tell lockdep about it.

This resolves this warning during an allyesconfig bzImage bootup test:

 [  423.670337] WARNING: at kernel/lockdep.c:2658 check_flags()
 [  423.670341]  [<c0107f01>] show_trace_log_lvl+0x19/0x2e
 [  423.670348]  [<c0107ffa>] show_trace+0x12/0x14
 [  423.670350]  [<c0108010>] dump_stack+0x14/0x16
 [  423.670353]  [<c015249d>] check_flags+0x95/0x142
 [  423.670357]  [<c0155576>] lock_acquire+0x52/0xb8
 [  423.670360]  [<c1313c90>] _spin_lock+0x2e/0x58
 [  423.670365]  [<c11b72f9>] jtcp_rcv_established+0x6e/0x189
 [  423.670369]  [<c11810da>] tcp_v4_do_rcv+0x30b/0x620
 [  423.670373]  [<c1181c8c>] tcp_v4_rcv+0x89d/0x8fa
 [  423.670376]  [<c1167dba>] ip_local_deliver+0x17d/0x225
 [  423.670380]  [<c11682f5>] ip_rcv+0x493/0x4ce
 [  423.670383]  [<c11177ef>] netif_receive_skb+0x347/0x365
 [  423.670388]  [<c07b6e7b>] nv_napi_poll+0x501/0x6c3
 [  423.670393]  [<c1115b1a>] net_rx_action+0xa3/0x1b6
 [  423.670396]  [<c013bdee>] __do_softirq+0x76/0xfb
 [  423.670400]  [<c0109189>] do_softirq+0x75/0xf3

Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes_32.c |    8 ++++++++
 arch/x86/kernel/kprobes_64.c |    8 ++++++++
 2 files changed, 16 insertions(+)

diff -puN arch/x86/kernel/kprobes_32.c~lockdep-annotate-kprobes-irq-fiddling arch/x86/kernel/kprobes_32.c
--- a/arch/x86/kernel/kprobes_32.c~lockdep-annotate-kprobes-irq-fiddling
+++ a/arch/x86/kernel/kprobes_32.c
@@ -564,6 +564,13 @@ static int __kprobes post_kprobe_handler
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_eflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags)) {
+		trace_hardirqs_off();
+	} else {
+		trace_hardirqs_on();
+	}
+#endif
 
 	/*Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
@@ -700,6 +707,7 @@ int __kprobes setjmp_pre_handler(struct 
 	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
 			MIN_STACK_SIZE(addr));
 	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
 	regs->eip = (unsigned long)(jp->entry);
 	return 1;
 }
diff -puN arch/x86/kernel/kprobes_64.c~lockdep-annotate-kprobes-irq-fiddling arch/x86/kernel/kprobes_64.c
--- a/arch/x86/kernel/kprobes_64.c~lockdep-annotate-kprobes-irq-fiddling
+++ a/arch/x86/kernel/kprobes_64.c
@@ -551,6 +551,13 @@ int __kprobes post_kprobe_handler(struct
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_rflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags)) {
+		trace_hardirqs_off();
+	} else {
+		trace_hardirqs_on();
+	}
+#endif
 
 	/* Restore the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
@@ -690,6 +697,7 @@ int __kprobes setjmp_pre_handler(struct 
 	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
 			MIN_STACK_SIZE(addr));
 	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
 	regs->rip = (unsigned long)(jp->entry);
 	return 1;
 }
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
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
lib-floating-proportions.patch
mm-per-device-dirty-threshold.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-per-device-dirty-threshold-fix.patch
mm-dirty-balancing-for-tasks.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
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
peterz-vs-ext4-mballoc-core.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
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
