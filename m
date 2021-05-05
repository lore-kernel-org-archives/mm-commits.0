Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E3AC43462
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C9B613FE
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhEEBg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A24261402;
        Wed,  5 May 2021 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178530;
        bh=hI1yWU7hy2tddluKFg6IWRdwO6mKCZurTTZxv5woaLo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qijj285R5W+JzG3TetefjUW+07S+hlOa8HDFEKd+sTpP0AMObTW6Po4VsEd3Pr3MH
         5NS6HM2irGr3JMd17FKgTkbIYhp0I/gmk3Sc58WXBw8r+Z9R6Orzqji3wZvy9UQgJk
         ZtfmwJDDgNoP+vcH3/4sE58sjb9rGp6JVA+l8EkE=
Date:   Tue, 04 May 2021 18:35:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 052/143] mm: make alloc_contig_range handle in-use
 hugetlb pages
Message-ID: <20210505013529.9eNpIyoQ-%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
