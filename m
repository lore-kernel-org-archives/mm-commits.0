Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7F4A9D4A
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378060; cv=none; b=VknmXwxti6lus3zuizi6JhwdklFLm/lZdbkzoT+0EbvWHjjOSbs5tHStjjxoqfZA14ehoVCx1SFm7dM67rz0qlmDsiaTsrcTe3DZ14/5RivxxILJ3WPVtpihl6PGg6a+2wwioJR8m8/DYM0PtgAZbYBgp3IGdnNMbkyzdbtm3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378060; c=relaxed/simple;
	bh=lZLqV3L5dZiLw/j/j/FlSwTVAX8oOb7FBly84yQ7VjE=;
	h=Date:To:From:Subject:Message-Id; b=f8Ued7GPRpJKWzWDqkMwiwQRI0DoafrnqciSFwacORJn1jITC+9Q/6MIFSbM4vwlTmv1n7fqdlyygwMzbhL/a+x1ZUWYGB+qEFxlj/xZZi4Gd6p4LjOUEv0LHUZCRbBQkYO0ahQIWzjYUZMRwmqGTmByTPkY0YpuuLUAq48gyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DT4uZz0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DT4uZz0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBC01F000E9;
	Wed,  2 Sep 2026 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378038;
	bh=AkcVT8PLR8w7moFtun6vih+ZVB93Glbk1SeUdI6ywfQ=;
	h=Date:To:From:Subject;
	b=DT4uZz0kOwi5IzpOo4E1ZzYLhVyR4o960EY2sVnr4XhmQ+kqphvcIGjcI/1uQo9a8
	 lK0D2qTiErY13nCodaegMgQUBgAs53Hws32MGkar0IkbhkYU1gV8YLWmDSi3qxV77V
	 iX/CpAV8Fbm7+wWzgZMDo4k+elvYzDowh2mr9HTw=
Date: Wed, 02 Sep 2026 12:40:37 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-lru_gen_soft_reclaim.patch added to mm-unstable branch
Message-Id: <20260902194038.1DBC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove lru_gen_soft_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-lru_gen_soft_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-lru_gen_soft_reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove lru_gen_soft_reclaim()
Date: Wed, 2 Sep 2026 10:43:08 -0700

The soft limit rbtree was the only caller. Dropping it leaves
MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
that op, so remove the op too and update the memcg LRU comment.

Link: https://lore.kernel.org/20260902174311.1772372-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   30 +++++++++++-------------------
 mm/vmscan.c            |   16 ++--------------
 2 files changed, 13 insertions(+), 33 deletions(-)

--- a/include/linux/mmzone.h~memcg-remove-lru_gen_soft_reclaim
+++ a/include/linux/mmzone.h
@@ -638,35 +638,32 @@ struct lru_gen_mm_walk {
  * For each node, memcgs are divided into two generations: the old and the
  * young. For each generation, memcgs are randomly sharded into multiple bins
  * to improve scalability. For each bin, the hlist_nulls is virtually divided
- * into three segments: the head, the tail and the default.
+ * into two segments: the tail and the default.
  *
  * An onlining memcg is added to the tail of a random bin in the old generation.
  * The eviction starts at the head of a random bin in the old generation. The
  * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
  * the old generation, is incremented when all its bins become empty.
  *
- * There are four operations:
- * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin in its
- *    current generation (old or young) and updates its "seg" to "head";
- * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
+ * There are three operations:
+ * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
  *    current generation (old or young) and updates its "seg" to "tail";
- * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
+ * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
  *    generation, updates its "gen" to "old" and resets its "seg" to "default";
- * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
+ * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
  *    young generation, updates its "gen" to "young" and resets its "seg" to
  *    "default".
  *
  * The events that trigger the above operations are:
- * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
- * 2. The first attempt to reclaim a memcg below low, which triggers
+ * 1. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
+ * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_TAIL;
- * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
+ * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
  *    threshold, which triggers MEMCG_LRU_YOUNG;
- * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
- * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
- * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
+ * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
+ * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
+ * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
  *
  * Notes:
  * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
@@ -699,7 +696,6 @@ void lru_gen_exit_memcg(struct mem_cgrou
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
 void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
@@ -740,10 +736,6 @@ static inline void lru_gen_release_memcg
 {
 }
 
-static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-}
-
 static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
 {
 }
--- a/mm/vmscan.c~memcg-remove-lru_gen_soft_reclaim
+++ a/mm/vmscan.c
@@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma
 /* see the comment on MEMCG_NR_GENS */
 enum {
 	MEMCG_LRU_NOP,
-	MEMCG_LRU_HEAD,
 	MEMCG_LRU_TAIL,
 	MEMCG_LRU_OLD,
 	MEMCG_LRU_YOUNG,
@@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct
 	new = old = lruvec->lrugen.gen;
 
 	/* see the comment on MEMCG_NR_GENS */
-	if (op == MEMCG_LRU_HEAD)
-		seg = MEMCG_LRU_HEAD;
-	else if (op == MEMCG_LRU_TAIL)
+	if (op == MEMCG_LRU_TAIL)
 		seg = MEMCG_LRU_TAIL;
 	else if (op == MEMCG_LRU_OLD)
 		new = get_memcg_gen(pgdat->memcg_lru.seq);
@@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct
 
 	hlist_nulls_del_rcu(&lruvec->lrugen.list);
 
-	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
+	if (op == MEMCG_LRU_OLD)
 		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
 	else
 		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
@@ -4489,15 +4486,6 @@ unlock:
 	}
 }
 
-void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
-{
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-	/* see the comment on MEMCG_NR_GENS */
-	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
-}
-
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
 {
 	struct lruvec *lruvec = get_lruvec(memcg, nid);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

