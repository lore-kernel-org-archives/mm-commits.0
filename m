From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:14:59 -0700
Message-ID: <20121008231500.45BEE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46948 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:15:01 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so537043ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:15:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix
has been removed from the -mm tree.  Its filename was
     mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch

This patch was dropped because it was folded into mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix

fix CONFIG_NUMA=n build

Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix
+++ a/mm/page_alloc.c
@@ -4558,7 +4558,9 @@ void __paginginit free_area_init_node(in
 	for_each_online_node(i)
 		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
 			node_set(i, pgdat->reclaim_nodes);
+#ifdef CONFIG_NUMA
 			zone_reclaim_mode = 1;
+#endif
 		}
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

