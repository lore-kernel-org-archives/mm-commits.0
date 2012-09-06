From: akpm@linux-foundation.org
Subject: + thp-s390-thp-pagetable-pre-allocation-for-s390.patch added to -mm tree
Date: Thu, 06 Sep 2012 14:00:36 -0700
Message-ID: <20120906210037.B27D35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55680 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759932Ab2IFVAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 17:00:40 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id w12so129993lag.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 14:00:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com


The patch titled
     Subject: thp, s390: thp pagetable pre-allocation for s390
has been added to the -mm tree.  Its filename is
     thp-s390-thp-pagetable-pre-allocation-for-s390.patch

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
Subject: thp, s390: thp pagetable pre-allocation for s390

This patch is part of the architecture backend for thp on s390.  It
provides the pagetable pre-allocation functions
pgtable_trans_huge_deposit() and pgtable_trans_huge_withdraw().  Unlike
other archs, s390 has no struct page * as pgtable_t, but rather a pointer
to the page table.  So instead of saving the pagetable pre- allocation
list info inside the struct page, it is being saved within the pagetable
itself.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    6 ++++
 arch/s390/mm/pgtable.c          |   38 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN arch/s390/include/asm/pgtable.h~thp-s390-thp-pagetable-pre-allocation-for-s390 arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~thp-s390-thp-pagetable-pre-allocation-for-s390
+++ a/arch/s390/include/asm/pgtable.h
@@ -1166,6 +1166,12 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_unmap(pte) do { } while (0)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+
+#define __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+
 static inline int pmd_trans_splitting(pmd_t pmd)
 {
 	return pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT;
diff -puN arch/s390/mm/pgtable.c~thp-s390-thp-pagetable-pre-allocation-for-s390 arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~thp-s390-thp-pagetable-pre-allocation-for-s390
+++ a/arch/s390/mm/pgtable.c
@@ -883,4 +883,42 @@ void pmdp_splitting_flush(struct vm_area
 		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
 	}
 }
+
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
+{
+	struct list_head *lh = (struct list_head *) pgtable;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	if (!mm->pmd_huge_pte)
+		INIT_LIST_HEAD(lh);
+	else
+		list_add(lh, (struct list_head *) mm->pmd_huge_pte);
+	mm->pmd_huge_pte = pgtable;
+}
+
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
+{
+	struct list_head *lh;
+	pgtable_t pgtable;
+	pte_t *ptep;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	pgtable = mm->pmd_huge_pte;
+	lh = (struct list_head *) pgtable;
+	if (list_empty(lh))
+		mm->pmd_huge_pte = NULL;
+	else {
+		mm->pmd_huge_pte = (pgtable_t) lh->next;
+		list_del(lh);
+	}
+	ptep = (pte_t *) pgtable;
+	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
+	ptep++;
+	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
+	return pgtable;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
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

