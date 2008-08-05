From: akpm@linux-foundation.org
Subject: + lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:14:29 -0700
Message-ID: <200808050914.m759ETtC027213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759504AbYHEJP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 05:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, davem@davemloft.net


The patch titled
     lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal fix
has been added to the -mm tree.  Its filename is
     lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal fix
From: Ingo Molnar <mingo@elte.hu>

fix:

 kernel/built-in.o: In function `lockdep_stats_show':
 lockdep_proc.c:(.text+0x3cb2f): undefined reference to `lockdep_count_forward_deps'
 kernel/built-in.o: In function `l_show':
 lockdep_proc.c:(.text+0x3d02b): undefined reference to `lockdep_count_forward_deps'
 lockdep_proc.c:(.text+0x3d047): undefined reference to `lockdep_count_backward_deps'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_internals.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN kernel/lockdep_internals.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix kernel/lockdep_internals.h
--- a/kernel/lockdep_internals.h~lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix
+++ a/kernel/lockdep_internals.h
@@ -53,8 +53,21 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+#ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+#else
+static inline unsigned long
+lockdep_count_forward_deps(struct lock_class *class)
+{
+	return 0;
+}
+static inline unsigned long
+lockdep_count_backward_deps(struct lock_class *class)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
remove-the-deprecated-cli-sti-functions.patch
dma-fix-order-calculation-in-dma_mark_declared_memory_occupied.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
i386-vmalloc-size-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-64-fix-overlap-of-modules-and-fixmap-areas.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
migrate_timers-add-comment-use-spinlock_irq.patch
use-warn-in-kernel-lockdepc.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
sched-type-fix.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-shrink-held_lock-structure.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-printk-formatting-infrastructure-fix.patch
pl2023-remove-usb-id-4348-5523-handled-by-ch341.patch
switch-proc-irq-smp_affinity-et-al-to-seqfiles.patch
mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
x86-fdiv-bug-detection-fix.patch
x86_64-restore-the-proper-nr_irqs-define-so-larger-systems-work.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
likely-profiling-disable-ftrace.patch

