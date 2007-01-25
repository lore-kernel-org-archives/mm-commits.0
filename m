From: akpm@osdl.org
Subject: + hrtimers-prevent-possible-itimer-dos.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:37:05 -0800
Message-ID: <200701250637.l0P6b5So008412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50447 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965577AbXAYGjG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:39:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     hrtimers: prevent possible itimer DoS
has been added to the -mm tree.  Its filename is
     hrtimers-prevent-possible-itimer-dos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hrtimers: prevent possible itimer DoS
From: Thomas Gleixner <tglx@linutronix.de>

Fix potential setitimer DoS with high-res timers by pushing itimer rearm
processing to process context.

[Fixes from: Ingo Molnar <mingo@elte.hu>]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/itimer.c |   14 ++++-------
 kernel/signal.c |   58 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 25 deletions(-)

diff -puN kernel/itimer.c~hrtimers-prevent-possible-itimer-dos kernel/itimer.c
--- a/kernel/itimer.c~hrtimers-prevent-possible-itimer-dos
+++ a/kernel/itimer.c
@@ -135,11 +135,6 @@ enum hrtimer_restart it_real_fn(struct h
 
 	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
 
-	if (sig->it_real_incr.tv64 != 0) {
-		hrtimer_forward(timer, hrtimer_cb_get_time(timer),
-				sig->it_real_incr);
-		return HRTIMER_RESTART;
-	}
 	return HRTIMER_NORESTART;
 }
 
@@ -231,11 +226,14 @@ again:
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
diff -puN kernel/signal.c~hrtimers-prevent-possible-itimer-dos kernel/signal.c
--- a/kernel/signal.c~hrtimers-prevent-possible-itimer-dos
+++ a/kernel/signal.c
@@ -456,26 +456,50 @@ static int __dequeue_signal(struct sigpe
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
 	int signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr)
+	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
+		/*
+		 * itimer signal ?
+		 *
+		 * itimers are process shared and we restart periodic
+		 * itimers in the signal delivery path to prevent DoS
+		 * attacks in the high resolution timer case. This is
+		 * compliant with the old way of self restarting
+		 * itimers, as the SIGALRM is a legacy signal and only
+		 * queued once. Changing the restart behaviour to
+		 * restart the timer in the signal dequeue path is
+		 * reducing the timer noise on heavy loaded !highres
+		 * systems too.
+		 */
+		if (unlikely(signr == SIGALRM)) {
+			struct hrtimer *tmr = &tsk->signal->real_timer;
+
+			if (!hrtimer_is_queued(tmr) &&
+			    tsk->signal->it_real_incr.tv64 != 0) {
+				hrtimer_forward(tmr, tmr->base->get_time(),
+						tsk->signal->it_real_incr);
+				hrtimer_restart(tmr);
+			}
+		}
+	}
 	recalc_sigpending_tsk(tsk);
- 	if (signr && unlikely(sig_kernel_stop(signr))) {
- 		/*
- 		 * Set a marker that we have dequeued a stop signal.  Our
- 		 * caller might release the siglock and then the pending
- 		 * stop signal it is about to process is no longer in the
- 		 * pending bitmasks, but must still be cleared by a SIGCONT
- 		 * (and overruled by a SIGKILL).  So those cases clear this
- 		 * shared flag after we've set it.  Note that this flag may
- 		 * remain set after the signal we return is ignored or
- 		 * handled.  That doesn't matter because its only purpose
- 		 * is to alert stop-signal processing code when another
- 		 * processor has come along and cleared the flag.
- 		 */
- 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
- 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
- 	}
+	if (signr && unlikely(sig_kernel_stop(signr))) {
+		/*
+		 * Set a marker that we have dequeued a stop signal.  Our
+		 * caller might release the siglock and then the pending
+		 * stop signal it is about to process is no longer in the
+		 * pending bitmasks, but must still be cleared by a SIGCONT
+		 * (and overruled by a SIGKILL).  So those cases clear this
+		 * shared flag after we've set it.  Note that this flag may
+		 * remain set after the signal we return is ignored or
+		 * handled.  That doesn't matter because its only purpose
+		 * is to alert stop-signal processing code when another
+		 * processor has come along and cleared the flag.
+		 */
+		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
+			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+	}
 	if ( signr &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
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
