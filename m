Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDCFC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjBCGiT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjBCGgg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617B08DAC0
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09641B80966
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41ABC4339C;
        Fri,  3 Feb 2023 06:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406185;
        bh=/bZPxZ9agPMXxXT2sb7Vb6/0hW6s181VU1jOIsPV+s4=;
        h=Date:To:From:Subject:From;
        b=nQJWePTbDZj78r849iaiHA0H0DSLOEC0kruLsXNXWEKKwsF0gGne9SYPSr3x96YYd
         G1diRzBv+bOpVsQXDE5Kd1QO2QSIxWZ4xTdHyjk1qWRM0kR+HL8/hlXA9OSOIuNizC
         Oy9ddR4HAnjc3D/+C0pqgqCdiI4yZ/3S7hraktPg=
Date:   Thu, 02 Feb 2023 22:36:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-convert-release_pte_pages-to-use-folios.patch removed from -mm tree
Message-Id: <20230203063625.A41ABC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: convert release_pte_pages() to use folios
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-convert-release_pte_pages-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: convert release_pte_pages() to use folios
Date: Fri, 13 Jan 2023 16:15:56 -0800

Converts release_pte_pages() to use folios instead of pages.

Link: https://lkml.kernel.org/r/20230114001556.43795-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-convert-release_pte_pages-to-use-folios
+++ a/mm/khugepaged.c
@@ -507,20 +507,20 @@ static void release_pte_page(struct page
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		struct list_head *compound_pagelist)
 {
-	struct page *page, *tmp;
+	struct folio *folio, *tmp;
 
 	while (--_pte >= pte) {
 		pte_t pteval = *_pte;
 
-		page = pte_page(pteval);
+		folio = pfn_folio(pte_pfn(pteval));
 		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)) &&
-				!PageCompound(page))
-			release_pte_page(page);
+				!folio_test_large(folio))
+			release_pte_folio(folio);
 	}
 
-	list_for_each_entry_safe(page, tmp, compound_pagelist, lru) {
-		list_del(&page->lru);
-		release_pte_page(page);
+	list_for_each_entry_safe(folio, tmp, compound_pagelist, lru) {
+		list_del(&folio->lru);
+		release_pte_folio(folio);
 	}
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

