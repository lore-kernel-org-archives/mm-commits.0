From: akpm@linux-foundation.org
Subject: [merged] slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:04:56 -0700
Message-ID: <20120918190457.2E3585C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57839 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2IRTE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:04:59 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so8526eek.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:04:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, chuck.lever@oracle.com, davem@davemloft.net, js1304@gmail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: do ClearSlabPfmemalloc() for all pages of slab
has been removed from the -mm tree.  Its filename was
     slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: slab: do ClearSlabPfmemalloc() for all pages of slab

Right now, we call ClearSlabPfmemalloc() for first page of slab when we
clear SlabPfmemalloc flag.  This is fine for most swap-over-network use
cases as it is expected that order-0 pages are in use.  Unfortunately it
is possible that that __ac_put_obj() checks SlabPfmemalloc on a tail page
and while this is harmless, it is sloppy.  This patch ensures that the
head page is always used.

This problem was originally identified by Joonsoo Kim.

[js1304@gmail.com: Original implementation and problem identification]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-do-clearslabpfmemalloc-for-all-pages-of-slab mm/slab.c
--- a/mm/slab.c~slab-do-clearslabpfmemalloc-for-all-pages-of-slab
+++ a/mm/slab.c
@@ -1000,7 +1000,7 @@ static void *__ac_get_obj(struct kmem_ca
 		l3 = cachep->nodelists[numa_mem_id()];
 		if (!list_empty(&l3->slabs_free) && force_refill) {
 			struct slab *slabp = virt_to_slab(objp);
-			ClearPageSlabPfmemalloc(virt_to_page(slabp->s_mem));
+			ClearPageSlabPfmemalloc(virt_to_head_page(slabp->s_mem));
 			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
@@ -1032,7 +1032,7 @@ static void *__ac_put_obj(struct kmem_ca
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
-		struct page *page = virt_to_page(objp);
+		struct page *page = virt_to_head_page(objp);
 		if (PageSlabPfmemalloc(page))
 			set_obj_pfmemalloc(&objp);
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch

