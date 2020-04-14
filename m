From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-simplify-detection-of-memory-zone-boundaries.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:26:06 -0700
Message-ID: <20200414002606.h2xB9sx3T%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNA0J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:26:09 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: arm: simplify detection of memory zone boundaries
has been added to the -mm tree.  Its filename is
     arm-simplify-detection-of-memory-zone-boundaries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-simplify-detection-of-memory-zone-boundaries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-simplify-detection-of-memory-zone-boundaries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm: simplify detection of memory zone boundaries

free_area_init() only requires the definition of maximal PFN for each of
the supported zone rater than calculation of actual zone sizes and the
sizes of the holes between the zones.

After removal of CONFIG_HAVE_MEMBLOCK_NODE_MAP the free_area_init() is
available to all architectures.

Using this function instead of free_area_init_node() simplifies the zone
detection.

Link: http://lkml.kernel.org/r/20200412194859.12663-8-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |   66 ++++---------------------------------------
 1 file changed, 7 insertions(+), 59 deletions(-)

--- a/arch/arm/mm/init.c~arm-simplify-detection-of-memory-zone-boundaries
+++ a/arch/arm/mm/init.c
@@ -92,18 +92,6 @@ EXPORT_SYMBOL(arm_dma_zone_size);
  */
 phys_addr_t arm_dma_limit;
 unsigned long arm_dma_pfn_limit;
-
-static void __init arm_adjust_dma_zone(unsigned long *size, unsigned long *hole,
-	unsigned long dma_size)
-{
-	if (size[0] <= dma_size)
-		return;
-
-	size[ZONE_NORMAL] = size[0] - dma_size;
-	size[ZONE_DMA] = dma_size;
-	hole[ZONE_NORMAL] = hole[0];
-	hole[ZONE_DMA] = 0;
-}
 #endif
 
 void __init setup_dma_zone(const struct machine_desc *mdesc)
@@ -121,56 +109,16 @@ void __init setup_dma_zone(const struct
 static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 	unsigned long max_high)
 {
-	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
-	struct memblock_region *reg;
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
-	/*
-	 * initialise the zones.
-	 */
-	memset(zone_size, 0, sizeof(zone_size));
-
-	/*
-	 * The memory size has already been determined.  If we need
-	 * to do anything fancy with the allocation of this memory
-	 * to the zones, now is the time to do it.
-	 */
-	zone_size[0] = max_low - min;
-#ifdef CONFIG_HIGHMEM
-	zone_size[ZONE_HIGHMEM] = max_high - max_low;
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfn[ZONE_DMA] = min(arm_dma_pfn_limit, max_low);
 #endif
-
-	/*
-	 * Calculate the size of the holes.
-	 *  holes = node_size - sum(bank_sizes)
-	 */
-	memcpy(zhole_size, zone_size, sizeof(zhole_size));
-	for_each_memblock(memory, reg) {
-		unsigned long start = memblock_region_memory_base_pfn(reg);
-		unsigned long end = memblock_region_memory_end_pfn(reg);
-
-		if (start < max_low) {
-			unsigned long low_end = min(end, max_low);
-			zhole_size[0] -= low_end - start;
-		}
+	max_zone_pfn[ZONE_NORMAL] = max_low;
 #ifdef CONFIG_HIGHMEM
-		if (end > max_low) {
-			unsigned long high_start = max(start, max_low);
-			zhole_size[ZONE_HIGHMEM] -= end - high_start;
-		}
+	max_zone_pfn[ZONE_HIGHMEM] = max_high;
 #endif
-	}
-
-#ifdef CONFIG_ZONE_DMA
-	/*
-	 * Adjust the sizes according to any special requirements for
-	 * this machine type.
-	 */
-	if (arm_dma_zone_size)
-		arm_adjust_dma_zone(zone_size, zhole_size,
-			arm_dma_zone_size >> PAGE_SHIFT);
-#endif
-
-	free_area_init_node(0, zone_size, min, zhole_size);
+	free_area_init(max_zone_pfn);
 }
 
 #ifdef CONFIG_HAVE_ARCH_PFN_VALID
@@ -306,7 +254,7 @@ void __init bootmem_init(void)
 	sparse_init();
 
 	/*
-	 * Now free the memory - free_area_init_node needs
+	 * Now free the memory - free_area_init needs
 	 * the sparse mem_map arrays initialized by sparse_init()
 	 * for memmap_init_zone(), otherwise all PFNs are invalid.
 	 */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
