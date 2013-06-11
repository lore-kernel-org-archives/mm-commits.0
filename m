From: akpm@linux-foundation.org
Subject: +
 kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch added to -mm tree
Date: Tue, 11 Jun 2013 14:12:58 -0700
Message-ID: <51b792da.2iEzu5yjgTXFZu33%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3FKVM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 17:12:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 14:12:58 -0700


The patch titled
     Subject: kernel/fork.c:copy_process(): don't add the uninitialized child to thread/task/pid lists
has been added to the -mm tree.  Its filename is
     kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch

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
@@ -1117,6 +1117,12 @@ static void posix_cpu_timers_init(struct
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
@@ -1445,7 +1451,11 @@ static struct task_struct *copy_process(
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
@@ -1453,10 +1463,10 @@ static struct task_struct *copy_process(
 
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
@@ -1466,7 +1476,7 @@ static struct task_struct *copy_process(
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

linux-next.patch
audit-wait_for_auditd-should-use-task_uninterruptible.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
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
x86-kill-tif_debug.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
usermodehelper-kill-the-sub_info-path-check.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
wait-introduce-wait_event_commonwq-condition-state-timeout.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch

