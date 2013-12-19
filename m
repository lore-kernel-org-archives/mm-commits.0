From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:51 -0800
Message-ID: <52b34ecf.YwcJg4WnAYm9qP1f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3LSTxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, mgorman@suse.de, dave.hansen@intel.com, hannes@cmpxchg.org

Subject: [merged] mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch removed from -mm tree
To: hannes@cmpxchg.org,dave.hansen@intel.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:51 -0800


The patch titled
     Subject: mm: page_alloc: exclude unreclaimable allocations from zone fairness policy
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: exclude unreclaimable allocations from zone fairness policy

Dave Hansen noted a regression in a microbenchmark that loops around
open() and close() on an 8-node NUMA machine and bisected it down to
81c0a2bb515f ("mm: page_alloc: fair zone allocator policy").  That change
forces the slab allocations of the file descriptor to spread out to all 8
nodes, causing remote references in the page allocator and slab.

The round-robin policy is only there to provide fairness among memory
allocations that are reclaimed involuntarily based on pressure in each
zone.  It does not make sense to apply it to unreclaimable kernel
allocations that are freed manually, in this case instantly after the
allocation, and incur the remote reference costs twice for no reason.

Only round-robin allocations that are usually freed through page reclaim
or slab shrinking.

Bisected by Dave Hansen.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy
+++ a/mm/page_alloc.c
@@ -1920,7 +1920,8 @@ zonelist_scan:
 		 * back to remote zones that do not partake in the
 		 * fairness round-robin cycle of this zonelist.
 		 */
-		if (alloc_flags & ALLOC_WMARK_LOW) {
+		if ((alloc_flags & ALLOC_WMARK_LOW) &&
+		    (gfp_mask & GFP_MOVABLE_MASK)) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (zone_reclaim_mode &&
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-memcg_size-calculation.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

