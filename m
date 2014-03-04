From: akpm@linux-foundation.org
Subject: + mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch added to
 -mm tree
Date: Tue, 04 Mar 2014 14:27:10 -0800
Message-ID: <5316533e.mOii5kUdwT2M2bgW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaCDW1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, cl@linux.com

Subject: + mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch added to -mm tree
To: cl@linux.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:10 -0800


The patch titled
     Subject: mm: replace __get_cpu_var uses with this_cpu_ptr
has been added to the -mm tree.  Its filename is
     mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: replace __get_cpu_var uses with this_cpu_ptr

Replace places where __get_cpu_var() is used for an address calculation
with this_cpu_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
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
@@ -2441,7 +2441,7 @@ static void drain_stock(struct memcg_sto
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
@@ -1295,7 +1295,7 @@ static void memory_failure_work_func(str
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
@@ -2196,7 +2196,7 @@ static inline void *new_slab_objects(str
 
 	page = new_slab(s, flags, node);
 	if (page) {
-		c = __this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 		if (c->page)
 			flush_slab(s, c);
 
@@ -2416,7 +2416,7 @@ redo:
 	 * and the retrieval of the tid.
 	 */
 	preempt_disable();
-	c = __this_cpu_ptr(s->cpu_slab);
+	c = this_cpu_ptr(s->cpu_slab);
 
 	/*
 	 * The transaction ids are globally unique per cpu and per operation on
@@ -2672,7 +2672,7 @@ redo:
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
@@ -1490,7 +1490,7 @@ void vfree(const void *addr)
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
@@ -1226,7 +1226,7 @@ int sysctl_stat_interval __read_mostly =
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
@@ -1071,7 +1071,7 @@ void zs_unmap_object(struct zs_pool *poo
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &__get_cpu_var(zs_map_area);
+	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
 		kunmap_atomic(area->vm_addr);
 	else {
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

