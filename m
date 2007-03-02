From: akpm@linux-foundation.org
Subject: + kvm-t60-resume-fix.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:28:19 -0800
Message-ID: <200703022228.l22MSJ5L020927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44386 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030648AbXCBW2h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:28:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, avi@qumranet.com


The patch titled
     KVM: T60 resume fix
has been added to the -mm tree.  Its filename is
     kvm-t60-resume-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: T60 resume fix
From: Ingo Molnar <mingo@elte.hu>

My T60 laptop does not resume correctly due to KVM attempting to send an
IPI to a CPU that might be down (or not up yet).  (Doing so also triggers
the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 732.)

with this fix applied my laptop does not hang during resume.

[ KVM will have to disable/enable virtualization on the CPU itself that
  goes down / comes up, not via an IPI sent from the requesting CPU. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-t60-resume-fix drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-t60-resume-fix
+++ a/drivers/kvm/kvm_main.c
@@ -2083,12 +2083,6 @@ static int kvm_cpu_hotplug(struct notifi
 	case CPU_DEAD:
 	case CPU_UP_CANCELED:
 		decache_vcpus_on_cpu(cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
-					 NULL, 0, 1);
-		break;
-	case CPU_UP_PREPARE:
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
-					 NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
sched-remove-smt-nice.patch
fix-nmi-appears-to-be-stuck.patch
kvm-t60-resume-fix.patch
git-kvm.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
fully-honor-vdso_enabled.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
