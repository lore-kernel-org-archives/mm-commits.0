From: akpm@linux-foundation.org
Subject: [merged] exitc-unexport-__set_special_pids.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:59 -0700
Message-ID: <51db149f.cxq3/Jl0mdb7+Tl/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] exitc-unexport-__set_special_pids.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:59 -0700


The patch titled
     Subject: exit.c: unexport __set_special_pids()
has been removed from the -mm tree.  Its filename was
     exitc-unexport-__set_special_pids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit.c: unexport __set_special_pids()

Move __set_special_pids() from exit.c to sys.c close to its single caller
and make it static.

And rename it to set_special_pids(), another helper with this name has
gone away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 kernel/exit.c         |   11 -----------
 kernel/sys.c          |   13 ++++++++++++-
 3 files changed, 12 insertions(+), 14 deletions(-)

diff -puN include/linux/sched.h~exitc-unexport-__set_special_pids include/linux/sched.h
--- a/include/linux/sched.h~exitc-unexport-__set_special_pids
+++ a/include/linux/sched.h
@@ -1950,8 +1950,6 @@ extern struct task_struct *find_task_by_
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
 
-extern void __set_special_pids(struct pid *pid);
-
 /* per-UID process charging. */
 extern struct user_struct * alloc_uid(kuid_t);
 static inline struct user_struct *get_uid(struct user_struct *u)
diff -puN kernel/exit.c~exitc-unexport-__set_special_pids kernel/exit.c
--- a/kernel/exit.c~exitc-unexport-__set_special_pids
+++ a/kernel/exit.c
@@ -312,17 +312,6 @@ kill_orphaned_pgrp(struct task_struct *t
 	}
 }
 
-void __set_special_pids(struct pid *pid)
-{
-	struct task_struct *curr = current->group_leader;
-
-	if (task_session(curr) != pid)
-		change_pid(curr, PIDTYPE_SID, pid);
-
-	if (task_pgrp(curr) != pid)
-		change_pid(curr, PIDTYPE_PGID, pid);
-}
-
 /*
  * Let kernel threads use this to say that they allow a certain signal.
  * Must not be used if kthread was cloned with CLONE_SIGHAND.
diff -puN kernel/sys.c~exitc-unexport-__set_special_pids kernel/sys.c
--- a/kernel/sys.c~exitc-unexport-__set_special_pids
+++ a/kernel/sys.c
@@ -1309,6 +1309,17 @@ out:
 	return retval;
 }
 
+static void set_special_pids(struct pid *pid)
+{
+	struct task_struct *curr = current->group_leader;
+
+	if (task_session(curr) != pid)
+		change_pid(curr, PIDTYPE_SID, pid);
+
+	if (task_pgrp(curr) != pid)
+		change_pid(curr, PIDTYPE_PGID, pid);
+}
+
 SYSCALL_DEFINE0(setsid)
 {
 	struct task_struct *group_leader = current->group_leader;
@@ -1328,7 +1339,7 @@ SYSCALL_DEFINE0(setsid)
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(sid);
+	set_special_pids(sid);
 
 	proc_clear_tty(group_leader);
 
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

