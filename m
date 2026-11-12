Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446235;
	b=kpB2XSz4+4HgXqU1SoxRDjsdGOXk/eDyLLD71CLi1LVvUi9pqe+u2eQmVcVvMwS3K/tW
	 XcJSM+Zr6uEM5fYfzrMax2nYqkCDDmXc4tD62+nKai4romx8pq5DropPyiqXId3D6j9Qv
	 fXgREahXf1DAtP6xjNeaZPxfZfrptUNLQQW/mOocTpUjK8cudHxyJzW92UjTlw7FxbwFe
	 Tn8yRKnI8OHsHGukpCud0p/ucgKzxCmY+bddvDb0uRomqNW6yw/wc51eVTCQbhZgXRQ3v
	 MaxZDDKf1CKImuwD6nKsOLbozO70rhKeabmyF9qmx8naW6ENgtsn1CScIhq0hOIL/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446235;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CCykUGsTkl/Ka0xHQkgCmeTYJq3Gtx1oXkgnfPLCS1o=;
	b=ROK6B84+8wZeCaEPFqDHsxr2H1je1cBt6NFA08wT5J3TH0LakYCkW4nx+f/4wm4Scpc5
	 CJvYFULqkZrZeiy+0PsyGZFJGtZLcQxripZtUNPGd/ZytKft4EySDMxUvbj+gpvd/yzuq
	 cX6bwGAfXhwXPeHQyoqQKeYEW0Sa3sVZNhorosi9Ogow5yXSHl5eh4YXbVsJ2tpgIgWST
	 Xy/NOQejPan2EbwEuL0s5i3i61m0lp0zurV7CZkyoCD9HJbzQcu9hVIPHJ9/o/IrKj+x6
	 YeF3oUJdZBZTiTe8wiC0zuyOBeiQbsudqmPX74YK3xkLuCTICKB4an3ZJivY7Hw96ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="biDun/u1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A583606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=biDun/u1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279DB1F00A05;
	Thu, 12 Nov 2026 01:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794446235;
	bh=CCykUGsTkl/Ka0xHQkgCmeTYJq3Gtx1oXkgnfPLCS1o=;
	h=Date:To:From:Subject;
	b=biDun/u1wPYl7zQM4i6FFpgn9mDOGAqWcmZbiRNyKW7oXrgAsFLwOgVXFNU8e5paA
	 vJ03Wauk3psBppAPmxjUbNADRzRg87nKw6rUAG+NMWHmJWj5NU7g86Tzp/jfshKd/h
	 y7Lp5mWqCAYro4Uubf4jFOApHRsnF/jGW3HUDqOo=
Date: Wed, 11 Nov 2026 17:17:14 -0800
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,zhangbo56@xiaomi.com,
	yuanchu@google.com,weixugc@google.com,wangzicheng@honor.com,
	surenb@google.com,sidchintamaneni@gmail.com,shakeel.butt@linux.dev,
	ryncsn@gmail.com,rppt@kernel.org,ridong.chen@linux.dev,qi.zheng@linux.dev,
	mhocko@suse.com,lyugaofei@xiaomi.com,liuxiang.277@bytedance.com,
	lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,
	hui.zhu@linux.dev,hannes@cmpxchg.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch added to mm-new branch
Message-Id: <20261112011715.279DB1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: balance anon and file scan budget by refault rate
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: balance anon and file scan budget by refault rate
Date: Thu, 12 Nov 2026 07:25:54 +0800

Replace get_type_to_scan() and isolate_folios(), which selected one
type per batch, with a proportional split of the scan budget between
anon and file, and scan both types each round.

lru_gen_balance_scan() splits the total by

        anon : file = swappiness * r_file * w_anon :
                      (MAX_SWAPPINESS - swappiness) * r_anon * w_file

where r_anon and r_file are the per-type refault rates scaled by
4096, clamped to [1, 4096]; a rate at the 4096 ceiling means the type
refaults at least as often as it is evicted. The w factors bias the
split toward the LRU sizes at mild swappiness and follow the IO cost
ratio at the extremes. Both rate accumulators start at MIN_LRU_BATCH,
so a type without eviction history reads as 100% until evictions
accumulate, and the floor of 1 keeps a type that never refaults from
zeroing out the other type's share. Swappiness 0 and
SWAPPINESS_ANON_ONLY keep their single-type behavior; at swappiness ==
MAX_SWAPPINESS the file factor is zero, so anon gets the whole budget,
as in the classical LRU; swappiness 1 no longer forces file-only
scanning as the old code did.

The proportional protection and priority reduction are applied to the
total once, before the split, and each budget is capped at its type's
evictable size. Regular reclaim derives the total from the evictable
sizes, so the budgets sum to it. The proactive path re-splits the
remaining target each round, so eviction keeps working while either
type makes progress, until the target is met or no progress is
possible. The debugfs scan_control gets .priority = DEF_PRIORITY so
eviction starts from the oldest gen and reports the default priority
in the tracepoints.

Link: https://lore.kernel.org/20261111232603.9934-8-baohua@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: lyugaofei <lyugaofei@xiaomi.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---

 mm/vmscan.c |  226 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 141 insertions(+), 85 deletions(-)

--- a/mm/vmscan.c~mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate
+++ a/mm/vmscan.c
@@ -4865,79 +4865,110 @@ static int get_tier_idx(struct lruvec *l
 	return tier - 1;
 }
 
-static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
+/*
+ * Balance the anon vs file scan budget using MGLRU's per-type refault
+ * rates, where swappiness is the relative IO cost of anon vs file (see
+ * Documentation/admin-guide/sysctl/vm.rst).
+ *
+ * On entry, nr[] holds the evictable size of each type, on return it
+ * holds each type's scan budget, bounded by its evictable size.
+ *
+ * LRU lock not needed: a stale snapshot merely skews the split for one pass,
+ * and MGLRU aging averages the fault rate so we can simply read it, no need
+ * to do any extra work here. If reclaim is blocked by unfair type hotness or
+ * stall aging, the priority will raise and a raised priority drives the
+ * aging.
+ *
+ * Calculation is basically based on following formula with a LRU size bias:
+ *
+ * anon : file = swappiness * r_file * w_anon :
+ *               (MAX_SWAPPINESS - swappiness) * r_anon * w_file
+ *
+ * r_file / r_anon: refault rate for file / anon.
+ * w_file / w_anon: LRU size weight of file / anon.
+ *
+ * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
+ * cancel the scan budget natually.
+ */
+static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
+		unsigned long total_scan, unsigned long nr[])
 {
-	struct ctrl_pos sp, pv;
-
-	if (swappiness <= MIN_SWAPPINESS + 1)
-		return LRU_GEN_FILE;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
+	u64 anon_scan, file_scan, total;
+	u64 anon_weight, file_weight;
+	int size_bias;
 
-	if (swappiness >= MAX_SWAPPINESS)
-		return LRU_GEN_ANON;
-	/*
-	 * Compare the sum of all tiers of anon with that of file to determine
-	 * which type to scan.
-	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
-		      swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
-		      MAX_SWAPPINESS - swappiness, &pv);
+	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
+	if (!total)
+		return;
 
-	return positive_ctrl_err(&sp, &pv);
-}
+	if (swappiness <= MIN_SWAPPINESS) {
+		nr[LRU_GEN_ANON] = 0;
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
+		return;
+	}
 
-static inline bool is_single_type_reclaim(int swappiness)
-{
-	return swappiness == MIN_SWAPPINESS ||
-	       swappiness == SWAPPINESS_ANON_ONLY;
-}
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		nr[LRU_GEN_FILE] = 0;
+		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		return;
+	}
 
-static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
-			  struct scan_control *sc, int swappiness,
-			  struct list_head *list, int *isolated,
-			  int *isolate_type, int *isolate_scanned)
-{
-	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
-	int type = get_type_to_scan(lruvec, swappiness);
-	int total_scanned = 0, scanned, tier;
-	bool tried = false;
+	for (int type = LRU_GEN_ANON; type <= LRU_GEN_FILE; type++) {
+		int hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
+		/* start at MIN_LRU_BATCH to smooth the rate on gen start */
+		u64 refaulted = MIN_LRU_BATCH, evicted = MIN_LRU_BATCH;
+
+		for (int tier = 0; tier < MAX_NR_TIERS; tier++) {
+			refaulted += READ_ONCE(lrugen->avg_refaulted[type][tier]);
+			refaulted += atomic_long_read(&lrugen->refaulted[hist][type][tier]);
 
-retry:
-	tier = get_tier_idx(lruvec, type);
-	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, list, isolated);
+			evicted += READ_ONCE(lrugen->avg_total[type][tier]);
+			evicted += atomic_long_read(&lrugen->evicted[hist][type][tier]);
+		}
 
-	total_scanned += scanned;
-	if (*isolated) {
-		*isolate_type = type;
-		*isolate_scanned = scanned;
-		return total_scanned;
+		/*
+		 * The rate scaled by 4096 to survive integer division, clamped
+		 * to [1, 4096] (~0% - 100%), the floor of 1 keeps a type that
+		 * never refaults from zeroing out the other type's share.
+		 */
+		refault_rate[type] = mul_u64_u64_div_u64(refaulted, 4096, evicted);
+		refault_rate[type] = clamp_t(u64, refault_rate[type], 1, 4096);
 	}
 
 	/*
-	 * We are running out of the current reclaim type. Fall back to
-	 * the other type if allowed.
+	 * The more extreme the swappiness, the wider the IO cost gap between
+	 * anon and file, so the split should follow the IO cost ratio rather
+	 * than the sizes. With a mild swappiness, balance the scan by the
+	 * actual LRU size more.
 	 */
-	if (!scanned && !tried && type_fallback_allowed) {
-		type = !type;
-		tried = true;
-		type_fallback_allowed = false;
-		goto retry;
-	}
+	size_bias = max(1, min(swappiness, MAX_SWAPPINESS - swappiness));
+	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
+	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
+
+	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+
+	/* Cross-multiply the ratio above. */
+	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
+	file_scan = (u64)total_scan - anon_scan;
+
 	/*
-	 * We scanned some folios but failed to isolate any due to promotions,
-	 * protections, or races. Retry once to avoid a larger loop.
+	 * Bound each type by its evictable size. Hand the exceeding part to
+	 * the other type. Any excess left when total_scan exceeds both sizes
+	 * is dropped, since it only stresses the scanner with no gain.
 	 */
-	if (scanned && !tried) {
-		tried = true;
-		goto retry;
-	}
-
-	return total_scanned;
+	if (anon_scan > nr[LRU_GEN_ANON])
+		file_scan += anon_scan - nr[LRU_GEN_ANON];
+	else if (file_scan > nr[LRU_GEN_FILE])
+		anon_scan += file_scan - nr[LRU_GEN_FILE];
+	nr[LRU_GEN_ANON] = min_t(u64, anon_scan, nr[LRU_GEN_ANON]);
+	nr[LRU_GEN_FILE] = min_t(u64, file_scan, nr[LRU_GEN_FILE]);
 }
 
 static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
-			struct scan_control *sc, int swappiness)
+			struct scan_control *sc, int type, int swappiness)
 {
 	LIST_HEAD(list);
 	LIST_HEAD(clean);
@@ -4946,8 +4977,8 @@ static int evict_folios(unsigned long nr
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
-	int scanned, reclaimed;
-	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	int tier, scanned, reclaimed;
+	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -4958,8 +4989,9 @@ static int evict_folios(unsigned long nr
 	/* In case folio deletion left empty old gens, flush them */
 	try_to_inc_min_seq(lruvec, swappiness);
 
-	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
-				 &list, &isolated, &type, &type_scanned);
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, &list, &isolated);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -4981,7 +5013,7 @@ retry:
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			type_scanned, reclaimed, &stat, sc,
+			scanned, reclaimed, &stat, sc,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
@@ -5058,18 +5090,18 @@ static bool should_run_aging(struct lruv
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
 
-static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-			   struct mem_cgroup *memcg, int swappiness)
-{
-	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
-
-	lruvec_evictable_size(lruvec, swappiness, sizes);
-	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
-
-	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
-	nr_to_scan >>= sc->priority;
-
-	return nr_to_scan;
+static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
+		struct mem_cgroup *memcg, int swappiness,
+		unsigned long nr_to_scan[])
+{
+	unsigned long total;
+
+	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
+
+	total = apply_proportional_protection(memcg, sc, total);
+	total >>= sc->priority;
+	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5102,6 +5134,30 @@ static bool should_abort_scan(struct lru
 	return true;
 }
 
+static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
+			     struct scan_control *sc, int swappiness, unsigned long max_batch)
+{
+	int type;
+	unsigned long batch, scanned, total_scanned = 0;
+
+	/*
+	 * Scan both types with the given budgets; the caller checks if
+	 * reclaim is satisfied after each pass.
+	 */
+	for (type = LRU_GEN_FILE; type >= LRU_GEN_ANON; type--) {
+		if (!nr_to_scan[type])
+			continue;
+
+		batch = min(nr_to_scan[type], max_batch);
+		scanned = evict_folios(batch, lruvec, sc, type, swappiness);
+
+		nr_to_scan[type] -= min(nr_to_scan[type], scanned);
+		total_scanned += scanned;
+	}
+
+	return total_scanned;
+}
+
 /*
  * For future optimizations:
  * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
@@ -5109,8 +5165,8 @@ static bool should_abort_scan(struct lru
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
+	unsigned long nr[ANON_AND_FILE];
 	bool need_rotate = false, should_age = false;
-	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
@@ -5127,9 +5183,9 @@ static bool try_to_shrink_lruvec(struct
 			return false;
 	}
 
-	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
-	while (nr_to_scan > 0) {
-		int delta;
+	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
+
+	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
 		DEFINE_MAX_SEQ(lruvec);
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
@@ -5144,9 +5200,7 @@ static bool try_to_shrink_lruvec(struct
 			should_age = true;
 		}
 
-		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
-		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
-		if (!delta)
+		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
 			break;
 
 		if (should_abort_scan(lruvec, sc))
@@ -5159,7 +5213,6 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
-		nr_to_scan -= delta;
 		cond_resched();
 	}
 
@@ -5771,8 +5824,8 @@ static int run_aging(struct lruvec *lruv
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
-	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
+	unsigned long nr_to_scan[ANON_AND_FILE];
 
 	if (seq + MIN_NR_GENS > max_seq)
 		return -EINVAL;
@@ -5788,8 +5841,11 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
-		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
+		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lru_gen_balance_scan(lruvec, swappiness,
+				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
+
+		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch

