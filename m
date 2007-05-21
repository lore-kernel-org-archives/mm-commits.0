From: akpm@linux-foundation.org
Subject: + signalfd-retrieve-multiple-signals-with-one-read-call.patch added to -mm tree
Date: Sun, 20 May 2007 21:02:21 -0700
Message-ID: <200705210402.l4L42KpG001965@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034AbXEUEE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davi@haxent.com.br, davidel@xmailserver.org


The patch titled
     signalfd: retrieve multiple signals with one read() call
has been added to the -mm tree.  Its filename is
     signalfd-retrieve-multiple-signals-with-one-read-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: signalfd: retrieve multiple signals with one read() call
From: Davi Arnaut <davi@haxent.com.br>

Gathering signals in bulk enables server applications to drain a signal
queue (almost full of realtime signals) more efficiently by reducing the
syscall and file look-up overhead.

Very similar to the sigtimedwait4() call described by Niels Provos, Chuck
Lever, and Stephen Tweedie in a paper entitled "Analyzing the Overload
Behavior of a Simple Web Server".  The paper lists more details and
advantages.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |  125 ++++++++++++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 45 deletions(-)

diff -puN fs/signalfd.c~signalfd-retrieve-multiple-signals-with-one-read-call fs/signalfd.c
--- a/fs/signalfd.c~signalfd-retrieve-multiple-signals-with-one-read-call
+++ a/fs/signalfd.c
@@ -11,6 +11,8 @@
  *      Now using anonymous inode source.
  *      Thanks to Oleg Nesterov for useful code review and suggestions.
  *      More comments and suggestions from Arnd Bergmann.
+ * Sat May 19, 2007: Davi E. M. Arnaut <davi@haxent.com.br>
+ *      Retrieve multiple signals with one read() call
  */
 
 #include <linux/file.h>
@@ -206,6 +208,64 @@ static int signalfd_copyinfo(struct sign
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
+static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
+				int nonblock)
+{
+	int locked;
+	ssize_t ret;
+	struct signalfd_lockctx lk;
+	DECLARE_WAITQUEUE(wait, current);
+
+	locked = signalfd_lock(ctx, &lk);
+	if (!locked)
+		return 0;
+
+	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+	switch (ret) {
+	case 0:
+		if (!nonblock)
+			break;
+		ret = -EAGAIN;
+	default:
+		signalfd_unlock(&lk);
+		return ret;
+	}
+
+	add_wait_queue(&ctx->wqh, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		if (ret != 0)
+			break;
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+		signalfd_unlock(&lk);
+		schedule();
+		locked = signalfd_lock(ctx, &lk);
+		if (unlikely(!locked)) {
+			/*
+			 * Let the caller read zero byte, ala socket
+			 * recv() when the peer disconnect. This test
+			 * must be done before doing a dequeue_signal(),
+			 * because if the sighand has been orphaned,
+			 * the dequeue_signal() call is going to crash.
+			 */
+			 ret = 0;
+			 break;
+		}
+	}
+
+	remove_wait_queue(&ctx->wqh, &wait);
+	__set_current_state(TASK_RUNNING);
+
+	if (likely(locked))
+		signalfd_unlock(&lk);
+
+	return ret;
+}
+
 /*
  * Returns either the size of a "struct signalfd_siginfo", or zero if the
  * sighand we are attached to, has been orphaned. The "count" parameter
@@ -215,55 +275,30 @@ static ssize_t signalfd_read(struct file
 			     loff_t *ppos)
 {
 	struct signalfd_ctx *ctx = file->private_data;
-	ssize_t res = 0;
-	int locked, signo;
+	struct signalfd_siginfo __user *siginfo;
+	int nonblock = file->f_flags & O_NONBLOCK;
+	ssize_t ret, total = 0;
 	siginfo_t info;
-	struct signalfd_lockctx lk;
-	DECLARE_WAITQUEUE(wait, current);
 
-	if (count < sizeof(struct signalfd_siginfo))
+	count /= sizeof(struct signalfd_siginfo);
+	if (!count)
 		return -EINVAL;
-	locked = signalfd_lock(ctx, &lk);
-	if (!locked)
-		return 0;
-	res = -EAGAIN;
-	signo = dequeue_signal(lk.tsk, &ctx->sigmask, &info);
-	if (signo == 0 && !(file->f_flags & O_NONBLOCK)) {
-		add_wait_queue(&ctx->wqh, &wait);
-		for (;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			signo = dequeue_signal(lk.tsk, &ctx->sigmask, &info);
-			if (signo != 0)
-				break;
-			if (signal_pending(current)) {
-				res = -ERESTARTSYS;
-				break;
-			}
-			signalfd_unlock(&lk);
-			schedule();
-			locked = signalfd_lock(ctx, &lk);
-			if (unlikely(!locked)) {
-				/*
-				 * Let the caller read zero byte, ala socket
-				 * recv() when the peer disconnect. This test
-				 * must be done before doing a dequeue_signal(),
-				 * because if the sighand has been orphaned,
-				 * the dequeue_signal() call is going to crash.
-				 */
-				res = 0;
-				break;
-			}
-		}
-		remove_wait_queue(&ctx->wqh, &wait);
-		__set_current_state(TASK_RUNNING);
-	}
-	if (likely(locked))
-		signalfd_unlock(&lk);
-	if (likely(signo))
-		res = signalfd_copyinfo((struct signalfd_siginfo __user *) buf,
-					&info);
 
-	return res;
+	siginfo = (struct signalfd_siginfo __user *) buf;
+
+	do {
+		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (unlikely(ret <= 0))
+			break;
+		ret = signalfd_copyinfo(siginfo, &info);
+		if (ret < 0)
+			break;
+		siginfo++;
+		total += ret;
+		nonblock = 1;
+	} while (--count);
+
+	return total ? total : ret;
 }
 
 static const struct file_operations signalfd_fops = {
_

Patches currently in -mm which might be from davi@haxent.com.br are

signalfd-retrieve-multiple-signals-with-one-read-call.patch
