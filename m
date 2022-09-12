Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81872ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiILD2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILD2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8A61C93F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC5B61167
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE34C433D7;
        Mon, 12 Sep 2022 03:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953282;
        bh=wv150bsvZ7hCCbYwjyVqfrjakYrBIxikmAuAVDFT28c=;
        h=Date:To:From:Subject:From;
        b=NqN7pHpgXAV9YeRlmhATC0dS127ILjybwDia0b/hC8dSpwrA9AT5Os2xIwjXncXlT
         XYtb5tuUrxh+NoO+J0rM8t3StNU4o6C/ckIEypccUTdHWuLlEXj9/R4k9ND/zzIf68
         KJCxcxOhabYxUNnbFTCbdMr+Sx3l+Y6R5VgzS/WY=
Date:   Sun, 11 Sep 2022 20:28:01 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch removed from -mm tree
Message-Id: <20220912032802.8BE34C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: add flag to predicate khugepaged-only behavior
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[zokeefe@google.com: consistently order cc->is_khugepaged and pte_* checks]
  Link: https://lkml.kernel.org/r/20220720140603.1958773-3-zokeefe@google.com
  Link: https://lore.kernel.org/linux-mm/Ys2qJm6FaOQcxkha@google.com/
Link: https://lkml.kernel.org/r/20220706235936.2197195-7-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   83 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 25 deletions(-)

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
 	u32 node_load[MAX_NUMNODES];
 
@@ -554,6 +558,7 @@ static bool is_refcount_suitable(struct
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte,
+					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
@@ -566,8 +571,10 @@ static int __collapse_huge_page_isolate(
 		pte_t pteval = *_pte;
 		if (pte_none(pteval) || (pte_present(pteval) &&
 				is_zero_pfn(pte_pfn(pteval)))) {
+			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -587,11 +594,14 @@ static int __collapse_huge_page_isolate(
 
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 
-		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
-			result = SCAN_EXCEED_SHARED_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-			goto out;
+		if (page_mapcount(page) > 1) {
+			++shared;
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				goto out;
+			}
 		}
 
 		if (PageCompound(page)) {
@@ -654,10 +664,14 @@ static int __collapse_huge_page_isolate(
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
@@ -666,7 +680,7 @@ next:
 
 	if (unlikely(!writable)) {
 		result = SCAN_PAGE_RO;
-	} else if (unlikely(!referenced)) {
+	} else if (unlikely(cc->is_khugepaged && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -745,6 +759,7 @@ static void khugepaged_alloc_sleep(void)
 
 
 struct collapse_control khugepaged_collapse_control = {
+	.is_khugepaged = true,
 	.last_target_node = NUMA_NO_NODE,
 };
 
@@ -1025,7 +1040,7 @@ static int collapse_huge_page(struct mm_
 	mmu_notifier_invalidate_range_end(&range);
 
 	spin_lock(pte_ptl);
-	result =  __collapse_huge_page_isolate(vma, address, pte,
+	result =  __collapse_huge_page_isolate(vma, address, pte, cc,
 					       &compound_pagelist);
 	spin_unlock(pte_ptl);
 
@@ -1116,7 +1131,9 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (is_swap_pte(pteval)) {
-			if (++unmapped <= khugepaged_max_ptes_swap) {
+			++unmapped;
+			if (!cc->is_khugepaged ||
+			    unmapped <= khugepaged_max_ptes_swap) {
 				/*
 				 * Always be strict with uffd-wp
 				 * enabled swap entries.  Please see
@@ -1134,8 +1151,10 @@ static int khugepaged_scan_pmd(struct mm
 			}
 		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
-			    ++none_or_zero <= khugepaged_max_ptes_none) {
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
@@ -1165,11 +1184,14 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		if (page_mapcount(page) > 1 &&
-				++shared > khugepaged_max_ptes_shared) {
-			result = SCAN_EXCEED_SHARED_PTE;
-			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-			goto out_unmap;
+		if (page_mapcount(page) > 1) {
+			++shared;
+			if (cc->is_khugepaged &&
+			    shared > khugepaged_max_ptes_shared) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				goto out_unmap;
+			}
 		}
 
 		page = compound_head(page);
@@ -1220,14 +1242,22 @@ static int khugepaged_scan_pmd(struct mm
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
@@ -1896,7 +1926,9 @@ static int khugepaged_scan_file(struct m
 			continue;
 
 		if (xa_is_value(page)) {
-			if (++swap > khugepaged_max_ptes_swap) {
+			++swap;
+			if (cc->is_khugepaged &&
+			    swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -1947,7 +1979,8 @@ static int khugepaged_scan_file(struct m
 	rcu_read_unlock();
 
 	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		if (cc->is_khugepaged &&
+		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

