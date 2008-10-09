From: akpm@linux-foundation.org
Subject: - posix-timers-always-do-get_task_structtimer-it_process.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:26 -0700
Message-ID: <200810092227.m99MRQWD005954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYJIW1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: always do get_task_struct(timer->it_process)
has been removed from the -mm tree.  Its filename was
     posix-timers-always-do-get_task_structtimer-it_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -866,8 +866,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
@@ -894,8 +893,7 @@ retry_delete:
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

git-tip.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
pid_ns-kill-the-now-unused-task_child_reaper.patch

