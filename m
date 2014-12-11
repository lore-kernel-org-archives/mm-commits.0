From: akpm@linux-foundation.org
Subject: [merged]
 exit-reparent-call-forget_original_parent-under-tasklist_lock.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:43 -0800
Message-ID: <5489ebbb.Ud8NSKbT/VjuMv98%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLKTIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: call forget_original_parent() under tasklist_lock
has been removed from the -mm tree.  Its filename was
     exit-reparent-call-forget_original_parent-under-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: call forget_original_parent() under tasklist_lock

Shift "release dead children" loop from forget_original_parent() to its
caller, exit_notify().  It is safe to reap them even if our parent reaps
us right after we drop tasklist_lock, those children no longer have any
connection to the exiting task.

And this allows us to avoid write_lock_irq(tasklist_lock) right after it
was released by forget_original_parent(), we can simply call it with
tasklist_lock held.

While at it, move the comment about forget_original_parent() up to
this function.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~exit-reparent-call-forget_original_parent-under-tasklist_lock kernel/exit.c
--- a/kernel/exit.c~exit-reparent-call-forget_original_parent-under-tasklist_lock
+++ a/kernel/exit.c
@@ -560,19 +560,26 @@ static void reparent_leader(struct task_
 	kill_orphaned_pgrp(p, father);
 }
 
-static void forget_original_parent(struct task_struct *father)
+/*
+ * This does two things:
+ *
+ * A.  Make init inherit all the child processes
+ * B.  Check to see if any process groups have become orphaned
+ *	as a result of our exiting, and if they have any stopped
+ *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
+ */
+static void forget_original_parent(struct task_struct *father,
+					struct list_head *dead)
 {
-	struct task_struct *p, *t, *n, *reaper;
-	LIST_HEAD(dead_children);
+	struct task_struct *p, *t, *reaper;
 
-	write_lock_irq(&tasklist_lock);
 	if (unlikely(!list_empty(&father->ptraced)))
-		exit_ptrace(father, &dead_children);
+		exit_ptrace(father, dead);
 
 	/* Can drop and reacquire tasklist_lock */
 	reaper = find_child_reaper(father);
 	if (list_empty(&father->children))
-		goto unlock;
+		return;
 
 	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
@@ -590,16 +597,9 @@ static void forget_original_parent(struc
 		 * notify anyone anything has happened.
 		 */
 		if (!same_thread_group(reaper, father))
-			reparent_leader(father, p, &dead_children);
+			reparent_leader(father, p, dead);
 	}
 	list_splice_tail_init(&father->children, &reaper->children);
- unlock:
-	write_unlock_irq(&tasklist_lock);
-
-	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
 }
 
 /*
@@ -609,18 +609,12 @@ static void forget_original_parent(struc
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	bool autoreap;
-
-	/*
-	 * This does two things:
-	 *
-	 * A.  Make init inherit all the child processes
-	 * B.  Check to see if any process groups have become orphaned
-	 *	as a result of our exiting, and if they have any stopped
-	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
-	 */
-	forget_original_parent(tsk);
+	struct task_struct *p, *n;
+	LIST_HEAD(dead);
 
 	write_lock_irq(&tasklist_lock);
+	forget_original_parent(tsk, &dead);
+
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
@@ -644,6 +638,11 @@ static void exit_notify(struct task_stru
 		wake_up_process(tsk->signal->group_exit_task);
 	write_unlock_irq(&tasklist_lock);
 
+	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
+
 	/* If the process is dead, release it - nobody will wait for it */
 	if (autoreap)
 		release_task(tsk);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

