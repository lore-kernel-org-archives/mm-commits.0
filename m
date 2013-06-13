From: akpm@linux-foundation.org
Subject: [merged]
 audit-wait_for_auditd-should-use-task_uninterruptible.patch removed from
 -mm tree
Date: Thu, 13 Jun 2013 11:57:38 -0700
Message-ID: <51ba1622.BhrysUzEqwCe7DKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3FMS5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, streeter@redhat.com, stable@vger.kernel.org, eparis@redhat.com, oleg@redhat.com

Subject: [merged] audit-wait_for_auditd-should-use-task_uninterruptible.patch removed from -mm tree
To: oleg@redhat.com,eparis@redhat.com,stable@vger.kernel.org,streeter@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:38 -0700


The patch titled
     Subject: audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
has been removed from the -mm tree.  Its filename was
     audit-wait_for_auditd-should-use-task_uninterruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

audit_log_start() does wait_for_auditd() in a loop until
audit_backlog_wait_time passes or audit_skb_queue has a room.

If signal_pending() is true this becomes a busy-wait loop, schedule() in
TASK_INTERRUPTIBLE won't block.

Thanks to Guy for fully investigating and explaining the problem.

(akpm: that'll cause the system to lock up on a non-preemptible
uniprocessor kernel)

(Guy: "Our customer was in fact running a uniprocessor machine, and they
reported a system hang.")

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Guy Streeter <streeter@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/audit.c~audit-wait_for_auditd-should-use-task_uninterruptible kernel/audit.c
--- a/kernel/audit.c~audit-wait_for_auditd-should-use-task_uninterruptible
+++ a/kernel/audit.c
@@ -1056,7 +1056,7 @@ static inline void audit_get_stamp(struc
 static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_INTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
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

