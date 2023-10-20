Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EE7C00A8F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 23:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjJTXuu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 19:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjJTXur (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 19:50:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1E5D5B
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 16:50:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F87C433CC;
        Fri, 20 Oct 2023 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697845843;
        bh=TqtWnrUILr4NJfM0jWLWmQlnwoOGK+95K22Wu8deWW4=;
        h=Date:To:From:Subject:From;
        b=RARIFJW0Y9bEZb370taTMVZdOe0ljREZETYI9jDHLhPEPF0rlsp0tOdZy6sopmnNu
         qoNRNR0B1xZjd8uF23blNp4R1AMk8Ci0Lzl8mU2/kjEmTJ7dQ/u+VFGlJduc/wHWUP
         Snl5a5NP7AGNM86qhxy4v79gVuG6fomASWXDYeyM=
Date:   Fri, 20 Oct 2023 16:50:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, shy828301@gmail.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231020235043.18F87C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: convert collapse_pte_mapped_thp() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

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
Subject: mm/khugepaged: convert collapse_pte_mapped_thp() to use folios
Date: Fri, 20 Oct 2023 11:33:31 -0700

This removes 2 calls to compound_head() and helps convert khugepaged to
use folios throughout.

Previously, if the address passed to collapse_pte_mapped_thp()
corresponded to a tail page, the scan would fail immediately. Using
filemap_lock_folio() we get the corresponding folio back and try to
operate on the folio instead.

Link: https://lkml.kernel.org/r/20231020183331.10770-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios
+++ a/mm/khugepaged.c
@@ -1477,7 +1477,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	bool notified = false;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
-	struct page *hpage;
+	struct folio *folio;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
@@ -1510,19 +1510,14 @@ int collapse_pte_mapped_thp(struct mm_st
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
 
-	hpage = find_lock_page(vma->vm_file->f_mapping,
+	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
-	if (!hpage)
+	if (IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
-	if (!PageHead(hpage)) {
-		result = SCAN_FAIL;
-		goto drop_hpage;
-	}
-
-	if (compound_order(hpage) != HPAGE_PMD_ORDER) {
+	if (folio_order(folio) != HPAGE_PMD_ORDER) {
 		result = SCAN_PAGE_COMPOUND;
-		goto drop_hpage;
+		goto drop_folio;
 	}
 
 	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
@@ -1536,13 +1531,13 @@ int collapse_pte_mapped_thp(struct mm_st
 		 */
 		goto maybe_install_pmd;
 	default:
-		goto drop_hpage;
+		goto drop_folio;
 	}
 
 	result = SCAN_FAIL;
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 	if (!start_pte)		/* mmap_lock + page lock should prevent this */
-		goto drop_hpage;
+		goto drop_folio;
 
 	/* step 1: check all mapped PTEs are to the right huge page */
 	for (i = 0, addr = haddr, pte = start_pte;
@@ -1567,7 +1562,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
 		 * page table, but the new page will not be a subpage of hpage.
 		 */
-		if (hpage + i != page)
+		if (folio_page(folio, i) != page)
 			goto abort;
 	}
 
@@ -1582,7 +1577,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
 	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
 	 * inserts a valid as-if-COWed PTE without even looking up page cache.
-	 * So page lock of hpage does not protect from it, so we must not drop
+	 * So page lock of folio does not protect from it, so we must not drop
 	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
 	 */
 	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
@@ -1606,7 +1601,7 @@ int collapse_pte_mapped_thp(struct mm_st
 			continue;
 		/*
 		 * We dropped ptl after the first scan, to do the mmu_notifier:
-		 * page lock stops more PTEs of the hpage being faulted in, but
+		 * page lock stops more PTEs of the folio being faulted in, but
 		 * does not stop write faults COWing anon copies from existing
 		 * PTEs; and does not stop those being swapped out or migrated.
 		 */
@@ -1615,7 +1610,7 @@ int collapse_pte_mapped_thp(struct mm_st
 			goto abort;
 		}
 		page = vm_normal_page(vma, addr, ptent);
-		if (hpage + i != page)
+		if (folio_page(folio, i) != page)
 			goto abort;
 
 		/*
@@ -1634,8 +1629,8 @@ int collapse_pte_mapped_thp(struct mm_st
 
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_ptes) {
-		page_ref_sub(hpage, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
+		folio_ref_sub(folio, nr_ptes);
+		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1659,14 +1654,14 @@ int collapse_pte_mapped_thp(struct mm_st
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, hpage)
+			? set_huge_pmd(vma, haddr, pmd, &folio->page)
 			: SCAN_SUCCEED;
-	goto drop_hpage;
+	goto drop_folio;
 abort:
 	if (nr_ptes) {
 		flush_tlb_mm(mm);
-		page_ref_sub(hpage, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
+		folio_ref_sub(folio, nr_ptes);
+		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
 	}
 	if (start_pte)
 		pte_unmap_unlock(start_pte, ptl);
@@ -1674,9 +1669,9 @@ abort:
 		spin_unlock(pml);
 	if (notified)
 		mmu_notifier_invalidate_range_end(&range);
-drop_hpage:
-	unlock_page(hpage);
-	put_page(hpage);
+drop_folio:
+	folio_unlock(folio);
+	folio_put(folio);
 	return result;
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch
mm-khugepaged-convert-hpage_collapse_scan_pmd-to-use-folios.patch
mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch
mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

