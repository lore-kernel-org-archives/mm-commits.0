Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4223F58EA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525417; cv=none; b=BMtlFKfw1BhaJXzeqiGnuy96KnHTfhQS449318VNU9/r263QgOPXYQJr6zT0g4vvUZVvUc/wrO3oZ3xd7hWL6zwbyPoUwF8FpW0qBem47kmSGtzG+2BTY4MidtcvvIBmu5yna72zo+c3iThTgKksHdfDTOkBm9iMuC/OScW0NuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525417; c=relaxed/simple;
	bh=gP74iJaiMGh/mwzUpKV9V9HVF4GTNW3QYQVl/261IA4=;
	h=Date:To:From:Subject:Message-Id; b=GTJuYnT+pRF9mZFnqWQWYJFAfZKzaxSTrfDaJjaARbv0gFWyXLFi6hikcJ50hyfh9XlcSlYTghQxwYL49rbDhkj4MpSZLXCZaTjS+dW5i89grlylOliTwA0lzVC2ROdusDk74NEXyvJESpIUf9gbsLzZd+OikPW21Td0j/cM2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG6GJG/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG6GJG/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850D71F00893;
	Fri,  9 Oct 2026 05:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525416;
	bh=admXKzqp1VVtmXJ/t7SqBHg4lkNFLH/pXWJcTmPrL9o=;
	h=Date:To:From:Subject;
	b=CG6GJG/c/YbXG5LUc1EdBn2RcjztTJTjNEaFlADkgVr22cY5KEhgC5G3N8/jfJjmF
	 id2eLgMxmq6eFuqhxvQA0lClTLboxl1UWUdBmCJ1D+ooSWfd3I1n3pGd4Dh5t3tTBf
	 c+68TR6XAZ7yLvLn/99BJjkBoh2+9UV2ABlbopiM=
Date: Thu, 08 Oct 2026 22:56:56 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch removed from -mm tree
Message-Id: <20261009055656.850D71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: group the fields of struct mem_cgroup_per_node
has been removed from the -mm tree.  Its filename was
     memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: group the fields of struct mem_cgroup_per_node
Date: Fri, 4 Sep 2026 20:05:22 -0700

Replace the two ad-hoc CACHELINE_PADDING members with named cache line
groups:

  memcg_pn_read_mostly   memcg, lruvec_stats_percpu, lruvec_stats,
                         shrinker_info, objcg
  memcg_pn_lruvec        lruvec
  memcg_pn_write_hot     lru_zone_size, iter, nmi slab stats
  memcg_pn_cold          orig_objcg, objcg_list

The group markers give the same isolation the padding did, but they are
named and the build now checks them.

lruvec still gets its own lines.  Commit f59adcf59332 ("mm: memcg: add
cacheline padding after lruvec in mem_cgroup_per_node") showed why that
matters: lru_zone_size[] is written under lru_lock but read without it by
lruvec_lru_size(), so it must not share a line with lruvec.

Splitting the cold fields out costs one extra cache line per node per
memcg.

No functional change.

Link: https://lore.kernel.org/20260905030522.1887837-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   32 ++++++++++++++++++++++----------
 mm/memcontrol.c            |   30 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~memcg-group-the-fields-of-struct-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -82,7 +82,8 @@ struct mem_cgroup_reclaim_iter {
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
-	/* Keep the read-only fields at the start */
+	/* Set when the memcg is created, then only read. */
+	__cacheline_group_begin_aligned(memcg_pn_read_mostly);
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
@@ -91,14 +92,30 @@ struct mem_cgroup_per_node {
 	struct shrinker_info __rcu	*shrinker_info;
 	struct obj_cgroup __rcu		*objcg;
 
-	CACHELINE_PADDING(_pad1_);
+	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
-	/* Fields which get updated often at the end. */
+	/*
+	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
+	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
+	 * padding after lruvec in mem_cgroup_per_node").
+	 */
+	__cacheline_group_begin_aligned(memcg_pn_lruvec);
 	struct lruvec		lruvec;
-	CACHELINE_PADDING(_pad2_);
+	__cacheline_group_end_aligned(memcg_pn_lruvec);
+
+	/* Written on every LRU update and on every reclaim iteration. */
+	__cacheline_group_begin_aligned(memcg_pn_write_hot);
 	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* slab stats for nmi context */
+	atomic_t		slab_reclaimable;
+	atomic_t		slab_unreclaimable;
+#endif
+	__cacheline_group_end_aligned(memcg_pn_write_hot);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
 	/*
 	 * orig_objcg preserves a pointer (and a reference) to the original
 	 * objcg until the end of life of memcg.
@@ -106,12 +123,7 @@ struct mem_cgroup_per_node {
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* slab stats for nmi context */
-	atomic_t		slab_reclaimable;
-	atomic_t		slab_unreclaimable;
-#endif
+	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
--- a/mm/memcontrol.c~memcg-group-the-fields-of-struct-mem_cgroup_per_node
+++ a/mm/memcontrol.c
@@ -5770,6 +5770,36 @@ static void __init memcg_struct_check(vo
 				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, memcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, lruvec_stats);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, shrinker_info);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_read_mostly, objcg);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_lruvec, lruvec);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, lru_zone_size);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, iter);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_reclaimable);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_write_hot, slab_unreclaimable);
+#endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, orig_objcg);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
+				      memcg_pn_cold, objcg_list);
 }
 
 int __init mem_cgroup_init(void)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


