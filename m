From: akpm@osdl.org
Subject: - high-res-timers-core-do-itimer-rearming-in-process-context.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:12:34 -0800
Message-ID: <200701250612.l0P6CYlF007820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49161 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404AbXAYGMs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:12:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     high-res timers: core, do itimer rearming in process context
has been removed from the -mm tree.  Its filename was
     high-res-timers-core-do-itimer-rearming-in-process-context.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: high-res timers: core, do itimer rearming in process context
From: Thomas Gleixner <tglx@linutronix.de>

Fix potential setitimer DoS with high-res timers by pushing itimer rearm
processing to process context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/itimer.c |    5 ---
 kernel/signal.c |   58 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 22 deletions(-)

diff -puN kernel/itimer.c~high-res-timers-core-do-itimer-rearming-in-process-context kernel/itimer.c
--- a/kernel/itimer.c~high-res-timers-core-do-itimer-rearming-in-process-context
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
 
diff -puN kernel/signal.c~high-res-timers-core-do-itimer-rearming-in-process-context kernel/signal.c
--- a/kernel/signal.c~high-res-timers-core-do-itimer-rearming-in-process-context
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
+			if (!hrtimer_active(tmr) &&
+			    tsk->signal->it_real_incr.tv64 != 0) {
+				hrtimer_forward(tmr, hrtimer_cb_get_time(tmr),
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
