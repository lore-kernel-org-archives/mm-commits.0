From: akpm@linux-foundation.org
Subject: [merged] thp-add-pmd-mmu_notifier-helpers.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:59 -0800
Message-ID: <201101142249.p0EMnnJI005327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853Ab1ANWuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add pmd mmu_notifier helpers
has been removed from the -mm tree.  Its filename was
     thp-add-pmd-mmu_notifier-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add pmd mmu_notifier helpers
From: Andrea Arcangeli <aarcange@redhat.com>

Add mmu notifier helpers to handle pmd huge operations.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN include/linux/mmu_notifier.h~thp-add-pmd-mmu_notifier-helpers include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~thp-add-pmd-mmu_notifier-helpers
+++ a/include/linux/mmu_notifier.h
@@ -243,6 +243,32 @@ static inline void mmu_notifier_mm_destr
 	__pte;								\
 })
 
+#define pmdp_clear_flush_notify(__vma, __address, __pmdp)		\
+({									\
+	pmd_t __pmd;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
+	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
+					    (__address)+HPAGE_PMD_SIZE);\
+	__pmd = pmdp_clear_flush(___vma, ___address, __pmdp);		\
+	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
+					  (__address)+HPAGE_PMD_SIZE);	\
+	__pmd;								\
+})
+
+#define pmdp_splitting_flush_notify(__vma, __address, __pmdp)		\
+({									\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
+	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
+					    (__address)+HPAGE_PMD_SIZE);\
+	pmdp_splitting_flush(___vma, ___address, __pmdp);		\
+	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
+					  (__address)+HPAGE_PMD_SIZE);	\
+})
+
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
 ({									\
 	int __young;							\
@@ -254,6 +280,17 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
+({									\
+	int __young;							\
+	struct vm_area_struct *___vma = __vma;				\
+	unsigned long ___address = __address;				\
+	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
+	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
+						  ___address);		\
+	__young;							\
+})
+
 #define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
 ({									\
 	struct mm_struct *___mm = __mm;					\
@@ -305,7 +342,10 @@ static inline void mmu_notifier_mm_destr
 }
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_flush_notify ptep_clear_flush
+#define pmdp_clear_flush_notify pmdp_clear_flush
+#define pmdp_splitting_flush_notify pmdp_splitting_flush
 #define set_pte_at_notify set_pte_at
 
 #endif /* CONFIG_MMU_NOTIFIER */
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

