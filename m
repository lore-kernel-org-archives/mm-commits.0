From: akpm@linux-foundation.org
Subject: + posix-timers-sys_timer_create-cleanup-the-error-handling.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:31 -0700
Message-ID: <200808042132.m74LWVQQ032018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1770798AbYHDVlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: sys_timer_create: cleanup the error handling
has been added to the -mm tree.  Its filename is
     posix-timers-sys_timer_create-cleanup-the-error-handling.patch

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
Subject: posix-timers: sys_timer_create: cleanup the error handling
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.

- sys_timer_create() is big and complicated. The code above the "out:"
  label relies on the fact that "error" must be == 0. This is not very
  robust, make the code more explicit. Remove the unneeded initialization
  of error.

- If idr_get_new() succeeds (as it normally should), we check the returned
  value twice. Move the "-EAGAIN" check under "if (error)".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-sys_timer_create-cleanup-the-error-handling kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-sys_timer_create-cleanup-the-error-handling
+++ a/kernel/posix-timers.c
@@ -469,7 +469,7 @@ sys_timer_create(const clockid_t which_c
 		 struct sigevent __user *timer_event_spec,
 		 timer_t __user * created_timer_id)
 {
-	int error = 0;
+	int error;
 	struct k_itimer *new_timer;
 	int new_timer_id;
 	struct task_struct *process;
@@ -493,9 +493,9 @@ sys_timer_create(const clockid_t which_c
 	error = idr_get_new(&posix_timers_id, (void *) new_timer,
 			    &new_timer_id);
 	spin_unlock_irq(&idr_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error) {
+	if (error) {
+		if (error == -EAGAIN)
+			goto retry;
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
@@ -556,6 +556,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
  	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
@@ -563,9 +565,7 @@ sys_timer_create(const clockid_t which_c
 	 * new_timer after the unlock call.
 	 */
 out:
-	if (error)
-		release_posix_timer(new_timer, it_id_set);
-
+	release_posix_timer(new_timer, it_id_set);
 	return error;
 }
 
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

