From: akpm@linux-foundation.org
Subject: - memcg-add-mem_cgroup_zone_nr_pages.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:14 -0800
Message-ID: <200901082249.n08MnE0N028495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763510AbZAHXAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 18:00:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: add mem_cgroup_zone_nr_pages()
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_zone_nr_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add mem_cgroup_zone_nr_pages()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Introduce mem_cgroup_zone_nr_pages().  It is called by zone_nr_pages()
helper function.

This patch doesn't have any behavior change.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +++++++++++
 mm/memcontrol.c            |   12 +++++++++++-
 mm/vmscan.c                |    3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_zone_nr_pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_zone_nr_pages
+++ a/include/linux/memcontrol.h
@@ -102,6 +102,9 @@ extern long mem_cgroup_calc_reclaim(stru
 					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
+unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
+				       struct zone *zone,
+				       enum lru_list lru);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -260,6 +263,14 @@ mem_cgroup_inactive_anon_is_low(struct m
 	return 1;
 }
 
+static inline unsigned long
+mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg, struct zone *zone,
+			 enum lru_list lru)
+{
+	return 0;
+}
+
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_zone_nr_pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_zone_nr_pages
+++ a/mm/memcontrol.c
@@ -186,7 +186,6 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
 	0, /* FORCE */
 };
 
-
 /* for encoding cft->private value on file */
 #define _MEM			(0)
 #define _MEMSWAP		(1)
@@ -448,6 +447,17 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return 0;
 }
 
+unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
+				       struct zone *zone,
+				       enum lru_list lru)
+{
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	return MEM_CGROUP_ZSTAT(mz, lru);
+}
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
diff -puN mm/vmscan.c~memcg-add-mem_cgroup_zone_nr_pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-mem_cgroup_zone_nr_pages
+++ a/mm/vmscan.c
@@ -139,6 +139,9 @@ static struct zone_reclaim_stat *get_rec
 static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
 				   enum lru_list lru)
 {
+	if (!scan_global_lru(sc))
+		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
+
 	return zone_page_state(zone, NR_LRU_BASE + lru);
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

