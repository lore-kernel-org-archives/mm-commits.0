From: akpm@linux-foundation.org
Subject: + timerfd-use-waitqueue-lock.patch added to -mm tree
Date: Fri, 18 May 2007 12:12:30 -0700
Message-ID: <200705181912.l4IJCUhT021626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbXERTPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 15:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, davi@haxent.com.br, tglx@linutronix.de


The patch titled
     timerfd: use waitqueue lock
has been added to the -mm tree.  Its filename is
     timerfd-use-waitqueue-lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timerfd: use waitqueue lock
From: Davide Libenzi <davidel@xmailserver.org>

The timerfd was using the unlocked waitqueue operations, but it was using a
different lock, so poll_wait() would race with it.  This patch makes
timerfd directly use the waitqueue lock.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Davi Arnaut <davi@haxent.com.br>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff -puN fs/timerfd.c~timerfd-use-waitqueue-lock fs/timerfd.c
--- a/fs/timerfd.c~timerfd-use-waitqueue-lock
+++ a/fs/timerfd.c
@@ -24,7 +24,6 @@
 struct timerfd_ctx {
 	struct hrtimer tmr;
 	ktime_t tintv;
-	spinlock_t lock;
 	wait_queue_head_t wqh;
 	int expired;
 };
@@ -39,10 +38,10 @@ static enum hrtimer_restart timerfd_tmrp
 	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	ctx->expired = 1;
 	wake_up_locked(&ctx->wqh);
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return HRTIMER_NORESTART;
 }
@@ -83,10 +82,10 @@ static unsigned int timerfd_poll(struct 
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ctx->expired)
 		events |= POLLIN;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
@@ -101,7 +100,7 @@ static ssize_t timerfd_read(struct file 
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
@@ -115,9 +114,9 @@ static ssize_t timerfd_read(struct file 
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->lock);
+			spin_unlock_irq(&ctx->wqh.lock);
 			schedule();
-			spin_lock_irq(&ctx->lock);
+			spin_lock_irq(&ctx->wqh.lock);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
@@ -139,7 +138,7 @@ static ssize_t timerfd_read(struct file 
 		} else
 			ticks = 1;
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
 		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
 	return res;
@@ -176,7 +175,6 @@ asmlinkage long sys_timerfd(int ufd, int
 			return -ENOMEM;
 
 		init_waitqueue_head(&ctx->wqh);
-		spin_lock_init(&ctx->lock);
 
 		timerfd_setup(ctx, clockid, flags, &ktmr);
 
@@ -202,10 +200,10 @@ asmlinkage long sys_timerfd(int ufd, int
 		 * it to the new values.
 		 */
 		for (;;) {
-			spin_lock_irq(&ctx->lock);
+			spin_lock_irq(&ctx->wqh.lock);
 			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
 				break;
-			spin_unlock_irq(&ctx->lock);
+			spin_unlock_irq(&ctx->wqh.lock);
 			cpu_relax();
 		}
 		/*
@@ -213,7 +211,7 @@ asmlinkage long sys_timerfd(int ufd, int
 		 */
 		timerfd_setup(ctx, clockid, flags, &ktmr);
 
-		spin_unlock_irq(&ctx->lock);
+		spin_unlock_irq(&ctx->wqh.lock);
 		fput(file);
 	}
 
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
x86_64-fix-oprofile-smp.patch
eventfd-use-waitqueue-lock.patch
timerfd-use-waitqueue-lock.patch
