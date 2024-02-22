Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898F2C128
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560112; cv=none; b=tBQ58XY+7b/o3aEAmTIyF74fwehVZfUWFSfe2gavUl5HDILVKCSzdmMT/dSBBmDWiDwRT3+ehOZEACvph/QbQFu2XAO8S3P0hPsv1Fe5wxG6SI92bFBWH4MOuy1OqgGrkcHrjxJjIm/YANlW8kLXCgHm+NULOkIVItFVqv9dM1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560112; c=relaxed/simple;
	bh=/HgNY8O9UcxuuK63vV0l6bndMWonRfHyQJfu3rixWYc=;
	h=Date:To:From:Subject:Message-Id; b=ocCdgL1ebMb4o6VKkWY1neyZrGw+ULtyIQu6ZHktP4s2/oB4fYGjWimau20LhLKq4EA8UwadCrdkzlP1ygtrj6FoihfIsdLoKumvMboOxOz9i0d7RrFuc7sHIxjm59Eg80Z5EBHiYCknwwb9v/i89JVqyHg6xGTx3upOKuocmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGXxY/nL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGXxY/nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A63C43390;
	Thu, 22 Feb 2024 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560112;
	bh=/HgNY8O9UcxuuK63vV0l6bndMWonRfHyQJfu3rixWYc=;
	h=Date:To:From:Subject:From;
	b=bGXxY/nLnHcM9o+UoRcsJ9ikFKvokSQeUtn52uahVUNc6j70h0ojEmD8nb8PEUbz/
	 P8Qb8s34WI8FQPPliY5UKNVcPNQIj7+g8PwsTU0ZWz/mFGUgi98amR0nnRcZZlJW0k
	 rk4uZ4eAyhXI27NgIOjhJiQQXJVUyA9FGvZ/4Pso=
Date: Wed, 21 Feb 2024 16:01:51 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-remove-list_lru_putback.patch removed from -mm tree
Message-Id: <20240222000152.15A63C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru: remove list_lru_putback()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-remove-list_lru_putback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/list_lru: remove list_lru_putback()
Date: Sun, 28 Jan 2024 13:28:51 +0000

Since the only user zswap_lru_putback() has gone, remove
list_lru_putback() too.

Link: https://lkml.kernel.org/r/20240126-zswap-writeback-race-v2-3-b10479847099@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com> 
Cc: Chris Li <chriscli@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   16 ----------------
 mm/list_lru.c            |   14 --------------
 mm/zswap.c               |    2 +-
 3 files changed, 1 insertion(+), 31 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-remove-list_lru_putback
+++ a/include/linux/list_lru.h
@@ -168,22 +168,6 @@ static inline unsigned long list_lru_cou
 void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
 void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
 			   struct list_head *head);
-/**
- * list_lru_putback: undo list_lru_isolate
- * @lru: the lru pointer.
- * @item: the item to put back.
- * @nid: the node id of the sublist to put the item back to.
- * @memcg: the cgroup of the sublist to put the item back to.
- *
- * Put back an isolated item into its original LRU. Note that unlike
- * list_lru_add, this does not increment the node LRU count (as
- * list_lru_isolate does not originally decrement this count).
- *
- * Since we might have dropped the LRU lock in between, recompute list_lru_one
- * from the node's id and memcg.
- */
-void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
-		      struct mem_cgroup *memcg);
 
 typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
 		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
--- a/mm/list_lru.c~mm-list_lru-remove-list_lru_putback
+++ a/mm/list_lru.c
@@ -162,20 +162,6 @@ void list_lru_isolate_move(struct list_l
 }
 EXPORT_SYMBOL_GPL(list_lru_isolate_move);
 
-void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
-		      struct mem_cgroup *memcg)
-{
-	struct list_lru_one *list =
-		list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-
-	if (list_empty(item)) {
-		list_add_tail(item, &list->list);
-		if (!list->nr_items++)
-			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
-	}
-}
-EXPORT_SYMBOL_GPL(list_lru_putback);
-
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg)
 {
--- a/mm/zswap.c~mm-list_lru-remove-list_lru_putback
+++ a/mm/zswap.c
@@ -410,7 +410,7 @@ static void zswap_lru_add(struct list_lr
 	 * 2. list_lru_add() is called after memcg->kmemcg_id is updated. The
 	 *    new entry will be added directly to memcg's parent's list_lru.
 	 *
-	 * Similar reasoning holds for list_lru_del() and list_lru_putback().
+	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

