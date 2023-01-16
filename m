Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE71C46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjAPVgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjAPVgc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:36:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A0F2BED5
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B2561118
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE731C433D2;
        Mon, 16 Jan 2023 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673904990;
        bh=+j4ENVtssbPpXecpnyznW/wgvl/kWjyjBNO2UO6MWYI=;
        h=Date:To:From:Subject:From;
        b=ITxzLLSLe94APslWccKQVNetMM2tpajgAmY+qQHhSWL2nUWGJcwFDKuw4wlBxoRo3
         9YP5B9GNClgmfmy3m3qyCqVCSBpFTYS31Fmj+8u2RYXvSXIses6zPmjXyUakL+Cw3z
         AccKqjx1R877qn56TJ3mL+ZLQwvnYdDTK33NhY8w=
Date:   Mon, 16 Jan 2023 13:36:29 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        minchan@kernel.org, bharata@amd.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch added to mm-unstable branch
Message-Id: <20230116213629.EE731C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: organize stats with struct migrate_pages_stats
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: organize stats with struct migrate_pages_stats
Date: Mon, 16 Jan 2023 14:30:49 +0800

Patch series "migrate_pages(): batch TLB flushing", v3.

Now, migrate_pages() migrate folios one by one, like the fake code as
follows,

  for each folio
    unmap
    flush TLB
    copy
    restore map

If multiple folios are passed to migrate_pages(), there are
opportunities to batch the TLB flushing and copying.  That is, we can
change the code to something as follows,

  for each folio
    unmap
  for each folio
    flush TLB
  for each folio
    copy
  for each folio
    restore map

The total number of TLB flushing IPI can be reduced considerably.  And
we may use some hardware accelerator such as DSA to accelerate the
folio copying.

So in this patch, we refactor the migrate_pages() implementation and
implement the TLB flushing batching.  Base on this, hardware
accelerated folio copying can be implemented.

If too many folios are passed to migrate_pages(), in the naive batched
implementation, we may unmap too many folios at the same time.  The
possibility for a task to wait for the migrated folios to be mapped
again increases.  So the latency may be hurt.  To deal with this
issue, the max number of folios be unmapped in batch is restricted to
no more than HPAGE_PMD_NR in the unit of page.  That is, the influence
is at the same level of THP migration.

We use the following test to measure the performance impact of the
patchset,

On a 2-socket Intel server,

 - Run pmbench memory accessing benchmark

 - Run `migratepages` to migrate pages of pmbench between node 0 and
   node 1 back and forth.

With the patch, the TLB flushing IPI reduces 99.1% during the test and
the number of pages migrated successfully per second increases 291.7%.


This patch (of 9):

Define struct migrate_pages_stats to organize the various statistics in
migrate_pages().  This makes it easier to collect and consume the
statistics in multiple functions.  This will be needed in the following
patches in the series.

Link: https://lkml.kernel.org/r/20230116063057.653862-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20230116063057.653862-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: haoxin <xhao@linux.alibaba.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-organize-stats-with-struct-migrate_pages_stats
+++ a/mm/migrate.c
@@ -1413,6 +1413,16 @@ static inline int try_split_folio(struct
 	return rc;
 }
 
+struct migrate_pages_stats {
+	int nr_succeeded;	/* Normal and large folios migrated successfully, in
+				   units of base pages */
+	int nr_failed_pages;	/* Normal and large folios failed to be migrated, in
+				   units of base pages.  Untried folios aren't counted */
+	int nr_thp_succeeded;	/* THP migrated successfully */
+	int nr_thp_failed;	/* THP failed to be migrated */
+	int nr_thp_split;	/* THP split before migrating */
+};
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -1447,13 +1457,8 @@ int migrate_pages(struct list_head *from
 	int large_retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
-	int nr_failed_pages = 0;
 	int nr_retry_pages = 0;
-	int nr_succeeded = 0;
-	int nr_thp_succeeded = 0;
 	int nr_large_failed = 0;
-	int nr_thp_failed = 0;
-	int nr_thp_split = 0;
 	int pass = 0;
 	bool is_large = false;
 	bool is_thp = false;
@@ -1463,9 +1468,11 @@ int migrate_pages(struct list_head *from
 	LIST_HEAD(split_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 	bool no_split_folio_counting = false;
+	struct migrate_pages_stats stats;
 
 	trace_mm_migrate_pages_start(mode, reason);
 
+	memset(&stats, 0, sizeof(stats));
 split_folio_migration:
 	for (pass = 0; pass < 10 && (retry || large_retry); pass++) {
 		retry = 0;
@@ -1519,9 +1526,9 @@ split_folio_migration:
 				/* Large folio migration is unsupported */
 				if (is_large) {
 					nr_large_failed++;
-					nr_thp_failed += is_thp;
+					stats.nr_thp_failed += is_thp;
 					if (!try_split_folio(folio, &split_folios)) {
-						nr_thp_split += is_thp;
+						stats.nr_thp_split += is_thp;
 						break;
 					}
 				/* Hugetlb migration is unsupported */
@@ -1529,7 +1536,7 @@ split_folio_migration:
 					nr_failed++;
 				}
 
-				nr_failed_pages += nr_pages;
+				stats.nr_failed_pages += nr_pages;
 				list_move_tail(&folio->lru, &ret_folios);
 				break;
 			case -ENOMEM:
@@ -1539,13 +1546,13 @@ split_folio_migration:
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					nr_thp_failed += is_thp;
+					stats.nr_thp_failed += is_thp;
 					/* Large folio NUMA faulting doesn't split to retry. */
 					if (!nosplit) {
 						int ret = try_split_folio(folio, &split_folios);
 
 						if (!ret) {
-							nr_thp_split += is_thp;
+							stats.nr_thp_split += is_thp;
 							break;
 						} else if (reason == MR_LONGTERM_PIN &&
 							   ret == -EAGAIN) {
@@ -1563,7 +1570,7 @@ split_folio_migration:
 					nr_failed++;
 				}
 
-				nr_failed_pages += nr_pages + nr_retry_pages;
+				stats.nr_failed_pages += nr_pages + nr_retry_pages;
 				/*
 				 * There might be some split folios of fail-to-migrate large
 				 * folios left in split_folios list. Move them back to migration
@@ -1573,7 +1580,7 @@ split_folio_migration:
 				list_splice_init(&split_folios, from);
 				/* nr_failed isn't updated for not used */
 				nr_large_failed += large_retry;
-				nr_thp_failed += thp_retry;
+				stats.nr_thp_failed += thp_retry;
 				goto out;
 			case -EAGAIN:
 				if (is_large) {
@@ -1585,8 +1592,8 @@ split_folio_migration:
 				nr_retry_pages += nr_pages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
-				nr_succeeded += nr_pages;
-				nr_thp_succeeded += is_thp;
+				stats.nr_succeeded += nr_pages;
+				stats.nr_thp_succeeded += is_thp;
 				break;
 			default:
 				/*
@@ -1597,20 +1604,20 @@ split_folio_migration:
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					nr_thp_failed += is_thp;
+					stats.nr_thp_failed += is_thp;
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
 
-				nr_failed_pages += nr_pages;
+				stats.nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
 	nr_failed += retry;
 	nr_large_failed += large_retry;
-	nr_thp_failed += thp_retry;
-	nr_failed_pages += nr_retry_pages;
+	stats.nr_thp_failed += thp_retry;
+	stats.nr_failed_pages += nr_retry_pages;
 	/*
 	 * Try to migrate split folios of fail-to-migrate large folios, no
 	 * nr_failed counting in this round, since all split folios of a
@@ -1643,16 +1650,17 @@ out:
 	if (list_empty(from))
 		rc = 0;
 
-	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
-	count_vm_events(PGMIGRATE_FAIL, nr_failed_pages);
-	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
-	count_vm_events(THP_MIGRATION_FAIL, nr_thp_failed);
-	count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
-	trace_mm_migrate_pages(nr_succeeded, nr_failed_pages, nr_thp_succeeded,
-			       nr_thp_failed, nr_thp_split, mode, reason);
+	count_vm_events(PGMIGRATE_SUCCESS, stats.nr_succeeded);
+	count_vm_events(PGMIGRATE_FAIL, stats.nr_failed_pages);
+	count_vm_events(THP_MIGRATION_SUCCESS, stats.nr_thp_succeeded);
+	count_vm_events(THP_MIGRATION_FAIL, stats.nr_thp_failed);
+	count_vm_events(THP_MIGRATION_SPLIT, stats.nr_thp_split);
+	trace_mm_migrate_pages(stats.nr_succeeded, stats.nr_failed_pages,
+			       stats.nr_thp_succeeded, stats.nr_thp_failed,
+			       stats.nr_thp_split, mode, reason);
 
 	if (ret_succeeded)
-		*ret_succeeded = nr_succeeded;
+		*ret_succeeded = stats.nr_succeeded;
 
 	return rc;
 }
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch
migrate_pages-separate-hugetlb-folios-migration.patch
migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch
migrate_pages-batch-_unmap-and-_move.patch
migrate_pages-move-migrate_folio_unmap.patch
migrate_pages-share-more-code-between-_unmap-and-_move.patch
migrate_pages-batch-flushing-tlb.patch
migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch

