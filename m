Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A97C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3964F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhBYTfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235057AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AF664FAF;
        Thu, 25 Feb 2021 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280696;
        bh=82RU+BkTGwTC7vompXtgLw5pz4XfhRLdNbeWfkhorSQ=;
        h=Date:From:To:Subject:From;
        b=aAEPBQIREr7EMvcWeXg16XfKDFR5UmqQm6zq0fxHdq2FKsVb9DflnlxuyvOgXlJQX
         cjMEaRV4eUjblcBoZcmrkhrtxTHhkoF1qz+jBj7NnZARaHN+VpNZfX2t1RbHmeOIGv
         7OxtGlk7q0aUEdLXCwfJDCXYPxrhobb3sXSkQtv8=
Date:   Thu, 25 Feb 2021 11:18:15 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 hugetlb-convert-page_huge_active-hpagemigratable-flag.patch removed from
 -mm tree
Message-ID: <20210225191815.CdUanF4mP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: convert page_huge_active() HPageMigratable flag
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-page_huge_active-hpagemigratable-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: convert page_huge_active() HPageMigratable flag

Use the new hugetlb page specific flag HPageMigratable to replace the
page_huge_active interfaces.  By it's name, page_huge_active implied that
a huge page was on the active list.  However, that is not really what code
checking the flag wanted to know.  It really wanted to determine if the
huge page could be migrated.  This happens when the page is actually added
to the page cache and/or task page table.  This is the reasoning behind
the name change.

The VM_BUG_ON_PAGE() calls in the *_huge_active() interfaces are not
really necessary as we KNOW the page is a hugetlb page.  Therefore, they
are removed.

The routine page_huge_active checked for PageHeadHuge before testing the
active bit.  This is unnecessary in the case where we hold a reference or
lock and know it is a hugetlb head page.  page_huge_active is also called
without holding a reference or lock (scan_movable_pages), and can race
with code freeing the page.  The extra check in page_huge_active shortened
the race window, but did not prevent the race.  Offline code calling
scan_movable_pages already deals with these races, so removing the check
is acceptable.  Add comment to racy code.

[songmuchun@bytedance.com: remove set_page_huge_active() declaration from include/linux/hugetlb.h]
  Link: https://lkml.kernel.org/r/CAMZfGtUda+KoAZscU0718TN61cSFwp4zy=y2oZ=+6Z2TAZZwng@mail.gmail.com
Link: https://lkml.kernel.org/r/20210122195231.324857-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c       |    2 -
 include/linux/hugetlb.h    |    7 +++--
 include/linux/page-flags.h |    6 ----
 mm/hugetlb.c               |   45 ++++++++---------------------------
 mm/memory_hotplug.c        |    9 ++++++-
 5 files changed, 25 insertions(+), 44 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-convert-page_huge_active-hpagemigratable-flag
+++ a/fs/hugetlbfs/inode.c
@@ -735,7 +735,7 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-		set_page_huge_active(page);
+		SetHPageMigratable(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
 		 * put_page() due to reference from alloc_huge_page()
--- a/include/linux/hugetlb.h~hugetlb-convert-page_huge_active-hpagemigratable-flag
+++ a/include/linux/hugetlb.h
@@ -480,9 +480,13 @@ unsigned long hugetlb_get_unmapped_area(
  * HPG_restore_reserve - Set when a hugetlb page consumes a reservation at
  *	allocation time.  Cleared when page is fully instantiated.  Free
  *	routine checks flag to restore a reservation on error paths.
+ * HPG_migratable  - Set after a newly allocated page is added to the page
+ *	cache and/or page tables.  Indicates the page is a candidate for
+ *	migration.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve = 0,
+	HPG_migratable,
 	__NR_HPAGEFLAGS,
 };
 
@@ -525,6 +529,7 @@ static inline void ClearHPage##uname(str
  * Create functions associated with hugetlb page flags
  */
 HPAGEFLAG(RestoreReserve, restore_reserve)
+HPAGEFLAG(Migratable, migratable)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -838,8 +843,6 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
-void set_page_huge_active(struct page *page);
-
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/include/linux/page-flags.h~hugetlb-convert-page_huge_active-hpagemigratable-flag
+++ a/include/linux/page-flags.h
@@ -592,15 +592,9 @@ static inline void ClearPageCompound(str
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
 int PageHeadHuge(struct page *page);
-bool page_huge_active(struct page *page);
 #else
 TESTPAGEFLAG_FALSE(Huge)
 TESTPAGEFLAG_FALSE(HeadHuge)
-
-static inline bool page_huge_active(struct page *page)
-{
-	return 0;
-}
 #endif
 
 
--- a/mm/hugetlb.c~hugetlb-convert-page_huge_active-hpagemigratable-flag
+++ a/mm/hugetlb.c
@@ -1365,30 +1365,6 @@ struct hstate *size_to_hstate(unsigned l
 }
 
 /*
- * Test to determine whether the hugepage is "active/in-use" (i.e. being linked
- * to hstate->hugepage_activelist.)
- *
- * This function can be called for tail pages, but never returns true for them.
- */
-bool page_huge_active(struct page *page)
-{
-	return PageHeadHuge(page) && PagePrivate(&page[1]);
-}
-
-/* never called for tail page */
-void set_page_huge_active(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
-	SetPagePrivate(&page[1]);
-}
-
-static void clear_page_huge_active(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
-	ClearPagePrivate(&page[1]);
-}
-
-/*
  * Internal hugetlb specific page flag. Do not use outside of the hugetlb
  * code
  */
@@ -1449,7 +1425,7 @@ static void __free_huge_page(struct page
 	}
 
 	spin_lock(&hugetlb_lock);
-	clear_page_huge_active(page);
+	ClearHPageMigratable(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
@@ -4218,7 +4194,7 @@ retry_avoidcopy:
 				make_huge_pte(vma, new_page, 1));
 		page_remove_rmap(old_page, true);
 		hugepage_add_new_anon_rmap(new_page, vma, haddr);
-		set_page_huge_active(new_page);
+		SetHPageMigratable(new_page);
 		/* Make the old page be freed below */
 		new_page = old_page;
 	}
@@ -4455,12 +4431,12 @@ retry:
 	spin_unlock(ptl);
 
 	/*
-	 * Only make newly allocated pages active.  Existing pages found
-	 * in the pagecache could be !page_huge_active() if they have been
-	 * isolated for migration.
+	 * Only set HPageMigratable in newly allocated pages.  Existing pages
+	 * found in the pagecache may not have HPageMigratableset if they have
+	 * been isolated for migration.
 	 */
 	if (new_page)
-		set_page_huge_active(page);
+		SetHPageMigratable(page);
 
 	unlock_page(page);
 out:
@@ -4771,7 +4747,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
 	spin_unlock(ptl);
-	set_page_huge_active(page);
+	SetHPageMigratable(page);
 	if (vm_shared)
 		unlock_page(page);
 	ret = 0;
@@ -5610,12 +5586,13 @@ bool isolate_huge_page(struct page *page
 	bool ret = true;
 
 	spin_lock(&hugetlb_lock);
-	if (!PageHeadHuge(page) || !page_huge_active(page) ||
+	if (!PageHeadHuge(page) ||
+	    !HPageMigratable(page) ||
 	    !get_page_unless_zero(page)) {
 		ret = false;
 		goto unlock;
 	}
-	clear_page_huge_active(page);
+	ClearHPageMigratable(page);
 	list_move_tail(&page->lru, list);
 unlock:
 	spin_unlock(&hugetlb_lock);
@@ -5625,7 +5602,7 @@ unlock:
 void putback_active_hugepage(struct page *page)
 {
 	spin_lock(&hugetlb_lock);
-	set_page_huge_active(page);
+	SetHPageMigratable(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
--- a/mm/memory_hotplug.c~hugetlb-convert-page_huge_active-hpagemigratable-flag
+++ a/mm/memory_hotplug.c
@@ -1260,7 +1260,14 @@ static int scan_movable_pages(unsigned l
 		if (!PageHuge(page))
 			continue;
 		head = compound_head(page);
-		if (page_huge_active(head))
+		/*
+		 * This test is racy as we hold no reference or lock.  The
+		 * hugetlb page could have been free'ed and head is no longer
+		 * a hugetlb page before the following check.  In such unlikely
+		 * cases false positives and negatives are possible.  Calling
+		 * code must deal with these scenarios.
+		 */
+		if (HPageMigratable(head))
 			goto found;
 		skip = compound_nr(head) - (page - head);
 		pfn += skip - 1;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


