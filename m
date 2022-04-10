Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FA1C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiDJElP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiDJElO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:41:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E571157
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D145EB80B83
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F9FC385A4;
        Sun, 10 Apr 2022 04:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565542;
        bh=EGKC/TMnfEYcsEqHwGsUVeeae3MT+1yz5/x2aj3jqD8=;
        h=Date:To:From:Subject:From;
        b=CbRi3sUXOGqDr/awuXJGoZm8R/E5cgg+u6RBR/0xh2ecip1vpTUTOjLZEq2I1TB8D
         XNSMRW0uqyDRUc6L6of5pPQAxeu/2cZCpCR4QWE3NpQpH3bLqKQHYO4EViMJ2AXgWs
         ftKkAusFu7tWkNkEZQPJMjDfy9WqZaD4e26pJDAY=
Date:   Sat, 09 Apr 2022 21:39:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@linux.dev, mhocko@kernel.org, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch removed from -mm tree
Message-Id: <20220410043902.61F9FC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.

Fix a VM_BUG_ON_FOLIO(folio_nr_pages(old) != nr_pages) crash.

With folios support, it is possible to have other than HPAGE_PMD_ORDER
THPs, in the form of folios, in the system.  Use thp_order() to correctly
determine the source page order during migration.

Link: https://lkml.kernel.org/r/20220404165325.1883267-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/20220404132908.GA785673@u2004/
Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 mm/migrate.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
+++ a/mm/mempolicy.c
@@ -1209,7 +1209,7 @@ static struct page *new_page(struct page
 		struct page *thp;
 
 		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
-					 HPAGE_PMD_ORDER);
+					 thp_order(page));
 		if (!thp)
 			return NULL;
 		prep_transhuge_page(thp);
--- a/mm/migrate.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
+++ a/mm/migrate.c
@@ -1547,7 +1547,7 @@ struct page *alloc_migration_target(stru
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
-		order = HPAGE_PMD_ORDER;
+		order = thp_order(page);
 	}
 	zidx = zone_idx(page_zone(page));
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch

