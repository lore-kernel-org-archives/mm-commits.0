From: akpm@linux-foundation.org
Subject: - hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:48 -0700
Message-ID: <200804282153.m3SLrmqx017925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935576AbYD1VyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, davem@davemloft.net, lethal@linux-sh.org, mingo@elte.hu, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: add missing TLB flush to hugetlb_cow()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: add missing TLB flush to hugetlb_cow()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

A cow break on a hugetlbfs page with page_count > 1 will set a new pte with
set_huge_pte_at(), w/o any tlb flush operation.  The old pte will remain in
the tlb and subsequent write access to the page will result in a page fault
loop, for as long as it may take until the tlb is flushed from somewhere else.
 This patch introduces an architecture-specific huge_ptep_clear_flush()
function, which is called before the the set_huge_pte_at() in hugetlb_cow().

ATTENTION: This is just a nop on all architectures for now, the s390
implementation will come with our large page patch later.  Other architectures
should define their own huge_ptep_clear_flush() if needed.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/hugetlb.h    |    5 +++++
 include/asm-powerpc/hugetlb.h |    5 +++++
 include/asm-sh/hugetlb.h      |    5 +++++
 include/asm-sparc64/hugetlb.h |    5 +++++
 include/asm-x86/hugetlb.h     |    5 +++++
 mm/hugetlb.c                  |    1 +
 6 files changed, 26 insertions(+)

diff -puN include/asm-ia64/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow include/asm-ia64/hugetlb.h
--- a/include/asm-ia64/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/include/asm-ia64/hugetlb.h
@@ -34,4 +34,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_IA64_HUGETLB_H */
diff -puN include/asm-powerpc/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow include/asm-powerpc/hugetlb.h
--- a/include/asm-powerpc/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/include/asm-powerpc/hugetlb.h
@@ -34,4 +34,9 @@ static inline void hugetlb_prefault_arch
 {
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_POWERPC_HUGETLB_H */
diff -puN include/asm-sh/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow include/asm-sh/hugetlb.h
--- a/include/asm-sh/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/include/asm-sh/hugetlb.h
@@ -46,4 +46,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_SH_HUGETLB_H */
diff -puN include/asm-sparc64/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow include/asm-sparc64/hugetlb.h
--- a/include/asm-sparc64/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/include/asm-sparc64/hugetlb.h
@@ -39,4 +39,9 @@ static inline void hugetlb_free_pgd_rang
 	free_pgd_range(tlb, addr, end, floor, ceiling);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_SPARC64_HUGETLB_H */
diff -puN include/asm-x86/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow include/asm-x86/hugetlb.h
--- a/include/asm-x86/hugetlb.h~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/include/asm-x86/hugetlb.h
@@ -46,4 +46,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_X86_HUGETLB_H */
diff -puN mm/hugetlb.c~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-missing-tlb-flush-to-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -892,6 +892,7 @@ static int hugetlb_cow(struct mm_struct 
 	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
 	if (likely(pte_same(*ptep, pte))) {
 		/* Break COW */
+		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
 		/* Make the old page be freed below */
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch

