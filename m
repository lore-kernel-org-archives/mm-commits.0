From: akpm@linux-foundation.org
Subject: - i386-remove-unnecessary-code.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:05 -0700
Message-ID: <200708141914.l7EJE5bv016578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933868AbXHNTV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, 76306.1226@compuserve.com, ak@suse.de, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     i386: remove unnecessary code
has been removed from the -mm tree.  Its filename was
     i386-remove-unnecessary-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: remove unnecessary code
From: Ingo Molnar <mingo@elte.hu>

Oleg Nesterov pointed out that the set_fs() calls in setup_frame()
and setup_rt_frame() were superfluous.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/signal.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/i386/kernel/signal.c~i386-remove-unnecessary-code arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~i386-remove-unnecessary-code
+++ a/arch/i386/kernel/signal.c
@@ -387,7 +387,6 @@ static int setup_frame(int sig, struct k
 	regs->edx = (unsigned long) 0;
 	regs->ecx = (unsigned long) 0;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
@@ -481,7 +480,6 @@ static int setup_rt_frame(int sig, struc
 	regs->edx = (unsigned long) &frame->info;
 	regs->ecx = (unsigned long) &frame->uc;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
_

Patches currently in -mm which might be from mingo@elte.hu are

futex_unlock_pi-hurts-my-brain-and-may-cause.patch
free_irq-fix-debug_shirq-handling.patch
git-acpi.patch
git-kvm.patch
mips-qemu-network-work-again.patch
geode-mfgpt-clock-event-device-support.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
i386-convert-mm_context_t-semaphore-to-a-mutex.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
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
