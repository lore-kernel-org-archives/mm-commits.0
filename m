Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC89C43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbiGHVEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiGHVEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:04:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0846D572
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E269FCE2D5F
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2422EC341C0;
        Fri,  8 Jul 2022 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314283;
        bh=29L5MOd7ByBIAz9N7BJsIP4biP3AhJ1KCuDjjRPLhgM=;
        h=Date:To:From:Subject:From;
        b=FcgLK51+SXFWxKFmBIQWN84TTFJ6bNXpTkjEXhaUlQf08I2ERY4kMHl/JQpMeCmr7
         nuWlugGLmYFFb6LbEdVzTi0zCxejrVo7KBQwK9rYYc4PFb+J/5yX2yv43hp2LKgaMN
         0LR4RLfYiJJXZdU/42bVSMvD3PQJkbzcAIt4TI9k=
Date:   Fri, 08 Jul 2022 14:04:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch added to mm-unstable branch
Message-Id: <20220708210443.2422EC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: dedup and simplify hugepage alloc and charging
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: dedup and simplify hugepage alloc and charging
Date: Wed, 6 Jul 2022 16:59:22 -0700

The following code is duplicated in collapse_huge_page() and
collapse_file():

        gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;

	new_page = khugepaged_alloc_page(hpage, gfp, node);
        if (!new_page) {
                result = SCAN_ALLOC_HUGE_PAGE_FAIL;
                goto out;
        }

        if (unlikely(mem_cgroup_charge(page_folio(new_page), mm, gfp))) {
                result = SCAN_CGROUP_CHARGE_FAIL;
                goto out;
        }
        count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);

Also, "node" is passed as an argument to both collapse_huge_page() and
collapse_file() and obtained the same way, via
khugepaged_find_target_node().

Move all this into a new helper, alloc_charge_hpage(), and remove the
duplicate code from collapse_huge_page() and collapse_file().  Also,
simplify khugepaged_alloc_page() by returning a bool indicating allocation
success instead of a copy of the allocated struct page *.

Link: https://lkml.kernel.org/r/20220706235936.2197195-5-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   78 ++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 43 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging
+++ a/mm/khugepaged.c
@@ -813,19 +813,18 @@ static int khugepaged_find_target_node(s
 }
 #endif
 
-static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
+static bool khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
 	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
-		return NULL;
+		return false;
 	}
 
 	prep_transhuge_page(*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
-	return *hpage;
+	return true;
 }
 
 /*
@@ -921,10 +920,24 @@ static bool __collapse_huge_page_swapin(
 	return true;
 }
 
-static void collapse_huge_page(struct mm_struct *mm,
-				   unsigned long address,
-				   struct page **hpage,
-				   int node, int referenced, int unmapped)
+static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
+			      struct collapse_control *cc)
+{
+	/* Only allocate from the target node */
+	gfp_t gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
+	int node = khugepaged_find_target_node(cc);
+
+	if (!khugepaged_alloc_page(hpage, gfp, node))
+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	if (unlikely(mem_cgroup_charge(page_folio(*hpage), mm, gfp)))
+		return SCAN_CGROUP_CHARGE_FAIL;
+	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
+	return SCAN_SUCCEED;
+}
+
+static void collapse_huge_page(struct mm_struct *mm, unsigned long address,
+			       struct page **hpage, int referenced,
+			       int unmapped, struct collapse_control *cc)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -935,13 +948,9 @@ static void collapse_huge_page(struct mm
 	int isolated = 0, result = 0;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
-	gfp_t gfp;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	/* Only allocate from the target node */
-	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
-
 	/*
 	 * Before allocating the hugepage, release the mmap_lock read lock.
 	 * The allocation can take potentially a long time if it involves
@@ -949,17 +958,12 @@ static void collapse_huge_page(struct mm
 	 * that. We will recheck the vma after taking it again in write mode.
 	 */
 	mmap_read_unlock(mm);
-	new_page = khugepaged_alloc_page(hpage, gfp, node);
-	if (!new_page) {
-		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
-		goto out_nolock;
-	}
 
-	if (unlikely(mem_cgroup_charge(page_folio(new_page), mm, gfp))) {
-		result = SCAN_CGROUP_CHARGE_FAIL;
+	result = alloc_charge_hpage(hpage, mm, cc);
+	if (result != SCAN_SUCCEED)
 		goto out_nolock;
-	}
-	count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);
+
+	new_page = *hpage;
 
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, address, &vma);
@@ -1233,10 +1237,9 @@ static int khugepaged_scan_pmd(struct mm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (ret) {
-		node = khugepaged_find_target_node(cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-		collapse_huge_page(mm, address, hpage, node,
-				referenced, unmapped);
+		collapse_huge_page(mm, address, hpage, referenced, unmapped,
+				   cc);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
@@ -1504,7 +1507,7 @@ static void retract_page_tables(struct a
  * @file: file that collapse on
  * @start: collapse start address
  * @hpage: new allocated huge page for collapse
- * @node: appointed node the new huge page allocate from
+ * @cc: collapse context and scratchpad
  *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
@@ -1521,12 +1524,11 @@ static void retract_page_tables(struct a
  *    + restore gaps in the page cache;
  *    + unlock and free huge page;
  */
-static void collapse_file(struct mm_struct *mm,
-		struct file *file, pgoff_t start,
-		struct page **hpage, int node)
+static void collapse_file(struct mm_struct *mm, struct file *file,
+			  pgoff_t start, struct page **hpage,
+			  struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
-	gfp_t gfp;
 	struct page *new_page;
 	pgoff_t index, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
@@ -1538,20 +1540,11 @@ static void collapse_file(struct mm_stru
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	/* Only allocate from the target node */
-	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
-
-	new_page = khugepaged_alloc_page(hpage, gfp, node);
-	if (!new_page) {
-		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+	result = alloc_charge_hpage(hpage, mm, cc);
+	if (result != SCAN_SUCCEED)
 		goto out;
-	}
 
-	if (unlikely(mem_cgroup_charge(page_folio(new_page), mm, gfp))) {
-		result = SCAN_CGROUP_CHARGE_FAIL;
-		goto out;
-	}
-	count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);
+	new_page = *hpage;
 
 	/*
 	 * Ensure we have slots for all the pages in the range.  This is
@@ -1963,8 +1956,7 @@ static void khugepaged_scan_file(struct
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-			node = khugepaged_find_target_node(cc);
-			collapse_file(mm, file, start, hpage, node);
+			collapse_file(mm, file, start, hpage, cc);
 		}
 	}
 
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

