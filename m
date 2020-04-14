From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:26:10 -0700
Message-ID: <20200414002610.Ywdsv0Th3%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNA0N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:26:13 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: arm64: simplify detection of memory zone boundaries for UMA configs
has been added to the -mm tree.  Its filename is
     arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch

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
Subject: arm64: simplify detection of memory zone boundaries for UMA configs

The free_area_init() function only requires the definition of maximal PFN
for each of the supported zone rater than calculation of actual zone sizes
and the sizes of the holes between the zones.

After removal of CONFIG_HAVE_MEMBLOCK_NODE_MAP the free_area_init() is
available to all architectures.

Using this function instead of free_area_init_node() simplifies the zone
detection.

Link: http://lkml.kernel.org/r/20200412194859.12663-9-rppt@kernel.org
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

 arch/arm64/mm/init.c |   54 -----------------------------------------
 1 file changed, 54 deletions(-)

--- a/arch/arm64/mm/init.c~arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs
+++ a/arch/arm64/mm/init.c
@@ -192,8 +192,6 @@ static phys_addr_t __init max_zone_phys(
 	return min(offset + (1ULL << zone_bits), memblock_end_of_DRAM());
 }
 
-#ifdef CONFIG_NUMA
-
 static void __init zone_sizes_init(unsigned long min, unsigned long max)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES]  = {0};
@@ -209,58 +207,6 @@ static void __init zone_sizes_init(unsig
 	free_area_init(max_zone_pfns);
 }
 
-#else
-
-static void __init zone_sizes_init(unsigned long min, unsigned long max)
-{
-	struct memblock_region *reg;
-	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
-	unsigned long __maybe_unused max_dma, max_dma32;
-
-	memset(zone_size, 0, sizeof(zone_size));
-
-	max_dma = max_dma32 = min;
-#ifdef CONFIG_ZONE_DMA
-	max_dma = max_dma32 = PFN_DOWN(arm64_dma_phys_limit);
-	zone_size[ZONE_DMA] = max_dma - min;
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	max_dma32 = PFN_DOWN(arm64_dma32_phys_limit);
-	zone_size[ZONE_DMA32] = max_dma32 - max_dma;
-#endif
-	zone_size[ZONE_NORMAL] = max - max_dma32;
-
-	memcpy(zhole_size, zone_size, sizeof(zhole_size));
-
-	for_each_memblock(memory, reg) {
-		unsigned long start = memblock_region_memory_base_pfn(reg);
-		unsigned long end = memblock_region_memory_end_pfn(reg);
-
-#ifdef CONFIG_ZONE_DMA
-		if (start >= min && start < max_dma) {
-			unsigned long dma_end = min(end, max_dma);
-			zhole_size[ZONE_DMA] -= dma_end - start;
-			start = dma_end;
-		}
-#endif
-#ifdef CONFIG_ZONE_DMA32
-		if (start >= max_dma && start < max_dma32) {
-			unsigned long dma32_end = min(end, max_dma32);
-			zhole_size[ZONE_DMA32] -= dma32_end - start;
-			start = dma32_end;
-		}
-#endif
-		if (start >= max_dma32 && start < max) {
-			unsigned long normal_end = min(end, max);
-			zhole_size[ZONE_NORMAL] -= normal_end - start;
-		}
-	}
-
-	free_area_init_node(0, zone_size, min, zhole_size);
-}
-
-#endif /* CONFIG_NUMA */
