From: akpm@linux-foundation.org
Subject: [merged] ptrace-copy_process-should-disable-stepping.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:57 -0800
Message-ID: <200912162037.nBGKbvI3013386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832AbZLPUiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: copy_process() should disable stepping
has been removed from the -mm tree.  Its filename was
     ptrace-copy_process-should-disable-stepping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: copy_process() should disable stepping
From: Oleg Nesterov <oleg@redhat.com>

If the tracee calls fork() after PTRACE_SINGLESTEP, the forked child
starts with TIF_SINGLESTEP/X86_EFLAGS_TF bits copied from ptraced parent. 
This is not right, especially when the new child is not auto-attaced: in
this case it is killed by SIGTRAP.

Change copy_process() to call user_disable_single_step(). Tested on x86.

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>

	int main(void)
	{
		int pid, status;

		if (!(pid = fork())) {
			assert(ptrace(PTRACE_TRACEME) == 0);
			kill(getpid(), SIGSTOP);

			if (!fork()) {
				/* kernel bug: this child will be killed by SIGTRAP */
				printf("Hello world\n");
				return 43;
			}

			wait(&status);
			return WEXITSTATUS(status);
		}

		for (;;) {
			assert(pid == wait(&status));
			if (WIFEXITED(status))
				break;
			assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
		}

		assert(WEXITSTATUS(status) == 43);
		return 0;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~ptrace-copy_process-should-disable-stepping kernel/fork.c
--- a/kernel/fork.c~ptrace-copy_process-should-disable-stepping
+++ a/kernel/fork.c
@@ -1210,9 +1210,10 @@ static struct task_struct *copy_process(
 		p->sas_ss_sp = p->sas_ss_size = 0;
 
 	/*
-	 * Syscall tracing should be turned off in the child regardless
-	 * of CLONE_PTRACE.
+	 * Syscall tracing and stepping should be turned off in the
+	 * child regardless of CLONE_PTRACE.
 	 */
+	user_disable_single_step(p);
 	clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

