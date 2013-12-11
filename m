From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch added to -mm tree
Date: Wed, 11 Dec 2013 13:29:19 -0800
Message-ID: <52a8d92f.0yMif1w/rE231qEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LKV3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 16:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, mgorman@suse.de, dave.hansen@intel.com, hannes@cmpxchg.org

Subject: + mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch added to -mm tree
To: hannes@cmpxchg.org,dave.hansen@intel.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 13:29:19 -0800


The patch titled
     Subject: mm: page_alloc: exclude unreclaimable allocations from zone fairness policy
has been added to the -mm tree.  Its filename is
     mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
mm-page_alloc-exclude-unreclaimable-allocations-from-zone-fairness-policy.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
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
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

