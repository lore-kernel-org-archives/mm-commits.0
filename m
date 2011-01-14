From: akpm@linux-foundation.org
Subject: [merged] thp-add-pmd-paravirt-ops.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:34 -0800
Message-ID: <201101142249.p0EMnOKL005290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab1ANWti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add pmd paravirt ops
has been removed from the -mm tree.  Its filename was
     thp-add-pmd-paravirt-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add pmd paravirt ops
From: Andrea Arcangeli <aarcange@redhat.com>

Paravirt ops pmd_update/pmd_update_defer/pmd_set_at.  Not all might be
necessary (vmware needs pmd_update, Xen needs set_pmd_at, nobody needs
pmd_update_defer), but this is to keep full simmetry with pte paravirt
ops, which looks cleaner and simpler from a common code POV.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/paravirt.h       |   25 ++++++++++++++++++++++++
 arch/x86/include/asm/paravirt_types.h |    6 +++++
 arch/x86/kernel/paravirt.c            |    3 ++
 3 files changed, 34 insertions(+)

diff -puN arch/x86/include/asm/paravirt.h~thp-add-pmd-paravirt-ops arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h~thp-add-pmd-paravirt-ops
+++ a/arch/x86/include/asm/paravirt.h
@@ -435,6 +435,11 @@ static inline void pte_update(struct mm_
 {
 	PVOP_VCALL3(pv_mmu_ops.pte_update, mm, addr, ptep);
 }
+static inline void pmd_update(struct mm_struct *mm, unsigned long addr,
+			      pmd_t *pmdp)
+{
+	PVOP_VCALL3(pv_mmu_ops.pmd_update, mm, addr, pmdp);
+}
 
 static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr,
 				    pte_t *ptep)
@@ -442,6 +447,12 @@ static inline void pte_update_defer(stru
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
+static inline void pmd_update_defer(struct mm_struct *mm, unsigned long addr,
+				    pmd_t *pmdp)
+{
+	PVOP_VCALL3(pv_mmu_ops.pmd_update_defer, mm, addr, pmdp);
+}
+
 static inline pte_t __pte(pteval_t val)
 {
 	pteval_t ret;
@@ -543,6 +554,20 @@ static inline void set_pte_at(struct mm_
 		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+			      pmd_t *pmdp, pmd_t pmd)
+{
+#if PAGETABLE_LEVELS >= 3
+	if (sizeof(pmdval_t) > sizeof(long))
+		/* 5 arg words */
+		pv_mmu_ops.set_pmd_at(mm, addr, pmdp, pmd);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp, pmd.pmd);
+#endif
+}
+#endif
+
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	pmdval_t val = native_pmd_val(pmd);
diff -puN arch/x86/include/asm/paravirt_types.h~thp-add-pmd-paravirt-ops arch/x86/include/asm/paravirt_types.h
--- a/arch/x86/include/asm/paravirt_types.h~thp-add-pmd-paravirt-ops
+++ a/arch/x86/include/asm/paravirt_types.h
@@ -265,10 +265,16 @@ struct pv_mmu_ops {
 	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, pte_t pteval);
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
+	void (*set_pmd_at)(struct mm_struct *mm, unsigned long addr,
+			   pmd_t *pmdp, pmd_t pmdval);
 	void (*pte_update)(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep);
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
+	void (*pmd_update)(struct mm_struct *mm, unsigned long addr,
+			   pmd_t *pmdp);
+	void (*pmd_update_defer)(struct mm_struct *mm,
+				 unsigned long addr, pmd_t *pmdp);
 
 	pte_t (*ptep_modify_prot_start)(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep);
diff -puN arch/x86/kernel/paravirt.c~thp-add-pmd-paravirt-ops arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~thp-add-pmd-paravirt-ops
+++ a/arch/x86/kernel/paravirt.c
@@ -421,8 +421,11 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
 	.set_pmd = native_set_pmd,
+	.set_pmd_at = native_set_pmd_at,
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
+	.pmd_update = paravirt_nop,
+	.pmd_update_defer = paravirt_nop,
 
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

