From: akpm@linux-foundation.org
Subject: + ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:17:43 -0800
Message-ID: <200911122317.nACNHh9Z030785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709AbZKLXSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:18:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de


The patch titled
     ptrace: change tracehook_report_syscall_exit() to handle stepping
has been added to the -mm tree.  Its filename is
     ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: change tracehook_report_syscall_exit() to handle stepping
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

Change tracehook_report_syscall_exit() to look at step flag and send the
trap signal if needed.

This change affects ia64, microblaze, parisc, powerpc, sh.  They pass
nonzero "step" argument to tracehook but since it was ignored the tracee
reports via ptrace_notify(), this is not right and not consistent.

	- PTRACE_SETSIGINFO doesn't work

	- if the tracer resumes the tracee with signr != 0 the new signal
	  is generated rather than delivering it

	- If PT_TRACESYSGOOD is set the tracee reports the wrong exit_code

I don't have a powerpc machine, but I think this test-case should see the
difference:

	#include <unistd.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>
	#include <stdio.h>

	int main(void)
	{
		int pid, status;

		if (!(pid = fork())) {
			assert(ptrace(PTRACE_TRACEME) == 0);
			kill(getpid(), SIGSTOP);

			getppid();

			return 0;
		}

		assert(pid == wait(&status));
		assert(ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_TRACESYSGOOD) == 0);

		assert(ptrace(PTRACE_SYSCALL, pid, 0,0) == 0);
		assert(pid == wait(&status));

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
		assert(pid == wait(&status));

		if (status == 0x57F)
			return 0;

		printf("kernel bug: status=%X shouldn't have 0x80\n", status);
		return 1;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/tracehook.h~ptrace-change-tracehook_report_syscall_exit-to-handle-stepping include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-change-tracehook_report_syscall_exit-to-handle-stepping
+++ a/include/linux/tracehook.h
@@ -134,6 +134,13 @@ static inline __must_check int tracehook
  */
 static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 {
+	if (step) {
+		siginfo_t info;
+		user_single_step_siginfo(current, regs, &info);
+		force_sig_info(SIGTRAP, &info, current);
+		return;
+	}
+
 	ptrace_report_syscall(regs);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
ptrace-copy_process-should-disable-stepping.patch
ptrace-introduce-user_single_step_siginfo-helper.patch
ptrace-powerpc-implement-user_single_step_siginfo.patch
ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch
ptrace-x86-implement-user_single_step_siginfo.patch
ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch
utrace-core.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

