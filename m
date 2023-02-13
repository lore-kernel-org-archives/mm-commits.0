Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B3FC6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjBMXzV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjBMXzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241416AD2
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DE3FB80B3E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3793C433EF;
        Mon, 13 Feb 2023 23:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332515;
        bh=9Z2H9Rfhd4nm7Znf9JnCtTRrhxO1QAKUj3MSOFyQCgc=;
        h=Date:To:From:Subject:From;
        b=eBtjzV31JN3i6jVsLFjoHhLVf6rpEpe+0BwJO+Rk/GzKxXpK6GfalVoIodXC2QwG4
         5Equ9/+pWyZEoXFfv+Pj7lnn4VrjqdwLVLyOXqLRFWe3CgLwrIbgjIgBhRSi9ZTuk8
         JT+ZHmT5YC/UrG1vVwgdaZiJJ4jPQrZatmDAWjNM=
Date:   Mon, 13 Feb 2023 15:55:14 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20230213235514.E3793C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert alloc_migrate_huge_page to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert alloc_migrate_huge_page to folios
Date: Fri, 13 Jan 2023 16:30:55 -0600

Change alloc_huge_page_nodemask() to alloc_hugetlb_folio_nodemask() and
alloc_migrate_huge_page() to alloc_migrate_hugetlb_folio().  Both
functions now return a folio rather than a page.

Link: https://lkml.kernel.org/r/20230113223057.173292-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-alloc_migrate_huge_page-to-folios
+++ a/include/linux/hugetlb.h
@@ -719,7 +719,7 @@ struct huge_bootmem_page {
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
@@ -1040,8 +1040,8 @@ static inline struct page *alloc_huge_pa
 	return NULL;
 }
 
-static inline struct page *
-alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+static inline struct folio *
+alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 			nodemask_t *nmask, gfp_t gfp_mask)
 {
 	return NULL;
--- a/mm/hugetlb.c~mm-hugetlb-convert-alloc_migrate_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2419,7 +2419,7 @@ out_unlock:
 	return folio;
 }
 
-static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 				     int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
@@ -2439,7 +2439,7 @@ static struct page *alloc_migrate_huge_p
 	 */
 	folio_set_hugetlb_temporary(folio);
 
-	return &folio->page;
+	return folio;
 }
 
 /*
@@ -2472,8 +2472,8 @@ struct folio *alloc_buddy_hugetlb_folio_
 	return folio;
 }
 
-/* page migration callback function */
-struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+/* folio migration callback function */
+struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
 	spin_lock_irq(&hugetlb_lock);
@@ -2484,12 +2484,12 @@ struct page *alloc_huge_page_nodemask(st
 						preferred_nid, nmask);
 		if (folio) {
 			spin_unlock_irq(&hugetlb_lock);
-			return &folio->page;
+			return folio;
 		}
 	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	return alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
+	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
 }
 
 /* mempolicy aware migration callback */
@@ -2498,16 +2498,16 @@ struct page *alloc_huge_page_vma(struct
 {
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
-	struct page *page;
+	struct folio *folio;
 	gfp_t gfp_mask;
 	int node;
 
 	gfp_mask = htlb_alloc_mask(h);
 	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-	page = alloc_huge_page_nodemask(h, node, nodemask, gfp_mask);
+	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask);
 	mpol_cond_put(mpol);
 
-	return page;
+	return &folio->page;
 }
 
 /*
--- a/mm/migrate.c~mm-hugetlb-convert-alloc_migrate_huge_page-to-folios
+++ a/mm/migrate.c
@@ -1663,6 +1663,7 @@ struct page *alloc_migration_target(stru
 	struct migration_target_control *mtc;
 	gfp_t gfp_mask;
 	unsigned int order = 0;
+	struct folio *hugetlb_folio = NULL;
 	struct folio *new_folio = NULL;
 	int nid;
 	int zidx;
@@ -1677,7 +1678,9 @@ struct page *alloc_migration_target(stru
 		struct hstate *h = folio_hstate(folio);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
-		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
+		hugetlb_folio = alloc_hugetlb_folio_nodemask(h, nid,
+						mtc->nmask, gfp_mask);
+		return &hugetlb_folio->page;
 	}
 
 	if (folio_test_large(folio)) {
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


