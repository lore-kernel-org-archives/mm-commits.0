Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6AAE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244453AbjJDUWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244847AbjJDUWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0410F2
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBDEC433C8;
        Wed,  4 Oct 2023 20:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450866;
        bh=KNKdEh4lSA1XSiOKYDgLIEEfd13M7YC2XrxHkLWSpmc=;
        h=Date:To:From:Subject:From;
        b=KZiAQUh9+qySeh/W4bdx1FOqX2iS8JrzdLsBxxu5gYtpjJK+Xz93ByU0PEyhDq32k
         UzY6vis9ifnp+DqqJlgjTllrGM//hIlnlDDN0dsV6QD3pQZUvvkZFlNCIUdD4ymBdh
         Xj4G9tO/LxKVEj5rHI2crqALsPrm+uO5XO8iT5HM=
Date:   Wed, 04 Oct 2023 13:21:04 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch removed from -mm tree
Message-Id: <20231004202106.6BBDEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: convert numamigrate_isolate_page() to numamigrate_isolate_folio()
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-numamigrate_isolate_page-to-numamigrate_isolate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2481,10 +2481,9 @@ static struct folio *alloc_misplaced_dst
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
@@ -2496,22 +2495,23 @@ static int numamigrate_isolate_page(pg_d
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
 
@@ -2545,7 +2545,7 @@ int migrate_misplaced_page(struct page *
 	if (page_is_file_lru(page) && PageDirty(page))
 		goto out;
 
-	isolated = numamigrate_isolate_page(pgdat, page);
+	isolated = numamigrate_isolate_folio(pgdat, page_folio(page));
 	if (!isolated)
 		goto out;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-add-vm_normal_folio_pmd.patch
mm-huge_memory-use-a-folio-in-do_huge_pmd_numa_page.patch
mm-memory-use-a-folio-in-do_numa_page.patch
mm-memory-make-numa_migrate_prep-to-take-a-folio.patch
mm-mempolicy-make-mpol_misplaced-to-take-a-folio.patch
sched-numa-mm-make-numa-migrate-functions-to-take-a-folio.patch

