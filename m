From: akpm@linux-foundation.org
Subject: - make-get_scan_ratio-memcg-safe.patch removed from -mm tree
Date: Tue, 02 Dec 2008 21:37:50 -0800
Message-ID: <200812030537.mB35bouF018277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbYLCFiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     make get_scan_ratio() memcg safe
has been removed from the -mm tree.  Its filename was
     make-get_scan_ratio-memcg-safe.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make get_scan_ratio() memcg safe
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, get_scan_ratio() always calculate the balancing value for
global reclaim and memcg reclaim doesn't use it.  Therefore it doesn't
have scan_global_lru() condition.

However, we plan to expand get_scan_ratio() to be usable for memcg too,
latter.  Then, The dependency code of global reclaim in the
get_scan_ratio() insert into scan_global_lru() condision explictly.

This patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~make-get_scan_ratio-memcg-safe mm/vmscan.c
--- a/mm/vmscan.c~make-get_scan_ratio-memcg-safe
+++ a/mm/vmscan.c
@@ -1423,13 +1423,16 @@ static void get_scan_ratio(struct zone *
 		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
-	free  = zone_page_state(zone, NR_FREE_PAGES);
 
-	/* If we have very few page cache pages, force-scan anon pages. */
-	if (unlikely(file + free <= zone->pages_high)) {
-		percent[0] = 100;
-		percent[1] = 0;
-		return;
+	if (scan_global_lru(sc)) {
+		free  = zone_page_state(zone, NR_FREE_PAGES);
+		/* If we have very few page cache pages,
+		   force-scan anon pages. */
+		if (unlikely(file + free <= zone->pages_high)) {
+			percent[0] = 100;
+			percent[1] = 0;
+			return;
+		}
 	}
 
 	/*
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
make-get_scan_ratio-memcg-safe.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_calc_reclaim.patch
memcg-show-inactive_ratio.patch
memcg-show-reclaim_stat.patch

