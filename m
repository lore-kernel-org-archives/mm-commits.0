From: akpm@linux-foundation.org
Subject: [merged] ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:06 -0800
Message-ID: <200912162038.nBGKc6Qc013401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964956AbZLPUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: change tracehook_report_syscall_exit() to handle stepping
has been removed from the -mm tree.  Its filename was
     ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

