Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E12C3DA7A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiL1XXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiL1XXW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:23:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA57B13EB6
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 240B7CE132C
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53216C433EF;
        Wed, 28 Dec 2022 23:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672269797;
        bh=SXve0f+FhwLfyCd53lLlTvMZGPOBTDsl//7cpP4Wu7k=;
        h=Date:To:From:Subject:From;
        b=U1MkI7Lzg2cCckdxDL4Rb1KqBhQHlDkRTg+A+il7iCPKf/lxWg21rrdSx4kK6MH6l
         qLtnOCiPU9ELzbZNNAIvFOXBl53+qVvzA1EEdu+oRnyTi0P/aL9DVKYlN1M18eefCQ
         MBK7dc4/sgsiDMx7s6JuwpKmS/AaKI3xEexyC/EU=
Date:   Wed, 28 Dec 2022 15:23:16 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        mgorman@techsingularity.net, bharata@amd.com,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-separate-hugetlb-folios-migration.patch added to mm-unstable branch
Message-Id: <20221228232317.53216C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: separate hugetlb folios migration
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-separate-hugetlb-folios-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-separate-hugetlb-folios-migration.patch

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
Subject: migrate_pages: separate hugetlb folios migration
Date: Tue, 27 Dec 2022 08:28:53 +0800

This is a preparation patch to batch the folio unmapping and moving for
the non-hugetlb folios.  Based on that we can batch the TLB shootdown
during the folio migration and make it possible to use some hardware
accelerator for the folio copying.

In this patch the hugetlb folios and non-hugetlb folios migration is
separated in migrate_pages() to make it easy to change the non-hugetlb
folios migration implementation.

Link: https://lkml.kernel.org/r/20221227002859.27740-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: haoxin <xhao@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-separate-hugetlb-folios-migration
+++ a/mm/migrate.c
@@ -1421,6 +1421,87 @@ struct migrate_pages_stats {
 	int nr_thp_split;
 };
 
+static int migrate_hugetlbs(struct list_head *from, new_page_t get_new_page,
+			    free_page_t put_new_page, unsigned long private,
+			    enum migrate_mode mode, int reason,
+			    struct migrate_pages_stats *stats,
+			    struct list_head *ret_folios)
+{
+	int retry = 1;
+	int nr_failed = 0;
+	int nr_retry_pages = 0;
+	int pass = 0;
+	struct folio *folio, *folio2;
+	int rc = 0, nr_pages;
+
+	for (pass = 0; pass < 10 && retry; pass++) {
+		retry = 0;
+		nr_retry_pages = 0;
+
+		list_for_each_entry_safe(folio, folio2, from, lru) {
+			if (!folio_test_hugetlb(folio))
+				continue;
+
+			nr_pages = folio_nr_pages(folio);
+
+			cond_resched();
+
+			rc = unmap_and_move_huge_page(get_new_page,
+						      put_new_page, private,
+						      &folio->page, pass > 2, mode,
+						      reason, ret_folios);
+			/*
+			 * The rules are:
+			 *	Success: hugetlb folio will be put back
+			 *	-EAGAIN: stay on the from list
+			 *	-ENOMEM: stay on the from list
+			 *	-ENOSYS: stay on the from list
+			 *	Other errno: put on ret_folios list
+			 */
+			switch(rc) {
+			case -ENOSYS:
+				/* Hugetlb migration is unsupported */
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
+				break;
+			case -ENOMEM:
+				/*
+				 * When memory is low, don't bother to try to migrate
+				 * other folios, just exit.
+				 */
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				goto out;
+			case -EAGAIN:
+				retry++;
+				nr_retry_pages += nr_pages;
+				break;
+			case MIGRATEPAGE_SUCCESS:
+				stats->nr_succeeded += nr_pages;
+				break;
+			default:
+				/*
+				 * Permanent failure (-EBUSY, etc.):
+				 * unlike -EAGAIN case, the failed folio is
+				 * removed from migration folio list and not
+				 * retried in the next outer loop.
+				 */
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				break;
+			}
+		}
+	}
+out:
+	nr_failed += retry;
+	stats->nr_failed_pages += nr_retry_pages;
+	if (rc != -ENOMEM)
+		rc = nr_failed;
+
+	return rc;
+}
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -1454,7 +1535,7 @@ int migrate_pages(struct list_head *from
 	int retry = 1;
 	int large_retry = 1;
 	int thp_retry = 1;
-	int nr_failed = 0;
+	int nr_failed;
 	int nr_retry_pages = 0;
 	int nr_large_failed = 0;
 	int pass = 0;
@@ -1471,6 +1552,12 @@ int migrate_pages(struct list_head *from
 	trace_mm_migrate_pages_start(mode, reason);
 
 	memset(&stats, 0, sizeof(stats));
+	rc = migrate_hugetlbs(from, get_new_page, put_new_page, private, mode, reason,
+			      &stats, &ret_folios);
+	if (rc < 0)
+		goto out;
+	nr_failed = rc;
+
 split_folio_migration:
 	for (pass = 0; pass < 10 && (retry || large_retry); pass++) {
 		retry = 0;
@@ -1479,30 +1566,28 @@ split_folio_migration:
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
+			if (folio_test_hugetlb(folio)) {
+				list_move_tail(&folio->lru, &ret_folios);
+				continue;
+			}
+
 			/*
 			 * Large folio statistics is based on the source large
 			 * folio. Capture required information that might get
 			 * lost during migration.
 			 */
-			is_large = folio_test_large(folio) && !folio_test_hugetlb(folio);
+			is_large = folio_test_large(folio);
 			is_thp = is_large && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
+
 			cond_resched();
 
-			if (folio_test_hugetlb(folio))
-				rc = unmap_and_move_huge_page(get_new_page,
-						put_new_page, private,
-						&folio->page, pass > 2, mode,
-						reason,
-						&ret_folios);
-			else
-				rc = unmap_and_move(get_new_page, put_new_page,
-						private, folio, pass > 2, mode,
-						reason, &ret_folios);
+			rc = unmap_and_move(get_new_page, put_new_page,
+					    private, folio, pass > 2, mode,
+					    reason, &ret_folios);
 			/*
 			 * The rules are:
-			 *	Success: non hugetlb folio will be freed, hugetlb
-			 *		 folio will be put back
+			 *	Success: folio will be freed
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	-ENOSYS: stay on the from list
@@ -1529,7 +1614,6 @@ split_folio_migration:
 						stats.nr_thp_split += is_thp;
 						break;
 					}
-				/* Hugetlb migration is unsupported */
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch
migrate_pages-separate-hugetlb-folios-migration.patch
migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch
migrate_pages-batch-_unmap-and-_move.patch
migrate_pages-move-migrate_folio_done-and-migrate_folio_unmap.patch
migrate_pages-share-more-code-between-_unmap-and-_move.patch
migrate_pages-batch-flushing-tlb.patch

