From: akpm@linux-foundation.org
Subject: + aio-kill-batch-allocation.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:15 -0700
Message-ID: <20130321223816.05A7D5A421E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38335 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3CUWiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:18 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so319962qah.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: aio: kill batch allocation
has been added to the -mm tree.  Its filename is
     aio-kill-batch-allocation.patch

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
Subject: aio: kill batch allocation

Previously, allocating a kiocb required touching quite a few global (well,
per kioctx) cachelines...  so batching up allocation to amortize those was
worthwhile.  But we've gotten rid of some of those, and in another couple
of patches kiocb allocation won't require writing to any shared
cachelines, so that means we can just rip this code out.

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

 fs/aio.c            |  116 +++++-------------------------------------
 include/linux/aio.h |    1 
 2 files changed, 15 insertions(+), 102 deletions(-)

diff -puN fs/aio.c~aio-kill-batch-allocation fs/aio.c
--- a/fs/aio.c~aio-kill-batch-allocation
+++ a/fs/aio.c
@@ -510,108 +510,27 @@ void exit_aio(struct mm_struct *mm)
  * This prevents races between the aio code path referencing the
  * req (after submitting it) and aio_complete() freeing the req.
  */
-static struct kiocb *__aio_get_req(struct kioctx *ctx)
+static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 {
-	struct kiocb *req = NULL;
+	struct kiocb *req;
+
+	if (atomic_read(&ctx->reqs_active) >= ctx->ring_info.nr)
+		return NULL;
+
+	if (atomic_inc_return(&ctx->reqs_active) > ctx->ring_info.nr - 1)
+		goto out_put;
 
 	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
 	if (unlikely(!req))
-		return NULL;
+		goto out_put;
 
 	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
 
 	return req;
-}
-
-/*
- * struct kiocb's are allocated in batches to reduce the number of
- * times the ctx lock is acquired and released.
- */
-#define KIOCB_BATCH_SIZE	32L
-struct kiocb_batch {
-	struct list_head head;
-	long count; /* number of requests left to allocate */
-};
-
-static void kiocb_batch_init(struct kiocb_batch *batch, long total)
-{
-	INIT_LIST_HEAD(&batch->head);
-	batch->count = total;
-}
-
-static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	struct kiocb *req, *n;
-
-	if (list_empty(&batch->head))
-		return;
-
-	spin_lock_irq(&ctx->ctx_lock);
-	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-		list_del(&req->ki_batch);
-		kmem_cache_free(kiocb_cachep, req);
-		atomic_dec(&ctx->reqs_active);
-	}
-	spin_unlock_irq(&ctx->ctx_lock);
-}
-
-/*
- * Allocate a batch of kiocbs.  This avoids taking and dropping the
- * context lock a lot during setup.
- */
-static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
-{
-	unsigned short allocated, to_alloc;
-	long avail;
-	struct kiocb *req, *n;
-
-	to_alloc = min(batch->count, KIOCB_BATCH_SIZE);
-	for (allocated = 0; allocated < to_alloc; allocated++) {
-		req = __aio_get_req(ctx);
-		if (!req)
-			/* allocation failed, go with what we've got */
-			break;
-		list_add(&req->ki_batch, &batch->head);
-	}
-
-	if (allocated == 0)
-		goto out;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	avail = ctx->ring_info.nr - atomic_read(&ctx->reqs_active) - 1;
-	BUG_ON(avail < 0);
-	if (avail < allocated) {
-		/* Trim back the number of requests. */
-		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
-			list_del(&req->ki_batch);
-			kmem_cache_free(kiocb_cachep, req);
-			if (--allocated <= avail)
-				break;
-		}
-	}
-
-	batch->count -= allocated;
-	atomic_add(allocated, &ctx->reqs_active);
-
-	spin_unlock_irq(&ctx->ctx_lock);
-
-out:
-	return allocated;
-}
-
-static inline struct kiocb *aio_get_req(struct kioctx *ctx,
-					struct kiocb_batch *batch)
-{
-	struct kiocb *req;
-
-	if (list_empty(&batch->head))
-		if (kiocb_batch_refill(ctx, batch) == 0)
-			return NULL;
-	req = list_first_entry(&batch->head, struct kiocb, ki_batch);
-	list_del(&req->ki_batch);
-	return req;
+out_put:
+	atomic_dec(&ctx->reqs_active);
+	return NULL;
 }
 
 static void kiocb_free(struct kiocb *req)
@@ -1192,8 +1111,7 @@ static ssize_t aio_setup_iocb(struct kio
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, struct kiocb_batch *batch,
-			 bool compat)
+			 struct iocb *iocb, bool compat)
 {
 	struct kiocb *req;
 	ssize_t ret;
@@ -1214,7 +1132,7 @@ static int io_submit_one(struct kioctx *
 		return -EINVAL;
 	}
 
-	req = aio_get_req(ctx, batch);  /* returns with 2 references to req */
+	req = aio_get_req(ctx);  /* returns with 2 references to req */
 	if (unlikely(!req))
 		return -EAGAIN;
 
@@ -1286,7 +1204,6 @@ long do_io_submit(aio_context_t ctx_id,
 	long ret = 0;
 	int i = 0;
 	struct blk_plug plug;
-	struct kiocb_batch batch;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1303,8 +1220,6 @@ long do_io_submit(aio_context_t ctx_id,
 		return -EINVAL;
 	}
 
-	kiocb_batch_init(&batch, nr);
-
 	blk_start_plug(&plug);
 
 	/*
@@ -1325,13 +1240,12 @@ long do_io_submit(aio_context_t ctx_id,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, &batch, compat);
+		ret = io_submit_one(ctx, user_iocb, &tmp, compat);
 		if (ret)
 			break;
 	}
 	blk_finish_plug(&plug);
 
-	kiocb_batch_free(ctx, &batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
diff -puN include/linux/aio.h~aio-kill-batch-allocation include/linux/aio.h
--- a/include/linux/aio.h~aio-kill-batch-allocation
+++ a/include/linux/aio.h
@@ -85,7 +85,6 @@ struct kiocb {
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-	struct list_head	ki_batch;	/* batch allocation */
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
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

