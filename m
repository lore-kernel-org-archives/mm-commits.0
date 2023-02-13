Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE4C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBMXzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBMXzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDBF1B3
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6018B60DB9
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B292FC4339B;
        Mon, 13 Feb 2023 23:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332509;
        bh=sUbt0Uk9FShLoGakBAstJkZ2Mo9GadMuLbv4OM1naw8=;
        h=Date:To:From:Subject:From;
        b=u1B5yoQfbpYXaZJoerWmngAmoFGV3JvOwtXnVqQNR3tUDkYq5IcQUeqITC/Nj7yX9
         CRGS6+f2TugNCwvO55umGCyeIFGbfk30icRoJdZDo71SBBovFBgg+7YO1IE35bInW0
         tkeWyDBrOqGq6Psr1xglmP5PL/KGq6H+P2j/2Zsc=
Date:   Mon, 13 Feb 2023 15:55:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-isolate_hugetlb-to-folios.patch removed from -mm tree
Message-Id: <20230213235509.B292FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert isolate_hugetlb to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-isolate_hugetlb-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert isolate_hugetlb to folios
Date: Fri, 13 Jan 2023 16:30:50 -0600

Patch series "continue hugetlb folio conversion", v3.

This series continues the conversion of core hugetlb functions to use
folios. This series converts many helper funtions in the hugetlb fault
path. This is in preparation for another series to convert the hugetlb
fault code paths to operate on folios.


This patch (of 8):

Convert isolate_hugetlb() to take in a folio and convert its callers to
pass a folio.  Use page_folio() to convert the callers to use a folio is
safe as isolate_hugetlb() operates on a head page.

Link: https://lkml.kernel.org/r/20230113223057.173292-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20230113223057.173292-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-int isolate_hugetlb(struct page *page, struct list_head *list);
+int isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -413,7 +413,7 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline int isolate_hugetlb(struct page *page, struct list_head *list)
+static inline int isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	return -EBUSY;
 }
--- a/mm/gup.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/gup.c
@@ -1930,7 +1930,7 @@ static unsigned long collect_longterm_un
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(&folio->page, movable_page_list);
+			isolate_hugetlb(folio, movable_page_list);
 			continue;
 		}
 
--- a/mm/hugetlb.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/hugetlb.c
@@ -2925,7 +2925,7 @@ retry:
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		ret = isolate_hugetlb(&old_folio->page, list);
+		ret = isolate_hugetlb(old_folio, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!folio_test_hugetlb_freed(old_folio)) {
@@ -3000,7 +3000,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (folio_ref_count(folio) && !isolate_hugetlb(&folio->page, list))
+	if (folio_ref_count(folio) && !isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
 		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
@@ -7250,19 +7250,19 @@ __weak unsigned long hugetlb_mask_last_p
  * These functions are overwritable if your architecture needs its own
  * behavior.
  */
-int isolate_hugetlb(struct page *page, struct list_head *list)
+int isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	int ret = 0;
 
 	spin_lock_irq(&hugetlb_lock);
-	if (!PageHeadHuge(page) ||
-	    !HPageMigratable(page) ||
-	    !get_page_unless_zero(page)) {
+	if (!folio_test_hugetlb(folio) ||
+	    !folio_test_hugetlb_migratable(folio) ||
+	    !folio_try_get(folio)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
-	ClearHPageMigratable(page);
-	list_move_tail(&page->lru, list);
+	folio_clear_hugetlb_migratable(folio);
+	list_move_tail(&folio->lru, list);
 unlock:
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
--- a/mm/memory-failure.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/memory-failure.c
@@ -2508,7 +2508,7 @@ static bool isolate_page(struct page *pa
 	bool isolated = false;
 
 	if (PageHuge(page)) {
-		isolated = !isolate_hugetlb(page, pagelist);
+		isolated = !isolate_hugetlb(page_folio(page), pagelist);
 	} else {
 		bool lru = !__PageMovable(page);
 
--- a/mm/memory_hotplug.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/memory_hotplug.c
@@ -1641,7 +1641,7 @@ do_migrate_range(unsigned long start_pfn
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_hugetlb(head, &source);
+			isolate_hugetlb(folio, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
--- a/mm/mempolicy.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/mempolicy.c
@@ -602,7 +602,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
 	     !hugetlb_pmd_shared(pte))) {
-		if (isolate_hugetlb(page, qp->pagelist) &&
+		if (isolate_hugetlb(page_folio(page), qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
--- a/mm/migrate.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/migrate.c
@@ -1773,7 +1773,7 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			err = isolate_hugetlb(page, pagelist);
+			err = isolate_hugetlb(page_folio(page), pagelist);
 			if (!err)
 				err = 1;
 		}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


