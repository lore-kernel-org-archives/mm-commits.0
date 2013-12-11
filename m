From: akpm@linux-foundation.org
Subject: + mm-memblock-print-phys_addr_t-using-%pa.patch added to -mm tree
Date: Wed, 11 Dec 2013 14:10:53 -0800
Message-ID: <52a8e2ed.kWhEtzhUU4WjFsPC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3LKWKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 17:10:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, grygorii.strashko@ti.com

Subject: + mm-memblock-print-phys_addr_t-using-%pa.patch added to -mm tree
To: grygorii.strashko@ti.com,tj@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 14:10:53 -0800


The patch titled
     Subject: mm/memblock: print phys_addr_t using %pa
has been added to the -mm tree.  Its filename is
     mm-memblock-print-phys_addr_t-using-%pa.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-print-phys_addr_t-using-%pa.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-print-phys_addr_t-using-%pa.patch

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
Subject: mm/memblock: print phys_addr_t using %pa

printk supports %pa format specifier to print phys_addr_t type values, so
use it instead of %#010llx/0x%llx/0x%08lx and drop corresponding type
casting.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   86 ++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 46 deletions(-)

diff -puN mm/memblock.c~mm-memblock-print-phys_addr_t-using-%pa mm/memblock.c
--- a/mm/memblock.c~mm-memblock-print-phys_addr_t-using-%pa
+++ a/mm/memblock.c
@@ -312,7 +312,7 @@ static int __init_memblock memblock_doub
 {
 	struct memblock_region *new_array, *old_array;
 	phys_addr_t old_alloc_size, new_alloc_size;
-	phys_addr_t old_size, new_size, addr;
+	phys_addr_t old_size, new_size, addr, end_addr;
 	int use_slab = slab_is_available();
 	int *in_slab;
 
@@ -373,9 +373,9 @@ static int __init_memblock memblock_doub
 		return -1;
 	}
 
-	memblock_dbg("memblock: %s is doubled to %ld at [%#010llx-%#010llx]",
-			memblock_type_name(type), type->max * 2, (u64)addr,
-			(u64)addr + new_size - 1);
+	end_addr = addr + new_size - 1;
+	memblock_dbg("memblock: %s is doubled to %ld at [%pa-%pa]",
+		     memblock_type_name(type), type->max * 2, &addr, &end_addr);
 
 	/*
 	 * Found space, we now need to move the array over before we add the
@@ -673,10 +673,10 @@ int __init_memblock memblock_remove(phys
 
 int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
-	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
-		     (unsigned long long)base,
-		     (unsigned long long)base + size - 1,
-		     (void *)_RET_IP_);
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("   memblock_free: [%pa-%pa] %pF\n",
+		     &base, &end, (void *)_RET_IP_);
 
 	return __memblock_remove(&memblock.reserved, base, size);
 }
@@ -687,11 +687,10 @@ static int __init_memblock memblock_rese
 						   unsigned long flags)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
+	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
-		     (unsigned long long)base,
-		     (unsigned long long)base + size - 1,
-		     flags, (void *)_RET_IP_);
+	memblock_dbg("memblock_reserve: [%pa-%pa] flags %#02lx %pF\n",
+		     &base, &end, flags, (void *)_RET_IP_);
 
 	return memblock_add_region(_rgn, base, size, nid, flags);
 }
@@ -1012,8 +1011,8 @@ phys_addr_t __init memblock_alloc_base(p
 	alloc = __memblock_alloc_base(size, align, max_addr);
 
 	if (alloc == 0)
-		panic("ERROR: Failed to allocate 0x%llx bytes below 0x%llx.\n",
-		      (unsigned long long) size, (unsigned long long) max_addr);
+		panic("ERROR: Failed to allocate %pa bytes below %pa.\n",
+		      &size, &max_addr);
 
 	return alloc;
 }
@@ -1146,9 +1145,9 @@ void * __init memblock_virt_alloc_try_ni
 				phys_addr_t min_addr, phys_addr_t max_addr,
 				int nid)
 {
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
-		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
-		     (u64)max_addr, (void *)_RET_IP_);
+	memblock_dbg("%s: %pa bytes align=%pa nid=%d\n\tfrom=%pa max_addr=%pa %pF\n",
+		     __func__, &size, &align, nid, &min_addr,
+		     &max_addr, (void *)_RET_IP_);
 	return memblock_virt_alloc_internal(size, align, min_addr,
 					     max_addr, nid);
 }
@@ -1178,17 +1177,16 @@ void * __init memblock_virt_alloc_try_ni
 {
 	void *ptr;
 
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
-		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
-		     (u64)max_addr, (void *)_RET_IP_);
+	memblock_dbg("%s: %pa bytes align=%pa nid=%d\n\tfrom=%pa max_addr=%pa %pF\n",
+		     __func__, &size, &align, nid, &min_addr,
+		     &max_addr, (void *)_RET_IP_);
 	ptr = memblock_virt_alloc_internal(size, align,
 					   min_addr, max_addr, nid);
 	if (ptr)
 		return ptr;
 
-	panic("%s: Failed to allocate %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx\n",
-	      __func__, (u64)size, (u64)align, nid, (u64)min_addr,
-	      (u64)max_addr);
+	panic("%s: Failed to allocate %pa bytes align=%pa nid=%d from=%pa max_addr=%pa\n",
+	      __func__, &size, &align, nid, &min_addr, &max_addr);
 	return NULL;
 }
 
@@ -1202,9 +1200,10 @@ void * __init memblock_virt_alloc_try_ni
  */
 void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
 {
-	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
-		     __func__, (u64)base, (u64)base + size - 1,
-		     (void *)_RET_IP_);
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("%s: [%pa-%pa] %pF\n",
+		     __func__, &base, &end, (void *)_RET_IP_);
 	kmemleak_free_part(__va(base), size);
 	__memblock_remove(&memblock.reserved, base, size);
 }
@@ -1220,11 +1219,11 @@ void __init __memblock_free_early(phys_a
  */
 void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
-	u64 cursor, end;
+	phys_addr_t cursor, end;
 
-	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
-		     __func__, (u64)base, (u64)base + size - 1,
-		     (void *)_RET_IP_);
+	end = base + size - 1;
+	memblock_dbg("%s: [%pa-%pa] %pF\n",
+		     __func__, &base, &end, (void *)_RET_IP_);
 	kmemleak_free_part(__va(base), size);
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
@@ -1414,7 +1413,7 @@ void __init_memblock memblock_set_curren
 
 static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
-	unsigned long long base, size;
+	phys_addr_t base, size, end;
 	unsigned long flags;
 	int i;
 
@@ -1426,24 +1425,24 @@ static void __init_memblock memblock_dum
 
 		base = rgn->base;
 		size = rgn->size;
+		end = base + size - 1;
 		flags = rgn->flags;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
 #endif
-		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s flags: %#lx\n",
-			name, i, base, base + size - 1, size, nid_buf, flags);
+		pr_info(" %s[%#x]\t[%pa-%pa], %pa bytes%s flags: %#lx\n",
+			name, i, &base, &end, &size, nid_buf, flags);
 	}
 }
 
 void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
-	pr_info(" memory size = %#llx reserved size = %#llx\n",
-		(unsigned long long)memblock.memory.total_size,
-		(unsigned long long)memblock.reserved.total_size);
-
+	pr_info(" memory size = %pa reserved size = %pa\n",
+		&memblock.memory.total_size,
+		&memblock.reserved.total_size);
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
 }
@@ -1470,17 +1469,12 @@ static int memblock_debug_show(struct se
 	int i;
 
 	for (i = 0; i < type->cnt; i++) {
+		phys_addr_t end;
+
 		reg = &type->regions[i];
+		end = reg->base + reg->size - 1;
 		seq_printf(m, "%4d: ", i);
-		if (sizeof(phys_addr_t) == 4)
-			seq_printf(m, "0x%08lx..0x%08lx\n",
-				   (unsigned long)reg->base,
-				   (unsigned long)(reg->base + reg->size - 1));
-		else
-			seq_printf(m, "0x%016llx..0x%016llx\n",
-				   (unsigned long long)reg->base,
-				   (unsigned long long)(reg->base + reg->size - 1));
-
+		seq_printf(m, "%pa..%pa\n", &reg->base, &end);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
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
mm-memblock-print-phys_addr_t-using-%pa.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

