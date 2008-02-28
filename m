From: akpm@linux-foundation.org
Subject: - handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont.patch removed from -mm tree
Date: Thu, 28 Feb 2008 13:10:54 -0800
Message-ID: <200802282110.m1SLAsUT020514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759851AbYB1VMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 16:12:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     handle_stop_signal: don't wake up the stopped task until it sees SIGCONT
has been removed from the -mm tree.  Its filename was
     handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: handle_stop_signal: don't wake up the stopped task until it sees SIGCONT
From: Oleg Nesterov <oleg@tv-sign.ru>

The bug was found by Jiri Kosina and the patch is based on his ideas.

handle_stop_signal(SIGCONT) wakes up the stopped task and unlocks ->siglock
for do_notify_parent_cldstop(p, CLD_CONTINUED).  The woken task returns from
do_signal_stop(), takes ->siglock and resumes to user-space without actually
seeing SIGCONT which may have a handler.

Move the code realated to do_notify_parent_cldstop(CLD_CONTINUED) up, before
"wake_up_state(t, state)".

NOTE: It is possible that the subsequent rm_from_queue(SIG_KERNEL_STOP_MASK)
removes SIGSTOP which comes after SIGCONT when we drop ->siglock.  Not nice,
but possible even without this change.  Hopefully we can remove the parent
notifying code from the sender path completely, but this needs more thinking.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Roland McGrath <roland@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN kernel/signal.c~handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont kernel/signal.c
--- a/kernel/signal.c~handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont
+++ a/kernel/signal.c
@@ -600,12 +600,31 @@ static void handle_stop_signal(int sig, 
 			do_notify_parent_cldstop(p, CLD_STOPPED);
 			spin_lock(&p->sighand->siglock);
 		}
+
+		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
+			/*
+			 * We were in fact stopped, and are now continued.
+			 * Notify the parent with CLD_CONTINUED.
+			 */
+			p->signal->flags = SIGNAL_STOP_CONTINUED;
+			p->signal->group_exit_code = 0;
+			spin_unlock(&p->sighand->siglock);
+			do_notify_parent_cldstop(p, CLD_CONTINUED);
+			spin_lock(&p->sighand->siglock);
+		} else {
+			/*
+			 * We are not stopped, but there could be a stop
+			 * signal in the middle of being processed after
+			 * being removed from the queue.  Clear that too.
+			 */
+			p->signal->flags = 0;
+		}
+
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -629,25 +648,6 @@ static void handle_stop_signal(int sig, 
 
 			t = next_thread(t);
 		} while (t != p);
-
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
-		} else {
-			/*
-			 * We are not stopped, but there could be a stop
-			 * signal in the middle of being processed after
-			 * being removed from the queue.  Clear that too.
-			 */
-			p->signal->flags = 0;
-		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
handle_stop_signal-dont-wake-up-the-stopped-task-until-it-sees-sigcont.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

