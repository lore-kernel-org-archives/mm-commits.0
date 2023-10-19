Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D338ECDB483
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 01:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjJSBHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 21:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjJSBHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 21:07:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F88D125
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 18:07:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAE3C433C7;
        Thu, 19 Oct 2023 01:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697677634;
        bh=Wi7pqMC7XvJxxMjzpdnypkoN5J+B0sHJnHF2ShYGMpw=;
        h=Date:To:From:Subject:From;
        b=e+tnb17sLi6zlsBNT33NJGshlTH/vcT8sdBJSrYllq9HpZa/PnC+LA4VCCZOyqnbK
         9aymkjlBhK6NetcDCQaUvfB9w4Sz1q1txrctMpdXSy8gK7P7CzCfHLVGwBQGQPyRPI
         MFqtO7VykGYO7A16dCDYyQs/dJYcBxjlxPsiUbGM=
Date:   Wed, 18 Oct 2023 18:07:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231019010714.BFAE3C433C7@smtp.kernel.org>
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
Date: Wed, 18 Oct 2023 13:32:13 -0700

This removes 2 calls to compound_head() and helps convert khugepaged to
use folios throughout.

Previously, if the address passed to collapse_pte_mapped_thp()
corresponded to a tail page, the scan would fail immediately.  Using
filemap_lock_folio() we can get the corresponding folio back and try to
operate on the folio instead.

Link: https://lkml.kernel.org/r/20231018203213.50224-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios
+++ a/mm/khugepaged.c
@@ -1475,7 +1475,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	bool notified = false;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
-	struct page *hpage;
+	struct folio *folio;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
@@ -1508,19 +1508,14 @@ int collapse_pte_mapped_thp(struct mm_st
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
 
-	hpage = find_lock_page(vma->vm_file->f_mapping,
+	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
-	if (!hpage)
+	if (!folio)
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
@@ -1534,13 +1529,13 @@ int collapse_pte_mapped_thp(struct mm_st
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
@@ -1565,7 +1560,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
 		 * page table, but the new page will not be a subpage of hpage.
 		 */
-		if (hpage + i != page)
+		if (folio_page(folio, i) != page)
 			goto abort;
 	}
 
@@ -1580,7 +1575,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
 	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
 	 * inserts a valid as-if-COWed PTE without even looking up page cache.
-	 * So page lock of hpage does not protect from it, so we must not drop
+	 * So page lock of folio does not protect from it, so we must not drop
 	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
 	 */
 	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
@@ -1604,7 +1599,7 @@ int collapse_pte_mapped_thp(struct mm_st
 			continue;
 		/*
 		 * We dropped ptl after the first scan, to do the mmu_notifier:
-		 * page lock stops more PTEs of the hpage being faulted in, but
+		 * page lock stops more PTEs of the folio being faulted in, but
 		 * does not stop write faults COWing anon copies from existing
 		 * PTEs; and does not stop those being swapped out or migrated.
 		 */
@@ -1613,7 +1608,7 @@ int collapse_pte_mapped_thp(struct mm_st
 			goto abort;
 		}
 		page = vm_normal_page(vma, addr, ptent);
-		if (hpage + i != page)
+		if (folio_page(folio, i) != page)
 			goto abort;
 
 		/*
@@ -1632,8 +1627,8 @@ int collapse_pte_mapped_thp(struct mm_st
 
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_ptes) {
-		page_ref_sub(hpage, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
+		folio_ref_sub(folio, nr_ptes);
+		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1657,14 +1652,14 @@ int collapse_pte_mapped_thp(struct mm_st
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
@@ -1672,9 +1667,9 @@ abort:
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
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix.patch

