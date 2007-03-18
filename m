From: akpm@linux-foundation.org
Subject: - futex-pi-state-locking-fix.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:05 -0800
Message-ID: <200703180910.l2I9A53F020063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXCRJL2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, cebbert@redhat.com, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     futex: PI state locking fix
has been removed from the -mm tree.  Its filename was
     futex-pi-state-locking-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex: PI state locking fix
From: Ingo Molnar <mingo@elte.hu>

Testing of -rt by IBM uncovered a locking bug in wake_futex_pi(): the PI
state needs to be locked before we access it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/futex.c~futex-pi-state-locking-fix kernel/futex.c
--- a/kernel/futex.c~futex-pi-state-locking-fix
+++ a/kernel/futex.c
@@ -565,6 +565,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (!pi_state)
 		return -EINVAL;
 
+	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -604,6 +605,7 @@ static int wake_futex_pi(u32 __user *uad
 	pi_state->owner = new_owner;
 	spin_unlock_irq(&new_owner->pi_lock);
 
+	spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
 
 	return 0;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
i386-trust-the-pm-timer-calibration-of-the-local-apic.patch
git-ieee1394.patch
git-kvm.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
