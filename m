From: akpm@osdl.org
Subject: + mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch added to -mm tree
Date: Wed, 10 Jan 2007 16:53:11 -0800
Message-ID: <200701110053.l0B0rB70012983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965281AbXAKAxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 19:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, pj@sgi.com


The patch titled
     mbind: restrict nodes to the currently allowed cpuset
has been added to the -mm tree.  Its filename is
     mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/mempolicy.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset
+++ a/mm/mempolicy.c
@@ -882,6 +882,7 @@ asmlinkage long sys_mbind(unsigned long 
 	int err;
 
 	err = get_nodes(&nodes, nmask, maxnode);
+	nodes_and(nodes, nodes, current->mems_allowed);
 	if (err)
 		return err;
 	return do_mbind(start, len, mode, &nodes, flags);
_

Patches currently in -mm which might be from clameter@sgi.com are

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
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
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
