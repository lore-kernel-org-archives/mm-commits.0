From: akpm@linux-foundation.org
Subject: + mm-vmstat-add-isolate-pages.patch added to -mm tree
Date: Wed, 15 Jul 2009 20:21:36 -0700
Message-ID: <200907160321.n6G3LaFZ028244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbZGPDVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 23:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: vmstat: add isolate pages
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-isolate-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmstat: add isolate pages
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If the system is running a heavy load of processes then concurrent reclaim
can isolate a large number of pages from the LRU. /proc/meminfo and the
output generated for an OOM do not show how many pages were isolated.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    4 ++++
 fs/proc/meminfo.c      |    4 ++++
 include/linux/mmzone.h |    2 ++
 mm/migrate.c           |   11 +++++++++++
 mm/page_alloc.c        |   12 +++++++++---
 mm/vmscan.c            |   12 +++++++++++-
 mm/vmstat.c            |    2 ++
 7 files changed, 43 insertions(+), 4 deletions(-)

diff -puN drivers/base/node.c~mm-vmstat-add-isolate-pages drivers/base/node.c
--- a/drivers/base/node.c~mm-vmstat-add-isolate-pages
+++ a/drivers/base/node.c
@@ -73,6 +73,8 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 		       "Node %d Unevictable:    %8lu kB\n"
+		       "Node %d Isolated(anon): %8lu kB\n"
+		       "Node %d Isolated(file): %8lu kB\n"
 		       "Node %d Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -106,6 +108,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_ISOLATED_ANON)),
+		       nid, K(node_page_state(nid, NR_ISOLATED_FILE)),
 		       nid, K(node_page_state(nid, NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
diff -puN fs/proc/meminfo.c~mm-vmstat-add-isolate-pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-vmstat-add-isolate-pages
+++ a/fs/proc/meminfo.c
@@ -65,6 +65,8 @@ static int meminfo_proc_show(struct seq_
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
 		"Unevictable:    %8lu kB\n"
+		"Isolated(anon): %8lu kB\n"
+		"Isolated(file): %8lu kB\n"
 		"Mlocked:        %8lu kB\n"
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -110,6 +112,8 @@ static int meminfo_proc_show(struct seq_
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
 		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_ISOLATED_ANON)),
+		K(global_page_state(NR_ISOLATED_FILE)),
 		K(global_page_state(NR_MLOCK)),
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
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
+	int flags;
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
@@ -2144,16 +2144,18 @@ void show_free_areas(void)
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
@@ -2181,6 +2183,8 @@ void show_free_areas(void)
 			" active_file:%lukB"
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
+			" isolated(anon):%lukB"
+			" isolated(file):%lukB"
 			" present:%lukB"
 			" mlocked:%lukB"
 			" dirty:%lukB"
@@ -2207,6 +2211,8 @@ void show_free_areas(void)
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
@@ -1067,6 +1067,8 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
 		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
+		unsigned long nr_anon;
+		unsigned long nr_file;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1097,6 +1099,10 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
+		nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+		nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1164,6 +1170,9 @@ static unsigned long shrink_inactive_lis
 				spin_lock_irq(&zone->lru_lock);
 			}
 		}
+		__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+		__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+
   	} while (nr_scanned < max_scan);
 
 done:
@@ -1274,6 +1283,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
 	else
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
@@ -1324,7 +1334,7 @@ static void shrink_active_list(unsigned 
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

linux-next.patch
mm-copy-over-oom_adj-value-at-fork-time.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

