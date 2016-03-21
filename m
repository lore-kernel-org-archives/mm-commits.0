From: akpm@linux-foundation.org
Subject: [merged] powerpc-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:23 -0700
Message-ID: <56f03f9f.xrfLpu8tKI+pRG3E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     powerpc-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: powerpc: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC.  This patch changes the code to query whether
it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/traps.c     |    5 +---
 arch/powerpc/mm/hash_utils_64.c |   36 ++++++++++++++++--------------
 arch/powerpc/mm/init_32.c       |    8 +++---
 3 files changed, 26 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/kernel/traps.c~powerpc-query-dynamic-debug_pagealloc-setting arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~powerpc-query-dynamic-debug_pagealloc-setting
+++ a/arch/powerpc/kernel/traps.c
@@ -203,9 +203,8 @@ static int __kprobes __die(const char *s
 #ifdef CONFIG_SMP
 	printk("SMP NR_CPUS=%d ", NR_CPUS);
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC ");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC ");
 #ifdef CONFIG_NUMA
 	printk("NUMA ");
 #endif
diff -puN arch/powerpc/mm/hash_utils_64.c~powerpc-query-dynamic-debug_pagealloc-setting arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~powerpc-query-dynamic-debug_pagealloc-setting
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -255,8 +255,10 @@ int htab_bolt_mapping(unsigned long vsta
 
 		if (ret < 0)
 			break;
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((paddr >> PAGE_SHIFT) < linear_map_hash_count)
+		if (debug_pagealloc_enabled() &&
+			(paddr >> PAGE_SHIFT) < linear_map_hash_count)
 			linear_map_hash_slots[paddr >> PAGE_SHIFT] = ret | 0x80;
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 	}
@@ -512,17 +514,17 @@ static void __init htab_init_page_sizes(
 	if (mmu_has_feature(MMU_FTR_16M_PAGE))
 		memcpy(mmu_psize_defs, mmu_psize_defaults_gp,
 		       sizeof(mmu_psize_defaults_gp));
- found:
-#ifndef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Pick a size for the linear mapping. Currently, we only support
-	 * 16M, 1M and 4K which is the default
-	 */
-	if (mmu_psize_defs[MMU_PAGE_16M].shift)
-		mmu_linear_psize = MMU_PAGE_16M;
-	else if (mmu_psize_defs[MMU_PAGE_1M].shift)
-		mmu_linear_psize = MMU_PAGE_1M;
-#endif /* CONFIG_DEBUG_PAGEALLOC */
+found:
+	if (!debug_pagealloc_enabled()) {
+		/*
+		 * Pick a size for the linear mapping. Currently, we only
+		 * support 16M, 1M and 4K which is the default
+		 */
+		if (mmu_psize_defs[MMU_PAGE_16M].shift)
+			mmu_linear_psize = MMU_PAGE_16M;
+		else if (mmu_psize_defs[MMU_PAGE_1M].shift)
+			mmu_linear_psize = MMU_PAGE_1M;
+	}
 
 #ifdef CONFIG_PPC_64K_PAGES
 	/*
@@ -721,10 +723,12 @@ static void __init htab_initialize(void)
 	prot = pgprot_val(PAGE_KERNEL);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
-	linear_map_hash_slots = __va(memblock_alloc_base(linear_map_hash_count,
-						    1, ppc64_rma_size));
-	memset(linear_map_hash_slots, 0, linear_map_hash_count);
+	if (debug_pagealloc_enabled()) {
+		linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
+		linear_map_hash_slots = __va(memblock_alloc_base(
+				linear_map_hash_count, 1, ppc64_rma_size));
+		memset(linear_map_hash_slots, 0, linear_map_hash_count);
+	}
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
 	/* On U3 based machines, we need to reserve the DART area and
diff -puN arch/powerpc/mm/init_32.c~powerpc-query-dynamic-debug_pagealloc-setting arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~powerpc-query-dynamic-debug_pagealloc-setting
+++ a/arch/powerpc/mm/init_32.c
@@ -112,10 +112,10 @@ void __init MMU_setup(void)
 	if (strstr(boot_command_line, "noltlbs")) {
 		__map_without_ltlbs = 1;
 	}
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	__map_without_bats = 1;
-	__map_without_ltlbs = 1;
-#endif
+	if (debug_pagealloc_enabled()) {
+		__map_without_bats = 1;
+		__map_without_ltlbs = 1;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


