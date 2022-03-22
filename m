Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39899C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiCVVre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiCVVr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022115F8DB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91EC66100A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E507AC340EC;
        Tue, 22 Mar 2022 21:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985557;
        bh=Zz3C5jyZcF3r7n9TLJbiOQTwALX+wG89V4HOV0ON8Ww=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=oK+TTQ1IsDbLedzlt9cvWJikwYu5U4B2pHTxa3GCkiDgq2BJ6p2iwBEaW8oPN8yRz
         AuptZEiwDTtti9/N8kYes9XIp4wieRqJf+o09k5liBBpEcWFmSvQLwZO6RfcdHGqQD
         E/JTBdYBPLmgBfu6IqySJwVGjhgplAgK6qpMO7r8=
Date:   Tue, 22 Mar 2022 14:45:56 -0700
To:     rostedt@goodmis.org, mingo@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 146/227] mm: compaction: cleanup the compaction trace events
Message-Id: <20220322214556.E507AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: cleanup the compaction trace events

As Steven suggested [1], we should access the pointers from the trace
event to avoid dereferencing them to the tracepoint function when the
tracepoint is disabled.

[1] https://lkml.org/lkml/2021/11/3/409

Link: https://lkml.kernel.org/r/4cd393b4d57f8f01ed72c001509b28e3a3b1a8c1.1646985115.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   26 +++++++++++++-------------
 mm/compaction.c                   |    9 +++------
 2 files changed, 16 insertions(+), 19 deletions(-)

--- a/include/trace/events/compaction.h~mm-compaction-cleanup-the-compaction-trace-events
+++ a/include/trace/events/compaction.h
@@ -67,10 +67,10 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 #ifdef CONFIG_COMPACTION
 TRACE_EVENT(mm_compaction_migratepages,
 
-	TP_PROTO(unsigned long nr_all,
+	TP_PROTO(struct compact_control *cc,
 		unsigned int nr_succeeded),
 
-	TP_ARGS(nr_all, nr_succeeded),
+	TP_ARGS(cc, nr_succeeded),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, nr_migrated)
@@ -79,7 +79,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_fast_assign(
 		__entry->nr_migrated = nr_succeeded;
-		__entry->nr_failed = nr_all - nr_succeeded;
+		__entry->nr_failed = cc->nr_migratepages - nr_succeeded;
 	),
 
 	TP_printk("nr_migrated=%lu nr_failed=%lu",
@@ -88,10 +88,10 @@ TRACE_EVENT(mm_compaction_migratepages,
 );
 
 TRACE_EVENT(mm_compaction_begin,
-	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
-		unsigned long free_pfn, unsigned long zone_end, bool sync),
+	TP_PROTO(struct compact_control *cc, unsigned long zone_start,
+		unsigned long zone_end, bool sync),
 
-	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync),
+	TP_ARGS(cc, zone_start, zone_end, sync),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, zone_start)
@@ -103,8 +103,8 @@ TRACE_EVENT(mm_compaction_begin,
 
 	TP_fast_assign(
 		__entry->zone_start = zone_start;
-		__entry->migrate_pfn = migrate_pfn;
-		__entry->free_pfn = free_pfn;
+		__entry->migrate_pfn = cc->migrate_pfn;
+		__entry->free_pfn = cc->free_pfn;
 		__entry->zone_end = zone_end;
 		__entry->sync = sync;
 	),
@@ -118,11 +118,11 @@ TRACE_EVENT(mm_compaction_begin,
 );
 
 TRACE_EVENT(mm_compaction_end,
-	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
-		unsigned long free_pfn, unsigned long zone_end, bool sync,
+	TP_PROTO(struct compact_control *cc, unsigned long zone_start,
+		unsigned long zone_end, bool sync,
 		int status),
 
-	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync, status),
+	TP_ARGS(cc, zone_start, zone_end, sync, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, zone_start)
@@ -135,8 +135,8 @@ TRACE_EVENT(mm_compaction_end,
 
 	TP_fast_assign(
 		__entry->zone_start = zone_start;
-		__entry->migrate_pfn = migrate_pfn;
-		__entry->free_pfn = free_pfn;
+		__entry->migrate_pfn = cc->migrate_pfn;
+		__entry->free_pfn = cc->free_pfn;
 		__entry->zone_end = zone_end;
 		__entry->sync = sync;
 		__entry->status = status;
--- a/mm/compaction.c~mm-compaction-cleanup-the-compaction-trace-events
+++ a/mm/compaction.c
@@ -2387,8 +2387,7 @@ compact_zone(struct compact_control *cc,
 	update_cached = !sync &&
 		cc->zone->compact_cached_migrate_pfn[0] == cc->zone->compact_cached_migrate_pfn[1];
 
-	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
-				cc->free_pfn, end_pfn, sync);
+	trace_mm_compaction_begin(cc, start_pfn, end_pfn, sync);
 
 	/* lru_add_drain_all could be expensive with involving other CPUs */
 	lru_add_drain();
@@ -2438,8 +2437,7 @@ compact_zone(struct compact_control *cc,
 				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION, &nr_succeeded);
 
-		trace_mm_compaction_migratepages(cc->nr_migratepages,
-						 nr_succeeded);
+		trace_mm_compaction_migratepages(cc, nr_succeeded);
 
 		/* All pages were either migrated or will be released */
 		cc->nr_migratepages = 0;
@@ -2515,8 +2513,7 @@ out:
 	count_compact_events(COMPACTMIGRATE_SCANNED, cc->total_migrate_scanned);
 	count_compact_events(COMPACTFREE_SCANNED, cc->total_free_scanned);
 
-	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
-				cc->free_pfn, end_pfn, sync, ret);
+	trace_mm_compaction_end(cc, start_pfn, end_pfn, sync, ret);
 
 	return ret;
 }
_
