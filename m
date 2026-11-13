Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600350;
	b=NQ4z5oVCwBiPMkf4xYtteOUyfxUbM2o8k7BMVB/SHru5SbJaJgsdRQKFL63TC9oubhaj
	 j6/6MwUPNgirEJ5ohkGM9EKHXTU7H2hU1fT+V97dDRQNdDqQdAg1on8qHG/wEC7Xt06ji
	 GGQGsCcUwbgNNv+JO26e2bj2UolqGhy19SQZ9EjlpbW0SXflVY88X30ad6v7D9ROSJi2q
	 7PMWcF/XXjoBQSJ19MX7s/BIj1J1+PeJ+OAWT3WxtYvdA+ld9dOEKPyupj2l3cN/qwpR6
	 dT+qkQRYzFLtKo3WWcnGCU3QyLU67OeSHmPuzk7yWQdyw930hqeXVIJhM+AUEhM7LVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600350;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tIspqABVcb8PMzyhpP3LqmaOlddJNnGLKNqPk7v7wTQ=;
	b=ll3WLj2LzmkJDU4jCfPOlHgXpqm9GM76faoak0US/F0pTbsYEC8n4eNxvJQGi2RgWw56
	 f/JrARgCILy6pwTkR2mWEr3kfFzXcXl4xUp/gR2i3XSa8iKxDOGX9zcvZVHTj4teHXwSI
	 6+PIfWK0pdahqpev60Ca973P+mjkEUXERi6uzzfT3vJZDnxSUGezALAS68MCwlAvEd2iJ
	 E77a1WbKLvLlOTa8SLOlYayp+GzYRGBkwIioaeNl6BVY6pBelX1TPI0lPjhE+muk/LGX3
	 YfUlE9yOiyIQXf07J2XERdgS2m97GKY9MGJjwBsMP+ADYvpYenvYYwnXt1ORjqK/hHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q7NFK+Fi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBABA606A335
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 20:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Q7NFK+Fi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572391F000C4;
	Fri, 13 Nov 2026 20:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794600350;
	bh=tIspqABVcb8PMzyhpP3LqmaOlddJNnGLKNqPk7v7wTQ=;
	h=Date:To:From:Subject;
	b=Q7NFK+FiYJMjLUEKPAVSgd6Kbdg413JHtoQkM8NqclHOEJTprLWnf5QtgHWtbvcGU
	 S1hUVe1AbHGqUED7L/PnKkj2jDipmBcc9l5SNlb7kk763VZ88gNiHDqSKkU7wG8KLg
	 nU86MbVmzDKkEJy2tDZWMDiKoMLz2y9hZumFw3+8=
Date: Fri, 13 Nov 2026 12:05:49 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch added to mm-new branch
Message-Id: <20261113200550.572391F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: restrict eviction accounting to eligible zones
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch

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
Subject: mm/mglru: restrict eviction accounting to eligible zones
Date: Sat, 14 Nov 2026 02:55:37 +0800

For both lruvec_evictable_size() and lru_gen_imbalanced(), only count
eligible zones up to sc->reclaim_idx.  This avoids overestimating the
number of pages available for scanning and allows aging to proceed more
promptly when eligible zones contain few folios.

lru_gen_age_node() uses lruvec_is_reclaimable() to determine whether any
memcg has generations old enough to reclaim under min_ttl.  If none are
reclaimable, it may trigger OOM.  However, lruvec_is_reclaimable() also
uses lruvec_is_sizable() to estimate the LRU size.

Previously, lruvec_is_sizable() counted folios across all zones.  With
accounting now restricted to zones up to sc->reclaim_idx, the estimated
size may be significantly smaller, potentially leading to premature OOM.

To avoid this, skip the sizing check when reclaim is restricted to zones
below ZONE_NORMAL.  As in __alloc_pages_may_oom(), triggering OOM for
low-zone allocations is generally pointless.

Furthermore, defer the sizing check until reclaim reaches a very low
sc->priority to reduce the risk of premature OOM.

Link: https://lore.kernel.org/20261113185541.70203-13-baohua@kernel.org
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
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
Cc: Hui Zhu <zhuhui@kylinos.cn>
Cc: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Bo Zhang <zhangbo0325@gmail.com>
---

 mm/trace_vmscan.h |    4 ++--
 mm/vmscan.c       |   26 ++++++++++++++++----------
 mm/vmscan.h       |    5 +++--
 3 files changed, 21 insertions(+), 14 deletions(-)

--- a/mm/trace_vmscan.h~mm-mglru-restrict-eviction-accounting-to-eligible-zones
+++ a/mm/trace_vmscan.h
@@ -488,9 +488,9 @@ TRACE_EVENT(mm_mglru_aging,
 			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
 
 			__entry->nr_anon[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq, MAX_NR_ZONES);
 			__entry->nr_file[i] =
-				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq, MAX_NR_ZONES);
 		}
 		__entry->nid = lruvec_pgdat(lruvec)->node_id;
 		__entry->priority = sc->priority;
--- a/mm/vmscan.c~mm-mglru-restrict-eviction-accounting-to-eligible-zones
+++ a/mm/vmscan.c
@@ -4205,8 +4205,8 @@ static void set_initial_priority(struct
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[])
 {
 	int type;
 	unsigned long seq;
@@ -4219,7 +4219,7 @@ static void lruvec_evictable_size(struct
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 }
 
@@ -4228,7 +4228,7 @@ static bool lruvec_is_sizable(struct lru
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4247,7 +4247,13 @@ static bool lruvec_is_reclaimable(struct
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	if (!lruvec_is_sizable(lruvec, sc))
+	/*
+	 * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
+	 * allocations. Also, defer the LRU size check until reclaim reaches
+	 * a very low priority to avoid premature OOM.
+	 */
+	if (sc->priority <= 1 && sc->reclaim_idx >= ZONE_NORMAL &&
+	    !lruvec_is_sizable(lruvec, sc))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -5088,9 +5094,9 @@ static bool lru_gen_imbalanced(struct lr
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5143,7 +5149,7 @@ static void lru_gen_prepare_scan(struct
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5854,7 +5860,7 @@ static int lru_gen_seq_show(struct seq_f
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
@@ -5907,7 +5913,7 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
--- a/mm/vmscan.h~mm-mglru-restrict-eviction-accounting-to-eligible-zones
+++ a/mm/vmscan.h
@@ -119,12 +119,13 @@ struct scan_control {
 #ifdef CONFIG_LRU_GEN
 /* The number of pages of @type in the generation @seq, summed over all zones */
 static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
-					    int type, unsigned long seq)
+					    int type, unsigned long seq,
+					    int max_zone)
 {
 	int gen = lru_gen_from_seq(seq);
 	unsigned long size = 0;
 
-	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+	for (int zone = 0; zone < max_zone; zone++)
 		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch
mm-mglru-avoid-placing-rejected-folios-below-populated-gen.patch
mm-mglru-run-aging-when-one-type-has-no-populatable-folios.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

