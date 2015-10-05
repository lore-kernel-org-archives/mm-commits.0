From: akpm@linux-foundation.org
Subject: +
 signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch added to -mm tree
Date: Mon, 05 Oct 2015 14:19:29 -0700
Message-ID: <5612e961.25vngexcR4jNhnwU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbJEVTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: introduce kernel_signal_stop() to fix jffs2_garbage_collect_thread()
has been added to the -mm tree.  Its filename is
     signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch

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
Subject: signal: introduce kernel_signal_stop() to fix jffs2_garbage_collect_thread()

jffs2_garbage_collect_thread() can race with SIGCONT and sleep in
TASK_STOPPED state after it was already sent. Add the new helper,
kernel_signal_stop(), which does this correctly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    3 +--
 include/linux/sched.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/jffs2/background.c~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread fs/jffs2/background.c
--- a/fs/jffs2/background.c~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread
+++ a/fs/jffs2/background.c
@@ -132,8 +132,7 @@ static int jffs2_garbage_collect_thread(
 			case SIGSTOP:
 				jffs2_dbg(1, "%s(): SIGSTOP received\n",
 					  __func__);
-				set_current_state(TASK_STOPPED);
-				schedule();
+				kernel_signal_stop();
 				break;
 
 			case SIGKILL:
diff -puN include/linux/sched.h~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread include/linux/sched.h
--- a/include/linux/sched.h~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread
+++ a/include/linux/sched.h
@@ -2477,6 +2477,16 @@ static inline int kernel_dequeue_signal(
 	return ret;
 }
 
+static inline void kernel_signal_stop(void)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	if (current->jobctl & JOBCTL_STOP_DEQUEUED)
+		__set_current_state(TASK_STOPPED);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	schedule();
+}
+
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

