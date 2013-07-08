From: akpm@linux-foundation.org
Subject: [merged] signals-eventpoll-do-not-use-sigprocmask.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:35:41 -0700
Message-ID: <51db148d.C59khmXh2rzSEpT0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3GHTfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, normalperson@yhbt.net, jbaron@redhat.com, dvlasenk@redhat.com, oleg@redhat.com

Subject: [merged] signals-eventpoll-do-not-use-sigprocmask.patch removed from -mm tree
To: oleg@redhat.com,dvlasenk@redhat.com,jbaron@redhat.com,normalperson@yhbt.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:41 -0700


The patch titled
     Subject: signals: eventpoll: do not use sigprocmask()
has been removed from the -mm tree.  Its filename was
     signals-eventpoll-do-not-use-sigprocmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1975,8 +1975,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -1993,7 +1993,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
 	}
 
 	return error;
@@ -2020,8 +2020,8 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -2038,7 +2038,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
 	}
 
 	return err;
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

