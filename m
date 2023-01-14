Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B591AC678D7
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjANDxc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2631B60D6
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20DCCB822BD
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2471C433D2;
        Sat, 14 Jan 2023 03:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668388;
        bh=OqzdCBZq2TYnFhSG13T9j3O20Dpr75y8N7FKMiPolgQ=;
        h=Date:To:From:Subject:From;
        b=2A0LbA8cpEOhHdhhyQwYS5ChAI7v02JC3ruLisHJ63ugADny1ejuqKjgUAqPthgj7
         T3Rqy6yTIK2t3ssZtdL+GxkQ77X39LxPbdzSPBf1eRKaT5HAot7sOBVeynyOVoLXp9
         Mx0/ms1MxVLONR05FyKyVyu5XWVzt3z4Ol0Iy8JE=
Date:   Fri, 13 Jan 2023 19:53:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035308.A2471C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert alloc_migrate_huge_page to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch

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
@@ -718,7 +718,7 @@ struct huge_bootmem_page {
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
-struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
+struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
@@ -1039,8 +1039,8 @@ static inline struct page *alloc_huge_pa
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
@@ -1996,6 +1996,7 @@ struct page *alloc_migration_target(stru
 	struct migration_target_control *mtc;
 	gfp_t gfp_mask;
 	unsigned int order = 0;
+	struct folio *hugetlb_folio = NULL;
 	struct folio *new_folio = NULL;
 	int nid;
 	int zidx;
@@ -2010,7 +2011,9 @@ struct page *alloc_migration_target(stru
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

