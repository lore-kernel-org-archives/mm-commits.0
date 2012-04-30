From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-mlock-statistic-in-memorystat.patch removed from -mm tree
Date: Mon, 30 Apr 2012 15:48:40 -0700
Message-ID: <20120430224841.31BD3A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45296 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2D3Wso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 18:48:44 -0400
Received: by lbbgp10 with SMTP id gp10so115885lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 15:48:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, dan.magenheimer@oracle.com, dhillf@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add mlock statistic in memory.stat
has been removed from the -mm tree.  Its filename was
     memcg-add-mlock-statistic-in-memorystat.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: memcg: add mlock statistic in memory.stat

We have the nr_mlock stat both in meminfo as well as vmstat system wide,
this patch adds the mlock field into per-memcg memory stat.  The stat
itself enhances the metrics exported by memcg since the unevictable lru
includes more than mlock()'d page like SHM_LOCK'd.

Why we need to count mlock'd pages while they are unevictable and we can
not do much on them anyway?

This is true.  The mlock stat I am proposing is more helpful for system
admin and kernel developer to understand the system workload.  The same
information should be helpful to add into OOM log as well.  Many times in
the past that we need to read the mlock stat from the per-container
meminfo for different reason.  Afterall, we do have the ability to read
the mlock from meminfo and this patch fills the info in memcg.

The code is based on the following commit which went into 3.4-rc1:
89c06bd52fb9 ("memcg: use new logic for page stat accounting").

Tested:
$ cat /dev/cgroup/memory/memory.use_hierarchy
1

$ mkdir /dev/cgroup/memory/A
$ mkdir /dev/cgroup/memory/A/B
$ echo 1g >/dev/cgroup/memory/A/memory.limit_in_bytes
$ echo 1g >/dev/cgroup/memory/B/memory.limit_in_bytes

1. Run memtoy in B and mlock 512m file pages:
memtoy>file /export/hda3/file_512m private
memtoy>map file_512m 0 512m
memtoy>lock file_512m
memtoy:  mlock of file_512m [131072 pages] took  5.296secs.

$ cat /dev/cgroup/memory/A/B/memory.stat
mlock 536870912
unevictable 536870912
..
total_mlock 536870912
total_unevictable 536870912

$ cat /dev/cgroup/memory/A/memory.stat
mlock 0
unevictable 0
..
total_mlock 536870912
total_unevictable 536870912

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    1 +
 include/linux/memcontrol.h       |    1 +
 mm/internal.h                    |   18 ++++++++++++++++++
 mm/memcontrol.c                  |   16 ++++++++++++++++
 mm/mlock.c                       |   15 +++++++++++++++
 mm/page_alloc.c                  |   16 ++++++++++++----
 6 files changed, 63 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-mlock-statistic-in-memorystat Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-mlock-statistic-in-memorystat
+++ a/Documentation/cgroups/memory.txt
@@ -428,6 +428,7 @@ memory.stat file includes following stat
 cache		- # of bytes of page cache memory.
 rss		- # of bytes of anonymous and swap cache memory.
 mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
+mlock		- # of bytes of mlocked memory.
 pgpgin		- # of charging events to the memory cgroup. The charging
 		event happens each time a page is accounted as either mapped
 		anon page(RSS) or cache page(Page Cache) to the cgroup.
diff -puN include/linux/memcontrol.h~memcg-add-mlock-statistic-in-memorystat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mlock-statistic-in-memorystat
+++ a/include/linux/memcontrol.h
@@ -30,6 +30,7 @@ struct mm_struct;
 /* Stats that can be updated by kernel. */
 enum mem_cgroup_page_stat_item {
 	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
+	MEMCG_NR_MLOCK, /* # of pages charged as mlock */
 };
 
 struct mem_cgroup_reclaim_cookie {
diff -puN mm/internal.h~memcg-add-mlock-statistic-in-memorystat mm/internal.h
--- a/mm/internal.h~memcg-add-mlock-statistic-in-memorystat
+++ a/mm/internal.h
@@ -12,6 +12,7 @@
 #define __MM_INTERNAL_H
 
 #include <linux/mm.h>
+#include <linux/memcontrol.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
@@ -167,15 +168,22 @@ static inline void munlock_vma_pages_all
 static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
 	VM_BUG_ON(PageLRU(page));
 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_MLOCK);
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
+
 	return 1;
 }
 
@@ -197,8 +205,13 @@ extern void munlock_vma_page(struct page
 extern void __clear_page_mlock(struct page *page);
 static inline void clear_page_mlock(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (unlikely(TestClearPageMlocked(page)))
 		__clear_page_mlock(page);
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
@@ -207,6 +220,11 @@ static inline void clear_page_mlock(stru
  */
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
+	/*
+	 * Here we are supposed to update the page memcg's mlock stat and the
+	 * newpage memcgs' mlock. Since the page and newpage are always being
+	 * charged to the same memcg, so no need.
+	 */
 	if (TestClearPageMlocked(page)) {
 		unsigned long flags;
 
diff -puN mm/memcontrol.c~memcg-add-mlock-statistic-in-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mlock-statistic-in-memorystat
+++ a/mm/memcontrol.c
@@ -87,6 +87,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
+	MEM_CGROUP_STAT_MLOCK, /* # of pages charged as mlock()ed */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	MEM_CGROUP_STAT_NSTATS,
@@ -1979,6 +1980,9 @@ void mem_cgroup_update_page_stat(struct 
 	case MEMCG_NR_FILE_MAPPED:
 		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
+	case MEMCG_NR_MLOCK:
+		idx = MEM_CGROUP_STAT_MLOCK;
+		break;
 	default:
 		BUG();
 	}
@@ -2631,6 +2635,14 @@ static int mem_cgroup_move_account(struc
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
+
+	if (PageMlocked(page)) {
+		/* Update mlocked data for mem_cgroup */
+		preempt_disable();
+		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_MLOCK]);
+		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_MLOCK]);
+		preempt_enable();
+	}
 	mem_cgroup_charge_statistics(from, anon, -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
@@ -4234,6 +4246,7 @@ enum {
 	MCS_CACHE,
 	MCS_RSS,
 	MCS_FILE_MAPPED,
+	MCS_MLOCK,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
@@ -4258,6 +4271,7 @@ static struct {
 	{"cache", "total_cache"},
 	{"rss", "total_rss"},
 	{"mapped_file", "total_mapped_file"},
+	{"mlock", "total_mlock"},
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"swap", "total_swap"},
@@ -4283,6 +4297,8 @@ mem_cgroup_get_local_stat(struct mem_cgr
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_MLOCK);
+	s->stat[MCS_MLOCK] += val * PAGE_SIZE;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
diff -puN mm/mlock.c~memcg-add-mlock-statistic-in-memorystat mm/mlock.c
--- a/mm/mlock.c~memcg-add-mlock-statistic-in-memorystat
+++ a/mm/mlock.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL(can_do_mlock);
 
 /*
  *  LRU accounting for clear_page_mlock()
+ *  Make sure the caller calls mem_cgroup_begin[end]_update_page_stat,
+ *  otherwise it will be race between "move" and "page stat accounting".
  */
 void __clear_page_mlock(struct page *page)
 {
@@ -60,6 +62,7 @@ void __clear_page_mlock(struct page *pag
 	}
 
 	dec_zone_page_state(page, NR_MLOCK);
+	mem_cgroup_dec_page_stat(page, MEMCG_NR_MLOCK);
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
@@ -78,14 +81,20 @@ void __clear_page_mlock(struct page *pag
  */
 void mlock_vma_page(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
 	BUG_ON(!PageLocked(page));
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_MLOCK);
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /**
@@ -105,10 +114,15 @@ void mlock_vma_page(struct page *page)
  */
 void munlock_vma_page(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
 	BUG_ON(!PageLocked(page));
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_MLOCK);
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
@@ -141,6 +155,7 @@ void munlock_vma_page(struct page *page)
 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 		}
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /**
diff -puN mm/page_alloc.c~memcg-add-mlock-statistic-in-memorystat mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-add-mlock-statistic-in-memorystat
+++ a/mm/page_alloc.c
@@ -597,10 +597,14 @@ out:
  * free_page_mlock() -- clean up attempts to free and mlocked() page.
  * Page should not be on lru, so no need to fix that up.
  * free_pages_check() will verify...
+ *
+ * Make sure the caller calls mem_cgroup_begin[end]_update_page_stat,
+ * otherwise it will be race between "move" and "page stat accounting".
  */
 static inline void free_page_mlock(struct page *page)
 {
 	__dec_zone_page_state(page, NR_MLOCK);
+	mem_cgroup_dec_page_stat(page, MEMCG_NR_MLOCK);
 	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
 
@@ -717,17 +721,19 @@ static bool free_pages_prepare(struct pa
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
-	int wasMlocked = __TestClearPageMlocked(page);
+	bool locked;
 
 	if (!free_pages_prepare(page, order))
 		return;
 
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+	if (unlikely(__TestClearPageMlocked(page)))
 		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, order,
 					get_pageblock_migratetype(page));
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	local_irq_restore(flags);
 }
 
@@ -1290,7 +1296,7 @@ void free_hot_cold_page(struct page *pag
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 	int migratetype;
-	int wasMlocked = __TestClearPageMlocked(page);
+	bool locked;
 
 	if (!free_pages_prepare(page, 0))
 		return;
@@ -1298,10 +1304,12 @@ void free_hot_cold_page(struct page *pag
 	migratetype = get_pageblock_migratetype(page);
 	set_page_private(page, migratetype);
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+	if (unlikely(__TestClearPageMlocked(page)))
 		free_page_mlock(page);
 	__count_vm_event(PGFREE);
 
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Free ISOLATE pages back to the allocator because they are being
_

Patches currently in -mm which might be from yinghan@google.com are

mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch

