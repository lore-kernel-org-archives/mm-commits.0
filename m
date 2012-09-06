From: akpm@linux-foundation.org
Subject: + thp-introduce-pmdp_invalidate.patch added to -mm tree
Date: Thu, 06 Sep 2012 14:00:24 -0700
Message-ID: <20120906210025.BD20F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40848 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2IFVA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 17:00:28 -0400
Received: by wgbdt11 with SMTP id dt11so130714wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 14:00:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com


The patch titled
     Subject: thp: introduce pmdp_invalidate()
has been added to the -mm tree.  Its filename is
     thp-introduce-pmdp_invalidate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp: introduce pmdp_invalidate()

On s390, a valid page table entry must not be changed while it is attached
to any CPU.  So instead of pmd_mknotpresent() and set_pmd_at(), an IDTE
operation would be necessary there.  This patch introduces the
pmdp_invalidate() function, to allow architecture-specific
implementations.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    5 +++++
 mm/huge_memory.c              |    3 +--
 mm/pgtable-generic.c          |   11 +++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/pgtable.h~thp-introduce-pmdp_invalidate include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~thp-introduce-pmdp_invalidate
+++ a/include/asm-generic/pgtable.h
@@ -170,6 +170,11 @@ extern void pgtable_trans_huge_deposit(s
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			    pmd_t *pmdp);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff -puN mm/huge_memory.c~thp-introduce-pmdp_invalidate mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-pmdp_invalidate
+++ a/mm/huge_memory.c
@@ -1361,8 +1361,7 @@ static int __split_huge_page_map(struct 
 		 * SMP TLB and finally we write the non-huge version
 		 * of the pmd entry with pmd_populate.
 		 */
-		set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
-		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+		pmdp_invalidate(vma, address, pmd);
 		pmd_populate(mm, pmd, pgtable);
 		ret = 1;
 	}
diff -puN mm/pgtable-generic.c~thp-introduce-pmdp_invalidate mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~thp-introduce-pmdp_invalidate
+++ a/mm/pgtable-generic.c
@@ -159,3 +159,14 @@ pgtable_t pgtable_trans_huge_withdraw(st
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		     pmd_t *pmdp)
+{
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

