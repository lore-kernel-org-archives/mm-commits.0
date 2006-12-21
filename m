From: akpm@osdl.org
Subject: + high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch added to -mm tree
Date: Thu, 21 Dec 2006 00:01:48 -0800
Message-ID: <200612210801.kBL81mNJ020383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422828AbWLUICB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 03:02:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     high-res timers: core, do itimer rearming in process context, fix2
has been added to the -mm tree.  Its filename is
     high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

genirq-fix-irq-flow-handler-uninstall.patch
__set_irq_handler-bogus-space.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
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
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch

