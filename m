Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25EC947E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737378; cv=none; b=taBOj43W1Xd8GIfC9qkgOVpyd9yxUnIREOvt8IryA0HyCjJZYNAdhvOeOV9tmwa4488LtkLUE38TChWMwZZ1exND/Vf8tUgg6aC7febzftNC97S/gEZaYUHhzTm/mjPUxBoG5bbXur6T7qRUtsI1nLnPuHpthDH5nQz8RI43RbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737378; c=relaxed/simple;
	bh=PCMVpjsHscCMfSa8gIVcooSy3xwSRFtn33OST2wYStY=;
	h=Date:To:From:Subject:Message-Id; b=fPN7dVBw8TmFloJydrT4S5d5GPUAnAmH5t+f0Ok364JP7eTQtEcOar7PJiicXkWJ4I1t4PuHsAT6BXyIvxqciRX/RpAmB0DZBwA1vglQgfXhvERL58tJyw5+8LPam1swcwxAc2jue5B1Ls7NT5vsbxm4DPIIRi4wR1wScMxUJ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DAFebt80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DAFebt80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD52C433F1;
	Sat, 24 Feb 2024 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708737378;
	bh=PCMVpjsHscCMfSa8gIVcooSy3xwSRFtn33OST2wYStY=;
	h=Date:To:From:Subject:From;
	b=DAFebt80S5Dg7j3LjZKYe4xqsE130uERrf5l1Q90Ge9Eil6nbhw0eHOHDOa2Nbk+p
	 qfLebY0FxsNNbvsp2AIHTllIwJmscqJQZ17nRce1nd1G4TffJXyDt8fwQf0pcygVgO
	 J+xT6+xIqabUAt1nrXq6/ArP9xwMmebO8ED76SHQ=
Date: Fri, 23 Feb 2024 17:16:17 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch added to mm-unstable branch
Message-Id: <20240224011618.3DD52C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, vmscan: do not turn on cache_trim_mode if it doesn't work
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

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
+	    !(sc->cache_trim_mode && !sc->reclaimable && sc->priority <= 1))
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

mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch
sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work.patch

