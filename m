From: akpm@linux-foundation.org
Subject: [folded-merged] aio-kill-ki_retry-fix-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:35:43 -0700
Message-ID: <20130318203543.9C27D5A4638@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60387 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3CRUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:35:44 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so618989qcr.0
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:35:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio-kill-ki_retry-fix-fix
has been removed from the -mm tree.  Its filename was
     aio-kill-ki_retry-fix-fix.patch

This patch was dropped because it was folded into aio-kill-ki_retry.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio-kill-ki_retry-fix-fix

The "aio: kill ki-retry" patch was assuming that we didn't touch struct
kiocb after passing it off to something that would call aio_complete() -
which was wrong.  So, revert the refcounting changes.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-kill-ki_retry-fix-fix fs/aio.c
--- a/fs/aio.c~aio-kill-ki_retry-fix-fix
+++ a/fs/aio.c
@@ -587,7 +587,7 @@ static inline struct kiocb *aio_get_req(
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 1);
+	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
 	return req;
 out_put:
@@ -1183,10 +1183,12 @@ static int io_submit_one(struct kioctx *
 	if (ret)
 		goto out_put_req;
 
+	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
 out_put_req:
 	put_reqs_available(ctx, 1);
-	aio_put_req(req);
+	aio_put_req(req);	/* drop extra ref to req */
+	aio_put_req(req);	/* drop i/o ref to req */
 	return ret;
 }
 
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

