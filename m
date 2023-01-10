Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7206BC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbjAJXys (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbjAJXy1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:54:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1402755663
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C80FDB81A20
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F77EC433D2;
        Tue, 10 Jan 2023 23:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673394863;
        bh=2SyKF0ZAKwPYcKImPC/09CNV6V5LKBeXKqLhxEfBO+w=;
        h=Date:To:From:Subject:From;
        b=yvnELNO9pNb3d3mCMB5iwwjkuVwg3FNQL0V5SIyFo8U8EbMRnvMZKQTJT9anuE1sY
         vbG8qISOiHfZPCyZqitMWv319ybg7Ao0XioJ5wuB+FbisTGQ3h1ZxnDHAp8Zs7IB9e
         MmfJhrpwr0dxroZU00V9Zk1vMddj7b1imyBPBxls=
Date:   Tue, 10 Jan 2023 15:54:22 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        bharata@amd.com, baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch added to mm-unstable branch
Message-Id: <20230110235423.6F77EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: move THP/hugetlb migration support check to simplify code
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch

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
Subject: migrate_pages: move THP/hugetlb migration support check to simplify code
Date: Tue, 10 Jan 2023 15:53:27 +0800

This is a code cleanup patch, no functionality change is expected.  After
the change, the line number reduces especially in the long
migrate_pages_batch().

Link: https://lkml.kernel.org/r/20230110075327.590514-10-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: haoxin <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   83 +++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

--- a/mm/migrate.c~migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code
+++ a/mm/migrate.c
@@ -1116,9 +1116,6 @@ static int migrate_folio_unmap(new_page_
 	bool locked = false;
 	bool dst_locked = false;
 
-	if (!thp_migration_supported() && folio_test_transhuge(src))
-		return -ENOSYS;
-
 	if (folio_ref_count(src) == 1) {
 		/* Folio was freed from under us. So we are done. */
 		folio_clear_active(src);
@@ -1368,16 +1365,6 @@ static int unmap_and_move_huge_page(new_
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 
-	/*
-	 * Migratability of hugepages depends on architectures and their size.
-	 * This check is necessary because some callers of hugepage migration
-	 * like soft offline and memory hotremove don't walk through page
-	 * tables or check whether the hugepage is pmd-based or not before
-	 * kicking migration.
-	 */
-	if (!hugepage_migration_supported(page_hstate(hpage)))
-		return -ENOSYS;
-
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
 		putback_active_hugepage(hpage);
@@ -1544,6 +1531,20 @@ static int migrate_hugetlbs(struct list_
 
 			cond_resched();
 
+			/*
+			 * Migratability of hugepages depends on architectures and
+			 * their size.  This check is necessary because some callers
+			 * of hugepage migration like soft offline and memory
+			 * hotremove don't walk through page tables or check whether
+			 * the hugepage is pmd-based or not before kicking migration.
+			 */
+			if (!hugepage_migration_supported(folio_hstate(folio))) {
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
+				continue;
+			}
+
 			rc = unmap_and_move_huge_page(get_new_page,
 						      put_new_page, private,
 						      &folio->page, pass > 2, mode,
@@ -1553,16 +1554,9 @@ static int migrate_hugetlbs(struct list_
 			 *	Success: hugetlb folio will be put back
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
-			 *	-ENOSYS: stay on the from list
 			 *	Other errno: put on ret_folios list
 			 */
 			switch(rc) {
-			case -ENOSYS:
-				/* Hugetlb migration is unsupported */
-				nr_failed++;
-				stats->nr_failed_pages += nr_pages;
-				list_move_tail(&folio->lru, ret_folios);
-				break;
 			case -ENOMEM:
 				/*
 				 * When memory is low, don't bother to try to migrate
@@ -1648,6 +1642,28 @@ retry:
 
 			cond_resched();
 
+			/*
+			 * Large folio migration might be unsupported or
+			 * the allocation might be failed so we should retry
+			 * on the same folio with the large folio split
+			 * to normal folios.
+			 *
+			 * Split folios are put in split_folios, and
+			 * we will migrate them after the rest of the
+			 * list is processed.
+			 */
+			if (!thp_migration_supported() && is_thp) {
+				nr_large_failed++;
+				stats->nr_thp_failed++;
+				if (!try_split_folio(folio, &split_folios)) {
+					stats->nr_thp_split++;
+					continue;
+				}
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
+				continue;
+			}
+
 			rc = migrate_folio_unmap(get_new_page, put_new_page, private,
 						 folio, &dst, pass > 2, force_lock,
 						 mode, reason, ret_folios);
@@ -1659,36 +1675,9 @@ retry:
 			 *	-EAGAIN: stay on the from list
 			 *	-EDEADLOCK: stay on the from list
 			 *	-ENOMEM: stay on the from list
-			 *	-ENOSYS: stay on the from list
 			 *	Other errno: put on ret_folios list
 			 */
 			switch(rc) {
-			/*
-			 * Large folio migration might be unsupported or
-			 * the allocation could've failed so we should retry
-			 * on the same folio with the large folio split
-			 * to normal folios.
-			 *
-			 * Split folios are put in split_folios, and
-			 * we will migrate them after the rest of the
-			 * list is processed.
-			 */
-			case -ENOSYS:
-				/* Large folio migration is unsupported */
-				if (is_large) {
-					nr_large_failed++;
-					stats->nr_thp_failed += is_thp;
-					if (!try_split_folio(folio, &split_folios)) {
-						stats->nr_thp_split += is_thp;
-						break;
-					}
-				} else if (!no_split_folio_counting) {
-					nr_failed++;
-				}
-
-				stats->nr_failed_pages += nr_pages;
-				list_move_tail(&folio->lru, ret_folios);
-				break;
 			case -ENOMEM:
 				/*
 				 * When memory is low, don't bother to try to migrate
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

