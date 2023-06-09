Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850D0C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjFIXch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjFIXbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BCB468F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F7861AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFE4C433EF;
        Fri,  9 Jun 2023 23:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353363;
        bh=Kt52DejBbJWfJm8qz21WUSWxXMbO0r8gWub3nX9KdGQ=;
        h=Date:To:From:Subject:From;
        b=PblGUGvenMabFpYv+wEAVgxdysMLId9sv/kWEgDnGfsk+lcdZTXo2nfjACesxCXt/
         fejsKZlUsO5zSJdnoPb30KGWs5M9MV3YkULWS9g3zj4oviBZMFKWHmjHdtupNyITaF
         poVGpTA2wtoSMY1HqbNyoJK1/UnpdlJHLBmPbnUY=
Date:   Fri, 09 Jun 2023 16:29:22 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-add-trace-event-for-fast-freepages-isolation.patch removed from -mm tree
Message-Id: <20230609232923.7CFE4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: add trace event for fast freepages isolation
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-trace-event-for-fast-freepages-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: add trace event for fast freepages isolation
Date: Thu, 25 May 2023 20:54:00 +0800

The fast_isolate_freepages() can also isolate freepages, but we can not
know the fast isolation efficiency to understand the fast isolation
pressure.  So add a trace event to show some numbers to help to understand
the efficiency for fast freepages isolation.

Link: https://lkml.kernel.org/r/78d2932d0160d122c15372aceb3f2c45460a17fc.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   11 +++++++++++
 mm/compaction.c                   |    6 +++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/include/trace/events/compaction.h~mm-compaction-add-trace-event-for-fast-freepages-isolation
+++ a/include/trace/events/compaction.h
@@ -64,6 +64,17 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
 );
 
+DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_fast_isolate_freepages,
+
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
+		unsigned long nr_taken),
+
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
+);
+
 #ifdef CONFIG_COMPACTION
 TRACE_EVENT(mm_compaction_migratepages,
 
--- a/mm/compaction.c~mm-compaction-add-trace-event-for-fast-freepages-isolation
+++ a/mm/compaction.c
@@ -1416,7 +1416,7 @@ static int next_search_order(struct comp
 static void fast_isolate_freepages(struct compact_control *cc)
 {
 	unsigned int limit = max(1U, freelist_scan_limit(cc) >> 1);
-	unsigned int nr_scanned = 0;
+	unsigned int nr_scanned = 0, total_isolated = 0;
 	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
 	unsigned long distance;
@@ -1515,6 +1515,7 @@ static void fast_isolate_freepages(struc
 				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
+				total_isolated += nr_isolated;
 				cc->nr_freepages += nr_isolated;
 				list_add_tail(&page->lru, &cc->freepages);
 				count_compact_events(COMPACTISOLATED, nr_isolated);
@@ -1535,6 +1536,9 @@ static void fast_isolate_freepages(struc
 			limit = max(1U, limit >> 1);
 	}
 
+	trace_mm_compaction_fast_isolate_freepages(min_pfn, cc->free_pfn,
+						   nr_scanned, total_isolated);
+
 	if (!page) {
 		cc->fast_search_fail++;
 		if (scan_start) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


