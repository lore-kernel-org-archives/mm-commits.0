From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
 removed from -mm tree
Date: Wed, 10 Dec 2014 15:13:59 -0800
Message-ID: <5488d3b7.ZNZkoOeEVDsIGqgs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbaLJXOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch

This patch was dropped because it was folded into mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix

Make sure that the cached reference is always released.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix
+++ a/mm/memcontrol.c
@@ -1165,9 +1165,17 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	}
 
 	if (reclaim) {
-		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
-			css_get(&memcg->css);
+		if (cmpxchg(&iter->position, pos, memcg) == pos) {
+			if (memcg)
+				css_get(&memcg->css);
+			if (pos)
+				css_put(&pos->css);
+		}
 
+		/*
+		 * pairs with css_tryget when dereferencing iter->position
+		 * above.
+		 */
 		if (pos)
 			css_put(&pos->css);
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
mm-hugetlb-fix-__unmap_hugepage_range.patch
mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch

