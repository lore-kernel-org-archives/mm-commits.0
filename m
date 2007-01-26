From: akpm@osdl.org
Subject: - mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:40 -0800
Message-ID: <200701260751.l0Q7peNu010749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030811AbXAZHvp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mbind: restrict nodes to the currently allowed cpuset
has been removed from the -mm tree.  Its filename was
     mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbind: restrict nodes to the currently allowed cpuset
From: Christoph Lameter <clameter@sgi.com>

Currently one can specify an arbitrary node mask to mbind that includes
nodes not allowed.  If that is done with an interleave policy then we will
go around all the nodes.  Those outside of the currently allowed cpuset
will be redirected to the border nodes.  Interleave will then create
imbalances at the borders of the cpuset.

This patch restricts the nodes to the currently allowed cpuset.

The RFC for this patch was discussed at
http://marc.theaimsgroup.com/?t=116793842100004&r=1&w=2

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mempolicy.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset
+++ a/mm/mempolicy.c
@@ -884,6 +884,10 @@ asmlinkage long sys_mbind(unsigned long 
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
+#ifdef CONFIG_CPUSETS
+	/* Restrict the nodes to the allowed nodes in the cpuset */
+	nodes_and(nodes, nodes, current->mems_allowed);
+#endif
 	return do_mbind(start, len, mode, &nodes, flags);
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
fix-writeback-calculation.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
use-zvc-for-free_pages-fix.patch
