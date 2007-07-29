From: akpm@linux-foundation.org
Subject: - sched-make-cpu_clock-not-use-the-rq-clock.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:31 -0700
Message-ID: <200707290613.l6T6DVKL011205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757510AbXG2GXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: make cpu_clock() not use the rq clock
has been removed from the -mm tree.  Its filename was
     sched-make-cpu_clock-not-use-the-rq-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: make cpu_clock() not use the rq clock
From: Ingo Molnar <mingo@elte.hu>

It is enough to disable interrupts to get the precise rq-clock of the local
CPU.

This also solves an NMI watchdog regression: the NMI watchdog calls
touch_softlockup_watchdog(), which might deadlock on rq->lock if the NMI
hits an rq-locked critical section.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/sched.c~sched-make-cpu_clock-not-use-the-rq-clock kernel/sched.c
--- a/kernel/sched.c~sched-make-cpu_clock-not-use-the-rq-clock
+++ a/kernel/sched.c
@@ -386,13 +386,12 @@ static inline unsigned long long rq_cloc
  */
 unsigned long long cpu_clock(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
 	unsigned long long now;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rq->lock, flags);
-	now = rq_clock(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	local_irq_save(flags);
+	now = rq_clock(cpu_rq(cpu));
+	local_irq_restore(flags);
 
 	return now;
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
slub-add-lock-debugging-check.patch
git-acpi.patch
git-kvm.patch
fix-theoretical-ccids_readwrite_lock-race.patch
pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
cfs-mark-print_cfs_stats-static.patch
time-simplify-smp_call_function_single-call-sequence.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
