Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597DFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiDHULB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiDHULB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:11:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CBA1E522F
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 13:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF33161E34
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FD9C385A3;
        Fri,  8 Apr 2022 20:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448533;
        bh=skQ4+SSthFwNXEUSPxFB30AaiHqqZjOmrlj9xVcgnkk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=BKrsdFk73utuvqjSyEUscWJAyAaZ5FM/xIs8jmNtD8FsiwQxY6gFzuGZvgsr1DxcC
         9D4/wu+TmfmcwBoNk5ARjFrVHJf1DDvNUAIxC7VPpTCwsB4V6SRYqLKxMbGF1cApeG
         EIZjnkZGrVB3R1n9LRSN6TGJFmfp68aizE+aJEW8=
Date:   Fri, 08 Apr 2022 13:08:52 -0700
To:     willy@infradead.org, naoya.horiguchi@linux.dev, mhocko@kernel.org,
        ziy@nvidia.com, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 1/9] mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.
Message-Id: <20220408200853.40FD9C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
