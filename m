From: akpm@linux-foundation.org
Subject: + signals-eventpoll-do-not-use-sigprocmask.patch added to -mm
 tree
Date: Tue, 25 Jun 2013 13:07:48 -0700
Message-ID: <51c9f894.8jjCH7Iz7+YA9fdu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3FYUHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, normalperson@yhbt.net, jbaron@redhat.com, dvlasenk@redhat.com, oleg@redhat.com

Subject: + signals-eventpoll-do-not-use-sigprocmask.patch added to -mm tree
To: oleg@redhat.com,dvlasenk@redhat.com,jbaron@redhat.com,normalperson@yhbt.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:07:48 -0700


The patch titled
     Subject: signals: eventpoll: do not use sigprocmask()
has been added to the -mm tree.  Its filename is
     signals-eventpoll-do-not-use-sigprocmask.patch

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
Subject: signals: eventpoll: do not use sigprocmask()

sigprocmask() should die. None of the current callers actually
need this strange interface.

Change fs/eventpoll.c to use set_current_blocked(). This also
means we should not worry about SIGKILL/SIGSTOP.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/eventpoll.c~signals-eventpoll-do-not-use-sigprocmask fs/eventpoll.c
--- a/fs/eventpoll.c~signals-eventpoll-do-not-use-sigprocmask
+++ a/fs/eventpoll.c
@@ -1977,8 +1977,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -1995,7 +1995,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
 	}
 
 	return error;
@@ -2022,8 +2022,8 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -2040,7 +2040,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
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

