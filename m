Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D3CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81BA61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWsz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhEHWsz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711DA613C5;
        Sat,  8 May 2021 22:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514073;
        bh=cnPZufqjT8mkyEnlWsTJT00VICyjCFfa37B2trEjHDM=;
        h=Date:From:To:Subject:From;
        b=ZQgTc8wzggtZUlAAb2iuHgZmNHOiHExGvVHkyRgm6TBfxZzG7+DGFM0cdcmnYWH9R
         lJT11xex+OctwSncO/6OlXsMut70Zivn9TXVlz09CGl7a4LKfVNxeMwbJCDXWUQess
         5A0HqLvzD2zXGra0Uw7fJMjgU4Sg+fSlURMCBPj4=
Date:   Sat, 08 May 2021 15:47:53 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [merged]
 mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch removed from
 -mm tree
Message-ID: <20210508224753.UqsfBN3oA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make alloc_contig_range handle in-use hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: make alloc_contig_range handle in-use hugetlb pages

alloc_contig_range() will fail if it finds a HugeTLB page within the
range, without a chance to handle them.  Since HugeTLB pages can be
migrated as any LRU or Movable page, it does not make sense to bail out
without trying.  Enable the interface to recognize in-use HugeTLB pages so
we can migrate them, and have much better chances to succeed the call.

Link: https://lkml.kernel.org/r/20210419075413.1064-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++--
 mm/compaction.c         |   12 +++++++++++-
 mm/hugetlb.c            |   22 +++++++++++++++++-----
 mm/vmscan.c             |    5 +++--
 4 files changed, 34 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb.h~mm-make-alloc_contig_range-handle-in-use-hugetlb-pages
+++ a/include/linux/hugetlb.h
@@ -588,7 +588,7 @@ struct huge_bootmem_page {
 	struct hstate *hstate;
 };
 
-int isolate_or_dissolve_huge_page(struct page *page);
+int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
@@ -871,7 +871,8 @@ static inline void huge_ptep_modify_prot
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
-static inline int isolate_or_dissolve_huge_page(struct page *page)
+static inline int isolate_or_dissolve_huge_page(struct page *page,
+						struct list_head *list)
 {
 	return -ENOMEM;
 }
--- a/mm/compaction.c~mm-make-alloc_contig_range-handle-in-use-hugetlb-pages
+++ a/mm/compaction.c
@@ -907,7 +907,7 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page) && cc->alloc_contig) {
-			ret = isolate_or_dissolve_huge_page(page);
+			ret = isolate_or_dissolve_huge_page(page, &cc->migratepages);
 
 			/*
 			 * Fail isolation in case isolate_or_dissolve_huge_page()
@@ -921,6 +921,15 @@ isolate_migratepages_block(struct compac
 				goto isolate_fail;
 			}
 
+			if (PageHuge(page)) {
+				/*
+				 * Hugepage was successfully isolated and placed
+				 * on the cc->migratepages list.
+				 */
+				low_pfn += compound_nr(page) - 1;
+				goto isolate_success_no_list;
+			}
+
 			/*
 			 * Ok, the hugepage was dissolved. Now these pages are
 			 * Buddy and cannot be re-allocated because they are
@@ -1062,6 +1071,7 @@ isolate_migratepages_block(struct compac
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
+isolate_success_no_list:
 		cc->nr_migratepages += compound_nr(page);
 		nr_isolated += compound_nr(page);
 
--- a/mm/hugetlb.c~mm-make-alloc_contig_range-handle-in-use-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -2271,9 +2271,11 @@ static void restore_reserve_on_error(str
  * alloc_and_dissolve_huge_page - Allocate a new page and dissolve the old one
  * @h: struct hstate old page belongs to
  * @old_page: Old page to dissolve
+ * @list: List to isolate the page in case we need to
  * Returns 0 on success, otherwise negated error.
  */
-static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page)
+static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
+					struct list_head *list)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nid = page_to_nid(old_page);
@@ -2300,9 +2302,13 @@ retry:
 		goto free_new;
 	} else if (page_count(old_page)) {
 		/*
-		 * Someone has grabbed the page, fail for now.
+		 * Someone has grabbed the page, try to isolate it here.
+		 * Fail with -EBUSY if not possible.
 		 */
-		ret = -EBUSY;
+		spin_unlock_irq(&hugetlb_lock);
+		if (!isolate_huge_page(old_page, list))
+			ret = -EBUSY;
+		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
 		/*
@@ -2352,10 +2358,11 @@ free_new:
 	return ret;
 }
 
-int isolate_or_dissolve_huge_page(struct page *page)
+int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 {
 	struct hstate *h;
 	struct page *head;
+	int ret = -EBUSY;
 
 	/*
 	 * The page might have been dissolved from under our feet, so make sure
@@ -2380,7 +2387,12 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	return alloc_and_dissolve_huge_page(h, head);
+	if (page_count(head) && isolate_huge_page(head, list))
+		ret = 0;
+	else if (!page_count(head))
+		ret = alloc_and_dissolve_huge_page(h, head, list);
+
+	return ret;
 }
 
 struct page *alloc_huge_page(struct vm_area_struct *vma,
--- a/mm/vmscan.c~mm-make-alloc_contig_range-handle-in-use-hugetlb-pages
+++ a/mm/vmscan.c
@@ -1507,8 +1507,9 @@ unsigned int reclaim_clean_pages_from_li
 	LIST_HEAD(clean_pages);
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (page_is_file_lru(page) && !PageDirty(page) &&
-		    !__PageMovable(page) && !PageUnevictable(page)) {
+		if (!PageHuge(page) && page_is_file_lru(page) &&
+		    !PageDirty(page) && !__PageMovable(page) &&
+		    !PageUnevictable(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}
_

Patches currently in -mm which might be from osalvador@suse.de are


