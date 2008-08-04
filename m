From: akpm@linux-foundation.org
Subject: + posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:25 -0700
Message-ID: <200808042132.m74LWQfJ032008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763948AbYHDVdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: sys_timer_create: remove the buggy PF_EXITING check
has been added to the -mm tree.  Its filename is
     posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch

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
Subject: posix-timers: sys_timer_create: remove the buggy PF_EXITING check
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_timer_create() return -EINVAL if the target thread has PF_EXITING.

This doesn't really make sense, the sub-thread can die right after unlock.
 And in fact, this is just wrong.  Without SIGEV_THREAD_ID good_sigevent()
returns ->group_leader, and it is very possible that the leader is already
dead.  This is OK, we shouldn't return the error in this case.

Remove this check and the comment.  Note that the "process" was found
under tasklist_lock, it must have ->sighand != NULL.

Also, remove a couple of unneeded initializations.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check
+++ a/kernel/posix-timers.c
@@ -475,9 +475,9 @@ sys_timer_create(const clockid_t which_c
 		 timer_t __user * created_timer_id)
 {
 	int error = 0;
-	struct k_itimer *new_timer = NULL;
+	struct k_itimer *new_timer;
 	int new_timer_id;
-	struct task_struct *process = NULL;
+	struct task_struct *process;
 	unsigned long flags;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
@@ -538,32 +538,12 @@ sys_timer_create(const clockid_t which_c
 
 		read_lock(&tasklist_lock);
 		if ((process = good_sigevent(&event))) {
-			/*
-			 * We may be setting up this process for another
-			 * thread.  It may be exiting.  To catch this
-			 * case the we check the PF_EXITING flag.  If
-			 * the flag is not set, the siglock will catch
-			 * him before it is too late (in exit_itimers).
-			 *
-			 * The exec case is a bit more invloved but easy
-			 * to code.  If the process is in our thread
-			 * group (and it must be or we would not allow
-			 * it here) and is doing an exec, it will cause
-			 * us to be killed.  In this case it will wait
-			 * for us to die which means we can finish this
-			 * linkage with our last gasp. I.e. no code :)
-			 */
+			get_task_struct(process);
 			spin_lock_irqsave(&process->sighand->siglock, flags);
-			if (!(process->flags & PF_EXITING)) {
-				get_task_struct(process);
-				new_timer->it_process = process;
-				list_add(&new_timer->list,
-					 &process->signal->posix_timers);
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
-			} else {
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
-				process = NULL;
-			}
+			new_timer->it_process = process;
+			list_add(&new_timer->list,
+				&process->signal->posix_timers);
+			spin_unlock_irqrestore(&process->sighand->siglock, flags);
 		}
 		read_unlock(&tasklist_lock);
 		if (!process) {
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

