From: akpm@linux-foundation.org
Subject: [merged] ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:54 -0700
Message-ID: <200904061935.n36JZs70012217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbZDFUVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic
has been removed from the -mm tree.  Its filename was
     ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic
From: Oleg Nesterov <oleg@redhat.com>

Another ancient bug. Consider this trivial test-case,

	int main(void)
	{
		int pid = fork();

		if (pid) {
			ptrace(PTRACE_ATTACH, pid, NULL, NULL);
			wait(NULL);
			ptrace(PTRACE_DETACH, pid, NULL, NULL);
		} else {
			pause();
			printf("WE HAVE A KERNEL BUG!!!\n");
		}

		return 0;
	}

the child must not "escape" for sys_pause(), but it can and this was seen
in practice.

This is because ptrace_detach does:

	if (!child->exit_state)
		wake_up_process(child);

this wakeup can happen after this child has already restarted sys_pause(),
because it gets another wakeup from ptrace_untrace().

With or without this patch, perhaps sys_pause() needs a fix.  But this
wakeup also breaks the SIGNAL_STOP_STOPPED logic in ptrace_untrace().

Remove this wakeup.  The caller saw this task in TASK_TRACED state, and
unless it was SIGKILL'ed in between __ptrace_unlink()->ptrace_untrace()
should handle this case correctly.  If it was SIGKILL'ed, we don't need to
wakup the dying tracee too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/ptrace.c~ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic
+++ a/kernel/ptrace.c
@@ -301,11 +301,7 @@ int ptrace_detach(struct task_struct *ch
 	 */
 	if (child->ptrace) {
 		child->exit_code = data;
-
 		dead = __ptrace_detach(current, child);
