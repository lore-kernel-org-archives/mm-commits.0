From: akpm@linux-foundation.org
Subject: - uml-customize-tlbh.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:28 -0800
Message-ID: <200802052237.m15Mb9O0012830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761239AbYBEWl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: customize tlb.h
has been removed from the -mm tree.  Its filename was
     uml-customize-tlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: customize tlb.h
From: Jeff Dike <jdike@addtoit.com>

Customize the hooks in tlb.h to optimize TLB flushing some more.

Add start and end fields to tlb_gather_mmu, which are used to limit
the address space range scanned when a region is unmapped.

The interfaces which just free page tables, without actually changing
mappings, don't need to cause a TLB flush.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c |   25 ++++++--
 include/asm-um/tlb.h |  122 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 8 deletions(-)

diff -puN arch/um/kernel/tlb.c~uml-customize-tlbh arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-customize-tlbh
+++ a/arch/um/kernel/tlb.c
@@ -193,18 +193,18 @@ static inline int update_pte_range(pmd_t
 		if (!pte_young(*pte)) {
 			r = 0;
 			w = 0;
-		} else if (!pte_dirty(*pte)) {
+		} else if (!pte_dirty(*pte))
 			w = 0;
-		}
+
 		prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
 			(x ? UM_PROT_EXEC : 0));
 		if (hvc->force || pte_newpage(*pte)) {
 			if (pte_present(*pte))
 				ret = add_mmap(addr, pte_val(*pte) & PAGE_MASK,
 					       PAGE_SIZE, prot, hvc);
-			else ret = add_munmap(addr, PAGE_SIZE, hvc);
-		}
-		else if (pte_newprot(*pte))
+			else
+				ret = add_munmap(addr, PAGE_SIZE, hvc);
+		} else if (pte_newprot(*pte))
 			ret = add_mprotect(addr, PAGE_SIZE, prot, hvc);
 		*pte = pte_mkuptodate(*pte);
 	} while (pte++, addr += PAGE_SIZE, ((addr < end) && !ret));
@@ -500,7 +500,8 @@ void flush_tlb_range(struct vm_area_stru
 	else fix_range(vma->vm_mm, start, end, 0);
 }
 
-void flush_tlb_mm(struct mm_struct *mm)
+void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+			unsigned long end)
 {
 	/*
 	 * Don't bother flushing if this address space is about to be
@@ -509,7 +510,17 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if (atomic_read(&mm->mm_users) == 0)
 		return;
 
-	fix_range(mm, 0, TASK_SIZE, 0);
+	fix_range(mm, start, end, 0);
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = mm->mmap;
+
+	while (vma != NULL) {
+		fix_range(mm, vma->vm_start, vma->vm_end, 0);
+		vma = vma->vm_next;
+	}
 }
 
 void force_flush_all(void)
diff -puN include/asm-um/tlb.h~uml-customize-tlbh include/asm-um/tlb.h
--- a/include/asm-um/tlb.h~uml-customize-tlbh
+++ a/include/asm-um/tlb.h
@@ -1,6 +1,126 @@
 #ifndef __UM_TLB_H
 #define __UM_TLB_H
 
-#include <asm/arch/tlb.h>
+#include <linux/swap.h>
+#include <asm/percpu.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+
+#define tlb_start_vma(tlb, vma) do { } while (0)
+#define tlb_end_vma(tlb, vma) do { } while (0)
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+
+/* struct mmu_gather is an opaque type used by the mm code for passing around
+ * any data needed by arch specific code for tlb_remove_page.
+ */
+struct mmu_gather {
+	struct mm_struct	*mm;
+	unsigned int		need_flush; /* Really unmapped some ptes? */
+	unsigned long		start;
+	unsigned long		end;
+	unsigned int		fullmm; /* non-zero means full mm flush */
+};
+
+/* Users of the generic TLB shootdown code must declare this storage space. */
+DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
+					  unsigned long address)
+{
+	if (tlb->start > address)
+		tlb->start = address;
+	if (tlb->end < address + PAGE_SIZE)
+		tlb->end = address + PAGE_SIZE;
+}
+
+static inline void init_tlb_gather(struct mmu_gather *tlb)
+{
+	tlb->need_flush = 0;
+
+	tlb->start = TASK_SIZE;
+	tlb->end = 0;
+
+	if (tlb->fullmm) {
+		tlb->start = 0;
+		tlb->end = TASK_SIZE;
+	}
+}
+
+/* tlb_gather_mmu
+ *	Return a pointer to an initialized struct mmu_gather.
+ */
+static inline struct mmu_gather *
+tlb_gather_mmu(struct mm_struct *mm, unsigned int full_mm_flush)
+{
+	struct mmu_gather *tlb = &get_cpu_var(mmu_gathers);
+
+	tlb->mm = mm;
+	tlb->fullmm = full_mm_flush;
+
+	init_tlb_gather(tlb);
+
+	return tlb;
+}
+
+extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
+			       unsigned long end);
+
+static inline void
+tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+	if (!tlb->need_flush)
+		return;
+
+	flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end);
+	init_tlb_gather(tlb);
+}
+
+/* tlb_finish_mmu
+ *	Called at the end of the shootdown operation to free up any resources
+ *	that were required.
+ */
+static inline void
+tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+	tlb_flush_mmu(tlb, start, end);
+
+	/* keep the page table cache within bounds */
+	check_pgt_cache();
+
+	put_cpu_var(mmu_gathers);
+}
+
+/* tlb_remove_page
+ *	Must perform the equivalent to __free_pte(pte_get_and_clear(ptep)),
+ *	while handling the additional races in SMP caused by other CPUs
+ *	caching valid mappings in their TLBs.
+ */
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
+{
+	tlb->need_flush = 1;
+	free_page_and_swap_cache(page);
+	return;
+}
+
+/**
+ * tlb_remove_tlb_entry - remember a pte unmapping for later tlb invalidation.
+ *
+ * Record the fact that pte's were really umapped in ->need_flush, so we can
+ * later optimise away the tlb invalidate.   This helps when userspace is
+ * unmapping already-unmapped pages, which happens quite a lot.
+ */
+#define tlb_remove_tlb_entry(tlb, ptep, address)		\
+	do {							\
+		tlb->need_flush = 1;				\
+		__tlb_remove_tlb_entry(tlb, ptep, address);	\
+	} while (0)
+
+#define pte_free_tlb(tlb, ptep) __pte_free_tlb(tlb, ptep)
+
+#define pud_free_tlb(tlb, pudp) __pud_free_tlb(tlb, pudp)
+
+#define pmd_free_tlb(tlb, pmdp) __pmd_free_tlb(tlb, pmdp)
+
+#define tlb_migrate_finish(mm) do {} while (0)
 
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
