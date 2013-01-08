From: akpm@linux-foundation.org
Subject: + aio-document-clarify-aio_read_events-and-shadow_tail.patch added to -mm tree
Date: Tue, 08 Jan 2013 12:20:29 -0800
Message-ID: <20130108202031.59F2582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:33512 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3AHUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:20:32 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so123307yen.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:20:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com


The patch titled
     Subject: aio: document, clarify aio_read_events() and shadow_tail
has been added to the -mm tree.  Its filename is
     aio-document-clarify-aio_read_events-and-shadow_tail.patch

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
Subject: aio: document, clarify aio_read_events() and shadow_tail

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff -puN fs/aio.c~aio-document-clarify-aio_read_events-and-shadow_tail fs/aio.c
--- a/fs/aio.c~aio-document-clarify-aio_read_events-and-shadow_tail
+++ a/fs/aio.c
@@ -103,6 +103,19 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+
+		/*
+		 * Copy of the real tail, that aio_complete uses - to reduce
+		 * cacheline bouncing. The real tail will tend to be much more
+		 * contended - since typically events are delivered one at a
+		 * time, and then aio_read_events() slurps them up a bunch at a
+		 * time - so it's helpful if aio_read_events() isn't also
+		 * contending for the tail. So, aio_complete() updates
+		 * shadow_tail whenever it updates tail.
+		 *
+		 * Also needed because tail is used as a hacky lock and isn't
+		 * always the real tail.
+		 */
 		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
@@ -846,10 +859,7 @@ static long aio_read_events_ring(struct 
 	long ret = 0;
 	int copy_ret;
 
-	if (!mutex_trylock(&ctx->ring_lock)) {
-		__set_current_state(TASK_RUNNING);
-		mutex_lock(&ctx->ring_lock);
-	}
+	mutex_lock(&ctx->ring_lock);
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
@@ -860,8 +870,6 @@ static long aio_read_events_ring(struct 
 	if (head == ctx->shadow_tail)
 		goto out;
 
-	__set_current_state(TASK_RUNNING);
-
 	while (ret < nr) {
 		long avail = (head < ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
@@ -940,6 +948,20 @@ static long read_events(struct kioctx *c
 		until = timespec_to_ktime(ts);
 	}
 
+	/*
+	 * Note that aio_read_events() is being called as the conditional - i.e.
+	 * we're calling it after prepare_to_wait() has set task state to
+	 * TASK_INTERRUPTIBLE.
+	 *
+	 * But aio_read_events() can block, and if it blocks it's going to flip
+	 * the task state back to TASK_RUNNING.
+	 *
+	 * This should be ok, provided it doesn't flip the state back to
+	 * TASK_RUNNING and return 0 too much - that causes us to spin. That
+	 * will only happen if the mutex_lock() call blocks, and we then find
+	 * the ringbuffer empty. So in practice we should be ok, but it's
+	 * something to be aware of when touching this code.
+	 */
 	wait_event_interruptible_hrtimeout(ctx->wait,
 			aio_read_events(ctx, min_nr, nr, event, &ret), until);
 
_

Patches currently in -mm which might be from koverstreet@google.com are

jiffies-conversions-use-compile-time-constants-when-possible.patch
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
generic-dynamic-per-cpu-refcounting-fix-fix.patch
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
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch
aio-smoosh-struct-kiocb-fix.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch

