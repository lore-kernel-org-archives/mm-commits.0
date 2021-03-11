Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2414C43333
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD1DD64F92
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhCKUhq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhCKUh2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB5364F8B;
        Thu, 11 Mar 2021 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615495048;
        bh=SPC3A6ybJu69WW0sTkKqk8BhVoKD3qLM5Hy2qE4np2s=;
        h=Date:From:To:Subject:From;
        b=KEyKQCH/WZ6TptZsw9vhSQbC/kh9k7EEgyP73/rBGHVvP8wELXKDeys4Dv3pDf/PM
         W066XttM1HXUtFTy/4OV1IWs3xl1i2L6vtQj8g4ZdM+ztN94KeIhZ1k0NqizxAHv1B
         6niwLuQiaIsIxgHHv0D/++SLmB3+nSN1P968YfH8=
Date:   Thu, 11 Mar 2021 12:37:27 -0800
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  +
 mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch added to -mm tree
Message-ID: <20210311203727.jaa5Q9zV2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rename shrinker_map to shrinker_info
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: memcontrol: rename shrinker_map to shrinker_info

The following patch is going to add nr_deferred into shrinker_map, the
change will make shrinker_map not only include map anymore, so rename it
to "memcg_shrinker_info".  And this should make the patch adding
nr_deferred cleaner and readable and make review easier.  Also remove the
"memcg_" prefix.

Link: https://lkml.kernel.org/r/20210311190845.9708-7-shy828301@gmail.com
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

 include/linux/memcontrol.h |    8 ++--
 mm/memcontrol.c            |    6 +--
 mm/vmscan.c                |   58 +++++++++++++++++------------------
 3 files changed, 36 insertions(+), 36 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rename-shrinker_map-to-shrinker_info
+++ a/include/linux/memcontrol.h
@@ -117,7 +117,7 @@ struct batched_lruvec_stat {
  * Bitmap of shrinker::id corresponding to memcg-aware shrinkers,
  * which have elements charged to this memcg.
  */
-struct memcg_shrinker_map {
+struct shrinker_info {
 	struct rcu_head rcu;
 	unsigned long map[];
 };
@@ -145,7 +145,7 @@ struct mem_cgroup_per_node {
 
 	struct mem_cgroup_reclaim_iter	iter;
 
-	struct memcg_shrinker_map __rcu	*shrinker_map;
+	struct shrinker_info __rcu	*shrinker_info;
 
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long		usage_in_excess;/* Set to the value by which */
@@ -1533,8 +1533,8 @@ static inline bool mem_cgroup_under_sock
 	return false;
 }
 
-int alloc_shrinker_maps(struct mem_cgroup *memcg);
-void free_shrinker_maps(struct mem_cgroup *memcg);
+int alloc_shrinker_info(struct mem_cgroup *memcg);
+void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 #else
 #define mem_cgroup_sockets_enabled 0
--- a/mm/memcontrol.c~mm-memcontrol-rename-shrinker_map-to-shrinker_info
+++ a/mm/memcontrol.c
@@ -5131,11 +5131,11 @@ static int mem_cgroup_css_online(struct
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	/*
-	 * A memcg must be visible for expand_shrinker_maps()
+	 * A memcg must be visible for expand_shrinker_info()
 	 * by the time the maps are allocated. So, we allocate maps
 	 * here, when for_each_mem_cgroup() can't skip it.
 	 */
-	if (alloc_shrinker_maps(memcg)) {
+	if (alloc_shrinker_info(memcg)) {
 		mem_cgroup_id_remove(memcg);
 		return -ENOMEM;
 	}
@@ -5199,7 +5199,7 @@ static void mem_cgroup_css_free(struct c
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
-	free_shrinker_maps(memcg);
+	free_shrinker_info(memcg);
 	memcg_free_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
--- a/mm/vmscan.c~mm-memcontrol-rename-shrinker_map-to-shrinker_info
+++ a/mm/vmscan.c
@@ -192,16 +192,16 @@ static inline int shrinker_map_size(int
 	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
 }
 
-static int expand_one_shrinker_map(struct mem_cgroup *memcg,
-				   int size, int old_size)
+static int expand_one_shrinker_info(struct mem_cgroup *memcg,
+				    int size, int old_size)
 {
-	struct memcg_shrinker_map *new, *old;
+	struct shrinker_info *new, *old;
 	struct mem_cgroup_per_node *pn;
 	int nid;
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
-		old = rcu_dereference_protected(pn->shrinker_map, true);
+		old = rcu_dereference_protected(pn->shrinker_info, true);
 		/* Not yet online memcg */
 		if (!old)
 			return 0;
@@ -214,17 +214,17 @@ static int expand_one_shrinker_map(struc
 		memset(new->map, (int)0xff, old_size);
 		memset((void *)new->map + old_size, 0, size - old_size);
 
-		rcu_assign_pointer(pn->shrinker_map, new);
+		rcu_assign_pointer(pn->shrinker_info, new);
 		kvfree_rcu(old, rcu);
 	}
 
 	return 0;
 }
 
-void free_shrinker_maps(struct mem_cgroup *memcg)
+void free_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_per_node *pn;
-	struct memcg_shrinker_map *map;
+	struct shrinker_info *info;
 	int nid;
 
 	if (mem_cgroup_is_root(memcg))
@@ -232,15 +232,15 @@ void free_shrinker_maps(struct mem_cgrou
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
-		map = rcu_dereference_protected(pn->shrinker_map, true);
-		kvfree(map);
-		rcu_assign_pointer(pn->shrinker_map, NULL);
+		info = rcu_dereference_protected(pn->shrinker_info, true);
+		kvfree(info);
+		rcu_assign_pointer(pn->shrinker_info, NULL);
 	}
 }
 
-int alloc_shrinker_maps(struct mem_cgroup *memcg)
+int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
-	struct memcg_shrinker_map *map;
+	struct shrinker_info *info;
 	int nid, size, ret = 0;
 
 	if (mem_cgroup_is_root(memcg))
@@ -249,20 +249,20 @@ int alloc_shrinker_maps(struct mem_cgrou
 	down_write(&shrinker_rwsem);
 	size = shrinker_map_size(shrinker_nr_max);
 	for_each_node(nid) {
-		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
-		if (!map) {
-			free_shrinker_maps(memcg);
+		info = kvzalloc_node(sizeof(*info) + size, GFP_KERNEL, nid);
+		if (!info) {
+			free_shrinker_info(memcg);
 			ret = -ENOMEM;
 			break;
 		}
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, map);
+		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
 	up_write(&shrinker_rwsem);
 
 	return ret;
 }
 
-static int expand_shrinker_maps(int new_id)
+static int expand_shrinker_info(int new_id)
 {
 	int size, old_size, ret = 0;
 	int new_nr_max = new_id + 1;
@@ -282,7 +282,7 @@ static int expand_shrinker_maps(int new_
 	do {
 		if (mem_cgroup_is_root(memcg))
 			continue;
-		ret = expand_one_shrinker_map(memcg, size, old_size);
+		ret = expand_one_shrinker_info(memcg, size, old_size);
 		if (ret) {
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
@@ -298,13 +298,13 @@ out:
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct memcg_shrinker_map *map;
+		struct shrinker_info *info;
 
 		rcu_read_lock();
-		map = rcu_dereference(memcg->nodeinfo[nid]->shrinker_map);
+		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
 		/* Pairs with smp mb in shrink_slab() */
 		smp_mb__before_atomic();
-		set_bit(shrinker_id, map->map);
+		set_bit(shrinker_id, info->map);
 		rcu_read_unlock();
 	}
 }
@@ -335,7 +335,7 @@ static int prealloc_memcg_shrinker(struc
 		goto unlock;
 
 	if (id >= shrinker_nr_max) {
-		if (expand_shrinker_maps(id)) {
+		if (expand_shrinker_info(id)) {
 			idr_remove(&shrinker_idr, id);
 			goto unlock;
 		}
@@ -665,7 +665,7 @@ static unsigned long do_shrink_slab(stru
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct mem_cgroup *memcg, int priority)
 {
-	struct memcg_shrinker_map *map;
+	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
 	int i;
 
@@ -675,12 +675,12 @@ static unsigned long shrink_slab_memcg(g
 	if (!down_read_trylock(&shrinker_rwsem))
 		return 0;
 
-	map = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_map,
-					true);
-	if (unlikely(!map))
+	info = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
+					 true);
+	if (unlikely(!info))
 		goto unlock;
 
-	for_each_set_bit(i, map->map, shrinker_nr_max) {
+	for_each_set_bit(i, info->map, shrinker_nr_max) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -691,7 +691,7 @@ static unsigned long shrink_slab_memcg(g
 		shrinker = idr_find(&shrinker_idr, i);
 		if (unlikely(!shrinker || shrinker == SHRINKER_REGISTERING)) {
 			if (!shrinker)
-				clear_bit(i, map->map);
+				clear_bit(i, info->map);
 			continue;
 		}
 
@@ -702,7 +702,7 @@ static unsigned long shrink_slab_memcg(g
 
 		ret = do_shrink_slab(&sc, shrinker, priority);
 		if (ret == SHRINK_EMPTY) {
-			clear_bit(i, map->map);
+			clear_bit(i, info->map);
 			/*
 			 * After the shrinker reported that it had no objects to
 			 * free, but before we cleared the corresponding bit in
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
mm-vmscan-consolidate-shrinker_maps-handling-code.patch
mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation.patch
mm-vmscan-remove-memcg_shrinker_map_size.patch
mm-vmscan-use-kvfree_rcu-instead-of-call_rcu.patch
mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
mm-vmscan-add-shrinker_info_protected-helper.patch
mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch
mm-vmscan-add-per-memcg-shrinker-nr_deferred.patch
mm-vmscan-use-per-memcg-nr_deferred-of-shrinker.patch
mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers.patch
mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

