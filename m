Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583D9C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380538AbiD2UNr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380543AbiD2UNn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C5DFCE
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2861860C8F
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C94C385A7;
        Fri, 29 Apr 2022 20:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263022;
        bh=tUpOPbtmui3MaWgTamDpVlCNH2ED9s8iq0zgpMZ8Gx8=;
        h=Date:To:From:Subject:From;
        b=yYFGvr/r1jBJ7FKxq5mLkh38PPDhEwfIcx2dByuhTbKfHWduGt9unOqkMrDcirW/G
         2OKJDy0broA3Y2wGmz1Jmm9OsZZzqu9icENoS+5YtRzmKZ78JMV+8rPACcTJsvPGSS
         1LzcyhxrzaI4fXzp0gvMvOlXPdFrs/uedvGQJDqo=
Date:   Fri, 29 Apr 2022 13:10:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-convert-add_to_swap-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20220429201022.82C94C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: convert add_to_swap() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     swap-convert-add_to_swap-to-take-a-folio.patch

This patch should soon appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: convert add_to_swap() to take a folio

The only caller already has a folio available, so this saves a conversion.
Also convert the return type to boolean.

Link: https://lkml.kernel.org/r/20220429192329.3034378-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

