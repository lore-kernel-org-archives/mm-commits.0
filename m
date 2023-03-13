Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AB9C6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjCMSvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCMSvI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D70B86DE2
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29BAB811E1
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C87C433D2;
        Mon, 13 Mar 2023 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678733433;
        bh=tpMF+bP/nlwPGjVu6DqfZ7x2bTNEY7fFSICmJgFEnmU=;
        h=Date:To:From:Subject:From;
        b=ppOfMOBKkp2klPK+ItDCB74aiwIV+xypwtg2wK2ClmYYrJsI6LlbZ5cOh1xURUET8
         k0U5QmuFjFKguyAiTi0Z83EEBj2HRdKxS8X0F03bEv8GALhGsu2hWrag+qGrpL7ma5
         clfM9tLpN0oQRPyZCf9tRfVVihPWM7LQMl5n33Ro=
Date:   Mon, 13 Mar 2023 11:50:32 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        peterz@infradead.org, npiggin@gmail.com,
        mgorman@techsingularity.net, hch@infradead.org, david@redhat.com,
        arnd@arndb.de, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch added to mm-unstable branch
Message-Id: <20230313185033.A9C87C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prefer xxx_page() alloc/free functions for order-0 pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: prefer xxx_page() alloc/free functions for order-0 pages
Date: Mon, 13 Mar 2023 12:27:14 +0000

Update instances of alloc_pages(..., 0), __get_free_pages(..., 0) and
__free_pages(..., 0) to use alloc_page(), __get_free_page() and
__free_page() respectively in core code.

Link: https://lkml.kernel.org/r/50c48ca4789f1da2a65795f2346f5ae3eff7d665.1678710232.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch

