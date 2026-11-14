Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794694259;
	b=eeWWSA0oXjmzJBg0OFZH1lqxhNsgNtL3yWb3nOlrIo72JcHCPNrwQVWRdjPo4Fzm21dA
	 vSfaPov11VIovkXVaDdU9ADX+BSQ+6WAbt4WFI3YvbhsT0EAUvhA628XhwMyb3Ix2PFRJ
	 zffJmROttWZFmtKB/sNaV65VXYcSM/v/JMEFa5VSuXWjnErRTGCYvfJ0myFf3Jinm9HRt
	 GoRr76zk6O8W26G1R8TwFSTBwVgn/uoXc9GyE1YgGYWQAXrm6Ovr7TrFG5UAZap7R/bJB
	 XhNO3MK26NiUqJSv0ehjaRkhRtdX25F5ddlCgDBbEvtEI2cyoECfn7adCMwUC3RY8hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794694259;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=USJchwg/G8VhxpafafCNLghAGz3skECn7beQNjVA7l4=;
	b=SJrwPcwCh0hYwGyI/5WOCsDTi7Gum5iERxEIGYB+ZzHs03WWaNArjhj7fsC0di7V+1ud
	 suQ0iVckkEjYRAOygN3R1rwHkzD8aCP4lD7FPTbiAMPN4CIH3EI9e0C+9Pqq4gx3ds+mw
	 QasqhlyF8OzvuPwVMBDCrnwjWpfOCCgeLvp8JOqaAoCnXGeGWH+w88e0xS/LgpfkdSpXi
	 ThEoocNvofEAPMK5xiJev2PRf9EC8M52pXKPFAuBOOucwW48Zudq4a5ZcHN63LJfMzSTJ
	 5eKpECUfAB0BKEQkMJaBp+64VfphKvuerMAxrHLJdDXdT6iUwNHHgyES7DuSJqyv5Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vGQv5+H9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780EA606A329
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 22:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vGQv5+H9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AE21F000C4;
	Sat, 14 Nov 2026 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694259;
	bh=USJchwg/G8VhxpafafCNLghAGz3skECn7beQNjVA7l4=;
	h=Date:To:From:Subject;
	b=vGQv5+H9HuAss/JPOBsQXNqzvGH8O6b9xKnjbrlYPhgN3WUs/eCBDucZWlfkbCdTM
	 qM2ogu1KT83CHclcWbdX5rTRhAugAQodLaKTtMlJPdaC6imwn+R8njYb9D80tRie4J
	 KRIcePVGajnSI9jBQfPGu8ahNvaHpVm99iJPGX/4=
Date: Sat, 14 Nov 2026 14:10:58 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch added to mm-new branch
Message-Id: <20261114221059.41AE21F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: Restrict eviction accounting to eligible zones
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
Subject: mm/mglru: Restrict eviction accounting to eligible zones
Date: Sun, 15 Nov 2026 04:07:59 +0800

For both lruvec_evictable_size() and lru_gen_imbalanced(),
only count eligible zones up to sc->reclaim_idx. This avoids
overestimating the number of pages available for scanning and
allows aging to proceed more promptly when eligible zones
contain few folios.

lru_gen_age_node() uses lruvec_is_reclaimable() to determine
whether any memcg has generations old enough to reclaim under
min_ttl. If none are reclaimable, it may trigger OOM. However,
lruvec_is_reclaimable() also uses lruvec_is_sizable() to
estimate the LRU size.

Previously, lruvec_is_sizable() counted folios across all zones.
With accounting now restricted to zones up to sc->reclaim_idx,
the estimated size may be significantly smaller, potentially
leading to premature OOM.

To avoid this and simplify the implementation, allow
lru_gen_age_node() to count folios from all zones.

Note that min_ttl currently has several issues and does not
work as expected.

First, reclaim does not enforce min_ttl on a per-memcg basis,
so folios from memcgs whose generations are all younger than
min_ttl can still be reclaimed.

Second, the LRU size check is coupled with the min_ttl check,
which can lead to premature OOM. For example, consider a system
with 100 memcgs, each containing fewer than 16 MB of evictable
folios. At priority 12, shifting each memcg's LRU size by
sc->priority can yield zero, causing all memcgs to be considered
unreclaimable even if their generations are older than min_ttl.

These issues should be addressed in a separate patch series
rather than as part of this eviction accounting change.

Link: https://lore.kernel.org/20261114200803.23129-13-baohua@kernel.org
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

 mm/trace_vmscan.h |    4 ++--
 mm/vmscan.c       |   27 +++++++++++++++------------
 mm/vmscan.h       |    7 ++++---
 3 files changed, 21 insertions(+), 17 deletions(-)

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
@@ -4207,8 +4207,9 @@ static void set_initial_priority(struct
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[],
+				  int max_zone)
 {
 	int type;
 	unsigned long seq;
@@ -4221,16 +4222,17 @@ static void lruvec_evictable_size(struct
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
 	}
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc,
+		int max_zone)
 {
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes, max_zone);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4249,7 +4251,8 @@ static bool lruvec_is_reclaimable(struct
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	if (!lruvec_is_sizable(lruvec, sc))
+	/* counting all zones to avoid premature OOM */
+	if (!lruvec_is_sizable(lruvec, sc, MAX_NR_ZONES))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -5102,9 +5105,9 @@ static bool lru_gen_imbalanced(struct lr
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5139,7 +5142,7 @@ static void lru_gen_prepare_scan(struct
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5326,7 +5329,7 @@ static int shrink_one(struct lruvec *lru
 	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc, sc->reclaim_idx + 1))
 		return 0;
 
 	/* one retry if too small */
@@ -5856,7 +5859,7 @@ static int lru_gen_seq_show(struct seq_f
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
@@ -5909,7 +5912,7 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
--- a/mm/vmscan.h~mm-mglru-restrict-eviction-accounting-to-eligible-zones
+++ a/mm/vmscan.h
@@ -117,14 +117,15 @@ struct scan_control {
 };
 
 #ifdef CONFIG_LRU_GEN
-/* The number of pages of @type in the generation @seq, summed over all zones */
+/* Number of pages of @type in generation @seq below @max_zone */
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
mm-mglru-run-aging-when-one-type-is-drained.patch
mm-mglru-run-aging-when-one-type-is-drained-fix.patch
mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

