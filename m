From: akpm@linux-foundation.org
Subject: + posix-timers-lock_timer-kill-the-bogus-it_id-check.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:24:25 -0700
Message-ID: <200808052024.m75KOQeu021687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761782AbYHEUZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: lock_timer: kill the bogus ->it_id check
has been added to the -mm tree.  Its filename is
     posix-timers-lock_timer-kill-the-bogus-it_id-check.patch

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
Subject: posix-timers: lock_timer: kill the bogus ->it_id check
From: Oleg Nesterov <oleg@tv-sign.ru>

lock_timer() checks that the timer found by idr_find(timer_id) has ->it_id
== timer_id.  This buys nothing.  This check can fail only if
sys_timer_create() unlocked idr_lock after idr_get_new(), but didn't set
->it_id = new_timer_id yet.  But in that case ->it_process == NULL so
lock_timer() can't succeed anyway.

Also remove a couple of unneeded typecasts.

Note that with or without this patch we have a small problem. 
sys_timer_create() doesn't ensure that the result of setting (say)
->it_sigev_notify must be visible if lock_timer() succeeds.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-lock_timer-kill-the-bogus-it_id-check kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-lock_timer-kill-the-bogus-it_id-check
+++ a/kernel/posix-timers.c
@@ -490,8 +490,7 @@ sys_timer_create(const clockid_t which_c
 		goto out;
 	}
 	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, (void *) new_timer,
-			    &new_timer_id);
+	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
 	spin_unlock_irq(&idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
@@ -586,12 +585,12 @@ static struct k_itimer * lock_timer(time
 	 */
 
 	spin_lock_irqsave(&idr_lock, *flags);
-	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
+	timr = idr_find(&posix_timers_id, (int) timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
 
-		if ((timr->it_id != timer_id) || !(timr->it_process) ||
-				!same_thread_group(timr->it_process, current)) {
+		if (!timr->it_process ||
+		    !same_thread_group(timr->it_process, current)) {
 			spin_unlock(&timr->it_lock);
 			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;
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

