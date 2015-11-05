From: akpm@linux-foundation.org
Subject: +
 signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal.patch
 added to -mm tree
Date: Wed, 04 Nov 2015 17:22:00 -0800
Message-ID: <563aaf38.+DiKhgJBQE4Osy15%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031345AbbKEBWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvyukov@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: kill the obsolete SIGNAL_UNKILLABLE check in complete_signal()
has been added to the -mm tree.  Its filename is
     signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal.patch

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
Subject: signal: kill the obsolete SIGNAL_UNKILLABLE check in complete_signal()

complete_signal() checks SIGNAL_UNKILLABLE before it starts to destroy the
thread group, today this is unnecessary and even not 100% correct.

After the commit f008faff0e27 ("signals: protect init from unwanted
signals more") we rely on sig_task_ignored(), complete_signal(SIGKILL) can
only see a SIGNAL_UNKILLABLE task if we actually want to kill it.  And
note that after the commit b3bfa0cba867 ("signals: protect cinit from
blocked fatal signals") we do not drop SIGKILL dequeued by /sbin/init.

And it does not look right.  fatal_signal_pending() should always imply
that the whole thread group (except ->group_exit_task if it is not NULL)
is killed, this check breaks the rule.

This explains WARN_ON(!JOBCTL_STOP_PENDING) in task_participate_group_stop()
triggered by the test-case from Dmitry:

	int main()
	{
		int pid = 1;
		ptrace(PTRACE_ATTACH, pid, 0, 0);
		ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_EXITKILL);
		sleep(1);
		return 0;
	}

do_signal_stop()->signal_group_exit() returns false because
SIGNAL_GROUP_EXIT is not set, but task_set_jobctl_pending() checks
fatal_signal_pending() and does not set JOBCTL_STOP_PENDING.

The test-case above needs root and (correctly) crashes the kernel, but we
can trigger the same warning inside the container or using another
test-case:

	static int init(void *arg)
	{
		for (;;)
			pause();
	}

	int main(void)
	{
		char stack[16 * 1024];

		for (;;) {
			int pid = clone(init, stack + sizeof(stack)/2,
					CLONE_NEWPID | SIGCHLD, NULL);
			assert(pid > 0);

			assert(ptrace(PTRACE_ATTACH, pid, 0, 0) == 0);
			assert(waitpid(-1, NULL, WSTOPPED) == pid);

			assert(ptrace(PTRACE_DETACH, pid, 0, SIGSTOP) == 0);
			assert(syscall(__NR_tkill, pid, SIGKILL) == 0);
			assert(pid == wait(NULL));
		}
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal kernel/signal.c
--- a/kernel/signal.c~signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal
+++ a/kernel/signal.c
@@ -909,7 +909,7 @@ static void complete_signal(int sig, str
 	 * then start taking the whole group down immediately.
 	 */
 	if (sig_fatal(p, sig) &&
-	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
+	    !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !t->ptrace)) {
 		/*
_

Patches currently in -mm which might be from oleg@redhat.com are

mmoom-fix-potentially-killing-unrelated-process-fix.patch
mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
signal-kill-the-obsolete-signal_unkillable-check-in-complete_signal.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

