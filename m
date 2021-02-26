Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960DAC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C97464F0D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZBRU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZBRI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84BAA64F2B;
        Fri, 26 Feb 2021 01:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302208;
        bh=LpMLGDTMIAYZn24LxN4Rcm5txiBnIPh4BlB3AJIhZIk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1a0nafmLl6jYa5klihoR2V/K93oXedufhY0hAlWSDR/GYBiEvt1vuC5vJpQT6URBY
         aALw5/lVzYHSwrFAvrCptZ+Yl3zTkSWMKBN9p1s5FABbCiSFGeaBevQ2QETHsViJaw
         WTXTiALZt4uccwZFPsA4LRZcDRWmcp8HG314JXHw=
Date:   Thu, 25 Feb 2021 17:16:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 023/118] mm: vmstat: fix NOHZ wakeups for node
 stat changes
Message-ID: <20210226011647.uVMjpRAVE%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmstat: fix NOHZ wakeups for node stat changes

On NOHZ, the periodic vmstat flushers on each CPU can go to sleep and
won't wake up until stat changes are detected in the per-cpu deltas of the
zone vmstat counters.

In commit 75ef71840539 ("mm, vmstat: add infrastructure for per-node
vmstats") per-node counters were introduced, and subsequently most stats
were moved from the zone to the node level.  However, the node counters
weren't added to the NOHZ wakeup detection.

In theory this can cause per-cpu errors to remain in the user-reported
stats indefinitely.  In practice this only affects a handful of sub
counters (file_mapped, dirty and writeback e.g.) because other page state
changes at the node level likely involve a change at the zone level as
well (alloc and free, lru ops).  Also, nobody has complained.

Fix it up for completeness: wake up vmstat refreshing on node changes. 
Also remove the BUILD_BUG_ONs that assert counter size; we haven't relied
on it since we added sizeof() to the range calculation in commit
13c9aaf7fa01 ("mm/vmstat.c: fix NUMA statistics updates").

Link: https://lkml.kernel.org/r/20210202184342.118513-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-nohz-wakeups-for-node-stat-changes
+++ a/mm/vmstat.c
@@ -1894,16 +1894,12 @@ static void vmstat_update(struct work_st
  */
 static bool need_update(int cpu)
 {
+	pg_data_t *last_pgdat = NULL;
 	struct zone *zone;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_pageset *p = per_cpu_ptr(zone->pageset, cpu);
-
-		BUILD_BUG_ON(sizeof(p->vm_stat_diff[0]) != 1);
-#ifdef CONFIG_NUMA
-		BUILD_BUG_ON(sizeof(p->vm_numa_stat_diff[0]) != 2);
-#endif
-
+		struct per_cpu_nodestat *n;
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
 		 */
@@ -1915,6 +1911,13 @@ static bool need_update(int cpu)
 			       sizeof(p->vm_numa_stat_diff[0])))
 			return true;
 #endif
+		if (last_pgdat == zone->zone_pgdat)
+			continue;
+		last_pgdat = zone->zone_pgdat;
+		n = per_cpu_ptr(zone->zone_pgdat->per_cpu_nodestats, cpu);
+		if (memchr_inv(n->vm_node_stat_diff, 0, NR_VM_NODE_STAT_ITEMS *
+			       sizeof(n->vm_node_stat_diff[0])))
+		    return true;
 	}
 	return false;
 }
_
