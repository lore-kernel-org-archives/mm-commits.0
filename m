Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4267EC6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 04:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBZE4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 23:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBZE4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 23:56:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038CE113D3
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E46660BF9
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 04:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5870C433EF;
        Sun, 26 Feb 2023 04:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677387370;
        bh=HErCJN0Z+IvbHytjrVe5cx2FCVCf+wTDqAGnzF9UYUo=;
        h=Date:To:From:Subject:From;
        b=hOMXzM/+K0pWIgKC3aDyfKvSa5ckeqBsrkaRgTaXeVFvu/sw3DyDfInAXHLZNaINQ
         SsgPhMo6O45CYGS2pf60deCcVhtzs37kBEDDtY2UbhIA0TW39qhzKJCzAIA2B/DMFe
         KQwwPcien+vXGtEJWQd3HFAqJAreGfmj8WHJsnBo=
Date:   Sat, 25 Feb 2023 20:56:09 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, tj@kernel.org, shy828301@gmail.com,
        shr@devkernel.io, pengfei.xu@intel.com, mike.kravetz@oracle.com,
        hughd@google.com, hch@lst.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch added to mm-hotfixes-unstable branch
Message-Id: <20230226045609.E5870C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: try migrate in batch asynchronously firstly
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch

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
Subject: migrate_pages: try migrate in batch asynchronously firstly
Date: Fri, 24 Feb 2023 22:11:45 +0800

When we have locked more than one folios, we cannot wait the lock or bit
(e.g., page lock, buffer head lock, writeback bit) synchronously. 
Otherwise deadlock may be triggered.  This make it hard to batch the
synchronous migration directly.

This patch re-enables batching synchronous migration via trying to migrate
in batch asynchronously firstly.  And any folios that are failed to be
migrated asynchronously will be migrated synchronously one by one.

Test shows that this can restore the TLB flushing batching performance for
synchronous migration effectively.

Link: https://lkml.kernel.org/r/20230224141145.96814-4-ying.huang@intel.com
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


--- a/mm/migrate.c~migrate_pages-try-migrate-in-batch-asynchronously-firstly
+++ b/mm/migrate.c
@@ -1843,6 +1843,51 @@ static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 	return rc;
 }
 
+static int migrate_pages_sync(struct list_head *from, new_page_t get_new_page,
+		free_page_t put_new_page, unsigned long private,
+		enum migrate_mode mode, int reason, struct list_head *ret_folios,
+		struct list_head *split_folios, struct migrate_pages_stats *stats)
+{
+	int rc, nr_failed = 0;
+	LIST_HEAD(folios);
+	struct migrate_pages_stats astats;
+
+	memset(&astats, 0, sizeof(astats));
+	/* Try to migrate in batch with MIGRATE_ASYNC mode firstly */
+	rc = migrate_pages_batch(from, get_new_page, put_new_page, private, MIGRATE_ASYNC,
+				 reason, &folios, split_folios, &astats,
+				 NR_MAX_MIGRATE_PAGES_RETRY);
+	stats->nr_succeeded += astats.nr_succeeded;
+	stats->nr_thp_succeeded += astats.nr_thp_succeeded;
+	stats->nr_thp_split += astats.nr_thp_split;
+	if (rc < 0) {
+		stats->nr_failed_pages += astats.nr_failed_pages;
+		stats->nr_thp_failed += astats.nr_thp_failed;
+		list_splice_tail(&folios, ret_folios);
+		return rc;
+	}
+	stats->nr_thp_failed += astats.nr_thp_split;
+	nr_failed += astats.nr_thp_split;
+	/*
+	 * Fall back to migrate all failed folios one by one synchronously. All
+	 * failed folios except split THPs will be retried, so their failure
+	 * isn't counted
+	 */
+	list_splice_tail_init(&folios, from);
+	while (!list_empty(from)) {
+		list_move(from->next, &folios);
+		rc = migrate_pages_batch(&folios, get_new_page, put_new_page,
+					 private, mode, reason, ret_folios,
+					 split_folios, stats, NR_MAX_MIGRATE_PAGES_RETRY);
+		list_splice_tail_init(&folios, ret_folios);
+		if (rc < 0)
+			return rc;
+		nr_failed += rc;
+	}
+
+	return nr_failed;
+}
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -1874,7 +1919,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
-	int nr_pages, batch;
+	int nr_pages;
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
 	LIST_HEAD(ret_folios);
@@ -1890,10 +1935,6 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	if (rc_gather < 0)
 		goto out;
 
-	if (mode == MIGRATE_ASYNC)
-		batch = NR_MAX_BATCHED_MIGRATION;
-	else
-		batch = 1;
 again:
 	nr_pages = 0;
 	list_for_each_entry_safe(folio, folio2, from, lru) {
@@ -1904,16 +1945,20 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		}
 
 		nr_pages += folio_nr_pages(folio);
-		if (nr_pages >= batch)
+		if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
 			break;
 	}
-	if (nr_pages >= batch)
+	if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
 		list_cut_before(&folios, from, &folio2->lru);
 	else
 		list_splice_init(from, &folios);
-	rc = migrate_pages_batch(&folios, get_new_page, put_new_page, private,
-				 mode, reason, &ret_folios, &split_folios, &stats,
-				 NR_MAX_MIGRATE_PAGES_RETRY);
+	if (mode == MIGRATE_ASYNC)
+		rc = migrate_pages_batch(&folios, get_new_page, put_new_page, private,
+					 mode, reason, &ret_folios, &split_folios, &stats,
+					 NR_MAX_MIGRATE_PAGES_RETRY);
+	else
+		rc = migrate_pages_sync(&folios, get_new_page, put_new_page, private,
+					mode, reason, &ret_folios, &split_folios, &stats);
 	list_splice_tail_init(&folios, &ret_folios);
 	if (rc < 0) {
 		rc_gather = rc;
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-fix-deadlock-in-batched-migration.patch
migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch
migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch

