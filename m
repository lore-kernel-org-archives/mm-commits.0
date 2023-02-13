Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFF9C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBMXzU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBMXzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB03271B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35113B81A31
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4226C4339B;
        Mon, 13 Feb 2023 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332514;
        bh=ttUmluwknLCDX20jYyqNLOX0SSjeZPjprD37cyP2w8Q=;
        h=Date:To:From:Subject:From;
        b=d4wMLVPU0YvsGCkxDN8dkSWG5M9h2Ygun9LnaUlkg5eazUzsAC8CJB++NrtyLYCXO
         zhgR5F6Wf+j4S/Wo4vog6g8jvXP90IWYnrbqNG/mQQZHCbyiia0oHVr8JFOzn5DZSg
         /W6rqsbHL4rokySsdkPUGr8K7y/VgfL6QHeztwd8=
Date:   Mon, 13 Feb 2023 15:55:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch removed from -mm tree
Message-Id: <20230213235513.E4226C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: increase use of folios in alloc_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: increase use of folios in alloc_huge_page()
Date: Fri, 13 Jan 2023 16:30:54 -0600

Change hugetlb_cgroup_commit_charge{,_rsvd}(), dequeue_huge_page_vma() and
alloc_buddy_huge_page_with_mpol() to use folios so alloc_huge_page() is
cleaned by operating on folios until its return.

Link: https://lkml.kernel.org/r/20230113223057.173292-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-increase-use-of-folios-in-alloc_huge_page
+++ a/include/linux/hugetlb_cgroup.h
@@ -141,10 +141,10 @@ extern int hugetlb_cgroup_charge_cgroup_
 					     struct hugetlb_cgroup **ptr);
 extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					 struct hugetlb_cgroup *h_cg,
-					 struct page *page);
+					 struct folio *folio);
 extern void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 					      struct hugetlb_cgroup *h_cg,
-					      struct page *page);
+					      struct folio *folio);
 extern void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
 					 struct folio *folio);
 extern void hugetlb_cgroup_uncharge_folio_rsvd(int idx, unsigned long nr_pages,
@@ -230,14 +230,14 @@ static inline int hugetlb_cgroup_charge_
 
 static inline void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 						struct hugetlb_cgroup *h_cg,
-						struct page *page)
+						struct folio *folio)
 {
 }
 
 static inline void
 hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 				  struct hugetlb_cgroup *h_cg,
-				  struct page *page)
+				  struct folio *folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-increase-use-of-folios-in-alloc_huge_page
+++ a/mm/hugetlb.c
@@ -1348,7 +1348,7 @@ static unsigned long available_huge_page
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
-static struct page *dequeue_huge_page_vma(struct hstate *h,
+static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve,
 				long chg)
@@ -1392,7 +1392,7 @@ static struct page *dequeue_huge_page_vm
 	}
 
 	mpol_cond_put(mpol);
-	return &folio->page;
+	return folio;
 
 err:
 	return NULL;
@@ -2446,7 +2446,7 @@ static struct page *alloc_migrate_huge_p
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
 static
-struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
+struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct folio *folio = NULL;
@@ -2469,7 +2469,7 @@ struct page *alloc_buddy_huge_page_with_
 	if (!folio)
 		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
 	mpol_cond_put(mpol);
-	return &folio->page;
+	return folio;
 }
 
 /* page migration callback function */
@@ -3018,7 +3018,6 @@ struct page *alloc_huge_page(struct vm_a
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
-	struct page *page;
 	struct folio *folio;
 	long map_chg, map_commit;
 	long gbl_chg;
@@ -3082,34 +3081,34 @@ struct page *alloc_huge_page(struct vm_a
 	 * from the global free pool (global change).  gbl_chg == 0 indicates
 	 * a reservation exists for the allocation.
 	 */
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
-	if (!page) {
+	folio = dequeue_hugetlb_folio_vma(h, vma, addr, avoid_reserve, gbl_chg);
+	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
-		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
-		if (!page)
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
-			SetHPageRestoreReserve(page);
+			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
-		list_add(&page->lru, &h->hugepage_activelist);
-		set_page_refcounted(page);
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
 		/* Fall through */
 	}
-	folio = page_folio(page);
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
 	/* If allocation is not consuming a reservation, also store the
 	 * hugetlb_cgroup pointer on the page.
 	 */
 	if (deferred_reserve) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, page);
+						  h_cg, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	hugetlb_set_page_subpool(page, spool);
+	hugetlb_set_folio_subpool(folio, spool);
 
 	map_commit = vma_commit_reservation(h, vma, addr);
 	if (unlikely(map_chg > map_commit)) {
@@ -3130,7 +3129,7 @@ struct page *alloc_huge_page(struct vm_a
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
 	}
-	return page;
+	return &folio->page;
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-increase-use-of-folios-in-alloc_huge_page
+++ a/mm/hugetlb_cgroup.c
@@ -331,19 +331,15 @@ static void __hugetlb_cgroup_commit_char
 
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 				  struct hugetlb_cgroup *h_cg,
-				  struct page *page)
+				  struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, false);
 }
 
 void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 				       struct hugetlb_cgroup *h_cg,
-				       struct page *page)
+				       struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, true);
 }
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


