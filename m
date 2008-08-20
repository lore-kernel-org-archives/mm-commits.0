From: akpm@linux-foundation.org
Subject: + posix-timers-simplify-de_thread-exit_itimers-path.patch added to -mm tree
Date: Wed, 20 Aug 2008 12:15:36 -0700
Message-ID: <200808201915.m7KJFafJ026900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205AbYHTTQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 15:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: simplify de_thread()->exit_itimers() path
has been added to the -mm tree.  Its filename is
     posix-timers-simplify-de_thread-exit_itimers-path.patch

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
Subject: posix-timers: simplify de_thread()->exit_itimers() path
From: Oleg Nesterov <oleg@tv-sign.ru>

de_thread() postpones release_task(leader) until after exit_itimers().
This was needed because !SIGEV_THREAD_ID timers could use ->group_leader
without get_task_struct(). With the recent changes we can release the
leader earlier and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rolanda McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~posix-timers-simplify-de_thread-exit_itimers-path fs/exec.c
--- a/fs/exec.c~posix-timers-simplify-de_thread-exit_itimers-path
+++ a/fs/exec.c
@@ -776,7 +776,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	struct task_struct *leader = NULL;
 	int count;
 
 	if (thread_group_empty(tsk))
@@ -814,7 +813,7 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
+		struct task_struct *leader = tsk->group_leader;
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -868,8 +867,9 @@ static int de_thread(struct task_struct 
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
+
+		release_task(leader);
 	}
 
 	sig->group_exit_task = NULL;
@@ -878,8 +878,6 @@ static int de_thread(struct task_struct 
 no_thread_group:
 	exit_itimers(sig);
 	flush_itimer_signals();
-	if (leader)
-		release_task(leader);
 
 	if (atomic_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
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
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

