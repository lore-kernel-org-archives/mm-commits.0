From: akpm@linux-foundation.org
Subject: [merged] aio-change-reqs_active-to-include-unreaped-completions.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:37 -0700
Message-ID: <20130508183537.E83F631C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58095 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3EHSfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:39 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so208255qcz.4
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: change reqs_active to include unreaped completions
has been removed from the -mm tree.  Its filename was
     aio-change-reqs_active-to-include-unreaped-completions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: change reqs_active to include unreaped completions

The aio code tries really hard to avoid having to deal with the completion
ringbuffer overflowing.  To do that, it has to keep track of the number of
outstanding kiocbs, and the number of completions currently in the
ringbuffer - and it's got to check that every time we allocate a kiocb.
Ouch.

But - we can improve this quite a bit if we just change reqs_active to
mean "number of outstanding requests and unreaped completions" - that
means kiocb allocation doesn't have to look at the ringbuffer, which is a
fairly significant win.

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
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff -puN fs/aio.c~aio-change-reqs_active-to-include-unreaped-completions fs/aio.c
--- a/fs/aio.c~aio-change-reqs_active-to-include-unreaped-completions
+++ a/fs/aio.c
@@ -71,12 +71,6 @@ struct aio_ring_info {
 	struct page		*internal_pages[AIO_RING_PAGES];
 };
 
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
 struct kioctx {
 	atomic_t		users;
 	atomic_t		dead;
@@ -92,7 +86,13 @@ struct kioctx {
 	atomic_t		reqs_active;
 	struct list_head	active_reqs;	/* used for cancellation */
 
-	/* sys_io_setup currently limits this to an unsigned int */
+	/*
+	 * This is what userspace passed to io_setup(), it's not used for
+	 * anything but counting against the global max_reqs quota.
+	 *
+	 * The real limit is ring->nr - 1, which will be larger (see
+	 * aio_setup_ring())
+	 */
 	unsigned		max_reqs;
 
 	struct aio_ring_info	ring_info;
@@ -284,8 +284,11 @@ static void free_ioctx_rcu(struct rcu_he
  */
 static void free_ioctx(struct kioctx *ctx)
 {
+	struct aio_ring_info *info = &ctx->ring_info;
+	struct aio_ring *ring;
 	struct io_event res;
 	struct kiocb *req;
+	unsigned head, avail;
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -299,7 +302,21 @@ static void free_ioctx(struct kioctx *ct
 
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	wait_event(ctx->wait, !atomic_read(&ctx->reqs_active));
+	ring = kmap_atomic(info->ring_pages[0]);
+	head = ring->head;
+	kunmap_atomic(ring);
+
+	while (atomic_read(&ctx->reqs_active) > 0) {
+		wait_event(ctx->wait, head != info->tail);
+
+		avail = (head <= info->tail ? info->tail : info->nr) - head;
+
+		atomic_sub(avail, &ctx->reqs_active);
+		head += avail;
+		head %= info->nr;
+	}
+
+	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
 
 	aio_free_ring(ctx);
 
@@ -548,7 +565,6 @@ static int kiocb_batch_refill(struct kio
 	unsigned short allocated, to_alloc;
 	long avail;
 	struct kiocb *req, *n;
-	struct aio_ring *ring;
 
 	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
 	for (allocated = 0; allocated < to_alloc; allocated++) {
@@ -563,10 +579,8 @@ static int kiocb_batch_refill(struct kio
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) -
-				atomic_read(&ctx->reqs_active);
+	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active) - 1;
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -581,7 +595,6 @@ static int kiocb_batch_refill(struct kio
 	batch->count -= allocated;
 	atomic_add(allocated, &ctx->reqs_active);
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -688,8 +701,11 @@ void aio_complete(struct kiocb *iocb, lo
 	 * when the event got cancelled.
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
-			  KIOCB_CANCELLED) == KIOCB_CANCELLED))
+			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
+		atomic_dec(&ctx->reqs_active);
+		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
+	}
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
@@ -746,7 +762,6 @@ void aio_complete(struct kiocb *iocb, lo
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
-	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -825,6 +840,8 @@ static long aio_read_events_ring(struct
 	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
+
+	atomic_sub(ret, &ctx->reqs_active);
 out:
 	mutex_unlock(&info->ring_lock);
 
_

Patches currently in -mm which might be from koverstreet@google.com are

origin.patch
linux-next.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

