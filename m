From: akpm@linux-foundation.org
Subject: + mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
 added to -mm tree
Date: Thu, 04 Feb 2016 15:07:47 -0800
Message-ID: <56b3d9c3.Z4qbcuBJBkBb2cD3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbcBDXHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: report slab usage in cgroup2 memory.stat
has been added to the -mm tree.  Its filename is
     mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: report slab usage in cgroup2 memory.stat

Show how much memory is used for storing reclaimable and unreclaimable
in-kernel data structures allocated from slab caches.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   15 +++++++++++++++
 include/linux/memcontrol.h  |   21 +++++++++++++++++++++
 mm/memcontrol.c             |    8 ++++++++
 mm/slab.c                   |    8 +++++---
 mm/slab.h                   |   30 ++++++++++++++++++++++++++++--
 mm/slub.c                   |    3 ++-
 6 files changed, 79 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/Documentation/cgroup-v2.txt
@@ -843,6 +843,11 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used to cache filesystem data,
 		including tmpfs and shared memory.
 
+	  slab
+
+		Amount of memory used for storing in-kernel data
+		structures.
+
 	  sock
 
 		Amount of memory used in network transmission buffers
@@ -871,6 +876,16 @@ PAGE_SIZE multiple when read back.
 		on the internal memory management lists used by the
 		page reclaim algorithm
 
+	  slab_reclaimable
+
+		Part of "slab" that might be reclaimed, such as
+		dentries and inodes.
+
+	  slab_unreclaimable
+
+		Part of "slab" that cannot be reclaimed on memory
+		pressure.
+
 	  pgfault
 
 		Total number of page faults incurred
diff -puN include/linux/memcontrol.h~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/include/linux/memcontrol.h
@@ -53,6 +53,8 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
 	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
+	MEMCG_SLAB_RECLAIMABLE,
+	MEMCG_SLAB_UNRECLAIMABLE,
 	MEMCG_NR_STAT,
 };
 
@@ -883,6 +885,20 @@ static __always_inline void memcg_kmem_p
 	if (memcg_kmem_enabled())
 		__memcg_kmem_put_cache(cachep);
 }
+
+/**
+ * memcg_kmem_update_page_stat - update kmem page state statistics
+ * @page: the page
+ * @idx: page state item to account
+ * @val: number of pages (positive or negative)
+ */
+static inline void memcg_kmem_update_page_stat(struct page *page,
+				enum mem_cgroup_stat_index idx, int val)
+{
+	if (memcg_kmem_enabled() && page->mem_cgroup)
+		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
+}
+
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -928,6 +944,11 @@ memcg_kmem_get_cache(struct kmem_cache *
 static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 }
+
+static inline void memcg_kmem_update_page_stat(struct page *page,
+				enum mem_cgroup_stat_index idx, int val)
+{
+}
 #endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/mm/memcontrol.c
@@ -5100,6 +5100,9 @@ static int memory_stat_show(struct seq_f
 		   (u64)stat[MEM_CGROUP_STAT_RSS] * PAGE_SIZE);
 	seq_printf(m, "file %llu\n",
 		   (u64)stat[MEM_CGROUP_STAT_CACHE] * PAGE_SIZE);
+	seq_printf(m, "slab %llu\n",
+		   (u64)(stat[MEMCG_SLAB_RECLAIMABLE] +
+			 stat[MEMCG_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
 	seq_printf(m, "sock %llu\n",
 		   (u64)stat[MEMCG_SOCK] * PAGE_SIZE);
 
@@ -5120,6 +5123,11 @@ static int memory_stat_show(struct seq_f
 			   mem_cgroup_lru_names[i], (u64)val * PAGE_SIZE);
 	}
 
+	seq_printf(m, "slab_reclaimable %llu\n",
+		   (u64)stat[MEMCG_SLAB_RECLAIMABLE] * PAGE_SIZE);
+	seq_printf(m, "slab_unreclaimable %llu\n",
+		   (u64)stat[MEMCG_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
+
 	/* Accumulated memory events */
 
 	seq_printf(m, "pgfault %lu\n",
diff -puN mm/slab.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat mm/slab.c
--- a/mm/slab.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/mm/slab.c
@@ -1569,9 +1569,10 @@ static struct page *kmem_getpages(struct
  */
 static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 {
-	const unsigned long nr_freed = (1 << cachep->gfporder);
+	int order = cachep->gfporder;
+	unsigned long nr_freed = (1 << order);
 
-	kmemcheck_free_shadow(page, cachep->gfporder);
+	kmemcheck_free_shadow(page, order);
 
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
@@ -1588,7 +1589,8 @@ static void kmem_freepages(struct kmem_c
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	__free_kmem_pages(page, cachep->gfporder);
+	memcg_uncharge_slab(page, order, cachep);
+	__free_pages(page, order);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
diff -puN mm/slab.h~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat mm/slab.h
--- a/mm/slab.h~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/mm/slab.h
@@ -245,12 +245,33 @@ static __always_inline int memcg_charge_
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
+	int ret;
+
 	if (!memcg_kmem_enabled())
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return __memcg_kmem_charge_memcg(page, gfp, order,
-					 s->memcg_params.memcg);
+
+	ret = __memcg_kmem_charge_memcg(page, gfp, order,
+					s->memcg_params.memcg);
+	if (ret)
+		return ret;
+
+	memcg_kmem_update_page_stat(page,
+			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			MEMCG_SLAB_RECLAIMABLE : MEMCG_SLAB_UNRECLAIMABLE,
+			1 << order);
+	return 0;
+}
+
+static __always_inline void memcg_uncharge_slab(struct page *page, int order,
+						struct kmem_cache *s)
+{
+	memcg_kmem_update_page_stat(page,
+			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			MEMCG_SLAB_RECLAIMABLE : MEMCG_SLAB_UNRECLAIMABLE,
+			-(1 << order));
+	memcg_kmem_uncharge(page, order);
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
@@ -293,6 +314,11 @@ static inline int memcg_charge_slab(stru
 	return 0;
 }
 
+static inline void memcg_uncharge_slab(struct page *page, int order,
+				       struct kmem_cache *s)
+{
+}
+
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
diff -puN mm/slub.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat mm/slub.c
--- a/mm/slub.c~mm-memcontrol-report-slab-usage-in-cgroup2-memorystat
+++ a/mm/slub.c
@@ -1474,7 +1474,8 @@ static void __free_slab(struct kmem_cach
 	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	__free_kmem_pages(page, order);
+	memcg_uncharge_slab(page, order, s);
+	__free_pages(page, order);
 }
 
 #define need_reserve_slab_rcu						\
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

