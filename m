From: akpm@linux-foundation.org
Subject: + block-aio-batch-completion-for-bios-kiocbs.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:39 -0800
Message-ID: <20130103234140.1C25B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:51676 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3ACXlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:41:44 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so986373eek.2
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:41:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: block, aio: batch completion for bios/kiocbs
has been added to the -mm tree.  Its filename is
     block-aio-batch-completion-for-bios-kiocbs.patch

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
Subject: block, aio: batch completion for bios/kiocbs

When completing a kiocb, there's some fixed overhead from touching the
kioctx's ring buffer the kiocb belongs to.  Some newer high end block
devices can complete multiple IOs per interrupt, much like many network
interfaces have been for some time.

This plumbs through infrastructure so we can take advantage of multiple
completions at the interrupt level, and complete multiple kiocbs at the
same time.

Drivers have to be converted to take advantage of this, but it's a simple
change and the next patches will convert a few drivers.

To use it, an interrupt handler (or any code that completes bios or
requests) declares and initializes a struct batch_complete:

struct batch_complete batch;
batch_complete_init(&batch);

Then, instead of calling bio_endio(), it calls
bio_endio_batch(bio, err, &batch). This just adds the bio to a list in
the batch_complete.

At the end, it calls

batch_complete(&batch);

This completes all the bios all at once, building up a list of kiocbs;
then the list of kiocbs are completed all at once.

Also, in order to batch up the kiocbs we have to add a different bio_endio
function to struct bio, that takes a pointer to the batch_complete - this
patch converts the dio code's bio_endio function.  In order to avoid
changing every bio_endio function in the kernel (there are many), we
currently use a union and a flag to indicate what kind of bio endio
function to call.  This is admittedly a hack, but should suffice for now.

For batching to work through say md or dm devices, the md/dm bio_endio
functions would have to be converted, much like the dio code.  That is
left for future patches.

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

 block/blk-core.c          |   34 ++--
 block/blk-flush.c         |    2 
 block/blk.h               |    3 
 drivers/block/swim3.c     |    2 
 drivers/md/dm.c           |    2 
 fs/aio.c                  |  254 ++++++++++++++++++++++++------------
 fs/bio.c                  |   52 ++++---
 fs/direct-io.c            |   20 +-
 include/linux/aio.h       |   22 ++-
 include/linux/bio.h       |   36 ++++-
 include/linux/blk_types.h |   11 +
 include/linux/blkdev.h    |   12 +
 12 files changed, 311 insertions(+), 139 deletions(-)

diff -puN block/blk-core.c~block-aio-batch-completion-for-bios-kiocbs block/blk-core.c
--- a/block/blk-core.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/block/blk-core.c
@@ -152,7 +152,8 @@ void blk_rq_init(struct request_queue *q
 EXPORT_SYMBOL(blk_rq_init);
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
-			  unsigned int nbytes, int error)
+			  unsigned int nbytes, int error,
+			  struct batch_complete *batch)
 {
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -176,7 +177,7 @@ static void req_bio_endio(struct request
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
+		bio_endio_batch(bio, error, batch);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -2256,7 +2257,8 @@ EXPORT_SYMBOL(blk_fetch_request);
  *     %false - this request doesn't have any more data
  *     %true  - this request has more data
  **/
-bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
+bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
+			struct batch_complete *batch)
 {
 	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
@@ -2312,7 +2314,7 @@ bool blk_update_request(struct request *
 		if (nr_bytes >= bio->bi_size) {
 			req->bio = bio->bi_next;
 			nbytes = bio->bi_size;
-			req_bio_endio(req, bio, nbytes, error);
+			req_bio_endio(req, bio, nbytes, error, batch);
 			next_idx = 0;
 			bio_nbytes = 0;
 		} else {
@@ -2374,7 +2376,7 @@ bool blk_update_request(struct request *
 	 * if the request wasn't completed, update state
 	 */
 	if (bio_nbytes) {
-		req_bio_endio(req, bio, bio_nbytes, error);
+		req_bio_endio(req, bio, bio_nbytes, error, batch);
 		bio->bi_idx += next_idx;
 		bio_iovec(bio)->bv_offset += nr_bytes;
 		bio_iovec(bio)->bv_len -= nr_bytes;
@@ -2411,14 +2413,15 @@ EXPORT_SYMBOL_GPL(blk_update_request);
 
 static bool blk_update_bidi_request(struct request *rq, int error,
 				    unsigned int nr_bytes,
-				    unsigned int bidi_bytes)
+				    unsigned int bidi_bytes,
+				    struct batch_complete *batch)
 {
-	if (blk_update_request(rq, error, nr_bytes))
+	if (blk_update_request(rq, error, nr_bytes, batch))
 		return true;
 
 	/* Bidi request must be completed as a whole */
 	if (unlikely(blk_bidi_rq(rq)) &&
-	    blk_update_request(rq->next_rq, error, bidi_bytes))
+	    blk_update_request(rq->next_rq, error, bidi_bytes, batch))
 		return true;
 
 	if (blk_queue_add_random(rq->q))
@@ -2501,7 +2504,7 @@ static bool blk_end_bidi_request(struct 
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, NULL))
 		return true;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2527,9 +2530,10 @@ static bool blk_end_bidi_request(struct 
  *     %true  - still buffers pending for this request
  **/
 bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes, unsigned int bidi_bytes)
+				   unsigned int nr_bytes, unsigned int bidi_bytes,
+				   struct batch_complete *batch)
 {
-	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, batch))
 		return true;
 
 	blk_finish_request(rq, error);
@@ -2630,7 +2634,7 @@ EXPORT_SYMBOL_GPL(blk_end_request_err);
  **/
 bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
+	return __blk_end_bidi_request(rq, error, nr_bytes, 0, NULL);
 }
 EXPORT_SYMBOL(__blk_end_request);
 
@@ -2642,7 +2646,7 @@ EXPORT_SYMBOL(__blk_end_request);
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
  */
-void __blk_end_request_all(struct request *rq, int error)
+void blk_end_request_all_batch(struct request *rq, int error, struct batch_complete *batch)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2650,10 +2654,10 @@ void __blk_end_request_all(struct reques
 	if (unlikely(blk_bidi_rq(rq)))
 		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes, batch);
 	BUG_ON(pending);
 }
-EXPORT_SYMBOL(__blk_end_request_all);
+EXPORT_SYMBOL(blk_end_request_all_batch);
 
 /**
  * __blk_end_request_cur - Helper function to finish the current request chunk.
diff -puN block/blk-flush.c~block-aio-batch-completion-for-bios-kiocbs block/blk-flush.c
--- a/block/blk-flush.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/block/blk-flush.c
@@ -316,7 +316,7 @@ void blk_insert_flush(struct request *rq
 	 * complete the request.
 	 */
 	if (!policy) {
-		__blk_end_bidi_request(rq, 0, 0, 0);
+		__blk_end_bidi_request(rq, 0, 0, 0, NULL);
 		return;
 	}
 
diff -puN block/blk.h~block-aio-batch-completion-for-bios-kiocbs block/blk.h
--- a/block/blk.h~block-aio-batch-completion-for-bios-kiocbs
+++ a/block/blk.h
@@ -31,7 +31,8 @@ void blk_queue_bypass_end(struct request
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
-			    unsigned int nr_bytes, unsigned int bidi_bytes);
+			    unsigned int nr_bytes, unsigned int bidi_bytes,
+			    struct batch_complete *batch);
 
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
diff -puN drivers/block/swim3.c~block-aio-batch-completion-for-bios-kiocbs drivers/block/swim3.c
--- a/drivers/block/swim3.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/drivers/block/swim3.c
@@ -775,7 +775,7 @@ static irqreturn_t swim3_interrupt(int i
 		if (intr & ERROR_INTR) {
 			n = fs->scount - 1 - resid / 512;
 			if (n > 0) {
-				blk_update_request(req, 0, n << 9);
+				blk_update_request(req, 0, n << 9, NULL);
 				fs->req_sector += n;
 			}
 			if (fs->retries < 5) {
diff -puN drivers/md/dm.c~block-aio-batch-completion-for-bios-kiocbs drivers/md/dm.c
--- a/drivers/md/dm.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/drivers/md/dm.c
@@ -712,7 +712,7 @@ static void end_clone_bio(struct bio *cl
 	 * Do not use blk_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
+	blk_update_request(tio->orig, 0, nr_bytes, NULL);
 }
 
 /*
diff -puN fs/aio.c~block-aio-batch-completion-for-bios-kiocbs fs/aio.c
--- a/fs/aio.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/fs/aio.c
@@ -621,71 +621,11 @@ static struct kioctx *lookup_ioctx(unsig
 	return ret;
 }
 
-/* aio_complete
- *	Called when the io request on the given iocb is complete.
- */
-void aio_complete(struct kiocb *iocb, long res, long res2)
+static inline unsigned kioctx_ring_put(struct kioctx *ctx, struct kiocb *req,
+				       unsigned tail)
 {
-	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
-	unsigned long	flags;
-	unsigned tail, pos;
-
-	/*
-	 * Special case handling for sync iocbs:
-	 *  - events go directly into the iocb for fast handling
-	 *  - the sync task with the iocb in its stack holds the single iocb
-	 *    ref, no other paths have a way to get another ref
-	 *  - the sync task helpfully left a reference to itself in the iocb
-	 */
-	if (is_sync_kiocb(iocb)) {
-		BUG_ON(atomic_read(&iocb->ki_users) != 1);
-		iocb->ki_user_data = res;
-		atomic_set(&iocb->ki_users, 0);
-		wake_up_process(iocb->ki_obj.tsk);
-		return;
-	}
-
-	/*
-	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after incrementing reqs_available.
-	 */
-	rcu_read_lock();
-
-	if (iocb->ki_list.next) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
-		list_del(&iocb->ki_list);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	}
-
-	/*
-	 * cancelled requests don't get events, userland was given one
-	 * when the event got cancelled.
-	 */
-	if (unlikely(xchg(&iocb->ki_cancel,
-			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-		/*
-		 * Can't use the percpu reqs_available here - could race with
-		 * free_ioctx()
-		 */
-		atomic_inc(&ctx->reqs_available);
-		smp_mb__after_atomic_inc();
-		/* Still need the wake_up in case free_ioctx is waiting */
-		goto put_rq;
-	}
-
-	/*
-	 * Add a completion event to the ring buffer; ctx->tail is both our lock
-	 * and the canonical version of the tail pointer.
-	 */
-	local_irq_save(flags);
-	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
-		cpu_relax();
-
-	pos = tail + AIO_EVENTS_OFFSET;
+	unsigned pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr)
 		tail = 0;
@@ -693,22 +633,41 @@ void aio_complete(struct kiocb *iocb, lo
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
-	event->data = iocb->ki_user_data;
-	event->res = res;
-	event->res2 = res2;
+	event->obj	= (u64) req->ki_obj.user;
+	event->data	= req->ki_user_data;
+	event->res	= req->ki_res;
+	event->res2	= req->ki_res2;
 
 	kunmap_atomic(ev_page);
 	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
 	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
-		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		 res, res2);
+		 ctx, tail, req, req->ki_obj.user, req->ki_user_data,
+		 req->ki_res, req->ki_res2);
+
+	return tail;
+}
+
+static inline unsigned kioctx_ring_lock(struct kioctx *ctx)
+{
+	unsigned tail;
 
-	/* after flagging the request as done, we
-	 * must never even look at it again
+	/*
+	 * ctx->tail is both our lock and the canonical version of the tail
+	 * pointer.
 	 */
-	smp_wmb();	/* make event visible before updating tail */
+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
+		cpu_relax();
+
+	return tail;
+}
+
+static inline void kioctx_ring_unlock(struct kioctx *ctx, unsigned tail)
+{
+	struct aio_ring *ring;
+
+	smp_wmb();
+	/* make event visible before updating tail */
 
 	ctx->shadow_tail = tail;
 
@@ -721,28 +680,157 @@ void aio_complete(struct kiocb *iocb, lo
 	smp_mb();
 
 	ctx->tail = tail;
-	local_irq_restore(flags);
 
-	pr_debug("added to ring %p at [%u]\n", iocb, tail);
+	if (waitqueue_active(&ctx->wait))
+		wake_up(&ctx->wait);
+}
+
+void batch_complete_aio(struct batch_complete *batch)
+{
+	struct kioctx *ctx = NULL;
+	struct eventfd_ctx *eventfd = NULL;
+	struct rb_node *n;
+	unsigned long flags;
+	unsigned tail = 0;
+
+	if (RB_EMPTY_ROOT(&batch->kiocb))
+		return;
+
+	/*
+	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
+	 * need to issue a wakeup after incrementing reqs_available.
+	 */
+	rcu_read_lock();
+	local_irq_save(flags);
+
+	n = rb_first(&batch->kiocb);
+	while (n) {
+		struct kiocb *req = container_of(n, struct kiocb, ki_node);
+
+		if (n->rb_right) {
+			n->rb_right->__rb_parent_color = n->__rb_parent_color;
+			n = n->rb_right;
+
+			while (n->rb_left)
+				n = n->rb_left;
+		} else {
+			n = rb_parent(n);
+		}
+
+		if (unlikely(xchg(&req->ki_cancel,
+				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
+			/*
+			 * Can't use the percpu reqs_available here - could race
+			 * with free_ioctx()
+			 */
+			atomic_inc(&req->ki_ctx->reqs_available);
+			aio_put_req(req);
+			continue;
+		}
+
+		if (unlikely(req->ki_eventfd != eventfd)) {
+			if (eventfd) {
+				/* Make event visible */
+				kioctx_ring_unlock(ctx, tail);
+				ctx = NULL;
+
+				eventfd_signal(eventfd, 1);
+				eventfd_ctx_put(eventfd);
+			}
+
+			eventfd = req->ki_eventfd;
+			req->ki_eventfd = NULL;
+		}
+
+		if (unlikely(req->ki_ctx != ctx)) {
+			if (ctx)
+				kioctx_ring_unlock(ctx, tail);
+
+			ctx = req->ki_ctx;
+			tail = kioctx_ring_lock(ctx);
+		}
+
+		tail = kioctx_ring_put(ctx, req, tail);
+		aio_put_req(req);
+	}
+
+	kioctx_ring_unlock(ctx, tail);
+	local_irq_restore(flags);
+	rcu_read_unlock();
 
 	/*
 	 * Check if the user asked us to deliver the result through an
 	 * eventfd. The eventfd_signal() function is safe to be called
 	 * from IRQ context.
 	 */
-	if (iocb->ki_eventfd != NULL)
-		eventfd_signal(iocb->ki_eventfd, 1);
+	if (eventfd) {
+		eventfd_signal(eventfd, 1);
+		eventfd_ctx_put(eventfd);
+	}
+}
+EXPORT_SYMBOL(batch_complete_aio);
 
-put_rq:
-	/* everything turned out well, dispose of the aiocb. */
-	aio_put_req(iocb);
+/* aio_complete_batch
+ *	Called when the io request on the given iocb is complete; @batch may be
+ *	NULL.
+ */
+void aio_complete_batch(struct kiocb *req, long res, long res2,
+			struct batch_complete *batch)
+{
+	req->ki_res = res;
+	req->ki_res2 = res2;
 
-	if (waitqueue_active(&ctx->wait))
-		wake_up(&ctx->wait);
+	if (req->ki_list.next) {
+		struct kioctx *ctx = req->ki_ctx;
+		unsigned long flags;
 
-	rcu_read_unlock();
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&req->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
+
+	/*
+	 * Special case handling for sync iocbs:
+	 *  - events go directly into the iocb for fast handling
+	 *  - the sync task with the iocb in its stack holds the single iocb
+	 *    ref, no other paths have a way to get another ref
+	 *  - the sync task helpfully left a reference to itself in the iocb
+	 */
+	if (is_sync_kiocb(req)) {
+		BUG_ON(atomic_read(&req->ki_users) != 1);
+		req->ki_user_data = req->ki_res;
+		atomic_set(&req->ki_users, 0);
+		wake_up_process(req->ki_obj.tsk);
+	} else if (batch) {
+		int res;
+		struct kiocb *t;
+		struct rb_node **n = &batch->kiocb.rb_node, *parent = NULL;
+
+		while (*n) {
+			parent = *n;
+			t = container_of(*n, struct kiocb, ki_node);
+
+			res = req->ki_ctx != t->ki_ctx
+				? req->ki_ctx < t->ki_ctx
+				: req->ki_eventfd != t->ki_eventfd
+				? req->ki_eventfd < t->ki_eventfd
+				: req < t;
+
+			n = res ? &(*n)->rb_left : &(*n)->rb_right;
+		}
+
+		rb_link_node(&req->ki_node, parent, n);
+		rb_insert_color(&req->ki_node, &batch->kiocb);
+	} else {
+		struct batch_complete batch_stack;
+
+		memset(&req->ki_node, 0, sizeof(req->ki_node));
+		batch_stack.kiocb.rb_node = &req->ki_node;
+
+		batch_complete_aio(&batch_stack);
+	}
 }
-EXPORT_SYMBOL(aio_complete);
+EXPORT_SYMBOL(aio_complete_batch);
 
 /* aio_read_events
  *	Pull an event off of the ioctx's event ring.  Returns the number of
diff -puN fs/bio.c~block-aio-batch-completion-for-bios-kiocbs fs/bio.c
--- a/fs/bio.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/fs/bio.c
@@ -27,6 +27,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/aio.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include <trace/events/block.h>
@@ -1407,31 +1408,42 @@ void bio_flush_dcache_pages(struct bio *
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
 
-/**
- * bio_endio - end I/O on a bio
- * @bio:	bio
- * @error:	error, if any
- *
- * Description:
- *   bio_endio() will end I/O on the whole bio. bio_endio() is the
- *   preferred way to end I/O on a bio, it takes care of clearing
- *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
- *   established -Exxxx (-EIO, for instance) error values in case
- *   something went wrong. No one should call bi_end_io() directly on a
- *   bio unless they own it and thus know that it has an end_io
- *   function.
- **/
-void bio_endio(struct bio *bio, int error)
+static inline void __bio_endio(struct bio *bio, struct batch_complete *batch)
 {
-	if (error)
+	if (bio->bi_error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+		bio->bi_error = -EIO;
+
+	if (bio_flagged(bio, BIO_BATCH_ENDIO))
+		bio->bi_batch_end_io(bio, bio->bi_error, batch);
+	else if (bio->bi_end_io)
+		bio->bi_end_io(bio, bio->bi_error);
+}
+
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch)
+{
+	if (error)
+		bio->bi_error = error;
+
+	if (batch)
+		bio_list_add(&batch->bio, bio);
+	else
+		__bio_endio(bio, batch);
+
+}
+EXPORT_SYMBOL(bio_endio_batch);
+
+void batch_complete(struct batch_complete *batch)
+{
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->bio)))
+		__bio_endio(bio, batch);
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	batch_complete_aio(batch);
 }
-EXPORT_SYMBOL(bio_endio);
+EXPORT_SYMBOL(batch_complete);
 
 void bio_pair_release(struct bio_pair *bp)
 {
diff -puN fs/direct-io.c~block-aio-batch-completion-for-bios-kiocbs fs/direct-io.c
--- a/fs/direct-io.c~block-aio-batch-completion-for-bios-kiocbs
+++ a/fs/direct-io.c
@@ -230,7 +230,8 @@ static inline struct page *dio_get_page(
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async,
+			    struct batch_complete *batch)
 {
 	ssize_t transferred = 0;
 
@@ -263,7 +264,7 @@ static ssize_t dio_complete(struct dio *
 			    dio->private, ret, is_async);
 	} else {
 		if (is_async)
-			aio_complete(dio->iocb, ret, 0);
+			aio_complete_batch(dio->iocb, ret, 0, batch);
 		inode_dio_done(dio->inode);
 	}
 
@@ -274,7 +275,7 @@ static int dio_bio_complete(struct dio *
 /*
  * Asynchronous IO callback. 
  */
-static void dio_bio_end_aio(struct bio *bio, int error)
+static void dio_bio_end_aio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long remaining;
@@ -290,7 +291,7 @@ static void dio_bio_end_aio(struct bio *
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
-		dio_complete(dio, dio->iocb->ki_pos, 0, true);
+		dio_complete(dio, dio->iocb->ki_pos, 0, true, batch);
 		kmem_cache_free(dio_cache, dio);
 	}
 }
@@ -329,7 +330,7 @@ void dio_end_io(struct bio *bio, int err
 	struct dio *dio = bio->bi_private;
 
 	if (dio->is_async)
-		dio_bio_end_aio(bio, error);
+		dio_bio_end_aio(bio, error, NULL);
 	else
 		dio_bio_end_io(bio, error);
 }
@@ -350,9 +351,10 @@ dio_bio_alloc(struct dio *dio, struct di
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
-	if (dio->is_async)
-		bio->bi_end_io = dio_bio_end_aio;
-	else
+	if (dio->is_async) {
+		bio->bi_batch_end_io = dio_bio_end_aio;
+		bio->bi_flags |= 1 << BIO_BATCH_ENDIO;
+	} else
 		bio->bi_end_io = dio_bio_end_io;
 
 	sdio->bio = bio;
@@ -1273,7 +1275,7 @@ do_blockdev_direct_IO(int rw, struct kio
 		dio_await_completion(dio);
 
 	if (drop_refcount(dio) == 0) {
-		retval = dio_complete(dio, offset, retval, false);
+		retval = dio_complete(dio, offset, retval, false, NULL);
 		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
diff -puN include/linux/aio.h~block-aio-batch-completion-for-bios-kiocbs include/linux/aio.h
--- a/include/linux/aio.h~block-aio-batch-completion-for-bios-kiocbs
+++ a/include/linux/aio.h
@@ -6,11 +6,12 @@
 #include <linux/aio_abi.h>
 #include <linux/uio.h>
 #include <linux/rcupdate.h>
-
 #include <linux/atomic.h>
+#include <linux/rbtree.h>
 
 struct kioctx;
 struct kiocb;
+struct batch_complete;
 
 #define KIOCB_KEY		0
 
@@ -19,6 +20,8 @@ struct kiocb;
 typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
 
 struct kiocb {
+	struct rb_node		ki_node;
+
 	atomic_t		ki_users;
 
 	struct file		*ki_filp;
@@ -32,6 +35,9 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
+	long			ki_res;
+	long			ki_res2;
+
 	loff_t			ki_pos;
 
 	void			*private;
@@ -74,7 +80,9 @@ static inline void init_sync_kiocb(struc
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern void aio_put_req(struct kiocb *iocb);
-extern void aio_complete(struct kiocb *iocb, long res, long res2);
+extern void batch_complete_aio(struct batch_complete *batch);
+extern void aio_complete_batch(struct kiocb *iocb, long res, long res2,
+			       struct batch_complete *batch);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
@@ -83,7 +91,10 @@ void kiocb_set_cancel_fn(struct kiocb *r
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_put_req(struct kiocb *iocb) { }
-static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
+
+static inline void batch_complete_aio(struct batch_complete *batch) { }
+static inline void aio_complete_batch(struct kiocb *iocb, long res, long res2,
+				      struct batch_complete *batch) { return 0; }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
@@ -93,6 +104,11 @@ static inline void kiocb_set_cancel_fn(s
 				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
+static inline void aio_complete(struct kiocb *iocb, long res, long res2)
+{
+	aio_complete_batch(iocb, res, res2, NULL);
+}
+
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);
diff -puN include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs include/linux/bio.h
--- a/include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs
+++ a/include/linux/bio.h
@@ -241,7 +241,27 @@ static inline struct bio *bio_clone_kmal
 
 }
 
-extern void bio_endio(struct bio *, int);
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
+
+/**
+ * bio_endio - end I/O on a bio
+ * @bio:	bio
+ * @error:	error, if any
+ *
+ * Description:
+ *   bio_endio() will end I/O on the whole bio. bio_endio() is the
+ *   preferred way to end I/O on a bio, it takes care of clearing
+ *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
+ *   established -Exxxx (-EIO, for instance) error values in case
+ *   something went wrong. No one should call bi_end_io() directly on a
+ *   bio unless they own it and thus know that it has an end_io
+ *   function.
+ **/
+static inline void bio_endio(struct bio *bio, int error)
+{
+	bio_endio_batch(bio, error, NULL);
+}
+
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
@@ -527,6 +547,20 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
+struct batch_complete {
+	struct bio_list		bio;
+	struct rb_root		kiocb;
+};
+
+static inline void batch_complete_init(struct batch_complete *batch)
+{
+	bio_list_init(&batch->bio);
+	batch->kiocb = RB_ROOT;
+}
+
+void batch_complete(struct batch_complete *batch);
+
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
diff -puN include/linux/blk_types.h~block-aio-batch-completion-for-bios-kiocbs include/linux/blk_types.h
--- a/include/linux/blk_types.h~block-aio-batch-completion-for-bios-kiocbs
+++ a/include/linux/blk_types.h
@@ -16,7 +16,9 @@ struct page;
 struct block_device;
 struct io_context;
 struct cgroup_subsys_state;
+struct batch_complete;
 typedef void (bio_end_io_t) (struct bio *, int);
+typedef void (bio_batch_end_io_t) (struct bio *, int, struct batch_complete *);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
@@ -42,6 +44,7 @@ struct bio {
 						 * top bits priority
 						 */
 
+	short			bi_error;
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
 
@@ -59,7 +62,10 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
-	bio_end_io_t		*bi_end_io;
+	union {
+		bio_end_io_t	*bi_end_io;
+		bio_batch_end_io_t *bi_batch_end_io;
+	};
 
 	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
@@ -111,12 +117,13 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#define BIO_BATCH_ENDIO	12
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
  */
-#define BIO_RESET_BITS	12
+#define BIO_RESET_BITS	13
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
diff -puN include/linux/blkdev.h~block-aio-batch-completion-for-bios-kiocbs include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-aio-batch-completion-for-bios-kiocbs
+++ a/include/linux/blkdev.h
@@ -875,7 +875,8 @@ extern struct request *blk_fetch_request
  * This prevents code duplication in drivers.
  */
 extern bool blk_update_request(struct request *rq, int error,
-			       unsigned int nr_bytes);
+			       unsigned int nr_bytes,
+			       struct batch_complete *batch);
 extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
 extern void blk_end_request_all(struct request *rq, int error);
@@ -883,10 +884,17 @@ extern bool blk_end_request_cur(struct r
 extern bool blk_end_request_err(struct request *rq, int error);
 extern bool __blk_end_request(struct request *rq, int error,
 			      unsigned int nr_bytes);
-extern void __blk_end_request_all(struct request *rq, int error);
 extern bool __blk_end_request_cur(struct request *rq, int error);
 extern bool __blk_end_request_err(struct request *rq, int error);
 
+extern void blk_end_request_all_batch(struct request *rq, int error,
+				      struct batch_complete *batch);
+
+static inline void __blk_end_request_all(struct request *rq, int error)
+{
+	blk_end_request_all_batch(rq, error, NULL);
+}
+
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
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

