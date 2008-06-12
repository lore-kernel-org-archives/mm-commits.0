From: akpm@linux-foundation.org
Subject: - acpi-fix-drivers-acpi-gluec-build-error.patch removed from -mm tree
Date: Thu, 12 Jun 2008 10:58:27 -0700
Message-ID: <200806121758.m5CHwRnr031473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbYFLR6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 13:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     acpi: fix drivers/acpi/glue.c build error
has been removed from the -mm tree.  Its filename was
     acpi-fix-drivers-acpi-gluec-build-error.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix drivers/acpi/glue.c build error
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build bug:

  drivers/built-in.o: In function `acpi_rtc_init':
  glue.c:(.init.text+0x16c3): undefined reference to `pnp_bus_type'

this tries to use PNP bus infrastructure even in the !PNP case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/acpi/glue.c~acpi-fix-drivers-acpi-gluec-build-error drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~acpi-fix-drivers-acpi-gluec-build-error
+++ a/drivers/acpi/glue.c
@@ -303,6 +303,7 @@ static void rtc_wake_off(struct device *
 
 static struct cmos_rtc_board_info rtc_info;
 
+#ifdef CONFIG_PNP
 
 /* PNP devices are registered in a subsys_initcall();
  * ACPI specifies the PNP IDs to use.
@@ -364,4 +365,6 @@ static int __init acpi_rtc_init(void)
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
 fs_initcall(acpi_rtc_init);
 
+#endif /* CONFIG_PNP */
+
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
fix-x86_64-splat.patch
lguest-use-cpu-capability-accessors.patch
x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch
x86-fix-longstanding-setupc-printk-format-warning.patch
pm-x86-remove-obsolete-pm-definitions-from-nmi-header.patch
sched-sched_clock-lockdep-fix.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
provide-rtc_cmos-platform-device-take-2.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
sched-fix-memory-leak-in-the-cpu-hotplug-handing-logic.patch
sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets.patch
sched-fix-task_wakekill-vs-sigkill-race.patch
__mutex_lock_common-use-signal_pending_state.patch
do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails.patch
x86-fix-lockdep-warning-during-suspend-to-ram.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
pm-boot-time-suspend-selftest.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
introduce-have_efficient_unaligned_access-kconfig-symbol.patch
percpu-introduce-define_per_cpu_page_aligned.patch
remove-argument-from-open_softirq-which-is-always-null.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing.patch
oprofile-multiplexing-checkpatch-fixes.patch
rtc-remove-and-clarify-unneeded-externs.patch
markers-use-rcu_barrier_sched-and-call_rcu_sched.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
x86-implement-pte_special.patch
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
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

