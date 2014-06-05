From: akpm@linux-foundation.org
Subject: [merged] mem-hotplug-implement-get-put_online_mems.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:49 -0700
Message-ID: <5390c9dd.tjNw6kk74K1QiNS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, rientjes@google.com, rafael.j.wysocki@intel.com, qiuxishi@huawei.com, penberg@kernel.org, liuj97@gmail.com, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, vdavydov@parallels.com

Subject: [merged] mem-hotplug-implement-get-put_online_mems.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com,laijs@cn.fujitsu.com,liuj97@gmail.com,penberg@kernel.org,qiuxishi@huawei.com,rafael.j.wysocki@intel.com,rientjes@google.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:49 -0700


The patch titled
     Subject: mem-hotplug: implement get/put_online_mems
has been removed from the -mm tree.  Its filename was
     mem-hotplug-implement-get-put_online_mems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mem-hotplug: implement get/put_online_mems

kmem_cache_{create,destroy,shrink} need to get a stable value of cpu/node
online mask, because they init/destroy/access per-cpu/node kmem_cache
parts, which can be allocated or destroyed on cpu/mem hotplug.  To protect
against cpu hotplug, these functions use {get,put}_online_cpus.  However,
they do nothing to synchronize with memory hotplug - taking the slab_mutex
does not eliminate the possibility of race as described in patch 2.

What we need there is something like get_online_cpus, but for memory.  We
already have lock_memory_hotplug, which serves for the purpose, but it's a
bit of a hammer right now, because it's backed by a mutex.  As a result,
it imposes some limitations to locking order, which are not desirable, and
can't be used just like get_online_cpus.  That's why in patch 1 I
substitute it with get/put_online_mems, which work exactly like
get/put_online_cpus except they block not cpu, but memory hotplug.

[ v1 can be found at https://lkml.org/lkml/2014/4/6/68.  I NAK'ed it by
myself, because it used an rw semaphore for get/put_online_mems, making
them dead lock prune.  ]



This patch (of 2):

{un}lock_memory_hotplug, which is used to synchronize against memory
hotplug, is currently backed by a mutex, which makes it a bit of a hammer
- threads that only want to get a stable value of online nodes mask won't
be able to proceed concurrently.  Also, it imposes some strong locking
ordering rules on it, which narrows down the set of its usage scenarios.

This patch introduces get/put_online_mems, which are the same as
get/put_online_cpus, but for memory hotplug, i.e.  executing a code inside
a get/put_online_mems section will guarantee a stable value of online
nodes, present pages, etc.

lock_memory_hotplug()/unlock_memory_hotplug() are removed altogether.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   14 ---
 include/linux/mmzone.h         |    8 -
 mm/kmemleak.c                  |    4 
 mm/memory-failure.c            |    8 -
 mm/memory_hotplug.c            |  142 ++++++++++++++++++++++---------
 mm/slub.c                      |    4 
 mm/vmscan.c                    |    2 
 7 files changed, 116 insertions(+), 66 deletions(-)

diff -puN include/linux/memory_hotplug.h~mem-hotplug-implement-get-put_online_mems include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mem-hotplug-implement-get-put_online_mems
+++ a/include/linux/memory_hotplug.h
@@ -187,14 +187,8 @@ extern void put_page_bootmem(struct page
 extern void get_page_bootmem(unsigned long ingo, struct page *page,
 			     unsigned long type);
 
-/*
- * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
- * notifier will be called under this. 2) offline/online/add/remove memory
- * will not run simultaneously.
- */
-
-void lock_memory_hotplug(void);
-void unlock_memory_hotplug(void);
+void get_online_mems(void);
+void put_online_mems(void);
 
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
@@ -232,8 +226,8 @@ static inline int try_online_node(int ni
 	return 0;
 }
 
-static inline void lock_memory_hotplug(void) {}
-static inline void unlock_memory_hotplug(void) {}
+static inline void get_online_mems(void) {}
+static inline void put_online_mems(void) {}
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
diff -puN include/linux/mmzone.h~mem-hotplug-implement-get-put_online_mems include/linux/mmzone.h
--- a/include/linux/mmzone.h~mem-hotplug-implement-get-put_online_mems
+++ a/include/linux/mmzone.h
@@ -481,9 +481,8 @@ struct zone {
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
-	 * lock_memory_hotplug()/unlock_memory_hotplug().  Any reader who can't
-	 * tolerant drift of present_pages should hold memory hotplug lock to
-	 * get a stable value.
+	 * mem_hotplug_begin/end(). Any reader who can't tolerant drift of
+	 * present_pages should get_online_mems() to get a stable value.
 	 *
 	 * Read access to managed_pages should be safe because it's unsigned
 	 * long. Write access to zone->managed_pages and totalram_pages are
@@ -765,7 +764,8 @@ typedef struct pglist_data {
 	int node_id;
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
-	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
+	struct task_struct *kswapd;	/* Protected by
+					   mem_hotplug_begin/end() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 #ifdef CONFIG_NUMA_BALANCING
diff -puN mm/kmemleak.c~mem-hotplug-implement-get-put_online_mems mm/kmemleak.c
--- a/mm/kmemleak.c~mem-hotplug-implement-get-put_online_mems
+++ a/mm/kmemleak.c
@@ -1300,7 +1300,7 @@ static void kmemleak_scan(void)
 	/*
 	 * Struct page scanning for each node.
 	 */
-	lock_memory_hotplug();
+	get_online_mems();
 	for_each_online_node(i) {
 		unsigned long start_pfn = node_start_pfn(i);
 		unsigned long end_pfn = node_end_pfn(i);
@@ -1318,7 +1318,7 @@ static void kmemleak_scan(void)
 			scan_block(page, page + 1, NULL, 1);
 		}
 	}
-	unlock_memory_hotplug();
+	put_online_mems();
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
diff -puN mm/memory-failure.c~mem-hotplug-implement-get-put_online_mems mm/memory-failure.c
--- a/mm/memory-failure.c~mem-hotplug-implement-get-put_online_mems
+++ a/mm/memory-failure.c
@@ -1664,11 +1664,7 @@ int soft_offline_page(struct page *page,
 		}
 	}
 
-	/*
-	 * The lock_memory_hotplug prevents a race with memory hotplug.
-	 * This is a big hammer, a better would be nicer.
-	 */
-	lock_memory_hotplug();
+	get_online_mems();
 
 	/*
 	 * Isolate the page, so that it doesn't get reallocated if it
@@ -1679,7 +1675,7 @@ int soft_offline_page(struct page *page,
 		set_migratetype_isolate(page, true);
 
 	ret = get_any_page(page, pfn, flags);
-	unlock_memory_hotplug();
+	put_online_mems();
 	if (ret > 0) { /* for in-use pages */
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
diff -puN mm/memory_hotplug.c~mem-hotplug-implement-get-put_online_mems mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-implement-get-put_online_mems
+++ a/mm/memory_hotplug.c
@@ -46,19 +46,84 @@
 static void generic_online_page(struct page *page);
 
 static online_page_callback_t online_page_callback = generic_online_page;
+static DEFINE_MUTEX(online_page_callback_lock);
 
-DEFINE_MUTEX(mem_hotplug_mutex);
+/* The same as the cpu_hotplug lock, but for memory hotplug. */
+static struct {
+	struct task_struct *active_writer;
+	struct mutex lock; /* Synchronizes accesses to refcount, */
+	/*
+	 * Also blocks the new readers during
+	 * an ongoing mem hotplug operation.
+	 */
+	int refcount;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+} mem_hotplug = {
+	.active_writer = NULL,
+	.lock = __MUTEX_INITIALIZER(mem_hotplug.lock),
+	.refcount = 0,
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	.dep_map = {.name = "mem_hotplug.lock" },
+#endif
+};
+
+/* Lockdep annotations for get/put_online_mems() and mem_hotplug_begin/end() */
+#define memhp_lock_acquire_read() lock_map_acquire_read(&mem_hotplug.dep_map)
+#define memhp_lock_acquire()      lock_map_acquire(&mem_hotplug.dep_map)
+#define memhp_lock_release()      lock_map_release(&mem_hotplug.dep_map)
+
+void get_online_mems(void)
+{
+	might_sleep();
+	if (mem_hotplug.active_writer == current)
+		return;
+	memhp_lock_acquire_read();
+	mutex_lock(&mem_hotplug.lock);
+	mem_hotplug.refcount++;
+	mutex_unlock(&mem_hotplug.lock);
+
+}
 
-void lock_memory_hotplug(void)
+void put_online_mems(void)
 {
-	mutex_lock(&mem_hotplug_mutex);
+	if (mem_hotplug.active_writer == current)
+		return;
+	mutex_lock(&mem_hotplug.lock);
+
+	if (WARN_ON(!mem_hotplug.refcount))
+		mem_hotplug.refcount++; /* try to fix things up */
+
+	if (!--mem_hotplug.refcount && unlikely(mem_hotplug.active_writer))
+		wake_up_process(mem_hotplug.active_writer);
+	mutex_unlock(&mem_hotplug.lock);
+	memhp_lock_release();
+
 }
 
-void unlock_memory_hotplug(void)
+static void mem_hotplug_begin(void)
 {
-	mutex_unlock(&mem_hotplug_mutex);
+	mem_hotplug.active_writer = current;
+
+	memhp_lock_acquire();
+	for (;;) {
+		mutex_lock(&mem_hotplug.lock);
+		if (likely(!mem_hotplug.refcount))
+			break;
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		mutex_unlock(&mem_hotplug.lock);
+		schedule();
+	}
 }
 
+static void mem_hotplug_done(void)
+{
+	mem_hotplug.active_writer = NULL;
+	mutex_unlock(&mem_hotplug.lock);
+	memhp_lock_release();
+}
 
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
@@ -727,14 +792,16 @@ int set_online_page_callback(online_page
 {
 	int rc = -EINVAL;
 
-	lock_memory_hotplug();
+	get_online_mems();
+	mutex_lock(&online_page_callback_lock);
 
 	if (online_page_callback == generic_online_page) {
 		online_page_callback = callback;
 		rc = 0;
 	}
 
-	unlock_memory_hotplug();
+	mutex_unlock(&online_page_callback_lock);
+	put_online_mems();
 
 	return rc;
 }
@@ -744,14 +811,16 @@ int restore_online_page_callback(online_
 {
 	int rc = -EINVAL;
 
-	lock_memory_hotplug();
+	get_online_mems();
+	mutex_lock(&online_page_callback_lock);
 
 	if (online_page_callback == callback) {
 		online_page_callback = generic_online_page;
 		rc = 0;
 	}
 
-	unlock_memory_hotplug();
+	mutex_unlock(&online_page_callback_lock);
+	put_online_mems();
 
 	return rc;
 }
@@ -899,7 +968,7 @@ int __ref online_pages(unsigned long pfn
 	int ret;
 	struct memory_notify arg;
 
-	lock_memory_hotplug();
+	mem_hotplug_begin();
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
@@ -907,23 +976,18 @@ int __ref online_pages(unsigned long pfn
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 
+	ret = -EINVAL;
 	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
-	    !can_online_high_movable(zone)) {
-		unlock_memory_hotplug();
-		return -EINVAL;
-	}
+	    !can_online_high_movable(zone))
+		goto out;
 
 	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
-		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages)) {
-			unlock_memory_hotplug();
-			return -EINVAL;
-		}
+		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages))
+			goto out;
 	}
 	if (online_type == ONLINE_MOVABLE && zone_idx(zone) == ZONE_MOVABLE - 1) {
-		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages)) {
-			unlock_memory_hotplug();
-			return -EINVAL;
-		}
+		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages))
+			goto out;
 	}
 
 	/* Previous code may changed the zone of the pfn range */
@@ -939,8 +1003,7 @@ int __ref online_pages(unsigned long pfn
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		unlock_memory_hotplug();
-		return ret;
+		goto out;
 	}
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
@@ -964,8 +1027,7 @@ int __ref online_pages(unsigned long pfn
 		       (((unsigned long long) pfn + nr_pages)
 			    << PAGE_SHIFT) - 1);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		unlock_memory_hotplug();
-		return ret;
+		goto out;
 	}
 
 	zone->present_pages += onlined_pages;
@@ -995,9 +1057,9 @@ int __ref online_pages(unsigned long pfn
 
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
-	unlock_memory_hotplug();
-
-	return 0;
+out:
+	mem_hotplug_done();
+	return ret;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
@@ -1055,7 +1117,7 @@ int try_online_node(int nid)
 	if (node_online(nid))
 		return 0;
 
-	lock_memory_hotplug();
+	mem_hotplug_begin();
 	pgdat = hotadd_new_pgdat(nid, 0);
 	if (!pgdat) {
 		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
@@ -1073,7 +1135,7 @@ int try_online_node(int nid)
 	}
 
 out:
-	unlock_memory_hotplug();
+	mem_hotplug_done();
 	return ret;
 }
 
@@ -1117,7 +1179,7 @@ int __ref add_memory(int nid, u64 start,
 		new_pgdat = !p;
 	}
 
-	lock_memory_hotplug();
+	mem_hotplug_begin();
 
 	new_node = !node_online(nid);
 	if (new_node) {
@@ -1158,7 +1220,7 @@ error:
 	release_memory_resource(res);
 
 out:
-	unlock_memory_hotplug();
+	mem_hotplug_done();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -1565,7 +1627,7 @@ static int __ref __offline_pages(unsigne
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
-	lock_memory_hotplug();
+	mem_hotplug_begin();
 
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
@@ -1672,7 +1734,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
-	unlock_memory_hotplug();
+	mem_hotplug_done();
 	return 0;
 
 failed_removal:
@@ -1684,7 +1746,7 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 
 out:
-	unlock_memory_hotplug();
+	mem_hotplug_done();
 	return ret;
 }
 
@@ -1888,7 +1950,7 @@ void __ref remove_memory(int nid, u64 st
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
-	lock_memory_hotplug();
+	mem_hotplug_begin();
 
 	/*
 	 * All memory blocks must be offlined before removing memory.  Check
@@ -1897,10 +1959,8 @@ void __ref remove_memory(int nid, u64 st
 	 */
 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
 				check_memblock_offlined_cb);
-	if (ret) {
-		unlock_memory_hotplug();
+	if (ret)
 		BUG();
-	}
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
@@ -1909,7 +1969,7 @@ void __ref remove_memory(int nid, u64 st
 
 	try_offline_node(nid);
 
-	unlock_memory_hotplug();
+	mem_hotplug_done();
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
diff -puN mm/slub.c~mem-hotplug-implement-get-put_online_mems mm/slub.c
--- a/mm/slub.c~mem-hotplug-implement-get-put_online_mems
+++ a/mm/slub.c
@@ -4332,7 +4332,7 @@ static ssize_t show_slab_objects(struct
 		}
 	}
 
-	lock_memory_hotplug();
+	get_online_mems();
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -4372,7 +4372,7 @@ static ssize_t show_slab_objects(struct
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	unlock_memory_hotplug();
+	put_online_mems();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }
diff -puN mm/vmscan.c~mem-hotplug-implement-get-put_online_mems mm/vmscan.c
--- a/mm/vmscan.c~mem-hotplug-implement-get-put_online_mems
+++ a/mm/vmscan.c
@@ -3434,7 +3434,7 @@ int kswapd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined.  Caller must
- * hold lock_memory_hotplug().
+ * hold mem_hotplug_begin/end().
  */
 void kswapd_stop(int nid)
 {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

