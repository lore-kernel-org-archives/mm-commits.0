From: akpm@linux-foundation.org
Subject: + aio-fix-aio_read_events_ring-types.patch added to -mm tree
Date: Mon, 07 Jan 2013 17:01:02 -0800
Message-ID: <20130108010102.EF402200B2E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:34962 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3AHBBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 20:01:05 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so1276655wey.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 17:01:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com


The patch titled
     Subject: aio: fix aio_read_events_ring() types
has been added to the -mm tree.  Its filename is
     aio-fix-aio_read_events_ring-types.patch

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
Subject: aio: fix aio_read_events_ring() types

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN fs/aio.c~aio-fix-aio_read_events_ring-types fs/aio.c
--- a/fs/aio.c~aio-fix-aio_read_events_ring-types
+++ a/fs/aio.c
@@ -838,12 +838,13 @@ EXPORT_SYMBOL(aio_complete_batch);
  *	Pull an event off of the ioctx's event ring.  Returns the number of
  *	events fetched
  */
-static int aio_read_events_ring(struct kioctx *ctx,
-				struct io_event __user *event, long nr)
+static long aio_read_events_ring(struct kioctx *ctx,
+				 struct io_event __user *event, long nr)
 {
 	struct aio_ring *ring;
 	unsigned head, pos;
-	int ret = 0, copy_ret;
+	long ret = 0;
+	int copy_ret;
 
 	if (!mutex_trylock(&ctx->ring_lock)) {
 		__set_current_state(TASK_RUNNING);
@@ -862,23 +863,24 @@ static int aio_read_events_ring(struct k
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		long avail = (head < ctx->shadow_tail
+			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
 		if (head == ctx->shadow_tail)
 			break;
 
-		i = min_t(int, i, nr - ret);
-		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
-			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+		avail = min(avail, nr - ret);
+		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
+			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
 		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
-		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * avail);
 		kunmap(page);
 
 		if (unlikely(copy_ret)) {
@@ -886,8 +888,8 @@ static int aio_read_events_ring(struct k
 			goto out;
 		}
 
-		ret += i;
-		head += i;
+		ret += avail;
+		head += avail;
 		head %= ctx->nr;
 	}
 
@@ -896,7 +898,7 @@ static int aio_read_events_ring(struct k
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, ctx->shadow_tail);
+	pr_debug("%li  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
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

