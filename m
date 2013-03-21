From: akpm@linux-foundation.org
Subject: + aio-reqs_active-reqs_available.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:24 -0700
Message-ID: <20130321223825.055A631C158@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42824 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3CUWi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:27 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so311105vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: reqs_active -> reqs_available
has been added to the -mm tree.  Its filename is
     aio-reqs_active-reqs_available.patch

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
Subject: aio: reqs_active -> reqs_available

The number of outstanding kiocbs is one of the few shared things left that
has to be touched for every kiocb - it'd be nice to make it percpu.

We can make it per cpu by treating it like an allocation problem: we have
a maximum number of kiocbs that can be outstanding (i.e.  slots) - then we
just allocate and free slots, and we know how to write per cpu allocators.

So as prep work for that, we convert reqs_active to reqs_available.

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

 fs/aio.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN fs/aio.c~aio-reqs_active-reqs_available fs/aio.c
--- a/fs/aio.c~aio-reqs_active-reqs_available
+++ a/fs/aio.c
@@ -89,7 +89,13 @@ struct kioctx {
 	struct work_struct	rcu_work;
 
 	struct {
-		atomic_t	reqs_active;
+		/*
+		 * This counts the number of available slots in the ringbuffer,
+		 * so we avoid overflowing it: it's decremented (if positive)
+		 * when allocating a kiocb and incremented when the resulting
+		 * io_event is pulled off the ringbuffer.
+		 */
+		atomic_t	reqs_available;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -306,17 +312,17 @@ static void free_ioctx(struct kioctx *ct
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_active) > 0) {
+	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
 		wait_event(ctx->wait, head != ctx->tail);
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
+		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
 		head %= ctx->nr_events;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_active) < 0);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);
 
 	aio_free_ring(ctx);
 
@@ -380,6 +386,8 @@ static struct kioctx *ioctx_alloc(unsign
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freectx;
 
+	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||
@@ -482,7 +490,7 @@ void exit_aio(struct mm_struct *mm)
 				"exit_aio:ioctx still alive: %d %d %d\n",
 				atomic_read(&ctx->users),
 				atomic_read(&ctx->dead),
-				atomic_read(&ctx->reqs_active));
+				atomic_read(&ctx->reqs_available));
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
@@ -514,12 +522,9 @@ static inline struct kiocb *aio_get_req(
 {
 	struct kiocb *req;
 
-	if (atomic_read(&ctx->reqs_active) >= ctx->nr_events)
+	if (atomic_dec_if_positive(&ctx->reqs_available) <= 0)
 		return NULL;
 
-	if (atomic_inc_return(&ctx->reqs_active) > ctx->nr_events - 1)
-		goto out_put;
-
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
 		goto out_put;
@@ -529,7 +534,7 @@ static inline struct kiocb *aio_get_req(
 
 	return req;
 out_put:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	return NULL;
 }
 
@@ -600,7 +605,7 @@ void aio_complete(struct kiocb *iocb, lo
 
 	/*
 	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after decrementing reqs_active.
+	 * need to issue a wakeup after incrementing reqs_available.
 	 */
 	rcu_read_lock();
 
@@ -618,7 +623,7 @@ void aio_complete(struct kiocb *iocb, lo
 	 */
 	if (unlikely(xchg(&iocb->ki_cancel,
 			  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-		atomic_dec(&ctx->reqs_active);
+		atomic_inc(&ctx->reqs_available);
 		/* Still need the wake_up in case free_ioctx is waiting */
 		goto put_rq;
 	}
@@ -755,7 +760,7 @@ static long aio_read_events_ring(struct
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
 
-	atomic_sub(ret, &ctx->reqs_active);
+	atomic_add(ret, &ctx->reqs_available);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
@@ -1188,7 +1193,7 @@ static int io_submit_one(struct kioctx *
 	return 0;
 
 out_put_req:
-	atomic_dec(&ctx->reqs_active);
+	atomic_inc(&ctx->reqs_available);
 	aio_put_req(req);	/* drop extra ref to req */
 	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
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

