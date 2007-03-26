From: akpm@linux-foundation.org
Subject: + i386-add-ptep_test_and_clear_dirtyyoung.patch added to -mm tree
Date: Sun, 25 Mar 2007 17:07:39 -0800
Message-ID: <200703260107.l2Q17dCi008773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbXCZBH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, hugh@veritas.com, mingo@redhat.com


The patch titled
     i386: add ptep_test_and_clear_{dirty,young}
has been added to the -mm tree.  Its filename is
     i386-add-ptep_test_and_clear_dirtyyoung.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -283,12 +283,23 @@ do {									\
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
@@ -305,9 +316,8 @@ do {									\
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
@@ -318,9 +328,8 @@ do {									\
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

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-configurable-fake-numa-node-sizes-fix.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
