From: akpm@linux-foundation.org
Subject: + posix-timers-always-do-get_task_structtimer-it_process.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:23 -0700
Message-ID: <200808042132.m74LWNLm032005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763061AbYHDVdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: always do get_task_struct(timer->it_process)
has been added to the -mm tree.  Its filename is
     posix-timers-always-do-get_task_structtimer-it_process.patch

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
Subject: posix-timers: always do get_task_struct(timer->it_process)
From: Oleg Nesterov <oleg@tv-sign.ru>

Change the code to get/put timer->it_process regardless of
SIGEV_THREAD_ID.  This streamlines the create/destroy paths and allows us
to simplify the usage of exit_itimers() in de_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-always-do-get_task_structtimer-it_process kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-always-do-get_task_structtimer-it_process
+++ a/kernel/posix-timers.c
@@ -555,11 +555,10 @@ sys_timer_create(const clockid_t which_c
 			 */
 			spin_lock_irqsave(&process->sighand->siglock, flags);
 			if (!(process->flags & PF_EXITING)) {
+				get_task_struct(process);
 				new_timer->it_process = process;
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-					get_task_struct(process);
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 			} else {
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
@@ -576,6 +575,7 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_signo = SIGALRM;
 		new_timer->it_sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
+		get_task_struct(process);
 		spin_lock_irqsave(&process->sighand->siglock, flags);
 		new_timer->it_process = process;
 		list_add(&new_timer->list, &process->signal->posix_timers);
@@ -868,8 +868,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
@@ -896,8 +895,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
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

