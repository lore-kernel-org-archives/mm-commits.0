From: akpm@linux-foundation.org
Subject: - hrtimers-prevent-possible-itimer-dos.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:17 -0800
Message-ID: <200702170715.l1H7FHgI021610@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946449AbXBQHVy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:21:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: prevent possible itimer DoS
has been removed from the -mm tree.  Its filename was
     hrtimers-prevent-possible-itimer-dos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
