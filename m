From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
 added to -mm tree
Date: Tue, 19 May 2020 18:41:32 -0700
Message-ID: <20200520014132.IwdmI5D_y%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgETBld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 May 2020 21:41:33 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, charante@codeaurora.org, mm-commits@vger.kernel.org, vinmenon@codeaurora.org


The patch titled
     Subject: mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix

fix comment grammer, reflow comment

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix
+++ a/mm/page_alloc.c
@@ -3711,11 +3711,11 @@ retry:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		/*
 		 * Allow GFP_ATOMIC order-0 allocations to exclude the
-		 * zone->watermark_boost in its watermark calculations.
-		 * We rely on the ALLOC_ flags set for GFP_ATOMIC
-		 * requests in gfp_to_alloc_flags() for this. Reason not to
-		 * use the GFP_ATOMIC directly is that we want to fall back
-		 * to slow path thus wake up kswapd.
+		 * zone->watermark_boost in their watermark calculations.
+		 * We rely on the ALLOC_ flags set for GFP_ATOMIC requests in
+		 * gfp_to_alloc_flags() for this.  Reason not to use the
+		 * GFP_ATOMIC directly is that we want to fall back to slow path
+		 * thus wake up kswapd.
 		 */
 		if (unlikely(!order && !(alloc_flags & ALLOC_WMARK_MASK) &&
 		     (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH)))) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-rejects.patch
kernel-add-panic_on_taint-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
