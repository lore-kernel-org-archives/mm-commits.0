From: akpm@linux-foundation.org
Subject: + sched-make-cpu_clock-not-use-the-rq-clock.patch added to -mm tree
Date: Thu, 26 Jul 2007 02:06:06 -0700
Message-ID: <200707260906.l6Q966Av023851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982AbXGZJGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 05:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     sched: make cpu_clock() not use the rq clock
has been added to the -mm tree.  Its filename is
     sched-make-cpu_clock-not-use-the-rq-clock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-kvm.patch
fix-theoretical-ccids_readwrite_lock-race.patch
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
blktrace-use-cpu_clock-instead-of-sched_clock.patch
sched-make-cpu_clock-not-use-the-rq-clock.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
time-simplify-smp_call_function_single-call-sequence.patch
sched-add-above-background-load-function.patch
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
