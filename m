From: akpm@linux-foundation.org
Subject: - i386-add-ptep_test_and_clear_dirtyyoung.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:19 -0700
Message-ID: <200705080002.l4802JiN008835@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967497AbXEHAMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, hugh@veritas.com, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     i386: add ptep_test_and_clear_{dirty,young}
has been removed from the -mm tree.  Its filename was
     i386-add-ptep_test_and_clear_dirtyyoung.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: add ptep_test_and_clear_{dirty,young}
From: David Rientjes <rientjes@google.com>

Add ptep_test_and_clear_{dirty,young} to i386.  They advertise that they
have it and there is at least one place where it needs to be called without
the page table lock: to clear the accessed bit on write to
/proc/pid/clear_refs.

ptep_clear_flush_{dirty,young} are updated to use the new functions.  The
overall net effect to current users of ptep_clear_flush_{dirty,young} is
that we introduce an additional branch.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable.h |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN include/asm-i386/pgtable.h~i386-add-ptep_test_and_clear_dirtyyoung include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-add-ptep_test_and_clear_dirtyyoung
+++ a/include/asm-i386/pgtable.h
@@ -296,12 +296,23 @@ do {									\
 	}								\
 } while (0)
 
-/*
- * We don't actually have these, but we want to advertise them so that
- * we can encompass the flush here.
- */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
+static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	if (!pte_dirty(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	if (!pte_young(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+}
 
 /*
  * Rules for using ptep_establish: the pte MUST be a user pte, and
@@ -318,9 +329,8 @@ do {									\
 #define ptep_clear_flush_dirty(vma, address, ptep)			\
 ({									\
 	int __dirty;							\
-	__dirty = pte_dirty(*(ptep));					\
+	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
 	if (__dirty) {							\
-		clear_bit(_PAGE_BIT_DIRTY, &(ptep)->pte_low);		\
 		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
 		flush_tlb_page(vma, address);				\
 	}								\
@@ -331,9 +341,8 @@ do {									\
 #define ptep_clear_flush_young(vma, address, ptep)			\
 ({									\
 	int __young;							\
-	__young = pte_young(*(ptep));					\
+	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
 	if (__young) {							\
-		clear_bit(_PAGE_BIT_ACCESSED, &(ptep)->pte_low);	\
 		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
 		flush_tlb_page(vma, address);				\
 	}								\
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
