From: akpm@linux-foundation.org
Subject: [merged] eventfd-remove-fput-call-from-possible-irq-context-3rd-rev.patch removed from -mm tree
Date: Mon, 30 Mar 2009 01:01:11 -0700
Message-ID: <200903300801.n2U81Bvo017317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbZC3IHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 04:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, bcrl@kvack.org, dada1@cosmosbay.com, jmoyer@redhat.com, stable@kernel.org, trond.myklebust@fys.uio.no, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     eventfd: remove fput() call from possible IRQ context
has been removed from the -mm tree.  Its filename was
     eventfd-remove-fput-call-from-possible-irq-context-3rd-rev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eventfd: remove fput() call from possible IRQ context
From: Davide Libenzi <davidel@xmailserver.org>

Remove a source of fput() call from inside IRQ context.  Myself, like Eric,
wasn't able to reproduce an fput() call from IRQ context, but Jeff said he was
able to, with the attached test program.  Independently from this, the bug is
conceptually there, so we might be better off fixing it.  This patch adds an
optimization similar to the one we already do on ->ki_filp, on ->ki_eventfd. 
Playing with ->f_count directly is not pretty in general, but the alternative
here would be to add a brand new delayed fput() infrastructure, that I'm not
sure is worth it.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff -puN fs/aio.c~eventfd-remove-fput-call-from-possible-irq-context-3rd-rev fs/aio.c
--- a/fs/aio.c~eventfd-remove-fput-call-from-possible-irq-context-3rd-rev
+++ a/fs/aio.c
@@ -443,7 +443,7 @@ static struct kiocb *__aio_get_req(struc
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
-	req->ki_eventfd = ERR_PTR(-EINVAL);
+	req->ki_eventfd = NULL;
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
@@ -485,8 +485,6 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
-	if (!IS_ERR(req->ki_eventfd))
-		fput(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -508,8 +506,11 @@ static void aio_fput_routine(struct work
 		list_del(&req->ki_list);
 		spin_unlock_irq(&fput_lock);
 
-		/* Complete the fput */
-		__fput(req->ki_filp);
+		/* Complete the fput(s) */
+		if (req->ki_filp != NULL)
+			__fput(req->ki_filp);
+		if (req->ki_eventfd != NULL)
+			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -527,12 +528,14 @@ static void aio_fput_routine(struct work
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
+	int schedule_putreq = 0;
+
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
-	req->ki_users --;
+	req->ki_users--;
 	BUG_ON(req->ki_users < 0);
 	if (likely(req->ki_users))
 		return 0;
@@ -540,10 +543,23 @@ static int __aio_put_req(struct kioctx *
 	req->ki_cancel = NULL;
 	req->ki_retry = NULL;
 
-	/* Must be done under the lock to serialise against cancellation.
-	 * Call this aio_fput as it duplicates fput via the fput_work.
+	/*
+	 * Try to optimize the aio and eventfd file* puts, by avoiding to
+	 * schedule work in case it is not __fput() time. In normal cases,
+	 * we would not be holding the last reference to the file*, so
+	 * this function will be executed w/out any aio kthread wakeup.
 	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
+	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
+		schedule_putreq++;
+	else
+		req->ki_filp = NULL;
+	if (req->ki_eventfd != NULL) {
+		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
+			schedule_putreq++;
+		else
+			req->ki_eventfd = NULL;
+	}
+	if (unlikely(schedule_putreq)) {
 		get_ioctx(ctx);
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
@@ -1009,7 +1025,7 @@ int aio_complete(struct kiocb *iocb, lon
 	 * eventfd. The eventfd_signal() function is safe to be called
 	 * from IRQ context.
 	 */
-	if (!IS_ERR(iocb->ki_eventfd))
+	if (iocb->ki_eventfd != NULL)
 		eventfd_signal(iocb->ki_eventfd, 1);
 
 put_rq:
@@ -1608,6 +1624,7 @@ static int io_submit_one(struct kioctx *
 		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
+			req->ki_eventfd = NULL;
 			goto out_put_req;
 		}
 	}
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
eventfd-improve-support-for-semaphore-like-behavior.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

