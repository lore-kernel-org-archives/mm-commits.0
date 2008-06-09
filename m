From: akpm@linux-foundation.org
Subject: + sched-sched_clock-lockdep-fix.patch added to -mm tree
Date: Mon, 09 Jun 2008 01:45:29 -0700
Message-ID: <200806090845.m598jTXZ011664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYFIIpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 04:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, sitsofe@yahoo.com


The patch titled
     sched: sched_clock() lockdep fix
has been added to the -mm tree.  Its filename is
     sched-sched_clock-lockdep-fix.patch

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
Subject: sched: sched_clock() lockdep fix
From: Ingo Molnar <mingo@elte.hu>

Sitsofe Wheeler reported a lockdep warning and bisected it down to:

> commit c6531cce6e6e4b99bcda46b6268d6f2d9e30aea4
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon May 12 21:21:14 2008 +0200
>
>     sched: do not trace sched_clock

do not use raw irq flags in cpu_clock() as it causes lockdep to lose
track of the true state of the IRQ flag.

Reported-and-bisected-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-sched_clock-lockdep-fix kernel/sched.c
--- a/kernel/sched.c~sched-sched_clock-lockdep-fix
+++ a/kernel/sched.c
@@ -854,7 +854,7 @@ unsigned long long notrace cpu_clock(int
 	unsigned long long prev_cpu_time, time, delta_time;
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
 	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
 	delta_time = time-prev_cpu_time;
@@ -863,7 +863,7 @@ unsigned long long notrace cpu_clock(int
 		time = __sync_cpu_clock(time, cpu);
 		per_cpu(prev_cpu_time, cpu) = time;
 	}
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	return time;
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
lguest-use-cpu-capability-accessors.patch
x86-remove-unused-variable-loops-in-arch-x86-boot-a20c.patch
x86-fix-longstanding-setupc-printk-format-warning.patch
sched-sched_clock-lockdep-fix.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
provide-rtc_cmos-platform-device-take-2.patch
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
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

