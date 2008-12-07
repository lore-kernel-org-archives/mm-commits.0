From: akpm@linux-foundation.org
Subject: + memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:45:21 -0800
Message-ID: <200812070745.mB77jLQh004094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbYLGHqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com


The patch titled
     memcg: memcg reclaim stat trivial fixes
has been added to the -mm tree.  Its filename is
     memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch

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
Subject: memcg: memcg reclaim stat trivial fixes
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This patch has three trivial fixes.

 - rename mem_cgroup_get_reclaim_stat_by_page to mem_cgroup_get_reclaim_stat_from_page
 - repair silly forgotten "return" in get_reclaim_stat()
 - make update_zone_reclaim_stat() helper function for cleanup

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +-
 mm/memcontrol.c            |    3 +-
 mm/swap.c                  |   48 ++++++++++++++++++-----------------
 mm/vmscan.c                |    2 -
 4 files changed, 30 insertions(+), 27 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes
+++ a/include/linux/memcontrol.h
@@ -108,7 +108,7 @@ unsigned long mem_cgroup_zone_nr_pages(s
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone);
 struct zone_reclaim_stat*
-mem_cgroup_get_reclaim_stat_by_page(struct page *page);
+mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -282,7 +282,7 @@ mem_cgroup_get_reclaim_stat(struct mem_c
 }
 
 static inline struct zone_reclaim_stat*
-mem_cgroup_get_reclaim_stat_by_page(struct page *page)
+mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
 	return NULL;
 }
diff -puN mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes
+++ a/mm/memcontrol.c
@@ -470,7 +470,8 @@ struct zone_reclaim_stat *mem_cgroup_get
 	return &mz->reclaim_stat;
 }
 
-struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat_by_page(struct page *page)
+struct zone_reclaim_stat *
+mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
diff -puN mm/swap.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes mm/swap.c
--- a/mm/swap.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes
+++ a/mm/swap.c
@@ -151,14 +151,32 @@ void  rotate_reclaimable_page(struct pag
 	}
 }
 
+static void update_page_reclaim_stat(struct zone *zone, struct page *page,
+				     int file, int rotated)
+{
+	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
+	struct zone_reclaim_stat *memcg_reclaim_stat;
+
+	memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_from_page(page);
+
+	reclaim_stat->recent_scanned[file]++;
+	if (rotated)
+		reclaim_stat->recent_rotated[file]++;
+
+	if (!memcg_reclaim_stat)
+		return;
+
+	memcg_reclaim_stat->recent_scanned[file]++;
+	if (rotated)
+		memcg_reclaim_stat->recent_rotated[file]++;
+}
+
 /*
  * FIXME: speed this up?
  */
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
-	struct zone_reclaim_stat *memcg_reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -171,14 +189,7 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		reclaim_stat->recent_rotated[!!file]++;
-		reclaim_stat->recent_scanned[!!file]++;
-
-		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
-		if (memcg_reclaim_stat) {
-			memcg_reclaim_stat->recent_rotated[!!file]++;
-			memcg_reclaim_stat->recent_scanned[!!file]++;
-		}
+		update_page_reclaim_stat(zone, page, !!file, 1);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -393,8 +404,6 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
-	struct zone_reclaim_stat *reclaim_stat = NULL;
-	struct zone_reclaim_stat *memcg_reclaim_stat = NULL;
 
 	VM_BUG_ON(is_unevictable_lru(lru));
 
@@ -402,30 +411,23 @@ void ____pagevec_lru_add(struct pagevec 
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
 		int file;
+		int active;
 
 		if (pagezone != zone) {
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
-			reclaim_stat = &zone->reclaim_stat;
-			memcg_reclaim_stat =
-				mem_cgroup_get_reclaim_stat_by_page(page);
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
 		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
+		active = is_active_lru(lru);
 		file = is_file_lru(lru);
-		reclaim_stat->recent_scanned[file]++;
-		if (memcg_reclaim_stat)
-			memcg_reclaim_stat->recent_scanned[file]++;
-		if (is_active_lru(lru)) {
+		if (active)
 			SetPageActive(page);
-			reclaim_stat->recent_rotated[file]++;
-			if (memcg_reclaim_stat)
-				memcg_reclaim_stat->recent_rotated[file]++;
-		}
+		update_page_reclaim_stat(zone, page, file, active);
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
diff -puN mm/vmscan.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes
+++ a/mm/vmscan.c
@@ -134,7 +134,7 @@ static struct zone_reclaim_stat *get_rec
 						  struct scan_control *sc)
 {
 	if (!scan_global_lru(sc))
-		mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
+		return mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
 
 	return &zone->reclaim_stat;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-remove-up-version-lru_add_drain_all.patch
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
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch

