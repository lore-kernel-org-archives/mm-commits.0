From: akpm@linux-foundation.org
Subject: + mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch added to -mm tree
Date: Mon, 13 May 2013 16:14:02 -0700
Message-ID: <20130513231402.ECDD85A423C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38535 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3EMXOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:14:04 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so668592vbg.2
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au


The patch titled
     Subject: mm/THP: add pmd args to pgtable deposit and withdraw APIs
has been added to the -mm tree.  Its filename is
     mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/THP: add pmd args to pgtable deposit and withdraw APIs

This will be later used by powerpc THP support.  In powerpc we want to use
pgtable for storing the hash index values.  So instead of adding them to
mm_context list, we would like to store them in the second half of pmd

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h     |    5 +++--
 arch/s390/mm/pgtable.c              |    5 +++--
 arch/sparc/include/asm/pgtable_64.h |    5 +++--
 arch/sparc/mm/tlb.c                 |    5 +++--
 include/asm-generic/pgtable.h       |    5 +++--
 mm/huge_memory.c                    |   18 +++++++++---------
 mm/pgtable-generic.c                |    5 +++--
 7 files changed, 27 insertions(+), 21 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/arch/s390/include/asm/pgtable.h
@@ -1351,10 +1351,11 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, , pmd_t *pmdp,
+				       pgtable_t pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 
 static inline int pmd_trans_splitting(pmd_t pmd)
 {
diff -puN arch/s390/mm/pgtable.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/arch/s390/mm/pgtable.c
@@ -1118,7 +1118,8 @@ void pmdp_splitting_flush(struct vm_area
 	}
 }
 
-void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				pgtable_t pgtable)
 {
 	struct list_head *lh = (struct list_head *) pgtable;
 
@@ -1132,7 +1133,7 @@ void pgtable_trans_huge_deposit(struct m
 	mm->pmd_huge_pte = pgtable;
 }
 
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	struct list_head *lh;
 	pgtable_t pgtable;
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -853,10 +853,11 @@ extern void update_mmu_cache_pmd(struct
 				 pmd_t *pmd);
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				       pgtable_t pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
 /* Encode and de-code a swap entry */
diff -puN arch/sparc/mm/tlb.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis arch/sparc/mm/tlb.c
--- a/arch/sparc/mm/tlb.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/arch/sparc/mm/tlb.c
@@ -188,7 +188,8 @@ void set_pmd_at(struct mm_struct *mm, un
 	}
 }
 
-void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				pgtable_t pgtable)
 {
 	struct list_head *lh = (struct list_head *) pgtable;
 
@@ -202,7 +203,7 @@ void pgtable_trans_huge_deposit(struct m
 	mm->pmd_huge_pte = pgtable;
 }
 
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	struct list_head *lh;
 	pgtable_t pgtable;
diff -puN include/asm-generic/pgtable.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/include/asm-generic/pgtable.h
@@ -173,11 +173,12 @@ extern void pmdp_splitting_flush(struct
 #endif
 
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				       pgtable_t pgtable);
 #endif
 
 #ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
diff -puN mm/huge_memory.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/mm/huge_memory.c
@@ -730,7 +730,7 @@ static int __do_huge_pmd_anonymous_page(
 		entry = mk_huge_pmd(page, vma);
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		pgtable_trans_huge_deposit(mm, pgtable);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
@@ -772,7 +772,7 @@ static bool set_huge_zero_page(pgtable_t
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
-	pgtable_trans_huge_deposit(mm, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	mm->nr_ptes++;
 	return true;
 }
@@ -917,7 +917,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	pgtable_trans_huge_deposit(dst_mm, pgtable);
+	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 	dst_mm->nr_ptes++;
 
 	ret = 0;
@@ -987,7 +987,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = pgtable_trans_huge_withdraw(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1085,7 +1085,7 @@ static int do_huge_pmd_wp_page_fallback(
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = pgtable_trans_huge_withdraw(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1360,7 +1360,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
-		pgtable = pgtable_trans_huge_withdraw(tlb->mm);
+		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		if (is_huge_zero_pmd(orig_pmd)) {
@@ -1693,7 +1693,7 @@ static int __split_huge_page_map(struct
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
 	if (pmd) {
-		pgtable = pgtable_trans_huge_withdraw(mm);
+		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 		pmd_populate(mm, &_pmd, pgtable);
 
 		haddr = address;
@@ -2363,7 +2363,7 @@ static void collapse_huge_page(struct mm
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
-	pgtable_trans_huge_deposit(mm, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
 	*hpage = NULL;
@@ -2669,7 +2669,7 @@ static void __split_huge_zero_page_pmd(s
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = pgtable_trans_huge_withdraw(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
diff -puN mm/pgtable-generic.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis
+++ a/mm/pgtable-generic.c
@@ -124,7 +124,8 @@ void pmdp_splitting_flush(struct vm_area
 
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				pgtable_t pgtable)
 {
 	assert_spin_locked(&mm->page_table_lock);
 
@@ -141,7 +142,7 @@ void pgtable_trans_huge_deposit(struct m
 #ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* no "address" argument so destroys page coloring of some arch */
-pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
 	pgtable_t pgtable;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

