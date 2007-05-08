From: akpm@linux-foundation.org
Subject: - i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:22 -0700
Message-ID: <200705080002.l4802MPZ008838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967482AbXEHALz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, hugh@veritas.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
has been removed from the -mm tree.  Its filename was
     i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable.h |   38 ++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung
+++ a/include/asm-i386/pgtable.h
@@ -297,22 +297,24 @@ do {									\
 } while (0)
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
-}
+#define ptep_test_and_clear_dirty(vma, addr, ptep) ({			\
+	int ret = 0;							\
+	if (pte_dirty(*ptep))						\
+		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low); \
+	if (ret)							\
+		pte_update_defer(vma->vm_mm, addr, ptep);		\
+	ret;								\
+})
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
-}
+#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
+	int ret = 0;							\
+	if (pte_young(*ptep))						\
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low); \
+	if (ret)							\
+		pte_update_defer(vma->vm_mm, addr, ptep);		\
+	ret;								\
+})
 
 /*
  * Rules for using ptep_establish: the pte MUST be a user pte, and
@@ -330,10 +332,8 @@ do {									\
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
 
@@ -342,10 +342,8 @@ do {									\
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

origin.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
