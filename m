Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8202D7262F
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565699; cv=none; b=gfgVtw4YxxqIWtWe2Y2d28VLr1iCnSVslX0ZLSdCDh5mvwONXNQIN3rBQcd88AMySxkYNCZoitnGs1DIaVBqVCzOjg/MbY4VvdJ543gfSKoHcLmj6lr/ftn3nkba+wCUUNyrxFwRvwOdDOjgfbr0xc2pSFK9FLKknIQ4/rckH5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565699; c=relaxed/simple;
	bh=ety02GR/drUkVmYKpLj9KubV+uT+1ewNKAy66f7xYRM=;
	h=Date:To:From:Subject:Message-Id; b=Uplj1O1Q7K/nkUITDcj7OlAXG4BMuIctjxCCASLqhzgnAsCJSNk0cJBpctAq8kQnaqCoHONjpqKVTIFGpacrNfUewQGPL92laewye2ERbk49azCUEjtll5KGhVdx81eYWLvD8WGTQJgm51ymwG6dBHsiUVCvo9qrrSXfemU6NmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+nE2ksQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+nE2ksQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BA2C4CEFB;
	Wed, 15 Oct 2025 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760565698;
	bh=ety02GR/drUkVmYKpLj9KubV+uT+1ewNKAy66f7xYRM=;
	h=Date:To:From:Subject:From;
	b=G+nE2ksQ6HGlDTx7DHwtwBFHt2q/CEm3P6EZXT1uRzZv7fumRTQOpQmrEYd81/caI
	 PHjlcd8GFxShm6nu3NAgKujxYnshGWjOXOqdq033vKwWeaHgO3FymTZGLbo6p1DI6V
	 AFLPdoP2iO40vFnktvl+6tUEfeEIEe971a9blDMQ=
Date: Wed, 15 Oct 2025 15:01:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-introduce-folio_split_queue_lock-and-its-variants.patch added to mm-new branch
Message-Id: <20251015220138.D0BA2C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: introduce folio_split_queue_lock and its variants
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-introduce-folio_split_queue_lock-and-its-variants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-introduce-folio_split_queue_lock-and-its-variants.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: thp: introduce folio_split_queue_lock and its variants
Date: Wed, 15 Oct 2025 14:35:31 +0800

In future memcg removal, the binding between a folio and a memcg may
change, making the split lock within the memcg unstable when held.

A new approach is required to reparent the split queue to its parent. 
This patch starts introducing a unified way to acquire the split lock for
future work.

It's a code-only refactoring with no functional changes.

Link: https://lkml.kernel.org/r/77069514656ea81a82969369f24da25ea1304e9c.1760509767.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++
 mm/huge_memory.c           |  119 ++++++++++++++++++++++++-----------
 2 files changed, 94 insertions(+), 35 deletions(-)

--- a/include/linux/memcontrol.h~mm-thp-introduce-folio_split_queue_lock-and-its-variants
+++ a/include/linux/memcontrol.h
@@ -1674,6 +1674,11 @@ int alloc_shrinker_info(struct mem_cgrou
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
 #else
 #define mem_cgroup_sockets_enabled 0
 
@@ -1705,6 +1710,11 @@ static inline void set_shrinker_bit(stru
 				    int nid, int shrinker_id)
 {
 }
+
+static inline int shrinker_id(struct shrinker *shrinker)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_MEMCG
--- a/mm/huge_memory.c~mm-thp-introduce-folio_split_queue_lock-and-its-variants
+++ a/mm/huge_memory.c
@@ -1076,28 +1076,86 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 	return pmd;
 }
 
+static struct deferred_split *split_queue_node(int nid)
+{
+	struct pglist_data *pgdata = NODE_DATA(nid);
+
+	return &pgdata->deferred_split_queue;
+}
+
 #ifdef CONFIG_MEMCG
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	if (mem_cgroup_disabled())
+		return NULL;
+	if (split_queue_node(folio_nid(folio)) == queue)
+		return NULL;
+	return container_of(queue, struct mem_cgroup, deferred_split_queue);
+}
 
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
+static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
+{
+	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
 }
 #else
 static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
+struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
+					   struct deferred_split *queue)
 {
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+	return NULL;
+}
 
-	return &pgdat->deferred_split_queue;
+static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memcg)
+{
+	return split_queue_node(nid);
 }
 #endif
 
+static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
+{
+	struct deferred_split *queue;
+
+	queue = memcg_split_queue(nid, memcg);
+	spin_lock(&queue->split_queue_lock);
+
+	return queue;
+}
+
+static struct deferred_split *
+split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags)
+{
+	struct deferred_split *queue;
+
+	queue = memcg_split_queue(nid, memcg);
+	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+
+	return queue;
+}
+
+static struct deferred_split *folio_split_queue_lock(struct folio *folio)
+{
+	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+}
+
+static struct deferred_split *
+folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
+{
+	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+}
+
+static inline void split_queue_unlock(struct deferred_split *queue)
+{
+	spin_unlock(&queue->split_queue_lock);
+}
+
+static inline void split_queue_unlock_irqrestore(struct deferred_split *queue,
+						 unsigned long flags)
+{
+	spin_unlock_irqrestore(&queue->split_queue_lock, flags);
+}
+
 static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
@@ -3654,7 +3712,7 @@ static int __folio_split(struct folio *f
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, bool uniform_split, bool unmapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3796,7 +3854,7 @@ static int __folio_split(struct folio *f
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	ds_queue = folio_split_queue_lock(folio);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
@@ -3818,7 +3876,7 @@ static int __folio_split(struct folio *f
 			 */
 			list_del_init(&folio->_deferred_list);
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
@@ -3918,7 +3976,7 @@ static int __folio_split(struct folio *f
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		spin_unlock(&ds_queue->split_queue_lock);
+		split_queue_unlock(ds_queue);
 		ret = -EAGAIN;
 	}
 fail:
@@ -4104,8 +4162,7 @@ bool __folio_unqueue_deferred_split(stru
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	ds_queue = get_deferred_split_queue(folio);
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		if (folio_test_partially_mapped(folio)) {
@@ -4116,7 +4173,7 @@ bool __folio_unqueue_deferred_split(stru
 		list_del_init(&folio->_deferred_list);
 		unqueued = true;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4124,10 +4181,7 @@ bool __folio_unqueue_deferred_split(stru
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
-#ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg = folio_memcg(folio);
-#endif
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 
 	/*
@@ -4150,7 +4204,7 @@ void deferred_split_folio(struct folio *
 	if (folio_test_swapcache(folio))
 		return;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4165,15 +4219,16 @@ void deferred_split_folio(struct folio *
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	if (list_empty(&folio->_deferred_list)) {
+		struct mem_cgroup *memcg;
+
+		memcg = folio_split_queue_memcg(folio, ds_queue);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-#ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 deferred_split_shrinker->id);
-#endif
+					 shrinker_id(deferred_split_shrinker));
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
@@ -4219,19 +4274,13 @@ static bool thp_underused(struct folio *
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
-	struct pglist_data *pgdata = NODE_DATA(sc->nid);
-	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
+	struct deferred_split *ds_queue;
 	unsigned long flags;
 	LIST_HEAD(list);
 	struct folio *folio, *next, *prev = NULL;
 	int split = 0, removed = 0;
 
-#ifdef CONFIG_MEMCG
-	if (sc->memcg)
-		ds_queue = &sc->memcg->deferred_split_queue;
-#endif
-
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
@@ -4250,7 +4299,7 @@ static unsigned long deferred_split_scan
 		if (!--sc->nr_to_scan)
 			break;
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+	split_queue_unlock_irqrestore(ds_queue, flags);
 
 	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
 		bool did_split = false;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-thp-replace-folio_memcg-with-folio_memcg_charged.patch
mm-thp-introduce-folio_split_queue_lock-and-its-variants.patch
mm-thp-use-folio_batch-to-handle-thp-splitting-in-deferred_split_scan.patch

