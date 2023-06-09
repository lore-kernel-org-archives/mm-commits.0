Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE14DC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 22:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjFIWLW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 18:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjFIWLV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 18:11:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE6830F8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 15:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 252C465C98
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 22:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70782C433D2;
        Fri,  9 Jun 2023 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686348679;
        bh=IwsRJClajQPDoySJM7vtwJmge6jwXB0zN6xi/8Z1IMU=;
        h=Date:To:From:Subject:From;
        b=1vB5QOQ7aWENTXbWTRdbedkLU8GfvF52GpLvDeCcfJKpz+02KcuJdtp76m1VYCA1Y
         zOuIcU2QX5LFcjJbzca7bgRq60UJ9FkJbOjly2pJjxiuXegCMSgeno6o+r1WVsDx7w
         jqm5avmSZrVOTsndeBq3WSDpiZrVsMxW8zGeg8bA=
Date:   Fri, 09 Jun 2023 15:11:18 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, steven.sistare@oracle.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, khalid.aziz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-skip-all-non-migratable-pages-during-scan.patch removed from -mm tree
Message-Id: <20230609221119.70782C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, compaction: skip all non-migratable pages during scan
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-all-non-migratable-pages-during-scan.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: mm, compaction: skip all non-migratable pages during scan
Date: Thu, 25 May 2023 13:15:07 -0600

Pages pinned in memory through extra refcounts can not be migrated. 
Currently as isolate_migratepages_block() scans pages for compaction, it
skips any pinned anonymous pages.  All non-migratable pages should be
skipped and not just the anonymous pinned pages.  This patch adds a check
for extra refcounts on a page to determine if the page can be migrated. 
This was seen as a real issue on a customer workload where a large number
of pages were pinned by vfio on the host and any attempts to allocate
hugepages resulted in significant amount of cpu time spent in either
direct compaction or in kcompactd scanning vfio pinned pages over and over
again that can not be migrated.  These are the changes in relevant stats
with this patch for a test run of this scenario:

				Before			After
compact_migrate_scanned		329,798,858		370,984,387
compact_free_scanned		40,478,406		25,843,262
compact_isolated		135,470,452		777,235
pgmigrate_success		544,255			507,325
pgmigrate_fail			134,616,282		47
kcompactd CPU time		5:12.81			0:12.28

Before the patch, large number of pages were isolated but most of
them failed to migrate.

Link: https://lkml.kernel.org/r/20230525191507.160076-1-khalid.aziz@oracle.com
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Suggested-by: Steve Sistare <steven.sistare@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   16 +++++++++++++
 mm/compaction.c         |   44 ++++++++++++++++++++++++++++++++++----
 mm/migrate.c            |   14 ------------
 3 files changed, 56 insertions(+), 18 deletions(-)

--- a/include/linux/migrate.h~mm-compaction-skip-all-non-migratable-pages-during-scan
+++ a/include/linux/migrate.h
@@ -141,6 +141,22 @@ const struct movable_operations *page_mo
 		((unsigned long)page->mapping - PAGE_MAPPING_MOVABLE);
 }
 
+static inline
+int folio_expected_refs(struct address_space *mapping,
+		struct folio *folio)
+{
+	int refs = 1;
+
+	if (!mapping)
+		return refs;
+
+	refs += folio_nr_pages(folio);
+	if (folio_test_private(folio))
+		refs++;
+
+	return refs;
+}
+
 #ifdef CONFIG_NUMA_BALANCING
 int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 			   int node);
--- a/mm/compaction.c~mm-compaction-skip-all-non-migratable-pages-during-scan
+++ a/mm/compaction.c
@@ -772,6 +772,42 @@ static bool too_many_isolated(struct com
 	return too_many;
 }
 
+/*
+ * Check if this base page should be skipped from isolation because
+ * it has extra refcounts that will prevent it from being migrated.
+ * This code is inspired by similar code in migrate_vma_check_page(),
+ * can_split_folio() and folio_migrate_mapping()
+ */
+static inline bool page_has_extra_refs(struct page *page,
+					struct address_space *mapping)
+{
+	unsigned long extra_refs;
+	struct folio *folio;
+
+	/*
+	 * Skip this check for pages in ZONE_MOVABLE or MIGRATE_CMA
+	 * pages that can not be long term pinned
+	 */
+	if (is_zone_movable_page(page) || is_migrate_cma_page(page))
+		return false;
+
+	folio = page_folio(page);
+
+	/*
+	 * caller holds a ref already from get_page_unless_zero()
+	 * which is accounted for in folio_expected_refs()
+	 */
+	extra_refs = folio_expected_refs(mapping, folio);
+
+	/*
+	 * This is an admittedly racy check but good enough to determine
+	 * if a page is pinned and can not be migrated
+	 */
+	if ((folio_ref_count(folio) - extra_refs) > folio_mapcount(folio))
+		return true;
+	return false;
+}
+
 /**
  * isolate_migratepages_block() - isolate all migrate-able pages within
  *				  a single pageblock
@@ -1010,12 +1046,12 @@ isolate_migratepages_block(struct compac
 			goto isolate_fail;
 
 		/*
-		 * Migration will fail if an anonymous page is pinned in memory,
-		 * so avoid taking lru_lock and isolating it unnecessarily in an
-		 * admittedly racy check.
+		 * Migration will fail if a page has extra refcounts
+		 * from long term pinning preventing it from migrating,
+		 * so avoid taking lru_lock and isolating it unnecessarily.
 		 */
 		mapping = page_mapping(page);
-		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+		if (!cc->alloc_contig && page_has_extra_refs(page, mapping))
 			goto isolate_fail_put;
 
 		/*
--- a/mm/migrate.c~mm-compaction-skip-all-non-migratable-pages-during-scan
+++ a/mm/migrate.c
@@ -379,20 +379,6 @@ unlock:
 }
 #endif
 
-static int folio_expected_refs(struct address_space *mapping,
-		struct folio *folio)
-{
-	int refs = 1;
-	if (!mapping)
-		return refs;
-
-	refs += folio_nr_pages(folio);
-	if (folio_test_private(folio))
-		refs++;
-
-	return refs;
-}
-
 /*
  * Replace the page in the mapping.
  *
_

Patches currently in -mm which might be from khalid.aziz@oracle.com are


