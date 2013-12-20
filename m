From: akpm@linux-foundation.org
Subject: +
 mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch added to -mm tree
Date: Fri, 20 Dec 2013 14:38:08 -0800
Message-ID: <52b4c6d0.DmzGzyvDpahZPGs+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3LTWiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 17:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, santosh.shilimkar@ti.com, grygorii.strashko@ti.com

Subject: + mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch added to -mm tree
To: grygorii.strashko@ti.com,santosh.shilimkar@ti.com,tj@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 14:38:08 -0800


The patch titled
     Subject: mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as input parameter
has been added to the -mm tree.  Its filename is
     mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as input parameter

Check nid parameter and produce warning if it has deprecated MAX_NUMNODES
value.  Also re-assign NUMA_NO_NODE value to the nid parameter in this
case.

These will help to identify the wrong API usage (the caller) and make code
simpler.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/memblock.c~mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter
+++ a/mm/memblock.c
@@ -785,11 +785,9 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
-	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
-	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
-			     __func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	for ( ; mi < mem->cnt; mi++) {
 		struct memblock_region *m = &mem->regions[mi];
@@ -797,7 +795,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (check_node && nid != memblock_get_region_node(m))
+		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
 		/* scan areas before each reservation for intersection */
@@ -858,11 +856,9 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
-	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
-	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
-			     __func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	if (*idx == (u64)ULLONG_MAX) {
 		mi = mem->cnt - 1;
@@ -875,7 +871,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (check_node && nid != memblock_get_region_node(m))
+		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
 		/* skip hotpluggable memory regions if needed */
@@ -1067,9 +1063,8 @@ static void * __init memblock_virt_alloc
 	phys_addr_t alloc;
 	void *ptr;
 
-	if (nid == MAX_NUMNODES)
-		pr_warn("%s: usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE\n",
-			__func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	/*
 	 * Detect any accidental use of these APIs after slab is ready, as at
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-3.patch
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
mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

