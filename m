From: akpm@linux-foundation.org
Subject: + i386-remove-unnecessary-code.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:32:56 -0700
Message-ID: <200707200632.l6K6WuDS011582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbXGTGdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, 76306.1226@compuserve.com, ak@suse.de, oleg@tv-sign.ru


The patch titled
     i386: remove unnecessary code
has been added to the -mm tree.  Its filename is
     i386-remove-unnecessary-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 2 deletions(-)

diff -puN arch/i386/kernel/signal.c~i386-remove-unnecessary-code arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~i386-remove-unnecessary-code
+++ a/arch/i386/kernel/signal.c
@@ -380,7 +380,6 @@ static int setup_frame(int sig, struct k
 	regs->edx = (unsigned long) 0;
 	regs->ecx = (unsigned long) 0;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
@@ -474,7 +473,6 @@ static int setup_rt_frame(int sig, struc
 	regs->edx = (unsigned long) &frame->info;
 	regs->ecx = (unsigned long) &frame->uc;
 
-	set_fs(USER_DS);
 	regs->xds = __USER_DS;
 	regs->xes = __USER_DS;
 	regs->xss = __USER_DS;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
git-sched.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
