From: akpm@linux-foundation.org
Subject: + posix-timers-lock_timer-make-it-readable.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:24:27 -0700
Message-ID: <200808052024.m75KORmL021690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbYHEUZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: lock_timer: make it readable
has been added to the -mm tree.  Its filename is
     posix-timers-lock_timer-make-it-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: lock_timer: make it readable
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.  Imho makes the code much more understandable.  At least this
patch lessens both the source and compiled code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-lock_timer-make-it-readable kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-lock_timer-make-it-readable
+++ a/kernel/posix-timers.c
@@ -575,7 +575,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
@@ -583,23 +583,20 @@ static struct k_itimer * lock_timer(time
 	 * flags part over to the timer lock.  Must not let interrupts in
 	 * while we are moving the lock.
 	 */
-
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-
-		if (!timr->it_process ||
-		    !same_thread_group(timr->it_process, current)) {
-			spin_unlock(&timr->it_lock);
-			spin_unlock_irqrestore(&idr_lock, *flags);
-			timr = NULL;
-		} else
+		if (timr->it_process &&
+		    same_thread_group(timr->it_process, current)) {
 			spin_unlock(&idr_lock);
-	} else
-		spin_unlock_irqrestore(&idr_lock, *flags);
+			return timr;
+		}
+		spin_unlock(&timr->it_lock);
+	}
+	spin_unlock_irqrestore(&idr_lock, *flags);
 
-	return timr;
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
proc-fix-warnings.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

