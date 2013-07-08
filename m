From: akpm@linux-foundation.org
Subject: [merged] fs-execc-do_execve_common-use-current_user.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:13 -0700
Message-ID: <51db14ad.X8hD8zhGP8To11US%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3GHTgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, segoon@openwall.com, oleg@redhat.com

Subject: [merged] fs-execc-do_execve_common-use-current_user.patch removed from -mm tree
To: oleg@redhat.com,segoon@openwall.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:13 -0700


The patch titled
     Subject: fs/exec.c: do_execve_common(): use current_user()
has been removed from the -mm tree.  Its filename was
     fs-execc-do_execve_common-use-current_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/exec.c: do_execve_common(): use current_user()

Trivial cleanup.  do_execve_common() can use current_user() and avoid the
unnecessary "struct cred *cred" var.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-do_execve_common-use-current_user fs/exec.c
--- a/fs/exec.c~fs-execc-do_execve_common-use-current_user
+++ a/fs/exec.c
@@ -1464,7 +1464,6 @@ static int do_execve_common(const char *
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
-	const struct cred *cred = current_cred();
 
 	/*
 	 * We move the actual failure in case of RLIMIT_NPROC excess from
@@ -1473,7 +1472,7 @@ static int do_execve_common(const char *
 	 * whether NPROC limit is still exceeded.
 	 */
 	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC)) {
+	    atomic_read(&current_user()->processes) > rlimit(RLIMIT_NPROC)) {
 		retval = -EAGAIN;
 		goto out_ret;
 	}
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

