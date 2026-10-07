Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E62D7DE9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334223; cv=none; b=Po5ohV9Jd8al1ORC9X1mPzdKwfNJtmu/8p+SbGGPHkEgVWQoWE9G5AuqkqHcgM3HqMga+XAQmTOPd2ZIpx0Glm7W7N/EOxK2jTWDq/hcrZquSHivjPlwwAQSAxzTWdUPf6BvmmY5JjFRqHLMmJv3IwI7zAUJky6SlLZWR9MeaSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334223; c=relaxed/simple;
	bh=r7TMa9xMT4wXuPrH53exmURzckUIMikhFjLwxbuLjVk=;
	h=Date:To:From:Subject:Message-Id; b=e5GVjxe6eZ0gulnq1IW1LdKU3esUy0e320wrhCZJP5yLG4Zo5IXYSShSWjZbcOZ67yedV4bWXaulWfiucmunqkTYA7MttXdNd0GaeXf2p1kIgG1zPzYa0+Pnr8HGBru8ok965c9C+n8Mfj01lhcVlEJbBJ85rZS0dEw71j2ClDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKjRgZ8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKjRgZ8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA31F0089C;
	Wed,  7 Oct 2026 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334222;
	bh=NBDNztn4t/sqglKrdjKOdSwPwf1cNKUYZyEWNCw5ROA=;
	h=Date:To:From:Subject;
	b=VKjRgZ8v84jhtzjD2ikBtLJ6AajzQqpxyVnm7kRJDFjyGDj23KL0FFpJAY7RGm+O8
	 wZJnbPi8iLZ+100paDKv0tMxS1TsE5ZiuGJ7Y0CxAoXJsf9pkpRNno1LwgExgktwSC
	 s6X9kqX81QnAsec9Aa681nuO/ySIAM0J36uTdEoM=
Date: Tue, 06 Oct 2026 17:50:21 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-lru_gen_soft_reclaim.patch removed from -mm tree
Message-Id: <20261007005021.F1EA31F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove lru_gen_soft_reclaim()
has been removed from the -mm tree.  Its filename was
     memcg-remove-lru_gen_soft_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove lru_gen_soft_reclaim()
Date: Wed, 2 Sep 2026 10:43:08 -0700

The soft limit rbtree was the only caller. Dropping it leaves
MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
that op, so remove the op too and update the memcg LRU comment.

Link: https://lore.kernel.org/20260902174311.1772372-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

