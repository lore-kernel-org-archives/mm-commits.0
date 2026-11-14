Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693556;
	b=CHKo6ElD681wf/PSCYnbnxJ1K7CExW6q3HmBNnRVpuAXcIKjbQ3s1to1RMxEIVHSE+Pp
	 2ZC4rU5eoWwPsBmaglEU6BFf9zCr9/eg6f00o8VH67eWN4NwP27+7Lz0Ip+Q4jhkeVd5l
	 Ufme3NmH8Z/CjZAQjbWqgQuKkUCZn7XLsM/nSqxnl6KWgqA75Tqq8z7GFu/sbA6a6FQbV
	 Besygx8AqqpMzdWoepdTvplcrFaWoC25SIPT5mA+BFF/VExOTGa+aUUYxOh9ikj/OnaF1
	 KxW8jxnisVNcXLGEJSFAaUbI3rtC5LarihOLi0dbFfqkJBTmP9cVG4Av0Fcr90L5aaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693556;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KqgOrtNPDZiLTeQ66Os7KSP10pU5q7Mo76X8d2qBoyc=;
	b=J/Ci8CN6rRunDvNGS37MkseT3eq6zW7R6or7XhmDnKrx6xK1dgAO2mZTnRmIenTEHp9e
	 immv3johooy04zFiJ4vGiraT8vWi54v3jY/BT+2fMQdp6V2v6UURLab1rQU2qM1DIpXZ2
	 NSc1JdWnHMq4FbEtsMaR/Xi4krzNOEGhP8ZnDWbYf/PheDgUg3ZjJNlkb/tS4ChHcMKYf
	 4rGeZe197NmCPp6KMvBwLyLRHodlAgBVFn6a78CWW0jllZcZutsFu93ywfGRQDoVRU9px
	 IZa3BxK2T0arRLV3J17uKyKWRNhcd3IYx0APDgGmMk5/Zo49kBZrgno97P5BLMOSU0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IYzNJKzL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0306606A329
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IYzNJKzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C071F000C4;
	Sat, 14 Nov 2026 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693556;
	bh=KqgOrtNPDZiLTeQ66Os7KSP10pU5q7Mo76X8d2qBoyc=;
	h=Date:To:From:Subject;
	b=IYzNJKzLaOuy07boJW0PCHFU8Jq75WQGB9YDU82GyUwUm9nWr2IYNjXSXGpKZCJkj
	 A0EWqRN4pU9aMoIdqr9YcDrobT2/S8xd7eoroOAf7lfGE1wpDquTmK68smTe/pVdFL
	 oebB4DfQg3S0luvPoBNcYBrUQMRIensl10/SUHvs=
Date: Sat, 14 Nov 2026 13:59:15 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch removed from -mm tree
Message-Id: <20261114215916.09C071F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: avoid placing rejected folios below populated gen
has been removed from the -mm tree.  Its filename was
     mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: avoid placing rejected folios below populated gen
Date: Sat, 14 Nov 2026 02:55:34 +0800

We used to scan only the oldest generation in scan_folios().  In
evict_folios(), we checked whether lru_gen_folio_seq(lruvec, folio, false)
== min_seq[type].  If so, the folio was marked active and moved to younger
generations.

This was itself buggy, as folios in generation min_seq[type] - 1 would not
be marked active by folio_set_active(), potentially causing a cold/hot
inversion.

Besides this issue, the old approach also differs from the current
behavior, where we can scan fewer than two generations.  Now that we can
scan younger generations, including the youngest generation, this no
longer prevents rejected folios from being placed in a generation below or
at the populated generation.  Such rejected folios would then be scanned
again and again, resulting in extremely low `pg_steal/pg_scan` ratios. 
For example:
  pgsteal_file: 2312605
  pgscan_file:  36465693
  reclamation efficiency: 6.34%

We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
promote the folio or place it in the youngest generation when the
populated generation is already the youngest one.  Also,
folio_set_active() is no longer needed.

With this change, the results become:
  pgsteal_file: 2683815
  pgscan_file:  4224244
  reclamation efficiency: 63.53%

The sys time for building the kernel also decreased from 4m30.532s to
3m50.188s while swappiness==1.

Link: https://lore.kernel.org/20261113185541.70203-10-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: wang lian <lianux.mm@gmail.com>
Cc: <liuxiang.277@bytedance.com>
Cc: <lyugaofei@xiaomi.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Bo Zhang <zhangbo56@xiaomi.com>
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 include/linux/mm_inline.h |   22 +++++++++++++++++++++-
 mm/vmscan.c               |   24 ++++++++++++------------
 2 files changed, 33 insertions(+), 13 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-avoid-placing-rejected-folios-below-populated-gen
+++ a/include/linux/mm_inline.h
@@ -332,7 +332,8 @@ static inline unsigned long lru_gen_foli
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq, bool reclaiming)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(str
 		return false;
 
 	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
+	if (scanned_seq != -1UL)
+		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -362,6 +365,17 @@ static inline bool lru_gen_add_folio(str
 	return true;
 }
 
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
+}
+
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
+}
+
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	unsigned long flags;
@@ -419,6 +433,12 @@ static inline bool lru_gen_add_folio(str
 {
 	return false;
 }
+
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return false;
+}
 
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
--- a/mm/vmscan.c~mm-mglru-avoid-placing-rejected-folios-below-populated-gen
+++ a/mm/vmscan.c
@@ -1865,7 +1865,8 @@ static bool too_many_isolated(struct pgl
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
+static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
+		bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -1922,7 +1923,7 @@ static unsigned int move_folios_to_lru(s
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else
+		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -2041,7 +2042,7 @@ static unsigned long shrink_inactive_lis
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list, true);
+	move_folios_to_lru(&folio_list, -1UL, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2152,8 +2153,8 @@ static void shrink_active_list(unsigned
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active, false);
-	nr_deactivate = move_folios_to_lru(&l_inactive, false);
+	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -4753,7 +4754,8 @@ static bool isolate_folio(struct lruvec
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       unsigned long *scanned_seq)
 {
 	enum node_stat_item item;
 	int zone_idx;
@@ -4784,6 +4786,7 @@ static int scan_folios(unsigned long nr_
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
@@ -4980,6 +4983,7 @@ static int evict_folios(unsigned long nr
 	int tier, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
+	unsigned long scanned_seq;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4991,7 +4995,7 @@ static int evict_folios(unsigned long nr
 
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, &list, &isolated);
+			      type, tier, &list, &isolated, &scanned_seq);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -5017,8 +5021,6 @@ retry:
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
 		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
 		if (!folio_evictable(folio))
 			continue;
@@ -5037,11 +5039,9 @@ retry:
 		 * so this effectively promotes them by at least one generation.
 		 */
 		folio_set_lru_refs(folio, 0);
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list, false);
+	move_folios_to_lru(&list, scanned_seq, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

