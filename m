From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-fix-build-failure.patch added to -mm tree
Date: Fri, 25 Jul 2008 05:22:57 -0700
Message-ID: <200807251222.m6PCMvqL010349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbYGYMXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 08:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     mm/hugetlb.c: fix build failure
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-build-failure.patch

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
Subject: mm/hugetlb.c: fix build failure
From: Ingo Molnar <mingo@elte.hu>


on !CONFIG_SYSCTL on x86 with latest -git i get:

     mm/hugetlb.c: In function 'decrement_hugepage_resv_vma':
     mm/hugetlb.c:83: error: 'reserve' undeclared (first use in this function)
     mm/hugetlb.c:83: error: (Each undeclared identifier is reported only once
     mm/hugetlb.c:83: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-build-failure mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-build-failure
+++ a/mm/hugetlb.c
@@ -1026,6 +1026,17 @@ static void __init report_hugepages(void
 	}
 }
 
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
@@ -1375,17 +1386,6 @@ static int __init hugetlb_default_setup(
 }
 __setup("default_hugepagesz=", hugetlb_default_setup);
 
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
introduce-have_efficient_unaligned_access-kconfig-symbol.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
inflate-refactor-inflate-malloc-code.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
gpiolib-allow-user-selection.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
ptrace-give-more-respect-to-sigkill.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
calgary-iommu-use-the-first-kernels-tce-tables-in-kdump.patch
markers-use-rcu_barrier_sched-and-call_rcu_sched.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
mm-hugetlbc-fix-build-failure.patch
signalfd-fix-undefined-reference-to-compat_sys_signalfd4.patch
linux-next.patch
x86-pci-replace-dbg-with-pr_debug.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
migrate_timers-add-comment-use-spinlock_irq.patch
firmware-fix-memmap-printk-format-warnings.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch
acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
mmu-notifiers-add-list_del_init_rcu.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
x86-use-generic-show_mem.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
likely-profiling-disable-ftrace.patch

