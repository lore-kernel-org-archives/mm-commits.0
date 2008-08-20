From: akpm@linux-foundation.org
Subject: + posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch added to -mm tree
Date: Wed, 20 Aug 2008 12:11:16 -0700
Message-ID: <200808201911.m7KJBGVN026774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbYHTTMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: check ->it_signal instead of ->it_pid to validate the timer
has been added to the -mm tree.  Its filename is
     posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch

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
Subject: posix-timers: check ->it_signal instead of ->it_pid to validate the timer
From: Oleg Nesterov <oleg@tv-sign.ru>

->it_pid (was ->it_process) has also a special meaning: if it is NULL,
the timer is under deletion or it wasn't initialized yet. We can check
->it_signal != NULL instead, this way we can

	- simplify sys_timer_create() a bit

	- remove yet another check from lock_timer()

	- move put_pid(->it_pid) into release_posix_timer() which
	  runs outside of ->it_lock

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer
+++ a/kernel/posix-timers.c
@@ -464,6 +464,7 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
+	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
@@ -480,7 +481,6 @@ sys_timer_create(const clockid_t which_c
 	int new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
-	struct pid *it_pid;
 
 	if (invalid_clockid(which_clock))
 		return -EINVAL;
@@ -532,9 +532,9 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 		rcu_read_lock();
-		it_pid = get_pid(good_sigevent(&event));
+		new_timer->it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!it_pid) {
+		if (!new_timer->it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -542,7 +542,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		it_pid = get_pid(task_tgid(current));
+		new_timer->it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -552,7 +552,6 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_pid = it_pid;
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
@@ -588,7 +587,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_pid && timr->it_signal == current->signal) {
+		if (timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -837,8 +836,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -864,8 +862,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

tracehook-fix-sa_nocldwait.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
fix-setpriorityprio_pgrp-thread-iterator-breakage.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

