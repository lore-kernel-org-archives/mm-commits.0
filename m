From: akpm@linux-foundation.org
Subject: + signals-__group_complete_signal-cache-the-value-of-p-signal.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:32:37 -0800
Message-ID: <200803060132.m261Wb3I002318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765776AbYCFBdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: __group_complete_signal: cache the value of p->signal
has been added to the -mm tree.  Its filename is
     signals-__group_complete_signal-cache-the-value-of-p-signal.patch

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
Subject: signals: __group_complete_signal: cache the value of p->signal
From: Oleg Nesterov <oleg@tv-sign.ru>

Cosmetic, cache p->signal to make the code a bit more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-__group_complete_signal-cache-the-value-of-p-signal kernel/signal.c
--- a/kernel/signal.c~signals-__group_complete_signal-cache-the-value-of-p-signal
+++ a/kernel/signal.c
@@ -842,6 +842,7 @@ static inline int wants_signal(int sig, 
 static void
 __group_complete_signal(int sig, struct task_struct *p)
 {
+	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
 	/*
@@ -862,14 +863,14 @@ __group_complete_signal(int sig, struct 
 		/*
 		 * Otherwise try to find a suitable thread.
 		 */
-		t = p->signal->curr_target;
+		t = signal->curr_target;
 		if (t == NULL)
 			/* restart balancing at this thread */
-			t = p->signal->curr_target = p;
+			t = signal->curr_target = p;
 
 		while (!wants_signal(sig, t)) {
 			t = next_thread(t);
-			if (t == p->signal->curr_target)
+			if (t == signal->curr_target)
 				/*
 				 * No thread needs to be woken.
 				 * Any eligible threads will see
@@ -877,14 +878,14 @@ __group_complete_signal(int sig, struct 
 				 */
 				return;
 		}
-		p->signal->curr_target = t;
+		signal->curr_target = t;
 	}
 
 	/*
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(p->signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -897,9 +898,9 @@ __group_complete_signal(int sig, struct 
 			 * running and doing things after a slower
 			 * thread has the fatal signal pending.
 			 */
-			p->signal->flags = SIGNAL_GROUP_EXIT;
-			p->signal->group_exit_code = sig;
-			p->signal->group_stop_count = 0;
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = sig;
+			signal->group_stop_count = 0;
 			t = p;
 			do {
 				sigaddset(&t->pending.signal, SIGKILL);
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
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
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

