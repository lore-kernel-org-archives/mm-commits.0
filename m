From: akpm@linux-foundation.org
Subject: + mm-per-cgroup-memory-reclaim-stats.patch added to -mm tree
Date: Wed, 24 May 2017 14:36:25 -0700
Message-ID: <5925fcd9.ZKKDhXA8D1ffT30e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941010AbdEXVg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, bsingharora@gmail.com, hannes@cmpxchg.org, lizefan@huawei.com, mhocko@suse.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: per-cgroup memory reclaim stats
has been added to the -mm tree.  Its filename is
     mm-per-cgroup-memory-reclaim-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-per-cgroup-memory-reclaim-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-per-cgroup-memory-reclaim-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: per-cgroup memory reclaim stats

Track the following reclaim counters for every memory cgroup: PGREFILL,
PGSCAN, PGSTEAL, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE and PGLAZYFREED.

These values are exposed using the memory.stats interface of cgroup v2.

The meaning of each value is the same as for global counters, available
using /proc/vmstat.

Also, for consistency, rename mem_cgroup_count_vm_event() to
count_memcg_event_mm().

Link: http://lkml.kernel.org/r/1494530183-30808-1-git-send-email-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   28 +++++++++++++++++++
 fs/dax.c                    |    2 -
 fs/ncpfs/mmap.c             |    2 -
 include/linux/memcontrol.h  |   48 +++++++++++++++++++++++++++++++---
 mm/filemap.c                |    2 -
 mm/memcontrol.c             |   10 +++++++
 mm/memory.c                 |    4 +-
 mm/shmem.c                  |    3 --
 mm/swap.c                   |    1 
 mm/vmscan.c                 |   30 ++++++++++++++++-----
 10 files changed, 113 insertions(+), 17 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-per-cgroup-memory-reclaim-stats Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-per-cgroup-memory-reclaim-stats
+++ a/Documentation/cgroup-v2.txt
@@ -930,6 +930,34 @@ PAGE_SIZE multiple when read back.
 
 		Number of times a shadow node has been reclaimed
 
+	  pgrefill
+
+		Amount of scanned pages (in an active LRU list)
+
+	  pgscan
+
+		Amount of scanned pages (in an inactive LRU list)
+
+	  pgsteal
+
+		Amount of reclaimed pages
+
+	  pgactivate
+
+		Amount of pages moved to the active LRU list
+
+	  pgdeactivate
+
+		Amount of pages moved to the inactive LRU lis
+
+	  pglazyfree
+
+		Amount of pages postponed to be freed under memory pressure
+
+	  pglazyfreed
+
+		Amount of reclaimed lazyfree pages
+
   memory.swap.current
 
 	A read-only single value file which exists on non-root
diff -puN fs/dax.c~mm-per-cgroup-memory-reclaim-stats fs/dax.c
--- a/fs/dax.c~mm-per-cgroup-memory-reclaim-stats
+++ a/fs/dax.c
@@ -1212,7 +1212,7 @@ static int dax_iomap_pte_fault(struct vm
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
+			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
 		error = dax_insert_mapping(mapping, iomap.bdev, iomap.dax_dev,
diff -puN fs/ncpfs/mmap.c~mm-per-cgroup-memory-reclaim-stats fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~mm-per-cgroup-memory-reclaim-stats
+++ a/fs/ncpfs/mmap.c
@@ -89,7 +89,7 @@ static int ncp_file_mmap_fault(struct vm
 	 * -- nyc
 	 */
 	count_vm_event(PGMAJFAULT);
-	mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
+	count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 	return VM_FAULT_MAJOR;
 }
 
diff -puN include/linux/memcontrol.h~mm-per-cgroup-memory-reclaim-stats include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-per-cgroup-memory-reclaim-stats
+++ a/include/linux/memcontrol.h
@@ -357,6 +357,17 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
+static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+{
+	struct mem_cgroup_per_node *mz;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	return mz->memcg;
+}
+
 /**
  * parent_mem_cgroup - find the accounting parent of a memcg
  * @memcg: memcg whose parent to find
@@ -546,8 +557,23 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
-					     enum vm_event_item idx)
+static inline void count_memcg_events(struct mem_cgroup *memcg,
+				      enum vm_event_item idx,
+				      unsigned long count)
+{
+	if (!mem_cgroup_disabled())
+		this_cpu_add(memcg->stat->events[idx], count);
+}
+
+static inline void count_memcg_page_event(struct page *page,
+					  enum memcg_stat_item idx)
+{
+	if (page->mem_cgroup)
+		count_memcg_events(page->mem_cgroup, idx, 1);
+}
+
+static inline void count_memcg_event_mm(struct mm_struct *mm,
+					enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
 
@@ -675,6 +701,11 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
+static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+{
+	return NULL;
+}
+
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
 	return true;
@@ -789,8 +820,19 @@ static inline void mem_cgroup_split_huge
 {
 }
 
+static inline void count_memcg_events(struct mem_cgroup *memcg,
+				      enum vm_event_item idx,
+				      unsigned long count)
+{
+}
+
+static inline void count_memcg_page_event(struct page *page,
+					  enum memcg_stat_item idx)
+{
+}
+
 static inline
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
 #endif /* CONFIG_MEMCG */
diff -puN mm/filemap.c~mm-per-cgroup-memory-reclaim-stats mm/filemap.c
--- a/mm/filemap.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/filemap.c
@@ -2226,7 +2226,7 @@ int filemap_fault(struct vm_fault *vmf)
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vmf->vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
+		count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
 retry_find:
 		page = find_get_page(mapping, offset);
diff -puN mm/memcontrol.c~mm-per-cgroup-memory-reclaim-stats mm/memcontrol.c
--- a/mm/memcontrol.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/memcontrol.c
@@ -5230,6 +5230,16 @@ static int memory_stat_show(struct seq_f
 	seq_printf(m, "pgfault %lu\n", events[PGFAULT]);
 	seq_printf(m, "pgmajfault %lu\n", events[PGMAJFAULT]);
 
+	seq_printf(m, "pgrefill %lu\n", events[PGREFILL]);
+	seq_printf(m, "pgscan %lu\n", events[PGSCAN_KSWAPD] +
+		   events[PGSCAN_DIRECT]);
+	seq_printf(m, "pgsteal %lu\n", events[PGSTEAL_KSWAPD] +
+		   events[PGSTEAL_DIRECT]);
+	seq_printf(m, "pgactivate %lu\n", events[PGACTIVATE]);
+	seq_printf(m, "pgdeactivate %lu\n", events[PGDEACTIVATE]);
+	seq_printf(m, "pglazyfree %lu\n", events[PGLAZYFREE]);
+	seq_printf(m, "pglazyfreed %lu\n", events[PGLAZYFREED]);
+
 	seq_printf(m, "workingset_refault %lu\n",
 		   stat[WORKINGSET_REFAULT]);
 	seq_printf(m, "workingset_activate %lu\n",
diff -puN mm/memory.c~mm-per-cgroup-memory-reclaim-stats mm/memory.c
--- a/mm/memory.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/memory.c
@@ -2719,7 +2719,7 @@ int do_swap_page(struct vm_fault *vmf)
 		/* Had to read the page from swap area: Major fault */
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 	} else if (PageHWPoison(page)) {
 		/*
 		 * hwpoisoned dirty swapcache pages are kept for killing
@@ -3875,7 +3875,7 @@ int handle_mm_fault(struct vm_area_struc
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
-	mem_cgroup_count_vm_event(vma->vm_mm, PGFAULT);
+	count_memcg_event_mm(vma->vm_mm, PGFAULT);
 
 	/* do counter updates before entering really critical section. */
 	check_sync_rss_stat(current);
diff -puN mm/shmem.c~mm-per-cgroup-memory-reclaim-stats mm/shmem.c
--- a/mm/shmem.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/shmem.c
@@ -1645,8 +1645,7 @@ repeat:
 			if (fault_type) {
 				*fault_type |= VM_FAULT_MAJOR;
 				count_vm_event(PGMAJFAULT);
-				mem_cgroup_count_vm_event(charge_mm,
-							  PGMAJFAULT);
+				count_memcg_event_mm(charge_mm, PGMAJFAULT);
 			}
 			/* Here we actually start the io */
 			page = shmem_swapin(swap, gfp, info, index);
diff -puN mm/swap.c~mm-per-cgroup-memory-reclaim-stats mm/swap.c
--- a/mm/swap.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/swap.c
@@ -591,6 +591,7 @@ static void lru_lazyfree_fn(struct page
 		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
 
 		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
+		count_memcg_page_event(page, PGLAZYFREE);
 		update_page_reclaim_stat(lruvec, 1, 0);
 	}
 }
diff -puN mm/vmscan.c~mm-per-cgroup-memory-reclaim-stats mm/vmscan.c
--- a/mm/vmscan.c~mm-per-cgroup-memory-reclaim-stats
+++ a/mm/vmscan.c
@@ -1306,6 +1306,7 @@ static unsigned long shrink_page_list(st
 			}
 
 			count_vm_event(PGLAZYFREED);
+			count_memcg_page_event(page, PGLAZYFREED);
 		} else if (!mapping || !__remove_mapping(mapping, page, true))
 			goto keep_locked;
 		/*
@@ -1335,6 +1336,7 @@ activate_locked:
 		if (!PageMlocked(page)) {
 			SetPageActive(page);
 			pgactivate++;
+			count_memcg_page_event(page, PGACTIVATE);
 		}
 keep_locked:
 		unlock_page(page);
@@ -1774,11 +1776,16 @@ shrink_inactive_list(unsigned long nr_to
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
-	if (global_reclaim(sc)) {
-		if (current_is_kswapd())
+	if (current_is_kswapd()) {
+		if (global_reclaim(sc))
 			__count_vm_events(PGSCAN_KSWAPD, nr_scanned);
-		else
+		count_memcg_events(lruvec_memcg(lruvec), PGSCAN_KSWAPD,
+				   nr_scanned);
+	} else {
+		if (global_reclaim(sc))
 			__count_vm_events(PGSCAN_DIRECT, nr_scanned);
+		count_memcg_events(lruvec_memcg(lruvec), PGSCAN_DIRECT,
+				   nr_scanned);
 	}
 	spin_unlock_irq(&pgdat->lru_lock);
 
@@ -1790,11 +1797,16 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&pgdat->lru_lock);
 
-	if (global_reclaim(sc)) {
-		if (current_is_kswapd())
+	if (current_is_kswapd()) {
+		if (global_reclaim(sc))
 			__count_vm_events(PGSTEAL_KSWAPD, nr_reclaimed);
-		else
+		count_memcg_events(lruvec_memcg(lruvec), PGSTEAL_KSWAPD,
+				   nr_reclaimed);
+	} else {
+		if (global_reclaim(sc))
 			__count_vm_events(PGSTEAL_DIRECT, nr_reclaimed);
+		count_memcg_events(lruvec_memcg(lruvec), PGSTEAL_DIRECT,
+				   nr_reclaimed);
 	}
 
 	putback_inactive_pages(lruvec, &page_list);
@@ -1939,8 +1951,11 @@ static unsigned move_active_pages_to_lru
 		}
 	}
 
-	if (!is_active_lru(lru))
+	if (!is_active_lru(lru)) {
 		__count_vm_events(PGDEACTIVATE, nr_moved);
+		count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
+				   nr_moved);
+	}
 
 	return nr_moved;
 }
@@ -1978,6 +1993,7 @@ static void shrink_active_list(unsigned
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_vm_events(PGREFILL, nr_scanned);
+	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&pgdat->lru_lock);
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-per-cgroup-memory-reclaim-stats.patch

