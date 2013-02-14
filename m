From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-only-suppress-events-from-cancelled-kiocbs-if-free_ioctx-is-in-progress.patch removed from -mm tree
Date: Thu, 14 Feb 2013 15:07:07 -0800
Message-ID: <20130214230707.BD7CF5A42A9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55050 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNXHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 18:07:09 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so300730vch.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 15:07:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcrl@kvack.org, jmoyer@redhat.com, koverstreet@google.com, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: only suppress events from cancelled kiocbs if free_ioctx() is in progress
has been removed from the -mm tree.  Its filename was
     aio-only-suppress-events-from-cancelled-kiocbs-if-free_ioctx-is-in-progress.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: only suppress events from cancelled kiocbs if free_ioctx() is in progress

The io_cancel() syscall allows for cancellation of iocbs in flight to
generate a completion event.  The current behaviour of
batch_complete_aio() is to suppress all completion events.  Some types of
asynchronous operations cannot be cancelled synchronously, and must
generate a completion event at some point after the io_cancel() syscall. 
Instead, only suppress completion events during kioctx teardown by
free_ioctx().

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-only-suppress-events-from-cancelled-kiocbs-if-free_ioctx-is-in-progress fs/aio.c
--- a/fs/aio.c~aio-only-suppress-events-from-cancelled-kiocbs-if-free_ioctx-is-in-progress
+++ a/fs/aio.c
@@ -81,6 +81,7 @@ struct kioctx {
 
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
+	unsigned		dead;
 
 	unsigned long		mmap_base;
 	unsigned long		mmap_size;
@@ -311,6 +312,7 @@ static void free_ioctx(struct kioctx *ct
 	struct kiocb *req;
 	unsigned cpu, head, avail;
 
+	ctx->dead = 1;
 	spin_lock_irq(&ctx->ctx_lock);
 
 	while (!list_empty(&ctx->active_reqs)) {
@@ -750,7 +752,9 @@ void batch_complete_aio(struct batch_com
 			n = rb_parent(n);
 		}
 
-		if (unlikely(xchg(&req->ki_cancel,
+		/* Suppress cancelled events if free_ioctx() is in progress. */
+		if (unlikely(req->ki_ctx->dead &&
+			     xchg(&req->ki_cancel,
 				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
 			/*
 			 * Can't use the percpu reqs_available here - could race
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

