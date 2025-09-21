Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7208F21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489973; cv=none; b=P74Vg841MyInxjjIElDYkRHaaCIWtfQqGRrpK8fc80nkGpuLukgIZXymtzohd3tP9A819Br5TF3WNZ8etsUUETCjyQZSRi3q65XGRvtyxzfclYwV6gS5wBi/Cqr+ZLhTerOaiEP89kqAz3PoAtGs/77sbFMPRzg0RNG9gj5J3aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489973; c=relaxed/simple;
	bh=QRSaKCrzWIxQ0LOs6dv8YgUcPooTwsmWAz4zqjqyMMc=;
	h=Date:To:From:Subject:Message-Id; b=nnl2uexSddC2I6NrDwakfpHFdnUScvr4sZwT8Z2MS4l+d3dRNS6/n9MM2njFzg6ANQJFQbo43l3js6r9JD6evHwtoXlM0yA627lXN2+x2C9W8Y9crDjrlTrYABDRAU545jpmUsuAxRbWsbUSPBAgeybzS0181rKXA9Tko/XtRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WStFlgK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WStFlgK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B178C4CEE7;
	Sun, 21 Sep 2025 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489973;
	bh=QRSaKCrzWIxQ0LOs6dv8YgUcPooTwsmWAz4zqjqyMMc=;
	h=Date:To:From:Subject:From;
	b=WStFlgK+Hgo97fDGwyyeagOzP9aJLDOC5+5O/4ruYGlKagVHhpzJ+AcVuqIWeiJvS
	 u7j5pmytgNtfQKPF2JiVOUpacjU/cAm6WqJEH33zDINV5pG7BJTH5xenx5Lx2xJ1VH
	 RsHEolDV2hQV5PUEjPvYY+94R1CgCK2233jxdGP4=
Date: Sun, 21 Sep 2025 14:26:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,flyinrm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled.patch removed from -mm tree
Message-Id: <20250921212613.0B178C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: re-enable kswapd when memory pressure subsides or demotion is toggled
has been removed from the -mm tree.  Its filename was
     mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chanwon Park <flyinrm@gmail.com>
Subject: mm: re-enable kswapd when memory pressure subsides or demotion is toggled
Date: Mon, 8 Sep 2025 19:04:10 +0900

If kswapd fails to reclaim pages from a node MAX_RECLAIM_RETRIES in a
row, kswapd on that node gets disabled. That is, the system won't wakeup
kswapd for that node until page reclamation is observed at least once.
That reclamation is mostly done by direct reclaim, which in turn enables
kswapd back.

However, on systems with CXL memory nodes, workloads with high anon page
usage can disable kswapd indefinitely, without triggering direct
reclaim. This can be reproduced with following steps:

   numa node 0   (32GB memory, 48 CPUs)
   numa node 2~5 (512GB CXL memory, 128GB each)
   (numa node 1 is disabled)
   swap space 8GB

   1) Set /sys/kernel/mm/demotion_enabled to 0.
   2) Set /proc/sys/kernel/numa_balancing to 0.
   3) Run a process that allocates and random accesses 500GB of anon
      pages.
   4) Let the process exit normally.

During 3), free memory on node 0 gets lower than low watermark, and
kswapd runs and depletes swap space. Then, kswapd fails consecutively
and gets disabled. Allocation afterwards happens on CXL memory, so node
0 never gains more memory pressure to trigger direct reclaim.

After 4), kswapd on node 0 remains disabled, and tasks running on that
node are unable to swap. If you turn on NUMA_BALANCING_MEMORY_TIERING
and demotion now, it won't work properly since kswapd is disabled.

To mitigate this problem, reset kswapd_failures to 0 on following
conditions:

   a) ZONE_BELOW_HIGH bit of a zone in hopeless node with a fallback
      memory node gets cleared.
   b) demotion_enabled is changed from false to true.

Rationale for a):
   ZONE_BELOW_HIGH bit being cleared might be a sign that the node may
   be reclaimable afterwards. This won't help much if the memory-hungry
   process keeps running without freeing anything, but at least the node
   will go back to reclaimable state when the process exits.

Rationale for b):
   When demotion_enabled is false, kswapd can only reclaim anon pages by
   swapping them out to swap space. If demotion_enabled is turned on,
   kswapd can demote anon pages to another node for reclaiming. So, the
   original failure count for determining reclaimability is no longer
   valid.

Since kswapd_failures resets may be missed by ++ operation, it is
changed from int to atomic_t.

[akpm@linux-foundation.org: tweak whitespace]
Link: https://lkml.kernel.org/r/aL6qGi69jWXfPc4D@pcw-MS-7D22
Signed-off-by: Chanwon Park <flyinrm@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/memory-tiers.c      |   12 ++++++++++++
 mm/page_alloc.c        |   29 ++++++++++++++++++++++-------
 mm/show_mem.c          |    3 ++-
 mm/vmscan.c            |   14 +++++++-------
 mm/vmstat.c            |    2 +-
 6 files changed, 45 insertions(+), 17 deletions(-)

--- a/include/linux/mmzone.h~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/include/linux/mmzone.h
@@ -1440,7 +1440,7 @@ typedef struct pglist_data {
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
-	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
+	atomic_t kswapd_failures;	/* Number of 'reclaimed == 0' runs */
 
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
--- a/mm/memory-tiers.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/mm/memory-tiers.c
@@ -942,11 +942,23 @@ static ssize_t demotion_enabled_store(st
 				      const char *buf, size_t count)
 {
 	ssize_t ret;
+	bool before = numa_demotion_enabled;
 
 	ret = kstrtobool(buf, &numa_demotion_enabled);
 	if (ret)
 		return ret;
 
+	/*
+	 * Reset kswapd_failures statistics. They may no longer be
+	 * valid since the policy for kswapd has changed.
+	 */
+	if (before == false && numa_demotion_enabled == true) {
+		struct pglist_data *pgdat;
+
+		for_each_online_pgdat(pgdat)
+			atomic_set(&pgdat->kswapd_failures, 0);
+	}
+
 	return count;
 }
 
--- a/mm/page_alloc.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/mm/page_alloc.c
@@ -2860,14 +2860,29 @@ static void free_frozen_page_commit(stru
 		 */
 		return;
 	}
+
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
-		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
-		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
-				      ZONE_MOVABLE, 0))
-			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+	if (pcp->count < high)
+		return;
+
+	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
+			   pcp, pindex);
+	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+			      ZONE_MOVABLE, 0)) {
+		struct pglist_data *pgdat = zone->zone_pgdat;
+		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		/*
+		 * Assume that memory pressure on this node is gone and may be
+		 * in a reclaimable state. If a memory fallback node exists,
+		 * direct reclaim may not have been triggered, causing a
+		 * 'hopeless node' to stay in that state for a while.  Let
+		 * kswapd work again by resetting kswapd_failures.
+		 */
+		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+			atomic_set(&pgdat->kswapd_failures, 0);
 	}
 }
 
--- a/mm/show_mem.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/mm/show_mem.c
@@ -278,7 +278,8 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES),
+			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
+				   MAX_RECLAIM_RETRIES),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
--- a/mm/vmscan.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/mm/vmscan.c
@@ -518,7 +518,7 @@ static bool skip_throttle_noprogress(pg_
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
 	 */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	/*
@@ -5101,7 +5101,7 @@ static void lru_gen_shrink_node(struct p
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		pgdat->kswapd_failures = 0;
+		atomic_set(&pgdat->kswapd_failures, 0);
 }
 
 /******************************************************************************
@@ -6180,7 +6180,7 @@ again:
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		pgdat->kswapd_failures = 0;
+		atomic_set(&pgdat->kswapd_failures, 0);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -6492,7 +6492,7 @@ static bool allow_direct_reclaim(pg_data
 	int i;
 	bool wmark_ok;
 
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
@@ -6902,7 +6902,7 @@ static bool prepare_kswapd_sleep(pg_data
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	/* Hopeless node, leave it to direct reclaim */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	if (pgdat_balanced(pgdat, order, highest_zoneidx)) {
@@ -7170,7 +7170,7 @@ restart:
 	}
 
 	if (!sc.nr_reclaimed)
-		pgdat->kswapd_failures++;
+		atomic_inc(&pgdat->kswapd_failures);
 
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
@@ -7429,7 +7429,7 @@ void wakeup_kswapd(struct zone *zone, gf
 		return;
 
 	/* Hopeless node, leave it to direct reclaim if possible */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ||
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES ||
 	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
 	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
 		/*
--- a/mm/vmstat.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled
+++ a/mm/vmstat.c
@@ -1848,7 +1848,7 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  node_unreclaimable:  %u"
 		   "\n  start_pfn:           %lu",
-		   pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES,
+		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
 		   zone->zone_start_pfn);
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from flyinrm@gmail.com are


