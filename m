From: akpm@linux-foundation.org
Subject: [folded-merged] aio-use-cancellation-list-lazily-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:32:14 -0700
Message-ID: <20130318203214.67BC331C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55191 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3CRUcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:32:15 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so614407ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:32:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio-use-cancellation-list-lazily-fix
has been removed from the -mm tree.  Its filename was
     aio-use-cancellation-list-lazily-fix.patch

This patch was dropped because it was folded into aio-use-cancellation-list-lazily.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio-use-cancellation-list-lazily-fix

The cancellation changes were fubar - we can't cancel a kiocb if it
doesn't actually have a cancellation callback.

The use of xchg() in aio_complete() was right - there we're marking the
kiocb as completed - but we need to use cmpxchg() in kiocb_cancel() - a
lock isn't sufficient since we're synchronizing with aio_complete() which
isn't taking any locks.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   32 ++++++++++++++++++++++----------
 include/linux/aio.h |   11 +++++++++++
 2 files changed, 33 insertions(+), 10 deletions(-)

diff -puN fs/aio.c~aio-use-cancellation-list-lazily-fix fs/aio.c
--- a/fs/aio.c~aio-use-cancellation-list-lazily-fix
+++ a/fs/aio.c
@@ -224,28 +224,40 @@ static int aio_setup_ring(struct kioctx
 
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 {
-	if (!req->ki_list.next) {
-		struct kioctx *ctx = req->ki_ctx;
-		unsigned long flags;
+	struct kioctx *ctx = req->ki_ctx;
+	unsigned long flags;
 
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
+	spin_lock_irqsave(&ctx->ctx_lock, flags);
+
+	if (!req->ki_list.next)
 		list_add(&req->ki_list, &ctx->active_reqs);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	}
 
 	req->ki_cancel = cancel;
+
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
-	kiocb_cancel_fn *cancel;
+	kiocb_cancel_fn *old, *cancel;
 	int ret = -EINVAL;
 
-	cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
-	if (!cancel || cancel == KIOCB_CANCELLED)
-		return ret;
+	/*
+	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
+	 * actually has a cancel function, hence the cmpxchg()
+	 */
+
+	cancel = ACCESS_ONCE(kiocb->ki_cancel);
+	do {
+		if (!cancel || cancel == KIOCB_CANCELLED)
+			return ret;
+
+		BUG();
+		old = cancel;
+		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
+	} while (cancel != old);
 
 	atomic_inc(&kiocb->ki_users);
 	spin_unlock_irq(&ctx->ctx_lock);
diff -puN include/linux/aio.h~aio-use-cancellation-list-lazily-fix include/linux/aio.h
--- a/include/linux/aio.h~aio-use-cancellation-list-lazily-fix
+++ a/include/linux/aio.h
@@ -14,6 +14,17 @@ struct kiocb;
 
 #define KIOCB_SYNC_KEY		(~0U)
 
+/*
+ * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
+ * cancelled or completed (this makes a certain amount of sense because
+ * successful cancellation - io_cancel() - does deliver the completion to
+ * userspace).
+ *
+ * And since most things don't implement kiocb cancellation and we'd really like
+ * kiocb completion to be lockless when possible, we use ki_cancel to
+ * synchronize cancellation and completion - we only set it to KIOCB_CANCELLED
+ * with xchg() or cmpxchg(), see batch_complete_aio() and kiocb_cancel().
+ */
 #define KIOCB_CANCELLED		((void *) (~0ULL))
 
 typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
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
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion-fix.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

