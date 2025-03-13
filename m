Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0B78F37
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899735; cv=none; b=LLd4/ZbVBPzaoSrlz95IKAWVq1G3Ic4+H/aptno1iz0WAy+a6w5jsiQqL6rem2eHEK5F8K9v1WZ+ETS8fDGn8XZ9BB9fYmI1TFibw3n9H1mbRUmS4pBfXiFLV8+TChAQRDDbS2Cs26OdB3u6Jo8MAHv1TztQ9X3Gxlq8ye99Iq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899735; c=relaxed/simple;
	bh=wc/e5HXnDpt6KIoz+ktd5i8Sxcs1rDo/m63ayOiu+Qo=;
	h=Date:To:From:Subject:Message-Id; b=QOnFTR7jNDKNUx5IjX0dqQm7RjJ2e4g0U76/4+AQwfwSg1yQ9S8lvFq16q8w+1YW4JuwphKQ4HtuJ+5AtAMvHUmLAKyVKnxkx3LtHZM1CVFXgkyH/qrdVtWsoc7563tIXjPyibdVOYQ6PMUNPLdfIbeFjcdne5AOV3wDn3IszVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mnr+Vmmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mnr+Vmmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD4BC4CEDD;
	Thu, 13 Mar 2025 21:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899734;
	bh=wc/e5HXnDpt6KIoz+ktd5i8Sxcs1rDo/m63ayOiu+Qo=;
	h=Date:To:From:Subject:From;
	b=Mnr+VmmyTTAyuF9o6p8R402XYpZwMq0eVqW4cdXZy+I5ORbJkqgVRZuf9zXWqloqP
	 o0DOF0P/kkcMxOpLuoAkXUvylkLx0y9KcMX/EInU2DomrPjrFxajCFlhz5EOaaLTQF
	 srUrRd0Si80z8/mQ5n5Rq2HzzDhFRXJnVi+gn5W4=
Date: Thu, 13 Mar 2025 14:02:13 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch added to mm-unstable branch
Message-Id: <20250313210214.5BD4BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch, mm: make releasing of memory to page allocator more explicit
has been added to the -mm mm-unstable branch.  Its filename is
     arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

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
Subject: arch, mm: make releasing of memory to page allocator more explicit
Date: Thu, 13 Mar 2025 15:50:03 +0200

The point where the memory is released from memblock to the buddy
allocator is hidden inside arch-specific mem_init()s and the call to
memblock_free_all() is needlessly duplicated in every artiste cure and
after introduction of arch_mm_preinit() hook, mem_init() implementation on
many architecture only contains the call to memblock_free_all().

Pull memblock_free_all() call into mm_core_init() and drop mem_init() on
relevant architectures to make it more explicit where the free memory is
released from memblock to the buddy allocator and to reduce code
duplication in architecture specific code.

Link: https://lkml.kernel.org/r/20250313135003.836600-14-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>	[x86]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
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

 arch/alpha/mm/init.c         |    6 ------
 arch/arc/mm/init.c           |   11 -----------
 arch/arm/mm/init.c           |   11 -----------
 arch/arm64/mm/init.c         |   11 -----------
 arch/csky/mm/init.c          |    5 -----
 arch/hexagon/mm/init.c       |   18 ------------------
 arch/loongarch/kernel/numa.c |    5 -----
 arch/loongarch/mm/init.c     |    5 -----
 arch/m68k/mm/init.c          |    2 --
 arch/microblaze/mm/init.c    |    3 ---
 arch/mips/mm/init.c          |    5 -----
 arch/nios2/mm/init.c         |    6 ------
 arch/openrisc/mm/init.c      |    3 ---
 arch/parisc/mm/init.c        |    2 --
 arch/powerpc/mm/mem.c        |    5 -----
 arch/riscv/mm/init.c         |    5 -----
 arch/s390/mm/init.c          |    6 ------
 arch/sh/mm/init.c            |    2 --
 arch/sparc/mm/init_32.c      |    5 -----
 arch/sparc/mm/init_64.c      |    2 --
 arch/um/kernel/mem.c         |    2 --
 arch/x86/mm/init_32.c        |    3 ---
 arch/x86/mm/init_64.c        |    2 --
 arch/xtensa/mm/init.c        |    9 ---------
 include/linux/memblock.h     |    1 -
 mm/internal.h                |    3 ++-
 mm/mm_init.c                 |    5 +++++
 27 files changed, 7 insertions(+), 136 deletions(-)

--- a/arch/alpha/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/alpha/mm/init.c
@@ -273,12 +273,6 @@ srm_paging_stop (void)
 }
 #endif
 
-void __init
-mem_init(void)
-{
-	memblock_free_all();
-}
-
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= _PAGE_P(_PAGE_FOE | _PAGE_FOW |
 								  _PAGE_FOR),
--- a/arch/arc/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/arc/mm/init.c
@@ -169,17 +169,6 @@ void __init arch_mm_preinit(void)
 	BUILD_BUG_ON((PTRS_PER_PTE * sizeof(pte_t)) > PAGE_SIZE);
 }
 
-/*
- * mem_init - initializes memory
- *
- * Frees up bootmem
- * Calculates and displays memory available/used
- */
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 #ifdef CONFIG_HIGHMEM
 int pfn_valid(unsigned long pfn)
 {
--- a/arch/arm64/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/arm64/mm/init.c
@@ -406,17 +406,6 @@ void __init arch_mm_preinit(void)
 	}
 }
 
-/*
- * mem_init() marks the free areas in the mem_map and tells us how much memory
- * is free.  This is done after various parts of the system have claimed their
- * memory after the kernel image.
- */
-void __init mem_init(void)
-{
-	/* this will put all unused low memory onto the freelists */
-	memblock_free_all();
-}
-
 void free_initmem(void)
 {
 	void *lm_init_begin = lm_alias(__init_begin);
--- a/arch/arm/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/arm/mm/init.c
@@ -263,17 +263,6 @@ void __init arch_mm_preinit(void)
 #endif
 }
 
-/*
- * mem_init() marks the free areas in the mem_map and tells us how much
- * memory is free.  This is done after various parts of the system have
- * claimed their memory after the kernel image.
- */
-void __init mem_init(void)
-{
-	/* this will put all unused low memory onto the freelists */
-	memblock_free_all();
-}
-
 #ifdef CONFIG_STRICT_KERNEL_RWX
 struct section_perm {
 	const char *name;
--- a/arch/csky/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/csky/mm/init.c
@@ -42,11 +42,6 @@ unsigned long empty_zero_page[PAGE_SIZE
 						__page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 void free_initmem(void)
 {
 	free_initmem_default(-1);
--- a/arch/hexagon/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/hexagon/mm/init.c
@@ -43,24 +43,6 @@ DEFINE_SPINLOCK(kmap_gen_lock);
 /*  checkpatch says don't init this to 0.  */
 unsigned long long kmap_generation;
 
-/*
- * mem_init - initializes memory
- *
- * Frees up bootmem
- * Fixes up more stuff for HIGHMEM
- * Calculates and displays memory available/used
- */
-void __init mem_init(void)
-{
-	/*  No idea where this is actually declared.  Seems to evade LXR.  */
-	memblock_free_all();
-
-	/*
-	 *  To-Do:  someone somewhere should wipe out the bootmem map
-	 *  after we're done?
-	 */
-}
-
 void sync_icache_dcache(pte_t pte)
 {
 	unsigned long addr;
--- a/arch/loongarch/kernel/numa.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/loongarch/kernel/numa.c
@@ -387,11 +387,6 @@ void __init paging_init(void)
 	free_area_init(zones_size);
 }
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 int pcibus_to_node(struct pci_bus *bus)
 {
 	return dev_to_node(&bus->dev);
--- a/arch/loongarch/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/loongarch/mm/init.c
@@ -75,11 +75,6 @@ void __init paging_init(void)
 
 	free_area_init(max_zone_pfns);
 }
-
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
 #endif /* !CONFIG_NUMA */
 
 void __ref free_initmem(void)
--- a/arch/m68k/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/m68k/mm/init.c
@@ -121,7 +121,5 @@ static inline void init_pointer_tables(v
 
 void __init mem_init(void)
 {
-	/* this will put all memory onto the freelists */
-	memblock_free_all();
 	init_pointer_tables();
 }
--- a/arch/microblaze/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/microblaze/mm/init.c
@@ -107,9 +107,6 @@ void __init setup_memory(void)
 
 void __init mem_init(void)
 {
-	/* this will put all memory onto the freelists */
-	memblock_free_all();
-
 	mem_init_done = 1;
 }
 
--- a/arch/mips/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/mips/mm/init.c
@@ -451,11 +451,6 @@ void __init arch_mm_preinit(void)
 }
 #endif /* !CONFIG_NUMA */
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long pfn;
--- a/arch/nios2/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/nios2/mm/init.c
@@ -60,12 +60,6 @@ void __init paging_init(void)
 			(unsigned long)empty_zero_page + PAGE_SIZE);
 }
 
-void __init mem_init(void)
-{
-	/* this will put all memory onto the freelists */
-	memblock_free_all();
-}
-
 void __init mmu_init(void)
 {
 	flush_tlb_all();
--- a/arch/openrisc/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/openrisc/mm/init.c
@@ -196,9 +196,6 @@ void __init mem_init(void)
 	/* clear the zero-page */
 	memset((void *)empty_zero_page, 0, PAGE_SIZE);
 
-	/* this will put all low memory onto the freelists */
-	memblock_free_all();
-
 	printk("mem_init_done ...........................................\n");
 	mem_init_done = 1;
 	return;
--- a/arch/parisc/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/parisc/mm/init.c
@@ -562,8 +562,6 @@ void __init mem_init(void)
 	BUILD_BUG_ON(TMPALIAS_MAP_START >= 0x80000000);
 #endif
 
-	memblock_free_all();
-
 #ifdef CONFIG_PA11
 	if (boot_cpu_data.cpu_type == pcxl2 || boot_cpu_data.cpu_type == pcxl) {
 		pcxl_dma_start = (unsigned long)SET_MAP_OFFSET(MAP_START);
--- a/arch/powerpc/mm/mem.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/powerpc/mm/mem.c
@@ -327,11 +327,6 @@ void __init arch_mm_preinit(void)
 #endif /* CONFIG_PPC32 */
 }
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 void free_initmem(void)
 {
 	ppc_md.progress = ppc_printk_progress;
--- a/arch/riscv/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/riscv/mm/init.c
@@ -196,11 +196,6 @@ void __init arch_mm_preinit(void)
 	print_vm_layout();
 }
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 /* Limit the memory size via mem. */
 static phys_addr_t memory_limit;
 #ifdef CONFIG_XIP_KERNEL
--- a/arch/s390/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/s390/mm/init.c
@@ -165,12 +165,6 @@ void __init arch_mm_preinit(void)
 	setup_zero_pages();	/* Setup zeroed pages. */
 }
 
-void __init mem_init(void)
-{
-	/* this will put all low memory onto the freelists */
-	memblock_free_all();
-}
-
 unsigned long memory_block_size_bytes(void)
 {
 	/*
--- a/arch/sh/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/sh/mm/init.c
@@ -330,8 +330,6 @@ unsigned int mem_init_done = 0;
 
 void __init mem_init(void)
 {
-	memblock_free_all();
-
 	/* Set this up early, so we can take care of the zero page */
 	cpu_cache_init();
 
--- a/arch/sparc/mm/init_32.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/sparc/mm/init_32.c
@@ -264,11 +264,6 @@ void __init arch_mm_preinit(void)
 	taint_real_pages();
 }
 
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 void sparc_flush_page_to_ram(struct page *page)
 {
 	unsigned long vaddr = (unsigned long)page_address(page);
--- a/arch/sparc/mm/init_64.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/sparc/mm/init_64.c
@@ -2505,8 +2505,6 @@ static void __init register_page_bootmem
 }
 void __init mem_init(void)
 {
-	memblock_free_all();
-
 	/*
 	 * Must be done after boot memory is put on freelist, because here we
 	 * might set fields in deferred struct pages that have not yet been
--- a/arch/um/kernel/mem.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/um/kernel/mem.c
@@ -71,8 +71,6 @@ void __init arch_mm_preinit(void)
 
 void __init mem_init(void)
 {
-	/* this will put all low memory onto the freelists */
-	memblock_free_all();
 	kmalloc_ok = 1;
 }
 
--- a/arch/x86/mm/init_32.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/x86/mm/init_32.c
@@ -702,9 +702,6 @@ void __init arch_mm_preinit(void)
 
 void __init mem_init(void)
 {
-	/* this will put all low memory onto the freelists */
-	memblock_free_all();
-
 	after_bootmem = 1;
 	x86_init.hyper.init_after_bootmem();
 
--- a/arch/x86/mm/init_64.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/x86/mm/init_64.c
@@ -1368,8 +1368,6 @@ void __init mem_init(void)
 {
 	/* clear_bss() already clear the empty_zero_page */
 
-	/* this will put all memory onto the freelists */
-	memblock_free_all();
 	after_bootmem = 1;
 	x86_init.hyper.init_after_bootmem();
 
--- a/arch/xtensa/mm/init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/arch/xtensa/mm/init.c
@@ -129,15 +129,6 @@ void __init zones_init(void)
 	print_vm_layout();
 }
 
-/*
- * Initialize memory pages.
- */
-
-void __init mem_init(void)
-{
-	memblock_free_all();
-}
-
 static void __init parse_memmap_one(char *p)
 {
 	char *oldp;
--- a/include/linux/memblock.h~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/include/linux/memblock.h
@@ -133,7 +133,6 @@ int memblock_mark_nomap(phys_addr_t base
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 
-void memblock_free_all(void);
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
 
--- a/mm/internal.h~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/mm/internal.h
@@ -1475,7 +1475,8 @@ static inline bool gup_must_unshare(stru
 }
 
 extern bool mirrored_kernelcore;
-extern bool memblock_has_mirror(void);
+bool memblock_has_mirror(void);
+void memblock_free_all(void);
 
 static __always_inline void vma_set_range(struct vm_area_struct *vma,
 					  unsigned long start, unsigned long end,
--- a/mm/mm_init.c~arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit
+++ a/mm/mm_init.c
@@ -2738,6 +2738,10 @@ void __init __weak arch_mm_preinit(void)
 {
 }
 
+void __init __weak mem_init(void)
+{
+}
+
 /*
  * Set up kernel memory allocators
  */
@@ -2761,6 +2765,7 @@ void __init mm_core_init(void)
 	report_meminit();
 	kmsan_init_shadow();
 	stack_depot_early_init();
+	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
 	/*
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

