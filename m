From: akpm@linux-foundation.org
Subject: + mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch added to -mm tree
Date: Thu, 15 May 2008 20:14:33 -0700
Message-ID: <200805160314.m4G3EX4F023915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYEPDPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 23:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, benh@kernel.crashing.org, clameter@sgi.com, davem@davemloft.net, hugh@veritas.com, lethal@linux-sh.org, npiggin@suse.de, paulus@samba.org, tony.luck@intel.com


The patch titled
     mm: remove double indirection on tlb parameter to free_pgd_range() & Co
has been added to the -mm tree.  Its filename is
     mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove double indirection on tlb parameter to free_pgd_range() & Co
From: "Jan Beulich" <jbeulich@novell.com>

The double indirection here is not needed anywhere and hence (at least)
confusing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c    |    2 +-
 arch/powerpc/mm/hugetlbpage.c |    8 ++++----
 fs/exec.c                     |    4 ++--
 include/asm-ia64/hugetlb.h    |    2 +-
 include/asm-powerpc/hugetlb.h |    2 +-
 include/asm-sh/hugetlb.h      |    2 +-
 include/asm-sparc64/hugetlb.h |    2 +-
 include/asm-x86/hugetlb.h     |    2 +-
 include/linux/mm.h            |    4 +---
 mm/internal.h                 |    3 +++
 mm/memory.c                   |   10 ++++++----
 mm/mmap.c                     |    6 ++++--
 12 files changed, 26 insertions(+), 21 deletions(-)

diff -puN arch/ia64/mm/hugetlbpage.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -112,7 +112,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
 {
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -255,7 +255,7 @@ static void hugetlb_free_pud_range(struc
  *
  * Must be called with pagetable lock held.
  */
-void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			    unsigned long addr, unsigned long end,
 			    unsigned long floor, unsigned long ceiling)
 {
@@ -315,13 +315,13 @@ void hugetlb_free_pgd_range(struct mmu_g
 		return;
 
 	start = addr;
-	pgd = pgd_offset((*tlb)->mm, addr);
+	pgd = pgd_offset(tlb->mm, addr);
 	do {
-		BUG_ON(get_slice_psize((*tlb)->mm, addr) != mmu_huge_psize);
+		BUG_ON(get_slice_psize(tlb->mm, addr) != mmu_huge_psize);
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		hugetlb_free_pud_range(*tlb, pgd, addr, next, floor, ceiling);
+		hugetlb_free_pud_range(tlb, pgd, addr, next, floor, ceiling);
 	} while (pgd++, addr = next, addr != end);
 }
 
diff -puN fs/exec.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co fs/exec.c
--- a/fs/exec.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/fs/exec.c
@@ -537,7 +537,7 @@ static int shift_arg_pages(struct vm_are
 		/*
 		 * when the old and new regions overlap clear from new_end.
 		 */
-		free_pgd_range(&tlb, new_end, old_end, new_end,
+		free_pgd_range(tlb, new_end, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	} else {
 		/*
@@ -546,7 +546,7 @@ static int shift_arg_pages(struct vm_are
 		 * have constraints on va-space that make this illegal (IA64) -
 		 * for the others its just a little faster.
 		 */
-		free_pgd_range(&tlb, old_start, old_end, new_end,
+		free_pgd_range(tlb, old_start, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	}
 	tlb_finish_mmu(tlb, new_end, old_end);
diff -puN include/asm-ia64/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/asm-ia64/hugetlb.h
--- a/include/asm-ia64/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/asm-ia64/hugetlb.h
@@ -4,7 +4,7 @@
 #include <asm/page.h>
 
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
 
diff -puN include/asm-powerpc/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/asm-powerpc/hugetlb.h
--- a/include/asm-powerpc/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/asm-powerpc/hugetlb.h
@@ -7,7 +7,7 @@
 int is_hugepage_only_range(struct mm_struct *mm, unsigned long addr,
 			   unsigned long len);
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
 
diff -puN include/asm-sh/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/asm-sh/hugetlb.h
--- a/include/asm-sh/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/asm-sh/hugetlb.h
@@ -26,7 +26,7 @@ static inline int prepare_hugepage_range
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
diff -puN include/asm-sparc64/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/asm-sparc64/hugetlb.h
--- a/include/asm-sparc64/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/asm-sparc64/hugetlb.h
@@ -31,7 +31,7 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
diff -puN include/asm-x86/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/asm-x86/hugetlb.h
--- a/include/asm-x86/hugetlb.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/asm-x86/hugetlb.h
@@ -26,7 +26,7 @@ static inline int prepare_hugepage_range
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
diff -puN include/linux/mm.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/include/linux/mm.h
@@ -767,10 +767,8 @@ struct mm_walk {
 int walk_page_range(const struct mm_struct *, unsigned long addr,
 		    unsigned long end, const struct mm_walk *walk,
 		    void *private);
-void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
-		unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
diff -puN mm/internal.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co mm/internal.h
--- a/mm/internal.h~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/mm/internal.h
@@ -13,6 +13,9 @@
 
 #include <linux/mm.h>
 
+void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
+		unsigned long floor, unsigned long ceiling);
+
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
diff -puN mm/memory.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co mm/memory.c
--- a/mm/memory.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/mm/memory.c
@@ -61,6 +61,8 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 
+#include "internal.h"
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
@@ -211,7 +213,7 @@ static inline void free_pud_range(struct
  *
  * Must be called with pagetable lock held.
  */
-void free_pgd_range(struct mmu_gather **tlb,
+void free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
 {
@@ -262,16 +264,16 @@ void free_pgd_range(struct mmu_gather **
 		return;
 
 	start = addr;
-	pgd = pgd_offset((*tlb)->mm, addr);
+	pgd = pgd_offset(tlb->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		free_pud_range(*tlb, pgd, addr, next, floor, ceiling);
+		free_pud_range(tlb, pgd, addr, next, floor, ceiling);
 	} while (pgd++, addr = next, addr != end);
 }
 
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
+void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long floor, unsigned long ceiling)
 {
 	while (vma) {
diff -puN mm/mmap.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co mm/mmap.c
--- a/mm/mmap.c~mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co
+++ a/mm/mmap.c
@@ -32,6 +32,8 @@
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
 
+#include "internal.h"
+
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
@@ -1756,7 +1758,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
+	free_pgtables(tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
 	tlb_finish_mmu(tlb, start, end);
 }
@@ -2056,7 +2058,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
 
 	/*
_

Patches currently in -mm which might be from jbeulich@novell.com are

acpi-fix-fadt-parsing.patch
acpi-adjust-register-handling.patch
acpi-adjust-_acpi_modulefunction_name-definitions.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch

