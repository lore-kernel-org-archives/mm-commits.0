From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-thread-pgprot_t-through-init_memory_mapping.patch removed from -mm
 tree
Date: Sat, 11 Apr 2020 23:45:22 -0700
Message-ID: <20200412064522.LF11DpEhn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgDLGpZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: x86/mm: thread pgprot_t through init_memory_mapping()
has been removed from the -mm tree.  Its filename was
     x86-mm-thread-pgprot_t-through-init_memory_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: x86/mm: thread pgprot_t through init_memory_mapping()

In preparation to support a pgprot_t argument for arch_add_memory().

It's required to move the prototype of init_memory_mapping() seeing the
original location came before the definition of pgprot_t.

Link: http://lkml.kernel.org/r/20200306170846.9333-4-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    3 --
 arch/x86/include/asm/pgtable.h    |    3 ++
 arch/x86/kernel/amd_gart_64.c     |    3 +-
 arch/x86/mm/init.c                |    9 ++++---
 arch/x86/mm/init_32.c             |    3 +-
 arch/x86/mm/init_64.c             |   32 +++++++++++++++-------------
 arch/x86/mm/mm_internal.h         |    3 +-
 arch/x86/platform/uv/bios_uv.c    |    3 +-
 8 files changed, 34 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/page_types.h~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/include/asm/page_types.h
@@ -71,9 +71,6 @@ static inline phys_addr_t get_max_mapped
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
 
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-
 extern void initmem_init(void);
 
 #endif	/* !__ASSEMBLY__ */
--- a/arch/x86/include/asm/pgtable.h~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/include/asm/pgtable.h
@@ -1081,6 +1081,9 @@ static inline void __meminit init_trampo
 
 void __init poking_init(void);
 
+unsigned long init_memory_mapping(unsigned long start,
+				  unsigned long end, pgprot_t prot);
+
 # ifdef CONFIG_RANDOMIZE_MEMORY
 void __meminit init_trampoline(void);
 # else
--- a/arch/x86/kernel/amd_gart_64.c~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -744,7 +744,8 @@ int __init gart_iommu_init(void)
 
 	start_pfn = PFN_DOWN(aper_base);
 	if (!pfn_range_is_mapped(start_pfn, end_pfn))
-		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT,
+				    PAGE_KERNEL);
 
 	pr_info("PCI-DMA: using GART IOMMU.\n");
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
--- a/arch/x86/mm/init_32.c~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/mm/init_32.c
@@ -257,7 +257,8 @@ static inline int __is_kernel_text(unsig
 unsigned long __init
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
-			     unsigned long page_size_mask)
+			     unsigned long page_size_mask,
+			     pgprot_t prot)
 {
 	int use_pse = page_size_mask == (1<<PG_LEVEL_2M);
 	unsigned long last_map_addr = end;
--- a/arch/x86/mm/init_64.c~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/mm/init_64.c
@@ -585,7 +585,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
  */
 static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
-	      unsigned long page_size_mask, bool init)
+	      unsigned long page_size_mask, pgprot_t _prot, bool init)
 {
 	unsigned long pages = 0, paddr_next;
 	unsigned long paddr_last = paddr_end;
@@ -595,7 +595,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 	for (; i < PTRS_PER_PUD; i++, paddr = paddr_next) {
 		pud_t *pud;
 		pmd_t *pmd;
-		pgprot_t prot = PAGE_KERNEL;
+		pgprot_t prot = _prot;
 
 		vaddr = (unsigned long)__va(paddr);
 		pud = pud_page + pud_index(vaddr);
@@ -644,9 +644,12 @@ phys_pud_init(pud_t *pud_page, unsigned
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
+
+			prot = __pgprot(pgprot_val(prot) | __PAGE_KERNEL_LARGE);
+
 			set_pte_init((pte_t *)pud,
 				     pfn_pte((paddr & PUD_MASK) >> PAGE_SHIFT,
-					     PAGE_KERNEL_LARGE),
+					     prot),
 				     init);
 			spin_unlock(&init_mm.page_table_lock);
 			paddr_last = paddr_next;
@@ -669,7 +672,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 
 static unsigned long __meminit
 phys_p4d_init(p4d_t *p4d_page, unsigned long paddr, unsigned long paddr_end,
-	      unsigned long page_size_mask, bool init)
+	      unsigned long page_size_mask, pgprot_t prot, bool init)
 {
 	unsigned long vaddr, vaddr_end, vaddr_next, paddr_next, paddr_last;
 
@@ -679,7 +682,7 @@ phys_p4d_init(p4d_t *p4d_page, unsigned
 
 	if (!pgtable_l5_enabled())
 		return phys_pud_init((pud_t *) p4d_page, paddr, paddr_end,
-				     page_size_mask, init);
+				     page_size_mask, prot, init);
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
 		p4d_t *p4d = p4d_page + p4d_index(vaddr);
@@ -702,13 +705,13 @@ phys_p4d_init(p4d_t *p4d_page, unsigned
 		if (!p4d_none(*p4d)) {
 			pud = pud_offset(p4d, 0);
 			paddr_last = phys_pud_init(pud, paddr, __pa(vaddr_end),
-					page_size_mask, init);
+					page_size_mask, prot, init);
 			continue;
 		}
 
 		pud = alloc_low_page();
 		paddr_last = phys_pud_init(pud, paddr, __pa(vaddr_end),
-					   page_size_mask, init);
+					   page_size_mask, prot, init);
 
 		spin_lock(&init_mm.page_table_lock);
 		p4d_populate_init(&init_mm, p4d, pud, init);
@@ -722,7 +725,7 @@ static unsigned long __meminit
 __kernel_physical_mapping_init(unsigned long paddr_start,
 			       unsigned long paddr_end,
 			       unsigned long page_size_mask,
-			       bool init)
+			       pgprot_t prot, bool init)
 {
 	bool pgd_changed = false;
 	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
@@ -743,13 +746,13 @@ __kernel_physical_mapping_init(unsigned
 			paddr_last = phys_p4d_init(p4d, __pa(vaddr),
 						   __pa(vaddr_end),
 						   page_size_mask,
-						   init);
+						   prot, init);
 			continue;
 		}
 
 		p4d = alloc_low_page();
 		paddr_last = phys_p4d_init(p4d, __pa(vaddr), __pa(vaddr_end),
-					   page_size_mask, init);
+					   page_size_mask, prot, init);
 
 		spin_lock(&init_mm.page_table_lock);
 		if (pgtable_l5_enabled())
@@ -778,10 +781,10 @@ __kernel_physical_mapping_init(unsigned
 unsigned long __meminit
 kernel_physical_mapping_init(unsigned long paddr_start,
 			     unsigned long paddr_end,
-			     unsigned long page_size_mask)
+			     unsigned long page_size_mask, pgprot_t prot)
 {
 	return __kernel_physical_mapping_init(paddr_start, paddr_end,
-					      page_size_mask, true);
+					      page_size_mask, prot, true);
 }
 
 /*
@@ -796,7 +799,8 @@ kernel_physical_mapping_change(unsigned
 			       unsigned long page_size_mask)
 {
 	return __kernel_physical_mapping_init(paddr_start, paddr_end,
-					      page_size_mask, false);
+					      page_size_mask, PAGE_KERNEL,
+					      false);
 }
 
 #ifndef CONFIG_NUMA
@@ -863,7 +867,7 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	init_memory_mapping(start, start + size);
+	init_memory_mapping(start, start + size, PAGE_KERNEL);
 
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
--- a/arch/x86/mm/init.c~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/mm/init.c
@@ -467,7 +467,7 @@ bool pfn_range_is_mapped(unsigned long s
  * the physical memory. To access them they are temporarily mapped.
  */
 unsigned long __ref init_memory_mapping(unsigned long start,
-					       unsigned long end)
+					unsigned long end, pgprot_t prot)
 {
 	struct map_range mr[NR_RANGE_MR];
 	unsigned long ret = 0;
@@ -481,7 +481,8 @@ unsigned long __ref init_memory_mapping(
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-						   mr[i].page_size_mask);
+						   mr[i].page_size_mask,
+						   prot);
 
 	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
 
@@ -521,7 +522,7 @@ static unsigned long __init init_range_m
 		 */
 		can_use_brk_pgt = max(start, (u64)pgt_buf_end<<PAGE_SHIFT) >=
 				    min(end, (u64)pgt_buf_top<<PAGE_SHIFT);
-		init_memory_mapping(start, end);
+		init_memory_mapping(start, end, PAGE_KERNEL);
 		mapped_ram_size += end - start;
 		can_use_brk_pgt = true;
 	}
@@ -661,7 +662,7 @@ void __init init_mem_mapping(void)
 #endif
 
 	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
+	init_memory_mapping(0, ISA_END_ADDRESS, PAGE_KERNEL);
 
 	/* Init the trampoline, possibly with KASLR memory offset */
 	init_trampoline();
--- a/arch/x86/mm/mm_internal.h~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/mm/mm_internal.h
@@ -12,7 +12,8 @@ void early_ioremap_page_table_range_init
 
 unsigned long kernel_physical_mapping_init(unsigned long start,
 					     unsigned long end,
-					     unsigned long page_size_mask);
+					     unsigned long page_size_mask,
+					     pgprot_t prot);
 unsigned long kernel_physical_mapping_change(unsigned long start,
 					     unsigned long end,
 					     unsigned long page_size_mask);
--- a/arch/x86/platform/uv/bios_uv.c~x86-mm-thread-pgprot_t-through-init_memory_mapping
+++ a/arch/x86/platform/uv/bios_uv.c
@@ -352,7 +352,8 @@ void __iomem *__init efi_ioremap(unsigne
 	if (type == EFI_MEMORY_MAPPED_IO)
 		return ioremap(phys_addr, size);
 
-	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size,
+					   PAGE_KERNEL);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
 		efi_ioremap(top, size - (top - phys_addr), type, attribute);
_

Patches currently in -mm which might be from logang@deltatee.com are
