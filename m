From: akpm@linux-foundation.org
Subject: + vmscan-noreclaim-lru-page-statistics.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:39 -0700
Message-ID: <200806090618.m596IdQg006631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbYFIGTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     vmscan: Noreclaim LRU Page Statistics
has been added to the -mm tree.  Its filename is
     vmscan-noreclaim-lru-page-statistics.patch

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
Subject: vmscan: Noreclaim LRU Page Statistics
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>


Report non-reclaimable pages per zone and system wide.

Kosaki Motohiro added support for memory controller noreclaim
statistics.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---

Index: linux-2.6.26-rc2-mm1/mm/page_alloc.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    6 ++++++
 fs/proc/proc_misc.c |    6 ++++++
 mm/memcontrol.c     |    6 ++++++
 mm/page_alloc.c     |   16 +++++++++++++++-
 mm/vmstat.c         |    3 +++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~noreclaim-lru-page-statistics drivers/base/node.c
--- a/drivers/base/node.c~noreclaim-lru-page-statistics
+++ a/drivers/base/node.c
@@ -67,6 +67,9 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Inactive(anon): %8lu kB\n"
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_LRU
+		       "Node %d Noreclaim:      %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
 		       "Node %d HighFree:       %8lu kB\n"
@@ -96,6 +99,9 @@ static ssize_t node_read_meminfo(struct 
 		       nid, node_page_state(nid, NR_INACTIVE_ANON),
 		       nid, node_page_state(nid, NR_ACTIVE_FILE),
 		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+#ifdef CONFIG_NORECLAIM_LRU
+		       nid, node_page_state(nid, NR_NORECLAIM),
+#endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
 		       nid, K(i.freehigh),
diff -puN fs/proc/proc_misc.c~noreclaim-lru-page-statistics fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~noreclaim-lru-page-statistics
+++ a/fs/proc/proc_misc.c
@@ -179,6 +179,9 @@ static int meminfo_read_proc(char *page,
 		"Inactive(anon): %8lu kB\n"
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
+#ifdef CONFIG_NORECLAIM_LRU
+		"Noreclaim:      %8lu kB\n"
+#endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
 		"HighFree:       %8lu kB\n"
@@ -214,6 +217,9 @@ static int meminfo_read_proc(char *page,
 		K(inactive_anon),
 		K(active_file),
 		K(inactive_file),
+#ifdef CONFIG_NORECLAIM_LRU
+		K(global_page_state(NR_NORECLAIM)),
+#endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
 		K(i.freehigh),
diff -puN mm/memcontrol.c~noreclaim-lru-page-statistics mm/memcontrol.c
--- a/mm/memcontrol.c~noreclaim-lru-page-statistics
+++ a/mm/memcontrol.c
@@ -933,6 +933,7 @@ static int mem_control_stat_show(struct 
 	{
 		unsigned long active_anon, inactive_anon;
 		unsigned long active_file, inactive_file;
+		unsigned long noreclaim;
 
 		inactive_anon = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_INACTIVE_ANON);
@@ -942,10 +943,15 @@ static int mem_control_stat_show(struct 
 						LRU_INACTIVE_FILE);
 		active_file = mem_cgroup_get_all_zonestat(mem_cont,
 						LRU_ACTIVE_FILE);
+		noreclaim = mem_cgroup_get_all_zonestat(mem_cont,
+							LRU_NORECLAIM);
+
 		cb->fill(cb, "active_anon", (active_anon) * PAGE_SIZE);
 		cb->fill(cb, "inactive_anon", (inactive_anon) * PAGE_SIZE);
 		cb->fill(cb, "active_file", (active_file) * PAGE_SIZE);
 		cb->fill(cb, "inactive_file", (inactive_file) * PAGE_SIZE);
+		cb->fill(cb, "noreclaim", noreclaim * PAGE_SIZE);
+
 	}
 	return 0;
 }
diff -puN mm/page_alloc.c~noreclaim-lru-page-statistics mm/page_alloc.c
--- a/mm/page_alloc.c~noreclaim-lru-page-statistics
+++ a/mm/page_alloc.c
@@ -1844,12 +1844,20 @@ void show_free_areas(void)
 	}
 
 	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
-		" inactive_file:%lu dirty:%lu writeback:%lu unstable:%lu\n"
+		" inactive_file:%lu"
+//TODO:  check/adjust line lengths
+#ifdef CONFIG_NORECLAIM_LRU
+		" noreclaim:%lu"
+#endif
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_INACTIVE_FILE),
+#ifdef CONFIG_NORECLAIM_LRU
+		global_page_state(NR_NORECLAIM),
+#endif
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
@@ -1876,6 +1884,9 @@ void show_free_areas(void)
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+#ifdef CONFIG_NORECLAIM_LRU
+			" noreclaim:%lukB"
+#endif
 			" present:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -1889,6 +1900,9 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
+#ifdef CONFIG_NORECLAIM_LRU
+			K(zone_page_state(zone, NR_NORECLAIM)),
+#endif
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
diff -puN mm/vmstat.c~noreclaim-lru-page-statistics mm/vmstat.c
--- a/mm/vmstat.c~noreclaim-lru-page-statistics
+++ a/mm/vmstat.c
@@ -606,6 +606,9 @@ static const char * const vmstat_text[] 
 	"nr_active_anon",
 	"nr_inactive_file",
 	"nr_active_file",
+#ifdef CONFIG_NORECLAIM_LRU
+	"nr_noreclaim",
+#endif
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch

