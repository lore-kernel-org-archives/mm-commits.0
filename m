Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB99EC46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjANDxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BB1B65
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA94623AF
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD11C433EF;
        Sat, 14 Jan 2023 03:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668376;
        bh=yVW/r4pX+1ibk9y71aXuCaRkLO8/Cb/yztZe90oAh2s=;
        h=Date:To:From:Subject:From;
        b=y+n/Xf0rqHCda/Cg1mnKsa4+SjKvdvwO+XrCDSdd4Cru/lXyglxmIPVaRsZqdY3gB
         RvqqArOmg3veFvjJXCmzDG+hX6iiAgw/autU31nINyZ0bd0ayFH2SURGAnxeB5n3pB
         x7XgZoAD00FLunnq1KjYKEB50flNn8NxgpadH4Kw=
Date:   Fri, 13 Jan 2023 19:52:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-isolate_hugetlb-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035256.BCD11C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert isolate_hugetlb to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-isolate_hugetlb-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-isolate_hugetlb-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert isolate_hugetlb to folios
Date: Fri, 13 Jan 2023 16:30:50 -0600

Patch series "continue hugetlb folio conversion", v3.

This series continues the conversion of core hugetlb functions to use
folios. This series converts many helper funtions in the hugetlb fault
path. This is in preperation for another series to convert the hugetlb
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
@@ -170,7 +170,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-int isolate_hugetlb(struct page *page, struct list_head *list);
+int isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -412,7 +412,7 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline int isolate_hugetlb(struct page *page, struct list_head *list)
+static inline int isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	return -EBUSY;
 }
--- a/mm/gup.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/gup.c
@@ -1905,7 +1905,7 @@ static unsigned long collect_longterm_un
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
@@ -2437,7 +2437,7 @@ static bool isolate_page(struct page *pa
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
@@ -601,7 +601,7 @@ static int queue_pages_hugetlb(pte_t *pt
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (isolate_hugetlb(page, qp->pagelist) &&
+		if (isolate_hugetlb(page_folio(page), qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
--- a/mm/migrate.c~mm-hugetlb-convert-isolate_hugetlb-to-folios
+++ a/mm/migrate.c
@@ -2106,7 +2106,7 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			err = isolate_hugetlb(page, pagelist);
+			err = isolate_hugetlb(page_folio(page), pagelist);
 			if (!err)
 				err = 1;
 		}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

