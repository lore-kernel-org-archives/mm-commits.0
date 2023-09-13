Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2C6EE020B
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjIMUEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjIMUEj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:04:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0254719BF
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:04:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF0BC433C7;
        Wed, 13 Sep 2023 20:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694635475;
        bh=UiCS7O7jQx+HsF8fGRHxth+txaAw7UgtE5YPIh3xN2Q=;
        h=Date:To:From:Subject:From;
        b=mD4i0mkdw2MyKpB58Qvsg1Il5Q+2iemMy1zmMMdqkdfTEwoD1+yVZAR6Ubk2d+7vX
         TbdKyRSkTzozsWJWS5Dsrw8D+3H2BIATQWKpiWKnOWD6ajzkSUbBUK1S4zqcAywq1Q
         lNLCIXpk+CrLKbvH+Xsxf2YPval45f1oi0YO7gMI=
Date:   Wed, 13 Sep 2023 13:04:34 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, mike.kravetz@oracle.com, hughd@google.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch added to mm-unstable branch
Message-Id: <20230913200435.8EF0BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: convert migrate_misplaced_page() to migrate_misplaced_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio.patch

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
Subject: mm: migrate: convert migrate_misplaced_page() to migrate_misplaced_folio()
Date: Wed, 13 Sep 2023 17:51:27 +0800

At present, numa balance only support base page and PMD-mapped THP, but we
will expand to support to migrate large folio/pte-mapped THP in the
future, it is better to make migrate_misplaced_page() to take a folio
instead of a page, and rename it to migrate_misplaced_folio(), it is a
preparation, also this remove several compound_head() calls.

Link: https://lkml.kernel.org/r/20230913095131.2426871-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 +--
 mm/huge_memory.c        |    2 -
 mm/memory.c             |    2 -
 mm/migrate.c            |   39 ++++++++++++++++++++------------------
 4 files changed, 25 insertions(+), 22 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio
+++ a/include/linux/migrate.h
@@ -142,10 +142,10 @@ const struct movable_operations *page_mo
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 			   int node);
 #else
-static inline int migrate_misplaced_page(struct page *page,
+static inline int migrate_misplaced_folio(struct folio *folio,
 					 struct vm_area_struct *vma, int node)
 {
 	return -EAGAIN; /* can't migrate now */
--- a/mm/huge_memory.c~mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio
+++ a/mm/huge_memory.c
@@ -1567,7 +1567,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	migrated = migrate_misplaced_page(page, vma, target_nid);
+	migrated = migrate_misplaced_folio(page_folio(page), vma, target_nid);
 	if (migrated) {
 		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
--- a/mm/memory.c~mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio
+++ a/mm/memory.c
@@ -4815,7 +4815,7 @@ static vm_fault_t do_numa_page(struct vm
 	writable = false;
 
 	/* Migrate to the requested node */
-	if (migrate_misplaced_page(page, vma, target_nid)) {
+	if (migrate_misplaced_folio(page_folio(page), vma, target_nid)) {
 		page_nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else {
--- a/mm/migrate.c~mm-migrate-convert-migrate_misplaced_page-to-migrate_misplaced_folio
+++ a/mm/migrate.c
@@ -2513,55 +2513,58 @@ static int numamigrate_isolate_folio(pg_
 }
 
 /*
- * Attempt to migrate a misplaced page to the specified destination
+ * Attempt to migrate a misplaced folio to the specified destination
  * node. Caller is expected to have an elevated reference count on
- * the page that will be dropped by this function before returning.
+ * the folio that will be dropped by this function before returning.
  */
-int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
-			   int node)
+int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
+			    int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated;
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
-	int nr_pages = thp_nr_pages(page);
+	int nr_pages = folio_nr_pages(folio);
 
 	/*
-	 * Don't migrate file pages that are mapped in multiple processes
+	 * Don't migrate file folios that are mapped in multiple processes
 	 * with execute permissions as they are probably shared libraries.
+	 * To check if the folio is shared, ideally we want to make sure
+	 * every page is mapped to the same process. Doing that is very
+	 * expensive, so check the estimated mapcount of the folio instead.
 	 */
-	if (page_mapcount(page) != 1 && page_is_file_lru(page) &&
+	if (folio_estimated_sharers(folio) != 1 && folio_is_file_lru(folio) &&
 	    (vma->vm_flags & VM_EXEC))
 		goto out;
 
 	/*
-	 * Also do not migrate dirty pages as not all filesystems can move
-	 * dirty pages in MIGRATE_ASYNC mode which is a waste of cycles.
+	 * Also do not migrate dirty folios as not all filesystems can move
+	 * dirty folios in MIGRATE_ASYNC mode which is a waste of cycles.
 	 */
-	if (page_is_file_lru(page) && PageDirty(page))
+	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
 		goto out;
 
-	isolated = numamigrate_isolate_folio(pgdat, page_folio(page));
+	isolated = numamigrate_isolate_folio(pgdat, folio);
 	if (!isolated)
 		goto out;
 
-	list_add(&page->lru, &migratepages);
+	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
 				     NULL, node, MIGRATE_ASYNC,
 				     MR_NUMA_MISPLACED, &nr_succeeded);
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
-			list_del(&page->lru);
-			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -nr_pages);
-			putback_lru_page(page);
+			list_del(&folio->lru);
+			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio), -nr_pages);
+			folio_putback_lru(folio);
 		}
 		isolated = 0;
 	}
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (!node_is_toptier(page_to_nid(page)) && node_is_toptier(node))
+		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
@@ -2569,7 +2572,7 @@ int migrate_misplaced_page(struct page *
 	return isolated;
 
 out:
-	put_page(page);
+	folio_put(folio);
 	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
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

