From: akpm@linux-foundation.org
Subject: - slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:36 -0700
Message-ID: <200708242056.l7OKuacc014077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763637AbXHXVIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: skip calling cache_free_alien() when the platform is not numa capable
has been removed from the -mm tree.  Its filename was
     slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: skip calling cache_free_alien() when the platform is not numa capable
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Skip calling cache_free_alien() when the platform is not numa capable. 
This will avoid cache misses that happen while accessing slabp (which is
per page memory reference) to get nodeid.  Instead use a global variable to
skip the call, which is mostly likely to be present in the cache.

This gives a 0.8% performance boost with the database oltp workload on a
quad-core SMP platform and by any means the number is not small :)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable mm/slab.c
--- a/mm/slab.c~slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable
+++ a/mm/slab.c
@@ -883,6 +883,7 @@ static void __slab_error(const char *fun
   */
 
 static int use_alien_caches __read_mostly = 1;
+static int numa_platform __read_mostly = 1;
 static int __init noaliencache_setup(char *s)
 {
 	use_alien_caches = 0;
@@ -1399,8 +1400,10 @@ void __init kmem_cache_init(void)
 	int order;
 	int node;
 
-	if (num_possible_nodes() == 1)
+	if (num_possible_nodes() == 1) {
 		use_alien_caches = 0;
+		numa_platform = 0;
+	}
 
 	for (i = 0; i < NUM_INIT_LISTS; i++) {
 		kmem_list3_init(&initkmem_list3[i]);
@@ -3558,7 +3561,14 @@ static inline void __cache_free(struct k
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	/*
+	 * Skip calling cache_free_alien() when the platform is not numa.
+	 * This will avoid cache misses that happen while accessing slabp (which
+	 * is per page memory  reference) to get nodeid. Instead use a global
+	 * variable to skip the call, which is mostly likely to be present in
+	 * the cache.
+	 */
+	if (numa_platform && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
