Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEF0C6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjBMXzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBMXzO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B57271B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3478BB80B3E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B06C433EF;
        Mon, 13 Feb 2023 23:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332510;
        bh=IAxaXiq0DJqEecIUXCNe0BZSGtRVeDHloF6ysN9y334=;
        h=Date:To:From:Subject:From;
        b=wYkXBWcR7UfKoMWaJTznSHnx/V5w2pYZEBeDp5RdUQQCXD272wWWh3JlWLupLXwpy
         6wIiJXl5x5MbwBhr4POnf8wm96Q8j/p0OAK48ptVmROpELjVimM/h8X5GufyuGDsV+
         AvvVPJeE+2RWfRYZ2awx0GgoNTmqVyEtX27yPMgA=
Date:   Mon, 13 Feb 2023 15:55:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-__update_and_free_page-to-folios.patch removed from -mm tree
Message-Id: <20230213235510.B4B06C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert __update_and_free_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-__update_and_free_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert __update_and_free_page() to folios
Date: Fri, 13 Jan 2023 16:30:51 -0600

Change __update_and_free_page() to __update_and_free_hugetlb_folio() by
changing its callers to pass in a folio.

Link: https://lkml.kernel.org/r/20230113223057.173292-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-__update_and_free_page-to-folios
+++ a/mm/hugetlb.c
@@ -1698,10 +1698,10 @@ static void add_hugetlb_folio(struct hst
 	enqueue_hugetlb_folio(h, folio);
 }
 
-static void __update_and_free_page(struct hstate *h, struct page *page)
+static void __update_and_free_hugetlb_folio(struct hstate *h,
+						struct folio *folio)
 {
 	int i;
-	struct folio *folio = page_folio(page);
 	struct page *subpage;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1714,7 +1714,7 @@ static void __update_and_free_page(struc
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
 
-	if (hugetlb_vmemmap_restore(h, page)) {
+	if (hugetlb_vmemmap_restore(h, &folio->page)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1750,7 +1750,7 @@ static void __update_and_free_page(struc
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
-		__free_pages(page, huge_page_order(h));
+		__free_pages(&folio->page, huge_page_order(h));
 	}
 }
 
@@ -1790,7 +1790,7 @@ static void free_hpage_workfn(struct wor
 		 */
 		h = size_to_hstate(page_size(page));
 
-		__update_and_free_page(h, page);
+		__update_and_free_hugetlb_folio(h, page_folio(page));
 
 		cond_resched();
 	}
@@ -1807,7 +1807,7 @@ static void update_and_free_hugetlb_foli
 				 bool atomic)
 {
 	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
-		__update_and_free_page(h, &folio->page);
+		__update_and_free_hugetlb_folio(h, folio);
 		return;
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


