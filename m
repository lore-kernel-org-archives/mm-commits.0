Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1A3C455B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439180; cv=none; b=hEKelhYm/AqZv5hKA8P8sHl14Q0B+u3uodj9mGKwjdkTMT/Pw8+LQC3Kxu18lxv2iDgaE8Hv0vXhQKphGKNo+qbmCyJN/g5ti72vz56cyCHhmXuzKCwdhv//AVsyYWR6YXNd/MQ5eJKb+Ed6Fmp+KXrZ18W8DJwgoTSZG7RM3ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439180; c=relaxed/simple;
	bh=70aQ5HToSb8ilnqe7EI3cGObCewaSBnhNI11/1oz9yI=;
	h=Date:To:From:Subject:Message-Id; b=JFeIILInPnfcFxLY6hXQfbk+paBHQTk7WM1kd2nF50Cx1QJnmqLStwKNaLPyfQzDWezipEN9eauYsgLnaB78iz4OGiWEaR7Xph3h12kggSXs3dc3ebyBfO66jFya561Ej5TtemOgTD0J8tgIjMbnlFTSznHScpOjqowi4VTVO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKVgpxSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKVgpxSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849591F00893;
	Tue,  2 Jun 2026 22:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439178;
	bh=xN12p+G4vZPPwcvpgacMXYstnVz8t6fn9PVv8cpMgNo=;
	h=Date:To:From:Subject;
	b=aKVgpxSCz8Wed1tkY0PS+5QtGkRz3PkFt5EDkKWGQyqGNcJnnUXcETjMzXyUU3+pw
	 Gkf7AAsbDn4fkl/EuvDhRWGP5HerkslHrhoKCNlyA3xAqVtKFYm1tLlScQ7uU0lu22
	 j3LOMxCkhQf07qOO6Yl0KgyyasJQamV4YvBboL/Q=
Date: Tue, 02 Jun 2026 15:26:18 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-restructure-the-reclaim-loop.patch removed from -mm tree
Message-Id: <20260602222618.849591F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: restructure the reclaim loop
has been removed from the -mm tree.  Its filename was
     mm-mglru-restructure-the-reclaim-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: restructure the reclaim loop
Date: Tue, 28 Apr 2026 02:06:55 +0800

The current loop will calculate the scan number on each iteration.  The
number of folios to scan is based on the LRU length, with some unclear
behaviors, e.g, the scan number is only shifted by reclaim priority when
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
has only 3 generations, which should be fine.  On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem.  These folios
might be used by other memcg, so aging them as ordinary memcg seems
correct.  Besides, aging enables further reclaim of an offlined memcg,
which will certainly happen if we keep shrinking it.  And offline memcg
might soon be no longer an issue with reparenting.

Overall, the memcg LRU rotation, as described in mmzone.h, remains the
same.

Note that because the scan budget is now pinned at loop entry, tiny lruvec
might skip this reclaim pass, also skipping aging, which could be
beneficial as aging is not helpful since it will still be un-reclaimable
after aging.  Reclaim will go on as usual once priority escalates.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-4-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   72 +++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

--- a/mm/vmscan.c~mm-mglru-restructure-the-reclaim-loop
+++ a/mm/vmscan.c
@@ -4917,49 +4917,37 @@ retry:
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
 
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
-		return nr_to_scan;
-
-	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
+	if (!mem_cgroup_online(memcg))
+		return evictable;
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
+	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
+	nr_to_scan >>= sc->priority;
 
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4989,31 +4977,44 @@ static bool should_abort_scan(struct lru
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
+
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+			need_rotate = true;
+			break;
+		}
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
-		if (nr_to_scan <= 0)
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			/* stop scanning as it's low on cold folios */
 			break;
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
 
@@ -5039,8 +5040,7 @@ static bool try_to_shrink_lruvec(struct
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from kasong@tencent.com are


