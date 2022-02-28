Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2723CC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiB1TAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiB1S7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:59:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FED56623C
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8165BB8162D
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13646C340F1;
        Mon, 28 Feb 2022 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646074752;
        bh=WkI6oUgeHu9LW5cjxgibsc87qvoE1ZA2HF9PE8b7O4s=;
        h=Date:To:From:Subject:From;
        b=Lzc3ZrTs7d9c10r6rB4xllRObCwHErxy06gmCtroHdGTD0By1nxhw82S/f4EYaFeC
         vg43WR+oaQ8YHOLnbMp6x6GDClQfLJOtnGpxUa3OZGQ28lJh5m9eCKzC3QmFPv3ll3
         boCMpv0XI/cRd/86qJj0Y7XMWFs0gTUfGpCO7hlI=
Date:   Mon, 28 Feb 2022 10:59:11 -0800
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
Subject: + mm-list_lru-allocate-list_lru_one-only-when-needed.patch added to -mm tree
Message-Id: <20220228185912.13646C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: allocate list_lru_one only when needed
has been added to the -mm tree.  Its filename is
     mm-list_lru-allocate-list_lru_one-only-when-needed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-allocate-list_lru_one-only-when-needed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-allocate-list_lru_one-only-when-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: allocate list_lru_one only when needed

In our server, we found a suspected memory leak problem.  The kmalloc-32
consumes more than 6GB of memory.  Other kmem_caches consume less than 2GB
memory.

After our in-depth analysis, the memory consumption of kmalloc-32 slab
cache is the cause of list_lru_one allocation.

  crash> p memcg_nr_cache_ids
  memcg_nr_cache_ids = $2 = 24574

memcg_nr_cache_ids is very large and memory consumption of each list_lru
can be calculated with the following formula.

  num_numa_node * memcg_nr_cache_ids * 32 (kmalloc-32)

There are 4 numa nodes in our system, so each list_lru consumes ~3MB.

  crash> list super_blocks | wc -l
  952

Every mount will register 2 list lrus, one is for inode, another is for
dentry.  There are 952 super_blocks.  So the total memory is 952 * 2 * 3
MB (~5.6GB).  But the number of memory cgroup is less than 500.  So I
guess more than 12286 containers have been deployed on this machine (I do
not know why there are so many containers, it may be a user's bug or the
user really want to do that).  And memcg_nr_cache_ids has not been reduced
to a suitable value.  This can waste a lot of memory.

Now the infrastructure for dynamic list_lru_one allocation is ready, so
remove statically allocated memory code to save memory.

Link: https://lkml.kernel.org/r/20220228122126.37293-11-songmuchun@bytedance.com
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

 include/linux/list_lru.h |    7 +-
 mm/list_lru.c            |  121 ++++++++++++++++++++-----------------
 mm/memcontrol.c          |    6 +
 3 files changed, 77 insertions(+), 57 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-allocate-list_lru_one-only-when-needed
+++ a/include/linux/list_lru.h
@@ -32,14 +32,15 @@ struct list_lru_one {
 };
 
 struct list_lru_per_memcg {
+	struct rcu_head		rcu;
 	/* array of per cgroup per node lists, indexed by node id */
-	struct list_lru_one	node[0];
+	struct list_lru_one	node[];
 };
 
 struct list_lru_memcg {
 	struct rcu_head			rcu;
 	/* array of per cgroup lists, indexed by memcg_cache_id */
-	struct list_lru_per_memcg	*mlru[];
+	struct list_lru_per_memcg __rcu	*mlru[];
 };
 
 struct list_lru_node {
@@ -77,7 +78,7 @@ int __list_lru_init(struct list_lru *lru
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 int memcg_update_all_list_lrus(int num_memcgs);
-void memcg_drain_all_list_lrus(int src_idx, struct mem_cgroup *dst_memcg);
+void memcg_drain_all_list_lrus(struct mem_cgroup *src, struct mem_cgroup *dst);
 
 /**
  * list_lru_add: add an element to the lru list's tail
--- a/mm/list_lru.c~mm-list_lru-allocate-list_lru_one-only-when-needed
+++ a/mm/list_lru.c
@@ -60,8 +60,12 @@ list_lru_from_memcg_idx(struct list_lru
 	 * from relocation (see memcg_update_list_lru).
 	 */
 	mlrus = rcu_dereference_check(lru->mlrus, lockdep_is_held(&nlru->lock));
-	if (mlrus && idx >= 0)
-		return &mlrus->mlru[idx]->node[nid];
+	if (mlrus && idx >= 0) {
+		struct list_lru_per_memcg *mlru;
+
+		mlru = rcu_dereference_check(mlrus->mlru[idx], true);
+		return mlru ? &mlru->node[nid] : NULL;
+	}
 	return &nlru->lru;
 }
 
@@ -188,7 +192,7 @@ unsigned long list_lru_count_one(struct
 
 	rcu_read_lock();
 	l = list_lru_from_memcg_idx(lru, nid, memcg_cache_id(memcg));
-	count = READ_ONCE(l->nr_items);
+	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
 	if (unlikely(count < 0))
@@ -217,8 +221,11 @@ __list_lru_walk_one(struct list_lru *lru
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
 
-	l = list_lru_from_memcg_idx(lru, nid, memcg_idx);
 restart:
+	l = list_lru_from_memcg_idx(lru, nid, memcg_idx);
+	if (!l)
+		goto out;
+
 	list_for_each_safe(item, n, &l->list) {
 		enum lru_status ret;
 
@@ -262,6 +269,7 @@ restart:
 			BUG();
 		}
 	}
+out:
 	return isolated;
 }
 
@@ -354,20 +362,25 @@ static struct list_lru_per_memcg *memcg_
 	return mlru;
 }
 
-static int memcg_init_list_lru_range(struct list_lru_memcg *mlrus,
-				     int begin, int end)
+static void memcg_list_lru_free(struct list_lru *lru, int src_idx)
 {
-	int i;
+	struct list_lru_memcg *mlrus;
+	struct list_lru_per_memcg *mlru;
 
-	for (i = begin; i < end; i++) {
-		mlrus->mlru[i] = memcg_init_list_lru_one(GFP_KERNEL);
-		if (!mlrus->mlru[i])
-			goto fail;
-	}
-	return 0;
-fail:
-	memcg_destroy_list_lru_range(mlrus, begin, i);
-	return -ENOMEM;
+	spin_lock_irq(&lru->lock);
+	mlrus = rcu_dereference_protected(lru->mlrus, true);
+	mlru = rcu_dereference_protected(mlrus->mlru[src_idx], true);
+	rcu_assign_pointer(mlrus->mlru[src_idx], NULL);
+	spin_unlock_irq(&lru->lock);
+
+	/*
+	 * The __list_lru_walk_one() can walk the list of this node.
+	 * We need kvfree_rcu() here. And the walking of the list
+	 * is under lru->node[nid]->lock, which can serve as a RCU
+	 * read-side critical section.
+	 */
+	if (mlru)
+		kvfree_rcu(mlru, rcu);
 }
 
 static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
@@ -381,14 +394,10 @@ static int memcg_init_list_lru(struct li
 
 	spin_lock_init(&lru->lock);
 
-	mlrus = kvmalloc(struct_size(mlrus, mlru, size), GFP_KERNEL);
+	mlrus = kvzalloc(struct_size(mlrus, mlru, size), GFP_KERNEL);
 	if (!mlrus)
 		return -ENOMEM;
 
-	if (memcg_init_list_lru_range(mlrus, 0, size)) {
-		kvfree(mlrus);
-		return -ENOMEM;
-	}
 	RCU_INIT_POINTER(lru->mlrus, mlrus);
 
 	return 0;
@@ -422,13 +431,9 @@ static int memcg_update_list_lru(struct
 	if (!new)
 		return -ENOMEM;
 
-	if (memcg_init_list_lru_range(new, old_size, new_size)) {
-		kvfree(new);
-		return -ENOMEM;
-	}
-
 	spin_lock_irq(&lru->lock);
 	memcpy(&new->mlru, &old->mlru, flex_array_size(new, mlru, old_size));
+	memset(&new->mlru[old_size], 0, flex_array_size(new, mlru, new_size - old_size));
 	rcu_assign_pointer(lru->mlrus, new);
 	spin_unlock_irq(&lru->lock);
 
@@ -436,20 +441,6 @@ static int memcg_update_list_lru(struct
 	return 0;
 }
 
-static void memcg_cancel_update_list_lru(struct list_lru *lru,
-					 int old_size, int new_size)
-{
-	struct list_lru_memcg *mlrus;
-
-	mlrus = rcu_dereference_protected(lru->mlrus,
-					  lockdep_is_held(&list_lrus_mutex));
-	/*
-	 * Do not bother shrinking the array back to the old size, because we
-	 * cannot handle allocation failures here.
-	 */
-	memcg_destroy_list_lru_range(mlrus, old_size, new_size);
-}
-
 int memcg_update_all_list_lrus(int new_size)
 {
 	int ret = 0;
@@ -460,15 +451,10 @@ int memcg_update_all_list_lrus(int new_s
 	list_for_each_entry(lru, &memcg_list_lrus, list) {
 		ret = memcg_update_list_lru(lru, old_size, new_size);
 		if (ret)
-			goto fail;
+			break;
 	}
-out:
 	mutex_unlock(&list_lrus_mutex);
 	return ret;
-fail:
-	list_for_each_entry_continue_reverse(lru, &memcg_list_lrus, list)
-		memcg_cancel_update_list_lru(lru, old_size, new_size);
-	goto out;
 }
 
 static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
@@ -485,6 +471,8 @@ static void memcg_drain_list_lru_node(st
 	spin_lock_irq(&nlru->lock);
 
 	src = list_lru_from_memcg_idx(lru, nid, src_idx);
+	if (!src)
+		goto out;
 	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
 
 	list_splice_init(&src->list, &dst->list);
@@ -494,7 +482,7 @@ static void memcg_drain_list_lru_node(st
 		set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
 		src->nr_items = 0;
 	}
-
+out:
 	spin_unlock_irq(&nlru->lock);
 }
 
@@ -505,15 +493,41 @@ static void memcg_drain_list_lru(struct
 
 	for_each_node(i)
 		memcg_drain_list_lru_node(lru, i, src_idx, dst_memcg);
+
+	memcg_list_lru_free(lru, src_idx);
 }
 
-void memcg_drain_all_list_lrus(int src_idx, struct mem_cgroup *dst_memcg)
+void memcg_drain_all_list_lrus(struct mem_cgroup *src, struct mem_cgroup *dst)
 {
+	struct cgroup_subsys_state *css;
 	struct list_lru *lru;
+	int src_idx = src->kmemcg_id;
+
+	/*
+	 * Change kmemcg_id of this cgroup and all its descendants to the
+	 * parent's id, and then move all entries from this cgroup's list_lrus
+	 * to ones of the parent.
+	 *
+	 * After we have finished, all list_lrus corresponding to this cgroup
+	 * are guaranteed to remain empty. So we can safely free this cgroup's
+	 * list lrus in memcg_list_lru_free().
+	 *
+	 * Changing ->kmemcg_id to the parent can prevent memcg_list_lru_alloc()
+	 * from allocating list lrus for this cgroup after memcg_list_lru_free()
+	 * call.
+	 */
+	rcu_read_lock();
+	css_for_each_descendant_pre(css, &src->css) {
+		struct mem_cgroup *memcg;
+
+		memcg = mem_cgroup_from_css(css);
+		memcg->kmemcg_id = dst->kmemcg_id;
+	}
+	rcu_read_unlock();
 
 	mutex_lock(&list_lrus_mutex);
 	list_for_each_entry(lru, &memcg_list_lrus, list)
-		memcg_drain_list_lru(lru, src_idx, dst_memcg);
+		memcg_drain_list_lru(lru, src_idx, dst);
 	mutex_unlock(&list_lrus_mutex);
 }
 
@@ -528,7 +542,7 @@ static bool memcg_list_lru_allocated(str
 		return true;
 
 	rcu_read_lock();
-	allocated = !!rcu_dereference(lru->mlrus)->mlru[idx];
+	allocated = !!rcu_access_pointer(rcu_dereference(lru->mlrus)->mlru[idx]);
 	rcu_read_unlock();
 
 	return allocated;
@@ -576,11 +590,12 @@ int memcg_list_lru_alloc(struct mem_cgro
 	mlrus = rcu_dereference_protected(lru->mlrus, true);
 	while (i--) {
 		int index = table[i].memcg->kmemcg_id;
+		struct list_lru_per_memcg *mlru = table[i].mlru;
 
-		if (mlrus->mlru[index])
-			kfree(table[i].mlru);
+		if (index < 0 || rcu_dereference_protected(mlrus->mlru[index], true))
+			kfree(mlru);
 		else
-			mlrus->mlru[index] = table[i].mlru;
+			rcu_assign_pointer(mlrus->mlru[index], mlru);
 	}
 	spin_unlock_irqrestore(&lru->lock, flags);
 
--- a/mm/memcontrol.c~mm-list_lru-allocate-list_lru_one-only-when-needed
+++ a/mm/memcontrol.c
@@ -3706,6 +3706,10 @@ static void memcg_offline_kmem(struct me
 
 	memcg_reparent_objcgs(memcg, parent);
 
+	/*
+	 * memcg_drain_all_list_lrus() can change memcg->kmemcg_id.
+	 * Cache it to local @kmemcg_id.
+	 */
 	kmemcg_id = memcg->kmemcg_id;
 
 	/*
@@ -3714,7 +3718,7 @@ static void memcg_offline_kmem(struct me
 	 * The ordering is imposed by list_lru_node->lock taken by
 	 * memcg_drain_all_list_lrus().
 	 */
-	memcg_drain_all_list_lrus(kmemcg_id, parent);
+	memcg_drain_all_list_lrus(memcg, parent);
 
 	memcg_free_cache_id(kmemcg_id);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

