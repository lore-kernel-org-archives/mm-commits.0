Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC19215767
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188261; cv=none; b=Aj2h3qBbAiFwfcnAyaUWTLcybbuox5+bSj5+YmEUUsrWREiTRoz9+Na8L/rDdE0vAWysUNKkro5dKbebPmLpI9Ty9fxPkoNCKH4XeaexUY0oTCAYxpNM/mNDxhkXq0bpvzNVwJO1WPYSsl79JqR1DQfS891XsFbEDFCzQ6/h5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188261; c=relaxed/simple;
	bh=lFb3Wx2RStiTcReO4YKYqNyJjzrspDvAaop8BlmsoaU=;
	h=Date:To:From:Subject:Message-Id; b=WmIdOwVGVyQZsaALVo2bVzvgF91k9iW+Xb/cs75NnCUd6BzQNNk/CPAspjNd9iob/a9CN5u6b2XwTPiauJaqJ45003s4RJv2s1y3ATmF2gHxRRmO3kb0jtC0kwLInRxcTgRaey+YntVVEl5cxgKJyfiOuI6BNA1zoUz6s3GSesg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B5vStl+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B5vStl+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A04C4CEEC;
	Mon, 17 Mar 2025 05:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188261;
	bh=lFb3Wx2RStiTcReO4YKYqNyJjzrspDvAaop8BlmsoaU=;
	h=Date:To:From:Subject:From;
	b=B5vStl+C6lgGbYhFhtzfEnB4+Q9lFmLOXx8avGQ1GbYr6is+CZicpoLcNRLu1GdFL
	 KzjWZWJuvabxqtezm791AVRph/lMd4pDF9J1beI7OPuFlxf3De2haAqUCmTpfU6/m/
	 H3NfpD1GOfmlLXQvoZfFqa3CpfQ3DYdYE+HSy/1w=
Date: Sun, 16 Mar 2025 22:11:00 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,mhocko@suse.com,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,dave.hansen@linux.intel.com,apw@canonical.com,bertrand.wlodarczyk@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-cleanup-add-for_each_managed_zone_pgdat-macro.patch removed from -mm tree
Message-Id: <20250317051100.E4A04C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmscan, cleanup: add for_each_managed_zone_pgdat macro
has been removed from the -mm tree.  Its filename was
     vmscan-cleanup-add-for_each_managed_zone_pgdat-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>
Subject: vmscan, cleanup: add for_each_managed_zone_pgdat macro
Date: Mon, 10 Feb 2025 17:07:49 +0100

The macro is introduced to eliminate redundancy in the repeated iteration
over managed zones in pgdat data structure, reducing the potential for
errors. This change doesn't introduce any functional modifications.
Due to concentration of the pattern in vmscan.c the macro is placed
locally in that file.

Link: https://lkml.kernel.org/r/20250210160818.686-1-bertrand.wlodarczyk@intel.com
Signed-off-by: Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   83 +++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 51 deletions(-)

--- a/mm/vmscan.c~vmscan-cleanup-add-for_each_managed_zone_pgdat-macro
+++ a/mm/vmscan.c
@@ -271,6 +271,25 @@ static int sc_swappiness(struct scan_con
 }
 #endif
 
+/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
+ * and including the specified highidx
+ * @zone: The current zone in the iterator
+ * @pgdat: The pgdat which node_zones are being iterated
+ * @idx: The index variable
+ * @highidx: The index of the highest zone to return
+ *
+ * This macro iterates through all managed zones up to and including the specified highidx.
+ * The zone iterator enters an invalid state after macro call and must be reinitialized
+ * before it can be used again.
+ */
+#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
+	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
+	    (idx) <= (highidx);					\
+	    (idx)++, (zone)++)					\
+		if (!managed_zone(zone))			\
+			continue;				\
+		else
+
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
@@ -396,13 +415,9 @@ static unsigned long lruvec_lru_size(str
 {
 	unsigned long size = 0;
 	int zid;
+	struct zone *zone;
 
-	for (zid = 0; zid <= zone_idx; zid++) {
-		struct zone *zone = &lruvec_pgdat(lruvec)->node_zones[zid];
-
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, lruvec_pgdat(lruvec), zid, zone_idx) {
 		if (!mem_cgroup_disabled())
 			size += mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
 		else
@@ -495,7 +510,7 @@ static bool skip_throttle_noprogress(pg_
 {
 	int reclaimable = 0, write_pending = 0;
 	int i;
-
+	struct zone *zone;
 	/*
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
@@ -508,12 +523,7 @@ static bool skip_throttle_noprogress(pg_
 	 * throttle as throttling will occur when the folios cycle
 	 * towards the end of the LRU if still under writeback.
 	 */
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		struct zone *zone = pgdat->node_zones + i;
-
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, i, MAX_NR_ZONES - 1) {
 		reclaimable += zone_reclaimable_pages(zone);
 		write_pending += zone_page_state_snapshot(zone,
 						  NR_ZONE_WRITE_PENDING);
@@ -2372,17 +2382,13 @@ static void prepare_scan_control(pg_data
 		unsigned long total_high_wmark = 0;
 		unsigned long free, anon;
 		int z;
+		struct zone *zone;
 
 		free = sum_zone_node_page_state(pgdat->node_id, NR_FREE_PAGES);
 		file = node_page_state(pgdat, NR_ACTIVE_FILE) +
 			   node_page_state(pgdat, NR_INACTIVE_FILE);
 
-		for (z = 0; z < MAX_NR_ZONES; z++) {
-			struct zone *zone = &pgdat->node_zones[z];
-
-			if (!managed_zone(zone))
-				continue;
-
+		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
 			total_high_wmark += high_wmark_pages(zone);
 		}
 
@@ -5851,6 +5857,7 @@ static inline bool should_continue_recla
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
 	int z;
+	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -5870,11 +5877,7 @@ static inline bool should_continue_recla
 		return false;
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
-	for (z = 0; z <= sc->reclaim_idx; z++) {
-		struct zone *zone = &pgdat->node_zones[z];
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
 		/* Allocation can already succeed, nothing to do */
 		if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 				      sc->reclaim_idx, 0))
@@ -6401,11 +6404,7 @@ static bool allow_direct_reclaim(pg_data
 	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
 		return true;
 
-	for (i = 0; i <= ZONE_NORMAL; i++) {
-		zone = &pgdat->node_zones[i];
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
 		if (!zone_reclaimable_pages(zone))
 			continue;
 
@@ -6710,12 +6709,7 @@ static bool pgdat_balanced(pg_data_t *pg
 	 * Check watermarks bottom-up as lower zones are more likely to
 	 * meet watermarks.
 	 */
-	for (i = 0; i <= highest_zoneidx; i++) {
-		zone = pgdat->node_zones + i;
-
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 			mark = promo_wmark_pages(zone);
 		else
@@ -6800,11 +6794,7 @@ static bool kswapd_shrink_node(pg_data_t
 
 	/* Reclaim a number of pages proportional to the number of zones */
 	sc->nr_to_reclaim = 0;
-	for (z = 0; z <= sc->reclaim_idx; z++) {
-		zone = pgdat->node_zones + z;
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
 		sc->nr_to_reclaim += max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
 	}
 
@@ -6835,12 +6825,7 @@ update_reclaim_active(pg_data_t *pgdat,
 	int i;
 	struct zone *zone;
 
-	for (i = 0; i <= highest_zoneidx; i++) {
-		zone = pgdat->node_zones + i;
-
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
 		if (active)
 			set_bit(ZONE_RECLAIM_ACTIVE, &zone->flags);
 		else
@@ -6901,11 +6886,7 @@ static int balance_pgdat(pg_data_t *pgda
 	 * stall or direct reclaim until kswapd is finished.
 	 */
 	nr_boost_reclaim = 0;
-	for (i = 0; i <= highest_zoneidx; i++) {
-		zone = pgdat->node_zones + i;
-		if (!managed_zone(zone))
-			continue;
-
+	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
 		nr_boost_reclaim += zone->watermark_boost;
 		zone_boosts[i] = zone->watermark_boost;
 	}
_

Patches currently in -mm which might be from bertrand.wlodarczyk@intel.com are


