From: akpm@linux-foundation.org
Subject: [merged] mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:52 -0700
Message-ID: <5390ca1c.kJArTL49HNVNxY6k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hughd@google.com, cl@linux.com

Subject: [merged] mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch removed from -mm tree
To: cl@linux.com,hughd@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:52 -0700


The patch titled
     Subject: mm: replace __get_cpu_var uses with this_cpu_ptr
has been removed from the -mm tree.  Its filename was
     mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: replace __get_cpu_var uses with this_cpu_ptr

Replace places where __get_cpu_var() is used for an address calculation
with this_cpu_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c    |    6 +++---
 mm/memcontrol.c     |    2 +-
 mm/memory-failure.c |    2 +-
 mm/page-writeback.c |    4 ++--
 mm/slub.c           |    6 +++---
 mm/swap.c           |    2 +-
 mm/vmalloc.c        |    2 +-
 mm/vmstat.c         |    4 ++--
 mm/zsmalloc.c       |    2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff -puN lib/radix-tree.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr lib/radix-tree.c
--- a/lib/radix-tree.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/lib/radix-tree.c
@@ -194,7 +194,7 @@ radix_tree_node_alloc(struct radix_tree_
 		 * succeed in getting a node here (and never reach
 		 * kmem_cache_alloc)
 		 */
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr) {
 			ret = rtp->nodes[rtp->nr - 1];
 			rtp->nodes[rtp->nr - 1] = NULL;
@@ -250,14 +250,14 @@ static int __radix_tree_preload(gfp_t gf
 	int ret = -ENOMEM;
 
 	preempt_disable();
-	rtp = &__get_cpu_var(radix_tree_preloads);
+	rtp = this_cpu_ptr(&radix_tree_preloads);
 	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
 		preempt_enable();
 		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 		if (node == NULL)
 			goto out;
 		preempt_disable();
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr < ARRAY_SIZE(rtp->nodes))
 			rtp->nodes[rtp->nr++] = node;
 		else
diff -puN mm/memcontrol.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/memcontrol.c
--- a/mm/memcontrol.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/memcontrol.c
@@ -2436,7 +2436,7 @@ static void drain_stock(struct memcg_sto
  */
 static void drain_local_stock(struct work_struct *dummy)
 {
-	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
+	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
diff -puN mm/memory-failure.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/memory-failure.c
--- a/mm/memory-failure.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/memory-failure.c
@@ -1298,7 +1298,7 @@ static void memory_failure_work_func(str
 	unsigned long proc_flags;
 	int gotten;
 
-	mf_cpu = &__get_cpu_var(memory_failure_cpu);
+	mf_cpu = this_cpu_ptr(&memory_failure_cpu);
 	for (;;) {
 		spin_lock_irqsave(&mf_cpu->lock, proc_flags);
 		gotten = kfifo_get(&mf_cpu->fifo, &entry);
diff -puN mm/page-writeback.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/page-writeback.c
--- a/mm/page-writeback.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/page-writeback.c
@@ -1623,7 +1623,7 @@ void balance_dirty_pages_ratelimited(str
 	 * 1000+ tasks, all of them start dirtying pages at exactly the same
 	 * time, hence all honoured too large initial task->nr_dirtied_pause.
 	 */
-	p =  &__get_cpu_var(bdp_ratelimits);
+	p =  this_cpu_ptr(&bdp_ratelimits);
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		*p = 0;
 	else if (unlikely(*p >= ratelimit_pages)) {
@@ -1635,7 +1635,7 @@ void balance_dirty_pages_ratelimited(str
 	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
 	 * the dirty throttling and livelock other long-run dirtiers.
 	 */
-	p = &__get_cpu_var(dirty_throttle_leaks);
+	p = this_cpu_ptr(&dirty_throttle_leaks);
 	if (*p > 0 && current->nr_dirtied < ratelimit) {
 		unsigned long nr_pages_dirtied;
 		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
diff -puN mm/slub.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/slub.c
--- a/mm/slub.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/slub.c
@@ -2209,7 +2209,7 @@ static inline void *new_slab_objects(str
 
 	page = new_slab(s, flags, node);
 	if (page) {
-		c = __this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 		if (c->page)
 			flush_slab(s, c);
 
@@ -2425,7 +2425,7 @@ redo:
 	 * and the retrieval of the tid.
 	 */
 	preempt_disable();
-	c = __this_cpu_ptr(s->cpu_slab);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * The transaction ids are globally unique per cpu and per operation on
@@ -2681,7 +2681,7 @@ redo:
 	 * during the cmpxchg then the free will succedd.
 	 */
 	preempt_disable();
-	c = __this_cpu_ptr(s->cpu_slab);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
 	preempt_enable();
diff -puN mm/swap.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/swap.c
--- a/mm/swap.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/swap.c
@@ -441,7 +441,7 @@ void rotate_reclaimable_page(struct page
 
 		page_cache_get(page);
 		local_irq_save(flags);
-		pvec = &__get_cpu_var(lru_rotate_pvecs);
+		pvec = this_cpu_ptr(&lru_rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
 		local_irq_restore(flags);
diff -puN mm/vmalloc.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/vmalloc.c
--- a/mm/vmalloc.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/vmalloc.c
@@ -1496,7 +1496,7 @@ void vfree(const void *addr)
 	if (!addr)
 		return;
 	if (unlikely(in_interrupt())) {
-		struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
+		struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
 		if (llist_add((struct llist_node *)addr, &p->list))
 			schedule_work(&p->wq);
 	} else
diff -puN mm/vmstat.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/vmstat.c
--- a/mm/vmstat.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/vmstat.c
@@ -489,7 +489,7 @@ static void refresh_cpu_vm_stats(void)
 			continue;
 
 		if (__this_cpu_read(p->pcp.count))
-			drain_zone_pages(zone, __this_cpu_ptr(&p->pcp));
+			drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
 #endif
 	}
 	fold_diff(global_diff);
@@ -1230,7 +1230,7 @@ int sysctl_stat_interval __read_mostly =
 static void vmstat_update(struct work_struct *w)
 {
 	refresh_cpu_vm_stats();
-	schedule_delayed_work(&__get_cpu_var(vmstat_work),
+	schedule_delayed_work(this_cpu_ptr(&vmstat_work),
 		round_jiffies_relative(sysctl_stat_interval));
 }
 
diff -puN mm/zsmalloc.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-replace-__get_cpu_var-uses-with-this_cpu_ptr
+++ a/mm/zsmalloc.c
@@ -1082,7 +1082,7 @@ void zs_unmap_object(struct zs_pool *poo
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &__get_cpu_var(zs_map_area);
+	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
 		kunmap_atomic(area->vm_addr);
 	else {
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch

