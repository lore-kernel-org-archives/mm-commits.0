Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1AFC74A4B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCHBFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCHBFi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 20:05:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9149FA4B1A
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 17:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48169B819F3
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 01:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFB4C433D2;
        Wed,  8 Mar 2023 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237534;
        bh=zyLD5T0q5YSPCS+n2ndmmhAUVDI7A4QuAfwgPmGV0p0=;
        h=Date:To:From:Subject:From;
        b=kO0FxnWc8WzCN8SJpXwOKiZdeaMO4AZKV5rwjN1JMM0e3OnSRy+wxUb80J9pEu+gt
         iuGQE3AS1RQ8E2LXRRqFnnmSTXeZB/3Li6b9A33PcbfVtkyBmVHTmzs5yP3ADDI4rE
         0TqJGkyoUvA/Xew2kI94W6NbgpMrxWYGqXSbeQxM=
Date:   Tue, 07 Mar 2023 17:05:33 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, tj@kernel.org, shy828301@gmail.com,
        shr@devkernel.io, pengfei.xu@intel.com, mike.kravetz@oracle.com,
        hughd@google.com, hch@lst.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch removed from -mm tree
Message-Id: <20230308010533.DBFB4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages: move split folios processing out of migrate_pages_batch()
has been removed from the -mm tree.  Its filename was
     migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: move split folios processing out of migrate_pages_batch()
Date: Fri, 3 Mar 2023 11:01:54 +0800

To simplify the code logic and reduce the line number.

Link: https://lkml.kernel.org/r/20230303030155.160983-3-ying.huang@intel.com
Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Xu, Pengfei" <pengfei.xu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Tejun Heo <tj@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch
+++ a/mm/migrate.c
@@ -1616,9 +1616,10 @@ static int migrate_hugetlbs(struct list_
 static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
 		enum migrate_mode mode, int reason, struct list_head *ret_folios,
-		struct migrate_pages_stats *stats)
+		struct list_head *split_folios, struct migrate_pages_stats *stats,
+		int nr_pass)
 {
-	int retry;
+	int retry = 1;
 	int large_retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
@@ -1628,21 +1629,15 @@ static int migrate_pages_batch(struct li
 	bool is_large = false;
 	bool is_thp = false;
 	struct folio *folio, *folio2, *dst = NULL, *dst2;
-	int rc, rc_saved, nr_pages;
-	LIST_HEAD(split_folios);
+	int rc, rc_saved = 0, nr_pages;
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
-	bool no_split_folio_counting = false;
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
-retry:
-	rc_saved = 0;
-	retry = 1;
-	for (pass = 0;
-	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
-	     pass++) {
+
+	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
 		retry = 0;
 		large_retry = 0;
 		thp_retry = 0;
@@ -1673,7 +1668,7 @@ retry:
 			if (!thp_migration_supported() && is_thp) {
 				nr_large_failed++;
 				stats->nr_thp_failed++;
-				if (!try_split_folio(folio, &split_folios)) {
+				if (!try_split_folio(folio, split_folios)) {
 					stats->nr_thp_split++;
 					continue;
 				}
@@ -1705,7 +1700,7 @@ retry:
 					stats->nr_thp_failed += is_thp;
 					/* Large folio NUMA faulting doesn't split to retry. */
 					if (!nosplit) {
-						int ret = try_split_folio(folio, &split_folios);
+						int ret = try_split_folio(folio, split_folios);
 
 						if (!ret) {
 							stats->nr_thp_split += is_thp;
@@ -1722,18 +1717,11 @@ retry:
 							break;
 						}
 					}
-				} else if (!no_split_folio_counting) {
+				} else {
 					nr_failed++;
 				}
 
 				stats->nr_failed_pages += nr_pages + nr_retry_pages;
-				/*
-				 * There might be some split folios of fail-to-migrate large
-				 * folios left in split_folios list. Move them to ret_folios
-				 * list so that they could be put back to the right list by
-				 * the caller otherwise the folio refcnt will be leaked.
-				 */
-				list_splice_init(&split_folios, ret_folios);
 				/* nr_failed isn't updated for not used */
 				nr_large_failed += large_retry;
 				stats->nr_thp_failed += thp_retry;
@@ -1746,7 +1734,7 @@ retry:
 				if (is_large) {
 					large_retry++;
 					thp_retry += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					retry++;
 				}
 				nr_retry_pages += nr_pages;
@@ -1769,7 +1757,7 @@ retry:
 				if (is_large) {
 					nr_large_failed++;
 					stats->nr_thp_failed += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					nr_failed++;
 				}
 
@@ -1787,9 +1775,7 @@ move:
 	try_to_unmap_flush();
 
 	retry = 1;
-	for (pass = 0;
-	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
-	     pass++) {
+	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
 		retry = 0;
 		large_retry = 0;
 		thp_retry = 0;
@@ -1818,7 +1804,7 @@ move:
 				if (is_large) {
 					large_retry++;
 					thp_retry += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					retry++;
 				}
 				nr_retry_pages += nr_pages;
@@ -1831,7 +1817,7 @@ move:
 				if (is_large) {
 					nr_large_failed++;
 					stats->nr_thp_failed += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					nr_failed++;
 				}
 
@@ -1868,27 +1854,6 @@ out:
 		dst2 = list_next_entry(dst, lru);
 	}
 
-	/*
-	 * Try to migrate split folios of fail-to-migrate large folios, no
-	 * nr_failed counting in this round, since all split folios of a
-	 * large folio is counted as 1 failure in the first round.
-	 */
-	if (rc >= 0 && !list_empty(&split_folios)) {
-		/*
-		 * Move non-migrated folios (after NR_MAX_MIGRATE_PAGES_RETRY
-		 * retries) to ret_folios to avoid migrating them again.
-		 */
-		list_splice_init(from, ret_folios);
-		list_splice_init(&split_folios, from);
-		/*
-		 * Force async mode to avoid to wait lock or bit when we have
-		 * locked more than one folios.
-		 */
-		mode = MIGRATE_ASYNC;
-		no_split_folio_counting = true;
-		goto retry;
-	}
-
 	return rc;
 }
 
@@ -1927,6 +1892,7 @@ int migrate_pages(struct list_head *from
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
 	LIST_HEAD(ret_folios);
+	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
 
 	trace_mm_migrate_pages_start(mode, reason);
@@ -1960,12 +1926,24 @@ again:
 	else
 		list_splice_init(from, &folios);
 	rc = migrate_pages_batch(&folios, get_new_page, put_new_page, private,
-				 mode, reason, &ret_folios, &stats);
+				 mode, reason, &ret_folios, &split_folios, &stats,
+				 NR_MAX_MIGRATE_PAGES_RETRY);
 	list_splice_tail_init(&folios, &ret_folios);
 	if (rc < 0) {
 		rc_gather = rc;
+		list_splice_tail(&split_folios, &ret_folios);
 		goto out;
 	}
+	if (!list_empty(&split_folios)) {
+		/*
+		 * Failure isn't counted since all split folios of a large folio
+		 * is counted as 1 failure already.  And, we only try to migrate
+		 * with minimal effort, force MIGRATE_ASYNC mode and retry once.
+		 */
+		migrate_pages_batch(&split_folios, get_new_page, put_new_page, private,
+				    MIGRATE_ASYNC, reason, &ret_folios, NULL, &stats, 1);
+		list_splice_tail_init(&split_folios, &ret_folios);
+	}
 	rc_gather += rc;
 	if (!list_empty(from))
 		goto again;
_

Patches currently in -mm which might be from ying.huang@intel.com are


