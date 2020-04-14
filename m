From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-use-free_area_init-instead-of-free_area_init_nodes.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 17:25:57 -0700
Message-ID: <20200414002557.L4B-6ylXL%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNAZ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:25:59 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: use free_area_init() instead of free_area_init_nodes()
has been added to the -mm tree.  Its filename is
     mm-use-free_area_init-instead-of-free_area_init_nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-free_area_init-instead-of-free_area_init_nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-free_area_init-instead-of-free_area_init_nodes.patch

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
Subject: mm: use free_area_init() instead of free_area_init_nodes()

free_area_init() has effectively became a wrapper for
free_area_init_nodes() and there is no point of keeping it.  Still
free_area_init() name is shorter and more general as it does not imply
necessity to initialize multiple nodes.

Rename free_area_init_nodes() to free_area_init(), update the callers and
drop old version of free_area_init().

Link: http://lkml.kernel.org/r/20200412194859.12663-6-rppt@kernel.org
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

 arch/arm64/mm/init.c             |    2 +-
 arch/ia64/mm/contig.c            |    2 +-
 arch/ia64/mm/discontig.c         |    2 +-
 arch/microblaze/mm/init.c        |    2 +-
 arch/mips/loongson64/numa.c      |    2 +-
 arch/mips/mm/init.c              |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    2 +-
 arch/powerpc/mm/mem.c            |    2 +-
 arch/riscv/mm/init.c             |    2 +-
 arch/s390/mm/init.c              |    2 +-
 arch/sh/mm/init.c                |    2 +-
 arch/sparc/mm/init_64.c          |    2 +-
 arch/x86/mm/init.c               |    2 +-
 include/linux/mm.h               |    7 +++----
 mm/page_alloc.c                  |   10 ++--------
 15 files changed, 18 insertions(+), 25 deletions(-)

--- a/arch/arm64/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/arm64/mm/init.c
@@ -206,7 +206,7 @@ static void __init zone_sizes_init(unsig
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max;
 
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 #else
--- a/arch/ia64/mm/contig.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/ia64/mm/contig.c
@@ -210,6 +210,6 @@ paging_init (void)
 		printk("Virtual mem_map starts at 0x%p\n", mem_map);
 	}
 #endif /* !CONFIG_VIRTUAL_MEM_MAP */
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
--- a/arch/ia64/mm/discontig.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/ia64/mm/discontig.c
@@ -627,7 +627,7 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = max_dma;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
--- a/arch/microblaze/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/microblaze/mm/init.c
@@ -112,7 +112,7 @@ static void __init paging_init(void)
 #endif
 
 	/* We don't have holes in memory map */
-	free_area_init_nodes(zones_size);
+	free_area_init(zones_size);
 }
 
 void __init setup_memory(void)
--- a/arch/mips/loongson64/numa.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/mips/loongson64/numa.c
@@ -247,7 +247,7 @@ void __init paging_init(void)
 	zones_size[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
 	zones_size[ZONE_NORMAL] = max_low_pfn;
-	free_area_init_nodes(zones_size);
+	free_area_init(zones_size);
 }
 
 void __init mem_init(void)
--- a/arch/mips/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/mips/mm/init.c
@@ -418,7 +418,7 @@ void __init paging_init(void)
 	}
 #endif
 
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 #ifdef CONFIG_64BIT
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -419,7 +419,7 @@ void __init paging_init(void)
 
 	pagetable_init();
 	zones_size[ZONE_NORMAL] = max_low_pfn;
-	free_area_init_nodes(zones_size);
+	free_area_init(zones_size);
 }
 
 void __init mem_init(void)
--- a/arch/powerpc/mm/mem.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/powerpc/mm/mem.c
@@ -271,7 +271,7 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
 #endif
 
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 
 	mark_nonram_nosave();
 }
--- a/arch/riscv/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/riscv/mm/init.c
@@ -39,7 +39,7 @@ static void __init zone_sizes_init(void)
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 static void setup_zero_page(void)
--- a/arch/s390/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/s390/mm/init.c
@@ -122,7 +122,7 @@ void __init paging_init(void)
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 void mark_rodata_ro(void)
--- a/arch/sh/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/sh/mm/init.c
@@ -334,7 +334,7 @@ void __init paging_init(void)
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 unsigned int mem_init_done = 0;
--- a/arch/sparc/mm/init_64.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/sparc/mm/init_64.c
@@ -2488,7 +2488,7 @@ void __init paging_init(void)
 
 		max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
-		free_area_init_nodes(max_zone_pfns);
+		free_area_init(max_zone_pfns);
 	}
 
 	printk("Booting Linux...\n");
--- a/arch/x86/mm/init.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/arch/x86/mm/init.c
@@ -949,7 +949,7 @@ void __init zone_sizes_init(void)
 	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
 #endif
 
-	free_area_init_nodes(max_zone_pfns);
+	free_area_init(max_zone_pfns);
 }
 
 __visible DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = {
--- a/include/linux/mm.h~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/include/linux/mm.h
@@ -2272,7 +2272,6 @@ static inline spinlock_t *pud_lock(struc
 }
 
 extern void __init pagecache_init(void);
-extern void free_area_init(unsigned long * max_zone_pfn);
 extern void __init free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
 extern void free_initmem(void);
@@ -2353,21 +2352,21 @@ static inline unsigned long get_num_phys
  *
  * An architecture is expected to register range of page frames backed by
  * physical memory with memblock_add[_node]() before calling
- * free_area_init_nodes() passing in the PFN each zone ends at. At a basic
+ * free_area_init() passing in the PFN each zone ends at. At a basic
  * usage, an architecture is expected to do something like
  *
  * unsigned long max_zone_pfns[MAX_NR_ZONES] = {max_dma, max_normal_pfn,
  * 							 max_highmem_pfn};
  * for_each_valid_physical_page_range()
  * 	memblock_add_node(base, size, nid)
- * free_area_init_nodes(max_zone_pfns);
+ * free_area_init(max_zone_pfns);
  *
  * free_bootmem_with_active_regions() calls free_bootmem_node() for each
  * registered physical page range.  Similarly
  * sparse_memory_present_with_active_regions() calls memory_present() for
  * each range when SPARSEMEM is enabled.
  */
-extern void free_area_init_nodes(unsigned long *max_zone_pfn);
+void free_area_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
--- a/mm/page_alloc.c~mm-use-free_area_init-instead-of-free_area_init_nodes
+++ a/mm/page_alloc.c
@@ -7428,7 +7428,7 @@ static void check_for_memory(pg_data_t *
 }
 
 /**
- * free_area_init_nodes - Initialise all pg_data_t and zone data
+ * free_area_init - Initialise all pg_data_t and zone data
  * @max_zone_pfn: an array of max PFNs for each zone
  *
  * This will call free_area_init_node() for each active node in the system.
@@ -7440,7 +7440,7 @@ static void check_for_memory(pg_data_t *
  * starts where the previous one ended. For example, ZONE_DMA32 starts
  * at arch_max_dma_pfn.
  */
-void __init free_area_init_nodes(unsigned long *max_zone_pfn)
+void __init free_area_init(unsigned long *max_zone_pfn)
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
@@ -7700,12 +7700,6 @@ void __init set_dma_reserve(unsigned lon
 	dma_reserve = new_dma_reserve;
 }
 
-void __init free_area_init(unsigned long *max_zone_pfn)
-{
-	init_unavailable_mem();
-	free_area_init_nodes(max_zone_pfn);
-}
