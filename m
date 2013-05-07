From: akpm@linux-foundation.org
Subject: [folded-merged] generic-dynamic-per-cpu-refcounting-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:42:56 -0700
Message-ID: <20130507194256.9D12D31C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33777 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EGTm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:42:57 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so100148vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:42:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-fix
has been removed from the -mm tree.  Its filename was
     generic-dynamic-per-cpu-refcounting-fix.patch

This patch was dropped because it was folded into generic-dynamic-per-cpu-refcounting.patch

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
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
linux-next.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch

