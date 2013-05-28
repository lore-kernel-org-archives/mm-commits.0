From: akpm@linux-foundation.org
Subject: + fs-execc-do_execve_common-use-current_user.patch added to -mm
 tree
Date: Tue, 28 May 2013 13:47:07 -0700
Message-ID: <51a517cb.Vz9bHbUrdmWawc4O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3E1UrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, segoon@openwall.com, oleg@redhat.com

Subject: + fs-execc-do_execve_common-use-current_user.patch added to -mm tree
To: oleg@redhat.com,segoon@openwall.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:47:07 -0700


The patch titled
     Subject: fs/exec.c: do_execve_common(): use current_user()
has been added to the -mm tree.  Its filename is
     fs-execc-do_execve_common-use-current_user.patch

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
@@ -1461,7 +1461,6 @@ static int do_execve_common(const char *
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
-	const struct cred *cred = current_cred();
 
 	/*
 	 * We move the actual failure in case of RLIMIT_NPROC excess from
@@ -1470,7 +1469,7 @@ static int do_execve_common(const char *
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

posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
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
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
fs-execc-do_execve_common-use-current_user.patch

