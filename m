From: akpm@linux-foundation.org
Subject: + sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:58:58 -0700
Message-ID: <20130321195859.1D49B31C259@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43929 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3CUT7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:59:00 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so296614ghb.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:59:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, Bernhard.Schmidt@lrz.de, ben@decadent.org.uk, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: sparse-vmemmap: specify vmemmap population range in bytes
has been added to the -mm tree.  Its filename is
     sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: sparse-vmemmap: specify vmemmap population range in bytes

The sparse code, when asking the architecture to populate the vmemmap,
specifies the section range as a starting page and a number of pages.

This is an awkward interface, because none of the arch-specific code
actually thinks of the range in terms of 'struct page' units and always
translates it to bytes first.

In addition, later patches mix huge page and regular page backing for the
vmemmap.  For this, they need to call vmemmap_populate_basepages() on
sub-section ranges with PAGE_SIZE and PMD_SIZE in mind.  But these are not
necessarily multiples of the 'struct page' size and so this unit is too
coarse.

Just translate the section range into bytes once in the generic sparse
code, then pass byte ranges down the stack.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Tested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c       |   13 +++++--------
 arch/ia64/mm/discontig.c  |    7 +++----
 arch/powerpc/mm/init_64.c |   11 +++--------
 arch/s390/mm/vmem.c       |   13 +++++--------
 arch/sparc/mm/init_64.c   |    7 +++----
 arch/x86/mm/init_64.c     |   15 +++++----------
 include/linux/mm.h        |    8 ++++----
 mm/sparse-vmemmap.c       |   19 ++++++++++++-------
 mm/sparse.c               |   10 ++++++++--
 9 files changed, 48 insertions(+), 55 deletions(-)

diff -puN arch/arm64/mm/mmu.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/arm64/mm/mmu.c
@@ -391,17 +391,14 @@ int kern_addr_valid(unsigned long addr)
 }
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 #ifdef CONFIG_ARM64_64K_PAGES
-int __meminit vmemmap_populate(struct page *start_page,
-			       unsigned long size, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	return vmemmap_populate_basepages(start_page, size, node);
+	return vmemmap_populate_basepages(start, end, node);
 }
 #else	/* !CONFIG_ARM64_64K_PAGES */
-int __meminit vmemmap_populate(struct page *start_page,
-			       unsigned long size, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long addr = start;
 	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
@@ -434,7 +431,7 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 #endif	/* CONFIG_ARM64_64K_PAGES */
-void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
diff -puN arch/ia64/mm/discontig.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/ia64/mm/discontig.c
@@ -819,13 +819,12 @@ void arch_refresh_nodedata(int update_no
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(struct page *start_page,
-						unsigned long size, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	return vmemmap_populate_basepages(start_page, size, node);
+	return vmemmap_populate_basepages(start, end, node);
 }
 
-void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 #endif
diff -puN arch/powerpc/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/powerpc/mm/init_64.c
@@ -263,19 +263,14 @@ static __meminit void vmemmap_list_popul
 	vmemmap_list = vmem_back;
 }
 
-int __meminit vmemmap_populate(struct page *start_page,
-			       unsigned long nr_pages, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	unsigned long start = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + nr_pages);
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
 
 	/* Align to the page size of the linear mapping. */
 	start = _ALIGN_DOWN(start, page_size);
 
-	pr_debug("vmemmap_populate page %p, %ld pages, node %d\n",
-		 start_page, nr_pages, node);
-	pr_debug(" -> map %lx..%lx\n", start, end);
+	pr_debug("vmemmap_populate %lx..%lx, node %d\n", start, end, node);
 
 	for (; start < end; start += page_size) {
 		void *p;
@@ -298,7 +293,7 @@ int __meminit vmemmap_populate(struct pa
 	return 0;
 }
 
-void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 
diff -puN arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/s390/mm/vmem.c
@@ -191,19 +191,16 @@ static void vmem_remove_range(unsigned l
 /*
  * Add a backed mem_map array to the virtual mem_map array.
  */
-int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	unsigned long address, start_addr, end_addr;
+	unsigned long address = start;
 	pgd_t *pg_dir;
 	pud_t *pu_dir;
 	pmd_t *pm_dir;
 	pte_t *pt_dir;
 	int ret = -ENOMEM;
 
-	start_addr = (unsigned long) start;
-	end_addr = (unsigned long) (start + nr);
-
-	for (address = start_addr; address < end_addr;) {
+	for (address = start; address < end;) {
 		pg_dir = pgd_offset_k(address);
 		if (pgd_none(*pg_dir)) {
 			pu_dir = vmem_pud_alloc();
@@ -265,11 +262,11 @@ int __meminit vmemmap_populate(struct pa
 	memset(start, 0, nr * sizeof(struct page));
 	ret = 0;
 out:
-	flush_tlb_kernel_range(start_addr, end_addr);
+	flush_tlb_kernel_range(start, end);
 	return ret;
 }
 
-void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 
diff -puN arch/sparc/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/sparc/mm/init_64.c
@@ -2163,10 +2163,9 @@ unsigned long vmemmap_table[VMEMMAP_SIZE
 static long __meminitdata addr_start, addr_end;
 static int __meminitdata node_start;
 
-int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node)
 {
-	unsigned long vstart = (unsigned long) start;
-	unsigned long vend = (unsigned long) (start + nr);
 	unsigned long phys_start = (vstart - VMEMMAP_BASE);
 	unsigned long phys_end = (vend - VMEMMAP_BASE);
 	unsigned long addr = phys_start & VMEMMAP_CHUNK_MASK;
@@ -2218,7 +2217,7 @@ void __meminit vmemmap_populate_print_la
 	}
 }
 
-void vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
 
diff -puN arch/x86/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/arch/x86/mm/init_64.c
@@ -1011,11 +1011,8 @@ remove_pagetable(unsigned long start, un
 	flush_tlb_all();
 }
 
-void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
+void __ref vmemmap_free(unsigned long start, unsigned long end)
 {
-	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
-
 	remove_pagetable(start, end, false);
 }
 
@@ -1284,17 +1281,15 @@ static long __meminitdata addr_start, ad
 static void __meminitdata *p_start, *p_end;
 static int __meminitdata node_start;
 
-int __meminit
-vmemmap_populate(struct page *start_page, unsigned long size, int node)
+int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long addr;
 	unsigned long next;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	for (; addr < end; addr = next) {
+	for (addr = start; addr < end; addr = next) {
 		void *p = NULL;
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -1351,7 +1346,7 @@ vmemmap_populate(struct page *start_page
 		}
 
 	}
-	sync_global_pgds((unsigned long)start_page, end - 1);
+	sync_global_pgds(start, end - 1);
 	return 0;
 }
 
diff -puN include/linux/mm.h~sparse-vmemmap-specify-vmemmap-population-range-in-bytes include/linux/mm.h
--- a/include/linux/mm.h~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/include/linux/mm.h
@@ -1760,12 +1760,12 @@ pte_t *vmemmap_pte_populate(pmd_t *pmd,
 void *vmemmap_alloc_block(unsigned long size, int node);
 void *vmemmap_alloc_block_buf(unsigned long size, int node);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
-int vmemmap_populate_basepages(struct page *start_page,
-						unsigned long pages, int node);
-int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
+int vmemmap_populate_basepages(unsigned long start, unsigned long end,
+			       int node);
+int vmemmap_populate(unsigned long start, unsigned long end, int node);
 void vmemmap_populate_print_last(void);
 #ifdef CONFIG_MEMORY_HOTPLUG
-void vmemmap_free(struct page *memmap, unsigned long nr_pages);
+void vmemmap_free(unsigned long start, unsigned long end);
 #endif
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long size);
diff -puN mm/sparse-vmemmap.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/mm/sparse-vmemmap.c
@@ -147,11 +147,10 @@ pgd_t * __meminit vmemmap_pgd_populate(u
 	return pgd;
 }
 
-int __meminit vmemmap_populate_basepages(struct page *start_page,
-						unsigned long size, int node)
+int __meminit vmemmap_populate_basepages(unsigned long start,
+					 unsigned long end, int node)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long addr = start;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -178,9 +177,15 @@ int __meminit vmemmap_populate_basepages
 
 struct page * __meminit sparse_mem_map_populate(unsigned long pnum, int nid)
 {
-	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
-	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
-	if (error)
+	unsigned long start;
+	unsigned long end;
+	struct page *map;
+
+	map = pfn_to_page(pnum * PAGES_PER_SECTION);
+	start = (unsigned long)map;
+	end = (unsigned long)(map + PAGES_PER_SECTION);
+
+	if (vmemmap_populate(start, end, nid))
 		return NULL;
 
 	return map;
diff -puN mm/sparse.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes mm/sparse.c
--- a/mm/sparse.c~sparse-vmemmap-specify-vmemmap-population-range-in-bytes
+++ a/mm/sparse.c
@@ -615,11 +615,17 @@ static inline struct page *kmalloc_secti
 }
 static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
-	vmemmap_free(memmap, nr_pages);
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	vmemmap_free(start, end);
 }
 static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
-	vmemmap_free(memmap, nr_pages);
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	vmemmap_free(start, end);
 }
 #else
 static struct page *__kmalloc_section_memmap(unsigned long nr_pages)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-try-harder-to-allocate-vmemmap-blocks.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-remove-dead-debugging-code-for-pse-setups.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
x86-64-fall-back-to-regular-page-vmemmap-on-allocation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

