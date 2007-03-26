From: akpm@linux-foundation.org
Subject: + i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch added to -mm tree
Date: Mon, 26 Mar 2007 00:21:52 -0800
Message-ID: <200703260821.l2Q8Lqev014628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662AbXCZIWB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 04:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, hugh@veritas.com, rientjes@google.com


The patch titled
     i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
has been added to the -mm tree.  Its filename is
     i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
From: Zachary Amsden <zach@vmware.com>

If you actually clear the bit, you need to:

+         pte_update_defer(vma->vm_mm, addr, ptep);

The reason is, when updating PTEs, the hypervisor must be notified.  Using
atomic operations to do this is fine for all hypervisors I am aware of. 
However, for hypervisors which shadow page tables, if these PTE
modifications are not trapped, you need a post-modification call to fulfill
the update of the shadow page table.

Cc: Zachary Amsden <zach@vmware.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable.h |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung
+++ a/include/asm-i386/pgtable.h
@@ -287,18 +287,24 @@ do {									\
 static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)
 {
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+	int ret = 0;
+	if (pte_dirty(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+	if (ret)
+		pte_update_defer(vma->vm_mm, addr, ptep);
+	return ret;
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)
 {
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+	int ret = 0;
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+	if (ret)
+		pte_update_defer(vma->vm_mm, addr, ptep);
+	return ret;
 }
 
 /*
@@ -317,10 +323,8 @@ do {									\
 ({									\
 	int __dirty;							\
 	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
-	if (__dirty) {							\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
+	if (__dirty)							\
 		flush_tlb_page(vma, address);				\
-	}								\
 	__dirty;							\
 })
 
@@ -329,10 +333,8 @@ do {									\
 ({									\
 	int __young;							\
 	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young) {							\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
+	if (__young)							\
 		flush_tlb_page(vma, address);				\
-	}								\
 	__young;							\
 })
 
_

Patches currently in -mm which might be from zach@vmware.com are

make-struct-vmi_ops-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
