From: akpm@linux-foundation.org
Subject: [failures] powerpc-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Mon, 08 Feb 2016 12:25:56 -0800
Message-ID: <56b8f9d4.tZYc61JDC2DIUH75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbcBHUZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 15:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, penberg@kernel.org, rientjes@google.com, sfr@canb.auug.org.au, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     powerpc-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: powerpc: query dynamic DEBUG_PAGEALLOC setting

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC.  This patch changes the code to query whether
it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/traps.c     |    5 +--
 arch/powerpc/mm/hash_utils_64.c |   40 +++++++++++++++---------------
 arch/powerpc/mm/init_32.c       |    8 +++---
 3 files changed, 26 insertions(+), 27 deletions(-)

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
@@ -255,10 +255,10 @@ int htab_bolt_mapping(unsigned long vsta
 
 		if (ret < 0)
 			break;
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((paddr >> PAGE_SHIFT) < linear_map_hash_count)
+
+		if (debug_pagealloc_enabled() &&
+			(paddr >> PAGE_SHIFT) < linear_map_hash_count)
 			linear_map_hash_slots[paddr >> PAGE_SHIFT] = ret | 0x80;
-#endif /* CONFIG_DEBUG_PAGEALLOC */
 	}
 	return ret < 0 ? ret : 0;
 }
@@ -512,17 +512,17 @@ static void __init htab_init_page_sizes(
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
@@ -720,12 +720,12 @@ static void __init htab_initialize(void)
 
 	prot = pgprot_val(PAGE_KERNEL);
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
-	linear_map_hash_slots = __va(memblock_alloc_base(linear_map_hash_count,
-						    1, ppc64_rma_size));
-	memset(linear_map_hash_slots, 0, linear_map_hash_count);
-#endif /* CONFIG_DEBUG_PAGEALLOC */
+	if (debug_pagealloc_enabled()) {
+		linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
+		linear_map_hash_slots = __va(memblock_alloc_base(
+				linear_map_hash_count, 1, ppc64_rma_size));
+		memset(linear_map_hash_slots, 0, linear_map_hash_count);
+	}
 
 	/* On U3 based machines, we need to reserve the DART area and
 	 * _NOT_ map it to avoid cache paradoxes as it's remapped non
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

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
sound-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch

