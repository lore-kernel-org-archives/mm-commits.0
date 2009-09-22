From: akpm@linux-foundation.org
Subject: [merged] mm-oom-analysis-add-shmem-vmstat.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:15 -0700
Message-ID: <200909222038.n8MKcF0O001066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbZIVUjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: oom analysis: add shmem vmstat
has been removed from the -mm tree.  Its filename was
     mm-oom-analysis-add-shmem-vmstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: oom analysis: add shmem vmstat
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently we encountered OOM problems due to memory use of the GEM cache. 
Generally a large amuont of Shmem/Tmpfs pages tend to create a memory
shortage problem.

We often use the following calculation to determine the amount of shmem
pages:

shmem = NR_ACTIVE_ANON + NR_INACTIVE_ANON - NR_ANON_PAGES

however the expression does not consider isolated and mlocked pages.

This patch adds explicit accounting for pages used by shmem and tmpfs.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 ++
 fs/proc/meminfo.c      |    2 ++
 include/linux/mmzone.h |    1 +
 mm/filemap.c           |    4 ++++
 mm/migrate.c           |    5 ++++-
 mm/page_alloc.c        |    5 ++++-
 mm/vmstat.c            |    2 +-
 7 files changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/base/node.c~mm-oom-analysis-add-shmem-vmstat drivers/base/node.c
--- a/drivers/base/node.c~mm-oom-analysis-add-shmem-vmstat
+++ a/drivers/base/node.c
@@ -85,6 +85,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:      %8lu kB\n"
 		       "Node %d Mapped:         %8lu kB\n"
 		       "Node %d AnonPages:      %8lu kB\n"
+		       "Node %d Shmem:          %8lu kB\n"
 		       "Node %d KernelStack:    %8lu kB\n"
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
@@ -117,6 +118,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
diff -puN fs/proc/meminfo.c~mm-oom-analysis-add-shmem-vmstat fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-oom-analysis-add-shmem-vmstat
+++ a/fs/proc/meminfo.c
@@ -81,6 +81,7 @@ static int meminfo_proc_show(struct seq_
 		"Writeback:      %8lu kB\n"
 		"AnonPages:      %8lu kB\n"
 		"Mapped:         %8lu kB\n"
+		"Shmem:          %8lu kB\n"
 		"Slab:           %8lu kB\n"
 		"SReclaimable:   %8lu kB\n"
 		"SUnreclaim:     %8lu kB\n"
@@ -125,6 +126,7 @@ static int meminfo_proc_show(struct seq_
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_SHMEM)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
diff -puN include/linux/mmzone.h~mm-oom-analysis-add-shmem-vmstat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-oom-analysis-add-shmem-vmstat
+++ a/include/linux/mmzone.h
@@ -100,6 +100,7 @@ enum zone_stat_item {
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
+	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff -puN mm/filemap.c~mm-oom-analysis-add-shmem-vmstat mm/filemap.c
--- a/mm/filemap.c~mm-oom-analysis-add-shmem-vmstat
+++ a/mm/filemap.c
@@ -119,6 +119,8 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
+	if (PageSwapBacked(page))
+		__dec_zone_page_state(page, NR_SHMEM);
 	BUG_ON(page_mapped(page));
 
 	/*
@@ -431,6 +433,8 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
+			if (PageSwapBacked(page))
+				__inc_zone_page_state(page, NR_SHMEM);
 			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
diff -puN mm/migrate.c~mm-oom-analysis-add-shmem-vmstat mm/migrate.c
--- a/mm/migrate.c~mm-oom-analysis-add-shmem-vmstat
+++ a/mm/migrate.c
@@ -312,7 +312,10 @@ static int migrate_page_move_mapping(str
 	 */
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-
+	if (PageSwapBacked(page)) {
+		__dec_zone_page_state(page, NR_SHMEM);
+		__inc_zone_page_state(newpage, NR_SHMEM);
+	}
 	spin_unlock_irq(&mapping->tree_lock);
 
 	return 0;
diff -puN mm/page_alloc.c~mm-oom-analysis-add-shmem-vmstat mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-analysis-add-shmem-vmstat
+++ a/mm/page_alloc.c
@@ -2139,7 +2139,7 @@ void show_free_areas(void)
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu pagetables:%lu bounce:%lu\n",
+		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
@@ -2153,6 +2153,7 @@ void show_free_areas(void)
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
+		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE));
 
@@ -2175,6 +2176,7 @@ void show_free_areas(void)
 			" dirty:%lukB"
 			" writeback:%lukB"
 			" mapped:%lukB"
+			" shmem:%lukB"
 			" slab_reclaimable:%lukB"
 			" slab_unreclaimable:%lukB"
 			" kernel_stack:%lukB"
@@ -2200,6 +2202,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_FILE_DIRTY)),
 			K(zone_page_state(zone, NR_WRITEBACK)),
 			K(zone_page_state(zone, NR_FILE_MAPPED)),
+			K(zone_page_state(zone, NR_SHMEM)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
 			zone_page_state(zone, NR_KERNEL_STACK) *
diff -puN mm/vmstat.c~mm-oom-analysis-add-shmem-vmstat mm/vmstat.c
--- a/mm/vmstat.c~mm-oom-analysis-add-shmem-vmstat
+++ a/mm/vmstat.c
@@ -644,7 +644,7 @@ static const char * const vmstat_text[] 
 	"nr_bounce",
 	"nr_vmscan_write",
 	"nr_writeback_temp",
-
+	"nr_shmem",
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
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

