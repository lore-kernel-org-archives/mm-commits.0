Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F4EC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiLUVUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLUVUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292531FCFB
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B257FB81BE7
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3D7C433D2;
        Wed, 21 Dec 2022 21:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657633;
        bh=Bt658CAcQNWyGxxd52yGRD3FSCQf699rnj0WIzNiDF8=;
        h=Date:To:From:Subject:From;
        b=eXtcETPaO2Sel0K2CZYlLVwEyi0GPDBRIopNDAcFi3tU8BMfY9Vn1rTjImBra5hpm
         LS/T9aUEHHMDfkXNNN1+/gUvkLfk8JrPl2XnlF6zAcV/t4C9Il6TlzRz+b/phIlK4C
         m5bZn4fAKnlCbdegLHZ4sPV6/vtzET5ws1f7RHSA=
Date:   Wed, 21 Dec 2022 13:20:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221221212033.6C3D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise: convert madvise_cold_or_pageout_pte_range() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: madvise: convert madvise_cold_or_pageout_pte_range() to use folios
Date: Wed, 21 Dec 2022 10:08:46 -0800

This change removes a number of calls to compound_head(), and saves
1729 bytes of kernel text.

Link: https://lkml.kernel.org/r/20221221180848.20774-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   98 ++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

--- a/mm/madvise.c~madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios
+++ a/mm/madvise.c
@@ -345,8 +345,8 @@ static int madvise_cold_or_pageout_pte_r
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *orig_pte, *pte, ptent;
 	spinlock_t *ptl;
-	struct page *page = NULL;
-	LIST_HEAD(page_list);
+	struct folio *folio = NULL;
+	LIST_HEAD(folio_list);
 	bool pageout_anon_only_filter;
 
 	if (fatal_signal_pending(current))
@@ -375,26 +375,26 @@ static int madvise_cold_or_pageout_pte_r
 			goto huge_unlock;
 		}
 
-		page = pmd_page(orig_pmd);
+		folio = pfn_folio(pmd_pfn(orig_pmd));
 
-		/* Do not interfere with other mappings of this page */
-		if (page_mapcount(page) != 1)
+		/* Do not interfere with other mappings of this folio */
+		if (folio_mapcount(folio) != 1)
 			goto huge_unlock;
 
-		if (pageout_anon_only_filter && !PageAnon(page))
+		if (pageout_anon_only_filter && !folio_test_anon(folio))
 			goto huge_unlock;
 
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
-			get_page(page);
+			folio_get(folio);
 			spin_unlock(ptl);
-			lock_page(page);
-			err = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
+			folio_lock(folio);
+			err = split_folio(folio);
+			folio_unlock(folio);
+			folio_put(folio);
 			if (!err)
-				goto regular_page;
+				goto regular_folio;
 			return 0;
 		}
 
@@ -406,25 +406,25 @@ static int madvise_cold_or_pageout_pte_r
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		ClearPageReferenced(page);
-		test_and_clear_page_young(page);
+		folio_clear_referenced(folio);
+		folio_test_clear_young(folio);
 		if (pageout) {
-			if (!isolate_lru_page(page)) {
-				if (PageUnevictable(page))
-					putback_lru_page(page);
+			if (!folio_isolate_lru(folio)) {
+				if (folio_test_unevictable(folio))
+					folio_putback_lru(folio);
 				else
-					list_add(&page->lru, &page_list);
+					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(page);
+			deactivate_page(&folio->page);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
-			reclaim_pages(&page_list);
+			reclaim_pages(&folio_list);
 		return 0;
 	}
 
-regular_page:
+regular_folio:
 	if (pmd_trans_unstable(pmd))
 		return 0;
 #endif
@@ -441,33 +441,33 @@ regular_page:
 		if (!pte_present(ptent))
 			continue;
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
 
 		/*
 		 * Creating a THP page is expensive so split it only if we
 		 * are sure it's worth. Split it if we are only owner.
 		 */
-		if (PageTransCompound(page)) {
-			if (page_mapcount(page) != 1)
+		if (folio_test_large(folio)) {
+			if (folio_mapcount(folio) != 1)
 				break;
-			if (pageout_anon_only_filter && !PageAnon(page))
+			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
-			get_page(page);
-			if (!trylock_page(page)) {
-				put_page(page);
+			folio_get(folio);
+			if (!folio_trylock(folio)) {
+				folio_put(folio);
 				break;
 			}
 			pte_unmap_unlock(orig_pte, ptl);
-			if (split_huge_page(page)) {
-				unlock_page(page);
-				put_page(page);
+			if (split_folio(folio)) {
+				folio_unlock(folio);
+				folio_put(folio);
 				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 				break;
 			}
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 			pte--;
 			addr -= PAGE_SIZE;
@@ -475,16 +475,16 @@ regular_page:
 		}
 
 		/*
-		 * Do not interfere with other mappings of this page and
-		 * non-LRU page.
+		 * Do not interfere with other mappings of this folio and
+		 * non-LRU folio.
 		 */
-		if (!PageLRU(page) || page_mapcount(page) != 1)
+		if (!folio_test_lru(folio) || folio_mapcount(folio) != 1)
 			continue;
 
-		if (pageout_anon_only_filter && !PageAnon(page))
+		if (pageout_anon_only_filter && !folio_test_anon(folio))
 			continue;
 
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
+		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 
 		if (pte_young(ptent)) {
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
@@ -495,28 +495,28 @@ regular_page:
 		}
 
 		/*
-		 * We are deactivating a page for accelerating reclaiming.
-		 * VM couldn't reclaim the page unless we clear PG_young.
+		 * We are deactivating a folio for accelerating reclaiming.
+		 * VM couldn't reclaim the folio unless we clear PG_young.
 		 * As a side effect, it makes confuse idle-page tracking
 		 * because they will miss recent referenced history.
 		 */
-		ClearPageReferenced(page);
-		test_and_clear_page_young(page);
+		folio_clear_referenced(folio);
+		folio_test_clear_young(folio);
 		if (pageout) {
-			if (!isolate_lru_page(page)) {
-				if (PageUnevictable(page))
-					putback_lru_page(page);
+			if (!folio_isolate_lru(folio)) {
+				if (folio_test_unevictable(folio))
+					folio_putback_lru(folio);
 				else
-					list_add(&page->lru, &page_list);
+					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(page);
+			deactivate_page(&folio->page);
 	}
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(orig_pte, ptl);
 	if (pageout)
-		reclaim_pages(&page_list);
+		reclaim_pages(&folio_list);
 	cond_resched();
 
 	return 0;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch

