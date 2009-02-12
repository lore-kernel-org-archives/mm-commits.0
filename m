From: akpm@linux-foundation.org
Subject: [to-be-updated] forget_original_parent-cleanup-ptrace-pathes.patch removed from -mm tree
Date: Wed, 11 Feb 2009 16:13:58 -0800
Message-ID: <200902120013.n1C0DwkN004224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbZBLAOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:14:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     forget_original_parent: cleanup ptrace pathes
has been removed from the -mm tree.  Its filename was
     forget_original_parent-cleanup-ptrace-pathes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forget_original_parent: cleanup ptrace pathes
From: Oleg Nesterov <oleg@redhat.com>

No functional changes.

- Fold ptrace_exit() into forget_original_parent(), it is trivial
  now. More importantly, this makes the code more symmetrical with
  reparent_thread().

- The same for ptrace_exit_finish(), and "ptrace_" is not correct
  any longer.

- "ptrace_dead" doesn't match the reality, rename to "dead_list".

- swap the reparent_thread()'s arguments, just to make it more
  symmetrical with __ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   55 ++++++++++++------------------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff -puN kernel/exit.c~forget_original_parent-cleanup-ptrace-pathes kernel/exit.c
--- a/kernel/exit.c~forget_original_parent-cleanup-ptrace-pathes
+++ a/kernel/exit.c
@@ -773,42 +773,8 @@ int __ptrace_detach(struct task_struct *
 	return 1;
 }
 
-/*
- * Detach all tasks we were using ptrace on.
- * Any that need to be release_task'd are put on the @dead list.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
-		if (__ptrace_detach(parent, p))
-			list_add(&p->ptrace_entry, dead);
-	}
-}
-
-/*
- * Finish up exit-time ptrace cleanup.
- *
- * Called without locks.
- */
-static void ptrace_exit_finish(struct task_struct *parent,
-			       struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	BUG_ON(!list_empty(&parent->ptraced));
-
-	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
-}
-
 /* Returns nonzero if the child should be released. */
-static int reparent_thread(struct task_struct *p, struct task_struct *father)
+static int reparent_thread(struct task_struct *father, struct task_struct *p)
 {
 	int dead;
 
@@ -889,14 +855,17 @@ static struct task_struct *find_new_reap
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper;
-	LIST_HEAD(ptrace_dead);
+	LIST_HEAD(dead_list);
 
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 	/*
 	 * First clean up ptrace if we were using it.
 	 */
-	ptrace_exit(father, &ptrace_dead);
+	list_for_each_entry_safe(p, n, &father->ptraced, ptrace_entry) {
+		if (__ptrace_detach(father, p))
+			list_add(&p->ptrace_entry, &dead_list);
+	}
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
@@ -904,14 +873,18 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		if (reparent_thread(p, father))
-			list_add(&p->ptrace_entry, &ptrace_dead);;
+		if (reparent_thread(father, p))
+			list_add(&p->ptrace_entry, &dead_list);;
 	}
-
 	write_unlock_irq(&tasklist_lock);
+
 	BUG_ON(!list_empty(&father->children));
+	BUG_ON(!list_empty(&father->ptraced));
 
-	ptrace_exit_finish(father, &ptrace_dead);
+	list_for_each_entry_safe(p, n, &dead_list, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
 }
 
 /*
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
forget_original_parent-cleanup-ptrace-pathes.patch
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

