From: akpm@linux-foundation.org
Subject: - unevictable-lru-page-statistics.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:54 -0700
Message-ID: <200810202032.m9KKWse2010506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYJTUkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, h-shimamoto@ct.jp.nec.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Unevictable LRU Page Statistics
has been removed from the -mm tree.  Its filename was
     unevictable-lru-page-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unevictable LRU Page Statistics
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Report unevictable pages per zone and system wide.

Kosaki Motohiro added support for memory controller unevictable
statistics.

[riel@redhat.com: fix printk in show_free_areas()]
[akpm@linux-foundation.org: fix units in /proc/vmstats]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Debugged-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    6 ++++++
 fs/proc/proc_misc.c |    6 ++++++
 mm/memcontrol.c     |    6 ++++++
 mm/page_alloc.c     |   18 ++++++++++++++++--
 mm/vmstat.c         |    3 +++
 5 files changed, 37 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~unevictable-lru-page-statistics drivers/base/node.c
--- a/drivers/base/node.c~unevictable-lru-page-statistics
+++ a/drivers/base/node.c
@@ -70,6 +70,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(anon): %8lu kB\n"
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       "Node %d Noreclaim:      %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
@@ -99,6 +102,9 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
 		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
 		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+#endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
diff -puN fs/proc/proc_misc.c~unevictable-lru-page-statistics fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~unevictable-lru-page-statistics
+++ a/fs/proc/proc_misc.c
@@ -174,6 +174,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(anon): %8lu kB\n"
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		"Unevictable:    %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
 		"HighFree:       %8lu kB\n"
@@ -212,6 +215,9 @@ static int meminfo_read_proc(char *page,
 		K(pages[LRU_INACTIVE_ANON]),
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		K(pages[LRU_UNEVICTABLE]),
+#endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
diff -puN mm/memcontrol.c~unevictable-lru-page-statistics mm/memcontrol.c
--- a/mm/memcontrol.c~unevictable-lru-page-statistics
+++ a/mm/memcontrol.c
@@ -1006,6 +1006,7 @@ static int mem_control_stat_show(struct 
 	{
 		unsigned long active_anon, inactive_anon;
 		unsigned long active_file, inactive_file;
+		unsigned long unevictable;
 
 		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_INACTIVE_ANON);
@@ -1015,10 +1016,15 @@ static int mem_control_stat_show(struct 
 						LRU_INACTIVE_FILE);
 		active_file = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_ACTIVE_FILE);
+		unevictable = mem_cgroup_get_all_zonestat(mem_cont,
+							LRU_UNEVICTABLE);
+
 		cb->fill(cb, "active_anon", (active_anon) * PAGE_SIZE);
 		cb->fill(cb, "inactive_anon", (inactive_anon) * PAGE_SIZE);
 		cb->fill(cb, "active_file", (active_file) * PAGE_SIZE);
 		cb->fill(cb, "inactive_file", (inactive_file) * PAGE_SIZE);
+		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
+
 	}
 	return 0;
 }
diff -puN mm/page_alloc.c~unevictable-lru-page-statistics mm/page_alloc.c
--- a/mm/page_alloc.c~unevictable-lru-page-statistics
+++ a/mm/page_alloc.c
@@ -1864,13 +1864,21 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
-		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
+		" inactive_file:%lu"
+//TODO:  check/adjust line lengths
+#ifdef CONFIG_UNEVICTABLE_LRU
+		" unevictable:%lu"
+#endif
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		global_page_state(NR_UNEVICTABLE),
+#endif
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
@@ -1897,6 +1905,9 @@ void show_free_areas(void)
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+#ifdef CONFIG_UNEVICTABLE_LRU
+			" unevictable:%lukB"
+#endif
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1910,6 +1921,9 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
+#ifdef CONFIG_UNEVICTABLE_LRU
+			K(zone_page_state(zone, NR_UNEVICTABLE)),
+#endif
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
diff -puN mm/vmstat.c~unevictable-lru-page-statistics mm/vmstat.c
--- a/mm/vmstat.c~unevictable-lru-page-statistics
+++ a/mm/vmstat.c
@@ -623,6 +623,9 @@ static const char * const vmstat_text[] 
 	"nr_active_anon",
 	"nr_inactive_file",
 	"nr_active_file",
+#ifdef CONFIG_UNEVICTABLE_LRU
+	"nr_unevictable",
+#endif
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch

