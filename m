From: akpm@linux-foundation.org
Subject: [merged] exit-reparent-introduce-find_child_reaper.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:08:34 -0800
Message-ID: <5489ebb2.2i4l027kwiDWoa3h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLKTIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: introduce find_child_reaper()
has been removed from the -mm tree.  Its filename was
     exit-reparent-introduce-find_child_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -459,6 +459,34 @@ static void exit_mm(struct task_struct *
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
@@ -466,33 +494,17 @@ static void exit_mm(struct task_struct *
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
@@ -501,7 +513,7 @@ static struct task_struct *find_new_reap
 		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     !same_thread_group(reaper, pid_ns->child_reaper);
+		     !same_thread_group(reaper, child_reaper);
 		     reaper = reaper->real_parent) {
 			/* call_usermodehelper() descendants need this check */
 			if (reaper == &init_task)
@@ -515,7 +527,7 @@ static struct task_struct *find_new_reap
 		}
 	}
 
-	return pid_ns->child_reaper;
+	return child_reaper;
 }
 
 /*
@@ -552,7 +564,9 @@ static void forget_original_parent(struc
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

