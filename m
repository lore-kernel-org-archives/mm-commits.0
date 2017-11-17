From: akpm@linux-foundation.org
Subject: [patch 66/94] kernel/signal.c: remove the no longer needed
 SIGNAL_UNKILLABLE check in complete_signal()
Date: Fri, 17 Nov 2017 15:30:08 -0800
Message-ID: <20171117233008.g72Llp1vr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966947AbdKQXaK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, keescook@chromium.org, me@kylehuey.com, mm-commits@vger.kernel.org, oleg@redhat.com, torvalds@linux-foundation.org

From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/signal.c: remove the no longer needed SIGNAL_UNKILLABLE check in complete_signal()

complete_signal() checks SIGNAL_UNKILLABLE before it starts to destroy the
thread group, today this is wrong in many ways.

If nothing else, fatal_signal_pending() should always imply that the whole
thread group (except ->group_exit_task if it is not NULL) is killed, this
check breaks the rule.

After the previous changes we can rely on sig_task_ignored();
sig_fatal(sig) && SIGNAL_UNKILLABLE can only be true if we actually want
to kill this task and sig == SIGKILL OR it is traced and debugger can
intercept the signal.

This should hopefully fix the problem reported by Dmitry. This test-case

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

triggers the WARN_ON_ONCE(!(task->jobctl & JOBCTL_STOP_PENDING)) in
task_participate_group_stop().  do_signal_stop()->signal_group_exit()
checks SIGNAL_GROUP_EXIT and return false, but task_set_jobctl_pending()
checks fatal_signal_pending() and does not set JOBCTL_STOP_PENDING.

And his should fix the minor security problem reported by Kyle,
SECCOMP_RET_TRACE can miss fatal_signal_pending() the same way if the task
is the root of a pid namespace.

Link: http://lkml.kernel.org/r/20171103184246.GD21036@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Kyle Huey <me@kylehuey.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~remove-the-no-longer-needed-signal_unkillable-check-in-complete_signal kernel/signal.c
--- a/kernel/signal.c~remove-the-no-longer-needed-signal_unkillable-check-in-complete_signal
+++ a/kernel/signal.c
@@ -931,9 +931,9 @@ static void complete_signal(int sig, str
 	 * then start taking the whole group down immediately.
 	 */
 	if (sig_fatal(p, sig) &&
-	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
+	    !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !t->ptrace)) {
+	    (sig == SIGKILL || !p->ptrace)) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
_
