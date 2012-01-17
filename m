From: akpm@linux-foundation.org
Subject: [merged] unused-iocbs-in-a-batch-should-not-be-accounted-as-active.patch removed from -mm tree
Date: Tue, 17 Jan 2012 13:00:47 -0800
Message-ID: <20120117210049.78D865C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63151 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2AQVAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 16:00:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gleb@redhat.com, jmoyer@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: unused iocbs in a batch should not be accounted as active
has been removed from the -mm tree.  Its filename was
     unused-iocbs-in-a-batch-should-not-be-accounted-as-active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gleb Natapov <gleb@redhat.com>
Subject: aio: unused iocbs in a batch should not be accounted as active

Since commit 080d676de095 ("aio: allocate kiocbs in batches") iocbs are
allocated in a batch during processing of first iocbs.  All iocbs in a
batch are automatically added to ctx->active_reqs list and accounted in
ctx->reqs_active.  If one (not the last one) of iocbs submitted by an user
fails, further iocbs are not processed, but they are still present in
ctx->active_reqs and accounted in ctx->reqs_active.  This causes process
to stuck in a D state in wait_for_all_aios() on exit since
ctx->reqs_active will never go down to zero.  Furthermore since
kiocb_batch_free() frees iocb without removing it from active_reqs list
the list become corrupted which may cause oops.

Fix this by removing iocb from ctx->active_reqs and updating
ctx->reqs_active in kiocb_batch_free().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>		[3.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~unused-iocbs-in-a-batch-should-not-be-accounted-as-active fs/aio.c
--- a/fs/aio.c~unused-iocbs-in-a-batch-should-not-be-accounted-as-active
+++ a/fs/aio.c
@@ -476,14 +476,21 @@ static void kiocb_batch_init(struct kioc
 	batch->count = total;
 }
 
-static void kiocb_batch_free(struct kiocb_batch *batch)
+static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 {
 	struct kiocb *req, *n;
 
+	if (list_empty(&batch->head))
+		return;
+
+	spin_lock_irq(&ctx->ctx_lock);
 	list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
 		list_del(&req->ki_batch);
+		list_del(&req->ki_list);
 		kmem_cache_free(kiocb_cachep, req);
+		ctx->reqs_active--;
 	}
+	spin_unlock_irq(&ctx->ctx_lock);
 }
 
 /*
@@ -1742,7 +1749,7 @@ long do_io_submit(aio_context_t ctx_id, 
 	}
 	blk_finish_plug(&plug);
 
-	kiocb_batch_free(&batch);
+	kiocb_batch_free(ctx, &batch);
 	put_ioctx(ctx);
 	return i ? i : ret;
 }
_

Patches currently in -mm which might be from gleb@redhat.com are

origin.patch

