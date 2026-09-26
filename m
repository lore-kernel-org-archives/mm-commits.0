Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ACE3976A9
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456378; cv=none; b=RrluFtLkjRZA2T59CtmGNeETHivb6CUyhG6lLX79JrYuKI2pQSp0LCZnhBONzvIcz+q1T60KQV6DgOOTOGeYFcUk28QAFQfKJZUtv5pYS/tp30zg+bb0GijprpS5VamNQ2TszyBuJ8ATY99HvALp+f/4xgTTbmtxXhYzGyFaQmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456378; c=relaxed/simple;
	bh=CodJVRNSzCUKF/vs/B1fRQGo/sccpRYY2Is9XrRWJw8=;
	h=Date:To:From:Subject:Message-Id; b=JVOaREmxdTl/UEtiBdtqIYfuaisRywIZxpnef6rgCIpE0o+U+0Mh8/G/48ofBlJ2iIYfPLSEP5dpeQdXYSm6If5+llXe4c5WSR05c85r3zMGE8elSsSlT/CHrI4+OxHd+3Bvq+t6VW34unhQyUCHlPDJ4foDH3Qz0WfUj30LJhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3kiYVd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3kiYVd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146821F000FF;
	Sat, 26 Sep 2026 20:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456375;
	bh=1Yl84irFD7aXZ/WgjR8uwXPghXCcWUecijL51R62EW0=;
	h=Date:To:From:Subject;
	b=R3kiYVd/V7hp3Qtih2V7HQyZeHARv+NbfWeqxafXV4GgBqvZQmlSR9pixMzZPp0G9
	 tXFXf/zC4A7t+qs3l4eJz2T0Z45V2+dZ0UjNaUgyrwSudN/3TjLoFEy1hYaLR36hG3
	 ZBzIKdPN6myZPSwFW8hlgQkXgdXCn34+eDpY/YfU=
Date: Sat, 26 Sep 2026 13:59:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch removed from -mm tree
Message-Id: <20260926205935.146821F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru indexing
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru indexing
Date: Thu, 10 Sep 2026 16:07:19 +0800

Patch series "mm: restore per-memcg reclaim for NONSLAB shrinkers under
nokmem", v3.

With cgroup.memory=nokmem, the THP deferred split shrinker and the zswap
shrinker are degraded in two ways.

First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
limit-induced reclaim of a cgroup neither splits its partially unmapped
THPs nor writes back its zswapped pages.  v1 of this series [1] restored
the flag to fix that.

However, as Sashiko's review of v1 pointed out [2], the flag alone is not
enough.  __list_lru_init() also collapses every list_lru into per-node
lists under nokmem, so even with the flag restored, the objects of all
cgroups share one list per node: the per-memcg shrinker bit is only set
for whichever memcg happens to repopulate the empty list, so pressure in
other cgroups may not even trigger the scan, and when it does, the scan
walks everyone's objects.

Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), THP had fully per-memcg deferred split queues embedded in
struct mem_cgroup, working independently of kmem accounting.  nokmem only
opts out of kernel slab accounting; THPs and zswapped pages are user
memory and remain charged to their cgroups, so per-memcg reclaim is still
what these shrinkers want.

This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers memcg
aware under nokmem:

Patch 1 drops the kmemcg_id copy, which is only assigned when kmem
accounting is enabled, and indexes the list_lru xarray with
mem_cgroup_id() instead, so the index works independently of kmem
accounting.  The list_lru plumbing passes memcg pointers now, and
memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
online/offline hooks.  It also drops the nokmem early return from the
offline path so these lrus are reparented on offline.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 3 and 4 restore/add SHRINKER_NONSLAB on the THP deferred split
shrinker and the zswap shrinker.

The savings of nokmem are preserved: slab-backed lrus (e.g.  the
superblock dentry/inode lrus) still fall back to per-node lists, and the
per-memcg lists are only allocated when a memcg actually holds such
objects.


This patch (of 4):

kmemcg_id is a copy of the private memcg ID and serves no purpose other
than indexing the per-memcg list_lru xarray.  It is assigned when kmem
accounting goes online, which never happens with cgroup.memory=nokmem, and
the memcgs then all resolve to the per-node lists.  The next patch needs
the index to work under nokmem as well.

Index the lists with mem_cgroup_id().  The cgroup ID is unique per memcg
and is only recycled once the cgroup is destroyed, long after offlining
has erased the xarray entries, so a recycled ID cannot resurrect a stale
entry.  The lookup now takes memcg pointers and routes root and NULL to
the per-node lists itself.

Also drop the nokmem early return from the offline path, so that the
reparenting covers lrus that stay memcg aware without kmem accounting. 
memcg_online_kmem() and memcg_offline_kmem() are each down to a single
statement now; inline them into the css online and offline hooks, dropping
the root check, as css_offline() is never called for the root and a memcg
that failed css_online() cannot have list_lru entries.

[akpm@linux-foundation.org: remove kmemcg_id from memcg_struct_check()]
Link: https://lore.kernel.org/20260910080722.3961351-1-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/20260910080722.3961351-2-qinyuntan@linux.alibaba.com
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>
---

 include/linux/memcontrol.h |   16 ------------
 mm/list_lru.c              |   27 ++++++++++-----------
 mm/memcontrol.c            |   45 ++++++-----------------------------
 3 files changed, 22 insertions(+), 66 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing
+++ a/include/linux/memcontrol.h
@@ -328,8 +328,6 @@ struct mem_cgroup {
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
-	int kmemcg_id;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -1820,15 +1818,6 @@ static inline void memcg_kmem_uncharge_p
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-/*
- * A helper for accessing memcg's kmem_id, used for getting
- * corresponding LRU lists.
- */
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return memcg ? memcg->kmemcg_id : -1;
-}
-
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
@@ -1896,11 +1885,6 @@ static inline bool memcg_kmem_online(voi
 	return false;
 }
 
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return -1;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
--- a/mm/list_lru.c~mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing
+++ a/mm/list_lru.c
@@ -72,10 +72,11 @@ static int lru_shrinker_id(struct list_l
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
-		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
+	if (list_lru_memcg_aware(lru) && memcg && !mem_cgroup_is_root(memcg)) {
+		struct list_lru_memcg *mlru =
+			xa_load(&lru->xa, mem_cgroup_id(memcg));
 
 		return mlru ? &mlru->node[nid] : NULL;
 	}
@@ -91,7 +92,7 @@ lock_list_lru_of_memcg(struct list_lru *
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg(lru, nid, *memcg);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -132,7 +133,7 @@ static inline bool list_lru_memcg_aware(
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
 	return &lru->node[nid].lru;
 }
@@ -313,7 +314,7 @@ unsigned long list_lru_count_one(struct
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg(lru, nid, memcg);
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -502,11 +503,10 @@ static void memcg_reparent_list_lru_one(
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
+	dst = list_lru_from_memcg(lru, nid, dst_memcg);
 	spin_lock_nested(&dst->lock, SINGLE_DEPTH_NESTING);
 
 	list_splice_init(&src->list, &dst->list);
@@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, mem_cgroup_id(memcg));
 		if (!mlru)
 			continue;
 
@@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, mem_cgroup_id(memcg));
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -566,9 +566,10 @@ void memcg_reparent_list_lrus(struct mem
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
-	int idx = memcg->kmemcg_id;
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return true;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	return xa_load(&lru->xa, mem_cgroup_id(memcg));
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
@@ -602,7 +603,7 @@ static int __memcg_list_lru_alloc(struct
 			if (!mlru)
 				return -ENOMEM;
 		}
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, mem_cgroup_id(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
--- a/mm/memcontrol.c~mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing
+++ a/mm/memcontrol.c
@@ -3807,33 +3807,6 @@ void folio_split_memcg_refs(struct folio
 	obj_cgroup_get_many(folio_objcg(folio), new_refs);
 }
 
-static void memcg_online_kmem(struct mem_cgroup *memcg)
-{
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	static_branch_enable(&memcg_kmem_online_key);
-
-	memcg->kmemcg_id = memcg->private_id;
-}
-
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *parent;
-
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	parent = parent_mem_cgroup(memcg);
-	memcg_reparent_list_lrus(memcg, parent);
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
@@ -4309,7 +4282,6 @@ static struct mem_cgroup *mem_cgroup_all
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4383,7 +4355,8 @@ static int mem_cgroup_css_online(struct
 	struct obj_cgroup *objcg;
 	int nid;
 
-	memcg_online_kmem(memcg);
+	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(memcg)))
+		static_branch_enable(&memcg_kmem_online_key);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -4391,7 +4364,7 @@ static int mem_cgroup_css_online(struct
 	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
-		goto offline_kmem;
+		goto reparent_lrus;
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
@@ -4449,8 +4422,8 @@ free_objcg:
 		}
 	}
 	free_shrinker_info(memcg);
-offline_kmem:
-	memcg_offline_kmem(memcg);
+reparent_lrus:
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -4466,11 +4439,11 @@ static void mem_cgroup_css_offline(struc
 
 	zswap_memcg_offline_cleanup(memcg);
 
-	memcg_offline_kmem(memcg);
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	/*
 	 * The reparenting of objcg must be after the reparenting of
-	 * the list_lru in memcg_offline_kmem(), which ensures that
-	 * they will not mistakenly get the parent list_lru.
+	 * the list_lru above, which ensures that they will not
+	 * mistakenly get the parent list_lru.
 	 */
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
@@ -5914,8 +5887,6 @@ static void __init memcg_struct_check(vo
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

