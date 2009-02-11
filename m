From: akpm@linux-foundation.org
Subject: [merged] ptrace-fix-the-usage-of-ptrace_fork.patch removed from -mm tree
Date: Wed, 11 Feb 2009 11:22:04 -0800
Message-ID: <200902111922.n1BJM4tX019170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbZBKTXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 14:23:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, markus.t.metzger@intel.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: fix the usage of ptrace_fork()
has been removed from the -mm tree.  Its filename was
     ptrace-fix-the-usage-of-ptrace_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: fix the usage of ptrace_fork()
From: Oleg Nesterov <oleg@redhat.com>

I noticed by pure accident we have ptrace_fork() and friends.  This was
added by "x86, bts: add fork and exit handling", commit
bf53de907dfdaac178c92d774aae7370d7b97d20

I think something like this program

	int main(void)
	{
		int pid = fork();

		if (!pid) {
			ptrace(PTRACE_TRACEME, 0, NULL, NULL);
			kill(getpid(), SIGSTOP);
			fork();
		} else {
			struct ptrace_bts_config bts = {
				.flags = PTRACE_BTS_O_ALLOC,
				.size  = 4 * 4096,
			};

			wait(NULL);

			ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACEFORK);
			ptrace(PTRACE_BTS_CONFIG, pid, &bts, sizeof(bts));
			ptrace(PTRACE_CONT, pid, NULL, NULL);

			sleep(1);
		}

		return 0;
	}

should crash the kernel.

If the task is traced by its natural parent ptrace_reparented() returns 0
but we should clear ->btsxxx anyway.

This is a minimal fix for 2.6.29, we need further cleanups imho.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~ptrace-fix-the-usage-of-ptrace_fork kernel/fork.c
--- a/kernel/fork.c~ptrace-fix-the-usage-of-ptrace_fork
+++ a/kernel/fork.c
@@ -1099,7 +1099,7 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(ptrace_reparented(current)))
+	if (unlikely(current->ptrace))
 		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

