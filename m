From: akpm@linux-foundation.org
Subject: +
 signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch added to
 -mm tree
Date: Mon, 05 Oct 2015 14:19:27 -0700
Message-ID: <5612e95f.di8YWOS7lWDxbMSm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbJEVT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: turn dequeue_signal_lock() into kernel_dequeue_signal()
has been added to the -mm tree.  Its filename is
     signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch

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
Subject: signal: turn dequeue_signal_lock() into kernel_dequeue_signal()

1. Rename dequeue_signal_lock() to kernel_dequeue_signal(). This
   matches another "for kthreads only" kernel_sigaction() helper.

2. Remove the "tsk" and "mask" arguments, they are always current
   and current->blocked. And it is simply wrong if tsk != current.

3. We could also remove the 3rd "siginfo_t *info" arg but it looks
   potentially useful. However we can simplify the callers if we
   change kernel_dequeue_signal() to accept info => NULL.

4. Remove _irqsave, it is never called from atomic context.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c                          |    9 ++-------
 drivers/usb/gadget/function/f_mass_storage.c |    4 +---
 fs/jffs2/background.c                        |    3 +--
 include/linux/sched.h                        |   11 ++++++-----
 4 files changed, 10 insertions(+), 17 deletions(-)

diff -puN drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal drivers/block/nbd.c
--- a/drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/drivers/block/nbd.c
@@ -432,9 +432,7 @@ static int nbd_thread_recv(struct nbd_de
 	nbd->task_recv = NULL;
 
 	if (signal_pending(current)) {
-		siginfo_t info;
-
-		ret = dequeue_signal_lock(current, &current->blocked, &info);
+		ret = kernel_dequeue_signal(NULL);
 		dev_warn(nbd_to_dev(nbd), "pid %d, %s, got signal %d\n",
 			 task_pid_nr(current), current->comm, ret);
 		mutex_lock(&nbd->tx_lock);
@@ -545,11 +543,8 @@ static int nbd_thread_send(void *data)
 					 !list_empty(&nbd->waiting_queue));
 
 		if (signal_pending(current)) {
-			siginfo_t info;
-			int ret;
+			int ret = kernel_dequeue_signal(NULL);
 
-			ret = dequeue_signal_lock(current, &current->blocked,
-						  &info);
 			dev_warn(nbd_to_dev(nbd), "pid %d, %s, got signal %d\n",
 				 task_pid_nr(current), current->comm, ret);
 			mutex_lock(&nbd->tx_lock);
diff -puN drivers/usb/gadget/function/f_mass_storage.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal drivers/usb/gadget/function/f_mass_storage.c
--- a/drivers/usb/gadget/function/f_mass_storage.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/drivers/usb/gadget/function/f_mass_storage.c
@@ -2347,7 +2347,6 @@ static void fsg_disable(struct usb_funct
 
 static void handle_exception(struct fsg_common *common)
 {
-	siginfo_t		info;
 	int			i;
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
@@ -2359,8 +2358,7 @@ static void handle_exception(struct fsg_
 	 * into a high-priority EXIT exception.
 	 */
 	for (;;) {
-		int sig =
-			dequeue_signal_lock(current, &current->blocked, &info);
+		int sig = kernel_dequeue_signal(NULL);
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
diff -puN fs/jffs2/background.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal fs/jffs2/background.c
--- a/fs/jffs2/background.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/fs/jffs2/background.c
@@ -121,13 +121,12 @@ static int jffs2_garbage_collect_thread(
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current) || freezing(current)) {
-			siginfo_t info;
 			unsigned long signr;
 
 			if (try_to_freeze())
 				goto again;
 
-			signr = dequeue_signal_lock(current, &current->blocked, &info);
+			signr = kernel_dequeue_signal(NULL);
 
 			switch(signr) {
 			case SIGSTOP:
diff -puN include/linux/sched.h~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal include/linux/sched.h
--- a/include/linux/sched.h~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/include/linux/sched.h
@@ -2464,14 +2464,15 @@ extern void ignore_signals(struct task_s
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
-static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+static inline int kernel_dequeue_signal(siginfo_t *info)
 {
-	unsigned long flags;
+	struct task_struct *tsk = current;
+	siginfo_t __info;
 	int ret;
 
-	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	ret = dequeue_signal(tsk, mask, info);
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	spin_lock_irq(&tsk->sighand->siglock);
+	ret = dequeue_signal(tsk, &tsk->blocked, info ?: &__info);
+	spin_unlock_irq(&tsk->sighand->siglock);
 
 	return ret;
 }
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

