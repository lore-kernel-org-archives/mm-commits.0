From: akpm@linux-foundation.org
Subject: + revert-xxx.patch added to -mm tree
Date: Fri, 24 Jan 2014 11:17:36 -0800
Message-ID: <52e2bc50.72br1Wmndk5TwX2b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAXTRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, santosh.shilimkar@ti.com, mingo@elte.hu, hpa@zytor.com, grygorii.strashko@ti.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: + revert-xxx.patch added to -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,grygorii.strashko@ti.com,hpa@zytor.com,mingo@elte.hu,santosh.shilimkar@ti.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:17:36 -0800


The patch titled
     Subject: revert XXX
has been added to the -mm tree.  Its filename is
     revert-xxx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-xxx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-xxx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: revert XXX

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    2 +-
 include/linux/bootmem.h |   37 +++++++++++++++++++++++++++++++++++++
 lib/swiotlb.c           |    4 ++--
 3 files changed, 40 insertions(+), 3 deletions(-)

diff -puN arch/arm/kernel/setup.c~revert-xxx arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~revert-xxx
+++ a/arch/arm/kernel/setup.c
@@ -731,7 +731,7 @@ static void __init request_standard_reso
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = memblock_virt_alloc(sizeof(*res), 0);
+		res = memblock_virt_alloc_low(sizeof(*res), 0);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
diff -puN include/linux/bootmem.h~revert-xxx include/linux/bootmem.h
--- a/include/linux/bootmem.h~revert-xxx
+++ a/include/linux/bootmem.h
@@ -175,6 +175,27 @@ static inline void * __init memblock_vir
 						    NUMA_NO_NODE);
 }
 
+#ifndef ARCH_LOW_ADDRESS_LIMIT
+#define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
+#endif
+
+static inline void * __init memblock_virt_alloc_low(
+                                        phys_addr_t size, phys_addr_t align)
+{
+        return memblock_virt_alloc_try_nid(size, align,
+						   BOOTMEM_LOW_LIMIT,
+						   ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+}
+static inline void * __init memblock_virt_alloc_low_nopanic(
+                                        phys_addr_t size, phys_addr_t align)
+{
+        return memblock_virt_alloc_try_nid_nopanic(size, align,
+						   BOOTMEM_LOW_LIMIT,
+						   ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+}
+
 static inline void * __init memblock_virt_alloc_from_nopanic(
 		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
 {
@@ -238,6 +259,22 @@ static inline void * __init memblock_vir
 	return __alloc_bootmem_nopanic(size, align, BOOTMEM_LOW_LIMIT);
 }
 
+static inline void * __init memblock_virt_alloc_low(
+                                        phys_addr_t size, phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_low(size, align, BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_low_nopanic(
+                                        phys_addr_t size, phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_low_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+}
+
 static inline void * __init memblock_virt_alloc_from_nopanic(
 		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
 {
diff -puN lib/swiotlb.c~revert-xxx lib/swiotlb.c
--- a/lib/swiotlb.c~revert-xxx
+++ a/lib/swiotlb.c
@@ -172,7 +172,7 @@ int __init swiotlb_init_with_tbl(char *t
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	v_overflow_buffer = memblock_virt_alloc_nopanic(
+	v_overflow_buffer = memblock_virt_alloc_low_nopanic(
 						PAGE_ALIGN(io_tlb_overflow),
 						PAGE_SIZE);
 	if (!v_overflow_buffer)
@@ -220,7 +220,7 @@ swiotlb_init(int verbose)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	/* Get IO TLB memory from the low pages */
-	vstart = memblock_virt_alloc_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
+	vstart = memblock_virt_alloc_low_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
 	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
 		return;
 
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
revert-xxx.patch
x86-fix-numa-by-reverting-wrong-memblock-setting.patch

