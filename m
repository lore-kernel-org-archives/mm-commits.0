Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B578F37
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899732; cv=none; b=CIoCoZkfDFIHYOdbzeAOfpo6NmcLRbVzsy17glMiaELD/PpTeQ/1dJ5Z9Bzmyed6jN0sbUyVFPw0LFZsvQ4XKih6sSKEzqPwmAmPN0hB+cw0JCmn4msXwF+bfk6ezBwfpuU+tUyw7Nt502RdiUqopgSamKYgomrPu9w2mvB3cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899732; c=relaxed/simple;
	bh=kLyzwFAYyQ2MiOWDHgpFzBFZrYpoEmn2wJUtZEpc3T0=;
	h=Date:To:From:Subject:Message-Id; b=SS/3WIh1JlB2LapgmiWu+N+6RfD7aTPnWmOg+mpdEGSh4pyiOtPyWepP/1kzyhFXBGO3Noyg17hnjbfIGNsLVAMzvMG8ltgFTfwnL1fdpsQKMTJ+zwPEDgLbp8at5ZEv3wYgv1tnNhQ23WjeP7GnLjabIcpkI/MHcftO81TWlfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pGm1GzE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pGm1GzE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2C4C4CEDD;
	Thu, 13 Mar 2025 21:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899731;
	bh=kLyzwFAYyQ2MiOWDHgpFzBFZrYpoEmn2wJUtZEpc3T0=;
	h=Date:To:From:Subject:From;
	b=pGm1GzE0W58jk6h1i9CDw3OKI9qM9UQk5WZpOa1uuIL9fEkvE3g/GqF6lSYGQsdod
	 BYtfNzNxvzXAbzuv4J4T7r993S3vUrSnXYSXfA50hODsDHxVxZcD8liK79i1tU4d+9
	 2mOpq1IV5e4oDswIwnXvCBEUTp0EZ7Vg0yg62FnM=
Date: Thu, 13 Mar 2025 14:02:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-mm-introduce-arch_mm_preinit.patch added to mm-unstable branch
Message-Id: <20250313210211.4B2C4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch, mm: introduce arch_mm_preinit
has been added to the -mm mm-unstable branch.  Its filename is
     arch-mm-introduce-arch_mm_preinit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-mm-introduce-arch_mm_preinit.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch, mm: introduce arch_mm_preinit
Date: Thu, 13 Mar 2025 15:50:02 +0200

Currently, implementation of mem_init() in every architecture consists of
one or more of the following:

* initializations that must run before page allocator is active, for
  instance swiotlb_init()
* a call to memblock_free_all() to release all the memory to the buddy
  allocator
* initializations that must run after page allocator is ready and there is
  no arch-specific hook other than mem_init() for that, like for example
  register_page_bootmem_info() in x86 and sparc64 or simple setting of
  mem_init_done = 1 in several architectures
* a bunch of semi-related stuff that apparently had no better place to
  live, for example a ton of BUILD_BUG_ON()s in parisc.

Introduce arch_mm_preinit() that will be the first thing called from
mm_core_init(). On architectures that have initializations that must happen
before the page allocator is ready, move those into arch_mm_preinit() along
with the code that does not depend on ordering with page allocator setup.

On several architectures this results in reduction of mem_init() to a
single call to memblock_free_all() that allows its consolidation next.

Link: https://lkml.kernel.org/r/20250313135003.836600-13-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>	[x86]
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren (csky) <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c      |   13 ++++++-------
 arch/arm/mm/init.c      |   21 ++++++++++++---------
 arch/arm64/mm/init.c    |   21 ++++++++++++---------
 arch/mips/mm/init.c     |   11 +++++++----
 arch/powerpc/mm/mem.c   |    9 ++++++---
 arch/riscv/mm/init.c    |    8 ++++++--
 arch/s390/mm/init.c     |    5 ++++-
 arch/sparc/mm/init_32.c |    5 ++++-
 arch/um/kernel/mem.c    |    7 +++++--
 arch/x86/mm/init_32.c   |    6 +++++-
 arch/x86/mm/init_64.c   |    5 ++++-
 include/linux/mm.h      |    1 +
 mm/mm_init.c            |    5 +++++
 13 files changed, 77 insertions(+), 40 deletions(-)

--- a/arch/arc/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/arc/mm/init.c
@@ -157,11 +157,16 @@ void __init setup_arch_memory(void)
 	free_area_init(max_zone_pfn);
 }
 
-static void __init highmem_init(void)
+void __init arch_mm_preinit(void)
 {
 #ifdef CONFIG_HIGHMEM
 	memblock_phys_free(high_mem_start, high_mem_sz);
 #endif
+
+	BUILD_BUG_ON((PTRS_PER_PGD * sizeof(pgd_t)) > PAGE_SIZE);
+	BUILD_BUG_ON((PTRS_PER_PUD * sizeof(pud_t)) > PAGE_SIZE);
+	BUILD_BUG_ON((PTRS_PER_PMD * sizeof(pmd_t)) > PAGE_SIZE);
+	BUILD_BUG_ON((PTRS_PER_PTE * sizeof(pte_t)) > PAGE_SIZE);
 }
 
 /*
@@ -172,13 +177,7 @@ static void __init highmem_init(void)
  */
 void __init mem_init(void)
 {
-	highmem_init();
 	memblock_free_all();
-
-	BUILD_BUG_ON((PTRS_PER_PGD * sizeof(pgd_t)) > PAGE_SIZE);
-	BUILD_BUG_ON((PTRS_PER_PUD * sizeof(pud_t)) > PAGE_SIZE);
-	BUILD_BUG_ON((PTRS_PER_PMD * sizeof(pmd_t)) > PAGE_SIZE);
-	BUILD_BUG_ON((PTRS_PER_PTE * sizeof(pte_t)) > PAGE_SIZE);
 }
 
 #ifdef CONFIG_HIGHMEM
--- a/arch/arm64/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/arm64/mm/init.c
@@ -357,12 +357,7 @@ void __init bootmem_init(void)
 	memblock_dump_all();
 }
 
-/*
- * mem_init() marks the free areas in the mem_map and tells us how much memory
- * is free.  This is done after various parts of the system have claimed their
- * memory after the kernel image.
- */
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	unsigned int flags = SWIOTLB_VERBOSE;
 	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
@@ -386,9 +381,6 @@ void __init mem_init(void)
 	swiotlb_init(swiotlb, flags);
 	swiotlb_update_mem_attributes();
 
-	/* this will put all unused low memory onto the freelists */
-	memblock_free_all();
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can be
 	 * detected at build time already.
@@ -414,6 +406,17 @@ void __init mem_init(void)
 	}
 }
 
+/*
+ * mem_init() marks the free areas in the mem_map and tells us how much memory
+ * is free.  This is done after various parts of the system have claimed their
+ * memory after the kernel image.
+ */
+void __init mem_init(void)
+{
+	/* this will put all unused low memory onto the freelists */
+	memblock_free_all();
+}
+
 void free_initmem(void)
 {
 	void *lm_init_begin = lm_alias(__init_begin);
--- a/arch/arm/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/arm/mm/init.c
@@ -237,12 +237,7 @@ static inline void poison_init_mem(void
 		*p++ = 0xe7fddef0;
 }
 
-/*
- * mem_init() marks the free areas in the mem_map and tells us how much
- * memory is free.  This is done after various parts of the system have
- * claimed their memory after the kernel image.
- */
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 #ifdef CONFIG_ARM_LPAE
 	swiotlb_init(max_pfn > arm_dma_pfn_limit, SWIOTLB_VERBOSE);
@@ -253,9 +248,6 @@ void __init mem_init(void)
 	memblock_phys_free(PHYS_OFFSET, __pa(swapper_pg_dir) - PHYS_OFFSET);
 #endif
 
-	/* this will put all unused low memory onto the freelists */
-	memblock_free_all();
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
@@ -271,6 +263,17 @@ void __init mem_init(void)
 #endif
 }
 
+/*
+ * mem_init() marks the free areas in the mem_map and tells us how much
+ * memory is free.  This is done after various parts of the system have
+ * claimed their memory after the kernel image.
+ */
+void __init mem_init(void)
+{
+	/* this will put all unused low memory onto the freelists */
+	memblock_free_all();
+}
+
 #ifdef CONFIG_STRICT_KERNEL_RWX
 struct section_perm {
 	const char *name;
--- a/arch/mips/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/mips/mm/init.c
@@ -425,7 +425,7 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	/*
 	 * When PFN_PTE_SHIFT is greater than PAGE_SHIFT we won't have enough PTE
@@ -435,7 +435,6 @@ void __init mem_init(void)
 
 	maar_init();
 	setup_zero_pages();	/* Setup zeroed pages.  */
-	memblock_free_all();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
@@ -446,13 +445,17 @@ void __init mem_init(void)
 #endif
 }
 #else  /* CONFIG_NUMA */
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	setup_zero_pages();	/* This comes from node 0 */
-	memblock_free_all();
 }
 #endif /* !CONFIG_NUMA */
 
+void __init mem_init(void)
+{
+	memblock_free_all();
+}
+
 void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long pfn;
--- a/arch/powerpc/mm/mem.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/powerpc/mm/mem.c
@@ -273,7 +273,7 @@ void __init paging_init(void)
 	mark_nonram_nosave();
 }
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	/*
 	 * book3s is limited to 16 page sizes due to encoding this in
@@ -295,8 +295,6 @@ void __init mem_init(void)
 
 	kasan_late_init();
 
-	memblock_free_all();
-
 #if defined(CONFIG_PPC_E500) && !defined(CONFIG_SMP)
 	/*
 	 * If smp is enabled, next_tlbcam_idx is initialized in the cpu up
@@ -329,6 +327,11 @@ void __init mem_init(void)
 #endif /* CONFIG_PPC32 */
 }
 
+void __init mem_init(void)
+{
+	memblock_free_all();
+}
+
 void free_initmem(void)
 {
 	ppc_md.progress = ppc_printk_progress;
--- a/arch/riscv/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/riscv/mm/init.c
@@ -171,7 +171,7 @@ static void __init print_vm_layout(void)
 static void print_vm_layout(void) { }
 #endif /* CONFIG_DEBUG_VM */
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	bool swiotlb = max_pfn > PFN_DOWN(dma32_phys_limit);
 #ifdef CONFIG_FLATMEM
@@ -192,11 +192,15 @@ void __init mem_init(void)
 	}
 
 	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
-	memblock_free_all();
 
 	print_vm_layout();
 }
 
+void __init mem_init(void)
+{
+	memblock_free_all();
+}
+
 /* Limit the memory size via mem. */
 static phys_addr_t memory_limit;
 #ifdef CONFIG_XIP_KERNEL
--- a/arch/s390/mm/init.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/s390/mm/init.c
@@ -154,7 +154,7 @@ static void pv_init(void)
 	swiotlb_update_mem_attributes();
 }
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	cpumask_set_cpu(0, &init_mm.context.cpu_attach_mask);
 	cpumask_set_cpu(0, mm_cpumask(&init_mm));
@@ -163,7 +163,10 @@ void __init mem_init(void)
 	kfence_split_mapping();
 
 	setup_zero_pages();	/* Setup zeroed pages. */
+}
 
+void __init mem_init(void)
+{
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
 }
--- a/arch/sparc/mm/init_32.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/sparc/mm/init_32.c
@@ -232,7 +232,7 @@ static void __init taint_real_pages(void
 	}
 }
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	int i;
 
@@ -262,7 +262,10 @@ void __init mem_init(void)
 	memset(sparc_valid_addr_bitmap, 0, i << 2);
 
 	taint_real_pages();
+}
 
+void __init mem_init(void)
+{
 	memblock_free_all();
 }
 
--- a/arch/um/kernel/mem.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/um/kernel/mem.c
@@ -54,7 +54,7 @@ int kmalloc_ok = 0;
 /* Used during early boot */
 static unsigned long brk_end;
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
@@ -66,10 +66,13 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	max_pfn = max_low_pfn;
+}
 
+void __init mem_init(void)
+{
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-	max_pfn = max_low_pfn;
 	kmalloc_ok = 1;
 }
 
--- a/arch/x86/mm/init_32.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/x86/mm/init_32.c
@@ -691,13 +691,17 @@ static void __init test_wp_bit(void)
 	panic("Linux doesn't support CPUs with broken WP.");
 }
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	pci_iommu_alloc();
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
+}
+
+void __init mem_init(void)
+{
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
 
--- a/arch/x86/mm/init_64.c~arch-mm-introduce-arch_mm_preinit
+++ a/arch/x86/mm/init_64.c
@@ -1359,10 +1359,13 @@ failed:
 	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
 }
 
-void __init mem_init(void)
+void __init arch_mm_preinit(void)
 {
 	pci_iommu_alloc();
+}
 
+void __init mem_init(void)
+{
 	/* clear_bss() already clear the empty_zero_page */
 
 	/* this will put all memory onto the freelists */
--- a/include/linux/mm.h~arch-mm-introduce-arch_mm_preinit
+++ a/include/linux/mm.h
@@ -43,6 +43,7 @@ struct folio_batch;
 
 extern int sysctl_page_lock_unfairness;
 
+void arch_mm_preinit(void);
 void mm_core_init(void);
 void init_mm_internals(void);
 
--- a/mm/mm_init.c~arch-mm-introduce-arch_mm_preinit
+++ a/mm/mm_init.c
@@ -2734,11 +2734,16 @@ static void __init mem_init_print_info(v
 		);
 }
 
+void __init __weak arch_mm_preinit(void)
+{
+}
+
 /*
  * Set up kernel memory allocators
  */
 void __init mm_core_init(void)
 {
+	arch_mm_preinit();
 	hugetlb_bootmem_alloc();
 
 	/* Initializations relying on SMP setup */
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch
csky-move-setup_initrd-to-setupc.patch
hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch
mips-consolidate-mem_init-for-numa-machines.patch
mips-make-setup_zero_pages-use-memblock.patch
nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch
s390-make-setup_zero_pages-use-memblock.patch
xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch
arch-mm-set-max_mapnr-when-allocating-memory-map-for-flatmem.patch
arch-mm-set-high_memory-in-free_area_init.patch
arch-mm-streamline-highmem-freeing.patch
arch-mm-introduce-arch_mm_preinit.patch
arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

