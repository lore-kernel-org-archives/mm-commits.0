Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3755B38A72B
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651291; cv=none; b=LqiBi++yzPTm5JnkMozhJ8odgENAhJhaobrGhnaMZYa0EGskx88cdqZIyuiSUqZlv03kT/4YaNJrukIoReK/XvLluh7XB3Yt+U6GiMCbQopfgTPsQwE2dcBNl5RnfJNkO5gLLZCd1KN6M6e6qsm+IwulUBmw6ynBruoEAZOGDpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651291; c=relaxed/simple;
	bh=OghdTV4PbI7riKs5D/b9fFHt+Paudh8JuzGv8kCExSk=;
	h=Date:To:From:Subject:Message-Id; b=ZCaJV3a3anKCJTw3SoOret5WPZwm/Xc/nUnckbyO8X0Ig73KVku0bf5PjG6Pzt8/Zy2HlxgcOc6I+R2P4/n+S7Sc6KYnJ9dOquFIpAO/DeDMRhmb8AIxOJNbqIe+6IsdxlYXzhAInisY/Ma0dY9FoShX0PgqxaKUGs2Op5QpbdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ABaKn6YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ABaKn6YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B51A1F00A3A;
	Sat,  5 Sep 2026 23:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651290;
	bh=Jp0GodN/RRsjQctTl2YklxdvTPp13n2fEplYyPOjank=;
	h=Date:To:From:Subject;
	b=ABaKn6YZCOZ/VhGrqBrosS8AvN50nE12/O5aNak/DMFDmSnXEhuwTFGFFBpG1hde7
	 j/W5vm/AZqSYIWZQ71obKuTmVZFoGJY2S+cZNvu69hLQ4o1a0KPruNCOJKj/nDI6Cr
	 xGbF7iL3djxue4nw520i3aWaptjcclZOWFWBXr80=
Date: Sat, 05 Sep 2026 16:34:49 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch added to mm-new branch
Message-Id: <20260905233450.0B51A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: group the fields of struct mem_cgroup_per_node
has been added to the -mm mm-new branch.  Its filename is
     memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

