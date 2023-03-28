Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C92C77B6E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjC1XXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjC1XWN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E1930F5
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9F4619FA
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF401C433EF;
        Tue, 28 Mar 2023 23:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045730;
        bh=1200r62JntBKB0tqnnxtcytIqVmWZL4HchXAv3C9Jjc=;
        h=Date:To:From:Subject:From;
        b=2PfbHh/mYtP48kscljS25X3b4+fGZAVgzRxk0qXO4fsDpEjYt+sRYWEXWLENI5D55
         VkBNPvROp7v0GQGA+vdIXciSHfR1+TzkXWO2Y9BA00jMvjRuiIuDu4Bd12w5sFB5W8
         WM182zv9U8qR9HbnSHxUz7tG0SbClUFnJtYvpwI4=
Date:   Tue, 28 Mar 2023 16:22:10 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        rppt@kernel.org, peterz@infradead.org, npiggin@gmail.com,
        mgorman@techsingularity.net, hch@infradead.org, david@redhat.com,
        arnd@arndb.de, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch removed from -mm tree
Message-Id: <20230328232210.BF401C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: prefer xxx_page() alloc/free functions for order-0 pages
has been removed from the -mm tree.  Its filename was
     mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: prefer xxx_page() alloc/free functions for order-0 pages
Date: Mon, 13 Mar 2023 12:27:14 +0000

Update instances of alloc_pages(..., 0), __get_free_pages(..., 0) and
__free_pages(..., 0) to use alloc_page(), __get_free_page() and
__free_page() respectively in core code.

Link: https://lkml.kernel.org/r/50c48ca4789f1da2a65795f2346f5ae3eff7d665.1678710232.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    4 ++--
 mm/debug_vm_pgtable.c         |    4 ++--
 mm/hugetlb_vmemmap.c          |    2 +-
 mm/mmu_gather.c               |    2 +-
 mm/page_alloc.c               |    2 +-
 mm/vmalloc.c                  |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/asm-generic/pgalloc.h~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/include/asm-generic/pgalloc.h
@@ -123,11 +123,11 @@ static inline pmd_t *pmd_alloc_one(struc
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
-	page = alloc_pages(gfp, 0);
+	page = alloc_page(gfp);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
-		__free_pages(page, 0);
+		__free_page(page);
 		return NULL;
 	}
 	return (pmd_t *)page_address(page);
--- a/mm/debug_vm_pgtable.c~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/mm/debug_vm_pgtable.c
@@ -1048,7 +1048,7 @@ static void __init destroy_args(struct p
 
 	if (args->pte_pfn != ULONG_MAX) {
 		page = pfn_to_page(args->pte_pfn);
-		__free_pages(page, 0);
+		__free_page(page);
 
 		args->pte_pfn = ULONG_MAX;
 	}
@@ -1290,7 +1290,7 @@ static int __init init_args(struct pgtab
 		}
 	}
 
-	page = alloc_pages(GFP_KERNEL, 0);
+	page = alloc_page(GFP_KERNEL);
 	if (page)
 		args->pte_pfn = page_to_pfn(page);
 
--- a/mm/hugetlb_vmemmap.c~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -400,7 +400,7 @@ static int alloc_vmemmap_page_list(unsig
 	return 0;
 out:
 	list_for_each_entry_safe(page, next, list, lru)
-		__free_pages(page, 0);
+		__free_page(page);
 	return -ENOMEM;
 }
 
--- a/mm/mmu_gather.c~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/mm/mmu_gather.c
@@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_ga
 	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
 		return false;
 
-	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
+	batch = (void *)__get_free_page(GFP_NOWAIT | __GFP_NOWARN);
 	if (!batch)
 		return false;
 
--- a/mm/page_alloc.c~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/mm/page_alloc.c
@@ -5558,7 +5558,7 @@ EXPORT_SYMBOL(__get_free_pages);
 
 unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
-	return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
+	return __get_free_page(gfp_mask | __GFP_ZERO);
 }
 EXPORT_SYMBOL(get_zeroed_page);
 
--- a/mm/vmalloc.c~mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages
+++ a/mm/vmalloc.c
@@ -2739,7 +2739,7 @@ void vfree(const void *addr)
 		 * High-order allocs for huge vmallocs are split, so
 		 * can be freed as an array of order-0 allocations
 		 */
-		__free_pages(page, 0);
+		__free_page(page);
 		cond_resched();
 	}
 	atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
iov_iter-add-copy_page_to_iter_nofault.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
mm-vmalloc-convert-vread-to-vread_iter-v8.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch
mm-mmap-vma_merge-explicitly-assign-res-vma-extend-invariants.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

