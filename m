Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C250EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383817AbiEMTW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383741AbiEMTWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36E31224
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBB686225D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503D9C34117;
        Fri, 13 May 2022 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469708;
        bh=LRyC/roBbfgkexvJQy4hLbDhuBv1hkKy+7WO0LEGWys=;
        h=Date:To:From:Subject:From;
        b=uEjQ+tjixkGtRb+/tWXj6glw0aizRd8yEHb8vYVRBjQoAMWedTG60B3XFCAg7QOMi
         GKm0PeY4rcIpQzL+37NiovRcx090JJGTrKj+X0XTKRPgAs9KtRP/8G0547e5WnJhkJ
         wsvuvJ3l6U63tbhAax6COUudFMhhE5rZ6F15OmU4=
Date:   Fri, 13 May 2022 12:21:47 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-convert-add_to_swap-to-take-a-folio.patch removed from -mm tree
Message-Id: <20220513192148.503D9C34117@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: convert add_to_swap() to take a folio
has been removed from the -mm tree.  Its filename was
     swap-convert-add_to_swap-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: convert add_to_swap() to take a folio

The only caller already has a folio available, so this saves a conversion.
Also convert the return type to boolean.

Link: https://lkml.kernel.org/r/20220504182857.4013401-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    6 ++---
 mm/swap_state.c |   47 ++++++++++++++++++++++++----------------------
 mm/vmscan.c     |    6 ++---
 3 files changed, 31 insertions(+), 28 deletions(-)

--- a/mm/swap.h~swap-convert-add_to_swap-to-take-a-folio
+++ a/mm/swap.h
@@ -32,7 +32,7 @@ extern struct address_space *swapper_spa
 		>> SWAP_ADDRESS_SPACE_SHIFT])
 
 void show_swap_cache_info(void);
-int add_to_swap(struct page *page);
+bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
 int add_to_swap_cache(struct page *page, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
@@ -119,9 +119,9 @@ struct page *find_get_incore_page(struct
 	return find_get_page(mapping, index);
 }
 
-static inline int add_to_swap(struct page *page)
+static inline bool add_to_swap(struct folio *folio)
 {
-	return 0;
+	return false;
 }
 
 static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
--- a/mm/swap_state.c~swap-convert-add_to_swap-to-take-a-folio
+++ a/mm/swap_state.c
@@ -176,24 +176,26 @@ void __delete_from_swap_cache(struct pag
 }
 
 /**
- * add_to_swap - allocate swap space for a page
- * @page: page we want to move to swap
+ * add_to_swap - allocate swap space for a folio
+ * @folio: folio we want to move to swap
  *
- * Allocate swap space for the page and add the page to the
- * swap cache.  Caller needs to hold the page lock. 
+ * Allocate swap space for the folio and add the folio to the
+ * swap cache.
+ *
+ * Context: Caller needs to hold the folio lock.
+ * Return: Whether the folio was added to the swap cache.
  */
-int add_to_swap(struct page *page)
+bool add_to_swap(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	swp_entry_t entry;
 	int err;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageUptodate(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
 	entry = folio_alloc_swap(folio);
 	if (!entry.val)
-		return 0;
+		return false;
 
 	/*
 	 * XArray node allocations from PF_MEMALLOC contexts could
@@ -206,7 +208,7 @@ int add_to_swap(struct page *page)
 	/*
 	 * Add it to the swap cache.
 	 */
-	err = add_to_swap_cache(page, entry,
+	err = add_to_swap_cache(&folio->page, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
 		/*
@@ -215,22 +217,23 @@ int add_to_swap(struct page *page)
 		 */
 		goto fail;
 	/*
-	 * Normally the page will be dirtied in unmap because its pte should be
-	 * dirty. A special case is MADV_FREE page. The page's pte could have
-	 * dirty bit cleared but the page's SwapBacked bit is still set because
-	 * clearing the dirty bit and SwapBacked bit has no lock protected. For
-	 * such page, unmap will not set dirty bit for it, so page reclaim will
-	 * not write the page out. This can cause data corruption when the page
-	 * is swap in later. Always setting the dirty bit for the page solves
-	 * the problem.
+	 * Normally the folio will be dirtied in unmap because its
+	 * pte should be dirty. A special case is MADV_FREE page. The
+	 * page's pte could have dirty bit cleared but the folio's
+	 * SwapBacked flag is still set because clearing the dirty bit
+	 * and SwapBacked flag has no lock protected. For such folio,
+	 * unmap will not set dirty bit for it, so folio reclaim will
+	 * not write the folio out. This can cause data corruption when
+	 * the folio is swapped in later. Always setting the dirty flag
+	 * for the folio solves the problem.
 	 */
-	set_page_dirty(page);
+	folio_mark_dirty(folio);
 
-	return 1;
+	return true;
 
 fail:
-	put_swap_page(page, entry);
-	return 0;
+	put_swap_page(&folio->page, entry);
+	return false;
 }
 
 /*
--- a/mm/vmscan.c~swap-convert-add_to_swap-to-take-a-folio
+++ a/mm/vmscan.c
@@ -1731,8 +1731,8 @@ retry:
 								page_list))
 						goto activate_locked;
 				}
-				if (!add_to_swap(page)) {
-					if (!PageTransHuge(page))
+				if (!add_to_swap(folio)) {
+					if (!folio_test_large(folio))
 						goto activate_locked_split;
 					/* Fallback to swap normal pages */
 					if (split_folio_to_list(folio,
@@ -1741,7 +1741,7 @@ retry:
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
-					if (!add_to_swap(page))
+					if (!add_to_swap(folio))
 						goto activate_locked_split;
 				}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

