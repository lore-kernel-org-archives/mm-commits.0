From: akpm@linux-foundation.org
Subject: - memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:17:07 -0800
Message-ID: <200901072317.n07NH7NT001594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763494AbZAGXRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid reclaim_stat oops when disabled
has been removed from the -mm tree.  Its filename was
     memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch

This patch was dropped because it was folded into memcg-add-zone_reclaim_stat.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid reclaim_stat oops when disabled
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_get_reclaim_stat_from_page() oopses in page_cgroup_zoneinfo()
when you boot with cgroup_disabled=memory: it needs to check for that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix
+++ a/mm/memcontrol.c
@@ -473,9 +473,14 @@ struct zone_reclaim_stat *mem_cgroup_get
 struct zone_reclaim_stat *
 mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+	struct page_cgroup *pc;
+	struct mem_cgroup_per_zone *mz;
 
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	pc = lookup_page_cgroup(page);
+	mz = page_cgroup_zoneinfo(pc);
 	if (!mz)
 		return NULL;
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
memcg-handle-swap-caches.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
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
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

