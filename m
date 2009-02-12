From: akpm@linux-foundation.org
Subject: + forget_original_parent-do-not-abuse-child-ptrace_entry.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:19:39 -0800
Message-ID: <200902120019.n1C0JeKR012186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZBLAVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com


The patch titled
     forget_original_parent: do not abuse child->ptrace_entry
has been added to the -mm tree.  Its filename is
     forget_original_parent-do-not-abuse-child-ptrace_entry.patch

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
Subject: forget_original_parent: do not abuse child->ptrace_entry
From: Oleg Nesterov <oleg@redhat.com>

By discussion with Roland.

- Use ->sibling instead of ->ptrace_entry to chain the need to be
  release_task'd childs. Nobody else can use ->sibling, this task
  is EXIT_DEAD and nobody can find it on its own list.

- rename ptrace_dead to dead_childs.

- Now that we don't have the "parallel" untrace code, change back
  reparent_thread() to return void, pass dead_childs as an argument.

Actually, I don't understand why do we notify /sbin/init when we
reparent a zombie, probably it is better to reap it unconditionally.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   87 ++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 46 deletions(-)

diff -puN kernel/exit.c~forget_original_parent-do-not-abuse-child-ptrace_entry kernel/exit.c
--- a/kernel/exit.c~forget_original_parent-do-not-abuse-child-ptrace_entry
+++ a/kernel/exit.c
@@ -726,46 +726,6 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-/* Returns nonzero if the child should be released. */
-static int reparent_thread(struct task_struct *p, struct task_struct *father)
-{
-	int dead;
-
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
-	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (task_detached(p))
-		return 0;
-	/* If this is a threaded reparent there is no need to
-	 * notify anyone anything has happened.
-	 */
-	if (same_thread_group(p->real_parent, father))
-		return 0;
-
-	/* We don't want people slaying init.  */
-	p->exit_signal = SIGCHLD;
-
-	/* If we'd notified the old parent about this child's death,
-	 * also notify the new parent.
-	 */
-	dead = 0;
-	if (!p->ptrace &&
-	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
-		do_notify_parent(p, p->exit_signal);
-		if (task_detached(p)) {
-			p->exit_state = EXIT_DEAD;
-			dead = 1;
-		}
-	}
-
-	kill_orphaned_pgrp(p, father);
-
-	return dead;
-}
-
 /*
  * When we die, we re-parent all our children.
  * Try to give them to another thread in our thread
@@ -805,10 +765,46 @@ static struct task_struct *find_new_reap
 	return pid_ns->child_reaper;
 }
 
+/*
+* Any that need to be release_task'd are put on the @dead list.
+ */
+static void reparent_thread(struct task_struct *father, struct task_struct *p,
+				struct list_head *dead)
+{
+	if (p->pdeath_signal)
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
+	list_move_tail(&p->sibling, &p->real_parent->children);
+
+	if (task_detached(p))
+		return;
+	/*
+	 * If this is a threaded reparent there is no need to
+	 * notify anyone anything has happened.
+	 */
+	if (same_thread_group(p->real_parent, father))
+		return;
+
+	/* We don't want people slaying init.  */
+	p->exit_signal = SIGCHLD;
+
+	/* If it has exited notify the new parent about this child's death. */
+	if (!p->ptrace &&
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
+		do_notify_parent(p, p->exit_signal);
+		if (task_detached(p)) {
+			p->exit_state = EXIT_DEAD;
+			list_move_tail(&p->sibling, dead);
+		}
+	}
+
+	kill_orphaned_pgrp(p, father);
+}
+
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper;
-	LIST_HEAD(ptrace_dead);
+	LIST_HEAD(dead_childs);
 
 	exit_ptrace(father);
 
@@ -821,15 +817,14 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		if (reparent_thread(p, father))
-			list_add(&p->ptrace_entry, &ptrace_dead);;
+		reparent_thread(father, p, &dead_childs);
 	}
-
 	write_unlock_irq(&tasklist_lock);
+
 	BUG_ON(!list_empty(&father->children));
 
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
+	list_for_each_entry_safe(p, n, &dead_childs, sibling) {
+		list_del_init(&p->sibling);
 		release_task(p);
 	}
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

