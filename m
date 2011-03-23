From: akpm@linux-foundation.org
Subject: [merged] memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:29 -0700
Message-ID: <201103232040.p2NKe5Uj028498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933394Ab1CWU5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@


The patch titled
     memcg: move memcg reclaimable page into tail of inactive list
has been removed from the -mm tree.  Its filename was
     memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move memcg reclaimable page into tail of inactive list
From: Minchan Kim <minchan.kim@gmail.com>

The rotate_reclaimable_page function moves just written out pages, which
the VM wanted to reclaim, to the end of the inactive list.  That way the
VM will find those pages first next time it needs to free memory.

This patch applies the rule in memcg.  It can help to prevent unnecessary
working page eviction of memcg.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   26 ++++++++++++++++++++++++++
 mm/swap.c                  |    3 ++-
 3 files changed, 34 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list
+++ a/include/linux/memcontrol.h
@@ -62,6 +62,7 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 extern void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru);
+extern void mem_cgroup_rotate_reclaimable_page(struct page *page);
 extern void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru);
 extern void mem_cgroup_del_lru(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page,
@@ -211,6 +212,11 @@ static inline void mem_cgroup_del_lru_li
 	return ;
 }
 
+static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
+{
+	return ;
+}
+
 static inline void mem_cgroup_rotate_lru_list(struct page *page, int lru)
 {
 	return ;
diff -puN mm/memcontrol.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list
+++ a/mm/memcontrol.c
@@ -829,6 +829,32 @@ void mem_cgroup_del_lru(struct page *pag
 	mem_cgroup_del_lru_list(page, page_lru(page));
 }
 
+/*
+ * Writeback is about to end against a page which has been marked for immediate
+ * reclaim.  If it still appears to be reclaimable, move it to the tail of the
+ * inactive list.
+ */
+void mem_cgroup_rotate_reclaimable_page(struct page *page)
+{
+	struct mem_cgroup_per_zone *mz;
+	struct page_cgroup *pc;
+	enum lru_list lru = page_lru(page);
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(page);
+	/* unused or root page is not rotated. */
+	if (!PageCgroupUsed(pc))
+		return;
+	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+	smp_rmb();
+	if (mem_cgroup_is_root(pc->mem_cgroup))
+		return;
+	mz = page_cgroup_zoneinfo(pc);
+	list_move_tail(&pc->lru, &mz->lists[lru]);
+}
+
 void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
diff -puN mm/swap.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list mm/swap.c
--- a/mm/swap.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list
+++ a/mm/swap.c
@@ -200,8 +200,9 @@ static void pagevec_move_tail(struct pag
 			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-			int lru = page_lru_base_type(page);
+			enum lru_list lru = page_lru_base_type(page);
 			list_move_tail(&page->lru, &zone->lru[lru].list);
+			mem_cgroup_rotate_reclaimable_page(page);
 			pgmoved++;
 		}
 	}
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

