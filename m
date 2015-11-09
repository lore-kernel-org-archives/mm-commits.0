From: akpm@linux-foundation.org
Subject: [merged]
 signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 12:13:26 -0800
Message-ID: <5640fe66.RRNnECVMeww7oeHc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbKIUN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: turn dequeue_signal_lock() into kernel_dequeue_signal()
has been removed from the -mm tree.  Its filename was
     signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/block/nbd.c                          |   15 ++++-----------
 drivers/usb/gadget/function/f_mass_storage.c |    4 +---
 fs/jffs2/background.c                        |    3 +--
 include/linux/sched.h                        |   11 ++++++-----
 4 files changed, 12 insertions(+), 21 deletions(-)

diff -puN drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal drivers/block/nbd.c
--- a/drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/drivers/block/nbd.c
@@ -444,9 +444,7 @@ static int nbd_thread_recv(struct nbd_de
 	spin_unlock_irqrestore(&nbd->tasks_lock, flags);
 
 	if (signal_pending(current)) {
-		siginfo_t info;
-
-		ret = dequeue_signal_lock(current, &current->blocked, &info);
+		ret = kernel_dequeue_signal(NULL);
 		dev_warn(nbd_to_dev(nbd), "pid %d, %s, got signal %d\n",
 			 task_pid_nr(current), current->comm, ret);
 		mutex_lock(&nbd->tx_lock);
@@ -560,11 +558,8 @@ static int nbd_thread_send(void *data)
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
@@ -592,10 +587,8 @@ static int nbd_thread_send(void *data)
 	spin_unlock_irqrestore(&nbd->tasks_lock, flags);
 
 	/* Clear maybe pending signals */
-	if (signal_pending(current)) {
-		siginfo_t info;
-		dequeue_signal_lock(current, &current->blocked, &info);
-	}
+	if (signal_pending(current))
+		kernel_dequeue_signal(NULL);
 
 	return 0;
 }
diff -puN drivers/usb/gadget/function/f_mass_storage.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal drivers/usb/gadget/function/f_mass_storage.c
--- a/drivers/usb/gadget/function/f_mass_storage.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal
+++ a/drivers/usb/gadget/function/f_mass_storage.c
@@ -2345,7 +2345,6 @@ static void fsg_disable(struct usb_funct
 
 static void handle_exception(struct fsg_common *common)
 {
-	siginfo_t		info;
 	int			i;
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
@@ -2357,8 +2356,7 @@ static void handle_exception(struct fsg_
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
@@ -2462,14 +2462,15 @@ extern void ignore_signals(struct task_s
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


