From: akpm@osdl.org
Subject: + high-res-timers-core-do-itimer-rearming-in-process-context.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:26 -0800
Message-ID: <200612132244.kBDMiQ5G022891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbWLMWog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     high-res timers: core, do itimer rearming in process context
has been added to the -mm tree.  Its filename is
     high-res-timers-core-do-itimer-rearming-in-process-context.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

