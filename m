From: akpm@linux-foundation.org
Subject: + quicklist-support-for-ia64.patch added to -mm tree
Date: Mon, 09 Apr 2007 14:19:51 -0700
Message-ID: <200704092119.l39LJp1F023748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXDIVUC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 17:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, davem@davemloft.net, tony.luck@intel.com, wli@holomorphy.com


The patch titled
     Quicklist support for IA64
has been added to the -mm tree.  Its filename is
     quicklist-support-for-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Quicklist support for IA64
From: Christoph Lameter <clameter@sgi.com>

IA64 is the origin of the quicklist implementation.  So cut out the pieces
that are now in core code and modify the functions called.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig          |    4 +
 arch/ia64/mm/contig.c      |    2 
 arch/ia64/mm/discontig.c   |    2 
 arch/ia64/mm/init.c        |   51 ---------------------
 include/asm-ia64/pgalloc.h |   82 ++++++-----------------------------
 5 files changed, 22 insertions(+), 119 deletions(-)

diff -puN arch/ia64/Kconfig~quicklist-support-for-ia64 arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~quicklist-support-for-ia64
+++ a/arch/ia64/Kconfig
@@ -30,6 +30,10 @@ config ZONE_DMA
 	def_bool y
 	depends on !IA64_SGI_SN2
 
+config QUICKLIST
+	bool
+	default y
+
 config MMU
 	bool
 	default y
diff -puN arch/ia64/mm/contig.c~quicklist-support-for-ia64 arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~quicklist-support-for-ia64
+++ a/arch/ia64/mm/contig.c
@@ -88,7 +88,7 @@ void show_mem(void)
 	printk(KERN_INFO "%d pages shared\n", total_shared);
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       pgtable_quicklist_total_size());
+	       quicklist_total_size());
 	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
 }
 
diff -puN arch/ia64/mm/discontig.c~quicklist-support-for-ia64 arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~quicklist-support-for-ia64
+++ a/arch/ia64/mm/discontig.c
@@ -561,7 +561,7 @@ void show_mem(void)
 	printk(KERN_INFO "%d pages shared\n", total_shared);
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
-	       pgtable_quicklist_total_size());
+	       quicklist_total_size());
 	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
 }
 
diff -puN arch/ia64/mm/init.c~quicklist-support-for-ia64 arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~quicklist-support-for-ia64
+++ a/arch/ia64/mm/init.c
@@ -39,9 +39,6 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-DEFINE_PER_CPU(unsigned long *, __pgtable_quicklist);
-DEFINE_PER_CPU(long, __pgtable_quicklist_size);
-
 extern void ia64_tlb_init (void);
 
 unsigned long MAX_DMA_ADDRESS = PAGE_OFFSET + 0x100000000UL;
@@ -56,54 +53,6 @@ EXPORT_SYMBOL(vmem_map);
 struct page *zero_page_memmap_ptr;	/* map entry for zero page */
 EXPORT_SYMBOL(zero_page_memmap_ptr);
 
-#define MIN_PGT_PAGES			25UL
-#define MAX_PGT_FREES_PER_PASS		16L
-#define PGT_FRACTION_OF_NODE_MEM	16
-
-static inline long
-max_pgt_pages(void)
-{
-	u64 node_free_pages, max_pgt_pages;
-
-#ifndef	CONFIG_NUMA
-	node_free_pages = nr_free_pages();
-#else
-	node_free_pages = node_page_state(numa_node_id(), NR_FREE_PAGES);
-#endif
-	max_pgt_pages = node_free_pages / PGT_FRACTION_OF_NODE_MEM;
-	max_pgt_pages = max(max_pgt_pages, MIN_PGT_PAGES);
-	return max_pgt_pages;
-}
-
-static inline long
-min_pages_to_free(void)
-{
-	long pages_to_free;
-
-	pages_to_free = pgtable_quicklist_size - max_pgt_pages();
-	pages_to_free = min(pages_to_free, MAX_PGT_FREES_PER_PASS);
-	return pages_to_free;
-}
-
-void
-check_pgt_cache(void)
-{
-	long pages_to_free;
-
-	if (unlikely(pgtable_quicklist_size <= MIN_PGT_PAGES))
-		return;
-
-	preempt_disable();
-	while (unlikely((pages_to_free = min_pages_to_free()) > 0)) {
-		while (pages_to_free--) {
-			free_page((unsigned long)pgtable_quicklist_alloc());
-		}
-		preempt_enable();
-		preempt_disable();
-	}
-	preempt_enable();
-}
-
 void
 lazy_mmu_prot_update (pte_t pte)
 {
diff -puN include/asm-ia64/pgalloc.h~quicklist-support-for-ia64 include/asm-ia64/pgalloc.h
--- a/include/asm-ia64/pgalloc.h~quicklist-support-for-ia64
+++ a/include/asm-ia64/pgalloc.h
@@ -18,71 +18,18 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/threads.h>
+#include <linux/quicklist.h>
 
 #include <asm/mmu_context.h>
 
-DECLARE_PER_CPU(unsigned long *, __pgtable_quicklist);
-#define pgtable_quicklist __ia64_per_cpu_var(__pgtable_quicklist)
-DECLARE_PER_CPU(long, __pgtable_quicklist_size);
-#define pgtable_quicklist_size __ia64_per_cpu_var(__pgtable_quicklist_size)
-
-static inline long pgtable_quicklist_total_size(void)
-{
-	long ql_size = 0;
-	int cpuid;
-
-	for_each_online_cpu(cpuid) {
-		ql_size += per_cpu(__pgtable_quicklist_size, cpuid);
-	}
-	return ql_size;
-}
-
-static inline void *pgtable_quicklist_alloc(void)
-{
-	unsigned long *ret = NULL;
-
-	preempt_disable();
-
-	ret = pgtable_quicklist;
-	if (likely(ret != NULL)) {
-		pgtable_quicklist = (unsigned long *)(*ret);
-		ret[0] = 0;
-		--pgtable_quicklist_size;
-		preempt_enable();
-	} else {
-		preempt_enable();
-		ret = (unsigned long *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-	}
-
-	return ret;
-}
-
-static inline void pgtable_quicklist_free(void *pgtable_entry)
-{
-#ifdef CONFIG_NUMA
-	int nid = page_to_nid(virt_to_page(pgtable_entry));
-
-	if (unlikely(nid != numa_node_id())) {
-		free_page((unsigned long)pgtable_entry);
-		return;
-	}
-#endif
-
-	preempt_disable();
-	*(unsigned long *)pgtable_entry = (unsigned long)pgtable_quicklist;
-	pgtable_quicklist = (unsigned long *)pgtable_entry;
-	++pgtable_quicklist_size;
-	preempt_enable();
-}
-
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pgd_free(pgd_t * pgd)
 {
-	pgtable_quicklist_free(pgd);
+	quicklist_free(0, NULL, pgd);
 }
 
 #ifdef CONFIG_PGTABLE_4
@@ -94,12 +41,12 @@ pgd_populate(struct mm_struct *mm, pgd_t
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pud_free(pud_t * pud)
 {
-	pgtable_quicklist_free(pud);
+	quicklist_free(0, NULL, pud);
 }
 #define __pud_free_tlb(tlb, pud)	pud_free(pud)
 #endif /* CONFIG_PGTABLE_4 */
@@ -112,12 +59,12 @@ pud_populate(struct mm_struct *mm, pud_t
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pmd_free(pmd_t * pmd)
 {
-	pgtable_quicklist_free(pmd);
+	quicklist_free(0, NULL, pmd);
 }
 
 #define __pmd_free_tlb(tlb, pmd)	pmd_free(pmd)
@@ -137,28 +84,31 @@ pmd_populate_kernel(struct mm_struct *mm
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 					 unsigned long addr)
 {
-	void *pg = pgtable_quicklist_alloc();
+	void *pg = quicklist_alloc(0, GFP_KERNEL, NULL);
 	return pg ? virt_to_page(pg) : NULL;
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long addr)
 {
-	return pgtable_quicklist_alloc();
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pte_free(struct page *pte)
 {
-	pgtable_quicklist_free(page_address(pte));
+	quicklist_free_page(0, NULL, pte);
 }
 
 static inline void pte_free_kernel(pte_t * pte)
 {
-	pgtable_quicklist_free(pte);
+	quicklist_free(0, NULL, pte);
 }
 
-#define __pte_free_tlb(tlb, pte)	pte_free(pte)
+static inline void check_pgt_cache(void)
+{
+	quicklist_trim(0, NULL, 25, 16);
+}
 
-extern void check_pgt_cache(void);
+#define __pte_free_tlb(tlb, pte)	pte_free(pte)
 
 #endif				/* _ASM_IA64_PGALLOC_H */
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
