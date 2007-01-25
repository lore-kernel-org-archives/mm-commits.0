From: akpm@osdl.org
Subject: - high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:12:37 -0800
Message-ID: <200701250612.l0P6CbWY007833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbXAYGMn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:12:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     high-res timers: core, do itimer rearming in process context, fix2
has been removed from the -mm tree.  Its filename was
     high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: high-res timers: core, do itimer rearming in process context, fix2
From: Thomas Gleixner <tglx@linutronix.de>

The rearming code in signal.c has to read the time and can not rely on the
timer->base->softirq time anymore, as it is not longer running in softirq
context.

Ensure, that the it_real_incr variable in the shared signal struct is set
to zero, when setitimer disables the itimer.  Otherwise it could happen
that an inactive itimer gets rearmed by a SIGALRM.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/itimer.c |    9 ++++++---
 kernel/signal.c |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN kernel/itimer.c~high-res-timers-core-do-itimer-rearming-in-process-context-fix2 kernel/itimer.c
--- a/kernel/itimer.c~high-res-timers-core-do-itimer-rearming-in-process-context-fix2
+++ a/kernel/itimer.c
@@ -226,11 +226,14 @@ again:
 			spin_unlock_irq(&tsk->sighand->siglock);
 			goto again;
 		}
-		tsk->signal->it_real_incr =
-			timeval_to_ktime(value->it_interval);
 		expires = timeval_to_ktime(value->it_value);
-		if (expires.tv64 != 0)
+		if (expires.tv64 != 0) {
+			tsk->signal->it_real_incr =
+				timeval_to_ktime(value->it_interval);
 			hrtimer_start(timer, expires, HRTIMER_MODE_REL);
+		} else
+			tsk->signal->it_real_incr.tv64 = 0;
+
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
diff -puN kernel/signal.c~high-res-timers-core-do-itimer-rearming-in-process-context-fix2 kernel/signal.c
--- a/kernel/signal.c~high-res-timers-core-do-itimer-rearming-in-process-context-fix2
+++ a/kernel/signal.c
@@ -477,7 +477,7 @@ int dequeue_signal(struct task_struct *t
 
 			if (!hrtimer_active(tmr) &&
 			    tsk->signal->it_real_incr.tv64 != 0) {
-				hrtimer_forward(tmr, hrtimer_cb_get_time(tmr),
+				hrtimer_forward(tmr, tmr->base->get_time(),
 						tsk->signal->it_real_incr);
 				hrtimer_restart(tmr);
 			}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
