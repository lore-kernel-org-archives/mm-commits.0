From: akpm@linux-foundation.org
Subject: + aio-use-cancellation-list-lazily.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:40:26 -0800
Message-ID: <20130103234027.B4D94200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:43797 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3ACXkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:40:31 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so986282eek.4
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:40:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: use cancellation list lazily
has been added to the -mm tree.  Its filename is
     aio-use-cancellation-list-lazily.patch

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
Subject: aio: use cancellation list lazily

Cancelling kiocbs requires adding them to a per kioctx linked list, which
is one of the few things we need to take the kioctx lock for in the fast
path.  But most kiocbs can't be cancelled - so if we just do this lazily,
we can avoid quite a bit of locking overhead.

While we're at it, instead of using a flag bit switch to using ki_cancel
itself to indicate that a kiocb has been cancelled/completed.  This lets
us get rid of ki_flags entirely.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/inode.c |    3 -
 fs/aio.c                   |   97 ++++++++++++++++++-----------------
 include/linux/aio.h        |   16 ++---
 3 files changed, 60 insertions(+), 56 deletions(-)

diff -puN drivers/usb/gadget/inode.c~aio-use-cancellation-list-lazily drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~aio-use-cancellation-list-lazily
+++ a/drivers/usb/gadget/inode.c
@@ -533,7 +533,6 @@ static int ep_aio_cancel(struct kiocb *i
 	local_irq_disable();
 	epdata = priv->epdata;
 	// spin_lock(&epdata->dev->lock);
-	kiocbSetCancelled(iocb);
 	if (likely(epdata && epdata->ep && priv->req))
 		value = usb_ep_dequeue (epdata->ep, priv->req);
 	else
@@ -663,7 +662,7 @@ fail:
 		goto fail;
 	}
 
-	iocb->ki_cancel = ep_aio_cancel;
+	kiocb_set_cancel_fn(iocb, ep_aio_cancel);
 	get_ep(epdata);
 	priv->epdata = epdata;
 	priv->actual = 0;
diff -puN fs/aio.c~aio-use-cancellation-list-lazily fs/aio.c
--- a/fs/aio.c~aio-use-cancellation-list-lazily
+++ a/fs/aio.c
@@ -97,6 +97,8 @@ struct kioctx {
 
 	struct aio_ring_info	ring_info;
 
+	spinlock_t		completion_lock;
+
 	struct rcu_head		rcu_head;
 	struct work_struct	rcu_work;
 };
@@ -217,25 +219,40 @@ static int aio_setup_ring(struct kioctx 
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
+{
+	if (!req->ki_list.next) {
+		struct kioctx *ctx = req->ki_ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_add(&req->ki_list, &ctx->active_reqs);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
+
+	req->ki_cancel = cancel;
+}
+EXPORT_SYMBOL(kiocb_set_cancel_fn);
+
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
-	int (*cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn *cancel;
 	int ret = -EINVAL;
 
-	cancel = kiocb->ki_cancel;
-	kiocbSetCancelled(kiocb);
-	if (cancel) {
-		atomic_inc(&kiocb->ki_users);
-		spin_unlock_irq(&ctx->ctx_lock);
-
-		memset(res, 0, sizeof(*res));
-		res->obj = (u64) kiocb->ki_obj.user;
-		res->data = kiocb->ki_user_data;
-		ret = cancel(kiocb, res);
+	cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
+	if (!cancel || cancel == KIOCB_CANCELLED)
+		return ret;
+
+	atomic_inc(&kiocb->ki_users);
+	spin_unlock_irq(&ctx->ctx_lock);
 
-		spin_lock_irq(&ctx->ctx_lock);
-	}
+	memset(res, 0, sizeof(*res));
+	res->obj = (u64) kiocb->ki_obj.user;
+	res->data = kiocb->ki_user_data;
+	ret = cancel(kiocb, res);
+
+	spin_lock_irq(&ctx->ctx_lock);
 
 	return ret;
 }
@@ -323,6 +340,7 @@ static struct kioctx *ioctx_alloc(unsign
 	atomic_set(&ctx->users, 2);
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
+	spin_lock_init(&ctx->completion_lock);
 	mutex_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -465,20 +483,12 @@ static struct kiocb *__aio_get_req(struc
 {
 	struct kiocb *req = NULL;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		return NULL;
 
-	req->ki_flags = 0;
 	atomic_set(&req->ki_users, 2);
-	req->ki_key = 0;
 	req->ki_ctx = ctx;
-	req->ki_cancel = NULL;
-	req->ki_retry = NULL;
-	req->ki_dtor = NULL;
-	req->private = NULL;
-	req->ki_iovec = NULL;
-	req->ki_eventfd = NULL;
 
 	return req;
 }
@@ -509,7 +519,6 @@ static void kiocb_batch_free(struct kioc
 	spin_lock_irq(&ctx->ctx_lock);
 	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
 		list_del(&req->ki_batch);
-		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
 		atomic_dec(&ctx->reqs_active);
 	}
@@ -555,10 +564,7 @@ static int kiocb_batch_refill(struct kio
 	}
 
 	batch->count -= allocated;
-	list_for_each_entry(req, &batch->head, ki_batch) {
-		list_add(&req->ki_list, &ctx->active_reqs);
-		atomic_inc(&ctx->reqs_active);
-	}
+	atomic_add(allocated, &ctx->reqs_active);
 
 	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -649,25 +655,34 @@ void aio_complete(struct kiocb *iocb, lo
 	info = &ctx->ring_info;
 
 	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
-	 *
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
 	 * need to issue a wakeup after decrementing reqs_active.
 	 */
 	rcu_read_lock();
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
 
-	list_del(&iocb->ki_list); /* remove from active_reqs */
+	if (iocb->ki_list.next) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&iocb->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
 
 	/*
 	 * cancelled requests don't get events, userland was given one
 	 * when the event got cancelled.
 	 */
-	if (kiocbIsCancelled(iocb))
+	if (unlikely(xchg(&iocb->ki_cancel,
+			  KIOCB_CANCELLED) == KIOCB_CANCELLED))
 		goto put_rq;
 
+	/*
+	 * Add a completion event to the ring buffer. Must be done holding
+	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * pointer since we might be called from irq context.
+	 */
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+
 	tail = info->tail;
 	pos = tail + AIO_EVENTS_OFFSET;
 
@@ -701,6 +716,8 @@ void aio_complete(struct kiocb *iocb, lo
 	kunmap_atomic(ring);
 	flush_dcache_page(info->ring_pages[0]);
 
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
 	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
@@ -727,7 +744,6 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(aio_complete);
@@ -1196,15 +1212,10 @@ static int io_submit_one(struct kioctx *
 	req->ki_opcode = iocb->aio_lio_opcode;
 
 	ret = aio_setup_iocb(req, compat);
-
 	if (ret)
 		goto out_put_req;
 
-	if (unlikely(kiocbIsCancelled(req))) {
-		ret = -EINTR;
-	} else {
-		ret = req->ki_retry(req);
-	}
+	ret = req->ki_retry(req);
 	if (ret != -EIOCBQUEUED) {
 		/*
 		 * There's no easy way to restart the syscall since other AIO's
@@ -1220,10 +1231,6 @@ static int io_submit_one(struct kioctx *
 	return 0;
 
 out_put_req:
-	spin_lock_irq(&ctx->ctx_lock);
-	list_del(&req->ki_list);
-	spin_unlock_irq(&ctx->ctx_lock);
-
 	atomic_dec(&ctx->reqs_active);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
diff -puN include/linux/aio.h~aio-use-cancellation-list-lazily include/linux/aio.h
--- a/include/linux/aio.h~aio-use-cancellation-list-lazily
+++ a/include/linux/aio.h
@@ -10,17 +10,13 @@
 #include <linux/atomic.h>
 
 struct kioctx;
+struct kiocb;
 
 #define KIOCB_SYNC_KEY		(~0U)
 
-/* ki_flags bits */
-#define KIF_CANCELLED		2
+#define KIOCB_CANCELLED		((void *) (~0ULL))
 
-#define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
-
-#define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
-
-#define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 /* is there a better place to document function pointer methods? */
 /**
@@ -48,13 +44,12 @@ struct kioctx;
  * calls may result in undefined behaviour.
  */
 struct kiocb {
-	unsigned long		ki_flags;
 	atomic_t		ki_users;
 	unsigned		ki_key;		/* id of this request */
 
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* may be NULL for sync ops */
-	int			(*ki_cancel)(struct kiocb *, struct io_event *);
+	kiocb_cancel_fn		*ki_cancel;
 	ssize_t			(*ki_retry)(struct kiocb *);
 	void			(*ki_dtor)(struct kiocb *);
 
@@ -112,6 +107,7 @@ struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
+void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_put_req(struct kiocb *iocb) { }
@@ -121,6 +117,8 @@ static inline void exit_aio(struct mm_st
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
 				struct iocb __user * __user *iocbpp,
 				bool compat) { return 0; }
+static inline void kiocb_set_cancel_fn(struct kiocb *req,
+				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch

