From: akpm@linux-foundation.org
Subject: [patch 055/101] mm, vmscan: Update all zone LRU sizes before
 updating memcg
Date: Thu, 28 Jul 2016 15:47:17 -0700
Message-ID: <579a8b75.s0vOwUzij+LEzGNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcG1WrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, minchan@kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: Update all zone LRU sizes before updating memcg

Minchan Kim reported setting the following warning on a 32-bit system
although it can affect 64-bit systems.

  WARNING: CPU: 4 PID: 1322 at mm/memcontrol.c:998 mem_cgroup_update_lru_size+0x103/0x110
  mem_cgroup_update_lru_size(f44b4000, 1, -7): zid 1 lru_size 1 but empty
  Modules linked in:
  CPU: 4 PID: 1322 Comm: cp Not tainted 4.7.0-rc4-mm1+ #143
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
   00000086 00000086 c2bc5a10 db3e4a97 c2bc5a54 db9d4025 c2bc5a40 db07b82a
   db9d0594 c2bc5a70 0000052a db9d4025 000003e6 db208463 000003e6 00000001
   f44b4000 00000001 c2bc5a5c db07b88b 00000009 00000000 c2bc5a54 db9d0594
  Call Trace:
   [<db3e4a97>] dump_stack+0x76/0xaf
   [<db07b82a>] __warn+0xea/0x110
   [<db208463>] ? mem_cgroup_update_lru_size+0x103/0x110
   [<db07b88b>] warn_slowpath_fmt+0x3b/0x40
   [<db208463>] mem_cgroup_update_lru_size+0x103/0x110
   [<db1b52a2>] isolate_lru_pages.isra.61+0x2e2/0x360
   [<db1b6ffc>] shrink_active_list+0xac/0x2a0
   [<db3f136e>] ? __delay+0xe/0x10
   [<db1b772c>] shrink_node_memcg+0x53c/0x7a0
   [<db1b7a3b>] shrink_node+0xab/0x2a0
   [<db1b7cf6>] do_try_to_free_pages+0xc6/0x390
   [<db1b8205>] try_to_free_pages+0x245/0x590

LRU list contents and counts are updated separately. Counts are updated
before pages are added to the LRU and updated after pages are removed.
The warning above is from a check in mem_cgroup_update_lru_size that
ensures that list sizes of zero are empty.

The problem is that node-lru needs to account for highmem pages if
CONFIG_HIGHMEM is set. One impact of the implementation is that the
sizes are updated in multiple passes when pages from multiple zones were
isolated. This happens whether HIGHMEM is set or not. When multiple zones
are isolated, it's possible for a debugging check in memcg to be tripped.

This patch forces all the zone counts to be updated before the memcg
function is called.

Link: http://lkml.kernel.org/r/1468588165-12461-6-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 include/linux/mm_inline.h  |    5 +---
 mm/memcontrol.c            |    5 ----
 mm/vmscan.c                |   40 ++++++++++++++++++++++++++++-------
 4 files changed, 37 insertions(+), 15 deletions(-)

diff -puN include/linux/memcontrol.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/include/linux/memcontrol.h
@@ -430,7 +430,7 @@ static inline bool mem_cgroup_online(str
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		enum zone_type zid, int nr_pages);
+		int nr_pages);
 
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask);
diff -puN include/linux/mm_inline.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/include/linux/mm_inline.h
@@ -52,10 +52,9 @@ static __always_inline void update_lru_s
 				enum lru_list lru, enum zone_type zid,
 				int nr_pages)
 {
-#ifdef CONFIG_MEMCG
-	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
-#else
 	__update_lru_size(lruvec, lru, zid, nr_pages);
+#ifdef CONFIG_MEMCG
+	mem_cgroup_update_lru_size(lruvec, lru, nr_pages);
 #endif
 }
 
diff -puN mm/memcontrol.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/mm/memcontrol.c
@@ -965,7 +965,6 @@ out:
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
- * @zid: Zone ID of the zone pages have been added to
  * @nr_pages: positive when adding or negative when removing
  *
  * This function must be called under lru_lock, just before a page is added
@@ -973,15 +972,13 @@ out:
  * so as to allow it to check that lru_size 0 is consistent with list_empty).
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				enum zone_type zid, int nr_pages)
+				int nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
 	long size;
 	bool empty;
 
-	__update_lru_size(lruvec, lru, zid, nr_pages);
-
 	if (mem_cgroup_disabled())
 		return;
 
diff -puN mm/vmscan.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/mm/vmscan.c
@@ -1350,6 +1350,38 @@ int __isolate_lru_page(struct page *page
 	return ret;
 }
 
+
+/*
+ * Update LRU sizes after isolating pages. The LRU size updates must
+ * be complete before mem_cgroup_update_lru_size due to a santity check.
+ */
+static __always_inline void update_lru_sizes(struct lruvec *lruvec,
+			enum lru_list lru, unsigned long *nr_zone_taken,
+			unsigned long nr_taken)
+{
+#ifdef CONFIG_HIGHMEM
+	int zid;
+
+	/*
+	 * Highmem has separate accounting for highmem pages so each zone
+	 * is updated separately.
+	 */
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		if (!nr_zone_taken[zid])
+			continue;
+
+		__update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
+	}
+#else
+	/* Zone ID does not matter on !HIGHMEM */
+	__update_lru_size(lruvec, lru, 0, -nr_taken);
+#endif
+
+#ifdef CONFIG_MEMCG
+	mem_cgroup_update_lru_size(lruvec, lru, -nr_taken);
+#endif
+}
+
 /*
  * zone_lru_lock is heavily contended.  Some of the functions that
  * shrink the lists perform better by taking out a batch of pages
@@ -1436,13 +1468,7 @@ static unsigned long isolate_lru_pages(u
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
-	for (scan = 0; scan < MAX_NR_ZONES; scan++) {
-		nr_pages = nr_zone_taken[scan];
-		if (!nr_pages)
-			continue;
