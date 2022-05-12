Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5879FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 20:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244169AbiELUSu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 16:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358277AbiELUSp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 16:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DE120F4E6
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 13:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF745B82B1F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860FFC34100;
        Thu, 12 May 2022 20:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652386720;
        bh=E2nxYL9UzjNtjLglNd4gY0TVy1ehYqSPPqOp9sjEDic=;
        h=Date:To:From:Subject:From;
        b=TKmM4iaXENs6Jbds4WPY342OILr5N15HRn2Y23WSOYHLeqFs6u0lZO9tmf3Nul8Cx
         SLswJmUHJgdEquqNHrassAAs4qbdai8JjAq/oAjJGVvFD3J6XInQmG8fM4UW0S1/p0
         rWPPuz8IRbibD0PvxoH93APpZcXnHcpZvGGs995k=
Date:   Thu, 12 May 2022 13:18:39 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migration-return-errno-when-isolate_huge_page-failed.patch removed from -mm tree
Message-Id: <20220512201840.860FFC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: return errno when isolate_huge_page failed
has been removed from the -mm tree.  Its filename was
     mm-migration-return-errno-when-isolate_huge_page-failed.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: return errno when isolate_huge_page failed

We might fail to isolate huge page due to e.g.  the page is under
migration which cleared HPageMigratable.  So we should return -EBUSY in
this case rather than always return 1 which could confuse the user.  Also
we make the prototype of isolate_huge_page consistent with
isolate_lru_page to improve the readability.

Link: https://lkml.kernel.org/r/20220425132723.34824-4-linmiaohe@huawei.com
Fixes: e8db67eb0ded ("mm: migrate: move_pages() supports thp migration")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 mm/gup.c                |    2 +-
 mm/hugetlb.c            |   11 +++++------
 mm/memory-failure.c     |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    5 +++--
 6 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/hugetlb.h~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/include/linux/hugetlb.h
@@ -170,7 +170,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_huge_page(struct page *page, struct list_head *list);
+int isolate_huge_page(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
@@ -376,9 +376,9 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+static inline int isolate_huge_page(struct page *page, struct list_head *list)
 {
-	return false;
+	return -EBUSY;
 }
 
 static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
--- a/mm/gup.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/gup.c
@@ -1869,7 +1869,7 @@ static long check_and_migrate_movable_pa
 		 * Try to move out any movable page before pinning the range.
 		 */
 		if (folio_test_hugetlb(folio)) {
-			if (!isolate_huge_page(&folio->page,
+			if (isolate_huge_page(&folio->page,
 						&movable_page_list))
 				isolation_error_count++;
 			continue;
--- a/mm/hugetlb.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/hugetlb.c
@@ -2765,8 +2765,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		if (!isolate_huge_page(old_page, list))
-			ret = -EBUSY;
+		ret = isolate_huge_page(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
@@ -2842,7 +2841,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && isolate_huge_page(head, list))
+	if (page_count(head) && !isolate_huge_page(head, list))
 		ret = 0;
 	else if (!page_count(head))
 		ret = alloc_and_dissolve_huge_page(h, head, list);
@@ -6945,15 +6944,15 @@ follow_huge_pgd(struct mm_struct *mm, un
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-bool isolate_huge_page(struct page *page, struct list_head *list)
+int isolate_huge_page(struct page *page, struct list_head *list)
 {
-	bool ret = true;
+	int ret = 0;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!PageHeadHuge(page) ||
 	    !HPageMigratable(page) ||
 	    !get_page_unless_zero(page)) {
-		ret = false;
+		ret = -EBUSY;
 		goto unlock;
 	}
 	ClearHPageMigratable(page);
--- a/mm/memory-failure.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/memory-failure.c
@@ -2190,7 +2190,7 @@ static bool isolate_page(struct page *pa
 	bool lru = PageLRU(page);
 
 	if (PageHuge(page)) {
-		isolated = isolate_huge_page(page, pagelist);
+		isolated = !isolate_huge_page(page, pagelist);
 	} else {
 		if (lru)
 			isolated = !isolate_lru_page(page);
--- a/mm/mempolicy.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/mempolicy.c
@@ -602,7 +602,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (!isolate_huge_page(page, qp->pagelist) &&
+		if (isolate_huge_page(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
--- a/mm/migrate.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/migrate.c
@@ -1628,8 +1628,9 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			isolate_huge_page(page, pagelist);
-			err = 1;
+			err = isolate_huge_page(page, pagelist);
+			if (!err)
+				err = 1;
 		}
 	} else {
 		struct page *head;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch
mm-swap-use-helper-macro-__attr_rw.patch
mm-swap-fold-__swap_info_get-into-its-sole-caller.patch
mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch
mm-swap-print-bad-swap-offset-entry-in-get_swap_device.patch
mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch
mm-swap-remove-unneeded-p-=-null-check-in-__swap_duplicate.patch
mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch
mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch
mm-swap-fix-the-comment-of-get_kernel_pages.patch
mm-swap-fix-comment-about-swap-extent.patch

