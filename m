From: akpm@linux-foundation.org
Subject: + uml-cover-stubs-with-a-vma.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:22:15 -0800
Message-ID: <200711200022.lAK0MGSd004187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbXKTAWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:22:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: cover stubs with a VMA
has been added to the -mm tree.  Its filename is
     uml-cover-stubs-with-a-vma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: cover stubs with a VMA
From: Jeff Dike <jdike@addtoit.com>

Give the stubs a VMA.  This allows the removal of a truly nasty kludge
to make sure that mm->nr_ptes was correct in exit_mmap.  The
underlying problem was always that the stubs, which have ptes, and
thus allocated a page table, weren't covered by a VMA.

This patch fixes that by using install_special_mapping in
arch_dup_mmap and activate_context to create the VMA.  The stubs have
to be moved, since shift_arg_pages seems to assume that the stack is
the only VMA present at that point during exec, and uses vma_adjust to
fiddle its VMA.  However, that extends the stub VMA by the amount
removed from the stack VMA.

To avoid this problem, the stubs were moved to a different fixed
location at the start of the address space.

arch_exit_mmap is used to clear the stub ptes at exit time.

The STUB_* constants in as-layout.h no longer depend on UM_TASK_SIZE,
so that definition is removed, along with the comments complaining
about gcc.

Because the stubs are no longer at the top of the address space, some
care is needed while flushing TLBs.  update_pte_range checks for
addresses in the stub range and skips them.  flush_thread now issues
two unmaps, one for the range before STUB_START and one for the range
after STUB_END.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/as-layout.h      |   19 +-----
 arch/um/include/common-offsets.h |    3 -
 arch/um/kernel/exec.c            |    5 +
 arch/um/kernel/skas/mmu.c        |   86 ++++++++++++++++-------------
 arch/um/kernel/tlb.c             |   11 +--
 include/asm-um/mmu_context.h     |    7 +-
 6 files changed, 66 insertions(+), 65 deletions(-)

diff -puN arch/um/include/as-layout.h~uml-cover-stubs-with-a-vma arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-cover-stubs-with-a-vma
+++ a/arch/um/include/as-layout.h
@@ -29,21 +29,10 @@
 #define _AC(X, Y)	__AC(X, Y)
 #endif
 
-/*
- * The "- 1"'s are to avoid gcc complaining about integer overflows
- * and unrepresentable decimal constants.  With 3-level page tables,
- * TASK_SIZE is 0x80000000, which gets turned into its signed decimal
- * equivalent in asm-offsets.s.  gcc then complains about that being
- * unsigned only in C90.  To avoid that, UM_TASK_SIZE is defined as
- * TASK_SIZE - 1.  To compensate, we need to add the 1 back here.
- * However, adding it back to UM_TASK_SIZE produces more gcc
- * complaints.  So, I adjust the thing being subtracted from
- * UM_TASK_SIZE instead.  Bah.
- */
-#define STUB_CODE _AC((unsigned long), \
-		      UM_TASK_SIZE - (2 * UM_KERN_PAGE_SIZE - 1))
-#define STUB_DATA _AC((unsigned long), UM_TASK_SIZE - (UM_KERN_PAGE_SIZE - 1))
-#define STUB_START _AC(, STUB_CODE)
+#define STUB_START _AC(, 0x100000)
+#define STUB_CODE _AC((unsigned long), STUB_START)
+#define STUB_DATA _AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
+#define STUB_END _AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
 
 #ifndef __ASSEMBLY__
 
diff -puN arch/um/include/common-offsets.h~uml-cover-stubs-with-a-vma arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-cover-stubs-with-a-vma
+++ a/arch/um/include/common-offsets.h
@@ -39,6 +39,3 @@ DEFINE(UM_HZ, HZ);
 DEFINE(UM_USEC_PER_SEC, USEC_PER_SEC);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
-
-/* See as-layout.h for an explanation of the "- 1".  Bah. */
-DEFINE(UM_TASK_SIZE, TASK_SIZE - 1);
diff -puN arch/um/kernel/exec.c~uml-cover-stubs-with-a-vma arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-cover-stubs-with-a-vma
+++ a/arch/um/kernel/exec.c
@@ -19,12 +19,13 @@
 void flush_thread(void)
 {
 	void *data = NULL;
-	unsigned long end = proc_mm ? TASK_SIZE : STUB_START;
 	int ret;
 
 	arch_flush_thread(&current->thread.arch);
 
-	ret = unmap(&current->mm->context.id, 0, end, 1, &data);
+	ret = unmap(&current->mm->context.id, 0, STUB_START, 0, &data);
+	ret = ret || unmap(&current->mm->context.id, STUB_END,
+			   TASK_SIZE - STUB_END, 1, &data);
 	if (ret) {
 		printk(KERN_ERR "flush_thread - clearing address space failed, "
 		       "err = %d\n", ret);
diff -puN arch/um/kernel/skas/mmu.c~uml-cover-stubs-with-a-vma arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-cover-stubs-with-a-vma
+++ a/arch/um/kernel/skas/mmu.c
@@ -34,25 +34,6 @@ static int init_stub_pte(struct mm_struc
 	if (!pte)
 		goto out_pte;
 
-	/*
-	 * There's an interaction between the skas0 stub pages, stack
-	 * randomization, and the BUG at the end of exit_mmap.  exit_mmap
-	 * checks that the number of page tables freed is the same as had
-	 * been allocated.  If the stack is on the last page table page,
-	 * then the stack pte page will be freed, and if not, it won't.  To
-	 * avoid having to know where the stack is, or if the process mapped
-	 * something at the top of its address space for some other reason,
-	 * we set TASK_SIZE to end at the start of the last page table.
-	 * This keeps exit_mmap off the last page, but introduces a leak
-	 * of that page.  So, we hang onto it here and free it in
-	 * destroy_context_skas.
-	 */
-
-	mm->context.last_page_table = pmd_page_vaddr(*pmd);
-#ifdef CONFIG_3_LEVEL_PGTABLES
-	mm->context.last_pmd = (unsigned long) __va(pud_val(*pud));
-#endif
-
 	*pte = mk_pte(virt_to_page(kernel), __pgprot(_PAGE_PRESENT));
 	*pte = pte_mkread(*pte);
 	return 0;
@@ -77,13 +58,6 @@ int init_new_context(struct task_struct 
 		if (stack == 0)
 			goto out;
 
-		/*
-		 * This zeros the entry that pgd_alloc didn't, needed since
-		 * we are about to reinitialize it, and want mm.nr_ptes to
-		 * be accurate.
-		 */
-		mm->pgd[USER_PTRS_PER_PGD] = __pgd(0);
-
 		ret = init_stub_pte(mm, STUB_CODE,
 				    (unsigned long) &__syscall_stub_start);
 		if (ret)
@@ -92,8 +66,6 @@ int init_new_context(struct task_struct 
 		ret = init_stub_pte(mm, STUB_DATA, stack);
 		if (ret)
 			goto out_free;
-
-		mm->nr_ptes--;
 	}
 
 	to_mm->id.stack = stack;
@@ -132,6 +104,55 @@ int init_new_context(struct task_struct 
 	return ret;
 }
 
+void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	struct page **pages;
+	int err;
+
+	if (!skas_needs_stub)
+		return;
+
+	pages = kmalloc(2 * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL) {
+		printk(KERN_ERR "arch_dup_mmap failed to allocate 2 page "
+		       "pointers\n");
+		goto out;
+	}
+
+	pages[0] = virt_to_page(&__syscall_stub_start);
+	pages[1] = virt_to_page(mm->context.id.stack);
+
+	/* dup_mmap already holds mmap_sem */
+	err = install_special_mapping(mm, STUB_START, STUB_END - STUB_START,
+				      VM_READ | VM_MAYREAD | VM_EXEC |
+				      VM_MAYEXEC | VM_DONTCOPY, pages);
+	if (err) {
+		printk(KERN_ERR "install_special_mapping returned %d\n", err);
+		goto out_free;
+	}
+	return;
+
+out_free:
+	kfree(pages);
+out:
+	force_sigsegv(SIGSEGV, current);
+}
+
+void arch_exit_mmap(struct mm_struct *mm)
+{
+	pte_t *pte;
+
+	pte = virt_to_pte(mm, STUB_CODE);
+	if (pte != NULL)
+		pte_clear(mm, STUB_CODE, pte);
+
+	pte = virt_to_pte(mm, STUB_DATA);
+	if (pte == NULL)
+		return;
+
+	pte_clear(mm, STUB_DATA, pte);
+}
+
 void destroy_context(struct mm_struct *mm)
 {
 	struct mm_context *mmu = &mm->context;
@@ -141,15 +162,8 @@ void destroy_context(struct mm_struct *m
 	else
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
 
-	if (!proc_mm || !ptrace_faultinfo) {
+	if (skas_needs_stub)
 		free_page(mmu->id.stack);
-		pte_lock_deinit(virt_to_page(mmu->last_page_table));
-		pte_free_kernel(mm, (pte_t *) mmu->last_page_table);
-		dec_zone_page_state(virt_to_page(mmu->last_page_table), NR_PAGETABLE);
-#ifdef CONFIG_3_LEVEL_PGTABLES
-		pmd_free(mm, (pmd_t *) mmu->last_pmd);
-#endif
-	}
 
 	free_ldt(mmu);
 }
diff -puN arch/um/kernel/tlb.c~uml-cover-stubs-with-a-vma arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-cover-stubs-with-a-vma
+++ a/arch/um/kernel/tlb.c
@@ -184,6 +184,9 @@ static inline int update_pte_range(pmd_t
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
+		if ((addr >= STUB_START) && (addr < STUB_END))
+			continue;
+
 		r = pte_read(*pte);
 		w = pte_write(*pte);
 		x = pte_exec(*pte);
@@ -486,9 +489,6 @@ void __flush_tlb_one(unsigned long addr)
 static void fix_range(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force)
 {
-	if (!proc_mm && (end_addr > STUB_START))
-		end_addr = STUB_START;
-
 	fix_range_common(mm, start_addr, end_addr, force);
 }
 
@@ -502,8 +502,6 @@ void flush_tlb_range(struct vm_area_stru
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long end;
-
 	/*
 	 * Don't bother flushing if this address space is about to be
 	 * destroyed.
@@ -511,8 +509,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	end = proc_mm ? TASK_SIZE : STUB_START;
-	fix_range(mm, 0, end, 0);
+	fix_range(mm, 0, TASK_SIZE, 0);
 }
 
 void force_flush_all(void)
diff -puN include/asm-um/mmu_context.h~uml-cover-stubs-with-a-vma include/asm-um/mmu_context.h
--- a/include/asm-um/mmu_context.h~uml-cover-stubs-with-a-vma
+++ a/include/asm-um/mmu_context.h
@@ -6,11 +6,12 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
-#include <asm-generic/mm_hooks.h>
-
 #include "linux/sched.h"
 #include "um_mmu.h"
 
+extern void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
+extern void arch_exit_mmap(struct mm_struct *mm);
+
 #define get_mmu_context(task) do ; while(0)
 #define activate_context(tsk) do ; while(0)
 
@@ -30,6 +31,8 @@ static inline void activate_mm(struct mm
 	 */
 	if (old != new && (current->flags & PF_BORROWED_MM))
 		__switch_mm(&new->context.id);
+
+	arch_dup_mmap(old, new);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-clean-up-task-size-calculation.patch
uml-add-virt_to_pte.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
