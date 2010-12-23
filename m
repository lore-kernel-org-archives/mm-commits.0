From: akpm@linux-foundation.org
Subject: [merged] mm-compactionc-avoid-double-mem_cgroup_del_lru.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:16 -0800
Message-ID: <201012232240.oBNMe4QV015421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab0LWWkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm/compaction.c: avoid double mem_cgroup_del_lru()
has been removed from the -mm tree.  Its filename was
     mm-compactionc-avoid-double-mem_cgroup_del_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/compaction.c: avoid double mem_cgroup_del_lru()
From: Minchan Kim <minchan.kim@gmail.com>

del_page_from_lru_list() already called mem_cgroup_del_lru().  So we must
not call it again.  It adds unnecessary overhead.

It was not a runtime bug because the TestClearPageCgroupAcctLRU() early in
mem_cgroup_del_lru_list() will prevent any double-deletion, etc.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/compaction.c~mm-compactionc-avoid-double-mem_cgroup_del_lru mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-avoid-double-mem_cgroup_del_lru
+++ a/mm/compaction.c
@@ -279,7 +279,6 @@ static unsigned long isolate_migratepage
 		/* Successfully isolated */
 		del_page_from_lru_list(zone, page, page_lru(page));
 		list_add(&page->lru, migratelist);
-		mem_cgroup_del_lru(page);
 		cc->nr_migratepages++;
 
 		/* Avoid isolating too much */
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-vmap-area-cache.patch
mm-find_get_pages_contig-fixlet.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
vmalloc-remove-redundant-unlikely.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

