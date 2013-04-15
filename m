From: akpm@linux-foundation.org
Subject: + generic-dynamic-per-cpu-refcounting-fix.patch added to -mm tree
Date: Mon, 15 Apr 2013 15:15:20 -0700
Message-ID: <20130415221520.670B85A4213@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:60674 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3DOWPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 18:15:21 -0400
Received: by mail-vb0-f73.google.com with SMTP id q12so518414vbe.2
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 15:15:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, tytso@mit.edu


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-fix
has been added to the -mm tree.  Its filename is
     generic-dynamic-per-cpu-refcounting-fix.patch

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
Subject: generic-dynamic-per-cpu-refcounting-fix

I suppose a comment indicating that it is intentionally overflowing is
probably merited.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-fix lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-fix
+++ a/lib/percpu-refcount.c
@@ -124,6 +124,13 @@ void __percpu_ref_get(struct percpu_ref
 		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
 					&ref->count);
 
+		/*
+		 * The high bits of the counter count the number of gets() that
+		 * have occured; we check for overflow to call
+		 * percpu_ref_alloc() every (1 << (64 - PCPU_COUNT_BITS))
+		 * iterations.
+		 */
+
 		if (!(v >> PCPU_COUNT_BITS) &&
 		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
 			percpu_ref_alloc(ref, pcpu_count);
_

Patches currently in -mm which might be from koverstreet@google.com are

linux-next.patch
mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
generic-dynamic-per-cpu-refcounting-fix.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

