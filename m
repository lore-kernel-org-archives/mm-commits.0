From: akpm@osdl.org
Subject: - mbind-restrict-nodes-to-the-currently-allowed-cpuset-fix.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:20:04 -0800
Message-ID: <200701122220.l0CMK4k6030819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161150AbXALWUS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mbind-restrict-nodes-to-the-currently-allowed-cpuset fix
has been removed from the -mm tree.  Its filename was
     mbind-restrict-nodes-to-the-currently-allowed-cpuset-fix.patch

This patch was dropped because it was folded into mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch

------------------------------------------------------
Subject: mbind-restrict-nodes-to-the-currently-allowed-cpuset fix
From: Christoph Lameter <clameter@sgi.com>

mems_allowed only exists if CONFIG_CPUSETS is set. So put an #ifdef around
it. Also move the masking of the nodes behind the error check (looks
better) and add a comment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mempolicy.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-restrict-nodes-to-the-currently-allowed-cpuset-fix
+++ a/mm/mempolicy.c
@@ -882,9 +882,12 @@ asmlinkage long sys_mbind(unsigned long 
 	int err;
 
 	err = get_nodes(&nodes, nmask, maxnode);
-	nodes_and(nodes, nodes, current->mems_allowed);
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

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
mbind-restrict-nodes-to-the-currently-allowed-cpuset-fix.patch
slab-cache_grow-cleanup.patch
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
