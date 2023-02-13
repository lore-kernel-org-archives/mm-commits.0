Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4C1C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjBMXz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBMXzS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74817148
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87A106135D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB36C433D2;
        Mon, 13 Feb 2023 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332517;
        bh=FN4w8XcadV6fPr4CgOG/DVk9/jALIw7MEXhVUm6KVJk=;
        h=Date:To:From:Subject:From;
        b=t+yrWdufFFF84D1W3BkRfzx3nIok92IvippEdiIgA8t9HvLmt0qFG+FHT1StTOrde
         nl5ZCUa/MqlodhmQiZR6r3YU/S2lRg/fpQQEGr4mtCPJxSg0mdsd+rhhCxhMcHXdON
         VzbxFAKjPJOUn2r4MprA18njg7uKeo2zhkA5roVo=
Date:   Mon, 13 Feb 2023 15:55:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-demote_free_huge_page-to-folios.patch removed from -mm tree
Message-Id: <20230213235516.DFB36C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert demote_free_huge_page to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-demote_free_huge_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert demote_free_huge_page to folios
Date: Fri, 13 Jan 2023 16:30:57 -0600

Change demote_free_huge_page to demote_free_hugetlb_folio() and change
demote_pool_huge_page() pass in a folio.

Link: https://lkml.kernel.org/r/20230113223057.173292-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-demote_free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -3579,12 +3579,12 @@ out:
 	return 0;
 }
 
-static int demote_free_huge_page(struct hstate *h, struct page *page)
+static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	int i, nid = page_to_nid(page);
+	int i, nid = folio_nid(folio);
 	struct hstate *target_hstate;
-	struct folio *folio = page_folio(page);
 	struct page *subpage;
+	struct folio *inner_folio;
 	int rc = 0;
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
@@ -3592,18 +3592,18 @@ static int demote_free_huge_page(struct
 	remove_hugetlb_folio_for_demote(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	rc = hugetlb_vmemmap_restore(h, page);
+	rc = hugetlb_vmemmap_restore(h, &folio->page);
 	if (rc) {
-		/* Allocation of vmemmmap failed, we can not demote page */
+		/* Allocation of vmemmmap failed, we can not demote folio */
 		spin_lock_irq(&hugetlb_lock);
-		set_page_refcounted(page);
-		add_hugetlb_folio(h, page_folio(page), false);
+		folio_ref_unfreeze(folio, 1);
+		add_hugetlb_folio(h, folio, false);
 		return rc;
 	}
 
 	/*
 	 * Use destroy_compound_hugetlb_folio_for_demote for all huge page
-	 * sizes as it will not ref count pages.
+	 * sizes as it will not ref count folios.
 	 */
 	destroy_compound_hugetlb_folio_for_demote(folio, huge_page_order(h));
 
@@ -3618,15 +3618,15 @@ static int demote_free_huge_page(struct
 	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
-		subpage = nth_page(page, i);
-		folio = page_folio(subpage);
+		subpage = folio_page(folio, i);
+		inner_folio = page_folio(subpage);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_folio_for_demote(folio,
+			prep_compound_gigantic_folio_for_demote(inner_folio,
 							target_hstate->order);
 		else
 			prep_compound_page(subpage, target_hstate->order);
-		set_page_private(subpage, 0);
-		prep_new_hugetlb_folio(target_hstate, folio, nid);
+		folio_change_private(inner_folio, NULL);
+		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
 		free_huge_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
@@ -3648,7 +3648,7 @@ static int demote_pool_huge_page(struct
 	__must_hold(&hugetlb_lock)
 {
 	int nr_nodes, node;
-	struct page *page;
+	struct folio *folio;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3659,11 +3659,10 @@ static int demote_pool_huge_page(struct
 	}
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
-			if (PageHWPoison(page))
+		list_for_each_entry(folio, &h->hugepage_freelists[node], lru) {
+			if (folio_test_hwpoison(folio))
 				continue;
-
-			return demote_free_huge_page(h, page);
+			return demote_free_hugetlb_folio(h, folio);
 		}
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


