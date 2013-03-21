From: akpm@linux-foundation.org
Subject: + aio-make-aio_put_req-lockless.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:37:54 -0700
Message-ID: <20130321223754.DFAEC5A4286@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:37914 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CUWh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:37:56 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so311319qcr.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:37:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: make aio_put_req() lockless
has been added to the -mm tree.  Its filename is
     aio-make-aio_put_req-lockless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: make aio_put_req() lockless

Freeing a kiocb needed to touch the kioctx for three things:

 * Pull it off the reqs_active list
 * Decrementing reqs_active
 * Issuing a wakeup, if the kioctx was in the process of being freed.

This patch moves these to aio_complete(), for a couple reasons:

 * aio_complete() already has to issue the wakeup, so if we drop the
   kioctx refcount before aio_complete does its wakeup we don't have to
   do it twice.
 * aio_complete currently has to take the kioctx lock, so it makes sense
   for it to pull the kiocb off the reqs_active list too.
 * A later patch is going to change reqs_active to include unreaped
   completions - this will mean allocating a kiocb doesn't have to look
   at the ringbuffer. So taking the decrement of reqs_active out of
   kiocb_free() is useful prep work for that patch.

This doesn't really affect cancellation, since existing (usb) code that
implements a cancel function still calls aio_complete() - we just have
to make sure that aio_complete does the necessary teardown for cancelled
kiocbs.

It does affect code paths where we free kiocbs that were never
submitted; they need to decrement reqs_active and pull the kiocb off the
reqs_active list. This occurs in two places: kiocb_batch_free(), which
is going away in a later patch, and the error path in io_submit_one.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   85 ++++++++++++++++--------------------------
 include/linux/aio.h |    4 -
 2 files changed, 35 insertions(+), 54 deletions(-)

diff -puN fs/aio.c~aio-make-aio_put_req-lockless fs/aio.c
--- a/fs/aio.c~aio-make-aio_put_req-lockless
+++ a/fs/aio.c
@@ -89,7 +89,7 @@ struct kioctx {
 
 	spinlock_t		ctx_lock;
 
-	int			reqs_active;
+	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -250,7 +250,7 @@ static void ctx_rcu_free(struct rcu_head
 static void __put_ioctx(struct kioctx *ctx)
 {
 	unsigned nr_events = ctx->max_reqs;
-	BUG_ON(ctx->reqs_active);
+	BUG_ON(atomic_read(&ctx->reqs_active));
 
 	aio_free_ring(ctx);
 	if (nr_events) {
@@ -284,7 +284,7 @@ static int kiocb_cancel(struct kioctx *c
 	cancel = kiocb->ki_cancel;
 	kiocbSetCancelled(kiocb);
 	if (cancel) {
-		kiocb->ki_users++;
+		atomic_inc(&kiocb->ki_users);
 		spin_unlock_irq(&ctx->ctx_lock);
 
 		memset(res, 0, sizeof(*res));
@@ -383,12 +383,12 @@ static void kill_ctx(struct kioctx *ctx)
 		kiocb_cancel(ctx, req, &res);
 	}
 
-	if (!ctx->reqs_active)
+	if (!atomic_read(&ctx->reqs_active))
 		goto out;
 
 	add_wait_queue(&ctx->wait, &wait);
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-	while (ctx->reqs_active) {
+	while (atomic_read(&ctx->reqs_active)) {
 		spin_unlock_irq(&ctx->ctx_lock);
 		io_schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -406,9 +406,9 @@ out:
  */
 ssize_t wait_on_sync_kiocb(struct kiocb *iocb)
 {
-	while (iocb->ki_users) {
+	while (atomic_read(&iocb->ki_users)) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!iocb->ki_users)
+		if (!atomic_read(&iocb->ki_users))
 			break;
 		io_schedule();
 	}
@@ -438,7 +438,7 @@ void exit_aio(struct mm_struct *mm)
 			printk(KERN_DEBUG
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users), ctx->dead,
-				ctx->reqs_active);
+				atomic_read(&ctx->reqs_active));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -453,11 +453,11 @@ void exit_aio(struct mm_struct *mm)
 }
 
 /* aio_get_req
- *	Allocate a slot for an aio request.  Increments the users count
+ *	Allocate a slot for an aio request.  Increments the ki_users count
  * of the kioctx so that the kioctx stays around until all requests are
  * complete.  Returns NULL if no requests are free.
  *
- * Returns with kiocb->users set to 2.  The io submit code path holds
+ * Returns with kiocb->ki_users set to 2.  The io submit code path holds
  * an extra reference while submitting the i/o.
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
@@ -471,7 +471,7 @@ static struct kiocb *__aio_get_req(struc
 		return NULL;
 
 	req->ki_flags = 0;
-	req->ki_users = 2;
+	atomic_set(&req->ki_users, 2);
 	req->ki_key = 0;
 	req->ki_ctx = ctx;
 	req->ki_cancel = NULL;
@@ -512,9 +512,9 @@ static void kiocb_batch_free(struct kioc
 		list_del(&req->ki_batch);
 		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
-		ctx->reqs_active--;
+		atomic_dec(&ctx->reqs_active);
 	}
-	if (unlikely(!ctx->reqs_active && ctx->dead))
+	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
 		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
@@ -545,7 +545,7 @@ static int kiocb_batch_refill(struct kio
 	spin_lock_irq(&ctx->ctx_lock);
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
+	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -560,7 +560,7 @@ static int kiocb_batch_refill(struct kio
 	batch->count -= allocated;
 	list_for_each_entry(req, &batch->head, ki_batch) {
 		list_add(&req->ki_list, &ctx->active_reqs);
-		ctx->reqs_active++;
+		atomic_inc(&ctx->reqs_active);
 	}
 
 	kunmap_atomic(ring);
@@ -583,10 +583,8 @@ static inline struct kiocb *aio_get_req(
 	return req;
 }
 
-static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
+static void kiocb_free(struct kiocb *req)
 {
-	assert_spin_locked(&ctx->ctx_lock);
-
 	if (req->ki_filp)
 		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
@@ -596,40 +594,12 @@ static inline void really_put_req(struct
 	if (req->ki_iovec != &req->ki_inline_vec)
 		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
-	ctx->reqs_active--;
-
-	if (unlikely(!ctx->reqs_active && ctx->dead))
-		wake_up_all(&ctx->wait);
 }
 
-/* __aio_put_req
- *	Returns true if this put was the last user of the request.
- */
-static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
-{
-	assert_spin_locked(&ctx->ctx_lock);
-
-	req->ki_users--;
-	BUG_ON(req->ki_users < 0);
-	if (likely(req->ki_users))
-		return;
-	list_del(&req->ki_list);		/* remove from active_reqs */
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-
-	really_put_req(ctx, req);
-}
-
-/* aio_put_req
- *	Returns true if this put was the last user of the kiocb,
- *	false if the request is still in use.
- */
 void aio_put_req(struct kiocb *req)
 {
-	struct kioctx *ctx = req->ki_ctx;
-	spin_lock_irq(&ctx->ctx_lock);
-	__aio_put_req(ctx, req);
-	spin_unlock_irq(&ctx->ctx_lock);
+	if (atomic_dec_and_test(&req->ki_users))
+		kiocb_free(req);
 }
 EXPORT_SYMBOL(aio_put_req);
 
@@ -677,9 +647,9 @@ void aio_complete(struct kiocb *iocb, lo
 	 *  - the sync task helpfully left a reference to itself in the iocb
 	 */
 	if (is_sync_kiocb(iocb)) {
-		BUG_ON(iocb->ki_users != 1);
+		BUG_ON(atomic_read(&iocb->ki_users) != 1);
 		iocb->ki_user_data = res;
-		iocb->ki_users = 0;
+		atomic_set(&iocb->ki_users, 0);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
 	}
@@ -694,6 +664,8 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
+	list_del(&iocb->ki_list); /* remove from active_reqs */
+
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
@@ -740,7 +712,8 @@ void aio_complete(struct kiocb *iocb, lo
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
-	__aio_put_req(ctx, iocb);
+	aio_put_req(iocb);
+	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -905,7 +878,7 @@ static int read_events(struct kioctx *ct
 				break;
 			/* Try to only show up in io wait if there are ops
 			 *  in flight */
-			if (ctx->reqs_active)
+			if (atomic_read(&ctx->reqs_active))
 				io_schedule();
 			else
 				schedule();
@@ -1364,6 +1337,14 @@ static int io_submit_one(struct kioctx *
 	return 0;
 
 out_put_req:
+	spin_lock_irq(&ctx->ctx_lock);
+	list_del(&req->ki_list);
+	spin_unlock_irq(&ctx->ctx_lock);
+
+	atomic_dec(&ctx->reqs_active);
+	if (unlikely(!atomic_read(&ctx->reqs_active) && ctx->dead))
+		wake_up_all(&ctx->wait);
+
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
diff -puN include/linux/aio.h~aio-make-aio_put_req-lockless include/linux/aio.h
--- a/include/linux/aio.h~aio-make-aio_put_req-lockless
+++ a/include/linux/aio.h
@@ -49,7 +49,7 @@ struct kioctx;
  */
 struct kiocb {
 	unsigned long		ki_flags;
-	int			ki_users;
+	atomic_t		ki_users;
 	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
@@ -96,7 +96,7 @@ static inline bool is_sync_kiocb(struct
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
-			.ki_users = 1,
+			.ki_users = ATOMIC_INIT(1),
 			.ki_key = KIOCB_SYNC_KEY,
 			.ki_filp = filp,
 			.ki_obj.tsk = current,
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

