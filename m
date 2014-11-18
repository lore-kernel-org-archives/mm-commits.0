From: akpm@linux-foundation.org
Subject: + exit-reparent-introduce-find_child_reaper.patch added to -mm
 tree
Date: Tue, 18 Nov 2014 13:50:07 -0800
Message-ID: <546bbf0f.CoF6LXEte6FnGnOd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKRVuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: introduce find_child_reaper()
has been added to the -mm tree.  Its filename is
     exit-reparent-introduce-find_child_reaper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-introduce-find_child_reaper.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-introduce-find_child_reaper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: introduce find_child_reaper()

find_new_reaper() does 2 completely different things.  Not only it finds a
reaper, it also updates pid_ns->child_reaper or kills the whole namespace
if the caller is ->child_reaper.

Now that has_child_subreaper logic doesn't depend on child_reaper check we
can move that pid_ns code into a separate helper.  IMHO this makes the
code more clean, and this allows the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   56 ++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff -puN kernel/exit.c~exit-reparent-introduce-find_child_reaper kernel/exit.c
--- a/kernel/exit.c~exit-reparent-introduce-find_child_reaper
+++ a/kernel/exit.c
@@ -462,6 +462,34 @@ static void exit_mm(struct task_struct *
 	clear_thread_flag(TIF_MEMDIE);
 }
 
+static struct task_struct *find_child_reaper(struct task_struct *father)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(father);
+	struct task_struct *reaper = pid_ns->child_reaper;
+
+	if (likely(reaper != father))
+		return reaper;
+
+	for_each_thread(father, reaper) {
+		if (reaper->flags & PF_EXITING)
+			continue;
+		pid_ns->child_reaper = reaper;
+		return reaper;
+	}
+
+	write_unlock_irq(&tasklist_lock);
+	if (unlikely(pid_ns == &init_pid_ns)) {
+		panic("Attempted to kill init! exitcode=0x%08x\n",
+			father->signal->group_exit_code ?: father->exit_code);
+	}
+	zap_pid_ns_processes(pid_ns);
+	write_lock_irq(&tasklist_lock);
+
+	return father;
+}
+
 /*
  * When we die, we re-parent all our children, and try to:
  * 1. give them to another thread in our thread group, if such a member exists
@@ -469,33 +497,17 @@ static void exit_mm(struct task_struct *
  *    child_subreaper for its children (like a service manager)
  * 3. give it to the init process (PID 1) in our pid namespace
  */
-static struct task_struct *find_new_reaper(struct task_struct *father)
-	__releases(&tasklist_lock)
-	__acquires(&tasklist_lock)
+static struct task_struct *find_new_reaper(struct task_struct *father,
+					   struct task_struct *child_reaper)
 {
-	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
 
 	for_each_thread(father, thread) {
 		if (thread->flags & PF_EXITING)
 			continue;
-		if (unlikely(pid_ns->child_reaper == father))
-			pid_ns->child_reaper = thread;
 		return thread;
 	}
 
-	if (unlikely(pid_ns->child_reaper == father)) {
-		write_unlock_irq(&tasklist_lock);
-		if (unlikely(pid_ns == &init_pid_ns)) {
-			panic("Attempted to kill init! exitcode=0x%08x\n",
-				father->signal->group_exit_code ?:
-					father->exit_code);
-		}
-
-		zap_pid_ns_processes(pid_ns);
-		write_lock_irq(&tasklist_lock);
-	}
-
 	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 		/*
@@ -504,7 +516,7 @@ static struct task_struct *find_new_reap
 		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     !same_thread_group(reaper, pid_ns->child_reaper);
+		     !same_thread_group(reaper, child_reaper);
 		     reaper = reaper->real_parent) {
 			/* call_usermodehelper() descendants need this check */
 			if (reaper == &init_task)
@@ -518,7 +530,7 @@ static struct task_struct *find_new_reap
 		}
 	}
 
-	return pid_ns->child_reaper;
+	return child_reaper;
 }
 
 /*
@@ -555,7 +567,9 @@ static void forget_original_parent(struc
 		exit_ptrace(father, &dead_children);
 
 	/* Can drop and reacquire tasklist_lock */
-	reaper = find_new_reaper(father);
+	reaper = find_child_reaper(father);
+
+	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
_

Patches currently in -mm which might be from oleg@redhat.com are

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
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
linux-next.patch

