From: akpm@linux-foundation.org
Subject: + mm-oom-analysis-add-shmem-vmstat.patch added to -mm tree
Date: Mon, 13 Jul 2009 15:30:30 -0700
Message-ID: <200907132230.n6DMUV0Y004897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbZGMWa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 18:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, riel@redhat.com, rientjes@google.com


The patch titled
     mm: oom analysis: add shmem vmstat
has been added to the -mm tree.  Its filename is
     mm-oom-analysis-add-shmem-vmstat.patch

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
@@ -120,6 +120,8 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
+	if (PageSwapBacked(page))
+		__dec_zone_page_state(page, NR_SHMEM);
 	BUG_ON(page_mapped(page));
 
 	/*
@@ -476,6 +478,8 @@ int add_to_page_cache_locked(struct page
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
