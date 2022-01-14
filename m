Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C0FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiANWIp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08DC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:08:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7DEE9CE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C82C36AE5;
        Fri, 14 Jan 2022 22:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198120;
        bh=AbxaJI2ZzEZZvcHuk8pMyWSoIl0x4wvKLH4mxWiFD30=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nOOaJVpVT4tEQBvbpUkM3/0IMy/lzozBo+bDJwMJI/Q4KHrSPOqfjL6sI3ZaxCDKv
         HXcNlLPYSif8Y5XydX3Tl2DW8sIRM6WCFiOeo8LpKYzxzlaV9L3xzhSai0nn7eyIbD
         /adefYQ2QlSnvZ+xCFE6j+DPdowdvckSOyyGlrhs=
Date:   Fri, 14 Jan 2022 14:08:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 104/146] mm: compaction: fix the migration stats
 in trace_mm_compaction_migratepages()
Message-ID: <20220114220840.FROGeVO3F%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
