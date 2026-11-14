Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694255;
	b=jcwZzROkbHXwc+G4Uz2ABPoKOooldeqRo/NX4THKcaBIKJklqQVdlVyGEJKOKYKu7zZZ
	 jSCuqNuiMi5aRCfy7+rCThvljaAjcvS/YFagDI1VlIWkD5NRZ5T567ttAfl/E93xpEQSN
	 diGWWUcOGmSbAqtCs2vzB9FbnMCIHSCsa4zHRk5tGAX8PZI8CyJUInV/sFxBdcTTabFUx
	 ZR+WOiTeFhiFU0qkA6N8BY/j0kM4bw0IEWGTphN9yVBoDRH6xXssI+7Egh5oiiZOBQHAE
	 tEEXlVH9T8PQbTU9ztfk0DeGnRrb6++Q6zRpa8vl0b4bg+nDQbHWuKYnRp8v5yK3s5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694255;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rnF1vv0ppTnpXflhOpIfAnzZmcWV7Ub3Bi/oC7fduEk=;
	b=Ch/J0WSbYlIJ3N197rTz6GWVfWbpZwfHN4ieMA7AtavUgu0rS0yH6b1pVBG+DWu/YgMC
	 cvjyZgxiZLRsBs4F8NpY/Rs8k2BNdn9owUsuF+0IyxGG4cCOM0GIpoboJQPOCliKwR+CG
	 7LTDgJzTqMGEe3xrpzK6UzK4+G4wCtm/h00yiggF7E9NjHCPdg6zGpl4Ejxti2YuaLb2t
	 /abTV9uxA7b7SEox/6meOLJKZE7ORHz/PsMxAUbHZOBm2k4C/VxPbFlhzIV0KyUBfekPx
	 BN0KQBR9zD8iLp3756UIBeFi2proanDLrVHjGkMQ6trtEzdf0ryix20/VM7b1aGhn1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QMXe0cZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477BC606A327
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QMXe0cZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EE51F000C4;
	Sat, 14 Nov 2026 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694254;
	bh=rnF1vv0ppTnpXflhOpIfAnzZmcWV7Ub3Bi/oC7fduEk=;
	h=Date:To:From:Subject;
	b=QMXe0cZ6sRIfGJXiXfCCpI2wd9XChs3fmtLxxd25XrGJ9AiJctqGVXVPZBKqR7FG0
	 7rYj4z6JTx6s34OfEvStRVMM5qnCIenkTquYRcwCjeqpKCb+fjexhxgDul3s8U3Eed
	 Crw0lN8jyLpoZ9c/2MadYe/57r1P1cz9rorJpqhY=
Date: Sat, 14 Nov 2026 14:10:54 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-run-aging-when-one-type-is-drained.patch added to mm-new branch
Message-Id: <20261114221054.A4EE51F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: Run aging when one type is drained
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-run-aging-when-one-type-is-drained.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-run-aging-when-one-type-is-drained.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: Run aging when one type is drained
Date: Sun, 15 Nov 2026 04:07:58 +0800

We may have remaining scan budget for anon or file but no folios
in populatable generations to scan. In this case, `scan_folios()`
may repeatedly scan that type without making progress, even when
the other type still has populatable folios.

Run aging when a type is drained to make more folios available for
reclaim. This also helps honor the scan budget distribution
determined by swappiness.

Move aging after eviction to detect a lack of scan progress and
avoid unnecessary aging when eviction can still make progress.

To avoid excessive aging, allow drained aging only once per
`try_to_shrink_lruvec()` invocation. Also skip drained aging if
another reclaimer has advanced `max_seq` during eviction.

At extreme swappiness values such as 1 and 200, reclaim initially
focuses on the preferred type. Rely on imbalanced aging once
`sc->priority` reaches `DEF_PRIORITY / 2`, rather than triggering
drained aging for the unpreferred type. This avoids unnecessary
aging and has shown better performance in testing.

If `evict_folio_lists()` returns zero, retry eviction once if
`max_seq` has advanced since the aging decision.

Link: https://lore.kernel.org/20261114200803.23129-12-baohua@kernel.org
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

 mm/vmscan.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-mglru-run-aging-when-one-type-is-drained
+++ a/mm/vmscan.c
@@ -5175,7 +5175,8 @@ static bool should_abort_scan(struct lru
 }
 
 static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
-			     struct scan_control *sc, int swappiness, unsigned long max_batch)
+			     struct scan_control *sc, int swappiness,
+			     unsigned long max_batch, bool *drained)
 {
 	int type;
 	unsigned long batch, scanned, total_scanned = 0;
@@ -5191,6 +5192,8 @@ static long evict_folio_lists(unsigned l
 		batch = min(nr_to_scan[type], max_batch);
 		scanned = evict_folios(batch, lruvec, sc, type, swappiness);
 
+		if (drained && !scanned)
+			*drained = true;
 		nr_to_scan[type] -= min(nr_to_scan[type], scanned);
 		total_scanned += scanned;
 	}
@@ -5206,9 +5209,15 @@ static long evict_folio_lists(unsigned l
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[ANON_AND_FILE];
-	bool need_rotate = false, should_age = false;
+	bool need_rotate = false, should_age = false, retried = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging, unpreferred type at extreme swappiness;
+	 * rely on imbalanced aging once priority reaches AGING_PRIORITY
+	 */
+	bool allow_drained_age = sc->priority < DEF_PRIORITY &&
+		swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS;
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5226,22 +5235,17 @@ static bool try_to_shrink_lruvec(struct
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+		bool drained = false, do_drained_age;
 		DEFINE_MAX_SEQ(lruvec);
+		unsigned long new_seq;
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
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH, &drained);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5253,6 +5257,27 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		/*
+		 * Allow drained aging only once per invocation and skip it if
+		 * max_seq advanced concurrently during eviction
+		 */
+		new_seq = READ_ONCE(lruvec->lrugen.max_seq);
+		do_drained_age = drained && allow_drained_age && max_seq == new_seq;
+		allow_drained_age &= !do_drained_age;
+		if (do_drained_age || should_run_aging(lruvec, new_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+
+		if (!scanned) {
+			/* Retry once if aging advanced max_seq */
+			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
+				break;
+			retried = true;
+		}
+
 		cond_resched();
 	}
 
@@ -5885,7 +5910,7 @@ static int run_eviction(struct lruvec *l
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
-		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
+		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

