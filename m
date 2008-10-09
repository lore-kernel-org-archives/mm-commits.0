From: akpm@linux-foundation.org
Subject: - posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:30 -0700
Message-ID: <200810092227.m99MRUJj005962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbYJIW1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: sys_timer_create: remove the buggy PF_EXITING check
has been removed from the -mm tree.  Its filename was
     posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

