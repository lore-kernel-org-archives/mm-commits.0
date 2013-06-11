From: akpm@linux-foundation.org
Subject: + exitc-unexport-__set_special_pids.patch added to -mm tree
Date: Tue, 11 Jun 2013 14:46:57 -0700
Message-ID: <51b79ad1.2ihlR5lrWlAk6k4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3FKVq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 17:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com

Subject: + exitc-unexport-__set_special_pids.patch added to -mm tree
To: oleg@redhat.com,ebiederm@xmission.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 14:46:57 -0700


The patch titled
     Subject: exit.c: unexport __set_special_pids()
has been added to the -mm tree.  Its filename is
     exitc-unexport-__set_special_pids.patch

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
exitc-unexport-__set_special_pids.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
wait-introduce-wait_event_commonwq-condition-state-timeout.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch

