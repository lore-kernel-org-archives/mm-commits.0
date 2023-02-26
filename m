Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E4EC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 04:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBZE4U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 23:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBZE4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 23:56:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C6310A9A
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:56:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61CFFB80956
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 04:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B89BC433D2;
        Sun, 26 Feb 2023 04:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677387368;
        bh=oOBRyZ9fOFfLEPOYWPJRap2Vy6w80zKufiCH+ei6r+g=;
        h=Date:To:From:Subject:From;
        b=hIxWe9zoQTCMj0uxGIQbhaA3cEGg6iTSmEh+gWITRNt7Ade2z8Twylam6YA1gYBSh
         8rgusKlrttdD7Y5t2KFDgnLwe0pwMh6+qVVmDx1M7CubU01pLJXGsKHJzv0c8vPrOy
         u96/5uES45Ipli1+s9dN3NFq5wSC08wI40t4nl5A=
Date:   Sat, 25 Feb 2023 20:56:06 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, tj@kernel.org, shy828301@gmail.com,
        shr@devkernel.io, pengfei.xu@intel.com, mike.kravetz@oracle.com,
        hughd@google.com, hch@lst.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch added to mm-hotfixes-unstable branch
Message-Id: <20230226045608.1B89BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: move split folios processing out of migrate_pages_batch()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: migrate_pages: move split folios processing out of migrate_pages_batch()
Date: Fri, 24 Feb 2023 22:11:44 +0800

To simplify the code logic and reduce the line number.

Link: https://lkml.kernel.org/r/20230224141145.96814-3-ying.huang@intel.com
Fixes: 6f7d760e86fa ("migrate_pages: move THP/hugetlb migration support check to simplify code")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Xu, Pengfei" <pengfei.xu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Tejun Heo <tj@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch
+++ b/mm/migrate.c
@@ -1605,9 +1605,10 @@ static int migrate_hugetlbs(struct list_head *from, new_page_t get_new_page,
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
@@ -1617,19 +1618,12 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
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
 
-retry:
-	rc_saved = 0;
-	retry = 1;
-	for (pass = 0;
-	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
-	     pass++) {
+	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
 		retry = 0;
 		large_retry = 0;
 		thp_retry = 0;
@@ -1660,7 +1654,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 			if (!thp_migration_supported() && is_thp) {
 				nr_large_failed++;
 				stats->nr_thp_failed++;
-				if (!try_split_folio(folio, &split_folios)) {
+				if (!try_split_folio(folio, split_folios)) {
 					stats->nr_thp_split++;
 					continue;
 				}
@@ -1692,7 +1686,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 					stats->nr_thp_failed += is_thp;
 					/* Large folio NUMA faulting doesn't split to retry. */
 					if (!nosplit) {
-						int ret = try_split_folio(folio, &split_folios);
+						int ret = try_split_folio(folio, split_folios);
 
 						if (!ret) {
 							stats->nr_thp_split += is_thp;
@@ -1709,18 +1703,11 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
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
@@ -1733,7 +1720,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 				if (is_large) {
 					large_retry++;
 					thp_retry += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					retry++;
 				}
 				nr_retry_pages += nr_pages;
@@ -1756,7 +1743,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 				if (is_large) {
 					nr_large_failed++;
 					stats->nr_thp_failed += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					nr_failed++;
 				}
 
@@ -1774,9 +1761,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 	try_to_unmap_flush();
 
 	retry = 1;
-	for (pass = 0;
-	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
-	     pass++) {
+	for (pass = 0; pass < nr_pass && (retry || large_retry); pass++) {
 		retry = 0;
 		large_retry = 0;
 		thp_retry = 0;
@@ -1805,7 +1790,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 				if (is_large) {
 					large_retry++;
 					thp_retry += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					retry++;
 				}
 				nr_retry_pages += nr_pages;
@@ -1818,7 +1803,7 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 				if (is_large) {
 					nr_large_failed++;
 					stats->nr_thp_failed += is_thp;
-				} else if (!no_split_folio_counting) {
+				} else {
 					nr_failed++;
 				}
 
@@ -1855,27 +1840,6 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
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
 
@@ -1914,6 +1878,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
 	LIST_HEAD(ret_folios);
+	LIST_HEAD(split_folios);
 	struct migrate_pages_stats stats;
 
 	trace_mm_migrate_pages_start(mode, reason);
@@ -1947,12 +1912,23 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
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
+		 * is counted as 1 failure already.
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

migrate_pages-fix-deadlock-in-batched-migration.patch
migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch
migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch

