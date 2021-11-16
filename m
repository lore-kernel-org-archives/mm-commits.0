Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4A2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B313561A88
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbhKPEUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:20:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242931AbhKPESn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E078863212;
        Tue, 16 Nov 2021 04:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637036143;
        bh=dPfOIJoZTzVzKOWf7FdLiHvJV92anu9MmgNp9VSIjCQ=;
        h=Date:From:To:Subject:From;
        b=kHGcNSJG+TfYL4kSq3M8LmOnmNw9DMUubrl6aJjEXc27mhOeQ7ZxhCJi3ePFCpwdl
         +bnmhRHYOcaBkryQgCUwdeDbBIEerHEk+ZZEYV6iZRTOJ8sSYsggHTDP5VJoy7xYLz
         a4Bwh/JJExO1LKEhRwsASraGwp02PPLn8xsMkaHY=
Date:   Mon, 15 Nov 2021 20:15:42 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-compaction-fix-the-migration-stats-in-trace=5Fmm=5Fcompa?=
 =?US-ASCII?Q?ction=5Fmigratepages.patch?= added to -mm tree
Message-ID: <20211116041542.5_sC-pHVJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix the migration stats in trace_mm_compaction_migratepages()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: fix the migration stats in trace_mm_compaction_migratepages()

Now the migrate_pages() has changed to return the number of {normal page,
THP, hugetlb} instead, thus we should not use the return value to
calculate the number of pages migrated successfully.  Instead we can just
use the 'nr_succeeded' which indicates the number of normal pages migrated
successfully to calculate the non-migrated pages in
trace_mm_compaction_migratepages().

Link: https://lkml.kernel.org/r/b4225251c4bec068dcd90d275ab7de88a39e2bd7.1636275127.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   24 ++++--------------------
 mm/compaction.c                   |    7 ++++---
 2 files changed, 8 insertions(+), 23 deletions(-)

--- a/include/trace/events/compaction.h~mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages
+++ a/include/trace/events/compaction.h
@@ -68,10 +68,9 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_PROTO(unsigned long nr_all,
-		int migrate_rc,
-		struct list_head *migratepages),
+		unsigned int nr_succeeded),
 
-	TP_ARGS(nr_all, migrate_rc, migratepages),
+	TP_ARGS(nr_all, nr_succeeded),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, nr_migrated)
@@ -79,23 +78,8 @@ TRACE_EVENT(mm_compaction_migratepages,
 	),
 
 	TP_fast_assign(
-		unsigned long nr_failed = 0;
-		struct list_head *page_lru;
-
-		/*
-		 * migrate_pages() returns either a non-negative number
-		 * with the number of pages that failed migration, or an
-		 * error code, in which case we need to count the remaining
-		 * pages manually
-		 */
-		if (migrate_rc >= 0)
-			nr_failed = migrate_rc;
-		else
-			list_for_each(page_lru, migratepages)
-				nr_failed++;
-
-		__entry->nr_migrated = nr_all - nr_failed;
-		__entry->nr_failed = nr_failed;
+		__entry->nr_migrated = nr_succeeded;
+		__entry->nr_failed = nr_all - nr_succeeded;
 	),
 
 	TP_printk("nr_migrated=%lu nr_failed=%lu",
--- a/mm/compaction.c~mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages
+++ a/mm/compaction.c
@@ -2280,6 +2280,7 @@ compact_zone(struct compact_control *cc,
 	unsigned long last_migrated_pfn;
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 	bool update_cached;
+	unsigned int nr_succeeded = 0;
 
 	/*
 	 * These counters track activities during zone compaction.  Initialize
@@ -2398,10 +2399,10 @@ compact_zone(struct compact_control *cc,
 
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
-				MR_COMPACTION, NULL);
+				MR_COMPACTION, &nr_succeeded);
 
-		trace_mm_compaction_migratepages(cc->nr_migratepages, err,
-							&cc->migratepages);
+		trace_mm_compaction_migratepages(cc->nr_migratepages,
+						 nr_succeeded);
 
 		/* All pages were either migrated or will be released */
 		cc->nr_migratepages = 0;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch

