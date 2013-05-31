From: akpm@linux-foundation.org
Subject: +
 include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch added to -mm tree
Date: Fri, 31 May 2013 13:59:53 -0700
Message-ID: <51a90f49.bOhPZEfTq3NV/WUv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3EaU7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:59:53 -0700


The patch titled
     Subject: include/linux/sched.h: don't use task->pid/tgid in same_thread_group/has_group_leader_pid
has been added to the -mm tree.  Its filename is
     include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch

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
Subject: include/linux/sched.h: don't use task->pid/tgid in same_thread_group/has_group_leader_pid

task_struct->pid/tgid should go away.

1. Change same_thread_group() to use task->signal for comparison.

2. Change has_group_leader_pid(task) to compare task_pid(task) with
   signal->leader_pid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Dyasly <dserrg@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid include/linux/sched.h
--- a/include/linux/sched.h~include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid
+++ a/include/linux/sched.h
@@ -2179,15 +2179,15 @@ static inline bool thread_group_leader(s
  * all we care about is that we have a task with the appropriate
  * pid, we don't actually care if we have the right task.
  */
-static inline int has_group_leader_pid(struct task_struct *p)
+static inline bool has_group_leader_pid(struct task_struct *p)
 {
-	return p->pid == p->tgid;
+	return task_pid(p) == p->signal->leader_pid;
 }
 
 static inline
-int same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->tgid == p2->tgid;
+	return p1->signal == p2->signal;
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
_

Patches currently in -mm which might be from oleg@redhat.com are

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
fs-execc-do_execve_common-use-current_user.patch

