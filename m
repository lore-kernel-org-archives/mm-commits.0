Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465378;
	b=ljFtF+24VrV6zwkMMK9tknBsSUu2jht6rjAczgUt1AEiW9Duwkr/HK28LMBDgIZj8SRp
	 IgYMqPA8XU4zcYmmLi/inARowXZcHDnhrTLWxyz3NxjuEKa1umFHEVYXhbykjY3kMuyVw
	 QGYEXmWfG0AriyCbpYYdQtibGZ9VHipXrPP0LIBlmnouiZhDxkbGdJOZeVZCJcYWAgd3H
	 5l7LTMyWfJCuobGEl2heucW84aobMjM8z/eQIgiI3++S/2kwVelU6hz93EroJpv3L9kBZ
	 KXwiyjXk46kDm4QO6AwKYT7YeakK5de85wJoTxEnDD0Yqn6Ic6ylKm38x2Uekdx+wJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465378;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=3WdZrhRt86LJzSImDBlnOI3ks/mh/8D5VSYEtJ+n3gI=;
	b=C7K7VyU+OkZSJjQUKDBNfC9oa6YKI/1/GMAH8S+amuuX0ftYxHrl9Nlg60kmgFarsO7F
	 14G8sy2pWfHwxDDYLzaCSGpkrkqxskNw+a1Zh7NiONEpyU3Ww8bYrj/0f5huMAR57fvO8
	 NM1T9s+HYwajLXEeRR+OTB20AQ7X+M5s6qdvx3NkvaLp6LSsJU2eqB/60E1LOQ/BSCguI
	 ul7q76MkUoy1HOmgJ6U+5chf2ltRC7CsCIwy6LFfi7qmdjA6kPCZ0iZOtTdzcB/E0YcbF
	 Stxzzx+kNsfEnpPD9HL67GZIsU4xpOvd6mN8Uw1LMvZVmPjXDYfU3m2cpClsI+DuPMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0qJmxVwx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E03606A321
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0qJmxVwx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273381F000C0;
	Mon, 23 Nov 2026 20:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465378;
	bh=3WdZrhRt86LJzSImDBlnOI3ks/mh/8D5VSYEtJ+n3gI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=0qJmxVwxAA+AWDq8oDeuUby3COMLqZxaVILC8sy0uqP+u/1/2aVfzodpsNHsMXGrg
	 v5HUoLu8aPgW85fu9Xtn7y+KlqL+qf+o3FsucsEWSLu6B4wKTOSVAfb6Qq+ZjtBAbK
	 B2fORQerZr17J4GbeZko2WfYBiY0s8TqhbfiosOo=
Date: Mon, 23 Nov 2026 12:22:57 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
Subject: + mm-mglru-make-generation-page-counters-atomic.patch added to mm-new branch
Message-Id: <20261123202258.273381F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: make generation page counters atomic
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-make-generation-page-counters-atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-generation-page-counters-atomic.patch

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
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
mm-mglru-make-generation-page-counters-atomic.patch
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

