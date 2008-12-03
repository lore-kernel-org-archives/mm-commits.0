From: akpm@linux-foundation.org
Subject: - inactive_anon_is_low-move-to-vmscanc.patch removed from -mm tree
Date: Tue, 02 Dec 2008 21:37:38 -0800
Message-ID: <200812030537.mB35bd1v018173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYLCFiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:38:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     inactive_anon_is_low(): move to vmscan.c
has been removed from the -mm tree.  Its filename was
     inactive_anon_is_low-move-to-vmscanc.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inactive_anon_is_low(): move to vmscan.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The inactive_anon_is_low() is called only vmscan.  Then it can move to
vmscan.c

This patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 -------------------
 mm/vmscan.c               |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 19 deletions(-)

diff -puN include/linux/mm_inline.h~inactive_anon_is_low-move-to-vmscanc include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~inactive_anon_is_low-move-to-vmscanc
+++ a/include/linux/mm_inline.h
@@ -81,23 +81,4 @@ static inline enum lru_list page_lru(str
 	return lru;
 }
 
-/**
- * inactive_anon_is_low - check if anonymous pages need to be deactivated
- * @zone: zone to check
- *
- * Returns true if the zone does not have enough inactive anon pages,
- * meaning some active anon pages need to be deactivated.
- */
-static inline int inactive_anon_is_low(struct zone *zone)
-{
-	unsigned long active, inactive;
-
-	active = zone_page_state(zone, NR_ACTIVE_ANON);
-	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
-
-	if (inactive * zone->inactive_ratio < active)
-		return 1;
-
-	return 0;
-}
 #endif
diff -puN mm/vmscan.c~inactive_anon_is_low-move-to-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~inactive_anon_is_low-move-to-vmscanc
+++ a/mm/vmscan.c
@@ -1338,6 +1338,26 @@ static void shrink_active_list(unsigned 
 	pagevec_release(&pvec);
 }
 
+/**
+ * inactive_anon_is_low - check if anonymous pages need to be deactivated
+ * @zone: zone to check
+ *
+ * Returns true if the zone does not have enough inactive anon pages,
+ * meaning some active anon pages need to be deactivated.
+ */
+static int inactive_anon_is_low(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_ANON);
+	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+
+	if (inactive * zone->inactive_ratio < active)
+		return 1;
+
+	return 0;
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
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

