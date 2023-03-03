Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F955C678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 03:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjCCDOu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 22:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjCCDOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 22:14:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4091E5F3
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 19:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 850FAB8169A
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 03:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F357DC4339B;
        Fri,  3 Mar 2023 03:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677813285;
        bh=Ho4DtxLO4OFTDlF0k0rCVzOcQH/12ZYK8KceyhRSf3c=;
        h=Date:To:From:Subject:From;
        b=TLSGAkzX7335XzfPSoQpofwRz/PIajhbTriLHCoZHFv1KnZ8xhMO/MWOBMi/IOfBs
         bpMIkrYbaJqaQFkncvU1TB26kBb8LqJrUK6Ngd55bPBF5ArrR4NR3cotInK2R+g74k
         +7huBQyASV0vADPtbfGTlz5t/rrwfG2zPmZxcsJ8=
Date:   Thu, 02 Mar 2023 19:14:44 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, tj@kernel.org, shy828301@gmail.com,
        shr@devkernel.io, pengfei.xu@intel.com, mike.kravetz@oracle.com,
        hughd@google.com, hch@lst.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303031444.F357DC4339B@smtp.kernel.org>
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
Date: Fri, 3 Mar 2023 11:01:55 +0800

When we have locked more than one folios, we cannot wait the lock or bit
(e.g., page lock, buffer head lock, writeback bit) synchronously. 
Otherwise deadlock may be triggered.  This make it hard to batch the
synchronous migration directly.

This patch re-enables batching synchronous migration via trying to migrate
in batch asynchronously firstly.  And any folios that are failed to be
migrated asynchronously will be migrated synchronously one by one.

Test shows that this can restore the TLB flushing batching performance for
synchronous migration effectively.

Link: https://lkml.kernel.org/r/20230303030155.160983-4-ying.huang@intel.com
Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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


--- a/mm/migrate.c~migrate_pages-try-migrate-in-batch-asynchronously-firstly
+++ a/mm/migrate.c
@@ -1115,9 +1115,8 @@ static void migrate_folio_done(struct fo
 /* Obtain the lock on page, remove all ptes. */
 static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
 			       unsigned long private, struct folio *src,
-			       struct folio **dstp, int force,
-			       enum migrate_mode mode, enum migrate_reason reason,
-			       struct list_head *ret)
+			       struct folio **dstp, enum migrate_mode mode,
+			       enum migrate_reason reason, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1147,7 +1146,7 @@ static int migrate_folio_unmap(new_page_
 	dst->private = NULL;
 
 	if (!folio_trylock(src)) {
-		if (!force || mode == MIGRATE_ASYNC)
+		if (mode == MIGRATE_ASYNC)
 			goto out;
 
 		/*
@@ -1185,8 +1184,6 @@ static int migrate_folio_unmap(new_page_
 			rc = -EBUSY;
 			goto out;
 		}
-		if (!force)
-			goto out;
 		folio_wait_writeback(src);
 	}
 
@@ -1500,6 +1497,9 @@ static inline int try_split_folio(struct
 #define NR_MAX_BATCHED_MIGRATION	512
 #endif
 #define NR_MAX_MIGRATE_PAGES_RETRY	10
+#define NR_MAX_MIGRATE_ASYNC_RETRY	3
+#define NR_MAX_MIGRATE_SYNC_RETRY					\
+	(NR_MAX_MIGRATE_PAGES_RETRY - NR_MAX_MIGRATE_ASYNC_RETRY)
 
 struct migrate_pages_stats {
 	int nr_succeeded;	/* Normal and large folios migrated successfully, in
@@ -1681,8 +1681,7 @@ static int migrate_pages_batch(struct li
 			}
 
 			rc = migrate_folio_unmap(get_new_page, put_new_page, private,
-						 folio, &dst, pass > 2, mode,
-						 reason, ret_folios);
+						 folio, &dst, mode, reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	Success: folio will be freed
@@ -1860,6 +1859,51 @@ out:
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
+				 NR_MAX_MIGRATE_ASYNC_RETRY);
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
+					 split_folios, stats, NR_MAX_MIGRATE_SYNC_RETRY);
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
@@ -1891,7 +1935,7 @@ int migrate_pages(struct list_head *from
 		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
-	int nr_pages, batch;
+	int nr_pages;
 	struct folio *folio, *folio2;
 	LIST_HEAD(folios);
 	LIST_HEAD(ret_folios);
@@ -1907,10 +1951,6 @@ int migrate_pages(struct list_head *from
 	if (rc_gather < 0)
 		goto out;
 
-	if (mode == MIGRATE_ASYNC)
-		batch = NR_MAX_BATCHED_MIGRATION;
-	else
-		batch = 1;
 again:
 	nr_pages = 0;
 	list_for_each_entry_safe(folio, folio2, from, lru) {
@@ -1921,16 +1961,20 @@ again:
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

migrate_pages-silence-gcc-notes-for-mis-casting.patch
migrate_pages-fix-deadlock-in-batched-migration.patch
migrate_pages-move-split-folios-processing-out-of-migrate_pages_batch.patch
migrate_pages-try-migrate-in-batch-asynchronously-firstly.patch

