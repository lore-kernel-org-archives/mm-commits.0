From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 023/131] unicore32: simplify detection of memory
 zone boundaries
Date: Wed, 03 Jun 2020 15:57:46 -0700
Message-ID: <20200603225746.kYv6t-kYX%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:57:48 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: unicore32: simplify detection of memory zone boundaries

free_area_init() only requires the definition of maximal PFN for each of
the supported zone rater than calculation of actual zone sizes and the
sizes of the holes between the zones.

After removal of CONFIG_HAVE_MEMBLOCK_NODE_MAP the free_area_init() is
available to all architectures.

Using this function instead of free_area_init_node() simplifies the zone
detection.

Link: http://lkml.kernel.org/r/20200412194859.12663-14-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Hoan Tran <hoan@os.amperecomputing.com>	[arm64]
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

 arch/unicore32/include/asm/memory.h  |    2 -
 arch/unicore32/include/mach/memory.h |    6 +--
 arch/unicore32/kernel/pci.c          |   14 +-------
 arch/unicore32/mm/init.c             |   43 +++++--------------------
 4 files changed, 15 insertions(+), 50 deletions(-)

--- a/arch/unicore32/include/asm/memory.h~unicore32-simplify-detection-of-memory-zone-boundaries
+++ a/arch/unicore32/include/asm/memory.h
@@ -60,7 +60,7 @@
 #ifndef __ASSEMBLY__
 
 #ifndef arch_adjust_zones
-#define arch_adjust_zones(size, holes) do { } while (0)
+#define arch_adjust_zones(max_zone_pfn) do { } while (0)
 #endif
 
 /*
--- a/arch/unicore32/include/mach/memory.h~unicore32-simplify-detection-of-memory-zone-boundaries
+++ a/arch/unicore32/include/mach/memory.h
@@ -25,10 +25,10 @@
 
 #if !defined(__ASSEMBLY__) && defined(CONFIG_PCI)
 
-void puv3_pci_adjust_zones(unsigned long *size, unsigned long *holes);
+void puv3_pci_adjust_zones(unsigned long *max_zone_pfn);
 
-#define arch_adjust_zones(size, holes) \
-	puv3_pci_adjust_zones(size, holes)
+#define arch_adjust_zones(max_zone_pfn) \
+	puv3_pci_adjust_zones(max_zone_pfn)
 
 #endif
 
--- a/arch/unicore32/kernel/pci.c~unicore32-simplify-detection-of-memory-zone-boundaries
+++ a/arch/unicore32/kernel/pci.c
@@ -133,21 +133,11 @@ static int pci_puv3_map_irq(const struct
  * This is really ugly and we need a better way of specifying
  * DMA-capable regions of memory.
  */
-void __init puv3_pci_adjust_zones(unsigned long *zone_size,
-	unsigned long *zhole_size)
+void __init puv3_pci_adjust_zones(unsigned long max_zone_pfn)
 {
 	unsigned int sz = SZ_128M >> PAGE_SHIFT;
 
-	/*
-	 * Only adjust if > 128M on current system
-	 */
-	if (zone_size[0] <= sz)
-		return;
-
-	zone_size[1] = zone_size[0] - sz;
-	zone_size[0] = sz;
-	zhole_size[1] = zhole_size[0];
-	zhole_size[0] = 0;
+	max_zone_pfn[ZONE_DMA] = sz;
 }
 
 /*
--- a/arch/unicore32/mm/init.c~unicore32-simplify-detection-of-memory-zone-boundaries
+++ a/arch/unicore32/mm/init.c
@@ -61,46 +61,21 @@ static void __init find_limits(unsigned
 	}
 }
 
-static void __init uc32_bootmem_free(unsigned long min, unsigned long max_low,
-	unsigned long max_high)
+static void __init uc32_bootmem_free(unsigned long max_low)
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
-	}
+	max_zone_pfn[ZONE_DMA] = max_low;
+	max_zone_pfn[ZONE_NORMAL] = max_low;
 
 	/*
 	 * Adjust the sizes according to any special requirements for
 	 * this machine type.
+	 * This might lower ZONE_DMA limit.
 	 */
-	arch_adjust_zones(zone_size, zhole_size);
+	arch_adjust_zones(max_zone_pfn);
 
-	free_area_init_node(0, zone_size, min, zhole_size);
+	free_area_init(max_zone_pfn);
 }
 
 int pfn_valid(unsigned long pfn)
@@ -176,11 +151,11 @@ void __init bootmem_init(void)
 	sparse_init();
 
 	/*
-	 * Now free the memory - free_area_init_node needs
+	 * Now free the memory - free_area_init needs
 	 * the sparse mem_map arrays initialized by sparse_init()
 	 * for memmap_init_zone(), otherwise all PFNs are invalid.
 	 */
-	uc32_bootmem_free(min, max_low, max_high);
+	uc32_bootmem_free(max_low);
 
 	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
 
_
