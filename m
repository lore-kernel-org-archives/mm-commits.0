From: akpm@linux-foundation.org
Subject: + introduce-flags-for-reserve_bootmem.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:02:34 -0700
Message-ID: <200710250402.l9P42YIf030797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199AbXJYECv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, linux-arch@vger.kernel.org, vgoyal@in.ibm.com


The patch titled
     Introduce flags for reserve_bootmem()
has been added to the -mm tree.  Its filename is
     introduce-flags-for-reserve_bootmem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce flags for reserve_bootmem()
From: Bernhard Walle <bwalle@suse.de>

This patchset adds a flags variable to reserve_bootmem() and uses the
BOOTMEM_EXCLUSIVE flag in crashkernel reservation code to detect collisions
between crashkernel area and already used memory.


This patch:

Change the reserve_bootmem() function to accept a new flag BOOTMEM_EXCLUSIVE. 
If that flag is set, the function returns with -EBUSY if the memory already
has been reserved in the past.  This is to avoid conflicts.

Because that code runs before SMP initialisation, there's no race condition
inside reserve_bootmem_core().

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: <linux-arch@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_irongate.c |    3 ++-
 arch/alpha/kernel/setup.c         |    5 +++--
 arch/alpha/mm/numa.c              |    5 +++--
 arch/arm/mm/init.c                |    4 ++--
 arch/arm/mm/mmu.c                 |   17 +++++++++++------
 arch/arm/mm/nommu.c               |    9 ++++++---
 arch/arm/plat-omap/fb.c           |    2 +-
 arch/avr32/kernel/setup.c         |    6 ++++--
 arch/blackfin/kernel/setup.c      |    2 +-
 arch/cris/kernel/setup.c          |    2 +-
 arch/frv/kernel/setup.c           |   16 ++++++++++------
 arch/h8300/kernel/setup.c         |    2 +-
 arch/ia64/mm/contig.c             |    2 +-
 arch/ia64/mm/discontig.c          |    4 ++--
 arch/m32r/kernel/setup.c          |   11 +++++++----
 arch/m32r/mm/discontig.c          |    5 +++--
 arch/m68k/atari/stram.c           |    2 +-
 arch/m68k/kernel/setup.c          |    3 ++-
 arch/m68knommu/kernel/setup.c     |    2 +-
 arch/mips/kernel/setup.c          |    4 ++--
 arch/mips/sgi-ip27/ip27-memory.c  |    3 ++-
 arch/parisc/mm/init.c             |   14 +++++++++-----
 arch/powerpc/mm/mem.c             |    3 ++-
 arch/powerpc/mm/numa.c            |    2 +-
 arch/s390/kernel/setup.c          |   11 +++++++----
 arch/sh/kernel/setup.c            |   10 ++++++----
 arch/sh/mm/numa.c                 |    4 ++--
 arch/sh64/kernel/setup.c          |    7 +++++--
 arch/sparc/mm/init.c              |    6 +++---
 arch/sparc64/mm/init.c            |    8 ++++----
 arch/v850/kernel/anna.c           |    3 ++-
 arch/v850/kernel/as85ep1.c        |    3 ++-
 arch/v850/kernel/rte_ma1_cb.c     |    6 ++++--
 arch/v850/kernel/setup.c          |   12 ++++++++----
 arch/x86/kernel/mpparse_32.c      |    6 ++++--
 arch/x86/kernel/setup_32.c        |   15 ++++++++-------
 arch/x86/kernel/setup_64.c        |    5 +++--
 arch/x86/mm/discontig_32.c        |    3 ++-
 arch/x86/mm/init_64.c             |    6 +++---
 arch/x86/mm/numa_64.c             |    6 ++++--
 arch/x86/mm/srat_64.c             |    3 ++-
 include/asm-x86/mmzone_32.h       |    4 ++--
 include/linux/bootmem.h           |   17 +++++++++++++++--
 mm/bootmem.c                      |   27 +++++++++++++++++++++------
 44 files changed, 185 insertions(+), 105 deletions(-)

diff -puN arch/alpha/kernel/core_irongate.c~introduce-flags-for-reserve_bootmem arch/alpha/kernel/core_irongate.c
--- a/arch/alpha/kernel/core_irongate.c~introduce-flags-for-reserve_bootmem
+++ a/arch/alpha/kernel/core_irongate.c
@@ -241,7 +241,8 @@ albacore_init_arch(void)
 				       size / 1024);
 		}
 #endif
-		reserve_bootmem_node(NODE_DATA(0), pci_mem, memtop - pci_mem);
+		reserve_bootmem_node(NODE_DATA(0), pci_mem, memtop -
+				pci_mem, BOOTMEM_DEFAULT);
 		printk("irongate_init_arch: temporarily reserving "
 			"region %08lx-%08lx for PCI\n", pci_mem, memtop - 1);
 	}
diff -puN arch/alpha/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/alpha/kernel/setup.c
@@ -429,7 +429,8 @@ setup_memory(void *kernel_end)
 	}
 
 	/* Reserve the bootmap memory.  */
-	reserve_bootmem(PFN_PHYS(bootmap_start), bootmap_size);
+	reserve_bootmem(PFN_PHYS(bootmap_start), bootmap_size,
+			BOOTMEM_DEFAULT);
 	printk("reserving pages %ld:%ld\n", bootmap_start, bootmap_start+PFN_UP(bootmap_size));
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -447,7 +448,7 @@ setup_memory(void *kernel_end)
 				       phys_to_virt(PFN_PHYS(max_low_pfn)));
 		} else {
 			reserve_bootmem(virt_to_phys((void *)initrd_start),
-					INITRD_SIZE);
+					INITRD_SIZE, BOOTMEM_DEFAULT);
 		}
 	}
 #endif /* CONFIG_BLK_DEV_INITRD */
diff -puN arch/alpha/mm/numa.c~introduce-flags-for-reserve_bootmem arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~introduce-flags-for-reserve_bootmem
+++ a/arch/alpha/mm/numa.c
@@ -242,7 +242,8 @@ setup_memory_node(int nid, void *kernel_
 	}
 
 	/* Reserve the bootmap memory.  */
-	reserve_bootmem_node(NODE_DATA(nid), PFN_PHYS(bootmap_start), bootmap_size);
+	reserve_bootmem_node(NODE_DATA(nid), PFN_PHYS(bootmap_start),
+			bootmap_size, BOOTMEM_DEFAULT);
 	printk(" reserving pages %ld:%ld\n", bootmap_start, bootmap_start+PFN_UP(bootmap_size));
 
 	node_set_online(nid);
@@ -281,7 +282,7 @@ setup_memory(void *kernel_end)
 			nid = kvaddr_to_nid(initrd_start);
 			reserve_bootmem_node(NODE_DATA(nid),
 					     virt_to_phys((void *)initrd_start),
-					     INITRD_SIZE);
+					     INITRD_SIZE, BOOTMEM_DEFAULT);
 		}
 	}
 #endif /* CONFIG_BLK_DEV_INITRD */
diff -puN arch/arm/mm/init.c~introduce-flags-for-reserve_bootmem arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~introduce-flags-for-reserve_bootmem
+++ a/arch/arm/mm/init.c
@@ -239,7 +239,7 @@ bootmem_init_node(int node, int initrd_n
 	 * Reserve the bootmem bitmap for this node.
 	 */
 	reserve_bootmem_node(pgdat, boot_pfn << PAGE_SHIFT,
-			     boot_pages << PAGE_SHIFT);
+			     boot_pages << PAGE_SHIFT, BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/*
@@ -247,7 +247,7 @@ bootmem_init_node(int node, int initrd_n
 	 */
 	if (node == initrd_node) {
 		reserve_bootmem_node(pgdat, phys_initrd_start,
-				     phys_initrd_size);
+				     phys_initrd_size, BOOTMEM_DEFAULT);
 		initrd_start = __phys_to_virt(phys_initrd_start);
 		initrd_end = initrd_start + phys_initrd_size;
 	}
diff -puN arch/arm/mm/mmu.c~introduce-flags-for-reserve_bootmem arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~introduce-flags-for-reserve_bootmem
+++ a/arch/arm/mm/mmu.c
@@ -605,9 +605,11 @@ void __init reserve_node_zero(pg_data_t 
 	 * Note that this can only be in node 0.
 	 */
 #ifdef CONFIG_XIP_KERNEL
-	reserve_bootmem_node(pgdat, __pa(&__data_start), &_end - &__data_start);
+	reserve_bootmem_node(pgdat, __pa(&__data_start), &_end - &__data_start,
+			BOOTMEM_DEFAULT);
 #else
-	reserve_bootmem_node(pgdat, __pa(&_stext), &_end - &_stext);
+	reserve_bootmem_node(pgdat, __pa(&_stext), &_end - &_stext,
+			BOOTMEM_DEFAULT);
 #endif
 
 	/*
@@ -615,7 +617,7 @@ void __init reserve_node_zero(pg_data_t 
 	 * and can only be in node 0.
 	 */
 	reserve_bootmem_node(pgdat, __pa(swapper_pg_dir),
-			     PTRS_PER_PGD * sizeof(pgd_t));
+			     PTRS_PER_PGD * sizeof(pgd_t), BOOTMEM_DEFAULT);
 
 	/*
 	 * Hmm... This should go elsewhere, but we really really need to
@@ -638,8 +640,10 @@ void __init reserve_node_zero(pg_data_t 
 	/* H1940 and RX3715 need to reserve this for suspend */
 
 	if (machine_is_h1940() || machine_is_rx3715()) {
-		reserve_bootmem_node(pgdat, 0x30003000, 0x1000);
-		reserve_bootmem_node(pgdat, 0x30081000, 0x1000);
+		reserve_bootmem_node(pgdat, 0x30003000, 0x1000,
+				BOOTMEM_DEFAULT);
+		reserve_bootmem_node(pgdat, 0x30081000, 0x1000,
+				BOOTMEM_DEFAULT);
 	}
 
 #ifdef CONFIG_SA1111
@@ -650,7 +654,8 @@ void __init reserve_node_zero(pg_data_t 
 	res_size = __pa(swapper_pg_dir) - PHYS_OFFSET;
 #endif
 	if (res_size)
-		reserve_bootmem_node(pgdat, PHYS_OFFSET, res_size);
+		reserve_bootmem_node(pgdat, PHYS_OFFSET, res_size,
+				BOOTMEM_DEFAULT);
 }
 
 /*
diff -puN arch/arm/mm/nommu.c~introduce-flags-for-reserve_bootmem arch/arm/mm/nommu.c
--- a/arch/arm/mm/nommu.c~introduce-flags-for-reserve_bootmem
+++ a/arch/arm/mm/nommu.c
@@ -27,9 +27,11 @@ void __init reserve_node_zero(pg_data_t 
 	 * Note that this can only be in node 0.
 	 */
 #ifdef CONFIG_XIP_KERNEL
-	reserve_bootmem_node(pgdat, __pa(&__data_start), &_end - &__data_start);
+	reserve_bootmem_node(pgdat, __pa(&__data_start), &_end - &__data_start,
+			BOOTMEM_DEFAULT);
 #else
-	reserve_bootmem_node(pgdat, __pa(&_stext), &_end - &_stext);
+	reserve_bootmem_node(pgdat, __pa(&_stext), &_end - &_stext,
+			BOOTMEM_DEFAULT);
 #endif
 
 	/*
@@ -37,7 +39,8 @@ void __init reserve_node_zero(pg_data_t 
 	 * some architectures which the DRAM is the exception vector to trap,
 	 * alloc_page breaks with error, although it is not NULL, but "0."
 	 */
-	reserve_bootmem_node(pgdat, CONFIG_VECTORS_BASE, PAGE_SIZE);
+	reserve_bootmem_node(pgdat, CONFIG_VECTORS_BASE, PAGE_SIZE,
+			BOOTMEM_DEFAULT);
 }
 
 /*
diff -puN arch/arm/plat-omap/fb.c~introduce-flags-for-reserve_bootmem arch/arm/plat-omap/fb.c
--- a/arch/arm/plat-omap/fb.c~introduce-flags-for-reserve_bootmem
+++ a/arch/arm/plat-omap/fb.c
@@ -207,7 +207,7 @@ void omapfb_reserve_sdram(void)
 			return;
 		}
 		if (rg.paddr)
-			reserve_bootmem(rg.paddr, rg.size);
+			reserve_bootmem(rg.paddr, rg.size, BOOTMEM_DEFAULT);
 		reserved += rg.size;
 		omapfb_config.mem_desc.region[i] = rg;
 		configured_regions++;
diff -puN arch/avr32/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/avr32/kernel/setup.c
@@ -489,7 +489,8 @@ static void __init setup_bootmem(void)
 		/* Reserve space for the bootmem bitmap... */
 		reserve_bootmem_node(NODE_DATA(node),
 				     PFN_PHYS(bootmap_pfn),
-				     bootmap_size);
+				     bootmap_size,
+				     BOOTMEM_DEFAULT);
 
 		/* ...and any other reserved regions. */
 		for (res = reserved; res; res = res->sibling) {
@@ -505,7 +506,8 @@ static void __init setup_bootmem(void)
 			    && res->end < PFN_PHYS(max_pfn))
 				reserve_bootmem_node(
 					NODE_DATA(node), res->start,
-					res->end - res->start + 1);
+					res->end - res->start + 1,
+					BOOTMEM_DEFAULT);
 		}
 
 		node_set_online(node);
diff -puN arch/blackfin/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/blackfin/kernel/setup.c
@@ -387,7 +387,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	free_bootmem(memory_start, memory_end - memory_start);
 
-	reserve_bootmem(memory_start, bootmap_size);
+	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
 	/*
 	 * get kmalloc into gear
 	 */
diff -puN arch/cris/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/cris/kernel/setup.c
--- a/arch/cris/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/cris/kernel/setup.c
@@ -137,7 +137,7 @@ setup_arch(char **cmdline_p)
 	 * Arguments are start, size
          */
 
-        reserve_bootmem(PFN_PHYS(start_pfn), bootmap_size);
+	reserve_bootmem(PFN_PHYS(start_pfn), bootmap_size, BOOTMEM_DEFAULT);
 
 	/* paging_init() sets up the MMU and marks all pages as reserved */
 
diff -puN arch/frv/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/frv/kernel/setup.c
@@ -925,13 +925,15 @@ static void __init setup_linux_memory(vo
 #endif
 
 	/* take back the memory occupied by the kernel image and the bootmem alloc map */
-	reserve_bootmem(kstart, kend - kstart + bootmap_size);
+	reserve_bootmem(kstart, kend - kstart + bootmap_size,
+			BOOTMEM_DEFAULT);
 
 	/* reserve the memory occupied by the initial ramdisk */
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (low_top_pfn << PAGE_SHIFT)) {
-			reserve_bootmem(INITRD_START, INITRD_SIZE);
+			reserve_bootmem(INITRD_START, INITRD_SIZE,
+					BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 		}
@@ -986,9 +988,10 @@ static void __init setup_uclinux_memory(
 
 	/* now take back the bits the core kernel is occupying */
 #ifndef CONFIG_PROTECT_KERNEL
-	reserve_bootmem(kend, bootmap_size);
+	reserve_bootmem(kend, bootmap_size, BOOTMEM_DEFAULT);
 	reserve_bootmem((unsigned long) &__kernel_image_start,
-			kend - (unsigned long) &__kernel_image_start);
+			kend - (unsigned long) &__kernel_image_start,
+			BOOTMEM_DEFAULT);
 
 #else
 	dampr = __get_DAMPR(0);
@@ -996,14 +999,15 @@ static void __init setup_uclinux_memory(
 	dampr = (dampr >> 4) + 17;
 	dampr = 1 << dampr;
 
-	reserve_bootmem(__get_DAMPR(0) & xAMPRx_PPFN, dampr);
+	reserve_bootmem(__get_DAMPR(0) & xAMPRx_PPFN, dampr, BOOTMEM_DEFAULT);
 #endif
 
 	/* reserve some memory to do uncached DMA through if requested */
 #ifdef CONFIG_RESERVE_DMA_COHERENT
 	if (dma_coherent_mem_start)
 		reserve_bootmem(dma_coherent_mem_start,
-				dma_coherent_mem_end - dma_coherent_mem_start);
+				dma_coherent_mem_end - dma_coherent_mem_start,
+				BOOTMEM_DEFAULT);
 #endif
 
 } /* end setup_uclinux_memory() */
diff -puN arch/h8300/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/h8300/kernel/setup.c
@@ -173,7 +173,7 @@ void __init setup_arch(char **cmdline_p)
 	 * the bootmem bitmap so we then reserve it after freeing it :-)
 	 */
 	free_bootmem(memory_start, memory_end - memory_start);
-	reserve_bootmem(memory_start, bootmap_size);
+	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
 	/*
 	 * get kmalloc into gear
 	 */
diff -puN arch/ia64/mm/contig.c~introduce-flags-for-reserve_bootmem arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~introduce-flags-for-reserve_bootmem
+++ a/arch/ia64/mm/contig.c
@@ -178,7 +178,7 @@ find_memory (void)
 
 	/* Free all available memory, then mark bootmem-map as being in use. */
 	efi_memmap_walk(filter_rsvd_memory, free_bootmem);
-	reserve_bootmem(bootmap_start, bootmap_size);
+	reserve_bootmem(bootmap_start, bootmap_size, BOOTMEM_DEFAULT);
 
 	find_initrd();
 
diff -puN arch/ia64/mm/discontig.c~introduce-flags-for-reserve_bootmem arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~introduce-flags-for-reserve_bootmem
+++ a/arch/ia64/mm/discontig.c
@@ -299,12 +299,12 @@ static void __init reserve_pernode_space
 		pages = bdp->node_low_pfn - (bdp->node_boot_start>>PAGE_SHIFT);
 		size = bootmem_bootmap_pages(pages) << PAGE_SHIFT;
 		base = __pa(bdp->node_bootmem_map);
-		reserve_bootmem_node(pdp, base, size);
+		reserve_bootmem_node(pdp, base, size, BOOTMEM_DEFAULT);
 
 		/* Now the per-node space */
 		size = mem_data[node].pernode_size;
 		base = __pa(mem_data[node].pernode_addr);
-		reserve_bootmem_node(pdp, base, size);
+		reserve_bootmem_node(pdp, base, size, BOOTMEM_DEFAULT);
 	}
 }
 
diff -puN arch/m32r/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/m32r/kernel/setup.c
@@ -177,25 +177,28 @@ static unsigned long __init setup_memory
 	 */
 	reserve_bootmem(CONFIG_MEMORY_START + PAGE_SIZE,
 		(PFN_PHYS(start_pfn) + bootmap_size + PAGE_SIZE - 1)
-		- CONFIG_MEMORY_START);
+		- CONFIG_MEMORY_START,
+		BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
 	 * enabling clean reboots, SMP operation, laptop functions.
 	 */
-	reserve_bootmem(CONFIG_MEMORY_START, PAGE_SIZE);
+	reserve_bootmem(CONFIG_MEMORY_START, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve memory hole
 	 */
 #ifdef CONFIG_MEMHOLE
-	reserve_bootmem(CONFIG_MEMHOLE_START, CONFIG_MEMHOLE_SIZE);
+	reserve_bootmem(CONFIG_MEMHOLE_START, CONFIG_MEMHOLE_SIZE,
+			BOOTMEM_DEFAULT);
 #endif
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
-			reserve_bootmem(INITRD_START, INITRD_SIZE);
+			reserve_bootmem(INITRD_START, INITRD_SIZE,
+					BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 			printk("initrd:start[%08lx],size[%08lx]\n",
diff -puN arch/m32r/mm/discontig.c~introduce-flags-for-reserve_bootmem arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~introduce-flags-for-reserve_bootmem
+++ a/arch/m32r/mm/discontig.c
@@ -91,7 +91,8 @@ unsigned long __init setup_memory(void)
 			PFN_PHYS(mp->pages));
 
 		reserve_bootmem_node(NODE_DATA(nid), PFN_PHYS(mp->start_pfn),
-			PFN_PHYS(mp->free_pfn - mp->start_pfn) + bootmap_size);
+			PFN_PHYS(mp->free_pfn - mp->start_pfn) + bootmap_size,
+			BOOTMEM_DEFAULT);
 
 		if (max_low_pfn < max_pfn)
 			max_low_pfn = max_pfn;
@@ -104,7 +105,7 @@ unsigned long __init setup_memory(void)
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= PFN_PHYS(max_low_pfn)) {
 			reserve_bootmem_node(NODE_DATA(0), INITRD_START,
-				INITRD_SIZE);
+				INITRD_SIZE, BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 			printk("initrd:start[%08lx],size[%08lx]\n",
diff -puN arch/m68k/atari/stram.c~introduce-flags-for-reserve_bootmem arch/m68k/atari/stram.c
--- a/arch/m68k/atari/stram.c~introduce-flags-for-reserve_bootmem
+++ a/arch/m68k/atari/stram.c
@@ -153,7 +153,7 @@ void __init atari_stram_reserve_pages(vo
 	/* always reserve first page of ST-RAM, the first 2 kB are
 	 * supervisor-only! */
 	if (!kernel_in_stram)
-		reserve_bootmem (0, PAGE_SIZE);
+		reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 }
 
diff -puN arch/m68k/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/m68k/kernel/setup.c
--- a/arch/m68k/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/m68k/kernel/setup.c
@@ -323,7 +323,8 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (m68k_ramdisk.size) {
 		reserve_bootmem_node(__virt_to_node(phys_to_virt(m68k_ramdisk.addr)),
-				     m68k_ramdisk.addr, m68k_ramdisk.size);
+				     m68k_ramdisk.addr, m68k_ramdisk.size,
+				     BOOTMEM_DEFAULT);
 		initrd_start = (unsigned long)phys_to_virt(m68k_ramdisk.addr);
 		initrd_end = initrd_start + m68k_ramdisk.size;
 		printk("initrd: %08lx - %08lx\n", initrd_start, initrd_end);
diff -puN arch/m68knommu/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/m68knommu/kernel/setup.c
@@ -206,7 +206,7 @@ void __init setup_arch(char **cmdline_p)
 	 * the bootmem bitmap so we then reserve it after freeing it :-)
 	 */
 	free_bootmem(memory_start, memory_end - memory_start);
-	reserve_bootmem(memory_start, bootmap_size);
+	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
 
 	/*
 	 * Get kmalloc into gear.
diff -puN arch/mips/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/mips/kernel/setup.c
--- a/arch/mips/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/mips/kernel/setup.c
@@ -230,7 +230,7 @@ static void __init finalize_initrd(void)
 		goto disable;
 	}
 
-	reserve_bootmem(__pa(initrd_start), size);
+	reserve_bootmem(__pa(initrd_start), size, BOOTMEM_DEFAULT);
 	initrd_below_start_ok = 1;
 
 	printk(KERN_INFO "Initial ramdisk at: 0x%lx (%lu bytes)\n",
@@ -383,7 +383,7 @@ static void __init bootmem_init(void)
 	/*
 	 * Reserve the bootmap memory.
 	 */
-	reserve_bootmem(PFN_PHYS(mapstart), bootmap_size);
+	reserve_bootmem(PFN_PHYS(mapstart), bootmap_size, BOOTMEM_DEFAULT);
 
 	/*
 	 * Reserve initrd memory if needed.
diff -puN arch/mips/sgi-ip27/ip27-memory.c~introduce-flags-for-reserve_bootmem arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~introduce-flags-for-reserve_bootmem
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -465,7 +465,8 @@ static void __init node_mem_init(cnodeid
 	free_bootmem_node(NODE_DATA(node), slot_firstpfn << PAGE_SHIFT,
 			(slot_lastpfn - slot_firstpfn) << PAGE_SHIFT);
 	reserve_bootmem_node(NODE_DATA(node), slot_firstpfn << PAGE_SHIFT,
-		((slot_freepfn - slot_firstpfn) << PAGE_SHIFT) + bootmap_size);
+		((slot_freepfn - slot_firstpfn) << PAGE_SHIFT) + bootmap_size,
+		BOOTMEM_DEFAULT);
 }
 
 /*
diff -puN arch/parisc/mm/init.c~introduce-flags-for-reserve_bootmem arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~introduce-flags-for-reserve_bootmem
+++ a/arch/parisc/mm/init.c
@@ -315,11 +315,13 @@ static void __init setup_bootmem(void)
 #define PDC_CONSOLE_IO_IODC_SIZE 32768
 
 	reserve_bootmem_node(NODE_DATA(0), 0UL,
-			(unsigned long)(PAGE0->mem_free + PDC_CONSOLE_IO_IODC_SIZE));
+			(unsigned long)(PAGE0->mem_free +
+				PDC_CONSOLE_IO_IODC_SIZE), BOOTMEM_DEFAULT);
 	reserve_bootmem_node(NODE_DATA(0), __pa((unsigned long)_text),
-			(unsigned long)(_end - _text));
+			(unsigned long)(_end - _text), BOOTMEM_DEFAULT);
 	reserve_bootmem_node(NODE_DATA(0), (bootmap_start_pfn << PAGE_SHIFT),
-			((bootmap_pfn - bootmap_start_pfn) << PAGE_SHIFT));
+			((bootmap_pfn - bootmap_start_pfn) << PAGE_SHIFT),
+			BOOTMEM_DEFAULT);
 
 #ifndef CONFIG_DISCONTIGMEM
 
@@ -328,7 +330,8 @@ static void __init setup_bootmem(void)
 	for (i = 0; i < npmem_holes; i++) {
 		reserve_bootmem_node(NODE_DATA(0),
 				(pmem_holes[i].start_pfn << PAGE_SHIFT),
-				(pmem_holes[i].pages << PAGE_SHIFT));
+				(pmem_holes[i].pages << PAGE_SHIFT),
+				BOOTMEM_DEFAULT);
 	}
 #endif
 
@@ -346,7 +349,8 @@ static void __init setup_bootmem(void)
 			initrd_below_start_ok = 1;
 			printk(KERN_INFO "initrd: reserving %08lx-%08lx (mem_max %08lx)\n", __pa(initrd_start), __pa(initrd_start) + initrd_reserve, mem_max);
 
-			reserve_bootmem_node(NODE_DATA(0),__pa(initrd_start), initrd_reserve);
+			reserve_bootmem_node(NODE_DATA(0), __pa(initrd_start),
+					initrd_reserve, BOOTMEM_DEFAULT);
 		}
 	}
 #endif
diff -puN arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~introduce-flags-for-reserve_bootmem
+++ a/arch/powerpc/mm/mem.c
@@ -220,7 +220,8 @@ void __init do_init_bootmem(void)
 	/* reserve the sections we're already using */
 	for (i = 0; i < lmb.reserved.cnt; i++)
 		reserve_bootmem(lmb.reserved.region[i].base,
-				lmb_size_bytes(&lmb.reserved, i));
+				lmb_size_bytes(&lmb.reserved, i),
+				BOOTMEM_DEFAULT);
 
 	/* XXX need to clip this if using highmem? */
 	sparse_memory_present_with_active_regions(0);
diff -puN arch/powerpc/mm/numa.c~introduce-flags-for-reserve_bootmem arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~introduce-flags-for-reserve_bootmem
+++ a/arch/powerpc/mm/numa.c
@@ -675,7 +675,7 @@ void __init do_init_bootmem(void)
 				dbg("reserve_bootmem %lx %lx\n", physbase,
 				    size);
 				reserve_bootmem_node(NODE_DATA(nid), physbase,
-						     size);
+						     size, BOOTMEM_DEFAULT);
 			}
 		}
 
diff -puN arch/s390/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/s390/kernel/setup.c
@@ -725,21 +725,24 @@ setup_memory(void)
 	/*
 	 * Reserve memory used for lowcore/command line/kernel image.
 	 */
-	reserve_bootmem(0, (unsigned long)_ehead);
+	reserve_bootmem(0, (unsigned long)_ehead, BOOTMEM_DEFAULT);
 	reserve_bootmem((unsigned long)_stext,
-			PFN_PHYS(start_pfn) - (unsigned long)_stext);
+			PFN_PHYS(start_pfn) - (unsigned long)_stext,
+			BOOTMEM_DEFAULT);
 	/*
 	 * Reserve the bootmem bitmap itself as well. We do this in two
 	 * steps (first step was init_bootmem()) because this catches
 	 * the (very unlikely) case of us accidentally initializing the
 	 * bootmem allocator with an invalid RAM area.
 	 */
-	reserve_bootmem(start_pfn << PAGE_SHIFT, bootmap_size);
+	reserve_bootmem(start_pfn << PAGE_SHIFT, bootmap_size,
+			BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (INITRD_START && INITRD_SIZE) {
 		if (INITRD_START + INITRD_SIZE <= memory_end) {
-			reserve_bootmem(INITRD_START, INITRD_SIZE);
+			reserve_bootmem(INITRD_START, INITRD_SIZE,
+					BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START;
 			initrd_end = initrd_start + INITRD_SIZE;
 		} else {
diff -puN arch/sh64/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/sh64/kernel/setup.c
--- a/arch/sh64/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/sh64/kernel/setup.c
@@ -227,7 +227,8 @@ void __init setup_arch(char **cmdline_p)
 	 * Reserve all kernel sections + bootmem bitmap + a guard page.
 	 */
 	reserve_bootmem_node(NODE_DATA(0), PFN_PHYS(first_pfn),
-		        (PFN_PHYS(start_pfn) + bootmap_size + PAGE_SIZE) - PFN_PHYS(first_pfn));
+			(PFN_PHYS(start_pfn) + bootmap_size + PAGE_SIZE)
+			- PFN_PHYS(first_pfn), BOOTMEM_DEFAULT);
 
 	/*
 	 * Reserve platform dependent sections
@@ -237,7 +238,9 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (PFN_PHYS(last_pfn))) {
-		        reserve_bootmem_node(NODE_DATA(0), INITRD_START + __MEMORY_START, INITRD_SIZE);
+			reserve_bootmem_node(NODE_DATA(0), INITRD_START +
+					__MEMORY_START, INITRD_SIZE,
+					BOOTMEM_DEFAULT);
 
 			initrd_start = (long) INITRD_START + PAGE_OFFSET + __MEMORY_START;
 			initrd_end = initrd_start + INITRD_SIZE;
diff -puN arch/sh/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/sh/kernel/setup.c
@@ -148,7 +148,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(free_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
@@ -184,13 +185,14 @@ void __init setup_bootmem_allocator(unsi
 	 * an invalid RAM area.
 	 */
 	reserve_bootmem(__MEMORY_START+PAGE_SIZE,
-		(PFN_PHYS(free_pfn)+bootmap_size+PAGE_SIZE-1)-__MEMORY_START);
+		(PFN_PHYS(free_pfn)+bootmap_size+PAGE_SIZE-1)-__MEMORY_START,
+		BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
 	 * enabling clean reboots, SMP operation, laptop functions.
 	 */
-	reserve_bootmem(__MEMORY_START, PAGE_SIZE);
+	reserve_bootmem(__MEMORY_START, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 	sparse_memory_present_with_active_regions(0);
 
@@ -207,7 +209,7 @@ void __init setup_bootmem_allocator(unsi
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
 			reserve_bootmem(INITRD_START + __MEMORY_START,
-					INITRD_SIZE);
+					INITRD_SIZE, BOOTMEM_DEFAULT);
 			initrd_start = INITRD_START + PAGE_OFFSET +
 					__MEMORY_START;
 			initrd_end = initrd_start + INITRD_SIZE;
diff -puN arch/sh/mm/numa.c~introduce-flags-for-reserve_bootmem arch/sh/mm/numa.c
--- a/arch/sh/mm/numa.c~introduce-flags-for-reserve_bootmem
+++ a/arch/sh/mm/numa.c
@@ -80,9 +80,9 @@ void __init setup_bootmem_node(int nid, 
 
 	/* Reserve the pgdat and bootmap space with the bootmem allocator */
 	reserve_bootmem_node(NODE_DATA(nid), start_pfn << PAGE_SHIFT,
-			     sizeof(struct pglist_data));
+			     sizeof(struct pglist_data), BOOTMEM_DEFAULT);
 	reserve_bootmem_node(NODE_DATA(nid), free_pfn << PAGE_SHIFT,
-			     bootmap_pages << PAGE_SHIFT);
+			     bootmap_pages << PAGE_SHIFT, BOOTMEM_DEFAULT);
 
 	/* It's up */
 	node_set_online(nid);
diff -puN arch/sparc64/mm/init.c~introduce-flags-for-reserve_bootmem arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~introduce-flags-for-reserve_bootmem
+++ a/arch/sparc64/mm/init.c
@@ -997,7 +997,7 @@ static unsigned long __init bootmem_init
 		prom_printf("reserve_bootmem(initrd): base[%llx] size[%lx]\n",
 			initrd_start, initrd_end);
 #endif
-		reserve_bootmem(initrd_start, size);
+		reserve_bootmem(initrd_start, size, BOOTMEM_DEFAULT);
 
 		initrd_start += PAGE_OFFSET;
 		initrd_end += PAGE_OFFSET;
@@ -1007,7 +1007,7 @@ static unsigned long __init bootmem_init
 #ifdef CONFIG_DEBUG_BOOTMEM
 	prom_printf("reserve_bootmem(kernel): base[%lx] size[%lx]\n", kern_base, kern_size);
 #endif
-	reserve_bootmem(kern_base, kern_size);
+	reserve_bootmem(kern_base, kern_size, BOOTMEM_DEFAULT);
 	*pages_avail -= PAGE_ALIGN(kern_size) >> PAGE_SHIFT;
 
 	/* Add back in the initmem pages. */
@@ -1024,7 +1024,7 @@ static unsigned long __init bootmem_init
 	prom_printf("reserve_bootmem(bootmap): base[%lx] size[%lx]\n",
 		    (bootmap_pfn << PAGE_SHIFT), size);
 #endif
-	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size);
+	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size, BOOTMEM_DEFAULT);
 
 	for (i = 0; i < pavail_ents; i++) {
 		unsigned long start_pfn, end_pfn;
@@ -1475,7 +1475,7 @@ static void __init taint_real_pages(void
 					goto do_next_page;
 				}
 			}
-			reserve_bootmem(old_start, PAGE_SIZE);
+			reserve_bootmem(old_start, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 		do_next_page:
 			old_start += PAGE_SIZE;
diff -puN arch/sparc/mm/init.c~introduce-flags-for-reserve_bootmem arch/sparc/mm/init.c
--- a/arch/sparc/mm/init.c~introduce-flags-for-reserve_bootmem
+++ a/arch/sparc/mm/init.c
@@ -259,7 +259,7 @@ unsigned long __init bootmem_init(unsign
 	if (initrd_start) {
 		/* Reserve the initrd image area. */
 		size = initrd_end - initrd_start;
-		reserve_bootmem(initrd_start, size);
+		reserve_bootmem(initrd_start, size, BOOTMEM_DEFAULT);
 		*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		initrd_start = (initrd_start - phys_base) + PAGE_OFFSET;
@@ -268,7 +268,7 @@ unsigned long __init bootmem_init(unsign
 #endif
 	/* Reserve the kernel text/data/bss. */
 	size = (start_pfn << PAGE_SHIFT) - phys_base;
-	reserve_bootmem(phys_base, size);
+	reserve_bootmem(phys_base, size, BOOTMEM_DEFAULT);
 	*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 	/* Reserve the bootmem map.   We do not account for it
@@ -276,7 +276,7 @@ unsigned long __init bootmem_init(unsign
 	 * in free_all_bootmem.
 	 */
 	size = bootmap_size;
-	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size);
+	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size, BOOTMEM_DEFAULT);
 	*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 	return max_pfn;
diff -puN arch/v850/kernel/anna.c~introduce-flags-for-reserve_bootmem arch/v850/kernel/anna.c
--- a/arch/v850/kernel/anna.c~introduce-flags-for-reserve_bootmem
+++ a/arch/v850/kernel/anna.c
@@ -85,7 +85,8 @@ void __init mach_reserve_bootmem ()
 	/* The space between SRAM and SDRAM is filled with duplicate
 	   images of SRAM.  Prevent the kernel from using them.  */
 	reserve_bootmem (SRAM_ADDR + SRAM_SIZE,
-			 SDRAM_ADDR - (SRAM_ADDR + SRAM_SIZE));
+			 SDRAM_ADDR - (SRAM_ADDR + SRAM_SIZE),
+			 BOOTMEM_DEFAULT);
 }
 
 void mach_gettimeofday (struct timespec *tv)
diff -puN arch/v850/kernel/as85ep1.c~introduce-flags-for-reserve_bootmem arch/v850/kernel/as85ep1.c
--- a/arch/v850/kernel/as85ep1.c~introduce-flags-for-reserve_bootmem
+++ a/arch/v850/kernel/as85ep1.c
@@ -116,7 +116,8 @@ void __init mach_reserve_bootmem ()
 	if (SDRAM_ADDR < RAM_END && SDRAM_ADDR > RAM_START)
 		/* We can't use the space between SRAM and SDRAM, so
 		   prevent the kernel from trying.  */
-		reserve_bootmem (SRAM_END, SDRAM_ADDR - SRAM_END);
+		reserve_bootmem(SRAM_END, SDRAM_ADDR - SRAM_END,
+				BOOTMEM_DEFAULT);
 }
 
 void mach_gettimeofday (struct timespec *tv)
diff -puN arch/v850/kernel/rte_ma1_cb.c~introduce-flags-for-reserve_bootmem arch/v850/kernel/rte_ma1_cb.c
--- a/arch/v850/kernel/rte_ma1_cb.c~introduce-flags-for-reserve_bootmem
+++ a/arch/v850/kernel/rte_ma1_cb.c
@@ -46,13 +46,15 @@ void __init mach_reserve_bootmem ()
 {
 #ifdef CONFIG_RTE_CB_MULTI
 	/* Prevent the kernel from touching the monitor's scratch RAM.  */
-	reserve_bootmem (MON_SCRATCH_ADDR, MON_SCRATCH_SIZE);
+	reserve_bootmem(MON_SCRATCH_ADDR, MON_SCRATCH_SIZE,
+			BOOTMEM_DEFAULT);
 #endif
 
 	/* The space between SRAM and SDRAM is filled with duplicate
 	   images of SRAM.  Prevent the kernel from using them.  */
 	reserve_bootmem (SRAM_ADDR + SRAM_SIZE,
-			 SDRAM_ADDR - (SRAM_ADDR + SRAM_SIZE));
+			 SDRAM_ADDR - (SRAM_ADDR + SRAM_SIZE),
+			 BOOTMEM_DEFAULT);
 }
 
 void mach_gettimeofday (struct timespec *tv)
diff -puN arch/v850/kernel/setup.c~introduce-flags-for-reserve_bootmem arch/v850/kernel/setup.c
--- a/arch/v850/kernel/setup.c~introduce-flags-for-reserve_bootmem
+++ a/arch/v850/kernel/setup.c
@@ -241,15 +241,18 @@ init_bootmem_alloc (unsigned long ram_st
 	if (kram_end > kram_start)
 		/* Reserve the RAM part of the kernel's address space, so it
 		   doesn't get allocated.  */
-		reserve_bootmem (kram_start, kram_end - kram_start);
+		reserve_bootmem(kram_start, kram_end - kram_start,
+				BOOTMEM_DEFAULT);
 	
 	if (intv_in_ram && !intv_in_kram)
 		/* Reserve the interrupt vector space.  */
-		reserve_bootmem (intv_start, intv_end - intv_start);
+		reserve_bootmem(intv_start, intv_end - intv_start,
+				BOOTMEM_DEFAULT);
 
 	if (bootmap >= ram_start && bootmap < ram_end)
 		/* Reserve the bootmap space.  */
-		reserve_bootmem (bootmap, bootmap_len);
+		reserve_bootmem(bootmap, bootmap_len,
+				BOOTMEM_DEFAULT);
 
 	/* Reserve the memory used by the root filesystem image if it's
 	   in RAM.  */
@@ -257,7 +260,8 @@ init_bootmem_alloc (unsigned long ram_st
 	    && (unsigned long)&_root_fs_image_start >= ram_start
 	    && (unsigned long)&_root_fs_image_start < ram_end)
 		reserve_bootmem ((unsigned long)&_root_fs_image_start,
-				 &_root_fs_image_end - &_root_fs_image_start);
+				 &_root_fs_image_end - &_root_fs_image_start,
+				 BOOTMEM_DEFAULT);
 
 	/* Let the platform-dependent code reserve some too.  */
 	if (mrb)
diff -puN arch/x86/kernel/mpparse_32.c~introduce-flags-for-reserve_bootmem arch/x86/kernel/mpparse_32.c
--- a/arch/x86/kernel/mpparse_32.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/kernel/mpparse_32.c
@@ -736,7 +736,8 @@ static int __init smp_scan_config (unsig
 			smp_found_config = 1;
 			printk(KERN_INFO "found SMP MP-table at %08lx\n",
 						virt_to_phys(mpf));
-			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
+			reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE,
+					BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr) {
 				/*
 				 * We cannot access to MPC table to compute
@@ -751,7 +752,8 @@ static int __init smp_scan_config (unsig
 				unsigned long end = max_low_pfn * PAGE_SIZE;
 				if (mpf->mpf_physptr + size > end)
 					size = end - mpf->mpf_physptr;
-				reserve_bootmem(mpf->mpf_physptr, size);
+				reserve_bootmem(mpf->mpf_physptr, size,
+						BOOTMEM_DEFAULT);
 			}
 
 			mpf_found = mpf;
diff -puN arch/x86/kernel/setup_32.c~introduce-flags-for-reserve_bootmem arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/kernel/setup_32.c
@@ -389,7 +389,7 @@ static void __init reserve_ebda_region(v
 	unsigned int addr;
 	addr = get_bios_ebda();
 	if (addr)
-		reserve_bootmem(addr, PAGE_SIZE);	
+		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -483,7 +483,7 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
@@ -511,13 +511,14 @@ void __init setup_bootmem_allocator(void
 	 * bootmem allocator with an invalid RAM area.
 	 */
 	reserve_bootmem(__pa_symbol(_text), (PFN_PHYS(min_low_pfn) +
-			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text));
+			 bootmap_size + PAGE_SIZE-1) - __pa_symbol(_text),
+			 BOOTMEM_DEFAULT);
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
 	 * enabling clean reboots, SMP operation, laptop functions.
 	 */
-	reserve_bootmem(0, PAGE_SIZE);
+	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
 
 	/* reserve EBDA region, it's a 4K region */
 	reserve_ebda_region();
@@ -527,7 +528,7 @@ void __init setup_bootmem_allocator(void
        unless you have no PS/2 mouse plugged in. */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 	    boot_cpu_data.x86 == 6)
-	     reserve_bootmem(0xa0000 - 4096, 4096);
+	     reserve_bootmem(0xa0000 - 4096, 4096, BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_SMP
 	/*
@@ -535,7 +536,7 @@ void __init setup_bootmem_allocator(void
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	reserve_bootmem(PAGE_SIZE, PAGE_SIZE);
+	reserve_bootmem(PAGE_SIZE, PAGE_SIZE, BOOTMEM_DEFAULT);
 #endif
 #ifdef CONFIG_ACPI_SLEEP
 	/*
@@ -558,7 +559,7 @@ void __init setup_bootmem_allocator(void
 		unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_lowmem) {
-			reserve_bootmem(ramdisk_image, ramdisk_size);
+			reserve_bootmem(ramdisk_image, ramdisk_size, BOOTMEM_DEFAULT);
 			initrd_start = ramdisk_image + PAGE_OFFSET;
 			initrd_end = initrd_start+ramdisk_size;
 		} else {
diff -puN arch/x86/kernel/setup_64.c~introduce-flags-for-reserve_bootmem arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/kernel/setup_64.c
@@ -170,7 +170,7 @@ contig_initmem_init(unsigned long start_
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
-	reserve_bootmem(bootmap, bootmap_size);
+	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 } 
 #endif
 
@@ -218,7 +218,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(free_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
diff -puN arch/x86/mm/discontig_32.c~introduce-flags-for-reserve_bootmem arch/x86/mm/discontig_32.c
--- a/arch/x86/mm/discontig_32.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/mm/discontig_32.c
@@ -345,7 +345,8 @@ unsigned long __init setup_memory(void)
 
 void __init numa_kva_reserve(void)
 {
-	reserve_bootmem(PFN_PHYS(kva_start_pfn),PFN_PHYS(kva_pages));
+	reserve_bootmem(PFN_PHYS(kva_start_pfn), PFN_PHYS(kva_pages),
+			BOOTMEM_DEFAULT);
 }
 
 void __init zone_sizes_init(void)
diff -puN arch/x86/mm/init_64.c~introduce-flags-for-reserve_bootmem arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/mm/init_64.c
@@ -650,9 +650,9 @@ void __init reserve_bootmem_generic(unsi
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
-  	reserve_bootmem_node(NODE_DATA(nid), phys, len);
-#else       		
-	reserve_bootmem(phys, len);    
+	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+#else
+	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #endif
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
diff -puN arch/x86/mm/numa_64.c~introduce-flags-for-reserve_bootmem arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/mm/numa_64.c
@@ -219,8 +219,10 @@ void __init setup_node_bootmem(int nodei
 
 	free_bootmem_with_active_regions(nodeid, end);
 
-	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size); 
-	reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start, bootmap_pages<<PAGE_SHIFT);
+	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size,
+			BOOTMEM_DEFAULT);
+	reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
+			bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
 #ifdef CONFIG_ACPI_NUMA
 	srat_reserve_add_area(nodeid);
 #endif
diff -puN arch/x86/mm/srat_64.c~introduce-flags-for-reserve_bootmem arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c~introduce-flags-for-reserve_bootmem
+++ a/arch/x86/mm/srat_64.c
@@ -535,7 +535,8 @@ void __init srat_reserve_add_area(int no
 		printk(KERN_INFO "SRAT: This will cost you %Lu MB of "
 				"pre-allocated memory.\n", (unsigned long long)total_mb);
 		reserve_bootmem_node(NODE_DATA(nodeid), nodes_add[nodeid].start,
-			       nodes_add[nodeid].end - nodes_add[nodeid].start);
+			       nodes_add[nodeid].end - nodes_add[nodeid].start,
+			       BOOTMEM_DEFAULT);
 	}
 }
 
diff -puN include/asm-x86/mmzone_32.h~introduce-flags-for-reserve_bootmem include/asm-x86/mmzone_32.h
--- a/include/asm-x86/mmzone_32.h~introduce-flags-for-reserve_bootmem
+++ a/include/asm-x86/mmzone_32.h
@@ -110,8 +110,8 @@ static inline int pfn_valid(int pfn)
 /*
  * Following are macros that are specific to this numa platform.
  */
-#define reserve_bootmem(addr, size) \
-	reserve_bootmem_node(NODE_DATA(0), (addr), (size))
+#define reserve_bootmem(addr, size, flags) \
+	reserve_bootmem_node(NODE_DATA(0), (addr), (size), (flags))
 #define alloc_bootmem(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
diff -puN include/linux/bootmem.h~introduce-flags-for-reserve_bootmem include/linux/bootmem.h
--- a/include/linux/bootmem.h~introduce-flags-for-reserve_bootmem
+++ a/include/linux/bootmem.h
@@ -61,8 +61,20 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long limit);
 extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
+/*
+ * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
+ * the architecture-specific code should honor this)
+ */
+#define BOOTMEM_DEFAULT		0
+#define BOOTMEM_EXCLUSIVE	(1<<0)
+
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-extern void reserve_bootmem(unsigned long addr, unsigned long size);
+/*
+ * If flags is 0, then the return value is always 0 (success). If
+ * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
+ * memory already was reserved.
+ */
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
@@ -85,7 +97,8 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long endpfn);
 extern void reserve_bootmem_node(pg_data_t *pgdat,
 				 unsigned long physaddr,
-				 unsigned long size);
+				 unsigned long size,
+				 int flags);
 extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
diff -puN mm/bootmem.c~introduce-flags-for-reserve_bootmem mm/bootmem.c
--- a/mm/bootmem.c~introduce-flags-for-reserve_bootmem
+++ a/mm/bootmem.c
@@ -111,11 +111,12 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static void __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-					unsigned long size)
+static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
+					unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
+	int ret;
 
 	/*
 	 * round up, partially reserved pages are considered
@@ -133,7 +134,20 @@ static void __init reserve_bootmem_core(
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
+			if (flags & BOOTMEM_EXCLUSIVE) {
+				ret = -EBUSY;
+				goto err;
+			}
 		}
+
+	return 0;
+
+err:
+	/* unreserve memory we accidentally reserved */
+	for (i--; i >= sidx; i--)
+		clear_bit(i, bdata->node_bootmem_map);
+
+	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -374,9 +388,9 @@ unsigned long __init init_bootmem_node(p
 }
 
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-				 unsigned long size)
+				 unsigned long size, int flags)
 {
-	reserve_bootmem_core(pgdat->bdata, physaddr, size);
+	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -398,9 +412,10 @@ unsigned long __init init_bootmem(unsign
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-void __init reserve_bootmem(unsigned long addr, unsigned long size)
+int __init reserve_bootmem(unsigned long addr, unsigned long size,
+			    int flags)
 {
-	reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
_

Patches currently in -mm which might be from bwalle@suse.de are

rename-_bss-to-__bss_start.patch
remove-extern-declarations-for-code-data-bss-resource.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
