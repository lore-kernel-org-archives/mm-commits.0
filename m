From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 138/166] fs/epoll: make nesting accounting safe
 for -rt kernel
Date: Mon, 06 Apr 2020 20:11:23 -0700
Message-ID: <20200407031123.COnBt0S6b%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgDGDLZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:25 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbueso@suse.de, jbaron@akamai.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, normalperson@yhbt.net, rpenyaev@suse.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Jason Baron <jbaron@akamai.com>
Subject: fs/epoll: make nesting accounting safe for -rt kernel

Davidlohr Bueso pointed out that when CONFIG_DEBUG_LOCK_ALLOC is set
ep_poll_safewake() can take several non-raw spinlocks after disabling
interrupts.  Since a spinlock can block in the -rt kernel, we can't take a
spinlock after disabling interrupts.  So let's re-work how we determine
the nesting level such that it plays nicely with the -rt kernel.

Let's introduce a 'nests' field in struct eventpoll that records the
current nesting level during ep_poll_callback().  Then, if we nest again
we can find the previous struct eventpoll that we were called from and
increase our count by 1.  The 'nests' field is protected by
ep->poll_wait.lock.

I've also moved the visited field to reduce the size of struct eventpoll
from 184 bytes to 176 bytes on x86_64 for !CONFIG_DEBUG_LOCK_ALLOC, which
is typical for a production config.

Link: http://lkml.kernel.org/r/1582739816-13167-1-git-send-email-jbaron@akamai.com
Reported-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   64 +++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 21 deletions(-)

--- a/fs/eventpoll.c~fs-epoll-make-nesting-accounting-safe-for-rt-kernel
+++ a/fs/eventpoll.c
@@ -218,13 +218,18 @@ struct eventpoll {
 	struct file *file;
 
 	/* used to optimize loop detection check */
-	int visited;
 	struct list_head visited_list_link;
+	int visited;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
 #endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/* tracks wakeup nests for lockdep validation */
+	u8 nests;
+#endif
 };
 
 /* Wait structure used by the poll hooks */
@@ -545,30 +550,47 @@ out_unlock:
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-static DEFINE_PER_CPU(int, wakeup_nest);
-
-static void ep_poll_safewake(wait_queue_head_t *wq)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
 {
+	struct eventpoll *ep_src;
 	unsigned long flags;
-	int subclass;
+	u8 nests = 0;
 
-	local_irq_save(flags);
-	preempt_disable();
-	subclass = __this_cpu_read(wakeup_nest);
-	spin_lock_nested(&wq->lock, subclass + 1);
-	__this_cpu_inc(wakeup_nest);
-	wake_up_locked_poll(wq, POLLIN);
-	__this_cpu_dec(wakeup_nest);
-	spin_unlock(&wq->lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	/*
+	 * To set the subclass or nesting level for spin_lock_irqsave_nested()
+	 * it might be natural to create a per-cpu nest count. However, since
+	 * we can recurse on ep->poll_wait.lock, and a non-raw spinlock can
+	 * schedule() in the -rt kernel, the per-cpu variable are no longer
+	 * protected. Thus, we are introducing a per eventpoll nest field.
+	 * If we are not being call from ep_poll_callback(), epi is NULL and
+	 * we are at the first level of nesting, 0. Otherwise, we are being
+	 * called from ep_poll_callback() and if a previous wakeup source is
+	 * not an epoll file itself, we are at depth 1 since the wakeup source
+	 * is depth 0. If the wakeup source is a previous epoll file in the
+	 * wakeup chain then we use its nests value and record ours as
+	 * nests + 1. The previous epoll file nests value is stable since its
+	 * already holding its own poll_wait.lock.
+	 */
+	if (epi) {
+		if ((is_file_epoll(epi->ffd.file))) {
+			ep_src = epi->ffd.file->private_data;
+			nests = ep_src->nests;
+		} else {
+			nests = 1;
+		}
+	}
+	spin_lock_irqsave_nested(&ep->poll_wait.lock, flags, nests);
+	ep->nests = nests + 1;
+	wake_up_locked_poll(&ep->poll_wait, EPOLLIN);
+	ep->nests = 0;
+	spin_unlock_irqrestore(&ep->poll_wait.lock, flags);
 }
 
 #else
 
-static void ep_poll_safewake(wait_queue_head_t *wq)
+static void ep_poll_safewake(struct eventpoll *ep, struct epitem *epi)
 {
-	wake_up_poll(wq, EPOLLIN);
+	wake_up_poll(&ep->poll_wait, EPOLLIN);
 }
 
 #endif
@@ -789,7 +811,7 @@ static void ep_free(struct eventpoll *ep
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
-		ep_poll_safewake(&ep->poll_wait);
+		ep_poll_safewake(ep, NULL);
 
 	/*
 	 * We need to lock this because we could be hit by
@@ -1258,7 +1280,7 @@ out_unlock:
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+		ep_poll_safewake(ep, epi);
 
 	if (!(epi->event.events & EPOLLEXCLUSIVE))
 		ewake = 1;
@@ -1562,7 +1584,7 @@ static int ep_insert(struct eventpoll *e
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+		ep_poll_safewake(ep, NULL);
 
 	return 0;
 
@@ -1666,7 +1688,7 @@ static int ep_modify(struct eventpoll *e
 
 	/* We have to call this outside the lock */
 	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+		ep_poll_safewake(ep, NULL);
 
 	return 0;
 }
_
