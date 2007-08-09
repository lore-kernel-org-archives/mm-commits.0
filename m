From: akpm@linux-foundation.org
Subject: + flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:47:39 -0700
Message-ID: <200708092047.l79KldUL018659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120AbXHIUxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, davem@davemloft.net, hugh@veritas.com, nickpiggin@yahoo.com.au, tony.luck@intel.com


The patch titled
     flush icache before set_pte() on ia64: flush icache at set_pte
has been added to the -mm tree.  Its filename is
     flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: flush icache before set_pte() on ia64: flush icache at set_pte
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Current ia64 kernel flushes icache by lazy_mmu_prot_update() *after*
set_pte().  This is too late.  This patch removes lazy_mmu_prot_update and
add modfied set_pte() for flushing if necessary.

This patch flush icache of a page when
	new pte has exec bit.
	&& new pte has present bit
	&& new pte is user's page.
	&& (old *ptep is not present
            || new pte's pfn is not same to old *ptep's ptn)
	&& new pte's page has no Pg_arch_1 bit.
	   Pg_arch_1 is set when a page is cache consistent.

I think this condition checks are much easier to understand than considering
"Where sync_icache_dcache() should be inserted ?".

pte_user() for ia64 was removed by http://lkml.org/lkml/2007/6/12/67 as
clean-up. So, I added it again.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cachetlb.txt    |    6 ----
 arch/ia64/mm/init.c           |    5 +---
 include/asm-generic/pgtable.h |    4 ---
 include/asm-ia64/pgtable.h    |   39 +++++++++++++++++++++-----------
 mm/hugetlb.c                  |    2 -
 mm/memory.c                   |    8 ------
 mm/migrate.c                  |    1 
 mm/mprotect.c                 |    1 
 mm/rmap.c                     |    1 
 9 files changed, 29 insertions(+), 38 deletions(-)

diff -puN Documentation/cachetlb.txt~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/Documentation/cachetlb.txt
@@ -133,12 +133,6 @@ changes occur:
 	The ia64 sn2 platform is one example of a platform
 	that uses this interface.
 
-8) void lazy_mmu_prot_update(pte_t pte)
-	This interface is called whenever the protection on
-	any user PTEs change.  This interface provides a notification
-	to architecture specific code to take appropriate action.
-
-
 Next, we have the cache flushing interfaces.  In general, when Linux
 is changing an existing virtual-->physical mapping to a new value,
 the sequence will be in one of the following forms:
diff -puN arch/ia64/mm/init.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/arch/ia64/mm/init.c
@@ -54,14 +54,13 @@ struct page *zero_page_memmap_ptr;	/* ma
 EXPORT_SYMBOL(zero_page_memmap_ptr);
 
 void
-lazy_mmu_prot_update (pte_t pte)
+__ia64_sync_icache_dcache (pte_t pte)
 {
 	unsigned long addr;
 	struct page *page;
 	unsigned long order;
 
-	if (!pte_exec(pte))
-		return;				/* not an executable page... */
+	BUG_ON(!pte_exec(pte));
 
 	page = pte_page(pte);
 	addr = (unsigned long) page_address(page);
diff -puN include/asm-generic/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/include/asm-generic/pgtable.h
@@ -125,10 +125,6 @@ static inline void ptep_set_wrprotect(st
 #define pgd_offset_gate(mm, addr)	pgd_offset(mm, addr)
 #endif
 
-#ifndef __HAVE_ARCH_LAZY_MMU_PROT_UPDATE
-#define lazy_mmu_prot_update(pte)	do { } while (0)
-#endif
-
 #ifndef __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
diff -puN include/asm-ia64/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/include/asm-ia64/pgtable.h
@@ -223,12 +223,6 @@ ia64_phys_addr_valid (unsigned long addr
  * page table.
  */
 
-/*
- * On some architectures, special things need to be done when setting
- * the PTE in a page table.  Nothing special needs to be on IA-64.
- */
-#define set_pte(ptep, pteval)	(*(ptep) = (pteval))
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
 #define VMALLOC_START		(RGN_BASE(RGN_GATE) + 0x200000000UL)
 #ifdef CONFIG_VIRTUAL_MEM_MAP
@@ -303,6 +297,7 @@ ia64_phys_addr_valid (unsigned long addr
 /*
  * The following have defined behavior only work if pte_present() is true.
  */
+#define pte_user(pte)	((pte_val(pte) & _PAGE_PL_MASK) == _PAGE_PL_3)
 #define pte_write(pte)	((unsigned) (((pte_val(pte) & _PAGE_AR_MASK) >> _PAGE_AR_SHIFT) - 2) <= 4)
 #define pte_exec(pte)		((pte_val(pte) & _PAGE_AR_RX) != 0)
 #define pte_dirty(pte)		((pte_val(pte) & _PAGE_D) != 0)
@@ -321,6 +316,30 @@ ia64_phys_addr_valid (unsigned long addr
 #define pte_mkhuge(pte)		(__pte(pte_val(pte)))
 
 /*
+ * Because ia64's Icache and Dcache is not coherent (on a cpu), we need to
+ * sync icache and dcache when we insert *new* executable page.
+ *  __ia64_sync_icache_dcache() check Pg_arch_1 bit and flush icache
+ * if necessary.
+ *
+ *  set_pte() is also called by the kernel, but we can expect that the kernel
+ *  flushes icache explicitly if necessary.
+ */
+extern void __ia64_sync_icache_dcache(pte_t pteval);
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	if (pte_exec(pteval) &&    // flush only new executable page.
+	    pte_present(pteval) && // swap out ?
+	    pte_user(pteval) &&    // ignore kernel page
+	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
+		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
+		/* load_module() calles flush_icache_range() explicitly*/
+		__ia64_sync_icache_dcache(pteval);
+	*ptep = pteval;
+}
+
+#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+
+/*
  * Make page protection values cacheable, uncacheable, or write-
  * combining.  Note that "protection" is really a misnomer here as the
  * protection value contains the memory attribute bits, dirty bits, and
@@ -489,12 +508,6 @@ extern struct page *zero_page_memmap_ptr
 #define HUGETLB_PGDIR_MASK	(~(HUGETLB_PGDIR_SIZE-1))
 #endif
 
-/*
- * IA-64 doesn't have any external MMU info: the page tables contain all the necessary
- * information.  However, we use this routine to take care of any (delayed) i-cache
- * flushing that may be necessary.
- */
-extern void lazy_mmu_prot_update (pte_t pte);
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
@@ -584,7 +597,7 @@ extern void lazy_mmu_prot_update (pte_t 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
 #define __HAVE_ARCH_PGD_OFFSET_GATE
-#define __HAVE_ARCH_LAZY_MMU_PROT_UPDATE
+
 
 #ifndef CONFIG_PGTABLE_4
 #include <asm-generic/pgtable-nopud.h>
diff -puN mm/hugetlb.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte mm/hugetlb.c
--- a/mm/hugetlb.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/mm/hugetlb.c
@@ -353,7 +353,6 @@ static void set_huge_ptep_writable(struc
 	entry = pte_mkwrite(pte_mkdirty(*ptep));
 	if (ptep_set_access_flags(vma, address, ptep, entry, 1)) {
 		update_mmu_cache(vma, address, entry);
-		lazy_mmu_prot_update(entry);
 	}
 }
 
@@ -706,7 +705,6 @@ void hugetlb_change_protection(struct vm
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(pte_modify(pte, newprot));
 			set_huge_pte_at(mm, address, ptep, pte);
-			lazy_mmu_prot_update(pte);
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
diff -puN mm/memory.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte mm/memory.c
--- a/mm/memory.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/mm/memory.c
@@ -1608,10 +1608,8 @@ static int do_wp_page(struct mm_struct *
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		if (ptep_set_access_flags(vma, address, page_table, entry,1)) {
+		if (ptep_set_access_flags(vma, address, page_table, entry,1))
 			update_mmu_cache(vma, address, entry);
-			lazy_mmu_prot_update(entry);
-		}
 		ret |= VM_FAULT_WRITE;
 		goto unlock;
 	}
@@ -1647,7 +1645,6 @@ gotten:
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		lazy_mmu_prot_update(entry);
 		/*
 		 * Clear the pte entry and flush it first, before updating the
 		 * pte with the new entry. This will avoid a race condition
@@ -2177,7 +2174,6 @@ static int do_anonymous_page(struct mm_s
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, address, entry);
-	lazy_mmu_prot_update(entry);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	return 0;
@@ -2328,7 +2324,6 @@ static int __do_fault(struct mm_struct *
 
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, entry);
-		lazy_mmu_prot_update(entry);
 	} else {
 		if (anon)
 			page_cache_release(page);
@@ -2502,7 +2497,6 @@ static inline int handle_pte_fault(struc
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
 		update_mmu_cache(vma, address, entry);
-		lazy_mmu_prot_update(entry);
 	} else {
 		/*
 		 * This is needed only for protection faults but the arch code
diff -puN mm/migrate.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte mm/migrate.c
--- a/mm/migrate.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/mm/migrate.c
@@ -181,7 +181,6 @@ static void remove_migration_pte(struct 
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, addr, pte);
-	lazy_mmu_prot_update(pte);
 
 out:
 	pte_unmap_unlock(ptep, ptl);
diff -puN mm/mprotect.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte mm/mprotect.c
--- a/mm/mprotect.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/mm/mprotect.c
@@ -53,7 +53,6 @@ static void change_pte_range(struct mm_s
 			if (dirty_accountable && pte_dirty(ptent))
 				ptent = pte_mkwrite(ptent);
 			set_pte_at(mm, addr, pte, ptent);
-			lazy_mmu_prot_update(ptent);
 #ifdef CONFIG_MIGRATION
 		} else if (!pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
diff -puN mm/rmap.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte mm/rmap.c
--- a/mm/rmap.c~flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte
+++ a/mm/rmap.c
@@ -436,7 +436,6 @@ static int page_mkclean_one(struct page 
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
-		lazy_mmu_prot_update(entry);
 		ret = 1;
 	}
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memory-hotplug-document-take-3.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-icache-before-set_pte-on-ia64-migration-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
