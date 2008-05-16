From: akpm@linux-foundation.org
Subject: - mprotect-prevent-alteration-of-the-pat-bits.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:25 -0700
Message-ID: <200805162253.m4GMrP0v003136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757108AbYEPWxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, hugh@veritas.com, mingo@elte.hu, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     mprotect: prevent alteration of the PAT bits
has been removed from the -mm tree.  Its filename was
     mprotect-prevent-alteration-of-the-pat-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mprotect: prevent alteration of the PAT bits
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

There is a defect in mprotect, which lets the user to change the page
cache type bits by-passing the kernel reserve_memtype and free_memtype
wrappers.  Fix the problem by not letting mprotect change the PAT bits.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/pgtable.h |   16 +++++++++++++---
 mm/mprotect.c             |   11 ++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff -puN include/asm-x86/pgtable.h~mprotect-prevent-alteration-of-the-pat-bits include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h~mprotect-prevent-alteration-of-the-pat-bits
+++ a/include/asm-x86/pgtable.h
@@ -57,7 +57,8 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
+			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
@@ -288,12 +289,21 @@ static inline pte_t pte_modify(pte_t pte
 	 * Chop off the NX bit (if present), and add the NX portion of
 	 * the newprot (if present):
 	 */
-	val &= _PAGE_CHG_MASK & ~_PAGE_NX;
-	val |= pgprot_val(newprot) & __supported_pte_mask;
+	val &= _PAGE_CHG_MASK;
+	val |= pgprot_val(newprot) & (~_PAGE_CHG_MASK) & __supported_pte_mask;
 
 	return __pte(val);
 }
 
+/* mprotect needs to preserve PAT bits when updating vm_page_prot */
+#define pgprot_modify pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	pgprotval_t preservebits = pgprot_val(oldprot) & _PAGE_CHG_MASK;
+	pgprotval_t addbits = pgprot_val(newprot);
+	return __pgprot(preservebits | addbits);
+}
+
 #define pte_pgprot(x) __pgprot(pte_val(x) & (0xfff | _PAGE_NX))
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
diff -puN mm/mprotect.c~mprotect-prevent-alteration-of-the-pat-bits mm/mprotect.c
--- a/mm/mprotect.c~mprotect-prevent-alteration-of-the-pat-bits
+++ a/mm/mprotect.c
@@ -26,6 +26,13 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#ifndef pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	return newprot;
+}
+#endif
+
 static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
@@ -192,7 +199,9 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = vm_get_page_prot(newflags);
+	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
+					  vm_get_page_prot(newflags));
+
 	if (vma_wants_writenotify(vma)) {
 		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
 		dirty_accountable = 1;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch

