From: akpm@linux-foundation.org
Subject: + signals-eventpoll-set-saved_sigmask-at-the-start.patch added to -mm tree
Date: Tue, 25 Jun 2013 13:07:49 -0700
Message-ID: <51c9f895.cUUdtlz0CHw5+iWJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3FYUHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, normalperson@yhbt.net, jbaron@redhat.com, dvlasenk@redhat.com, oleg@redhat.com

Subject: + signals-eventpoll-set-saved_sigmask-at-the-start.patch added to -mm tree
To: oleg@redhat.com,dvlasenk@redhat.com,jbaron@redhat.com,normalperson@yhbt.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:07:49 -0700


The patch titled
     Subject: signals: eventpoll: set ->saved_sigmask at the start
has been added to the -mm tree.  Its filename is
     signals-eventpoll-set-saved_sigmask-at-the-start.patch

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
Subject: signals: eventpoll: set ->saved_sigmask at the start

task_struct->saved_sigmask has no meaning unless we return with
set_restore_sigmask() and nobody except current can use it.

This means that sys_epoll_pwait() doesn't need to save ->blocked
into the local var and then memcopy it into ->saved_sigmask, we
can simply set ->saved_sigmask right before set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -puN fs/eventpoll.c~signals-eventpoll-set-saved_sigmask-at-the-start fs/eventpoll.c
--- a/fs/eventpoll.c~signals-eventpoll-set-saved_sigmask-at-the-start
+++ a/fs/eventpoll.c
@@ -1966,23 +1966,23 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		size_t, sigsetsize)
 {
 	int error;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -1990,12 +1990,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (error == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return error;
@@ -2009,25 +2007,25 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			compat_size_t, sigsetsize)
 {
 	long err;
-	compat_sigset_t csigmask;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		compat_sigset_t csigmask;
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(compat_sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -2035,12 +2033,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (err == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (err == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return err;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
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
signals-eventpoll-do-not-use-sigprocmask.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
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
wait-introduce-prepare_to_wait_event.patch

