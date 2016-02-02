From: akpm@linux-foundation.org
Subject: + mm-workingset-per-cgroup-cache-thrash-detection.patch added to
 -mm tree
Date: Tue, 02 Feb 2016 14:36:40 -0800
Message-ID: <56b12f78.E7w4Zzy4LrJCWYBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbcBBWgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: per-cgroup cache thrash detection
has been added to the -mm tree.  Its filename is
     mm-workingset-per-cgroup-cache-thrash-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-per-cgroup-cache-thrash-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-per-cgroup-cache-thrash-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: per-cgroup cache thrash detection

Cache thrash detection (see a528910e12ec "mm: thrash detection-based file
cache sizing" for details) currently only works on the system level, not
inside cgroups.  Worse, as the refaults are compared to the global number
of active cache, cgroups might wrongfully get all their refaults activated
when their pages are hotter than those of others.

Move the refault machinery from the zone to the lruvec, and then tag
eviction entries with the memcg ID.  This makes the thrash detection work
correctly inside cgroups.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   56 +++++++++++++++++++++----
 include/linux/mmzone.h     |   13 +++--
 mm/memcontrol.c            |   25 -----------
 mm/vmscan.c                |   18 ++++----
 mm/workingset.c            |   78 ++++++++++++++++++++++++++++++-----
 5 files changed, 133 insertions(+), 57 deletions(-)

diff -puN include/linux/memcontrol.h~mm-workingset-per-cgroup-cache-thrash-detection include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-workingset-per-cgroup-cache-thrash-detection
+++ a/include/linux/memcontrol.h
@@ -89,6 +89,10 @@ enum mem_cgroup_events_target {
 };
 
 #ifdef CONFIG_MEMCG
+
+#define MEM_CGROUP_ID_SHIFT	16
+#define MEM_CGROUP_ID_MAX	USHRT_MAX
+
 struct mem_cgroup_stat_cpu {
 	long count[MEMCG_NR_STAT];
 	unsigned long events[MEMCG_NR_EVENTS];
@@ -265,6 +269,11 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+static inline bool mem_cgroup_disabled(void)
+{
+	return !cgroup_subsys_enabled(memory_cgrp_subsys);
+}
+
 /**
  * mem_cgroup_events - count memory events against a cgroup
  * @memcg: the memory cgroup
@@ -312,6 +321,28 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup_reclaim_cookie *);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 
+static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+
+	return memcg->css.id;
+}
+
+/**
+ * mem_cgroup_from_id - look up a memcg from an id
+ * @id: the id to look up
+ *
+ * Caller must hold rcu_read_lock() and use css_tryget() as necessary.
+ */
+static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+{
+	struct cgroup_subsys_state *css;
+
+	css = css_from_id(id, &memory_cgrp_subsys);
+	return mem_cgroup_from_css(css);
+}
+
 /**
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
@@ -353,11 +384,6 @@ static inline bool mm_match_cgroup(struc
 struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
 ino_t page_cgroup_ino(struct page *page);
 
-static inline bool mem_cgroup_disabled(void)
-{
-	return !cgroup_subsys_enabled(memory_cgrp_subsys);
-}
-
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
@@ -502,8 +528,17 @@ void mem_cgroup_split_huge_fixup(struct
 #endif
 
 #else /* CONFIG_MEMCG */
+
+#define MEM_CGROUP_ID_SHIFT	0
+#define MEM_CGROUP_ID_MAX	0
+
 struct mem_cgroup;
 
+static inline bool mem_cgroup_disabled(void)
+{
+	return true;
+}
+
 static inline void mem_cgroup_events(struct mem_cgroup *memcg,
 				     enum mem_cgroup_events_index idx,
 				     unsigned int nr)
@@ -586,9 +621,16 @@ static inline void mem_cgroup_iter_break
 {
 }
 
-static inline bool mem_cgroup_disabled(void)
+static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
-	return true;
+	return 0;
+}
+
+static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+{
+	WARN_ON_ONCE(id);
+	/* XXX: This should always return root_mem_cgroup */
+	return NULL;
 }
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
diff -puN include/linux/mmzone.h~mm-workingset-per-cgroup-cache-thrash-detection include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-workingset-per-cgroup-cache-thrash-detection
+++ a/include/linux/mmzone.h
@@ -212,10 +212,12 @@ struct zone_reclaim_stat {
 };
 
 struct lruvec {
-	struct list_head lists[NR_LRU_LISTS];
-	struct zone_reclaim_stat reclaim_stat;
+	struct list_head		lists[NR_LRU_LISTS];
+	struct zone_reclaim_stat	reclaim_stat;
+	/* Evictions & activations on the inactive file list */
+	atomic_long_t			inactive_age;
 #ifdef CONFIG_MEMCG
-	struct zone *zone;
+	struct zone			*zone;
 #endif
 };
 
@@ -490,9 +492,6 @@ struct zone {
 	spinlock_t		lru_lock;
 	struct lruvec		lruvec;
 
-	/* Evictions & activations on the inactive file list */
-	atomic_long_t		inactive_age;
-
 	/*
 	 * When free pages are below this point, additional steps are taken
 	 * when reading the number of free pages to avoid per-cpu counter
@@ -761,6 +760,8 @@ static inline struct zone *lruvec_zone(s
 #endif
 }
 
+extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru);
+
 #ifdef CONFIG_HAVE_MEMORY_PRESENT
 void memory_present(int nid, unsigned long start, unsigned long end);
 #else
diff -puN mm/memcontrol.c~mm-workingset-per-cgroup-cache-thrash-detection mm/memcontrol.c
--- a/mm/memcontrol.c~mm-workingset-per-cgroup-cache-thrash-detection
+++ a/mm/memcontrol.c
@@ -268,31 +268,6 @@ static inline bool mem_cgroup_is_root(st
 	return (memcg == root_mem_cgroup);
 }
 
-/*
- * We restrict the id in the range of [1, 65535], so it can fit into
- * an unsigned short.
- */
-#define MEM_CGROUP_ID_MAX	USHRT_MAX
-
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return memcg->css.id;
-}
-
-/*
- * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock().  The caller is responsible for calling
- * css_tryget_online() if the mem_cgroup is used for charging. (dropping
- * refcnt from swap can be called against removed memcg.)
- */
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	struct cgroup_subsys_state *css;
-
-	css = css_from_id(id, &memory_cgrp_subsys);
-	return mem_cgroup_from_css(css);
-}
-
 #ifndef CONFIG_SLOB
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
diff -puN mm/vmscan.c~mm-workingset-per-cgroup-cache-thrash-detection mm/vmscan.c
--- a/mm/vmscan.c~mm-workingset-per-cgroup-cache-thrash-detection
+++ a/mm/vmscan.c
@@ -213,7 +213,7 @@ bool zone_reclaimable(struct zone *zone)
 		zone_reclaimable_pages(zone) * 6;
 }
 
-static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
 		return mem_cgroup_get_lru_size(lruvec, lru);
@@ -1923,8 +1923,8 @@ static bool inactive_file_is_low(struct
 	unsigned long inactive;
 	unsigned long active;
 
-	inactive = get_lru_size(lruvec, LRU_INACTIVE_FILE);
-	active = get_lru_size(lruvec, LRU_ACTIVE_FILE);
+	inactive = lruvec_lru_size(lruvec, LRU_INACTIVE_FILE);
+	active = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
 
 	return active > inactive;
 }
@@ -2063,7 +2063,7 @@ static void get_scan_count(struct lruvec
 	 * system is under heavy pressure.
 	 */
 	if (!inactive_file_is_low(lruvec) &&
-	    get_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
+	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2089,10 +2089,10 @@ static void get_scan_count(struct lruvec
 	 * anon in [0], file in [1]
 	 */
 
-	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
-		get_lru_size(lruvec, LRU_INACTIVE_ANON);
-	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
-		get_lru_size(lruvec, LRU_INACTIVE_FILE);
+	anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON) +
+		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON);
+	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE) +
+		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
@@ -2130,7 +2130,7 @@ out:
 			unsigned long size;
 			unsigned long scan;
 
-			size = get_lru_size(lruvec, lru);
+			size = lruvec_lru_size(lruvec, lru);
 			scan = size >> sc->priority;
 
 			if (!scan && pass && force_scan)
diff -puN mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection mm/workingset.c
--- a/mm/workingset.c~mm-workingset-per-cgroup-cache-thrash-detection
+++ a/mm/workingset.c
@@ -153,7 +153,8 @@
  */
 
 #define EVICTION_SHIFT	(RADIX_TREE_EXCEPTIONAL_ENTRY + \
-			 ZONES_SHIFT + NODES_SHIFT)
+			 ZONES_SHIFT + NODES_SHIFT +	\
+			 MEM_CGROUP_ID_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
 
 /*
@@ -166,9 +167,10 @@
  */
 static unsigned int bucket_order __read_mostly;
 
-static void *pack_shadow(unsigned long eviction, struct zone *zone)
+static void *pack_shadow(int memcgid, struct zone *zone, unsigned long eviction)
 {
 	eviction >>= bucket_order;
+	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | zone_to_nid(zone);
 	eviction = (eviction << ZONES_SHIFT) | zone_idx(zone);
 	eviction = (eviction << RADIX_TREE_EXCEPTIONAL_SHIFT);
@@ -176,18 +178,21 @@ static void *pack_shadow(unsigned long e
 	return (void *)(eviction | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
-static void unpack_shadow(void *shadow, struct zone **zonep,
+static void unpack_shadow(void *shadow, int *memcgidp, struct zone **zonep,
 			  unsigned long *evictionp)
 {
 	unsigned long entry = (unsigned long)shadow;
-	int zid, nid;
+	int memcgid, nid, zid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
 	zid = entry & ((1UL << ZONES_SHIFT) - 1);
 	entry >>= ZONES_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
+	memcgid = entry & ((1UL << MEM_CGROUP_ID_SHIFT) - 1);
+	entry >>= MEM_CGROUP_ID_SHIFT;
 
+	*memcgidp = memcgid;
 	*zonep = NODE_DATA(nid)->node_zones + zid;
 	*evictionp = entry << bucket_order;
 }
@@ -202,11 +207,20 @@ static void unpack_shadow(void *shadow,
  */
 void *workingset_eviction(struct address_space *mapping, struct page *page)
 {
+	struct mem_cgroup *memcg = page_memcg(page);
 	struct zone *zone = page_zone(page);
+	int memcgid = mem_cgroup_id(memcg);
 	unsigned long eviction;
+	struct lruvec *lruvec;
 
-	eviction = atomic_long_inc_return(&zone->inactive_age);
-	return pack_shadow(eviction, zone);
+	/* Page is fully exclusive and pins page->mem_cgroup */
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_PAGE(page_count(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+
+	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	eviction = atomic_long_inc_return(&lruvec->inactive_age);
+	return pack_shadow(memcgid, zone, eviction);
 }
 
 /**
@@ -221,13 +235,42 @@ void *workingset_eviction(struct address
 bool workingset_refault(void *shadow)
 {
 	unsigned long refault_distance;
+	unsigned long active_file;
+	struct mem_cgroup *memcg;
 	unsigned long eviction;
+	struct lruvec *lruvec;
 	unsigned long refault;
 	struct zone *zone;
+	int memcgid;
 
-	unpack_shadow(shadow, &zone, &eviction);
+	unpack_shadow(shadow, &memcgid, &zone, &eviction);
 
-	refault = atomic_long_read(&zone->inactive_age);
+	rcu_read_lock();
+	/*
+	 * Look up the memcg associated with the stored ID. It might
+	 * have been deleted since the page's eviction.
+	 *
+	 * Note that in rare events the ID could have been recycled
+	 * for a new cgroup that refaults a shared page. This is
+	 * impossible to tell from the available data. However, this
+	 * should be a rare and limited disturbance, and activations
+	 * are always speculative anyway. Ultimately, it's the aging
+	 * algorithm's job to shake out the minimum access frequency
+	 * for the active cache.
+	 *
+	 * XXX: On !CONFIG_MEMCG, this will always return NULL; it
+	 * would be better if the root_mem_cgroup existed in all
+	 * configurations instead.
+	 */
+	memcg = mem_cgroup_from_id(memcgid);
+	if (!mem_cgroup_disabled() && !memcg) {
+		rcu_read_unlock();
+		return false;
+	}
+	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	refault = atomic_long_read(&lruvec->inactive_age);
+	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
+	rcu_read_unlock();
 
 	/*
 	 * The unsigned subtraction here gives an accurate distance
@@ -249,7 +292,7 @@ bool workingset_refault(void *shadow)
 
 	inc_zone_state(zone, WORKINGSET_REFAULT);
 
-	if (refault_distance <= zone_page_state(zone, NR_ACTIVE_FILE)) {
+	if (refault_distance <= active_file) {
 		inc_zone_state(zone, WORKINGSET_ACTIVATE);
 		return true;
 	}
@@ -262,7 +305,22 @@ bool workingset_refault(void *shadow)
  */
 void workingset_activation(struct page *page)
 {
-	atomic_long_inc(&page_zone(page)->inactive_age);
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+
+	memcg = lock_page_memcg(page);
+	/*
+	 * Filter non-memcg pages here, e.g. unmap can call
+	 * mark_page_accessed() on VDSO pages.
+	 *
+	 * XXX: See workingset_refault() - this should return
+	 * root_mem_cgroup even for !CONFIG_MEMCG.
+	 */
+	if (!mem_cgroup_disabled() && !memcg)
+		return;
+	lruvec = mem_cgroup_zone_lruvec(page_zone(page), memcg);
+	atomic_long_inc(&lruvec->inactive_age);
+	unlock_page_memcg(memcg);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

