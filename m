From: akpm@linux-foundation.org
Subject: + introduce-kill_orphaned_pgrp-helper.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:11:08 -0800
Message-ID: <200803030811.m238B83E006145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbYCCIMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     pgrp: introduce kill_orphaned_pgrp() helper
has been added to the -mm tree.  Its filename is
     introduce-kill_orphaned_pgrp-helper.patch

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
Subject: pgrp: introduce kill_orphaned_pgrp() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Factor out the common code in reparent_thread() and exit_notify().

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   74 ++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 39 deletions(-)

diff -puN kernel/exit.c~introduce-kill_orphaned_pgrp-helper kernel/exit.c
--- a/kernel/exit.c~introduce-kill_orphaned_pgrp-helper
+++ a/kernel/exit.c
@@ -255,6 +255,37 @@ static int has_stopped_jobs(struct pid *
 	return retval;
 }
 
+/*
+ * Check to see if any process groups have become orphaned as
+ * a result of our exiting, and if they have any stopped jobs,
+ * send them a SIGHUP and then a SIGCONT. (POSIX 3.2.2.2)
+ */
+static void
+kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
+{
+	struct pid *pgrp = task_pgrp(tsk);
+	struct task_struct *ignored_task = tsk;
+
+	if (!parent)
+		 /* exit: our father is in a different pgrp than
+		  * we are and we were the only connection outside.
+		  */
+		parent = tsk->real_parent;
+	else
+		/* reparent: our child is in a different pgrp than
+		 * we are, and it was the only connection outside.
+		 */
+		ignored_task = NULL;
+
+	if (task_pgrp(parent) != pgrp &&
+	    task_session(parent) == task_session(tsk) &&
+	    will_become_orphaned_pgrp(pgrp, ignored_task) &&
+	    has_stopped_jobs(pgrp)) {
+		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
+		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
+	}
+}
+
 /**
  * reparent_to_kthreadd - Reparent the calling kernel thread to kthreadd
  *
@@ -635,22 +666,7 @@ reparent_thread(struct task_struct *p, s
 	    p->exit_signal != -1 && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
-	/*
-	 * process group orphan check
-	 * Case ii: Our child is in a different pgrp
-	 * than we are, and it was the only connection
-	 * outside, so the child pgrp is now orphaned.
-	 */
-	if ((task_pgrp(p) != task_pgrp(father)) &&
-	    (task_session(p) == task_session(father))) {
-		struct pid *pgrp = task_pgrp(p);
-
-		if (will_become_orphaned_pgrp(pgrp, NULL) &&
-		    has_stopped_jobs(pgrp)) {
-			__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
-			__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
-		}
-	}
+	kill_orphaned_pgrp(p, father);
 }
 
 /*
@@ -738,8 +754,6 @@ static void forget_original_parent(struc
 static void exit_notify(struct task_struct *tsk)
 {
 	int state;
-	struct task_struct *t;
-	struct pid *pgrp;
 
 	/*
 	 * This does two things:
@@ -753,25 +767,7 @@ static void exit_notify(struct task_stru
 	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
-	/*
-	 * Check to see if any process groups have become orphaned
-	 * as a result of our exiting, and if they have any stopped
-	 * jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
-	 *
-	 * Case i: Our father is in a different pgrp than we are
-	 * and we were the only connection outside, so our pgrp
-	 * is about to become orphaned.
-	 */
-	t = tsk->real_parent;
-
-	pgrp = task_pgrp(tsk);
-	if ((task_pgrp(t) != pgrp) &&
-	    (task_session(t) == task_session(tsk)) &&
-	    will_become_orphaned_pgrp(pgrp, tsk) &&
-	    has_stopped_jobs(pgrp)) {
-		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
-		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
-	}
+	kill_orphaned_pgrp(tsk, NULL);
 
 	/* Let father know we died
 	 *
@@ -788,8 +784,8 @@ static void exit_notify(struct task_stru
 	 * the same after a fork.
 	 */
 	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
-	    ( tsk->parent_exec_id != t->self_exec_id  ||
-	      tsk->self_exec_id != tsk->parent_exec_id)
+	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
+	     tsk->self_exec_id != tsk->parent_exec_id)
 	    && !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
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
introduce-kill_orphaned_pgrp-helper.patch
will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch
exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch
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

