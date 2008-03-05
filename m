From: akpm@linux-foundation.org
Subject: + handle_stop_signal-use-the-cached-p-signal-value.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:36:17 -0800
Message-ID: <200803052336.m25NaHOX027435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbYCEXha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com


The patch titled
     handle_stop_signal: use the cached p->signal value
has been added to the -mm tree.  Its filename is
     handle_stop_signal-use-the-cached-p-signal-value.patch

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
Subject: handle_stop_signal: use the cached p->signal value
From: Oleg Nesterov <oleg@tv-sign.ru>

Cache the value of p->signal, and change the code to use while_each_thread()
helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN kernel/signal.c~handle_stop_signal-use-the-cached-p-signal-value kernel/signal.c
--- a/kernel/signal.c~handle_stop_signal-use-the-cached-p-signal-value
+++ a/kernel/signal.c
@@ -566,9 +566,10 @@ static void do_notify_parent_cldstop(str
  */
 static void handle_stop_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (p->signal->flags & SIGNAL_GROUP_EXIT)
+	if (signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * The process is in the middle of dying already.
 		 */
@@ -578,19 +579,18 @@ static void handle_stop_signal(int sig, 
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
-		rm_from_queue(sigmask(SIGCONT), &p->signal->shared_pending);
+		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
 		t = p;
 		do {
 			rm_from_queue(sigmask(SIGCONT), &t->pending);
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
+		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
@@ -615,9 +615,7 @@ static void handle_stop_signal(int sig, 
 				state |= TASK_INTERRUPTIBLE;
 			}
 			wake_up_state(t, state);
-
-			t = next_thread(t);
-		} while (t != p);
+		} while_each_thread(p, t);
 
 		/*
 		 * Notify the parent with CLD_CONTINUED if we were stopped.
@@ -628,29 +626,29 @@ static void handle_stop_signal(int sig, 
 		 * CLD_CONTINUED was dropped.
 		 */
 		why = 0;
-		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+		if (signal->flags & SIGNAL_STOP_STOPPED)
 			why |= SIGNAL_CLD_CONTINUED;
-		else if (p->signal->group_stop_count)
+		else if (signal->group_stop_count)
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
-			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
-			p->signal->group_stop_count = 0;
-			p->signal->group_exit_code = 0;
+			signal->flags = why | SIGNAL_STOP_CONTINUED;
+			signal->group_stop_count = 0;
+			signal->group_exit_code = 0;
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
 			 * signal in the middle of being processed after
 			 * being removed from the queue.  Clear that too.
 			 */
-			p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
 		 * is undone by the wakeup for SIGKILL.
 		 */
-		p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
+		signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
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
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

