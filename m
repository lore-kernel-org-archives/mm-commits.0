From: akpm@linux-foundation.org
Subject: + aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:39:03 -0700
Message-ID: <20130321223903.DDE2631C158@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59160 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3CUWjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:39:05 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so310850vea.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:39:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, bcrl@kvack.org, jwboyer@redhat.com, zab@redhat.com


The patch titled
     Subject: aio: fix kioctx not being freed after cancellation at exit time
has been added to the -mm tree.  Its filename is
     aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

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
Subject: aio: fix kioctx not being freed after cancellation at exit time


The recent changes overhauling fs/aio.c introduced a bug that results in the
kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
time.  Specifically, a kiocb that is cancelled has its completion events
discarded by batch_complete_aio(), which then fails to wake up the process
stuck in free_ioctx().  Fix this by removing the event suppression in
batch_complete_aio() and modify the wait_event() condition in free_ioctx()
appropriately.

This patch was tested with the cancel operation in the thread based code
posted yesterday.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -349,7 +349,9 @@ static void free_ioctx(struct kioctx *ct
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1));
 
 		avail = (head <= ctx->shadow_tail
 			 ? ctx->shadow_tail : ctx->nr_events) - head;
@@ -774,17 +776,6 @@ void batch_complete_aio(struct batch_com
 			n = rb_parent(n);
 		}
 
-		if (unlikely(xchg(&req->ki_cancel,
-				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-			/*
-			 * Can't use the percpu reqs_available here - could race
-			 * with free_ioctx()
-			 */
-			atomic_inc(&req->ki_ctx->reqs_available);
-			aio_put_req(req);
-			continue;
-		}
-
 		if (unlikely(req->ki_eventfd != eventfd)) {
 			if (eventfd) {
 				/* Make event visible */
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

