From: akpm@linux-foundation.org
Subject: + block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Thu, 24 Jan 2013 14:41:49 -0800
Message-ID: <20130124224149.9BAE35A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62863 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3AXWlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 17:41:52 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so961099vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 14:41:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, Valdis.Kletnieks@vt.edu


The patch titled
     Subject: aio: Fix a null pointer deref in batch_complete_aio
has been added to the -mm tree.  Its filename is
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch

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
@@ -669,6 +669,9 @@ static inline void kioctx_ring_unlock(st
 {
 	struct aio_ring *ring;
 
+	if (!ctx)
+		return;
+
 	smp_wmb();
 	/* make event visible before updating tail */
 
@@ -746,8 +749,7 @@ void batch_complete_aio(struct batch_com
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

