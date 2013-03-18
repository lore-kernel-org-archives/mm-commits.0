From: akpm@linux-foundation.org
Subject: [folded-merged] block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:36:46 -0700
Message-ID: <20130318203647.4F2AA31C25D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52045 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3CRUgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:36:48 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so614938ggi.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:36:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: Fix a null pointer deref in batch_complete_aio
has been removed from the -mm tree.  Its filename was
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into block-aio-batch-completion-for-bios-kiocbs.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: Fix a null pointer deref in batch_complete_aio

The batch completion code was trying to be a bit too clever, and skip
checking ctx where it couldn't be NULL - but that broke if a kiocb had
been cancelled. Move the check to kioctx_ring_unlock().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix fs/aio.c
--- a/fs/aio.c~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix
+++ a/fs/aio.c
@@ -680,6 +680,9 @@ static inline void kioctx_ring_unlock(st
 {
 	struct aio_ring *ring;
 
+	if (!ctx)
+		return;
+
 	smp_wmb();
 	/* make event visible before updating tail */
 
@@ -757,8 +760,7 @@ void batch_complete_aio(struct batch_com
 		}
 
 		if (unlikely(req->ki_ctx != ctx)) {
-			if (ctx)
-				kioctx_ring_unlock(ctx, tail);
+			kioctx_ring_unlock(ctx, tail);
 
 			ctx = req->ki_ctx;
 			tail = kioctx_ring_lock(ctx);
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
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion-fix.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

