Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFDEEE0207
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjIMUEi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B223F1BC3
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F95C433C7;
        Wed, 13 Sep 2023 20:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635472;
        bh=Qy9Vf5mjsdR3xtpyWqPrRVRo4aaHNoEn5ih8Ma9NQWo=;
        h=Date:To:From:Subject:From;
        b=AyKoHTeuDT+mTrxCNtm/txEikkZ5bpaoLk/Nk1WohU/koNFYNnX06axBCKA3J0r7N
         SrJ/WShv8n329ftI3lL1yy5vTeoA2bdMpJ2wAzuzl8PXEKDWiZ9CuJkLn/xtDtVqoK
         YUwizLC+3xP2r8czPSQvEZNPQ950u5z1+78wR5B8=
Date:   Wed, 13 Sep 2023 13:04:31 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch added to mm-unstable branch
Message-Id: <20230913200432.48F95C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: convert numamigrate_isolate_page() to numamigrate_isolate_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: convert numamigrate_isolate_page() to numamigrate_isolate_folio()
Date: Wed, 13 Sep 2023 17:51:26 +0800

Rename numamigrate_isolate_page() to numamigrate_isolate_folio(), then
make it takes a folio and use folio API to save compound_head() calls.

Link: https://lkml.kernel.org/r/20230913095131.2426871-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio
+++ a/mm/migrate.c
@@ -2478,10 +2478,9 @@ static struct folio *alloc_misplaced_dst
 	return __folio_alloc_node(gfp, order, nid);
 }
 
-static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
+static int numamigrate_isolate_folio(pg_data_t *pgdat, struct folio *folio)
 {
-	int nr_pages = thp_nr_pages(page);
-	int order = compound_order(page);
+	int nr_pages = folio_nr_pages(folio);
 
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
@@ -2493,22 +2492,23 @@ static int numamigrate_isolate_page(pg_d
 			if (managed_zone(pgdat->node_zones + z))
 				break;
 		}
-		wakeup_kswapd(pgdat->node_zones + z, 0, order, ZONE_MOVABLE);
+		wakeup_kswapd(pgdat->node_zones + z, 0,
+			      folio_order(folio), ZONE_MOVABLE);
 		return 0;
 	}
 
-	if (!isolate_lru_page(page))
+	if (!folio_isolate_lru(folio))
 		return 0;
 
-	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_is_file_lru(page),
+	node_stat_mod_folio(folio, NR_ISOLATED_ANON + folio_is_file_lru(folio),
 			    nr_pages);
 
 	/*
-	 * Isolating the page has taken another reference, so the
-	 * caller's reference can be safely dropped without the page
+	 * Isolating the folio has taken another reference, so the
+	 * caller's reference can be safely dropped without the folio
 	 * disappearing underneath us during migration.
 	 */
-	put_page(page);
+	folio_put(folio);
 	return 1;
 }
 
@@ -2542,7 +2542,7 @@ int migrate_misplaced_page(struct page *
 	if (page_is_file_lru(page) && PageDirty(page))
 		goto out;
 
-	isolated = numamigrate_isolate_page(pgdat, page);
+	isolated = numamigrate_isolate_folio(pgdat, page_folio(page));
 	if (!isolated)
 		goto out;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate-remove-pagetranshuge-check-in-numamigrate_isolate_page.patch
mm-migrate-remove-thp-mapcount-check-in-numamigrate_isolate_page.patch
mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch
mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch
mm-migrate-use-__folio_test_movable.patch
mm-migrate-use-a-folio-in-add_page_for_migration.patch
mm-migrate-remove-pagehead-check-for-hugetlb-in-add_page_for_migration.patch
mm-migrate-remove-isolated-variable-in-add_page_for_migration.patch

