From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_zone_nr_pages.patch added to -mm tree
Date: Tue, 02 Dec 2008 20:17:15 -0800
Message-ID: <200812030417.mB34HFZ6005679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYLCERf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 23:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     memcg: add mem_cgroup_zone_nr_pages()
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_zone_nr_pages.patch

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
Subject: memcg: add mem_cgroup_zone_nr_pages()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Introduce mem_cgroup_zone_nr_pages().  It is called by zone_nr_pages()
helper function.

This patch doesn't have any behavior change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +++++++++++
 mm/memcontrol.c            |   12 +++++++++++-
 mm/vmscan.c                |    3 +++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_zone_nr_pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_zone_nr_pages
+++ a/include/linux/memcontrol.h
@@ -92,6 +92,9 @@ extern long mem_cgroup_calc_reclaim(stru
 					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
+unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
+				       struct zone *zone,
+				       enum lru_list lru);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -250,6 +253,14 @@ mem_cgroup_inactive_anon_is_low(struct m
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

vmscan-evict-streaming-io-first.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
mm-kill-zone_is_near_oom.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
inactive_anon_is_low-move-to-vmscanc.patch
introduce-zone_reclaim-struct.patch
add-zone_nr_pages-helper-function.patch
make-get_scan_ratio-memcg-safe.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_calc_reclaim.patch
memcg-show-inactive_ratio.patch
memcg-show-reclaim_stat.patch

