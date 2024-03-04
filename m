Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9214D39AF1
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573135; cv=none; b=mM2s7gZenHBDLWgEMYLf48BZTKs+b2DT2+iFbpdGV0i/tmfwbMUEsVe/aLmhSCZgSkQsz4o+W6iZeyUBoyWAJhufdjWZlbJSSSjmTA+30FVBJdw5sP/kaJAVIpLbfTgRHd2c9GlJEWQCnaNtwHinp5S+4jtH1OfkL2Rpfzbu+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573135; c=relaxed/simple;
	bh=0KyGL1L4Olqimnz8/ZfXQNEYADu3UOw9mi9ExPi1zuI=;
	h=Date:To:From:Subject:Message-Id; b=L/ATq97UMKPQp58Oasoy30+2ysmUQHYhhhQV5qppwBEqb0CSgahEri67L4bNnghfmSlvQ5F2tn01W19MfCBdUSgkyHh6++F9mZrmQfcCisMCQh0cqSPASGwiBf2ho270pRAzI6kTrwpqZe8MsQF3FEYuBZDmQVMwFj7Tyh1uptM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=emOFl8c5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emOFl8c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64AC433F1;
	Mon,  4 Mar 2024 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709573135;
	bh=0KyGL1L4Olqimnz8/ZfXQNEYADu3UOw9mi9ExPi1zuI=;
	h=Date:To:From:Subject:From;
	b=emOFl8c53PE/eUAZlfv36k9+zXPk/nGB7Voaocal5JD//wCXEkaQRp3YxAYTN/qZt
	 K/pQVGQGaDt4C7Yekvtmwgo5pox+MRy7DTJ4EcCIHU2Nmk2RsJyxg1WDNuRiBlZZfD
	 m8PJev3uTC3UUlYYtHRmm01HJONO7PXEOKdv57zw=
Date: Mon, 04 Mar 2024 09:25:34 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch removed from -mm tree
Message-Id: <20240304172535.0D64AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, vmscan: do not turn on cache_trim_mode if it doesn't work
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: mm, vmscan: do not turn on cache_trim_mode if it doesn't work
Date: Fri, 23 Feb 2024 14:44:07 +0900

With cache_trim_mode on, reclaim logic doesn't bother reclaiming anon
pages.  However, it should be more careful to turn on the mode because
it's going to prevent anon pages from being reclaimed even if there are a
huge number of anon pages that are cold and should be reclaimed.  Even
worse, that leads kswapd_failures to reach MAX_RECLAIM_RETRIES and
stopping kswapd from functioning until direct reclaim eventually works to
resume kswapd.

So do not turn on cache_trim_mode if the mode doesn't work, especially
while the sytem is struggling against reclaim.

The problematic behavior can be reproduced by:

   CONFIG_NUMA_BALANCING enabled
   sysctl_numa_balancing_mode set to NUMA_BALANCING_MEMORY_TIERING
   numa node0 (8GB local memory, 16 CPUs)
   numa node1 (8GB slow tier memory, no CPUs)

   Sequence:

   1) echo 3 > /proc/sys/vm/drop_caches
   2) To emulate the system with full of cold memory in local DRAM, run
      the following dummy program and never touch the region:

         mmap(0, 8 * 1024 * 1024 * 1024, PROT_READ | PROT_WRITE,
	      MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);

   3) Run any memory intensive work e.g. XSBench.
   4) Check if numa balancing is working e.i. promotion/demotion.
   5) Iterate 1) ~ 4) until numa balancing stops.

With this, you could see that promotion/demotion are not working because
kswapd has stopped due to ->kswapd_failures >= MAX_RECLAIM_RETRIES.

Interesting vmstat delta's differences between before and after are like:

   +-----------------------+-------------------------------+
   | interesting vmstat	   | before	   | after	   |
   +-----------------------+-------------------------------+
   | nr_inactive_anon	   | 321935	   | 1636737	   |
   | nr_active_anon	   | 1780700	   | 465913	   |
   | nr_inactive_file	   | 30425	   | 35711	   |
   | nr_active_file	   | 14961	   | 8698	   |
   | pgpromote_success	   | 356	   | 1267785	   |
   | pgpromote_candidate   | 21953245	   | 1745631	   |
   | pgactivate		   | 1844523	   | 3309867	   |
   | pgdeactivate	   | 50634	   | 1545041	   |
   | pgfault		   | 31100294	   | 6411036	   |
   | pgdemote_kswapd	   | 30856	   | 2267467	   |
   | pgscan_kswapd	   | 1861981	   | 7729231	   |
   | pgscan_anon	   | 1822930	   | 7667544	   |
   | pgscan_file	   | 39051	   | 61687	   |
   | pgsteal_anon	   | 386	   | 2227217	   |
   | pgsteal_file	   | 30470	   | 40250	   |
   | pageoutrun		   | 30		   | 457	   |
   | numa_hint_faults	   | 27418279	   | 2752289	   |
   | numa_pages_migrated   | 356	   | 1267785 	   |
   +-----------------------+-------------------------------+

[akpm@linux-foundation.org: simplify boolean expression, per Ying Huang]
Link: https://lkml.kernel.org/r/20240223054407.14829-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work
+++ a/mm/vmscan.c
@@ -127,6 +127,9 @@ struct scan_control {
 	/* One of the zones is ready for compaction */
 	unsigned int compaction_ready:1;
 
+	/* If the last try was reclaimable */
+	unsigned int reclaimable:1;
+
 	/* There is easily reclaimable cold cache in the current node */
 	unsigned int cache_trim_mode:1;
 
@@ -2267,9 +2270,14 @@ static void prepare_scan_control(pg_data
 	 * If we have plenty of inactive file pages that aren't
 	 * thrashing, try to reclaim those first before touching
 	 * anonymous pages.
+	 *
+	 * It doesn't make sense to keep cache_trim_mode on if the mode
+	 * is not working while struggling against reclaim. So do not
+	 * turn it on if so. Note the highest priority of kswapd is 1.
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
-	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
+	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
+	    (!sc->cache_trim_mode || sc->reclaimable || sc->priority > 1))
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
@@ -5883,7 +5891,6 @@ static void shrink_node(pg_data_t *pgdat
 {
 	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
-	bool reclaimable = false;
 
 	if (lru_gen_enabled() && root_reclaim(sc)) {
 		lru_gen_shrink_node(pgdat, sc);
@@ -5898,6 +5905,14 @@ again:
 	nr_reclaimed = sc->nr_reclaimed;
 	nr_scanned = sc->nr_scanned;
 
+	/*
+	 * Reset to the default values at the start.
+	 */
+	if (sc->priority == DEF_PRIORITY) {
+		sc->reclaimable = 1;
+		sc->cache_trim_mode = 0;
+	}
+
 	prepare_scan_control(pgdat, sc);
 
 	shrink_node_memcgs(pgdat, sc);
@@ -5911,8 +5926,7 @@ again:
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
 			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
-	if (nr_node_reclaimed)
-		reclaimable = true;
+	sc->reclaimable = !!nr_node_reclaimed;
 
 	if (current_is_kswapd()) {
 		/*
@@ -5986,7 +6000,7 @@ again:
 	 * sleep. On reclaim progress, reset the failure counter. A
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
-	if (reclaimable)
+	if (sc->reclaimable)
 		pgdat->kswapd_failures = 0;
 }
 
_

Patches currently in -mm which might be from byungchul@sk.com are

sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch
mm-vmscan-retry-kswapds-priority-loop-with-cache_trim_mode-off-on-failure.patch

