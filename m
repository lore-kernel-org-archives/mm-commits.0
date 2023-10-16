Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5042ECDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjJPW0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjJPW0L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:26:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CDDAC
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:26:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA7DC433C8;
        Mon, 16 Oct 2023 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697495166;
        bh=V3Q18u2R+2bloH8Zmorl5ZOcpeh1oKlF8bwO6i7f/yc=;
        h=Date:To:From:Subject:From;
        b=S93fEIcIb8BHhDFcYZWq17jIl0mdUVudwM8qU32ydKkVfw4F7Rvk4pIRex5eErTag
         H5HqX3fTZHX2XmhSn70xVr0Dg8zcY5cRmJ+TqOMwe6WcwSM02wXPGZ5a0OweLnKLxv
         aN7JCQvTSOZdKm2pQEYkWhCXSzOVRymTEpH0G9xE=
Date:   Mon, 16 Oct 2023 15:26:05 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch added to mm-unstable branch
Message-Id: <20231016222606.2DA7DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct nr_failed in migrate_pages_sync()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: correct nr_failed in migrate_pages_sync()
Date: Mon, 16 Oct 2023 11:41:56 -0400

nr_failed was missing the large folio splits from migrate_pages_batch()
and can cause a mismatch between migrate_pages() return value and the
number of not migrated pages, i.e., when the return value of
migrate_pages() is 0, there are still pages left in the from page list. 
It will happen when a non-PMD THP large folio fails to migrate due to
-ENOMEM and is split successfully but not all the split pages are not
migrated, migrate_pages_batch() would return non-zero, but
astats.nr_thp_split =3D 0.  nr_failed would be 0 and returned to the
caller of migrate_pages(), but the not migrated pages are left in the from
page list without being added back to LRU lists.

Fix it by adding a new nr_split counter for large folio splits and adding
it to nr_failed in migrate_page_sync() after migrate_pages_batch() is
done.

Link: https://lkml.kernel.org/r/20231016154156.1948815-1-zi.yan@sent.com
Fixes: 2ef7dbb26990 ("migrate_pages: try migrate in batch asynchronously fi=
rstly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |   24 ++++++++++++++----------
 mm/migrate.c                   |   15 +++++++++++----
 2 files changed, 25 insertions(+), 14 deletions(-)

--- a/include/trace/events/migrate.h~mm-migrate-correct-nr_failed-in-migrate_pages_sync
+++ a/include/trace/events/migrate.h
@@ -49,10 +49,11 @@ TRACE_EVENT(mm_migrate_pages,
 
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
 		 unsigned long thp_succeeded, unsigned long thp_failed,
-		 unsigned long thp_split, enum migrate_mode mode, int reason),
+		 unsigned long thp_split, unsigned long large_folio_split,
+		 enum migrate_mode mode, int reason),
 
 	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
-		thp_split, mode, reason),
+		thp_split, large_folio_split, mode, reason),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,		succeeded)
@@ -60,26 +61,29 @@ TRACE_EVENT(mm_migrate_pages,
 		__field(	unsigned long,		thp_succeeded)
 		__field(	unsigned long,		thp_failed)
 		__field(	unsigned long,		thp_split)
+		__field(	unsigned long,		large_folio_split)
 		__field(	enum migrate_mode,	mode)
 		__field(	int,			reason)
 	),
 
 	TP_fast_assign(
-		__entry->succeeded	= succeeded;
-		__entry->failed		= failed;
-		__entry->thp_succeeded	= thp_succeeded;
-		__entry->thp_failed	= thp_failed;
-		__entry->thp_split	= thp_split;
-		__entry->mode		= mode;
-		__entry->reason		= reason;
+		__entry->succeeded			= succeeded;
+		__entry->failed				= failed;
+		__entry->thp_succeeded		= thp_succeeded;
+		__entry->thp_failed			= thp_failed;
+		__entry->thp_split			= thp_split;
+		__entry->large_folio_split	= large_folio_split;
+		__entry->mode				= mode;
+		__entry->reason				= reason;
 	),
 
-	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu mode=%s reason=%s",
+	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu nr_split=%lu mode=%s reason=%s",
 		__entry->succeeded,
 		__entry->failed,
 		__entry->thp_succeeded,
 		__entry->thp_failed,
 		__entry->thp_split,
+		__entry->large_folio_split,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
--- a/mm/migrate.c~mm-migrate-correct-nr_failed-in-migrate_pages_sync
+++ a/mm/migrate.c
@@ -1495,6 +1495,7 @@ struct migrate_pages_stats {
 	int nr_thp_succeeded;	/* THP migrated successfully */
 	int nr_thp_failed;	/* THP failed to be migrated */
 	int nr_thp_split;	/* THP split before migrating */
+	int nr_split;	/* Large folio (include THP) split before migrating */
 };
 
 /*
@@ -1614,6 +1615,7 @@ static int migrate_pages_batch(struct li
 	int nr_retry_pages = 0;
 	int pass = 0;
 	bool is_thp = false;
+	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL, *dst2;
 	int rc, rc_saved = 0, nr_pages;
 	LIST_HEAD(unmap_folios);
@@ -1629,7 +1631,8 @@ static int migrate_pages_batch(struct li
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
+			is_large = folio_test_large(folio);
+			is_thp = is_large && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
@@ -1649,6 +1652,7 @@ static int migrate_pages_batch(struct li
 				stats->nr_thp_failed++;
 				if (!try_split_folio(folio, split_folios)) {
 					stats->nr_thp_split++;
+					stats->nr_split++;
 					continue;
 				}
 				stats->nr_failed_pages += nr_pages;
@@ -1677,11 +1681,12 @@ static int migrate_pages_batch(struct li
 				nr_failed++;
 				stats->nr_thp_failed += is_thp;
 				/* Large folio NUMA faulting doesn't split to retry. */
-				if (folio_test_large(folio) && !nosplit) {
+				if (is_large && !nosplit) {
 					int ret = try_split_folio(folio, split_folios);
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
+						stats->nr_split++;
 						break;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
@@ -1827,6 +1832,7 @@ static int migrate_pages_sync(struct lis
 	stats->nr_succeeded += astats.nr_succeeded;
 	stats->nr_thp_succeeded += astats.nr_thp_succeeded;
 	stats->nr_thp_split += astats.nr_thp_split;
+	stats->nr_split += astats.nr_split;
 	if (rc < 0) {
 		stats->nr_failed_pages += astats.nr_failed_pages;
 		stats->nr_thp_failed += astats.nr_thp_failed;
@@ -1834,7 +1840,7 @@ static int migrate_pages_sync(struct lis
 		return rc;
 	}
 	stats->nr_thp_failed += astats.nr_thp_split;
-	nr_failed += astats.nr_thp_split;
+	nr_failed += astats.nr_split + astats.nr_thp_split;
 	/*
 	 * Fall back to migrate all failed folios one by one synchronously. All
 	 * failed folios except split THPs will be retried, so their failure
@@ -1969,7 +1975,8 @@ out:
 	count_vm_events(THP_MIGRATION_SPLIT, stats.nr_thp_split);
 	trace_mm_migrate_pages(stats.nr_succeeded, stats.nr_failed_pages,
 			       stats.nr_thp_succeeded, stats.nr_thp_failed,
-			       stats.nr_thp_split, mode, reason);
+			       stats.nr_thp_split, stats.nr_split, mode,
+			       reason);
 
 	if (ret_succeeded)
 		*ret_succeeded = stats.nr_succeeded;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

