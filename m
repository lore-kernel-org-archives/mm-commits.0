From: akpm@linux-foundation.org
Subject: + aio-correct-calculation-of-available-events.patch added to -mm tree
Date: Wed, 13 Feb 2013 13:28:02 -0800
Message-ID: <20130213212802.B38635A4272@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:47093 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3BMV2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 16:28:04 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so170678vea.0
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 13:28:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bcrl@kvack.org, koverstreet@google.com


The patch titled
     Subject: aio: correct calculation of available events
has been added to the -mm tree.  Its filename is
     aio-correct-calculation-of-available-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Benjamin LaHaise <bcrl@kvack.org>
Subject: aio: correct calculation of available events

When the number of available events in the ring buffer is calculated, the
avail calculation is incorrect when head == tail.  This is harmless in
aio_read_events_ring(), but in free_ioctx() leads to the subsequent
WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr).  Correct this.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-correct-calculation-of-available-events fs/aio.c
--- a/fs/aio.c~aio-correct-calculation-of-available-events
+++ a/fs/aio.c
@@ -337,7 +337,8 @@ static void free_ioctx(struct kioctx *ct
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		avail = (head <= ctx->shadow_tail ?
+			 ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -885,7 +886,7 @@ static long aio_read_events_ring(struct 
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head < ctx->shadow_tail
+		long avail = (head <= ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
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
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

