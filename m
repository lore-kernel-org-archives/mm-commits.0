From: akpm@linux-foundation.org
Subject: - i386-pte-drop-ptep_get_and_clear-paravirt-op.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:03 -0700
Message-ID: <200704252040.l3PKe3Zk012380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993151AbXDYUkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     i386: pte drop ptep_get_and_clear paravirt op
has been removed from the -mm tree.  Its filename was
     i386-pte-drop-ptep_get_and_clear-paravirt-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: pte drop ptep_get_and_clear paravirt op
From: Zachary Amsden <zach@vmware.com>

In shadow mode hypervisors, ptep_get_and_clear achieves the desired purpose of
keeping the shadows in sync by issuing a native_get_and_clear, followed by a
call to pte_update, which indicates the PTE has been modified.

Direct mode hypervisors (Xen) have no need for this anyway, and will trap the
update using writable pagetables.

This means no hypervisor makes use of ptep_get_and_clear; there is no reason
to have it in the paravirt-ops structure.  Change confusing terminology about
raw vs.  native functions into consistent use of native_pte_xxx for operations
which do not invoke paravirt-ops.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 --
 include/asm-i386/paravirt.h |   13 +------------
 include/asm-i386/pgtable.h  |    4 +---
 3 files changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~i386-pte-drop-ptep_get_and_clear-paravirt-op arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~i386-pte-drop-ptep_get_and_clear-paravirt-op
+++ a/arch/i386/kernel/paravirt.c
@@ -315,8 +315,6 @@ struct paravirt_ops paravirt_ops = {
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-	.ptep_get_and_clear = native_ptep_get_and_clear,
-
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = native_kmap_atomic_pte,
 #else
diff -puN include/asm-i386/paravirt.h~i386-pte-drop-ptep_get_and_clear-paravirt-op include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~i386-pte-drop-ptep_get_and_clear-paravirt-op
+++ a/include/asm-i386/paravirt.h
@@ -188,8 +188,6 @@ struct paravirt_ops
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
- 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
-
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
 
 #ifdef CONFIG_X86_PAE
@@ -855,12 +853,8 @@ static inline void pmd_clear(pmd_t *pmdp
 	PVOP_VCALL1(pmd_clear, pmdp);
 }
 
-static inline pte_t raw_ptep_get_and_clear(pte_t *p)
-{
-	unsigned long long val = PVOP_CALL1(unsigned long long, ptep_get_and_clear, p);
-	return (pte_t) { val, val >> 32 };
-}
 #else  /* !CONFIG_X86_PAE */
+
 static inline pte_t __pte(unsigned long val)
 {
 	return (pte_t) { PVOP_CALL1(unsigned long, make_pte, val) };
@@ -896,11 +890,6 @@ static inline void set_pmd(pmd_t *pmdp, 
 {
 	PVOP_VCALL2(set_pmd, pmdp, pmdval.pud.pgd.pgd);
 }
-
-static inline pte_t raw_ptep_get_and_clear(pte_t *p)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, ptep_get_and_clear, p) };
-}
 #endif	/* CONFIG_X86_PAE */
 
 /* Lazy mode for batching updates / context switch */
diff -puN include/asm-i386/pgtable.h~i386-pte-drop-ptep_get_and_clear-paravirt-op include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-pte-drop-ptep_get_and_clear-paravirt-op
+++ a/include/asm-i386/pgtable.h
@@ -267,8 +267,6 @@ extern void vmalloc_sync_all(void);
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
-
-#define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
 
 /*
@@ -335,7 +333,7 @@ do {									\
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	pte_t pte = raw_ptep_get_and_clear(ptep);
+	pte_t pte = native_ptep_get_and_clear(ptep);
 	pte_update(mm, addr, ptep);
 	return pte;
 }
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
