From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-add-memblock-memory-allocation-apis-fix-3.patch removed from
 -mm tree
Date: Tue, 21 Jan 2014 15:33:45 -0800
Message-ID: <52df03d9.yPkmyPj3Ngy27g28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAUXdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, grygorii.strashko@ti.com

Subject: [folded-merged] mm-memblock-add-memblock-memory-allocation-apis-fix-3.patch removed from -mm tree
To: grygorii.strashko@ti.com,tj@kernel.org,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:33:45 -0800


The patch titled
     Subject: mm/memblock: add more comments in code
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-memblock-memory-allocation-apis-fix-3.patch

This patch was dropped because it was folded into mm-memblock-add-memblock-memory-allocation-apis.patch

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: add more comments in code

Add additional description on:
- why warning is produced in case if slab is ready
- why kmemleak_alloc is called for each allocated memory block

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix-3 mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis-fix-3
+++ a/mm/memblock.c
@@ -1071,6 +1071,11 @@ static void * __init memblock_virt_alloc
 		pr_warn("%s: usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE\n",
 			__func__);
 
+	/*
+	 * Detect any accidental use of these APIs after slab is ready, as at
+	 * this moment memblock may be deinitialized already and its
+	 * internal data may be destroyed (after execution of free_all_bootmem)
+	 */
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
@@ -1107,7 +1112,9 @@ done:
 
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
-	 * are never reported as leaks.
+	 * are never reported as leaks. This is because many of these blocks
+	 * are only referred via the physical address which is not
+	 * looked up by kmemleak.
 	 */
 	kmemleak_alloc(ptr, size, 0, 0);
 
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
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
x86-mm-memblock-switch-to-use-numa_no_node.patch
mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch

