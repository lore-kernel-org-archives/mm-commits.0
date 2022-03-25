Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989E6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347702AbiCYBc0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357346AbiCYBcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09070403CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B43AB82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F5C340EE;
        Fri, 25 Mar 2022 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171829;
        bh=9CwzitA/CsRFN5r5P23uLLZsGeVyLsbfFGoewUxa030=;
        h=Date:To:From:Subject:From;
        b=uyAfxk5QMtPF81vsccq/tGGx+zBHsbY7kEDya4Z723Wsms4A3kbYWlAglouAEiRQq
         h/M+a7U96cfK1heqFlP7D23Um3qlnTgIjA/NkFvu2Rykia2CpoH+wR9tWBCXl7FILc
         /PNGqPsCBLn6yCZZqkdYWYzvvT0ekoP50wDzbO9I=
Date:   Thu, 24 Mar 2022 18:30:28 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-introduce-kmem_cache_alloc_lru.patch removed from -mm tree
Message-Id: <20220325013029.241F5C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce kmem_cache_alloc_lru
has been removed from the -mm tree.  Its filename was
     mm-introduce-kmem_cache_alloc_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: introduce kmem_cache_alloc_lru

We currently allocate scope for every memcg to be able to tracked on every
superblock instantiated in the system, regardless of whether that
superblock is even accessible to that memcg.

These huge memcg counts come from container hosts where memcgs are
confined to just a small subset of the total number of superblocks that
instantiated at any given point in time.

For these systems with huge container counts, list_lru does not need the
capability of tracking every memcg on every superblock.  What it comes
down to is that adding the memcg to the list_lru at the first insert.  So
introduce kmem_cache_alloc_lru to allocate objects and its list_lru.  In
the later patch, we will convert all inode and dentry allocation from
kmem_cache_alloc to kmem_cache_alloc_lru.

Link: https://lkml.kernel.org/r/20220228122126.37293-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h   |    4 +
 include/linux/memcontrol.h |   14 ++++
 include/linux/slab.h       |    3 +
 mm/list_lru.c              |  104 +++++++++++++++++++++++++++++++----
 mm/memcontrol.c            |   14 ----
 mm/slab.c                  |   39 +++++++++----
 mm/slab.h                  |   25 +++++++-
 mm/slob.c                  |    6 ++
 mm/slub.c                  |   42 +++++++++-----
 9 files changed, 198 insertions(+), 53 deletions(-)

--- a/include/linux/list_lru.h~mm-introduce-kmem_cache_alloc_lru
+++ a/include/linux/list_lru.h
@@ -56,6 +56,8 @@ struct list_lru {
 	struct list_head	list;
 	int			shrinker_id;
 	bool			memcg_aware;
+	/* protects ->mlrus->mlru[i] */
+	spinlock_t		lock;
 	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
 	struct list_lru_memcg	__rcu *mlrus;
 #endif
@@ -72,6 +74,8 @@ int __list_lru_init(struct list_lru *lru
 #define list_lru_init_memcg(lru, shrinker)		\
 	__list_lru_init((lru), true, NULL, shrinker)
 
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp);
 int memcg_update_all_list_lrus(int num_memcgs);
 void memcg_drain_all_list_lrus(int src_idx, struct mem_cgroup *dst_memcg);
 
--- a/include/linux/memcontrol.h~mm-introduce-kmem_cache_alloc_lru
+++ a/include/linux/memcontrol.h
@@ -524,6 +524,20 @@ static inline struct mem_cgroup *page_me
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+retry:
+	memcg = obj_cgroup_memcg(objcg);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	return memcg;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * folio_memcg_kmem - Check if the folio has the memcg_kmem flag set.
--- a/include/linux/slab.h~mm-introduce-kmem_cache_alloc_lru
+++ a/include/linux/slab.h
@@ -135,6 +135,7 @@
 
 #include <linux/kasan.h>
 
+struct list_lru;
 struct mem_cgroup;
 /*
  * struct kmem_cache related prototypes
@@ -416,6 +417,8 @@ static __always_inline unsigned int __km
 
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __alloc_size(1);
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t flags) __assume_slab_alignment __malloc;
+void *kmem_cache_alloc_lru(struct kmem_cache *s, struct list_lru *lru,
+			   gfp_t gfpflags) __assume_slab_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
 /*
--- a/mm/list_lru.c~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/list_lru.c
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/memcontrol.h>
 #include "slab.h"
+#include "internal.h"
 
 #ifdef CONFIG_MEMCG_KMEM
 static LIST_HEAD(memcg_list_lrus);
@@ -338,22 +339,30 @@ static void memcg_destroy_list_lru_range
 		kfree(mlrus->mlru[i]);
 }
 
+static struct list_lru_per_memcg *memcg_init_list_lru_one(gfp_t gfp)
+{
+	int nid;
+	struct list_lru_per_memcg *mlru;
+
+	mlru = kmalloc(struct_size(mlru, node, nr_node_ids), gfp);
+	if (!mlru)
+		return NULL;
+
+	for_each_node(nid)
+		init_one_lru(&mlru->node[nid]);
+
+	return mlru;
+}
+
 static int memcg_init_list_lru_range(struct list_lru_memcg *mlrus,
 				     int begin, int end)
 {
 	int i;
 
 	for (i = begin; i < end; i++) {
-		int nid;
-		struct list_lru_per_memcg *mlru;
-
-		mlru = kmalloc(struct_size(mlru, node, nr_node_ids), GFP_KERNEL);
-		if (!mlru)
+		mlrus->mlru[i] = memcg_init_list_lru_one(GFP_KERNEL);
+		if (!mlrus->mlru[i])
 			goto fail;
-
-		for_each_node(nid)
-			init_one_lru(&mlru->node[nid]);
-		mlrus->mlru[i] = mlru;
 	}
 	return 0;
 fail:
@@ -370,6 +379,8 @@ static int memcg_init_list_lru(struct li
 	if (!memcg_aware)
 		return 0;
 
+	spin_lock_init(&lru->lock);
+
 	mlrus = kvmalloc(struct_size(mlrus, mlru, size), GFP_KERNEL);
 	if (!mlrus)
 		return -ENOMEM;
@@ -416,8 +427,11 @@ static int memcg_update_list_lru(struct
 		return -ENOMEM;
 	}
 
+	spin_lock_irq(&lru->lock);
 	memcpy(&new->mlru, &old->mlru, flex_array_size(new, mlru, old_size));
 	rcu_assign_pointer(lru->mlrus, new);
+	spin_unlock_irq(&lru->lock);
+
 	kvfree_rcu(old, rcu);
 	return 0;
 }
@@ -502,6 +516,78 @@ void memcg_drain_all_list_lrus(int src_i
 		memcg_drain_list_lru(lru, src_idx, dst_memcg);
 	mutex_unlock(&list_lrus_mutex);
 }
+
+static bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
+				     struct list_lru *lru)
+{
+	bool allocated;
+	int idx;
+
+	idx = memcg->kmemcg_id;
+	if (unlikely(idx < 0))
+		return true;
+
+	rcu_read_lock();
+	allocated = !!rcu_dereference(lru->mlrus)->mlru[idx];
+	rcu_read_unlock();
+
+	return allocated;
+}
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	int i;
+	unsigned long flags;
+	struct list_lru_memcg *mlrus;
+	struct list_lru_memcg_table {
+		struct list_lru_per_memcg *mlru;
+		struct mem_cgroup *memcg;
+	} *table;
+
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+
+	gfp &= GFP_RECLAIM_MASK;
+	table = kmalloc_array(memcg->css.cgroup->level, sizeof(*table), gfp);
+	if (!table)
+		return -ENOMEM;
+
+	/*
+	 * Because the list_lru can be reparented to the parent cgroup's
+	 * list_lru, we should make sure that this cgroup and all its
+	 * ancestors have allocated list_lru_per_memcg.
+	 */
+	for (i = 0; memcg; memcg = parent_mem_cgroup(memcg), i++) {
+		if (memcg_list_lru_allocated(memcg, lru))
+			break;
+
+		table[i].memcg = memcg;
+		table[i].mlru = memcg_init_list_lru_one(gfp);
+		if (!table[i].mlru) {
+			while (i--)
+				kfree(table[i].mlru);
+			kfree(table);
+			return -ENOMEM;
+		}
+	}
+
+	spin_lock_irqsave(&lru->lock, flags);
+	mlrus = rcu_dereference_protected(lru->mlrus, true);
+	while (i--) {
+		int index = table[i].memcg->kmemcg_id;
+
+		if (mlrus->mlru[index])
+			kfree(table[i].mlru);
+		else
+			mlrus->mlru[index] = table[i].mlru;
+	}
+	spin_unlock_irqrestore(&lru->lock, flags);
+
+	kfree(table);
+
+	return 0;
+}
 #else
 static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
--- a/mm/memcontrol.c~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/memcontrol.c
@@ -2805,20 +2805,6 @@ static void commit_charge(struct folio *
 	folio->memcg_data = (unsigned long)memcg;
 }
 
-static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-retry:
-	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
-	rcu_read_unlock();
-
-	return memcg;
-}
-
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * The allocated objcg pointers array is not accounted directly.
--- a/mm/slab.c~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/slab.c
@@ -3211,7 +3211,7 @@ slab_alloc_node(struct kmem_cache *cache
 	bool init = false;
 
 	flags &= gfp_allowed_mask;
-	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
+	cachep = slab_pre_alloc_hook(cachep, NULL, &objcg, 1, flags);
 	if (unlikely(!cachep))
 		return NULL;
 
@@ -3287,7 +3287,8 @@ __do_cache_alloc(struct kmem_cache *cach
 #endif /* CONFIG_NUMA */
 
 static __always_inline void *
-slab_alloc(struct kmem_cache *cachep, gfp_t flags, size_t orig_size, unsigned long caller)
+slab_alloc(struct kmem_cache *cachep, struct list_lru *lru, gfp_t flags,
+	   size_t orig_size, unsigned long caller)
 {
 	unsigned long save_flags;
 	void *objp;
@@ -3295,7 +3296,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 	bool init = false;
 
 	flags &= gfp_allowed_mask;
-	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
+	cachep = slab_pre_alloc_hook(cachep, lru, &objcg, 1, flags);
 	if (unlikely(!cachep))
 		return NULL;
 
@@ -3484,6 +3485,18 @@ void ___cache_free(struct kmem_cache *ca
 	__free_one(ac, objp);
 }
 
+static __always_inline
+void *__kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
+			     gfp_t flags)
+{
+	void *ret = slab_alloc(cachep, lru, flags, cachep->object_size, _RET_IP_);
+
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       cachep->object_size, cachep->size, flags);
+
+	return ret;
+}
+
 /**
  * kmem_cache_alloc - Allocate an object
  * @cachep: The cache to allocate from.
@@ -3496,15 +3509,17 @@ void ___cache_free(struct kmem_cache *ca
  */
 void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
-	void *ret = slab_alloc(cachep, flags, cachep->object_size, _RET_IP_);
-
-	trace_kmem_cache_alloc(_RET_IP_, ret,
-			       cachep->object_size, cachep->size, flags);
-
-	return ret;
+	return __kmem_cache_alloc_lru(cachep, NULL, flags);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
+			   gfp_t flags)
+{
+	return __kmem_cache_alloc_lru(cachep, lru, flags);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_lru);
+
 static __always_inline void
 cache_alloc_debugcheck_after_bulk(struct kmem_cache *s, gfp_t flags,
 				  size_t size, void **p, unsigned long caller)
@@ -3521,7 +3536,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	size_t i;
 	struct obj_cgroup *objcg = NULL;
 
-	s = slab_pre_alloc_hook(s, &objcg, size, flags);
+	s = slab_pre_alloc_hook(s, NULL, &objcg, size, flags);
 	if (!s)
 		return 0;
 
@@ -3562,7 +3577,7 @@ kmem_cache_alloc_trace(struct kmem_cache
 {
 	void *ret;
 
-	ret = slab_alloc(cachep, flags, size, _RET_IP_);
+	ret = slab_alloc(cachep, NULL, flags, size, _RET_IP_);
 
 	ret = kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc(_RET_IP_, ret,
@@ -3689,7 +3704,7 @@ static __always_inline void *__do_kmallo
 	cachep = kmalloc_slab(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	ret = slab_alloc(cachep, flags, size, caller);
+	ret = slab_alloc(cachep, NULL, flags, size, caller);
 
 	ret = kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc(caller, ret,
--- a/mm/slab.h~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/slab.h
@@ -231,6 +231,7 @@ struct kmem_cache {
 #include <linux/kmemleak.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
+#include <linux/list_lru.h>
 
 /*
  * State of the slab allocator.
@@ -472,6 +473,7 @@ static inline size_t obj_full_size(struc
  * Returns false if the allocation should fail.
  */
 static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct list_lru *lru,
 					     struct obj_cgroup **objcgp,
 					     size_t objects, gfp_t flags)
 {
@@ -487,13 +489,26 @@ static inline bool memcg_slab_pre_alloc_
 	if (!objcg)
 		return true;
 
-	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
-		obj_cgroup_put(objcg);
-		return false;
+	if (lru) {
+		int ret;
+		struct mem_cgroup *memcg;
+
+		memcg = get_mem_cgroup_from_objcg(objcg);
+		ret = memcg_list_lru_alloc(memcg, lru, flags);
+		css_put(&memcg->css);
+
+		if (ret)
+			goto out;
 	}
 
+	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s)))
+		goto out;
+
 	*objcgp = objcg;
 	return true;
+out:
+	obj_cgroup_put(objcg);
+	return false;
 }
 
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
@@ -598,6 +613,7 @@ static inline void memcg_free_slab_cgrou
 }
 
 static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct list_lru *lru,
 					     struct obj_cgroup **objcgp,
 					     size_t objects, gfp_t flags)
 {
@@ -697,6 +713,7 @@ static inline size_t slab_ksize(const st
 }
 
 static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
+						     struct list_lru *lru,
 						     struct obj_cgroup **objcgp,
 						     size_t size, gfp_t flags)
 {
@@ -707,7 +724,7 @@ static inline struct kmem_cache *slab_pr
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+	if (!memcg_slab_pre_alloc_hook(s, lru, objcgp, size, flags))
 		return NULL;
 
 	return s;
--- a/mm/slob.c~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/slob.c
@@ -635,6 +635,12 @@ void *kmem_cache_alloc(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+
+void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru, gfp_t flags)
+{
+	return slob_alloc_node(cachep, flags, NUMA_NO_NODE);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_lru);
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
--- a/mm/slub.c~mm-introduce-kmem_cache_alloc_lru
+++ a/mm/slub.c
@@ -3131,7 +3131,7 @@ static __always_inline void maybe_wipe_o
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static __always_inline void *slab_alloc_node(struct kmem_cache *s,
+static __always_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
 	void *object;
@@ -3141,7 +3141,7 @@ static __always_inline void *slab_alloc_
 	struct obj_cgroup *objcg = NULL;
 	bool init = false;
 
-	s = slab_pre_alloc_hook(s, &objcg, 1, gfpflags);
+	s = slab_pre_alloc_hook(s, lru, &objcg, 1, gfpflags);
 	if (!s)
 		return NULL;
 
@@ -3232,27 +3232,41 @@ out:
 	return object;
 }
 
-static __always_inline void *slab_alloc(struct kmem_cache *s,
+static __always_inline void *slab_alloc(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, unsigned long addr, size_t orig_size)
 {
-	return slab_alloc_node(s, gfpflags, NUMA_NO_NODE, addr, orig_size);
+	return slab_alloc_node(s, lru, gfpflags, NUMA_NO_NODE, addr, orig_size);
 }
 
-void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
+static __always_inline
+void *__kmem_cache_alloc_lru(struct kmem_cache *s, struct list_lru *lru,
+			     gfp_t gfpflags)
 {
-	void *ret = slab_alloc(s, gfpflags, _RET_IP_, s->object_size);
+	void *ret = slab_alloc(s, lru, gfpflags, _RET_IP_, s->object_size);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s->object_size,
 				s->size, gfpflags);
 
 	return ret;
 }
+
+void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return __kmem_cache_alloc_lru(s, NULL, gfpflags);
+}
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+void *kmem_cache_alloc_lru(struct kmem_cache *s, struct list_lru *lru,
+			   gfp_t gfpflags)
+{
+	return __kmem_cache_alloc_lru(s, lru, gfpflags);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_lru);
+
 #ifdef CONFIG_TRACING
 void *kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
-	void *ret = slab_alloc(s, gfpflags, _RET_IP_, size);
+	void *ret = slab_alloc(s, NULL, gfpflags, _RET_IP_, size);
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags);
 	ret = kasan_kmalloc(s, ret, size, gfpflags);
 	return ret;
@@ -3263,7 +3277,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_trace);
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	void *ret = slab_alloc_node(s, gfpflags, node, _RET_IP_, s->object_size);
+	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, s->object_size);
 
 	trace_kmem_cache_alloc_node(_RET_IP_, ret,
 				    s->object_size, s->size, gfpflags, node);
@@ -3277,7 +3291,7 @@ void *kmem_cache_alloc_node_trace(struct
 				    gfp_t gfpflags,
 				    int node, size_t size)
 {
-	void *ret = slab_alloc_node(s, gfpflags, node, _RET_IP_, size);
+	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, size);
 
 	trace_kmalloc_node(_RET_IP_, ret,
 			   size, s->size, gfpflags, node);
@@ -3667,7 +3681,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	struct obj_cgroup *objcg = NULL;
 
 	/* memcg and kmem_cache debug support */
-	s = slab_pre_alloc_hook(s, &objcg, size, flags);
+	s = slab_pre_alloc_hook(s, NULL, &objcg, size, flags);
 	if (unlikely(!s))
 		return false;
 	/*
@@ -4417,7 +4431,7 @@ void *__kmalloc(size_t size, gfp_t flags
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	ret = slab_alloc(s, flags, _RET_IP_, size);
+	ret = slab_alloc(s, NULL, flags, _RET_IP_, size);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
@@ -4465,7 +4479,7 @@ void *__kmalloc_node(size_t size, gfp_t
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	ret = slab_alloc_node(s, flags, node, _RET_IP_, size);
+	ret = slab_alloc_node(s, NULL, flags, node, _RET_IP_, size);
 
 	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
@@ -4923,7 +4937,7 @@ void *__kmalloc_track_caller(size_t size
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	ret = slab_alloc(s, gfpflags, caller, size);
+	ret = slab_alloc(s, NULL, gfpflags, caller, size);
 
 	/* Honor the call site pointer we received. */
 	trace_kmalloc(caller, ret, size, s->size, gfpflags);
@@ -4954,7 +4968,7 @@ void *__kmalloc_node_track_caller(size_t
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	ret = slab_alloc_node(s, gfpflags, node, caller, size);
+	ret = slab_alloc_node(s, NULL, gfpflags, node, caller, size);
 
 	/* Honor the call site pointer we received. */
 	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


