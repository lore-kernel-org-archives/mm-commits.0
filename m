From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-add-isolate-pages.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:27 -0700
Message-ID: <200909222038.n8MKcRXo001454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbZIVUjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: vmstat: add isolate pages
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-isolate-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmstat: add isolate pages
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If the system is running a heavy load of processes then concurrent reclaim
can isolate a large number of pages from the LRU. /proc/vmstat and the
output generated for an OOM do not show how many pages were isolated.

This has been observed during process fork bomb testing (mstctl11 in LTP).

This patch shows the information about isolated pages.

Reproduced via:

-----------------------
% ./hackbench 140 process 1000
   => OOM occur

active_anon:146 inactive_anon:0 isolated_anon:49245
 active_file:79 inactive_file:18 isolated_file:113
 unevictable:0 dirty:0 writeback:0 unstable:0 buffer:39
 free:370 slab_reclaimable:309 slab_unreclaimable:5492
 mapped:53 shmem:15 pagetables:28140 bounce:0

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/migrate.c           |   11 +++++++++++
 mm/page_alloc.c        |   12 +++++++++---
 mm/vmscan.c            |   12 +++++++++++-
 mm/vmstat.c            |    2 ++
 5 files changed, 35 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmstat-add-isolate-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmstat-add-isolate-pages
+++ a/include/linux/mmzone.h
@@ -100,6 +100,8 @@ enum zone_stat_item {
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
+	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
+	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
diff -puN mm/migrate.c~mm-vmstat-add-isolate-pages mm/migrate.c
--- a/mm/migrate.c~mm-vmstat-add-isolate-pages
+++ a/mm/migrate.c
@@ -67,6 +67,8 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				    !!page_is_file_cache(page));
 		putback_lru_page(page);
 		count++;
 	}
@@ -698,6 +700,8 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
+		dec_zone_page_state(page, NR_ISOLATED_ANON +
+				    !!page_is_file_cache(page));
 		putback_lru_page(page);
 	}
 
@@ -742,6 +746,13 @@ int migrate_pages(struct list_head *from
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	list_for_each_entry(page, from, lru)
+		__inc_zone_page_state(page, NR_ISOLATED_ANON +
+				      !!page_is_file_cache(page));
+	local_irq_restore(flags);
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
diff -puN mm/page_alloc.c~mm-vmstat-add-isolate-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmstat-add-isolate-pages
+++ a/mm/page_alloc.c
@@ -2134,16 +2134,18 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
-		" inactive_file:%lu"
+	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
+		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
-		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
+		global_page_state(NR_ISOLATED_ANON),
+		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_FILE),
+		global_page_state(NR_ISOLATED_FILE),
 		global_page_state(NR_UNEVICTABLE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
@@ -2171,6 +2173,8 @@ void show_free_areas(void)
 			" active_file:%lukB"
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
+			" isolated(anon):%lukB"
+			" isolated(file):%lukB"
 			" present:%lukB"
 			" mlocked:%lukB"
 			" dirty:%lukB"
@@ -2197,6 +2201,8 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
+			K(zone_page_state(zone, NR_ISOLATED_ANON)),
+			K(zone_page_state(zone, NR_ISOLATED_FILE)),
 			K(zone->present_pages),
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_FILE_DIRTY)),
diff -puN mm/vmscan.c~mm-vmstat-add-isolate-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-add-isolate-pages
+++ a/mm/vmscan.c
@@ -1072,6 +1072,8 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
 		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
+		unsigned long nr_anon;
+		unsigned long nr_file;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1102,6 +1104,10 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
+		nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+		nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1169,6 +1175,9 @@ static unsigned long shrink_inactive_lis
 				spin_lock_irq(&zone->lru_lock);
 			}
 		}
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+
   	} while (nr_scanned < max_scan);
 
 done:
@@ -1279,6 +1288,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
@@ -1329,7 +1339,7 @@ static void shrink_active_list(unsigned 
 						LRU_ACTIVE + file * LRU_FILE);
 	move_active_pages_to_lru(zone, &l_inactive,
 						LRU_BASE   + file * LRU_FILE);
-
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 }
 
diff -puN mm/vmstat.c~mm-vmstat-add-isolate-pages mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-add-isolate-pages
+++ a/mm/vmstat.c
@@ -644,6 +644,8 @@ static const char * const vmstat_text[] 
 	"nr_bounce",
 	"nr_vmscan_write",
 	"nr_writeback_temp",
+	"nr_isolated_anon",
+	"nr_isolated_file",
 	"nr_shmem",
 #ifdef CONFIG_NUMA
 	"numa_hit",
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

