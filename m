Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F12BC7EE2C
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbjEYTyQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbjEYTyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8967BC
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18C9564ACA
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717E8C433EF;
        Thu, 25 May 2023 19:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044419;
        bh=m/AwKqpada00Tj2xCgVjiKmfu7aHuoalP+6ypRcVAwU=;
        h=Date:To:From:Subject:From;
        b=ygLmV2MwgdG+FqkgloG05GhC0MhjQn0vRblisc71mwA+OtIW1POBD36wLLDoVfh4L
         x/qYvlXEDUTAMCO4dn6gxq3rUVMVGR/evLwkpDC/0UBGGys1yRLpcgqBQ2k58mpE3T
         Q/BguF9q0zqn/XE2NkPPWSDDHHj1lfrpa60NdXbM=
Date:   Thu, 25 May 2023 12:53:38 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-add-trace-event-for-fast-freepages-isolation.patch added to mm-unstable branch
Message-Id: <20230525195339.717E8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: add trace event for fast freepages isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-add-trace-event-for-fast-freepages-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-add-trace-event-for-fast-freepages-isolation.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: add trace event for fast freepages isolation
Date: Thu, 25 May 2023 20:54:00 +0800

The fast_isolate_freepages() can also isolate freepages, but we can not
know the fast isolation efficiency to understand the fast isolation
pressure.  So add a trace event to show some numbers to help to understand
the efficiency for fast freepages isolation.

Link: https://lkml.kernel.org/r/78d2932d0160d122c15372aceb3f2c45460a17fc.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1446,7 +1446,7 @@ static int next_search_order(struct comp
 static void fast_isolate_freepages(struct compact_control *cc)
 {
 	unsigned int limit = max(1U, freelist_scan_limit(cc) >> 1);
-	unsigned int nr_scanned = 0;
+	unsigned int nr_scanned = 0, total_isolated = 0;
 	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
 	unsigned long distance;
@@ -1545,6 +1545,7 @@ static void fast_isolate_freepages(struc
 				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
+				total_isolated += nr_isolated;
 				cc->nr_freepages += nr_isolated;
 				list_add_tail(&page->lru, &cc->freepages);
 				count_compact_events(COMPACTISOLATED, nr_isolated);
@@ -1565,6 +1566,9 @@ static void fast_isolate_freepages(struc
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

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

