From: akpm@linux-foundation.org
Subject: + posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:21 -0700
Message-ID: <200808042132.m74LWLJi032002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765053AbYHDVdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: don't switch to ->group_leader if ->it_process dies
has been added to the -mm tree.  Its filename is
     posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch

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
Subject: posix-timers: don't switch to ->group_leader if ->it_process dies
From: Oleg Nesterov <oleg@tv-sign.ru>

posix_timer_event() drops SIGEV_THREAD_ID and switches to ->group_leader
if send_sigqueue() fails.

This is not very useful and doesn't work reliably.  send_sigqueue() can
only fail if ->it_process is dead.  But it can die before it dequeues the
SI_TIMER signal, in that case the timer stops anyway.

Remove this code.  I guess it was needed a long ago to ensure that the
timer is not destroyed when when its creator thread dies.

Q: perhaps it makes sense to change sys_timer_settime() to return an error
if ->it_process is dead?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-dont-switch-to-group_leader-if-it_process-dies kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-dont-switch-to-group_leader-if-it_process-dies
+++ a/kernel/posix-timers.c
@@ -313,6 +313,7 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr, int si_private)
 {
+	int shared, ret;
 	/*
 	 * FIXME: if ->sigq is queued we can race with
 	 * dequeue_signal()->do_schedule_next_timer().
@@ -331,20 +332,10 @@ int posix_timer_event(struct k_itimer *t
 	timr->sigq->info.si_tid = timr->it_id;
 	timr->sigq->info.si_value = timr->it_sigev_value;
 
-	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
-		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
-
-		if (likely(ret >= 0))
-			return ret;
-
-		timr->it_sigev_notify = SIGEV_SIGNAL;
-		leader = timr->it_process->group_leader;
-		put_task_struct(timr->it_process);
-		timr->it_process = leader;
-	}
-
-	return send_sigqueue(timr->sigq, timr->it_process, 1);
+	shared = !(timr->it_sigev_notify & SIGEV_THREAD_ID);
+	ret = send_sigqueue(timr->sigq, timr->it_process, shared);
+	/* If we failed to send the signal the timer stops. */
+	return ret > 0;
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
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
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

