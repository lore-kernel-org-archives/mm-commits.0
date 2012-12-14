From: akpm@linux-foundation.org
Subject: [merged] thp-change-split_huge_page_pmd-interface.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:20 -0800
Message-ID: <20121214232721.7B31520008A@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:40768 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2LNX1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:25 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so207290lag.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change split_huge_page_pmd() interface
has been removed from the -mm tree.  Its filename was
     thp-change-split_huge_page_pmd-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change split_huge_page_pmd() interface

Pass vma instead of mm and add address parameter.

In most cases we already have vma on the stack. We provides
split_huge_page_pmd_mm() for few cases when we have mm, but not vma.

This change is preparation to huge zero pmd splitting implementation.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    4 ++--
 arch/x86/kernel/vm86_32.c      |    2 +-
 fs/proc/task_mmu.c             |    2 +-
 include/linux/huge_mm.h        |   14 ++++++++++----
 mm/huge_memory.c               |   19 +++++++++++++++++--
 mm/memory.c                    |    4 ++--
 mm/mempolicy.c                 |    2 +-
 mm/mprotect.c                  |    2 +-
 mm/mremap.c                    |    2 +-
 mm/pagewalk.c                  |    2 +-
 10 files changed, 37 insertions(+), 16 deletions(-)

diff -puN Documentation/vm/transhuge.txt~thp-change-split_huge_page_pmd-interface Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-change-split_huge_page_pmd-interface
+++ a/Documentation/vm/transhuge.txt
@@ -276,7 +276,7 @@ unaffected. libhugetlbfs will also work 
 == Graceful fallback ==
 
 Code walking pagetables but unware about huge pmds can simply call
-split_huge_page_pmd(mm, pmd) where the pmd is the one returned by
+split_huge_page_pmd(vma, addr, pmd) where the pmd is the one returned by
 pmd_offset. It's trivial to make the code transparent hugepage aware
 by just grepping for "pmd_offset" and adding split_huge_page_pmd where
 missing after pmd_offset returns the pmd. Thanks to the graceful
@@ -299,7 +299,7 @@ diff --git a/mm/mremap.c b/mm/mremap.c
 		return NULL;
 
 	pmd = pmd_offset(pud, addr);
-+	split_huge_page_pmd(mm, pmd);
++	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_none_or_clear_bad(pmd))
 		return NULL;
 
diff -puN arch/x86/kernel/vm86_32.c~thp-change-split_huge_page_pmd-interface arch/x86/kernel/vm86_32.c
--- a/arch/x86/kernel/vm86_32.c~thp-change-split_huge_page_pmd-interface
+++ a/arch/x86/kernel/vm86_32.c
@@ -182,7 +182,7 @@ static void mark_screen_rdonly(struct mm
 	if (pud_none_or_clear_bad(pud))
 		goto out;
 	pmd = pmd_offset(pud, 0xA0000);
-	split_huge_page_pmd(mm, pmd);
+	split_huge_page_pmd_mm(mm, 0xA0000, pmd);
 	if (pmd_none_or_clear_bad(pmd))
 		goto out;
 	pte = pte_offset_map_lock(mm, pmd, 0xA0000, &ptl);
diff -puN fs/proc/task_mmu.c~thp-change-split_huge_page_pmd-interface fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-change-split_huge_page_pmd-interface
+++ a/fs/proc/task_mmu.c
@@ -643,7 +643,7 @@ static int clear_refs_pte_range(pmd_t *p
 	spinlock_t *ptl;
 	struct page *page;
 
-	split_huge_page_pmd(walk->mm, pmd);
+	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
diff -puN include/linux/huge_mm.h~thp-change-split_huge_page_pmd-interface include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-change-split_huge_page_pmd-interface
+++ a/include/linux/huge_mm.h
@@ -95,12 +95,14 @@ extern int handle_pte_fault(struct mm_st
 			    struct vm_area_struct *vma, unsigned long address,
 			    pte_t *pte, pmd_t *pmd, unsigned int flags);
 extern int split_huge_page(struct page *page);
-extern void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd);
-#define split_huge_page_pmd(__mm, __pmd)				\
+extern void __split_huge_page_pmd(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd);
+#define split_huge_page_pmd(__vma, __address, __pmd)			\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
 		if (unlikely(pmd_trans_huge(*____pmd)))			\
-			__split_huge_page_pmd(__mm, ____pmd);		\
+			__split_huge_page_pmd(__vma, __address,		\
+					____pmd);			\
 	}  while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)				\
 	do {								\
@@ -110,6 +112,8 @@ extern void __split_huge_page_pmd(struct
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)
+extern void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
+		pmd_t *pmd);
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -177,10 +181,12 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-#define split_huge_page_pmd(__mm, __pmd)	\
+#define split_huge_page_pmd(__vma, __address, __pmd)	\
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
+#define split_huge_page_pmd_mm(__mm, __address, __pmd)	\
+	do { } while (0)
 #define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
diff -puN mm/huge_memory.c~thp-change-split_huge_page_pmd-interface mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/huge_memory.c
@@ -2475,9 +2475,14 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
+void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
+		pmd_t *pmd)
 {
 	struct page *page;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct mm_struct *mm = vma->vm_mm;
+
+	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
@@ -2495,6 +2500,16 @@ void __split_huge_page_pmd(struct mm_str
 	BUG_ON(pmd_trans_huge(*pmd));
 }
 
+void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
+		pmd_t *pmd)
+{
+	struct vm_area_struct *vma;
+
+	vma = find_vma(mm, address);
+	BUG_ON(vma == NULL);
+	split_huge_page_pmd(vma, address, pmd);
+}
+
 static void split_huge_page_address(struct mm_struct *mm,
 				    unsigned long address)
 {
@@ -2509,7 +2524,7 @@ static void split_huge_page_address(stru
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
 	 * materialize from under us.
 	 */
-	split_huge_page_pmd(mm, pmd);
+	split_huge_page_pmd_mm(mm, address, pmd);
 }
 
 void __vma_adjust_trans_huge(struct vm_area_struct *vma,
diff -puN mm/memory.c~thp-change-split_huge_page_pmd-interface mm/memory.c
--- a/mm/memory.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/memory.c
@@ -1243,7 +1243,7 @@ static inline unsigned long zap_pmd_rang
 					BUG();
 				}
 #endif
-				split_huge_page_pmd(vma->vm_mm, pmd);
+				split_huge_page_pmd(vma, addr, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
 			/* fall through */
@@ -1512,7 +1512,7 @@ struct page *follow_page(struct vm_area_
 	}
 	if (pmd_trans_huge(*pmd)) {
 		if (flags & FOLL_SPLIT) {
-			split_huge_page_pmd(mm, pmd);
+			split_huge_page_pmd(vma, address, pmd);
 			goto split_fallthrough;
 		}
 		spin_lock(&mm->page_table_lock);
diff -puN mm/mempolicy.c~thp-change-split_huge_page_pmd-interface mm/mempolicy.c
--- a/mm/mempolicy.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/mempolicy.c
@@ -511,7 +511,7 @@ static inline int check_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
+		split_huge_page_pmd(vma, addr, pmd);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
 		if (check_pte_range(vma, pmd, addr, next, nodes,
diff -puN mm/mprotect.c~thp-change-split_huge_page_pmd-interface mm/mprotect.c
--- a/mm/mprotect.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/mprotect.c
@@ -90,7 +90,7 @@ static inline void change_pmd_range(stru
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-				split_huge_page_pmd(vma->vm_mm, pmd);
+				split_huge_page_pmd(vma, addr, pmd);
 			else if (change_huge_pmd(vma, pmd, addr, newprot))
 				continue;
 			/* fall through */
diff -puN mm/mremap.c~thp-change-split_huge_page_pmd-interface mm/mremap.c
--- a/mm/mremap.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/mremap.c
@@ -182,7 +182,7 @@ unsigned long move_page_tables(struct vm
 				need_flush = true;
 				continue;
 			} else if (!err) {
-				split_huge_page_pmd(vma->vm_mm, old_pmd);
+				split_huge_page_pmd(vma, old_addr, old_pmd);
 			}
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
diff -puN mm/pagewalk.c~thp-change-split_huge_page_pmd-interface mm/pagewalk.c
--- a/mm/pagewalk.c~thp-change-split_huge_page_pmd-interface
+++ a/mm/pagewalk.c
@@ -58,7 +58,7 @@ again:
 		if (!walk->pte_entry)
 			continue;
 
-		split_huge_page_pmd(walk->mm, pmd);
+		split_huge_page_pmd_mm(walk->mm, addr, pmd);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			goto again;
 		err = walk_pte_range(pmd, addr, next, walk);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

