From: akpm@linux-foundation.org
Subject: + aio-change-reqs_active-to-include-unreaped-completions.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:12 -0700
Message-ID: <20130321223813.0A74531C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:54013 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CUWiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:14 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so311126yen.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: change reqs_active to include unreaped completions
has been added to the -mm tree.  Its filename is
     aio-change-reqs_active-to-include-unreaped-completions.patch

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
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

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
@@ -563,9 +579,8 @@ static int kiocb_batch_refill(struct kio
 		goto out;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
 
-	avail = aio_ring_avail(&ctx->ring_info, ring) - atomic_read(&ctx->reqs_active);
+	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active) - 1;
 	BUG_ON(avail < 0);
 	if (avail < allocated) {
 		/* Trim back the number of requests. */
@@ -580,7 +595,6 @@ static int kiocb_batch_refill(struct kio
 	batch->count -= allocated;
 	atomic_add(allocated, &ctx->reqs_active);
 
-	kunmap_atomic(ring);
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
@@ -687,8 +701,11 @@ void aio_complete(struct kiocb *iocb, lo
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
@@ -745,7 +762,6 @@ void aio_complete(struct kiocb *iocb, lo
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
-	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -822,6 +838,8 @@ static long aio_read_events_ring(struct
 	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
+
+	atomic_sub(ret, &ctx->reqs_active);
 out:
 	mutex_unlock(&info->ring_lock);
 
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

