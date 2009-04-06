From: akpm@linux-foundation.org
Subject: [merged] forget_original_parent-do-not-abuse-child-ptrace_entry.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:50 -0700
Message-ID: <200904061935.n36JZoGa012209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758442AbZDFUXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     forget_original_parent: do not abuse child->ptrace_entry
has been removed from the -mm tree.  Its filename was
     forget_original_parent-do-not-abuse-child-ptrace_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: s/childs/children/]
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
+	LIST_HEAD(dead_children);
 
 	exit_ptrace(father);
 
@@ -821,15 +817,14 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		if (reparent_thread(p, father))
-			list_add(&p->ptrace_entry, &ptrace_dead);;
+		reparent_thread(father, p, &dead_children);
 	}
