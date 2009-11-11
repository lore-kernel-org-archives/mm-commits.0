From: akpm@linux-foundation.org
Subject: + ptrace-copy_process-should-disable-stepping.patch added to -mm tree
Date: Tue, 10 Nov 2009 16:04:47 -0800
Message-ID: <200911110004.nAB04mFS023424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704AbZKKAEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 19:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: copy_process() should disable stepping
has been added to the -mm tree.  Its filename is
     ptrace-copy_process-should-disable-stepping.patch

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


diff -puN kernel/fork.c~ptrace-copy_process-should-disable-stepping kernel/fork.c
--- a/kernel/fork.c~ptrace-copy_process-should-disable-stepping
+++ a/kernel/fork.c
@@ -1203,9 +1203,10 @@ static struct task_struct *copy_process(
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

linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
ptrace-copy_process-should-disable-stepping.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch
utrace-core.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

