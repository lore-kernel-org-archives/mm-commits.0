Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8395C433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD94864E46
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhBBTZC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238091AbhBBTWt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73A5260295;
        Tue,  2 Feb 2021 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612293728;
        bh=rs9uwII8KyHK4Vkzu1J6iO7mDqwP1qE+rkY53pLfDnA=;
        h=Date:From:To:Subject:From;
        b=iK3fNfhRGBW4dc837w2dTDmWwJnUHDgnFqhGIPoQ5FoIeQKX8E0vVNbLAdmTDVT5o
         iqI2ln7m11ZL5GuEzmFmrawKClKwmnWwuG+hYvlEdhiOiz8iiJhyZE3ZBSQZfuoRnz
         Wxi4Q80vdAbaLbGac33FZTrFl4IReg5YK2/7/eoI=
Date:   Tue, 02 Feb 2021 11:22:07 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  + mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch
 added to -mm tree
Message-ID: <20210202192207.rcIq2jj78%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: fix NOHZ wakeups for node stat changes
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch

