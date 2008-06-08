From: akpm@linux-foundation.org
Subject: + hugetlb-introduce-pud_huge.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:59 -0700
Message-ID: <200806081911.m58JBxmh016176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbYFHTMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ak@suse.de


The patch titled
     hugetlb: introduce pud_huge
has been added to the -mm tree.  Its filename is
     hugetlb-introduce-pud_huge.patch

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
Subject: hugetlb: introduce pud_huge
From: Nick Piggin <npiggin@suse.de>

Straight forward extensions for huge pages located in the PUD instead of
PMDs.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c    |    6 ++++++
 arch/powerpc/mm/hugetlbpage.c |    5 +++++
 arch/sh/mm/hugetlbpage.c      |    5 +++++
 arch/sparc64/mm/hugetlbpage.c |    5 +++++
 arch/x86/mm/hugetlbpage.c     |   25 ++++++++++++++++++++++++-
 include/linux/hugetlb.h       |    5 +++++
 mm/hugetlb.c                  |    9 +++++++++
 mm/memory.c                   |   15 +++++++++++----
 8 files changed, 70 insertions(+), 5 deletions(-)

diff -puN arch/ia64/mm/hugetlbpage.c~hugetlb-introduce-pud_huge arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~hugetlb-introduce-pud_huge
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -107,6 +107,12 @@ int pmd_huge(pmd_t pmd)
 {
 	return 0;
 }
+
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
 {
diff -puN arch/powerpc/mm/hugetlbpage.c~hugetlb-introduce-pud_huge arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlb-introduce-pud_huge
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -369,6 +369,11 @@ int pmd_huge(pmd_t pmd)
 	return 0;
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
diff -puN arch/sh/mm/hugetlbpage.c~hugetlb-introduce-pud_huge arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~hugetlb-introduce-pud_huge
+++ a/arch/sh/mm/hugetlbpage.c
@@ -79,6 +79,11 @@ int pmd_huge(pmd_t pmd)
 	return 0;
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/sparc64/mm/hugetlbpage.c~hugetlb-introduce-pud_huge arch/sparc64/mm/hugetlbpage.c
--- a/arch/sparc64/mm/hugetlbpage.c~hugetlb-introduce-pud_huge
+++ a/arch/sparc64/mm/hugetlbpage.c
@@ -295,6 +295,11 @@ int pmd_huge(pmd_t pmd)
 	return 0;
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-introduce-pud_huge arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-introduce-pud_huge
+++ a/arch/x86/mm/hugetlbpage.c
@@ -189,6 +189,11 @@ int pmd_huge(pmd_t pmd)
 	return 0;
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
@@ -209,6 +214,11 @@ int pmd_huge(pmd_t pmd)
 	return !!(pmd_val(pmd) & _PAGE_PSE);
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
@@ -217,9 +227,22 @@ follow_huge_pmd(struct mm_struct *mm, un
 
 	page = pte_page(*(pte_t *)pmd);
 	if (page)
-		page += ((address & ~HPAGE_MASK) >> PAGE_SHIFT);
+		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
 	return page;
 }
+
+struct page *
+follow_huge_pud(struct mm_struct *mm, unsigned long address,
+		pud_t *pud, int write)
+{
+	struct page *page;
+
+	page = pte_page(*(pte_t *)pud);
+	if (page)
+		page += ((address & ~PUD_MASK) >> PAGE_SHIFT);
+	return page;
+}
+
 #endif
 
 /* x86_64 also uses this file */
diff -puN include/linux/hugetlb.h~hugetlb-introduce-pud_huge include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-introduce-pud_huge
+++ a/include/linux/hugetlb.h
@@ -50,7 +50,10 @@ struct page *follow_huge_addr(struct mm_
 			      int write);
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 				pmd_t *pmd, int write);
+struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
+				pud_t *pud, int write);
 int pmd_huge(pmd_t pmd);
+int pud_huge(pud_t pmd);
 void hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
@@ -78,8 +81,10 @@ static inline unsigned long hugetlb_tota
 #define hugetlb_report_meminfo(buf)		0
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
+#define follow_huge_pud(mm, addr, pud, write)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
+#define pud_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, write)	({ BUG(); 0; })
diff -puN mm/hugetlb.c~hugetlb-introduce-pud_huge mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-introduce-pud_huge
+++ a/mm/hugetlb.c
@@ -1896,6 +1896,15 @@ int hugetlb_fault(struct mm_struct *mm, 
 	return ret;
 }
 
+/* Can be overriden by architectures */
+__attribute__((weak)) struct page *
+follow_huge_pud(struct mm_struct *mm, unsigned long address,
+	       pud_t *pud, int write)
+{
+	BUG();
+	return NULL;
+}
+
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
 			unsigned long *position, int *length, int i,
diff -puN mm/memory.c~hugetlb-introduce-pud_huge mm/memory.c
--- a/mm/memory.c~hugetlb-introduce-pud_huge
+++ a/mm/memory.c
@@ -998,19 +998,24 @@ struct page *follow_page(struct vm_area_
 		goto no_page_table;
 
 	pud = pud_offset(pgd, address);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+	if (pud_none(*pud))
+		goto no_page_table;
+	if (pud_huge(*pud)) {
+		BUG_ON(flags & FOLL_GET);
+		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
+		goto out;
+	}
+	if (unlikely(pud_bad(*pud)))
 		goto no_page_table;
-	
+
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		goto no_page_table;
-
 	if (pmd_huge(*pmd)) {
 		BUG_ON(flags & FOLL_GET);
 		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
 		goto out;
 	}
-
 	if (unlikely(pmd_bad(*pmd)))
 		goto no_page_table;
 
@@ -1541,6 +1546,8 @@ static int apply_to_pmd_range(struct mm_
 	unsigned long next;
 	int err;
 
+	BUG_ON(pud_huge(*pud));
+
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

