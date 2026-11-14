Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794693559;
	b=ztGUKF9tZl4CKtbevDkLFF4+GhCFOXfJQDqigVt14RlqibYNQeDSe38aHFEls1NpLajv
	 pZBd6jV3MJY8NLjpmkkDM9xu2DbGJCuUDTkAwQ7MQMr78nh9ffqJKl/8VQPwKHIux1Q62
	 JWCk0nqclZ4P6Kc3HM+0MOMut18lM95kjcuUfXI9G09UOXm9EVbuBoDyecZLJUQx2sekJ
	 ZA8vHgrGAvzjT7YcyAuBeUMMapzSZttQv3wkoqWv0jZ5I4+lDVliwdQAr2T5x5bOhEOMK
	 +96Lm7O3U3/UtJiIPhiun0UxXC0fwDwugcv0ATmX2/8unx/nxbIY9QJ351efrP6pZrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794693559;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ZHu0FKvPgyR2NuPJp3RICjbGrqXwCbfm2QZeN1iKetM=;
	b=OpLZer6Hh+knrNc/Ps15Fa+PdZxXhHykNzI1wJgcnGC1e4t413nySy6brDPFgrlHewM5
	 f20LETTKvq3GkkIfV2m2Zi1kaChz1qCehoKagDY5WXx6KH3GsGLt2sBKyk4x/WY/SS8I6
	 n5KpvyQA2Ju+NO7lw9xxiMVBWtzgdda+8t2IpCdkM55/PXRoHzl0NG5ZfLPwbgXAjTWkl
	 tlwNmEWDJsDSla775JGw6CxXgVOrxK/3ndHrzDUleI0To08cQWVI5ujykZoLy1QOCOsMf
	 KcN2qIOladw2IcrL9FuLKAezsLEwtL0kOXJSwsvKea9uET9/I+iWDCgghEMyr4GVRRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="YQMu/CUX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605FF606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 21:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YQMu/CUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D2A1F000C4;
	Sat, 14 Nov 2026 21:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794693559;
	bh=ZHu0FKvPgyR2NuPJp3RICjbGrqXwCbfm2QZeN1iKetM=;
	h=Date:To:From:Subject;
	b=YQMu/CUXgYFl73gIU1OiAJasGbCpMeO4kyzGeu8d4HTfhSgHR60DyhzifrhpEeMNM
	 /TnYKihfTQyCECLaLIIZ0jedIjVdz4t/4QoVJ+JyVbALkorlVPIueBirC48reo4TfF
	 UTLnoYXlI8Marz66MoFcE8LkZXDLQ5vi5KNXRthE=
Date: Sat, 14 Nov 2026 13:59:18 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch removed from -mm tree
Message-Id: <20261114215919.29D2A1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: run aging when one type has no populatable folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: run aging when one type has no populatable folios
Date: Sat, 14 Nov 2026 02:55:36 +0800

We may have scan budget remaining for anon or file but no folios in
populatable generations to scan.  In this case, `scan_folios()` may waste
time scanning that type while the other type still has populatable folios.

Run aging in this case to make more folios populatable.  This also helps
respect the scan budget distribution determined by swappiness.

To avoid excessive aging, allow no-populatable aging only once per
`try_to_shrink_lruvec()` invocation.

With extreme swappiness values such as 1 and 200, reclaim initially
focuses exclusively on the preferred type.  In this case, defer aging the
lagging type until `sc->priority` reaches `DEF_PRIORITY / 2`.  This avoids
unnecessary aging and has shown better performance in testing.

Link: https://lore.kernel.org/20261113185541.70203-12-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
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
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/vmscan.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-one-type-has-no-populatable-folios
+++ a/mm/vmscan.c
@@ -5109,7 +5109,8 @@ static bool lru_gen_imbalanced(struct lr
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     bool no_populatable)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5121,6 +5122,13 @@ static bool should_run_aging(struct lruv
 	if (sc->priority == DEF_PRIORITY)
 		return false;
 
+	/*
+	 * Run aging if scan budget remains but no folios
+	 * in populatable generations are available to scan.
+	 */
+	if (no_populatable)
+		return true;
+
 	/* better to run aging even though eviction is still possible */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
 		return true;
@@ -5208,6 +5216,13 @@ static bool try_to_shrink_lruvec(struct
 	bool need_rotate = false, should_age = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging type under extreme swappiness,
+	 * as reclaim of the unpreferred type is disabled until
+	 * DEF_PRIORITY / 2.
+	 */
+	bool allow_no_populatable_age = (sc->priority <= DEF_PRIORITY / 2) ||
+		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5225,22 +5240,19 @@ static bool try_to_shrink_lruvec(struct
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
-		DEFINE_MAX_SEQ(lruvec);
+		unsigned long orig_file, orig_anon;
+		unsigned long max_seq;
+		bool no_populatable;
+		long scanned;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
-				need_rotate = true;
-			should_age = true;
-		}
-
-		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
-			break;
+		orig_anon = nr[LRU_GEN_ANON];
+		orig_file = nr[LRU_GEN_FILE];
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5252,6 +5264,21 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
+		no_populatable = allow_no_populatable_age &&
+			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file));
+		allow_no_populatable_age &= !no_populatable;
+		max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+		if (!scanned)
+			break;
+
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

