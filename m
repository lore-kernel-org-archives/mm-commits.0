From: akpm@linux-foundation.org
Subject: + reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:21:06 -0800
Message-ID: <200901302021.n0UKL6IW013092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbZA3UVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:21:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com


The patch titled
     reparent_thread: fix a zombie leak if /sbin/init ignores SIGCHLD
has been added to the -mm tree.  Its filename is
     reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reparent_thread: fix a zombie leak if /sbin/init ignores SIGCHLD
From: Oleg Nesterov <oleg@redhat.com>

If /sbin/init ignores SIGCHLD and we re-parent a zombie, it is leaked. 
reparent_thread() does do_notify_parent() which sets ->exit_signal = -1 in
this case.  This means that nobody except us can reap it, the detached
task is not visible to do_wait().

Change reparent_thread() to return a boolean (like __pthread_detach) to
indicate that the thread is dead and must be released.  Also change
forget_original_parent() to add the child to ptrace_dead list in this
case.

The naming becomes insane, the next patch does the cleanup.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld kernel/exit.c
--- a/kernel/exit.c~reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld
+++ a/kernel/exit.c
@@ -804,8 +804,11 @@ static void ptrace_exit_finish(struct ta
 	}
 }
 
-static void reparent_thread(struct task_struct *p, struct task_struct *father)
+/* Returns nonzero if the child should be released. */
+static int reparent_thread(struct task_struct *p, struct task_struct *father)
 {
+	int dead;
+
 	if (p->pdeath_signal)
 		/* We already hold the tasklist_lock here.  */
 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
@@ -813,12 +816,12 @@ static void reparent_thread(struct task_
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	if (task_detached(p))
-		return;
+		return 0;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
 	if (same_thread_group(p->real_parent, father))
-		return;
+		return 0;
 
 	/* We don't want people slaying init.  */
 	p->exit_signal = SIGCHLD;
@@ -826,11 +829,19 @@ static void reparent_thread(struct task_
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
+	dead = 0;
 	if (!p->ptrace &&
-	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
+		if (task_detached(p)) {
+			p->exit_state = EXIT_DEAD;
+			dead = 1;
+		}
+	}
 
 	kill_orphaned_pgrp(p, father);
+
+	return dead;
 }
 
 /*
@@ -890,7 +901,8 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		reparent_thread(p, father);
+		if (reparent_thread(p, father))
+			list_add(&p->ptrace_entry, &ptrace_dead);;
 	}
 
 	write_unlock_irq(&tasklist_lock);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
wait-prevent-exclusive-waiter-starvation.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
kthread-dont-looking-for-a-task-in-create_kthread-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

