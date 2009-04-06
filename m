From: akpm@linux-foundation.org
Subject: [merged] reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:46 -0700
Message-ID: <200904061935.n36JZkJR012199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757840AbZDFTjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     reparent_thread: fix a zombie leak if /sbin/init ignores SIGCHLD
has been removed from the -mm tree.  Its filename was
     reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -810,8 +810,11 @@ static void ptrace_exit_finish(struct ta
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
@@ -819,12 +822,12 @@ static void reparent_thread(struct task_
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
@@ -832,11 +835,19 @@ static void reparent_thread(struct task_
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
@@ -896,7 +907,8 @@ static void forget_original_parent(struc
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
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

