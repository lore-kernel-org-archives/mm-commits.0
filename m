Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6C3C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357349AbiCYBcY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357343AbiCYBcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB72B3DDED
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58744B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB991C340ED;
        Fri, 25 Mar 2022 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171828;
        bh=2IKPu4dzV5KAjHCGyasVqdq8m7rhw03dyrxP4yz//6s=;
        h=Date:To:From:Subject:From;
        b=SZ06e2MBxkp/T/C5iHLk8DByVchvug549edkmohg9m9I5QkKSy7DGRs+e4A/8+4Lk
         I6Ysd4135fxYflLGokv152YEYRP6SbLygtdEv5FDSz49pZg+vqeVnjAkn/3KNkQk6E
         4URaq9dg0Qrz4WICKswzICf6sC89h3Qo+7O1uFsg=
Date:   Thu, 24 Mar 2022 18:30:27 -0700
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
Subject: [merged] mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch removed from -mm tree
Message-Id: <20220325013027.DB991C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: transpose the array of per-node per-memcg lru lists
has been removed from the -mm tree.  Its filename was
     mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: transpose the array of per-node per-memcg lru lists

Patch series "Optimize list lru memory consumption", v6.

In our server, we found a suspected memory leak problem.  The kmalloc-32
consumes more than 6GB of memory.  Other kmem_caches consume less than 2GB
memory.

After our in-depth analysis, the memory consumption of kmalloc-32 slab
cache is the cause of list_lru_one allocation.

  crash> p
  memcg_nr_cache_ids memcg_nr_cache_ids = $2 = 24574

memcg_nr_cache_ids is very large and memory consumption of each list_lru
can be calculated with the following formula.

  num_numa_node * memcg_nr_cache_ids * 32 (kmalloc-32)

There are 4 numa nodes in our system, so each list_lru consumes ~3MB.

  crash> list super_blocks | wc -l
  952

Every mount will register 2 list lrus, one is for inode, another is for
dentry.  There are 952 super_blocks.  So the total memory is 952 * 2 * 3
MB (~5.6GB).  But now the number of memory cgroups is less than 500.  So I
guess more than 12286 memory cgroups have been created on this machine (I
do not know why there are so many cgroups, it may be a user's bug or the
user really want to do that).  Because memcg_nr_cache_ids has not been
reduced to a suitable value.  It leads to waste a lot of memory.  If we
want to reduce memcg_nr_cache_ids, we have to *reboot* the server.  This
is not what we want.

In order to reduce memcg_nr_cache_ids, I had posted a patchset [1] to do
this.  But this did not fundamentally solve the problem.

We currently allocate scope for every memcg to be able to tracked on every
superblock instantiated in the system, regardless of whether that
superblock is even accessible to that memcg.

These huge memcg counts come from container hosts where memcgs are
confined to just a small subset of the total number of superblocks that
instantiated at any given point in time.

For these systems with huge container counts, list_lru does not need the
capability of tracking every memcg on every superblock.

What it comes down to is that the list_lru is only needed for a given
memcg if that memcg is instatiating and freeing objects on a given
list_lru.

As Dave said, "Which makes me think we should be moving more towards 'add
the memcg to the list_lru at the first insert' model rather than
'instantiate all at memcg init time just in case'."

This patchset aims to optimize the list lru memory consumption from
different aspects.

I had done a easy test to show the optimization.  I create 10k memory
cgroups and mount 10k filesystems in the systems.  We use free command to
show how many memory does the systems comsumes after this operation (There
are 2 numa nodes in the system).

        +-----------------------+------------------------+
        |      condition        |   memory consumption   |
        +-----------------------+------------------------+
        | without this patchset |        24464 MB        |
        +-----------------------+------------------------+
        |     after patch 1     |        21957 MB        | <--------+
        +-----------------------+------------------------+          |
        |     after patch 10    |         6895 MB        |          |
        +-----------------------+------------------------+          |
        |     after patch 12    |         4367 MB        |          |
        +-----------------------+------------------------+          |
                                                                    |
        The more the number of nodes, the more obvious the effect---+

BTW, there was a recent discussion [2] on the same issue.

[1] https://lore.kernel.org/all/20210428094949.43579-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/all/20210405054848.GA1077931@in.ibm.com/

This series not only optimizes the memory usage of list_lru but also
simplifies the code.


This patch (of 16):

The current scheme of maintaining per-node per-memcg lru lists looks like:
  struct list_lru {
    struct list_lru_node *node;           (for each node)
      struct list_lru_memcg *memcg_lrus;
        struct list_lru_one *lru[];       (for each memcg)
  }

By effectively transposing the two-dimension array of list_lru_one's structures
(per-node per-memcg => per-memcg per-node) it's possible to save some memory
and simplify alloc/dealloc paths. The new scheme looks like:
  struct list_lru {
    struct list_lru_memcg *mlrus;
      struct list_lru_per_memcg *mlru[];  (for each memcg)
        struct list_lru_one node[0];      (for each node)
  }

Memory savings are coming from not only 'struct rcu_head' but also some
pointer arrays used to store the pointer to 'struct list_lru_one'.  The
array is per node and its size is 8 (a pointer) * num_memcgs.  So the
total size of the arrays is 8 * num_nodes * memcg_nr_cache_ids.  After
this patch, the size becomes 8 * memcg_nr_cache_ids.

Link: https://lkml.kernel.org/r/20220228122126.37293-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220228122126.37293-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   17 +--
 mm/list_lru.c            |  206 +++++++++++++------------------------
 2 files changed, 86 insertions(+), 137 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists
+++ a/include/linux/list_lru.h
@@ -31,10 +31,15 @@ struct list_lru_one {
 	long			nr_items;
 };
 
+struct list_lru_per_memcg {
+	/* array of per cgroup per node lists, indexed by node id */
+	struct list_lru_one	node[0];
+};
+
 struct list_lru_memcg {
-	struct rcu_head		rcu;
+	struct rcu_head			rcu;
 	/* array of per cgroup lists, indexed by memcg_cache_id */
-	struct list_lru_one	*lru[];
+	struct list_lru_per_memcg	*mlru[];
 };
 
 struct list_lru_node {
@@ -42,11 +47,7 @@ struct list_lru_node {
 	spinlock_t		lock;
 	/* global list, used for the root cgroup in cgroup aware lrus */
 	struct list_lru_one	lru;
-#ifdef CONFIG_MEMCG_KMEM
-	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
-	struct list_lru_memcg	__rcu *memcg_lrus;
-#endif
-	long nr_items;
+	long			nr_items;
 } ____cacheline_aligned_in_smp;
 
 struct list_lru {
@@ -55,6 +56,8 @@ struct list_lru {
 	struct list_head	list;
 	int			shrinker_id;
 	bool			memcg_aware;
+	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
+	struct list_lru_memcg	__rcu *mlrus;
 #endif
 };
 
--- a/mm/list_lru.c~mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists
+++ a/mm/list_lru.c
@@ -49,35 +49,37 @@ static int lru_shrinker_id(struct list_l
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru_node *nlru, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 {
-	struct list_lru_memcg *memcg_lrus;
+	struct list_lru_memcg *mlrus;
+	struct list_lru_node *nlru = &lru->node[nid];
+
 	/*
 	 * Either lock or RCU protects the array of per cgroup lists
-	 * from relocation (see memcg_update_list_lru_node).
+	 * from relocation (see memcg_update_list_lru).
 	 */
-	memcg_lrus = rcu_dereference_check(nlru->memcg_lrus,
-					   lockdep_is_held(&nlru->lock));
-	if (memcg_lrus && idx >= 0)
-		return memcg_lrus->lru[idx];
+	mlrus = rcu_dereference_check(lru->mlrus, lockdep_is_held(&nlru->lock));
+	if (mlrus && idx >= 0)
+		return &mlrus->mlru[idx]->node[nid];
 	return &nlru->lru;
 }
 
 static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru_node *nlru, void *ptr,
+list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
 		   struct mem_cgroup **memcg_ptr)
 {
+	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l = &nlru->lru;
 	struct mem_cgroup *memcg = NULL;
 
-	if (!nlru->memcg_lrus)
+	if (!lru->mlrus)
 		goto out;
 
 	memcg = mem_cgroup_from_obj(ptr);
 	if (!memcg)
 		goto out;
 
-	l = list_lru_from_memcg_idx(nlru, memcg_cache_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_cache_id(memcg));
 out:
 	if (memcg_ptr)
 		*memcg_ptr = memcg;
@@ -103,18 +105,18 @@ static inline bool list_lru_memcg_aware(
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru_node *nlru, int idx)
+list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 {
-	return &nlru->lru;
+	return &lru->node[nid].lru;
 }
 
 static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru_node *nlru, void *ptr,
+list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
 		   struct mem_cgroup **memcg_ptr)
 {
 	if (memcg_ptr)
 		*memcg_ptr = NULL;
-	return &nlru->lru;
+	return &lru->node[nid].lru;
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -127,7 +129,7 @@ bool list_lru_add(struct list_lru *lru,
 
 	spin_lock(&nlru->lock);
 	if (list_empty(item)) {
-		l = list_lru_from_kmem(nlru, item, &memcg);
+		l = list_lru_from_kmem(lru, nid, item, &memcg);
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
 		if (!l->nr_items++)
@@ -150,7 +152,7 @@ bool list_lru_del(struct list_lru *lru,
 
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
-		l = list_lru_from_kmem(nlru, item, NULL);
+		l = list_lru_from_kmem(lru, nid, item, NULL);
 		list_del_init(item);
 		l->nr_items--;
 		nlru->nr_items--;
@@ -180,12 +182,11 @@ EXPORT_SYMBOL_GPL(list_lru_isolate_move)
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(nlru, memcg_cache_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_cache_id(memcg));
 	count = READ_ONCE(l->nr_items);
 	rcu_read_unlock();
 
@@ -206,16 +207,16 @@ unsigned long list_lru_count_node(struct
 EXPORT_SYMBOL_GPL(list_lru_count_node);
 
 static unsigned long
-__list_lru_walk_one(struct list_lru_node *nlru, int memcg_idx,
+__list_lru_walk_one(struct list_lru *lru, int nid, int memcg_idx,
 		    list_lru_walk_cb isolate, void *cb_arg,
 		    unsigned long *nr_to_walk)
 {
-
+	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
 
-	l = list_lru_from_memcg_idx(nlru, memcg_idx);
+	l = list_lru_from_memcg_idx(lru, nid, memcg_idx);
 restart:
 	list_for_each_safe(item, n, &l->list) {
 		enum lru_status ret;
@@ -272,8 +273,8 @@ list_lru_walk_one(struct list_lru *lru,
 	unsigned long ret;
 
 	spin_lock(&nlru->lock);
-	ret = __list_lru_walk_one(nlru, memcg_cache_id(memcg), isolate, cb_arg,
-				  nr_to_walk);
+	ret = __list_lru_walk_one(lru, nid, memcg_cache_id(memcg), isolate,
+				  cb_arg, nr_to_walk);
 	spin_unlock(&nlru->lock);
 	return ret;
 }
@@ -288,8 +289,8 @@ list_lru_walk_one_irq(struct list_lru *l
 	unsigned long ret;
 
 	spin_lock_irq(&nlru->lock);
-	ret = __list_lru_walk_one(nlru, memcg_cache_id(memcg), isolate, cb_arg,
-				  nr_to_walk);
+	ret = __list_lru_walk_one(lru, nid, memcg_cache_id(memcg), isolate,
+				  cb_arg, nr_to_walk);
 	spin_unlock_irq(&nlru->lock);
 	return ret;
 }
@@ -308,7 +309,7 @@ unsigned long list_lru_walk_node(struct
 			struct list_lru_node *nlru = &lru->node[nid];
 
 			spin_lock(&nlru->lock);
-			isolated += __list_lru_walk_one(nlru, memcg_idx,
+			isolated += __list_lru_walk_one(lru, nid, memcg_idx,
 							isolate, cb_arg,
 							nr_to_walk);
 			spin_unlock(&nlru->lock);
@@ -328,166 +329,111 @@ static void init_one_lru(struct list_lru
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static void __memcg_destroy_list_lru_node(struct list_lru_memcg *memcg_lrus,
-					  int begin, int end)
+static void memcg_destroy_list_lru_range(struct list_lru_memcg *mlrus,
+					 int begin, int end)
 {
 	int i;
 
 	for (i = begin; i < end; i++)
-		kfree(memcg_lrus->lru[i]);
+		kfree(mlrus->mlru[i]);
 }
 
-static int __memcg_init_list_lru_node(struct list_lru_memcg *memcg_lrus,
-				      int begin, int end)
+static int memcg_init_list_lru_range(struct list_lru_memcg *mlrus,
+				     int begin, int end)
 {
 	int i;
 
 	for (i = begin; i < end; i++) {
-		struct list_lru_one *l;
+		int nid;
+		struct list_lru_per_memcg *mlru;
 
-		l = kmalloc(sizeof(struct list_lru_one), GFP_KERNEL);
-		if (!l)
+		mlru = kmalloc(struct_size(mlru, node, nr_node_ids), GFP_KERNEL);
+		if (!mlru)
 			goto fail;
 
-		init_one_lru(l);
-		memcg_lrus->lru[i] = l;
+		for_each_node(nid)
+			init_one_lru(&mlru->node[nid]);
+		mlrus->mlru[i] = mlru;
 	}
 	return 0;
 fail:
-	__memcg_destroy_list_lru_node(memcg_lrus, begin, i);
+	memcg_destroy_list_lru_range(mlrus, begin, i);
 	return -ENOMEM;
 }
 
-static int memcg_init_list_lru_node(struct list_lru_node *nlru)
+static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
-	struct list_lru_memcg *memcg_lrus;
+	struct list_lru_memcg *mlrus;
 	int size = memcg_nr_cache_ids;
 
-	memcg_lrus = kvmalloc(struct_size(memcg_lrus, lru, size), GFP_KERNEL);
-	if (!memcg_lrus)
+	lru->memcg_aware = memcg_aware;
+	if (!memcg_aware)
+		return 0;
+
+	mlrus = kvmalloc(struct_size(mlrus, mlru, size), GFP_KERNEL);
+	if (!mlrus)
 		return -ENOMEM;
 
-	if (__memcg_init_list_lru_node(memcg_lrus, 0, size)) {
-		kvfree(memcg_lrus);
+	if (memcg_init_list_lru_range(mlrus, 0, size)) {
+		kvfree(mlrus);
 		return -ENOMEM;
 	}
-	RCU_INIT_POINTER(nlru->memcg_lrus, memcg_lrus);
+	RCU_INIT_POINTER(lru->mlrus, mlrus);
 
 	return 0;
 }
 
-static void memcg_destroy_list_lru_node(struct list_lru_node *nlru)
+static void memcg_destroy_list_lru(struct list_lru *lru)
 {
-	struct list_lru_memcg *memcg_lrus;
+	struct list_lru_memcg *mlrus;
+
+	if (!list_lru_memcg_aware(lru))
+		return;
+
 	/*
 	 * This is called when shrinker has already been unregistered,
 	 * and nobody can use it. So, there is no need to use kvfree_rcu().
 	 */
-	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus, true);
-	__memcg_destroy_list_lru_node(memcg_lrus, 0, memcg_nr_cache_ids);
-	kvfree(memcg_lrus);
+	mlrus = rcu_dereference_protected(lru->mlrus, true);
+	memcg_destroy_list_lru_range(mlrus, 0, memcg_nr_cache_ids);
+	kvfree(mlrus);
 }
 
-static int memcg_update_list_lru_node(struct list_lru_node *nlru,
-				      int old_size, int new_size)
+static int memcg_update_list_lru(struct list_lru *lru, int old_size, int new_size)
 {
 	struct list_lru_memcg *old, *new;
 
 	BUG_ON(old_size > new_size);
 
-	old = rcu_dereference_protected(nlru->memcg_lrus,
+	old = rcu_dereference_protected(lru->mlrus,
 					lockdep_is_held(&list_lrus_mutex));
-	new = kvmalloc(struct_size(new, lru, new_size), GFP_KERNEL);
+	new = kvmalloc(struct_size(new, mlru, new_size), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
-	if (__memcg_init_list_lru_node(new, old_size, new_size)) {
+	if (memcg_init_list_lru_range(new, old_size, new_size)) {
 		kvfree(new);
 		return -ENOMEM;
 	}
 
-	memcpy(&new->lru, &old->lru, flex_array_size(new, lru, old_size));
-	rcu_assign_pointer(nlru->memcg_lrus, new);
+	memcpy(&new->mlru, &old->mlru, flex_array_size(new, mlru, old_size));
+	rcu_assign_pointer(lru->mlrus, new);
 	kvfree_rcu(old, rcu);
 	return 0;
 }
 
-static void memcg_cancel_update_list_lru_node(struct list_lru_node *nlru,
-					      int old_size, int new_size)
-{
-	struct list_lru_memcg *memcg_lrus;
-
-	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus,
-					       lockdep_is_held(&list_lrus_mutex));
-	/* do not bother shrinking the array back to the old size, because we
-	 * cannot handle allocation failures here */
-	__memcg_destroy_list_lru_node(memcg_lrus, old_size, new_size);
-}
-
-static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
-{
-	int i;
-
-	lru->memcg_aware = memcg_aware;
-
-	if (!memcg_aware)
-		return 0;
-
-	for_each_node(i) {
-		if (memcg_init_list_lru_node(&lru->node[i]))
-			goto fail;
-	}
-	return 0;
-fail:
-	for (i = i - 1; i >= 0; i--) {
-		if (!lru->node[i].memcg_lrus)
-			continue;
-		memcg_destroy_list_lru_node(&lru->node[i]);
-	}
-	return -ENOMEM;
-}
-
-static void memcg_destroy_list_lru(struct list_lru *lru)
-{
-	int i;
-
-	if (!list_lru_memcg_aware(lru))
-		return;
-
-	for_each_node(i)
-		memcg_destroy_list_lru_node(&lru->node[i]);
-}
-
-static int memcg_update_list_lru(struct list_lru *lru,
-				 int old_size, int new_size)
-{
-	int i;
-
-	for_each_node(i) {
-		if (memcg_update_list_lru_node(&lru->node[i],
-					       old_size, new_size))
-			goto fail;
-	}
-	return 0;
-fail:
-	for (i = i - 1; i >= 0; i--) {
-		if (!lru->node[i].memcg_lrus)
-			continue;
-
-		memcg_cancel_update_list_lru_node(&lru->node[i],
-						  old_size, new_size);
-	}
-	return -ENOMEM;
-}
-
 static void memcg_cancel_update_list_lru(struct list_lru *lru,
 					 int old_size, int new_size)
 {
-	int i;
+	struct list_lru_memcg *mlrus;
 
-	for_each_node(i)
-		memcg_cancel_update_list_lru_node(&lru->node[i],
-						  old_size, new_size);
+	mlrus = rcu_dereference_protected(lru->mlrus,
+					  lockdep_is_held(&list_lrus_mutex));
+	/*
+	 * Do not bother shrinking the array back to the old size, because we
+	 * cannot handle allocation failures here.
+	 */
+	memcg_destroy_list_lru_range(mlrus, old_size, new_size);
 }
 
 int memcg_update_all_list_lrus(int new_size)
@@ -524,8 +470,8 @@ static void memcg_drain_list_lru_node(st
 	 */
 	spin_lock_irq(&nlru->lock);
 
-	src = list_lru_from_memcg_idx(nlru, src_idx);
-	dst = list_lru_from_memcg_idx(nlru, dst_idx);
+	src = list_lru_from_memcg_idx(lru, nid, src_idx);
+	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
 
 	list_splice_init(&src->list, &dst->list);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


