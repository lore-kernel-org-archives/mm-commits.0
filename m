Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB49C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiGDBJc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGDBJb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DB7626B
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 459FAB803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF266C341C7;
        Mon,  4 Jul 2022 01:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896967;
        bh=eIWzwNNqFHTP0/8EcqIti6gDxD6MfcLkCcZeX/ycrAY=;
        h=Date:To:From:Subject:From;
        b=RAKxBhBlHN3TK+E3lDG17dyGF64/be1xCg+YsMeeBeqYOxQat/2zDb7YW6kA0dHVN
         13DLhoqMU9ob62ZYqk/h6Fbcm30KCFCMPUpVNX6NQWv4qPkLGs/saAOOavUkLgW/aZ
         wjnK8mmd3jtSBU4beKN4fxB0vS3Rt7jL4QgugdNA=
Date:   Sun, 03 Jul 2022 18:09:26 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-return-errno-when-isolate_huge_page-failed.patch removed from -mm tree
Message-Id: <20220704010926.DF266C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: return errno when isolate_huge_page failed
has been removed from the -mm tree.  Its filename was
     mm-migration-return-errno-when-isolate_huge_page-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: return errno when isolate_huge_page failed
Date: Mon, 30 May 2022 19:30:15 +0800

We might fail to isolate huge page due to e.g.  the page is under
migration which cleared HPageMigratable.  We should return errno in this
case rather than always return 1 which could confuse the user, i.e.  the
caller might think all of the memory is migrated while the hugetlb page is
left behind.  We make the prototype of isolate_huge_page consistent with
isolate_lru_page as suggested by Huang Ying and rename isolate_huge_page
to isolate_hugetlb as suggested by Muchun to improve the readability.

Link: https://lkml.kernel.org/r/20220530113016.16663-4-linmiaohe@huawei.com
Fixes: e8db67eb0ded ("mm: migrate: move_pages() supports thp migration")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Reported-by: kernel test robot <lkp@intel.com> (build error)
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 mm/gup.c                |    2 +-
 mm/hugetlb.c            |   11 +++++------
 mm/memory-failure.c     |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    7 ++++---
 7 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/hugetlb.h~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/include/linux/hugetlb.h
@@ -170,7 +170,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_huge_page(struct page *page, struct list_head *list);
+int isolate_hugetlb(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
@@ -376,9 +376,9 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+static inline int isolate_hugetlb(struct page *page, struct list_head *list)
 {
-	return false;
+	return -EBUSY;
 }
 
 static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
--- a/mm/gup.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/gup.c
@@ -1930,7 +1930,7 @@ static long check_and_migrate_movable_pa
 		 * Try to move out any movable page before pinning the range.
 		 */
 		if (folio_test_hugetlb(folio)) {
-			if (!isolate_huge_page(&folio->page,
+			if (isolate_hugetlb(&folio->page,
 						&movable_page_list))
 				isolation_error_count++;
 			continue;
--- a/mm/hugetlb.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/hugetlb.c
@@ -2766,8 +2766,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		if (!isolate_huge_page(old_page, list))
-			ret = -EBUSY;
+		ret = isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
@@ -2843,7 +2842,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && isolate_huge_page(head, list))
+	if (page_count(head) && !isolate_hugetlb(head, list))
 		ret = 0;
 	else if (!page_count(head))
 		ret = alloc_and_dissolve_huge_page(h, head, list);
@@ -6960,15 +6959,15 @@ follow_huge_pgd(struct mm_struct *mm, un
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-bool isolate_huge_page(struct page *page, struct list_head *list)
+int isolate_hugetlb(struct page *page, struct list_head *list)
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
@@ -2178,7 +2178,7 @@ static bool isolate_page(struct page *pa
 	bool lru = PageLRU(page);
 
 	if (PageHuge(page)) {
-		isolated = isolate_huge_page(page, pagelist);
+		isolated = !isolate_hugetlb(page, pagelist);
 	} else {
 		if (lru)
 			isolated = !isolate_lru_page(page);
--- a/mm/memory_hotplug.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/memory_hotplug.c
@@ -1641,7 +1641,7 @@ do_migrate_range(unsigned long start_pfn
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_huge_page(head, &source);
+			isolate_hugetlb(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
--- a/mm/mempolicy.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/mempolicy.c
@@ -602,7 +602,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (!isolate_huge_page(page, qp->pagelist) &&
+		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
--- a/mm/migrate.c~mm-migration-return-errno-when-isolate_huge_page-failed
+++ a/mm/migrate.c
@@ -133,7 +133,7 @@ static void putback_movable_page(struct
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_huge_page().
+ * and isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1628,8 +1628,9 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			isolate_huge_page(page, pagelist);
-			err = 1;
+			err = isolate_hugetlb(page, pagelist);
+			if (!err)
+				err = 1;
 		}
 	} else {
 		struct page *head;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

