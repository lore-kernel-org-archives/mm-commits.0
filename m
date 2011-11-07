From: akpm@linux-foundation.org
Subject: [merged] aio-allocate-kiocbs-in-batches.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:56 -0800
Message-ID: <201111072029.pA7KTuOk024574@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1KGUaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:30:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, dehrenberg@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: allocate kiocbs in batches
has been removed from the -mm tree.  Its filename was
     aio-allocate-kiocbs-in-batches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeff Moyer <jmoyer@redhat.com>
Subject: aio: allocate kiocbs in batches

In testing aio on a fast storage device, I found that the context lock
takes up a fair amount of cpu time in the I/O submission path.  The reason
is that we take it for every I/O submitted (see __aio_get_req).  Since we
know how many I/Os are passed to io_submit, we can preallocate the kiocbs
in batches, reducing the number of times we take and release the lock.

In my testing, I was able to reduce the amount of time spent in
_raw_spin_lock_irq by .56% (average of 3 runs).  The command I used to
test this was:

   aio-stress -O -o 2 -o 3 -r 8 -d 128 -b 32 -i 32 -s 16384 <dev>

I also tested the patch with various numbers of events passed to
io_submit, and I ran the xfstests aio group of tests to ensure I didn't
break anything.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Daniel Ehrenberg <dehrenberg@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |  136 +++++++++++++++++++++++++++++++++---------
 include/linux/aio.h |    1 
 2 files changed, 108 insertions(+), 29 deletions(-)

diff -puN fs/aio.c~aio-allocate-kiocbs-in-batches fs/aio.c
--- a/fs/aio.c~aio-allocate-kiocbs-in-batches
+++ a/fs/aio.c
@@ -440,8 +440,6 @@ void exit_aio(struct mm_struct *mm)
 static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
-	struct aio_ring *ring;
-	int okay = 0;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
@@ -459,39 +457,114 @@ static struct kiocb *__aio_get_req(struc
 	INIT_LIST_HEAD(&req->ki_run_list);
 	req->ki_eventfd = NULL;
 
-	/* Check if the completion queue has enough free space to
-	 * accept an event from this io.
-	 */
+	return req;
+}
+
+/*
+ * struct kiocb's are allocated in batches to reduce the number of
+ * times the ctx lock is acquired and released.
+ */
+#define KIOCB_BATCH_SIZE	32L
+struct kiocb_batch {
+	struct list_head head;
+	long count; /* number of requests left to allocate */
+};
+
+static void kiocb_batch_init(struct kiocb_batch *batch, long total)
+{
+	INIT_LIST_HEAD(&batch->head);
+	batch->count = total;
+}
+
+static void kiocb_batch_free(struct kiocb_batch *batch)
+{
+	struct kiocb *req, *n;
+
+	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
+		list_del(&req->ki_batch);
+		kmem_cache_free(kiocb_cachep, req);
+	}
+}
+
+/*
+ * Allocate a batch of kiocbs.  This avoids taking and dropping the
+ * context lock a lot during setup.
+ */
+static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
+{
+	unsigned short allocated, to_alloc;
+	long avail;
+	bool called_fput = false;
+	struct kiocb *req, *n;
+	struct aio_ring *ring;
+
+	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
+	for (allocated = 0; allocated < to_alloc; allocated++) {
+		req = __aio_get_req(ctx);
+		if (!req)
+			/* allocation failed, go with what we've got */
+			break;
+		list_add(&req->ki_batch, &batch->head);
+	}
+
+	if (allocated == 0)
+		goto out;
+
+retry:
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
-	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
+	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
+
+	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
+	BUG_ON(avail < 0);
+	if (avail == 0 && !called_fput) {
+		/*
+		 * Handle a potential starvation case.  It is possible that
+		 * we hold the last reference on a struct file, causing us
+		 * to delay the final fput to non-irq context.  In this case,
+		 * ctx->reqs_active is artificially high.  Calling the fput
+		 * routine here may free up a slot in the event completion
+		 * ring, allowing this allocation to succeed.
+		 */
+		kunmap_atomic(ring);
+		spin_unlock_irq(&ctx->ctx_lock);
+		aio_fput_routine(NULL);
+		called_fput = true;
+		goto retry;
+	}
+
+	if (avail < allocated) {
+		/* Trim back the number of requests. */
+		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
+			list_del(&req->ki_batch);
+			kmem_cache_free(kiocb_cachep, req);
+			if (--allocated <= avail)
+				break;
+		}
+	}
+
+	batch->count -= allocated;
+	list_for_each_entry(req, &batch->head, ki_batch) {
 		list_add(&req->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
-		okay = 1;
 	}
-	kunmap_atomic(ring, KM_USER0);
-	spin_unlock_irq(&ctx->ctx_lock);
 
-	if (!okay) {
-		kmem_cache_free(kiocb_cachep, req);
-		req = NULL;
-	}
+	kunmap_atomic(ring);
+	spin_unlock_irq(&ctx->ctx_lock);
 
-	return req;
+out:
+	return allocated;
 }
 
-static inline struct kiocb *aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx,
+					struct kiocb_batch *batch)
 {
 	struct kiocb *req;
-	/* Handle a potential starvation case -- should be exceedingly rare as 
-	 * requests will be stuck on fput_head only if the aio_fput_routine is 
-	 * delayed and the requests were the last user of the struct file.
-	 */
-	req = __aio_get_req(ctx);
-	if (unlikely(NULL == req)) {
-		aio_fput_routine(NULL);
-		req = __aio_get_req(ctx);
-	}
+
+	if (list_empty(&batch->head))
+		if (kiocb_batch_refill(ctx, batch) == 0)
+			return NULL;
+	req = list_first_entry(&batch->head, struct kiocb, ki_batch);
+	list_del(&req->ki_batch);
 	return req;
 }
 
@@ -1515,7 +1588,8 @@ static ssize_t aio_setup_iocb(struct kio
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, bool compat)
+			 struct iocb *iocb, struct kiocb_batch *batch,
+			 bool compat)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1541,7 +1615,7 @@ static int io_submit_one(struct kioctx *
 	if (unlikely(!file))
 		return -EBADF;
 
-	req = aio_get_req(ctx);		/* returns with 2 references to req */
+	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
 	if (unlikely(!req)) {
 		fput(file);
 		return -EAGAIN;
@@ -1621,8 +1695,9 @@ long do_io_submit(aio_context_t ctx_id, 
 {
 	struct kioctx *ctx;
 	long ret = 0;
-	int i;
+	int i = 0;
 	struct blk_plug plug;
+	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1639,6 +1714,8 @@ long do_io_submit(aio_context_t ctx_id, 
 		return -EINVAL;
 	}
 
+	kiocb_batch_init(&batch, nr);
+
 	blk_start_plug(&plug);
 
 	/*
@@ -1659,12 +1736,13 @@ long do_io_submit(aio_context_t ctx_id, 
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, &batch, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
+	kiocb_batch_free(&batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
diff -puN include/linux/aio.h~aio-allocate-kiocbs-in-batches include/linux/aio.h
--- a/include/linux/aio.h~aio-allocate-kiocbs-in-batches
+++ a/include/linux/aio.h
@@ -117,6 +117,7 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+	struct list_head	ki_batch;	/* batch allocation */
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch

