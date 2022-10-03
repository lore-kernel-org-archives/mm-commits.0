Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CE7C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJCVFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJCVFM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05FA11815
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A86DB8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEF1C433C1;
        Mon,  3 Oct 2022 21:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831092;
        bh=2n7jdKeL7BO8wKa89hXGJW7mgNc5eL22AjxGZIjLT1o=;
        h=Date:To:From:Subject:From;
        b=tw0wi6sG87skwdiCizry6w4SXl85WAOxe7ax8cAx2I75Ncp/SlVVP1hzsmlUhbHpu
         Rh4KQXqbbTEM0QAyk61x4soyp5DAoAYC50bh+nwBmCi4Nzs1+7+dZCKW3a7zH/3scf
         mjK5YPHajFHJ/tBzArCgDaiS+mlfMyhlhEo78pQ4=
Date:   Mon, 03 Oct 2022 14:04:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_swap_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210452.0DEF1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_swap_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_swap_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_swap_page() to use a folio
Date: Fri, 2 Sep 2022 20:46:10 +0100

Removes quite a lot of calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   57 ++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/mm/memory.c~mm-convert-do_swap_page-to-use-a-folio
+++ a/mm/memory.c
@@ -3724,6 +3724,7 @@ static vm_fault_t handle_pte_marker(stru
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	struct page *page = NULL, *swapcache;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
@@ -3768,19 +3769,23 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
+	if (page)
+		folio = page_folio(page);
 
 	if (!page) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
-			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-							vmf->address);
-			if (page) {
-				__SetPageLocked(page);
-				__SetPageSwapBacked(page);
+			folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0,
+						vma, vmf->address, false);
+			page = &folio->page;
+			if (folio) {
+				__folio_set_locked(folio);
+				__folio_set_swapbacked(folio);
 
 				if (mem_cgroup_swapin_charge_page(page,
-					vma->vm_mm, GFP_KERNEL, entry)) {
+							vma->vm_mm, GFP_KERNEL,
+							entry)) {
 					ret = VM_FAULT_OOM;
 					goto out_page;
 				}
@@ -3788,20 +3793,21 @@ vm_fault_t do_swap_page(struct vm_fault
 
 				shadow = get_shadow_from_swap_cache(entry);
 				if (shadow)
-					workingset_refault(page_folio(page),
-								shadow);
+					workingset_refault(folio, shadow);
 
-				lru_cache_add(page);
+				folio_add_lru(folio);
 
 				/* To provide entry to swap_readpage() */
-				set_page_private(page, entry.val);
+				folio_set_swap_entry(folio, entry);
 				swap_readpage(page, true, NULL);
-				set_page_private(page, 0);
+				folio->private = NULL;
 			}
 		} else {
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						vmf);
 			swapcache = page;
+			if (page)
+				folio = page_folio(page);
 		}
 
 		if (!page) {
@@ -3844,7 +3850,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!PageSwapCache(page) ||
+		if (unlikely(!folio_test_swapcache(folio) ||
 			     page_private(page) != entry.val))
 			goto out_page;
 
@@ -3859,6 +3865,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			page = swapcache;
 			goto out_page;
 		}
+		folio = page_folio(page);
 
 		/*
 		 * If we want to map a page that's in the swapcache writable, we
@@ -3867,7 +3874,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * pagevecs if required.
 		 */
 		if ((vmf->flags & FAULT_FLAG_WRITE) && page == swapcache &&
-		    !PageKsm(page) && !PageLRU(page))
+		    !folio_test_ksm(folio) && !folio_test_lru(folio))
 			lru_add_drain();
 	}
 
@@ -3881,7 +3888,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
 		goto out_nomap;
 
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(!folio_test_uptodate(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_nomap;
 	}
@@ -3894,14 +3901,14 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * check after taking the PT lock and making sure that nobody
 	 * concurrently faulted in this page and set PG_anon_exclusive.
 	 */
-	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
-	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
+	BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
+	BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
 
 	/*
 	 * Check under PT lock (to protect against concurrent fork() sharing
 	 * the swap entry concurrently) for certainly exclusive pages.
 	 */
-	if (!PageKsm(page)) {
+	if (!folio_test_ksm(folio)) {
 		/*
 		 * Note that pte_swp_exclusive() == false for architectures
 		 * without __HAVE_ARCH_PTE_SWP_EXCLUSIVE.
@@ -3913,7 +3920,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 * swapcache -> certainly exclusive.
 			 */
 			exclusive = true;
-		} else if (exclusive && PageWriteback(page) &&
+		} else if (exclusive && folio_test_writeback(folio) &&
 			  data_race(si->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
@@ -3956,7 +3963,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * exposing them to the swapcache or because the swap entry indicates
 	 * exclusivity.
 	 */
-	if (!PageKsm(page) && (exclusive || page_count(page) == 1)) {
+	if (!folio_test_ksm(folio) &&
+	    (exclusive || folio_ref_count(folio) == 1)) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
@@ -3976,16 +3984,17 @@ vm_fault_t do_swap_page(struct vm_fault
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		folio_add_lru_vma(folio, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
-	VM_BUG_ON(!PageAnon(page) || (pte_write(pte) && !PageAnonExclusive(page)));
+	VM_BUG_ON(!folio_test_anon(folio) ||
+			(pte_write(pte) && !PageAnonExclusive(page)));
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 
-	unlock_page(page);
+	folio_unlock(folio);
 	if (page != swapcache && swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
@@ -4017,9 +4026,9 @@ out:
 out_nomap:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
-	unlock_page(page);
+	folio_unlock(folio);
 out_release:
-	put_page(page);
+	folio_put(folio);
 	if (page != swapcache && swapcache) {
 		unlock_page(swapcache);
 		put_page(swapcache);
_

Patches currently in -mm which might be from willy@infradead.org are


