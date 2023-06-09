Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF127C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjFIXb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjFIX3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA6E4236
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42B861AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DC8C433EF;
        Fri,  9 Jun 2023 23:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353333;
        bh=2qPpjTdo77xN997ZVM7245L1WS6btwL/bouPwHtHApU=;
        h=Date:To:From:Subject:From;
        b=dUdbuU815f7djFvSp6bn+GYJz5egsp6iVDerQJv7R+hDGA0MTmdWzsk4iZobU7WlJ
         cS0y9D3E5zcm3qzLzvXJXAfugiK63C78OcFKKbxT8dbeOLjBebGhnEK/dEUXTt122k
         3tjLiI5RR9gCPqRpyYsGv6Ef/ZCYNaTzkZIHOj2s=
Date:   Fri, 09 Jun 2023 16:28:52 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch removed from -mm tree
Message-Id: <20230609232853.26DC8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: remove unnecessary is_via_compact_memory() checks
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: remove unnecessary is_via_compact_memory() checks
Date: Fri, 19 May 2023 14:39:58 +0200

Remove from all paths not reachable via /proc/sys/vm/compact_memory.

Link: https://lkml.kernel.org/r/20230519123959.77335-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +----------
 mm/vmscan.c     |    8 +-------
 2 files changed, 2 insertions(+), 17 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unnecessary-is_via_compact_memory-checks
+++ a/mm/compaction.c
@@ -2280,9 +2280,6 @@ bool compaction_zonelist_suitable(struct
 		unsigned long available;
 		unsigned long watermark;
 
-		if (is_via_compact_memory(order))
-			return true;
-
 		/* Allocation can already succeed, nothing to do */
 		watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (zone_watermark_ok(zone, order, watermark,
@@ -2848,9 +2845,6 @@ static bool kcompactd_node_suitable(pg_d
 		if (!populated_zone(zone))
 			continue;
 
-		if (is_via_compact_memory(pgdat->kcompactd_max_order))
-			return true;
-
 		/* Allocation can already succeed, check other zones */
 		if (zone_watermark_ok(zone, pgdat->kcompactd_max_order,
 				      min_wmark_pages(zone),
@@ -2895,9 +2889,6 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_deferred(zone, cc.order))
 			continue;
 
-		if (is_via_compact_memory(cc.order))
-			goto compact;
-
 		/* Allocation can already succeed, nothing to do */
 		if (zone_watermark_ok(zone, cc.order,
 				      min_wmark_pages(zone), zoneid, 0))
@@ -2906,7 +2897,7 @@ static void kcompactd_do_work(pg_data_t
 		if (compaction_suitable(zone, cc.order,
 					zoneid) != COMPACT_CONTINUE)
 			continue;
-compact:
+
 		if (kthread_should_stop())
 			return;
 
--- a/mm/vmscan.c~mm-compaction-remove-unnecessary-is_via_compact_memory-checks
+++ a/mm/vmscan.c
@@ -6399,9 +6399,6 @@ static inline bool should_continue_recla
 		if (!managed_zone(zone))
 			continue;
 
-		if (sc->order == -1) /* is_via_compact_memory() */
-			return false;
-
 		/* Allocation can already succeed, nothing to do */
 		if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 				      sc->reclaim_idx, 0))
@@ -6598,9 +6595,6 @@ static inline bool compaction_ready(stru
 {
 	unsigned long watermark;
 
-	if (sc->order == -1) /* is_via_compact_memory() */
-		goto suitable;
-
 	/* Allocation can already succeed, nothing to do */
 	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 			      sc->reclaim_idx, 0))
@@ -6610,7 +6604,7 @@ static inline bool compaction_ready(stru
 	if (compaction_suitable(zone, sc->order,
 				sc->reclaim_idx) == COMPACT_SKIPPED)
 		return false;
-suitable:
+
 	/*
 	 * Compaction is already possible, but it takes time to run and there
 	 * are potentially other callers using the pages just freed. So proceed
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_isolation-write-proper-kerneldoc.patch

