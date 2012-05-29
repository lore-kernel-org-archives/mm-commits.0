From: akpm@linux-foundation.org
Subject: [folded] mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch removed from -mm tree
Date: Tue, 29 May 2012 14:43:25 -0700
Message-ID: <20120529214325.B6161A021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52397 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2E2Vn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:43:27 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so280192wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:43:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2
has been removed from the -mm tree.  Its filename was
     mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch

This patch was dropped because it was folded into mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2

Don't confuse an address with a pfn.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2 mm/sparse.c
--- a/mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2
+++ a/mm/sparse.c
@@ -288,7 +288,7 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * this problem.
 	 */
 	goal = __pa(pgdat) & PAGE_SECTION_MASK;
-	host_pgdat = NODE_DATA(early_pfn_to_nid(goal));
+	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
 	return __alloc_bootmem_node_nopanic(host_pgdat, size,
 					    SMP_CACHE_BYTES, goal);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-remove-swap-token-code.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-buddy-dump-pg_compound_lock-page-flag.patch
mm-page_alloc-catch-out-of-date-list-of-page-flag-names.patch
mm-page_allocc-cleanups.patch
mm-consider-all-swapped-back-pages-in-used-once-logic.patch
mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch
mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch
mm-memblock-fix-memory-leak-on-extending-regions.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup-fix.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
mm-memcg-remove-obsolete-statistics-array-boundary-enum-item.patch
mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch
mm-memcg-print-statistics-directly-to-seq_file.patch
mm-memcg-keep-ratelimit-counter-separate-from-event-counters.patch
mm-memcg-group-swapped-out-statistics-counter-logically.patch
mm-memcg-print-statistics-from-live-counters.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
mm-memcg-get_lru_size-not-get_lruvec_size.patch
mm-trivial-cleanups-in-vmscanc.patch
mm-memcg-apply-add-del_page-to-lruvec.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
memcg-decrement-static-keys-at-real-destroy-time-v6.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v7.patch

