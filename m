From: akpm@linux-foundation.org
Subject: [merged] move-exit_task_namespaces-outside-of-exit_notify.patch
 removed from -mm tree
Date: Mon, 17 Jun 2013 13:10:56 -0700
Message-ID: <51bf6d50.+Xzu7AdlMJ8VSgj7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3FQULC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 16:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, avagin@openvz.org, oleg@redhat.com

Subject: [merged] move-exit_task_namespaces-outside-of-exit_notify.patch removed from -mm tree
To: oleg@redhat.com,avagin@openvz.org,ebiederm@xmission.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 13:10:56 -0700


The patch titled
     Subject: move exit_task_namespaces() outside of exit_notify()
has been removed from the -mm tree.  Its filename was
     move-exit_task_namespaces-outside-of-exit_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: move exit_task_namespaces() outside of exit_notify()

exit_notify() does exit_task_namespaces() after forget_original_parent(). 
This was needed to ensure that ->nsproxy can't be cleared prematurely, an
exiting child we are going to reparent can do do_notify_parent() and use
the parent's (ours) pid_ns.

However, after 32084504 "pidns: use task_active_pid_ns in
do_notify_parent" ->nsproxy != NULL is no longer needed, we rely on
task_active_pid_ns().

Move exit_task_namespaces() from exit_notify() to do_exit(), after
exit_fs() and before exit_task_work().

This solves the problem reported by Andrey, free_ipc_ns()->shm_destroy()
does fput() which needs task_work_add().

Note: this particular problem can be fixed if we change fput(), and that
change makes sense anyway.  But there is another reason to move the
callsite.  The original reason for exit_task_namespaces() from the middle
of exit_notify() was subtle and it has already gone away, now this looks
confusing.  And this allows us do simplify exit_notify(), we can avoid
unlock/lock(tasklist) and we can use ->exit_state instead of PF_EXITING in
forget_original_parent().

Reported-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~move-exit_task_namespaces-outside-of-exit_notify kernel/exit.c
--- a/kernel/exit.c~move-exit_task_namespaces-outside-of-exit_notify
+++ a/kernel/exit.c
@@ -649,7 +649,6 @@ static void exit_notify(struct task_stru
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
 	 */
 	forget_original_parent(tsk);
-	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
 	if (group_dead)
@@ -795,6 +794,7 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
+	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
 	exit_thread();
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

