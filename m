From: akpm@linux-foundation.org
Subject: + eventfd-use-waitqueue-lock.patch added to -mm tree
Date: Fri, 18 May 2007 12:12:11 -0700
Message-ID: <200705181912.l4IJCBEx021600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbXERTPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 15:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, davi@haxent.com.br, tglx@linutronix.de


The patch titled
     eventfd: use waitqueue lock
has been added to the -mm tree.  Its filename is
     eventfd-use-waitqueue-lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eventfd: use waitqueue lock
From: Davide Libenzi <davidel@xmailserver.org>

The eventfd was using the unlocked waitqueue operations, but it was using a
different lock, so poll_wait() would race with it.  This patch makes
eventfd directly use the waitqueue lock.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Davi Arnaut <davi@haxent.com.br>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/eventfd.c~eventfd-use-waitqueue-lock fs/eventfd.c
--- a/fs/eventfd.c~eventfd-use-waitqueue-lock
+++ a/fs/eventfd.c
@@ -17,7 +17,6 @@
 #include <linux/eventfd.h>
 
 struct eventfd_ctx {
-	spinlock_t lock;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
@@ -45,13 +44,13 @@ int eventfd_signal(struct file *file, in
 
 	if (n < 0)
 		return -EINVAL;
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ULLONG_MAX - ctx->count < n)
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked(&ctx->wqh);
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
@@ -70,14 +69,14 @@ static unsigned int eventfd_poll(struct 
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ctx->count > 0)
 		events |= POLLIN;
 	if (ctx->count == ULLONG_MAX)
 		events |= POLLERR;
 	if (ULLONG_MAX - 1 > ctx->count)
 		events |= POLLOUT;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
@@ -92,7 +91,7 @@ static ssize_t eventfd_read(struct file 
 
 	if (count < sizeof(ucnt))
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	ucnt = ctx->count;
 	if (ucnt > 0)
@@ -110,9 +109,9 @@ static ssize_t eventfd_read(struct file 
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
@@ -122,7 +121,7 @@ static ssize_t eventfd_read(struct file 
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
 		return -EFAULT;
 
@@ -143,7 +142,7 @@ static ssize_t eventfd_write(struct file
 		return -EFAULT;
 	if (ucnt == ULLONG_MAX)
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	if (ULLONG_MAX - ctx->count > ucnt)
 		res = sizeof(ucnt);
@@ -159,9 +158,9 @@ static ssize_t eventfd_write(struct file
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
@@ -171,7 +170,7 @@ static ssize_t eventfd_write(struct file
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 
 	return res;
 }
@@ -210,7 +209,6 @@ asmlinkage long sys_eventfd(unsigned int
 		return -ENOMEM;
 
 	init_waitqueue_head(&ctx->wqh);
-	spin_lock_init(&ctx->lock);
 	ctx->count = count;
 
 	/*
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
x86_64-fix-oprofile-smp.patch
eventfd-use-waitqueue-lock.patch
timerfd-use-waitqueue-lock.patch
