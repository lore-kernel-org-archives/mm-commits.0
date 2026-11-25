Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638954;
	b=46WYEHEN4WR8+w8SVrTRZ1MoNZaqFhrng2H+lvTTEnbSztkmmxChn8yP6jl46KRBU+Hz
	 gJ/NAGmNmQFVOd5cfu7yEWF8wQnSGM4CJXgDx9jSSFU/9XO0Ln2v+3ZCnKiyA+62G2tTj
	 JYVPCWlOnHYmAhvgpJWxDxDB1moGk0lOze2oQuNL/k0foa7tUDK4rFKp+/bxc8VP5JHcR
	 xgbPRWUhyNbL2HHfjGMXPtenGNwKiZVVUV8oYHv+ni0nF9+O+7CayeaOn8EzHxbtRAP+v
	 KNgw4FYXVkbEEv7eWtVrSRi/CS9whSS/4kXp5g4WDpGQukJFIvNn+CGmlYICuzzX5rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638954;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=1i65o6qwphI1LdRK/kPITGf4+7Eva/TGg2ouefVwHno=;
	b=ipd/eto+GX2dtw3TY9n0M6BJRwce/G6HcqURNflzwMzwJ8oChQCBc9okzpH9qqagpoEV
	 w9qDVQDeCjnFl7mgix6EgQYiQP7XmfyClIsHte0m2BQBQIBhQn6JvHWxNTWmmqfeVJ3s6
	 iZKTHOfyM5yN50PksgFL0yME5jH6TK60gJ/Ur8RfOS9CrsK2kmK+0zju3y/lVmw4u67Vb
	 dHqTw2nnLlUYLmdHpyKrz1yw9M9WyC3psj+VR0MyJzrFP0BDFL2BGQ1FHGcnl77jhIUnc
	 kbiN68T3kxi0J/TbCdEKeOqooraTg44IpevbII93AMMxwlU00TbEbihRZ0du014bUYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n80RGnr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEF6606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n80RGnr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559CF1F000C0;
	Wed, 25 Nov 2026 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638954;
	bh=1i65o6qwphI1LdRK/kPITGf4+7Eva/TGg2ouefVwHno=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=n80RGnr2xwo6etLgZhC7JX8DNv95wkBsEY5FaaksdFrN7WMoV4VH+z71nytuhTSYR
	 C9/fqiPLoBTFxU6rS1h6HDbwr09mMNvs8TVjGvOm+8nDS5vmkj2bVeFsvHYqpS+uWh
	 2Z1GVli4s3gpDnQXQgJ3VUIzzeQfLlYj8QIpEsOg=
Date: Wed, 25 Nov 2026 12:35:53 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-mglru-make-generation-page-counters-atomic.patch removed from -mm tree
Message-Id: <20261125203554.559CF1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: make generation page counters atomic
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-generation-page-counters-atomic.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: make generation page counters atomic
Date: Tue, 24 Nov 2026 02:52:56 +0800

No feature change, convert them to atomic so we can update them without
holding the LRU lock. A temporary underflow is fine: readers clamp a
negative value to zero, and the counters only need to be eventually
consistent.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |    6 ++----
 include/linux/mmzone.h    |    2 +-
 mm/vmscan.c               |   26 +++++++++++++-------------
 mm/vmscan.h               |    2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-make-generation-page-counters-atomic
+++ a/include/linux/mm_inline.h
@@ -265,11 +265,9 @@ static inline void lru_gen_update_size(s
 	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
 
 	if (old_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
 	if (new_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
-			   lrugen->nr_pages[new_gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
 	/* addition */
 	if (old_gen < 0) {
--- a/include/linux/mmzone.h~mm-mglru-make-generation-page-counters-atomic
+++ a/include/linux/mmzone.h
@@ -554,7 +554,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
--- a/mm/vmscan.c~mm-mglru-make-generation-page-counters-atomic
+++ a/mm/vmscan.c
@@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *l
 				break;
 		}
 		flush_lru_batch(head, &batch_end, target_list);
-
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
-		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
+		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
 		if (!remaining)
 			return false;
 	}
@@ -4093,8 +4089,8 @@ restart:
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(str
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
+	/*
+	 * The child is offline and the lockless updaters, which hold
+	 * rcu_read_lock() over the update, avoid racing with reparenting,
+	 * so the read/set/add operations below are safe.
+	 */
 	for (gen = 0; gen < MAX_NR_GENS; gen++) {
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(str
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
--- a/mm/vmscan.h~mm-mglru-make-generation-page-counters-atomic
+++ a/mm/vmscan.h
@@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_s
 	unsigned long size = 0;
 
 	for (int zone = 0; zone < max_zone; zone++)
-		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+		size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
 
 	return size;
 }
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
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

