From: akpm@linux-foundation.org
Subject: [merged]
 kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:09 -0700
Message-ID: <51db14a9.dX5vqlJdiM7popnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GHTgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:09 -0700


The patch titled
     Subject: kernel/fork.c:copy_process(): don't add the uninitialized child to thread/task/pid lists
has been removed from the -mm tree.  Its filename was
     kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/fork.c:copy_process(): don't add the uninitialized child to thread/task/pid lists

copy_process() adds the new child to thread_group/init_task.tasks list and
then does attach_pid(child, PIDTYPE_PID).  This means that the lockless
next_thread() or next_task() can see this thread with the wrong pid.  Say,
"ls /proc/pid/task" can list the same inode twice.

We could move attach_pid(child, PIDTYPE_PID) up, but in this case
find_task_by_vpid() can find the new thread before it was fully
initialized.

And this is already true for PIDTYPE_PGID/PIDTYPE_SID, With this patch
copy_process() initializes child->pids[*].pid first, then calls
attach_pid() to insert the task into the pid->tasks list.

attach_pid() no longer need the "struct pid*" argument, it is always
called after pid_link->pid was already set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    6 ++----
 kernel/fork.c       |   16 +++++++++++++---
 kernel/pid.c        |   12 ++++--------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff -puN include/linux/pid.h~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists include/linux/pid.h
--- a/include/linux/pid.h~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists
+++ a/include/linux/pid.h
@@ -86,11 +86,9 @@ extern struct task_struct *get_pid_task(
 extern struct pid *get_task_pid(struct task_struct *task, enum pid_type type);
 
 /*
- * attach_pid() and detach_pid() must be called with the tasklist_lock
- * write-held.
+ * these helpers must be called with the tasklist_lock write-held.
  */
-extern void attach_pid(struct task_struct *task, enum pid_type type,
-			struct pid *pid);
+extern void attach_pid(struct task_struct *task, enum pid_type);
 extern void detach_pid(struct task_struct *task, enum pid_type);
 extern void change_pid(struct task_struct *task, enum pid_type,
 			struct pid *pid);
diff -puN kernel/fork.c~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists
+++ a/kernel/fork.c
@@ -1121,6 +1121,12 @@ static void posix_cpu_timers_init(struct
 	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
 }
 
+static inline void
+init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
+{
+	 task->pids[type].pid = pid;
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1449,7 +1455,11 @@ static struct task_struct *copy_process(
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
+		init_task_pid(p, PIDTYPE_PID, pid);
 		if (thread_group_leader(p)) {
+			init_task_pid(p, PIDTYPE_PGID, task_pgrp(current));
+			init_task_pid(p, PIDTYPE_SID, task_session(current));
+
 			if (is_child_reaper(pid)) {
 				ns_of_pid(pid)->child_reaper = p;
 				p->signal->flags |= SIGNAL_UNKILLABLE;
@@ -1457,10 +1467,10 @@ static struct task_struct *copy_process(
 
 			p->signal->leader_pid = pid;
 			p->signal->tty = tty_kref_get(current->signal->tty);
-			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
-			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
+			attach_pid(p, PIDTYPE_PGID);
+			attach_pid(p, PIDTYPE_SID);
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
@@ -1470,7 +1480,7 @@ static struct task_struct *copy_process(
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
 		}
-		attach_pid(p, PIDTYPE_PID, pid);
+		attach_pid(p, PIDTYPE_PID);
 		nr_threads++;
 	}
 
diff -puN kernel/pid.c~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists kernel/pid.c
--- a/kernel/pid.c~kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists
+++ a/kernel/pid.c
@@ -373,14 +373,10 @@ EXPORT_SYMBOL_GPL(find_vpid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-void attach_pid(struct task_struct *task, enum pid_type type,
-		struct pid *pid)
+void attach_pid(struct task_struct *task, enum pid_type type)
 {
-	struct pid_link *link;
-
-	link = &task->pids[type];
-	link->pid = pid;
-	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
+	struct pid_link *link = &task->pids[type];
+	hlist_add_head_rcu(&link->node, &link->pid->tasks[type]);
 }
 
 static void __change_pid(struct task_struct *task, enum pid_type type,
@@ -412,7 +408,7 @@ void change_pid(struct task_struct *task
 		struct pid *pid)
 {
 	__change_pid(task, type, pid);
-	attach_pid(task, type, pid);
+	attach_pid(task, type);
 }
 
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

