From: akpm@linux-foundation.org
Subject: + unevictable-lru-page-statistics.patch added to -mm tree
Date: Wed, 11 Jun 2008 12:59:49 -0700
Message-ID: <200806111959.m5BJxn8v015208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbYFKUAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     Unevictable LRU Page Statistics
has been added to the -mm tree.  Its filename is
     unevictable-lru-page-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unevictable LRU Page Statistics
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Report unevictable pages per zone and system wide.

Kosaki Motohiro added support for memory controller unevictable
statistics.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    6 ++++++
 fs/proc/proc_misc.c |    6 ++++++
 mm/memcontrol.c     |    6 ++++++
 mm/page_alloc.c     |   16 +++++++++++++++-
 mm/vmstat.c         |    3 +++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~unevictable-lru-page-statistics drivers/base/node.c
--- a/drivers/base/node.c~unevictable-lru-page-statistics
+++ a/drivers/base/node.c
@@ -67,6 +67,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(anon): %8lu kB\n"
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       "Node %d Noreclaim:      %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
@@ -96,6 +99,9 @@ static ssize_t node_read_meminfo(struct 
 		       nid, node_page_state(nid, NR_INACTIVE_ANON),
 		       nid, node_page_state(nid, NR_ACTIVE_FILE),
 		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+#ifdef CONFIG_UNEVICTABLE_LRU
+		       nid, node_page_state(nid, NR_UNEVICTABLE),
+#endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
diff -puN fs/proc/proc_misc.c~unevictable-lru-page-statistics fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~unevictable-lru-page-statistics
+++ a/fs/proc/proc_misc.c
@@ -175,6 +175,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(anon): %8lu kB\n"
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_UNEVICTABLE_LRU
+		"Unevictable:    %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
 		"HighFree:       %8lu kB\n"
@@ -210,6 +213,9 @@ static int meminfo_read_proc(char *page,
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
@@ -930,6 +930,7 @@ static int mem_control_stat_show(struct 
 	{
 		unsigned long active_anon, inactive_anon;
 		unsigned long active_file, inactive_file;
+		unsigned long unevictable;
 
 		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_INACTIVE_ANON);
@@ -939,10 +940,15 @@ static int mem_control_stat_show(struct 
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
@@ -1844,12 +1844,20 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
-		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
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
@@ -1876,6 +1884,9 @@ void show_free_areas(void)
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+#ifdef CONFIG_UNEVICTABLE_LRU
+			" unevictable:%lukB"
+#endif
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1889,6 +1900,9 @@ void show_free_areas(void)
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
@@ -606,6 +606,9 @@ static const char * const vmstat_text[] 
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

vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch

