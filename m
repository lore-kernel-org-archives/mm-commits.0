From: akpm@linux-foundation.org
Subject: [merged] mm-remove-vmalloc_sync_unmappings.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:43:11 -0700
Message-ID: <20200602214311.l1KEXeecG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org


The patch titled
     Subject: mm: remove vmalloc_sync_(un)mappings()
has been removed from the -mm tree.  Its filename was
     mm-remove-vmalloc_sync_unmappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joerg Roedel <jroedel@suse.de>
Subject: mm: remove vmalloc_sync_(un)mappings()

These functions are not needed anymore because the vmalloc and ioremap
mappings are now synchronized when they are created or teared down.

Remove all callers and function definitions.

Link: http://lkml.kernel.org/r/20200515140023.25469-7-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c      |   37 -------------------------------------
 drivers/acpi/apei/ghes.c |    6 ------
 include/linux/vmalloc.h  |    2 --
 kernel/notifier.c        |    1 -
 kernel/trace/trace.c     |   12 ------------
 mm/nommu.c               |   12 ------------
 mm/vmalloc.c             |   21 ---------------------
 7 files changed, 91 deletions(-)

--- a/arch/x86/mm/fault.c~mm-remove-vmalloc_sync_unmappings
+++ a/arch/x86/mm/fault.c
@@ -214,26 +214,6 @@ void arch_sync_kernel_mappings(unsigned
 	}
 }
 
-static void vmalloc_sync(void)
-{
-	unsigned long address;
-
-	if (SHARED_KERNEL_PMD)
-		return;
-
-	arch_sync_kernel_mappings(VMALLOC_START, VMALLOC_END);
-}
-
-void vmalloc_sync_mappings(void)
-{
-	vmalloc_sync();
-}
-
-void vmalloc_sync_unmappings(void)
-{
-	vmalloc_sync();
-}
-
 /*
  * 32-bit:
  *
@@ -336,23 +316,6 @@ out:
 
 #else /* CONFIG_X86_64: */
 
-void vmalloc_sync_mappings(void)
-{
-	/*
-	 * 64-bit mappings might allocate new p4d/pud pages
-	 * that need to be propagated to all tasks' PGDs.
-	 */
-	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
-}
-
-void vmalloc_sync_unmappings(void)
-{
-	/*
-	 * Unmappings never allocate or free p4d/pud pages.
-	 * No work is required here.
-	 */
-}
-
 /*
  * 64-bit:
  *
--- a/drivers/acpi/apei/ghes.c~mm-remove-vmalloc_sync_unmappings
+++ a/drivers/acpi/apei/ghes.c
@@ -167,12 +167,6 @@ int ghes_estatus_pool_init(int num_ghes)
 	if (!addr)
 		goto err_pool_alloc;
 
-	/*
-	 * New allocation must be visible in all pgd before it can be found by
-	 * an NMI allocating from the pool.
-	 */
-	vmalloc_sync_mappings();
-
 	rc = gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
 	if (rc)
 		goto err_pool_add;
--- a/include/linux/vmalloc.h~mm-remove-vmalloc_sync_unmappings
+++ a/include/linux/vmalloc.h
@@ -130,8 +130,6 @@ extern int remap_vmalloc_range_partial(s
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
-void vmalloc_sync_mappings(void);
-void vmalloc_sync_unmappings(void);
 
 /*
  * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
--- a/kernel/notifier.c~mm-remove-vmalloc_sync_unmappings
+++ a/kernel/notifier.c
@@ -519,7 +519,6 @@ NOKPROBE_SYMBOL(notify_die);
 
 int register_die_notifier(struct notifier_block *nb)
 {
-	vmalloc_sync_mappings();
 	return atomic_notifier_chain_register(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(register_die_notifier);
--- a/kernel/trace/trace.c~mm-remove-vmalloc_sync_unmappings
+++ a/kernel/trace/trace.c
@@ -8527,18 +8527,6 @@ static int allocate_trace_buffers(struct
 	allocate_snapshot = false;
 #endif
 
-	/*
-	 * Because of some magic with the way alloc_percpu() works on
-	 * x86_64, we need to synchronize the pgd of all the tables,
-	 * otherwise the trace events that happen in x86_64 page fault
-	 * handlers can't cope with accessing the chance that a
-	 * alloc_percpu()'d memory might be touched in the page fault trace
-	 * event. Oh, and we need to audit all other alloc_percpu() and vmalloc()
-	 * calls in tracing, because something might get triggered within a
-	 * page fault trace event!
-	 */
-	vmalloc_sync_mappings();
-
 	return 0;
 }
 
--- a/mm/nommu.c~mm-remove-vmalloc_sync_unmappings
+++ a/mm/nommu.c
@@ -371,18 +371,6 @@ void vm_unmap_aliases(void)
 }
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
-/*
- * Implement a stub for vmalloc_sync_[un]mapping() if the architecture
- * chose not to have one.
- */
-void __weak vmalloc_sync_mappings(void)
-{
-}
-
-void __weak vmalloc_sync_unmappings(void)
-{
-}
-
 struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
 {
 	BUG();
--- a/mm/vmalloc.c~mm-remove-vmalloc_sync_unmappings
+++ a/mm/vmalloc.c
@@ -1354,12 +1354,6 @@ static bool __purge_vmap_area_lazy(unsig
 		return false;
 
 	/*
-	 * First make sure the mappings are removed from all page-tables
-	 * before they are freed.
-	 */
-	vmalloc_sync_unmappings();
-
-	/*
 	 * TODO: to calculate a flush range without looping.
 	 * The list can be up to lazy_max_pages() elements.
 	 */
@@ -3089,21 +3083,6 @@ int remap_vmalloc_range(struct vm_area_s
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
-/*
- * Implement stubs for vmalloc_sync_[un]mappings () if the architecture chose
- * not to have one.
- *
- * The purpose of this function is to make sure the vmalloc area
- * mappings are identical in all page-tables in the system.
- */
-void __weak vmalloc_sync_mappings(void)
-{
-}
-
-void __weak vmalloc_sync_unmappings(void)
-{
-}
