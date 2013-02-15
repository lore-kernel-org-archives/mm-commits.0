From: akpm@linux-foundation.org
Subject: + aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch added to -mm tree
Date: Fri, 15 Feb 2013 14:38:37 -0800
Message-ID: <20130215223838.67C5831C4D5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61262 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3BOWik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 17:38:40 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so401612vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 14:38:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bcrl@kvack.org, jwboyer@redhat.com, koverstreet@google.com, zab@redhat.com


The patch titled
     Subject: aio: v3: fix kioctx not being freed after cancellation at exit time
has been added to the -mm tree.  Its filename is
     aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

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
Subject: aio: v3: fix kioctx not being freed after cancellation at exit time

v3 corrects a typo in v2 of this patch.  The wrong version of the patch was
copied over and misspelled ctx in the first hunk.  A known good tree with
this patch is at git://git.kvack.org/~bcrl/linux-next-20130213.git-v3 .

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/aio.c~aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time fs/aio.c
--- a/fs/aio.c~aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time
+++ a/fs/aio.c
@@ -337,7 +337,7 @@ static void free_ioctx(struct kioctx *ct
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait,
 			   (head != ctx->shadow_tail) ||
-			   (atomic_read(&ctx->reqs_available) >= ctr->nr));
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
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
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

