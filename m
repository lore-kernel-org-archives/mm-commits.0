From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 124/128] x86/mm: remove vmalloc faulting
Date: Tue, 02 Jun 2020 13:17:39 -0700
Message-ID: <20200602201739.YfeR9UO-H%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBURl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:17:41 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org

From: Joerg Roedel <jroedel@suse.de>
Subject: x86/mm: remove vmalloc faulting

Remove fault handling on vmalloc areas, as the vmalloc code now takes care
of synchronizing changes to all page-tables in the system.

Link: http://lkml.kernel.org/r/20200515140023.25469-8-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
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
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/switch_to.h |   23 ----
 arch/x86/kernel/setup_percpu.c   |    6 -
 arch/x86/mm/fault.c              |  134 -----------------------------
 arch/x86/mm/pti.c                |    8 -
 arch/x86/mm/tlb.c                |   37 --------
 5 files changed, 4 insertions(+), 204 deletions(-)

--- a/arch/x86/include/asm/switch_to.h~x86-mm-remove-vmalloc-faulting
+++ a/arch/x86/include/asm/switch_to.h
@@ -12,27 +12,6 @@ struct task_struct *__switch_to_asm(stru
 __visible struct task_struct *__switch_to(struct task_struct *prev,
 					  struct task_struct *next);
 
-/* This runs runs on the previous thread's stack. */
-static inline void prepare_switch_to(struct task_struct *next)
-{
-#ifdef CONFIG_VMAP_STACK
-	/*
-	 * If we switch to a stack that has a top-level paging entry
-	 * that is not present in the current mm, the resulting #PF will
-	 * will be promoted to a double-fault and we'll panic.  Probe
-	 * the new stack now so that vmalloc_fault can fix up the page
-	 * tables if needed.  This can only happen if we use a stack
-	 * in vmap space.
-	 *
-	 * We assume that the stack is aligned so that it never spans
-	 * more than one top-level paging entry.
-	 *
-	 * To minimize cache pollution, just follow the stack pointer.
-	 */
-	READ_ONCE(*(unsigned char *)next->thread.sp);
-#endif
-}
-
 asmlinkage void ret_from_fork(void);
 
 /*
@@ -67,8 +46,6 @@ struct fork_frame {
 
 #define switch_to(prev, next, last)					\
 do {									\
-	prepare_switch_to(next);					\
-									\
 	((last) = __switch_to_asm((prev), (next)));			\
 } while (0)
 
--- a/arch/x86/kernel/setup_percpu.c~x86-mm-remove-vmalloc-faulting
+++ a/arch/x86/kernel/setup_percpu.c
@@ -287,9 +287,9 @@ void __init setup_per_cpu_areas(void)
 	/*
 	 * Sync back kernel address range again.  We already did this in
 	 * setup_arch(), but percpu data also needs to be available in
-	 * the smpboot asm.  We can't reliably pick up percpu mappings
-	 * using vmalloc_fault(), because exception dispatch needs
-	 * percpu data.
+	 * the smpboot asm and arch_sync_kernel_mappings() doesn't sync to
+	 * swapper_pg_dir on 32-bit. The per-cpu mappings need to be available
+	 * there too.
 	 *
 	 * FIXME: Can the later sync in setup_cpu_entry_areas() replace
 	 * this call?
--- a/arch/x86/mm/fault.c~x86-mm-remove-vmalloc-faulting
+++ a/arch/x86/mm/fault.c
@@ -215,44 +215,6 @@ void arch_sync_kernel_mappings(unsigned
 }
 
 /*
- * 32-bit:
- *
- *   Handle a fault on the vmalloc or module mapping area
- */
-static noinline int vmalloc_fault(unsigned long address)
-{
-	unsigned long pgd_paddr;
-	pmd_t *pmd_k;
-	pte_t *pte_k;
-
-	/* Make sure we are in vmalloc area: */
-	if (!(address >= VMALLOC_START && address < VMALLOC_END))
-		return -1;
-
-	/*
-	 * Synchronize this task's top level page-table
-	 * with the 'reference' page table.
-	 *
-	 * Do _not_ use "current" here. We might be inside
-	 * an interrupt in the middle of a task switch..
-	 */
-	pgd_paddr = read_cr3_pa();
-	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
-	if (!pmd_k)
-		return -1;
-
-	if (pmd_large(*pmd_k))
-		return 0;
-
-	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k))
-		return -1;
-
-	return 0;
-}
-NOKPROBE_SYMBOL(vmalloc_fault);
-
-/*
  * Did it hit the DOS screen memory VA from vm86 mode?
  */
 static inline void
@@ -316,79 +278,6 @@ out:
 
 #else /* CONFIG_X86_64: */
 
-/*
- * 64-bit:
- *
- *   Handle a fault on the vmalloc area
- */
-static noinline int vmalloc_fault(unsigned long address)
-{
-	pgd_t *pgd, *pgd_k;
-	p4d_t *p4d, *p4d_k;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	/* Make sure we are in vmalloc area: */
-	if (!(address >= VMALLOC_START && address < VMALLOC_END))
-		return -1;
-
-	/*
-	 * Copy kernel mappings over when needed. This can also
-	 * happen within a race in page table update. In the later
-	 * case just flush:
-	 */
-	pgd = (pgd_t *)__va(read_cr3_pa()) + pgd_index(address);
-	pgd_k = pgd_offset_k(address);
-	if (pgd_none(*pgd_k))
-		return -1;
-
-	if (pgtable_l5_enabled()) {
-		if (pgd_none(*pgd)) {
-			set_pgd(pgd, *pgd_k);
-			arch_flush_lazy_mmu_mode();
-		} else {
-			BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_k));
-		}
-	}
-
-	/* With 4-level paging, copying happens on the p4d level. */
-	p4d = p4d_offset(pgd, address);
-	p4d_k = p4d_offset(pgd_k, address);
-	if (p4d_none(*p4d_k))
-		return -1;
-
-	if (p4d_none(*p4d) && !pgtable_l5_enabled()) {
-		set_p4d(p4d, *p4d_k);
-		arch_flush_lazy_mmu_mode();
-	} else {
-		BUG_ON(p4d_pfn(*p4d) != p4d_pfn(*p4d_k));
-	}
-
-	BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS < 4);
-
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud))
-		return -1;
-
-	if (pud_large(*pud))
-		return 0;
-
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd))
-		return -1;
-
-	if (pmd_large(*pmd))
-		return 0;
-
-	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
-		return -1;
-
-	return 0;
-}
-NOKPROBE_SYMBOL(vmalloc_fault);
-
 #ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
 KERN_ERR 
@@ -1227,29 +1116,6 @@ do_kern_addr_fault(struct pt_regs *regs,
 	 */
 	WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
-	/*
-	 * We can fault-in kernel-space virtual memory on-demand. The
-	 * 'reference' page table is init_mm.pgd.
-	 *
-	 * NOTE! We MUST NOT take any locks for this case. We may
-	 * be in an interrupt or a critical region, and should
-	 * only copy the information from the master page table,
-	 * nothing more.
-	 *
-	 * Before doing this on-demand faulting, ensure that the
-	 * fault is not any of the following:
-	 * 1. A fault on a PTE with a reserved bit set.
-	 * 2. A fault caused by a user-mode access.  (Do not demand-
-	 *    fault kernel memory due to user-mode accesses).
-	 * 3. A fault caused by a page-level protection violation.
-	 *    (A demand fault would be on a non-present page which
-	 *     would have X86_PF_PROT==0).
-	 */
-	if (!(hw_error_code & (X86_PF_RSVD | X86_PF_USER | X86_PF_PROT))) {
-		if (vmalloc_fault(address) >= 0)
-			return;
-	}
-
 	/* Was the fault spurious, caused by lazy TLB invalidation? */
 	if (spurious_kernel_fault(hw_error_code, address))
 		return;
--- a/arch/x86/mm/pti.c~x86-mm-remove-vmalloc-faulting
+++ a/arch/x86/mm/pti.c
@@ -448,13 +448,7 @@ static void __init pti_clone_user_shared
 		 * the sp1 and sp2 slots.
 		 *
 		 * This is done for all possible CPUs during boot to ensure
-		 * that it's propagated to all mms.  If we were to add one of
-		 * these mappings during CPU hotplug, we would need to take
-		 * some measure to make sure that every mm that subsequently
-		 * ran on that CPU would have the relevant PGD entry in its
-		 * pagetables.  The usual vmalloc_fault() mechanism would not
-		 * work for page faults taken in entry_SYSCALL_64 before RSP
-		 * is set up.
+		 * that it's propagated to all mms.
 		 */
 
 		unsigned long va = (unsigned long)&per_cpu(cpu_tss_rw, cpu);
--- a/arch/x86/mm/tlb.c~x86-mm-remove-vmalloc-faulting
+++ a/arch/x86/mm/tlb.c
@@ -161,34 +161,6 @@ void switch_mm(struct mm_struct *prev, s
 	local_irq_restore(flags);
 }
 
-static void sync_current_stack_to_mm(struct mm_struct *mm)
-{
-	unsigned long sp = current_stack_pointer;
-	pgd_t *pgd = pgd_offset(mm, sp);
-
-	if (pgtable_l5_enabled()) {
-		if (unlikely(pgd_none(*pgd))) {
-			pgd_t *pgd_ref = pgd_offset_k(sp);
-
-			set_pgd(pgd, *pgd_ref);
-		}
-	} else {
-		/*
-		 * "pgd" is faked.  The top level entries are "p4d"s, so sync
-		 * the p4d.  This compiles to approximately the same code as
-		 * the 5-level case.
-		 */
-		p4d_t *p4d = p4d_offset(pgd, sp);
-
-		if (unlikely(p4d_none(*p4d))) {
-			pgd_t *pgd_ref = pgd_offset_k(sp);
-			p4d_t *p4d_ref = p4d_offset(pgd_ref, sp);
-
-			set_p4d(p4d, *p4d_ref);
-		}
-	}
-}
-
 static inline unsigned long mm_mangle_tif_spec_ib(struct task_struct *next)
 {
 	unsigned long next_tif = task_thread_info(next)->flags;
@@ -377,15 +349,6 @@ void switch_mm_irqs_off(struct mm_struct
 		 */
 		cond_ibpb(tsk);
 
-		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
-			/*
-			 * If our current stack is in vmalloc space and isn't
-			 * mapped in the new pgd, we'll double-fault.  Forcibly
-			 * map it.
-			 */
-			sync_current_stack_to_mm(next);
-		}
