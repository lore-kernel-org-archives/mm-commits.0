Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598881;
	b=TO4jpFasePRfGxhmUeYW8X3Dww2/snRIWVftdYd8YY7toPouebjmh0rrme3WJkLo6tLx
	 4GNLZ9vtHMmIRrGs8NqsUmqslGOZf3Fh3BQvFiWspaMWOzsp+DqZGoGD/QvxVlGPA7DFE
	 DwX8XO0+ysVhNhs/OPTK3aQy9lCX2DzUPYXpeDKKhcEBpyv9GCwKAS8G0aw21BPpOEg+M
	 7QtFo1fzWHw17fat/jF1VJg8MOHundxEyKU4m62zttB6HfhsoQO/fO5YH/Hp5/LyHce39
	 wUwfboqjYWsduiUmT/0QT0xuaqdGsbNG5N/21EDiGMPQocWd5L5xAaWUBpwSXF0TFWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598881;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=AZrY0KxoC2nNHefTY9+8CABvcpufc/wb5mTGpcn2tO0=;
	b=f/3cud8psutoRpz5brvJEa5HqoAar38CJf4d3GTmSt501hw4VUB8pk9h6WMkBGLzpMKP
	 IQ6Z02mwXcRLmDe+5M2Cn/D/dFyjVeEeLVknx9t3qegBDNPD3HA4UHbCigjjuN+OyVgdU
	 FJaf0hHXI7xxm5HPygz6q2xlV+x+7ONed81SvDrgJ3ayLXC/2n7QCYGO2Jx2/WYEtA8bK
	 KbY52myaBL/6ju6tV7oYS7GrJsNaLLZ0z/yAJ7uyeYo/zRd0akdmKeMWq57WH9KAP4ajW
	 iHKnfu3asofxDrHEIIyuphKaionmUxll8dQh/3Wy43n4jQCz+eQ8oql2dFcPTAq6nhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x2UdysTL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42F606A32D
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x2UdysTL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B101F000C4;
	Fri, 13 Nov 2026 19:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794598881;
	bh=AZrY0KxoC2nNHefTY9+8CABvcpufc/wb5mTGpcn2tO0=;
	h=Date:To:From:Subject;
	b=x2UdysTLutJAMW8OL9nFt+uW6QP9CAOtAXz29qvNT7jDkYWs0yyGqN/GNzgHqreTh
	 dxc1UjtxhiJneLmspl0Ly2vZ3xm2digS12UrJArELyApbLc9O/VgAq9nXdL4hT+e6w
	 hebfJkn+qGLySMTidErNS3SQxj/pduf3Qpd/tGvg=
Date: Fri, 13 Nov 2026 11:41:20 -0800
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch removed from -mm tree
Message-Id: <20261113194121.61B101F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: restrict eviction accounting to eligible zones
has been removed from the -mm tree.  Its filename was
     mm-mglru-restrict-eviction-accounting-to-eligible-zones.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: restrict eviction accounting to eligible zones
Date: Thu, 12 Nov 2026 07:25:59 +0800

For both lruvec_evictable_size() and lru_gen_imbalanced(),
only count eligible zones below sc->reclaim_idx. This
avoids inflating the number of scanned pages and allows
aging to proceed more promptly when eligible zones have
few folios.

Link: https://lore.kernel.org/20261111232603.9934-13-baohua@kernel.org
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
Cc: Michal Hocko <mhocko@suse.com>
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
---

 mm/trace_vmscan.h |    4 ++--
 mm/vmscan.c       |   18 +++++++++---------
 mm/vmscan.h       |    5 +++--
 3 files changed, 14 insertions(+), 13 deletions(-)

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
@@ -4207,8 +4207,8 @@ static void set_initial_priority(struct
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[])
 {
 	int type;
 	unsigned long seq;
@@ -4221,7 +4221,7 @@ static void lruvec_evictable_size(struct
 
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 }
 
@@ -4230,7 +4230,7 @@ static bool lruvec_is_sizable(struct lru
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -5090,9 +5090,9 @@ static bool lru_gen_imbalanced(struct lr
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
-		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
 		for (seq = min_seq[type]; seq < max_seq; seq++)
-			old[type] += lruvec_gen_size(lrugen, type, seq);
+			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
@@ -5145,7 +5145,7 @@ static void lru_gen_prepare_scan(struct
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5843,7 +5843,7 @@ static int lru_gen_seq_show(struct seq_f
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			seq_printf(m, " %10lu%c",
-				   lruvec_gen_size(lrugen, type, seq), mark);
+				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
 		}
 
 		seq_putc(m, '\n');
@@ -5896,7 +5896,7 @@ static int run_eviction(struct lruvec *l
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
mm-mglru-reduce-lru-lock-contention-by-shrinking-folio-batches-in-inc_min_seq.patch
mm-mglru-make-swappiness=1-file-reclaim-more-aggressive.patch

