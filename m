From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch removed from -mm tree
Date: Thu, 14 Feb 2013 15:06:57 -0800
Message-ID: <20130214230659.9550E5A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40384 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNXHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 18:07:06 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so300194vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 15:07:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcrl@kvack.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been removed from the -mm tree.  Its filename was
     aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: fix kioctx not being freed after cancellation at exit time

The recent changes overhauling fs/aio.c introduced a bug that results in
the kioctx not being freed when outstanding kiocbs are cancelled at
exit_aio() time.  Specifically, a kiocb that is cancelled has its
completion events discarded by batch_complete_aio(), which then fails to
wake up the process stuck in free_ioctx().  Fix this by adding a wake_up()
in batch_complete_aio() and modifying the wait_event() condition in
free_ioctx() appropriately.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -335,7 +335,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) != ctx->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
@@ -755,6 +757,7 @@ void batch_complete_aio(struct batch_com
 			 * with free_ioctx()
 			 */
 			atomic_inc(&req->ki_ctx->reqs_available);
+			wake_up(&req->ki_ctx->wait);
 			aio_put_req(req);
 			continue;
 		}
_

Patches currently in -mm which might be from bcrl@kvack.org are

linux-next.patch
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
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-correct-calculation-of-available-events.patch
aio-only-suppress-events-from-cancelled-kiocbs-if-free_ioctx-is-in-progress.patch

