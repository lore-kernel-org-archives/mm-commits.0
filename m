From: akpm@linux-foundation.org
Subject: +
 ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped.patch added to
 -mm tree
Date: Tue, 24 Mar 2015 14:12:46 -0700
Message-ID: <5511d34e./CYOtbnmTZ2H+T1x%akpm__18712.7832360149$1427231591$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbbCXVMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, labath@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: fix race between ptrace_resume() and wait_task_stopped()
has been added to the -mm tree.  Its filename is
     ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped.patch

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
Subject: ptrace: fix race between ptrace_resume() and wait_task_stopped()

ptrace_resume() is called when the tracee is still __TASK_TRACED.  We set
tracee->exit_code and then wake_up_state() changes tracee->state.  If the
tracer's sub-thread does wait() in between, task_stopped_code(ptrace => T)
wrongly looks like another report from tracee.

This confuses debugger, and since wait_task_stopped() clears ->exit_code
the tracee can miss a signal.

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <sys/wait.h>
	#include <sys/ptrace.h>
	#include <pthread.h>
	#include <assert.h>

	int pid;

	void *waiter(void *arg)
	{
		int stat;

		for (;;) {
			assert(pid == wait(&stat));
			assert(WIFSTOPPED(stat));
			if (WSTOPSIG(stat) == SIGHUP)
				continue;

			assert(WSTOPSIG(stat) == SIGCONT);
			printf("ERR! extra/wrong report:%x\n", stat);
		}
	}

	int main(void)
	{
		pthread_t thread;

		pid = fork();
		if (!pid) {
			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
			for (;;)
				kill(getpid(), SIGHUP);
		}

		assert(pthread_create(&thread, NULL, waiter, NULL) == 0);

		for (;;)
			ptrace(PTRACE_CONT, pid, 0, SIGCONT);

		return 0;
	}

Note for stable: the bug is very old, but without 9899d11f6544 "ptrace:
ensure arch_ptrace/ptrace_request can never race with SIGKILL" the fix
should use lock_task_sighand(child).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Pavel Labath <labath@google.com>
Tested-by: Pavel Labath <labath@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN kernel/ptrace.c~ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped
+++ a/kernel/ptrace.c
@@ -697,6 +697,8 @@ static int ptrace_peek_siginfo(struct ta
 static int ptrace_resume(struct task_struct *child, long request,
 			 unsigned long data)
 {
+	bool need_siglock;
+
 	if (!valid_signal(data))
 		return -EIO;
 
@@ -724,8 +726,26 @@ static int ptrace_resume(struct task_str
 		user_disable_single_step(child);
 	}
 
+	/*
+	 * Change ->exit_code and ->state under siglock to avoid the race
+	 * with wait_task_stopped() in between; a non-zero ->exit_code will
+	 * wrongly look like another report from tracee.
+	 *
+	 * Note that we need siglock even if ->exit_code == data and/or this
+	 * status was not reported yet, the new status must not be cleared by
+	 * wait_task_stopped() after resume.
+	 *
+	 * If data == 0 we do not care if wait_task_stopped() reports the old
+	 * status and clears the code too; this can't race with the tracee, it
+	 * takes siglock after resume.
+	 */
+	need_siglock = data && !thread_group_empty(current);
+	if (need_siglock)
+		spin_lock_irq(&child->sighand->siglock);
 	child->exit_code = data;
 	wake_up_state(child, __TASK_TRACED);
+	if (need_siglock)
+		spin_unlock_irq(&child->sighand->siglock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

ptrace-x86-fix-the-tif_forced_tf-logic-in-handle_signal.patch
arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
ptrace-fix-race-between-ptrace_resume-and-wait_task_stopped.patch
ptrace-ptrace_detach-can-no-longer-race-with-sigkill.patch
signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch
fork-report-pid-reservation-failure-properly.patch
mm-rcu-protected-get_mm_exe_file.patch
de_thread-move-notify_count-write-under-lock.patch
linux-next.patch

