Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630A1DE8BB
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968136; cv=none; b=N1zF5Q/0/vZf+lRVNuRWk5Wd56DLmvQmBK5ZAjPfVMJDk2htnUs6MKnnbmo4XtPrcd7UOV/vjp4H26YBenQZqw8j4DA1T/SqsY4uJ7rXauBNYiMRXnzSbEoetEaJClPoRPD7Hyc0cTIGboilYkd9mJtlK1Y4XdA4E/JqPhwvK78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968136; c=relaxed/simple;
	bh=89LHD6a6iLvNJldD1jf94WITUomKufF+4nciik9GELs=;
	h=Date:To:From:Subject:Message-Id; b=gUMrlzgjunuBItH42M5y17gVNej/Erlnpm828RmuScXFD5wQEGEs2NnxHbvwQUi15eVTexbo7T6w7EcQnp8P+juQpTtrCA7qFmBt0YJYBOx0kMeJyuQdT3lwXDFpRk7po+yCirdcvDLp8oZ8e/y/qN0L6MXP5ahx1Ox3DAmzZnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RxUDfndI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RxUDfndI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA41F00893;
	Tue,  9 Jun 2026 01:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968135;
	bh=MUKvxr0QeR65LPjWPNxbz/jjGSj5MzxDqgp5vxse2os=;
	h=Date:To:From:Subject;
	b=RxUDfndI9wpSE6j28BM7fWqOQzjdf25o/mPelWNbwbpobo+wzRSOpSOllDRt3WZOc
	 lZbPM+M6AVf/ismq02+ONzTkBuZhZpPZCKOGSqArQdDe25u+bb6gF8oUKGYIscuwg/
	 0UJLrHTolmwUQ7xNpMQ4j28/yCPEqvLpdhK6RaaA=
Date: Mon, 08 Jun 2026 18:22:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch removed from -mm tree
Message-Id: <20260609012215.11EA41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: introduce caller locking for additions and deletions
has been removed from the -mm tree.  Its filename was
     mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: introduce caller locking for additions and deletions
Date: Wed, 27 May 2026 16:45:13 -0400

Locking is currently internal to the list_lru API.  However, a caller
might want to keep auxiliary state synchronized with the LRU state.

For example, the THP shrinker uses the lock of its custom LRU to keep
PG_partially_mapped and vmstats consistent.

To allow the THP shrinker to switch to list_lru, provide normal and
irqsafe locking primitives as well as caller-locked variants of the
addition and deletion functions.

Link: https://lore.kernel.org/20260527204757.2544958-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   43 +++++++++++
 mm/list_lru.c            |  133 ++++++++++++++++++++++++++++---------
 2 files changed, 145 insertions(+), 31 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-introduce-caller-locking-for-additions-and-deletions
+++ a/include/linux/list_lru.h
@@ -84,6 +84,46 @@ int memcg_list_lru_alloc(struct mem_cgro
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
+ * list_lru_lock: lock the sublist for the given node and memcg
+ * @lru: the lru pointer
+ * @nid: the node id of the sublist to lock.
+ * @memcg: pointer to the cgroup of the sublist to lock. On return,
+ *         updated to the cgroup whose sublist was actually locked,
+ *         which may be an ancestor if the original memcg was dying.
+ *
+ * Returns the locked list_lru_one sublist. The caller must call
+ * list_lru_unlock() when done.
+ *
+ * You must ensure that the memcg is not freed during this call (e.g., with
+ * rcu or by taking a css refcnt).
+ *
+ * Return: the locked list_lru_one, or NULL on failure
+ */
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+		struct mem_cgroup **memcg);
+
+/**
+ * list_lru_unlock: unlock a sublist locked by list_lru_lock()
+ * @l: the list_lru_one to unlock
+ */
+void list_lru_unlock(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+		struct mem_cgroup **memcg);
+void list_lru_unlock_irq(struct list_lru_one *l);
+
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+		struct mem_cgroup **memcg, unsigned long *irq_flags);
+void list_lru_unlock_irqrestore(struct list_lru_one *l,
+		unsigned long *irq_flags);
+
+/* Caller-locked variants, see list_lru_add() etc for documentation */
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		struct list_head *item, int nid, struct mem_cgroup *memcg);
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		struct list_head *item, int nid);
+
+/**
  * list_lru_add: add an element to the lru list's tail
  * @lru: the lru pointer
  * @item: the item to be added.
@@ -115,6 +155,9 @@ void memcg_reparent_list_lrus(struct mem
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg);
 
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg);
+
 /**
  * list_lru_add_obj: add an element to the lru list's tail
  * @lru: the lru pointer
--- a/mm/list_lru.c~mm-list_lru-introduce-caller-locking-for-additions-and-deletions
+++ a/mm/list_lru.c
@@ -15,17 +15,23 @@
 #include "slab.h"
 #include "internal.h"
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq,
+				 unsigned long *irq_flags)
 {
-	if (irq)
+	if (irq_flags)
+		spin_lock_irqsave(&l->lock, *irq_flags);
+	else if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
 }
 
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
+				   unsigned long *irq_flags)
 {
-	if (irq_off)
+	if (irq_flags)
+		spin_unlock_irqrestore(&l->lock, *irq_flags);
+	else if (irq_off)
 		spin_unlock_irq(&l->lock);
 	else
 		spin_unlock(&l->lock);
@@ -78,7 +84,8 @@ list_lru_from_memcg_idx(struct list_lru
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l;
 
@@ -86,12 +93,12 @@ lock_list_lru_of_memcg(struct list_lru *
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
 	if (likely(l)) {
-		lock_list_lru(l, irq);
+		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
 			rcu_read_unlock();
 			return l;
 		}
-		unlock_list_lru(l, irq);
+		unlock_list_lru(l, irq, irq_flags);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
@@ -132,24 +139,58 @@ list_lru_from_memcg_idx(struct list_lru
 
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
-		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
+		       struct mem_cgroup **memcg, bool irq,
+		       unsigned long *irq_flags, bool skip_empty)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	lock_list_lru(l, irq);
+	lock_list_lru(l, irq, irq_flags);
 
 	return l;
 }
 #endif /* CONFIG_MEMCG */
 
-/* The caller must ensure the memcg lifetime. */
-bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
-		  struct mem_cgroup *memcg)
+struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
+				   struct mem_cgroup **memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l;
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/false,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
+}
+
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+				       struct mem_cgroup **memcg)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irq(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
+}
 
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
+struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
+					   struct mem_cgroup **memcg,
+					   unsigned long *flags)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/flags, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irqrestore(struct list_lru_one *l, unsigned long *flags)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/flags);
+}
+
+bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid,
+		    struct mem_cgroup *memcg)
+{
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/*
@@ -159,15 +200,50 @@ bool list_lru_add(struct list_lru *lru,
 		 */
 		if (!l->nr_items++)
 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
-		unlock_list_lru(l, false);
-		atomic_long_inc(&nlru->nr_items);
+		atomic_long_inc(&lru->node[nid].nr_items);
 		return true;
 	}
-	unlock_list_lru(l, false);
 	return false;
 }
 EXPORT_SYMBOL_GPL(list_lru_add);
 
+bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
+		    struct list_head *item, int nid)
+{
+	if (!list_empty(item)) {
+		list_del_init(item);
+		l->nr_items--;
+		atomic_long_dec(&lru->node[nid].nr_items);
+		return true;
+	}
+	return false;
+}
+
+/* The caller must ensure the memcg lifetime. */
+bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
+		  struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+	bool ret;
+
+	l = list_lru_lock(lru, nid, &memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock(l);
+	return ret;
+}
+
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item,
+		      int nid, struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+	bool ret;
+
+	l = list_lru_lock_irq(lru, nid, &memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock_irq(l);
+	return ret;
+}
+
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
 	bool ret;
@@ -189,19 +265,13 @@ EXPORT_SYMBOL_GPL(list_lru_add_obj);
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		  struct mem_cgroup *memcg)
 {
-	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+	bool ret;
 
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!list_empty(item)) {
-		list_del_init(item);
-		l->nr_items--;
-		unlock_list_lru(l, false);
-		atomic_long_dec(&nlru->nr_items);
-		return true;
-	}
-	unlock_list_lru(l, false);
-	return false;
+	l = list_lru_lock(lru, nid, &memcg);
+	ret = __list_lru_del(lru, l, item, nid);
+	list_lru_unlock(l);
+	return ret;
 }
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
@@ -274,7 +344,8 @@ __list_lru_walk_one(struct list_lru *lru
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, &memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, /*irq=*/irq_off,
+				   /*irq_flags=*/NULL, /*skip_empty=*/true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
@@ -315,7 +386,7 @@ restart:
 			BUG();
 		}
 	}
-	unlock_list_lru(l, irq_off);
+	unlock_list_lru(l, irq_off, NULL);
 out:
 	return isolated;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


