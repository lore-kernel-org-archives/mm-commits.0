Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A280C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0401261247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhKKCsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234354AbhKKCsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88AE861247;
        Thu, 11 Nov 2021 02:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598744;
        bh=dJfmFkW3xX6qNYv8E4hYgOKbKewqGWl4k6FYEVkkIcQ=;
        h=Date:From:To:Subject:From;
        b=H1gTnoZdXhu7T8j/FYJwHhQDK6y905aoY+lUDx2o3yu4gE1UrVaQv6pJHgk9MgM0j
         nQXY1NZcRFdu5MYcQHrRWuX8un1J8zKSrFXvInF0Yk4uXxF2//oPlXiuiBaq+ZOHhd
         8/W9q+zTIted7NbUNwt1DTeg0jg2N73bvs0tl2E0=
Date:   Wed, 10 Nov 2021 18:45:43 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, corbet@lwn.net, david@fromorbit.com,
        djwong@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        riel@surriel.com, tytso@mit.edu, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch removed
 from -mm tree
Message-ID: <20211111024543.lnXAIkmEN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: throttle reclaim when no progress is being made
has been removed from the -mm tree.  Its filename was
     mm-vmscan-throttle-reclaim-when-no-progress-is-being-made.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmscan: throttle reclaim when no progress is being made

Memcg reclaim throttles on congestion if no reclaim progress is made. 
This makes little sense, it might be due to writeback or a host of other
factors.

For !memcg reclaim, it's messy.  Direct reclaim primarily is throttled in
the page allocator if it is failing to make progress.  Kswapd throttles if
too many pages are under writeback and marked for immediate reclaim.

This patch explicitly throttles if reclaim is failing to make progress.

[vbabka@suse.cz: Remove redundant code]
Link: https://lkml.kernel.org/r/20211022144651.19914-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    1 +
 include/trace/events/vmscan.h |    4 +++-
 mm/memcontrol.c               |   10 +---------
 mm/vmscan.c                   |   28 ++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-throttle-reclaim-when-no-progress-is-being-made
+++ a/include/linux/mmzone.h
@@ -276,6 +276,7 @@ enum lru_list {
 enum vmscan_throttle_state {
 	VMSCAN_THROTTLE_WRITEBACK,
 	VMSCAN_THROTTLE_ISOLATED,
+	VMSCAN_THROTTLE_NOPROGRESS,
 	NR_VMSCAN_THROTTLE,
 };
 
--- a/include/trace/events/vmscan.h~mm-vmscan-throttle-reclaim-when-no-progress-is-being-made
+++ a/include/trace/events/vmscan.h
@@ -29,11 +29,13 @@
 
 #define _VMSCAN_THROTTLE_WRITEBACK	(1 << VMSCAN_THROTTLE_WRITEBACK)
 #define _VMSCAN_THROTTLE_ISOLATED	(1 << VMSCAN_THROTTLE_ISOLATED)
+#define _VMSCAN_THROTTLE_NOPROGRESS	(1 << VMSCAN_THROTTLE_NOPROGRESS)
 
 #define show_throttle_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",					\
 		{_VMSCAN_THROTTLE_WRITEBACK,	"VMSCAN_THROTTLE_WRITEBACK"},	\
-		{_VMSCAN_THROTTLE_ISOLATED,	"VMSCAN_THROTTLE_ISOLATED"}	\
+		{_VMSCAN_THROTTLE_ISOLATED,	"VMSCAN_THROTTLE_ISOLATED"},	\
+		{_VMSCAN_THROTTLE_NOPROGRESS,	"VMSCAN_THROTTLE_NOPROGRESS"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
 
--- a/mm/memcontrol.c~mm-vmscan-throttle-reclaim-when-no-progress-is-being-made
+++ a/mm/memcontrol.c
@@ -3487,19 +3487,11 @@ static int mem_cgroup_force_empty(struct
 
 	/* try to free all pages in this cgroup */
 	while (nr_retries && page_counter_read(&memcg->memory)) {
-		int progress;
-
 		if (signal_pending(current))
 			return -EINTR;
 
-		progress = try_to_free_mem_cgroup_pages(memcg, 1,
-							GFP_KERNEL, true);
-		if (!progress) {
+		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true))
 			nr_retries--;
-			/* maybe some writeback is necessary */
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
-		}
-
 	}
 
 	return 0;
--- a/mm/vmscan.c~mm-vmscan-throttle-reclaim-when-no-progress-is-being-made
+++ a/mm/vmscan.c
@@ -3322,6 +3322,33 @@ static inline bool compaction_ready(stru
 	return zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
 }
 
+static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
+{
+	/* If reclaim is making progress, wake any throttled tasks. */
+	if (sc->nr_reclaimed) {
+		wait_queue_head_t *wqh;
+
+		wqh = &pgdat->reclaim_wait[VMSCAN_THROTTLE_NOPROGRESS];
+		if (waitqueue_active(wqh))
+			wake_up(wqh);
+
+		return;
+	}
+
+	/*
+	 * Do not throttle kswapd on NOPROGRESS as it will throttle on
+	 * VMSCAN_THROTTLE_WRITEBACK if there are too many pages under
+	 * writeback and marked for immediate reclaim at the tail of
+	 * the LRU.
+	 */
+	if (current_is_kswapd())
+		return;
+
+	/* Throttle if making no progress at high prioities. */
+	if (sc->priority < DEF_PRIORITY - 2)
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS, HZ/10);
+}
+
 /*
  * This is the direct reclaim path, for page-allocating processes.  We only
  * try to reclaim pages from zones which will satisfy the caller's allocation
@@ -3406,6 +3433,7 @@ static void shrink_zones(struct zonelist
 			continue;
 		last_pgdat = zone->zone_pgdat;
 		shrink_node(zone->zone_pgdat, sc);
+		consider_reclaim_throttle(zone->zone_pgdat, sc);
 	}
 
 	/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


