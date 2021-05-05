Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99606C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEFA61422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEEBhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6446141D;
        Wed,  5 May 2021 01:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178572;
        bh=Ub7a6/augn7nCZ5ot3AQd7KMXBZy7kEkDACf11NBzvg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MYjgZIJ4Srj6eHhWh2G8XWrgK8jPCx4G6kJCVeG9C7/XxePMjHW7fwk/1evNT+qgo
         Zzr6ljSaGGA8WV/08fYMgZPRwYb0I1Oo3FxkCBIzXBFd/eBxOGp9ScHWIj+zxtNJnU
         69lHLySNGP/H2fBK/z269Ek+EXDcrxY1zta/rDGM=
Date:   Tue, 04 May 2021 18:36:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 063/143] mm: vmscan: consolidate shrinker_maps
 handling code
Message-ID: <20210505013611.RFDjFmCFZ%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: consolidate shrinker_maps handling code

The shrinker map management is not purely memcg specific, it is at the
intersection between memory cgroup and shrinkers.  It's allocation and
assignment of a structure, and the only memcg bit is the map is being
stored in a memcg structure.  So move the shrinker_maps handling code into
vmscan.c for tighter integration with shrinker code, and remove the
"memcg_" prefix.  There is no functional change.

Link: https://lkml.kernel.org/r/20210311190845.9708-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +-
 mm/huge_memory.c           |    4 -
 mm/list_lru.c              |    6 -
 mm/memcontrol.c            |  130 ----------------------------------
 mm/vmscan.c                |  132 ++++++++++++++++++++++++++++++++++-
 5 files changed, 142 insertions(+), 141 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-consolidate-shrinker_maps-handling-code
+++ a/include/linux/memcontrol.h
@@ -1610,10 +1610,9 @@ static inline bool mem_cgroup_under_sock
 	return false;
 }
 
-extern int memcg_expand_shrinker_maps(int new_id);
-
-extern void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
-				   int nid, int shrinker_id);
+int alloc_shrinker_maps(struct mem_cgroup *memcg);
+void free_shrinker_maps(struct mem_cgroup *memcg);
+void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
@@ -1623,8 +1622,8 @@ static inline bool mem_cgroup_under_sock
 	return false;
 }
 
-static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
-					  int nid, int shrinker_id)
+static inline void set_shrinker_bit(struct mem_cgroup *memcg,
+				    int nid, int shrinker_id)
 {
 }
 #endif
--- a/mm/huge_memory.c~mm-vmscan-consolidate-shrinker_maps-handling-code
+++ a/mm/huge_memory.c
@@ -2830,8 +2830,8 @@ void deferred_split_huge_page(struct pag
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
 		if (memcg)
-			memcg_set_shrinker_bit(memcg, page_to_nid(page),
-					       deferred_split_shrinker.id);
+			set_shrinker_bit(memcg, page_to_nid(page),
+					 deferred_split_shrinker.id);
 #endif
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
--- a/mm/list_lru.c~mm-vmscan-consolidate-shrinker_maps-handling-code
+++ a/mm/list_lru.c
@@ -125,8 +125,8 @@ bool list_lru_add(struct list_lru *lru,
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
 		if (!l->nr_items++)
-			memcg_set_shrinker_bit(memcg, nid,
-					       lru_shrinker_id(lru));
+			set_shrinker_bit(memcg, nid,
+					 lru_shrinker_id(lru));
 		nlru->nr_items++;
 		spin_unlock(&nlru->lock);
 		return true;
@@ -540,7 +540,7 @@ static void memcg_drain_list_lru_node(st
 
 	if (src->nr_items) {
 		dst->nr_items += src->nr_items;
-		memcg_set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
+		set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
 		src->nr_items = 0;
 	}
 
--- a/mm/memcontrol.c~mm-vmscan-consolidate-shrinker_maps-handling-code
+++ a/mm/memcontrol.c
@@ -400,130 +400,6 @@ DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabl
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 #endif
 
-static int memcg_shrinker_map_size;
-static DEFINE_MUTEX(memcg_shrinker_map_mutex);
-
-static void memcg_free_shrinker_map_rcu(struct rcu_head *head)
-{
-	kvfree(container_of(head, struct memcg_shrinker_map, rcu));
-}
-
-static int memcg_expand_one_shrinker_map(struct mem_cgroup *memcg,
-					 int size, int old_size)
-{
-	struct memcg_shrinker_map *new, *old;
-	struct mem_cgroup_per_node *pn;
-	int nid;
-
-	lockdep_assert_held(&memcg_shrinker_map_mutex);
-
-	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		old = rcu_dereference_protected(pn->shrinker_map, true);
-		/* Not yet online memcg */
-		if (!old)
-			return 0;
-
-		new = kvmalloc_node(sizeof(*new) + size, GFP_KERNEL, nid);
-		if (!new)
-			return -ENOMEM;
-
-		/* Set all old bits, clear all new bits */
-		memset(new->map, (int)0xff, old_size);
-		memset((void *)new->map + old_size, 0, size - old_size);
-
-		rcu_assign_pointer(pn->shrinker_map, new);
-		call_rcu(&old->rcu, memcg_free_shrinker_map_rcu);
-	}
-
-	return 0;
-}
-
-static void memcg_free_shrinker_maps(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup_per_node *pn;
-	struct memcg_shrinker_map *map;
-	int nid;
-
-	if (mem_cgroup_is_root(memcg))
-		return;
-
-	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		map = rcu_dereference_protected(pn->shrinker_map, true);
-		kvfree(map);
-		rcu_assign_pointer(pn->shrinker_map, NULL);
-	}
-}
-
-static int memcg_alloc_shrinker_maps(struct mem_cgroup *memcg)
-{
-	struct memcg_shrinker_map *map;
-	int nid, size, ret = 0;
-
-	if (mem_cgroup_is_root(memcg))
-		return 0;
-
-	mutex_lock(&memcg_shrinker_map_mutex);
-	size = memcg_shrinker_map_size;
-	for_each_node(nid) {
-		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
-		if (!map) {
-			memcg_free_shrinker_maps(memcg);
-			ret = -ENOMEM;
-			break;
-		}
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, map);
-	}
-	mutex_unlock(&memcg_shrinker_map_mutex);
-
-	return ret;
-}
-
-int memcg_expand_shrinker_maps(int new_id)
-{
-	int size, old_size, ret = 0;
-	struct mem_cgroup *memcg;
-
-	size = DIV_ROUND_UP(new_id + 1, BITS_PER_LONG) * sizeof(unsigned long);
-	old_size = memcg_shrinker_map_size;
-	if (size <= old_size)
-		return 0;
-
-	mutex_lock(&memcg_shrinker_map_mutex);
-	if (!root_mem_cgroup)
-		goto unlock;
-
-	for_each_mem_cgroup(memcg) {
-		if (mem_cgroup_is_root(memcg))
-			continue;
-		ret = memcg_expand_one_shrinker_map(memcg, size, old_size);
-		if (ret) {
-			mem_cgroup_iter_break(NULL, memcg);
-			goto unlock;
-		}
-	}
-unlock:
-	if (!ret)
-		memcg_shrinker_map_size = size;
-	mutex_unlock(&memcg_shrinker_map_mutex);
-	return ret;
-}
-
-void memcg_set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
-{
-	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct memcg_shrinker_map *map;
-
-		rcu_read_lock();
-		map = rcu_dereference(memcg->nodeinfo[nid]->shrinker_map);
-		/* Pairs with smp mb in shrink_slab() */
-		smp_mb__before_atomic();
-		set_bit(shrinker_id, map->map);
-		rcu_read_unlock();
-	}
-}
-
 /**
  * mem_cgroup_css_from_page - css of the memcg associated with a page
  * @page: page of interest
@@ -5242,11 +5118,11 @@ static int mem_cgroup_css_online(struct
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	/*
-	 * A memcg must be visible for memcg_expand_shrinker_maps()
+	 * A memcg must be visible for expand_shrinker_maps()
 	 * by the time the maps are allocated. So, we allocate maps
 	 * here, when for_each_mem_cgroup() can't skip it.
 	 */
-	if (memcg_alloc_shrinker_maps(memcg)) {
+	if (alloc_shrinker_maps(memcg)) {
 		mem_cgroup_id_remove(memcg);
 		return -ENOMEM;
 	}
@@ -5310,7 +5186,7 @@ static void mem_cgroup_css_free(struct c
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
-	memcg_free_shrinker_maps(memcg);
+	free_shrinker_maps(memcg);
 	memcg_free_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
--- a/mm/vmscan.c~mm-vmscan-consolidate-shrinker_maps-handling-code
+++ a/mm/vmscan.c
@@ -185,6 +185,132 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_MEMCG
+
+static int memcg_shrinker_map_size;
+static DEFINE_MUTEX(memcg_shrinker_map_mutex);
+
+static void free_shrinker_map_rcu(struct rcu_head *head)
+{
+	kvfree(container_of(head, struct memcg_shrinker_map, rcu));
+}
+
+static int expand_one_shrinker_map(struct mem_cgroup *memcg,
+				   int size, int old_size)
+{
+	struct memcg_shrinker_map *new, *old;
+	struct mem_cgroup_per_node *pn;
+	int nid;
+
+	lockdep_assert_held(&memcg_shrinker_map_mutex);
+
+	for_each_node(nid) {
+		pn = memcg->nodeinfo[nid];
+		old = rcu_dereference_protected(pn->shrinker_map, true);
+		/* Not yet online memcg */
+		if (!old)
+			return 0;
+
+		new = kvmalloc_node(sizeof(*new) + size, GFP_KERNEL, nid);
+		if (!new)
+			return -ENOMEM;
+
+		/* Set all old bits, clear all new bits */
+		memset(new->map, (int)0xff, old_size);
+		memset((void *)new->map + old_size, 0, size - old_size);
+
+		rcu_assign_pointer(pn->shrinker_map, new);
+		call_rcu(&old->rcu, free_shrinker_map_rcu);
+	}
+
+	return 0;
+}
+
+void free_shrinker_maps(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup_per_node *pn;
+	struct memcg_shrinker_map *map;
+	int nid;
+
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	for_each_node(nid) {
+		pn = memcg->nodeinfo[nid];
+		map = rcu_dereference_protected(pn->shrinker_map, true);
+		kvfree(map);
+		rcu_assign_pointer(pn->shrinker_map, NULL);
+	}
+}
+
+int alloc_shrinker_maps(struct mem_cgroup *memcg)
+{
+	struct memcg_shrinker_map *map;
+	int nid, size, ret = 0;
+
+	if (mem_cgroup_is_root(memcg))
+		return 0;
+
+	mutex_lock(&memcg_shrinker_map_mutex);
+	size = memcg_shrinker_map_size;
+	for_each_node(nid) {
+		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
+		if (!map) {
+			free_shrinker_maps(memcg);
+			ret = -ENOMEM;
+			break;
+		}
+		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, map);
+	}
+	mutex_unlock(&memcg_shrinker_map_mutex);
+
+	return ret;
+}
+
+static int expand_shrinker_maps(int new_id)
+{
+	int size, old_size, ret = 0;
+	struct mem_cgroup *memcg;
+
+	size = DIV_ROUND_UP(new_id + 1, BITS_PER_LONG) * sizeof(unsigned long);
+	old_size = memcg_shrinker_map_size;
+	if (size <= old_size)
+		return 0;
+
+	mutex_lock(&memcg_shrinker_map_mutex);
+	if (!root_mem_cgroup)
+		goto unlock;
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		if (mem_cgroup_is_root(memcg))
+			continue;
+		ret = expand_one_shrinker_map(memcg, size, old_size);
+		if (ret) {
+			mem_cgroup_iter_break(NULL, memcg);
+			goto unlock;
+		}
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+unlock:
+	if (!ret)
+		memcg_shrinker_map_size = size;
+	mutex_unlock(&memcg_shrinker_map_mutex);
+	return ret;
+}
+
+void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
+{
+	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
+		struct memcg_shrinker_map *map;
+
+		rcu_read_lock();
+		map = rcu_dereference(memcg->nodeinfo[nid]->shrinker_map);
+		/* Pairs with smp mb in shrink_slab() */
+		smp_mb__before_atomic();
+		set_bit(shrinker_id, map->map);
+		rcu_read_unlock();
+	}
+}
+
 /*
  * We allow subsystems to populate their shrinker-related
  * LRU lists before register_shrinker_prepared() is called
@@ -212,7 +338,7 @@ static int prealloc_memcg_shrinker(struc
 		goto unlock;
 
 	if (id >= shrinker_nr_max) {
-		if (memcg_expand_shrinker_maps(id)) {
+		if (expand_shrinker_maps(id)) {
 			idr_remove(&shrinker_idr, id);
 			goto unlock;
 		}
@@ -590,7 +716,7 @@ static unsigned long shrink_slab_memcg(g
 			 * case, we invoke the shrinker one more time and reset
 			 * the bit if it reports that it is not empty anymore.
 			 * The memory barrier here pairs with the barrier in
-			 * memcg_set_shrinker_bit():
+			 * set_shrinker_bit():
 			 *
 			 * list_lru_add()     shrink_slab_memcg()
 			 *   list_add_tail()    clear_bit()
@@ -602,7 +728,7 @@ static unsigned long shrink_slab_memcg(g
 			if (ret == SHRINK_EMPTY)
 				ret = 0;
 			else
-				memcg_set_shrinker_bit(memcg, nid, i);
+				set_shrinker_bit(memcg, nid, i);
 		}
 		freed += ret;
 
_
