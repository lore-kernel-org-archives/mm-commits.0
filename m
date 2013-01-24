From: akpm@linux-foundation.org
Subject: + aio-kill-ki_retry-fix-fix.patch added to -mm tree
Date: Thu, 24 Jan 2013 14:43:09 -0800
Message-ID: <20130124224309.92CE231C1F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41158 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3AXWnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 17:43:10 -0500
Received: by mail-yh0-f74.google.com with SMTP id z12so876646yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 14:43:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com


The patch titled
     Subject: aio-kill-ki_retry-fix-fix
has been added to the -mm tree.  Its filename is
     aio-kill-ki_retry-fix-fix.patch

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
@@ -576,7 +576,7 @@ static inline struct kiocb *aio_get_req(
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 1);
+	atomic_set(&req->ki_users, 2);
 	req->ki_ctx = ctx;
 	return req;
 out_put:
@@ -1172,10 +1172,12 @@ static int io_submit_one(struct kioctx *
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
aio-kiocb_cancel-fix.patch
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
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch

