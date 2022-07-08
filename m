Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52761CCA47B
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiGHVE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiGHVEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:04:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A10A0256
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99177B804A4
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6D1C341C0;
        Fri,  8 Jul 2022 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314288;
        bh=axzoUf+kzeTV0ncPBjxcDKPS5hdF6N5784UN8lZUj8c=;
        h=Date:To:From:Subject:From;
        b=HGZBB7+uqhwU1Dfl45/4wLja57l+giCpReshBgpfFepVkzXdQ/rnA/tq9vLUSNuOh
         bH5CHaRodIU4RBDLIhHeiM+iDREPpboTv4LkIH5dK/Gx/mwgpXP7geiB3FqQCSkszP
         bU+38Q75ZzzG24hUQCnIDSj1gLBDXCswgARhdjyE=
Date:   Fri, 08 Jul 2022 14:04:47 -0700
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
Subject: + mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch added to mm-unstable branch
Message-Id: <20220708210448.3A6D1C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add flag to predicate khugepaged-only behavior
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch

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
Subject: mm/khugepaged: add flag to predicate khugepaged-only behavior
Date: Wed, 6 Jul 2022 16:59:24 -0700

Add .is_khugepaged flag to struct collapse_control so khugepaged-specific
behavior can be elided by MADV_COLLAPSE context.

Start by protecting khugepaged-specific heuristics by this flag.  In
MADV_COLLAPSE, the user presumably has reason to believe the collapse will
be beneficial and khugepaged heuristics shouldn't prevent the user from
doing so:

1) sysfs-controlled knobs khugepaged_max_ptes_[none|swap|shared]

2) requirement that some pages in region being collapsed be young or
   referenced

Link: https://lkml.kernel.org/r/20220706235936.2197195-7-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
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
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   62 +++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 19 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior
+++ a/mm/khugepaged.c
@@ -73,6 +73,8 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  * default collapse hugepages if there is at least one pte mapped like
  * it would have happened if the vma was large enough during page
  * fault.
+ *
+ * Note that these are only respected if collapse was initiated by khugepaged.
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
@@ -86,6 +88,8 @@ static struct kmem_cache *mm_slot_cache
 #define MAX_PTE_MAPPED_THP 8
 
 struct collapse_control {
+	bool is_khugepaged;
+
 	/* Num pages scanned per node */
 	int node_load[MAX_NUMNODES];
 
@@ -554,6 +558,7 @@ static bool is_refcount_suitable(struct
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte,
+					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
@@ -567,7 +572,8 @@ static int __collapse_huge_page_isolate(
 		if (pte_none(pteval) || (pte_present(pteval) &&
 				is_zero_pfn(pte_pfn(pteval)))) {
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    (++none_or_zero <= khugepaged_max_ptes_none ||
+			     !cc->is_khugepaged)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -587,8 +593,8 @@ static int __collapse_huge_page_isolate(
 
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 
-		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
+		if (cc->is_khugepaged && page_mapcount(page) > 1 &&
+		    ++shared > khugepaged_max_ptes_shared) {
 			result = SCAN_EXCEED_SHARED_PTE;
 			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 			goto out;
@@ -654,10 +660,14 @@ static int __collapse_huge_page_isolate(
 		if (PageCompound(page))
 			list_add_tail(&page->lru, compound_pagelist);
 next:
-		/* There should be enough young pte to collapse the page */
-		if (pte_young(pteval) ||
-		    page_is_young(page) || PageReferenced(page) ||
-		    mmu_notifier_test_young(vma->vm_mm, address))
+		/*
+		 * If collapse was initiated by khugepaged, check that there is
+		 * enough young pte to justify collapsing the page
+		 */
+		if (cc->is_khugepaged &&
+		    (pte_young(pteval) || page_is_young(page) ||
+		     PageReferenced(page) || mmu_notifier_test_young(vma->vm_mm,
+								     address)))
 			referenced++;
 
 		if (pte_write(pteval))
@@ -666,7 +676,7 @@ next:
 
 	if (unlikely(!writable)) {
 		result = SCAN_PAGE_RO;
-	} else if (unlikely(!referenced)) {
+	} else if (unlikely(cc->is_khugepaged && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -745,6 +755,7 @@ static void khugepaged_alloc_sleep(void)
 
 
 struct collapse_control khugepaged_collapse_control = {
+	.is_khugepaged = true,
 	.last_target_node = NUMA_NO_NODE,
 };
 
@@ -1023,7 +1034,7 @@ static int collapse_huge_page(struct mm_
 	mmu_notifier_invalidate_range_end(&range);
 
 	spin_lock(pte_ptl);
-	result =  __collapse_huge_page_isolate(vma, address, pte,
+	result =  __collapse_huge_page_isolate(vma, address, pte, cc,
 					       &compound_pagelist);
 	spin_unlock(pte_ptl);
 
@@ -1114,7 +1125,8 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
-			if (++unmapped <= khugepaged_max_ptes_swap) {
+			if (++unmapped <= khugepaged_max_ptes_swap ||
+			    !cc->is_khugepaged) {
 				/*
 				 * Always be strict with uffd-wp
 				 * enabled swap entries.  Please see
@@ -1133,7 +1145,8 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    (++none_or_zero <= khugepaged_max_ptes_none ||
+			     !cc->is_khugepaged)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1163,8 +1176,9 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
+		if (cc->is_khugepaged &&
+		    page_mapcount(page) > 1 &&
+		    ++shared > khugepaged_max_ptes_shared) {
 			result = SCAN_EXCEED_SHARED_PTE;
 			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 			goto out_unmap;
@@ -1218,14 +1232,22 @@ static int khugepaged_scan_pmd(struct mm
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
-		if (pte_young(pteval) ||
-		    page_is_young(page) || PageReferenced(page) ||
-		    mmu_notifier_test_young(vma->vm_mm, address))
+
+		/*
+		 * If collapse was initiated by khugepaged, check that there is
+		 * enough young pte to justify collapsing the page
+		 */
+		if (cc->is_khugepaged &&
+		    (pte_young(pteval) || page_is_young(page) ||
+		     PageReferenced(page) || mmu_notifier_test_young(vma->vm_mm,
+								     address)))
 			referenced++;
 	}
 	if (!writable) {
 		result = SCAN_PAGE_RO;
-	} else if (!referenced || (unmapped && referenced < HPAGE_PMD_NR/2)) {
+	} else if (cc->is_khugepaged &&
+		   (!referenced ||
+		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1894,7 +1916,8 @@ static int khugepaged_scan_file(struct m
 			continue;
 
 		if (xa_is_value(page)) {
-			if (++swap > khugepaged_max_ptes_swap) {
+			if (cc->is_khugepaged &&
+			    ++swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -1945,7 +1968,8 @@ static int khugepaged_scan_file(struct m
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		if (present < HPAGE_PMD_NR - khugepaged_max_ptes_none &&
+		    cc->is_khugepaged) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
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

