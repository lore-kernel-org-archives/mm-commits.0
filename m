From: akpm@linux-foundation.org
Subject: + handle_stop_signal-unify-partial-full-stop-handling.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:36:15 -0800
Message-ID: <200803052336.m25NaF9U027427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbYCEXhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com


The patch titled
     handle_stop_signal: unify partial/full stop handling
has been added to the -mm tree.  Its filename is
     handle_stop_signal-unify-partial-full-stop-handling.patch

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
Subject: handle_stop_signal: unify partial/full stop handling
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that handle_stop_signal() doesn't drop ->siglock, we can't see both
->group_stop_count && SIGNAL_STOP_STOPPED.  Merge two "if" branches.

As Roland pointed out, we never actually needed 2 do_notify_parent_cldstop()
calls.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff -puN kernel/signal.c~handle_stop_signal-unify-partial-full-stop-handling kernel/signal.c
--- a/kernel/signal.c~handle_stop_signal-unify-partial-full-stop-handling
+++ a/kernel/signal.c
@@ -585,33 +585,16 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 	} else if (sig == SIGCONT) {
+		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		if (unlikely(p->signal->group_stop_count > 0)) {
-			/*
-			 * There was a group stop in progress.  We'll
-			 * pretend it finished before we got here.  We are
-			 * obliged to report it to the parent: if the
-			 * SIGSTOP happened "after" this SIGCONT, then it
-			 * would have cleared this pending SIGCONT.  If it
-			 * happened "before" this SIGCONT, then the parent
-			 * got the SIGCHLD about the stop finishing before
-			 * the continue happened.  We do the notification
-			 * now, and it's as if the stop had finished and
-			 * the SIGCHLD was pending on entry to this kill.
-			 */
-			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_STOPPED;
-		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -621,7 +604,7 @@ static void handle_stop_signal(int sig, 
 			 * running the handler.  With the TIF_SIGPENDING
 			 * flag set, the thread will pause and acquire the
 			 * siglock that we hold now and until we've queued
-			 * the pending signal. 
+			 * the pending signal.
 			 *
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
@@ -636,13 +619,23 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_CONTINUED;
+		/*
+		 * Notify the parent with CLD_CONTINUED if we were stopped.
+		 *
+		 * If we were in the middle of a group stop, we pretend it
+		 * was already finished, and then continued. Since SIGCHLD
+		 * doesn't queue we report only CLD_STOPPED, as if the next
+		 * CLD_CONTINUED was dropped.
+		 */
+		why = 0;
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			why |= SIGNAL_CLD_CONTINUED;
+		else if (p->signal->group_stop_count)
+			why |= SIGNAL_CLD_STOPPED;
+
+		if (why) {
+			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
+			p->signal->group_stop_count = 0;
 			p->signal->group_exit_code = 0;
 		} else {
 			/*
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

