Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E513E8C7C
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313490; cv=none; b=YtnuyxmN5/BMaJ+b9guq9Hm2f1pp/hzeXBGFgjNARLO5z9Pv+0jjlyahWSiN49HlecGzL7/Y99gah6yBExcqcrVpcKi08ASkuIw+AGb+zZClpbAvcVzquvWuIOJ5FFRJ/iXfmg78A4uf6amkB4Nz783UfJpZkx4Pu9LbNY1TI90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313490; c=relaxed/simple;
	bh=3mvp3RaocOsmfTr5hGO1T7voFlWqKbr+Vs8BEoMpMS4=;
	h=Date:To:From:Subject:Message-Id; b=XXdCH3eFYfxec+Lx0y1hc4AqdpEtVaCAUwa6eaG2XK7SPHdFzSAIEzrdBN5KG4DH1oLNT68OEBYy0Aifsi7THrgoPP6rKUxVSrGLltkCnLgpJqugCKHKl4VFCl5rYfV9A3TMmrAA0ZVpbAJTdcNKjS/375WARExmE8h9MWvletA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jewp6o6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jewp6o6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A88DC19425;
	Mon, 27 Apr 2026 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313490;
	bh=3mvp3RaocOsmfTr5hGO1T7voFlWqKbr+Vs8BEoMpMS4=;
	h=Date:To:From:Subject:From;
	b=jewp6o6aC/UXxgjnmPYcN+nXVncg8sHC+BnFQhZieFSlqI9J7SckjPhJvhVVMAj7A
	 L6MjpJ7Kp3uFKwY16367p7Jd1g9YdbCOQrpu6Ep0V7nFvCUWbV0qBzyQovxDRnKQr7
	 d/ek+McCGXcS6IfmB42FzGva2Pbt+wDJweZjnsR8=
Date: Mon, 27 Apr 2026 11:11:29 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-restructure-the-reclaim-loop.patch removed from -mm tree
Message-Id: <20260427181130.6A88DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: restructure the reclaim loop
has been removed from the -mm tree.  Its filename was
     mm-mglru-restructure-the-reclaim-loop.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: restructure the reclaim loop
Date: Fri, 24 Apr 2026 01:43:15 +0800

The current loop will calculate the scan number on each iteration.  The
number of folios to scan is based on the LRU length, with some unclear
behaviors, eg, the scan number is only shifted by reclaim priority when
aging is not needed or when at the default priority, and it couples the
number calculation with aging and rotation.

Adjust, simplify it, and decouple aging and rotation.  Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how aging and offline memcg reclaim works:
Previously, aging was skipped at DEF_PRIORITY even when eviction was no
longer possible, so the reclaimer wasted an iteration until the priority
escalated.  Now aging runs immediately whenever it is needed to make
progress; the DEF_PRIORITY skip only applies when eviction is still
viable.  This may avoid wasted iterations that over-reclaim slab and break
reclaim balance in multi-cgroup setups.

Similar for offline memcg.  Previously, offline memcg wouldn't be aged
unless it didn't have any evictable folios.  Now, we might age it if it
has only 3 generations and the reclaim priority is less than DEF_PRIORITY,
which should be fine.  On one hand, offline memcg might still hold
long-term folios, and in fact, a long-existing offline memcg must be
pinned by some long-term folios like shmem.  These folios might be used by
other memcg, so aging them as ordinary memcg seems correct.  Besides,
aging enables further reclaim of an offlined memcg, which will certainly
happen if we keep shrinking it.  And offline memcg might soon be no longer
an issue with reparenting.

Overall, the memcg LRU rotation, as described in mmzone.h, remains the
same.

Also apply a minimal batch factor when reclaim is running with higher
priority so small memcg won't be over protected.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-4-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   70 ++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

--- a/mm/vmscan.c~mm-mglru-restructure-the-reclaim-loop
+++ a/mm/vmscan.c
@@ -4913,49 +4913,41 @@ retry:
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     int swappiness, unsigned long *nr_to_scan)
+			     struct scan_control *sc, int swappiness)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
-	*nr_to_scan = 0;
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
+	/* try to avoid aging, do gentle reclaim at the default priority */
+	if (sc->priority == DEF_PRIORITY)
+		return false;
+
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
 
-/*
- * For future optimizations:
- * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
- *    reclaim.
- */
-static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
+			   struct mem_cgroup *memcg, int swappiness)
 {
-	bool need_aging;
-	unsigned long nr_to_scan;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
+	unsigned long nr_to_scan, evictable;
 
-	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
-		return -1;
-
-	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	evictable = lruvec_evictable_size(lruvec, swappiness);
+	nr_to_scan = evictable;
 
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
+	if (!mem_cgroup_online(memcg))
 		return nr_to_scan;
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	nr_to_scan >>= sc->priority;
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
+	if (!nr_to_scan && sc->priority < DEF_PRIORITY)
+		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
 
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4977,44 @@ static bool should_abort_scan(struct lru
 	return true;
 }
 
+/*
+ * For future optimizations:
+ * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
+ *    reclaim.
+ */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
+	bool need_rotate = false;
 	long nr_batch, nr_to_scan;
-	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	while (true) {
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	while (nr_to_scan > 0) {
 		int delta;
+		DEFINE_MAX_SEQ(lruvec);
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
-		if (nr_to_scan <= 0)
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+			need_rotate = true;
 			break;
+		}
+
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			/* stop scanning as it's low on cold folios */
+			break;
+		}
 
 		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
-		scanned += delta;
-		if (scanned >= nr_to_scan)
-			break;
-
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		nr_to_scan -= delta;
 		cond_resched();
 	}
 
@@ -5035,8 +5040,7 @@ static bool try_to_shrink_lruvec(struct
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

