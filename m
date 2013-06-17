From: akpm@linux-foundation.org
Subject: [merged]
 fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work.patch
 removed from -mm tree
Date: Mon, 17 Jun 2013 13:10:50 -0700
Message-ID: <51bf6d4a.QqtsYZYx44++SeEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3FQUK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 16:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, oleg@redhat.com

Subject: [merged] fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work.patch removed from -mm tree
To: oleg@redhat.com,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 13:10:50 -0700


The patch titled
     Subject: fput: task_work_add() can fail if the caller has passed exit_task_work()
has been removed from the -mm tree.  Its filename was
     fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fput: task_work_add() can fail if the caller has passed exit_task_work()

fput() assumes that it can't be called after exit_task_work() but this is
not true, for example free_ipc_ns()->shm_destroy() can do this.  In this
case fput() silently leaks the file.

Change it to fallback to delayed_fput_work if task_work_add() fails.  The
patch looks complicated but it is not, it changes the code from

	if (PF_KTHREAD) {
		schedule_work(...);
		return;
	}
	task_work_add(...)

to
	if (!PF_KTHREAD) {
		if (!task_work_add(...))
			return;
		/* fallback */
	}
	schedule_work(...);

As for shm_destroy() in particular, we could make another fix but I think
this change makes sense anyway.  There could be another similar user, it
is not safe to assume that task_work_add() can't fail.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/file_table.c~fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work fs/file_table.c
--- a/fs/file_table.c~fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work
+++ a/fs/file_table.c
@@ -306,17 +306,18 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
+		unsigned long flags;
+
 		file_sb_list_del(file);
-		if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
-			unsigned long flags;
-			spin_lock_irqsave(&delayed_fput_lock, flags);
-			list_add(&file->f_u.fu_list, &delayed_fput_list);
-			schedule_work(&delayed_fput_work);
-			spin_unlock_irqrestore(&delayed_fput_lock, flags);
-			return;
+		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+			init_task_work(&file->f_u.fu_rcuhead, ____fput);
+			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
+				return;
 		}
-		init_task_work(&file->f_u.fu_rcuhead, ____fput);
-		task_work_add(task, &file->f_u.fu_rcuhead, true);
+		spin_lock_irqsave(&delayed_fput_lock, flags);
+		list_add(&file->f_u.fu_list, &delayed_fput_list);
+		schedule_work(&delayed_fput_work);
+		spin_unlock_irqrestore(&delayed_fput_lock, flags);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
kernel-sysc-do_sysinfo-use-get_monotonic_boottime.patch
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
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exitc-unexport-__set_special_pids.patch
fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
fs-execc-de_thread-mt-exec-should-update-real_start_time.patch
wait-introduce-wait_event_commonwq-condition-state-timeout.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch

