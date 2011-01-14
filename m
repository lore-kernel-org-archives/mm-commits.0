From: akpm@linux-foundation.org
Subject: [merged] thp-madvisemadv_nohugepage.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:45 -0800
Message-ID: <201101142251.p0EMpZFX005530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1ANWvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: madvise(MADV_NOHUGEPAGE)
has been removed from the -mm tree.  Its filename was
     thp-madvisemadv_nohugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: madvise(MADV_NOHUGEPAGE)
From: Andrea Arcangeli <aarcange@redhat.com>

Add madvise MADV_NOHUGEPAGE to mark regions that are not important to be
hugepage backed.  Return -EINVAL if the vma is not of an anonymous type,
or the feature isn't built into the kernel.  Never silently return
success.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |   14 ++++++-----
 include/linux/khugepaged.h |    7 +++--
 include/linux/mm.h         |    1 
 mm/huge_memory.c           |   41 +++++++++++++++++++++++++----------
 mm/madvise.c               |    4 ++-
 5 files changed, 46 insertions(+), 21 deletions(-)

diff -puN include/linux/huge_mm.h~thp-madvisemadv_nohugepage include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-madvisemadv_nohugepage
+++ a/include/linux/huge_mm.h
@@ -52,10 +52,12 @@ extern pmd_t *page_check_address_pmd(str
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
 #define transparent_hugepage_enabled(__vma)				\
-	(transparent_hugepage_flags & (1<<TRANSPARENT_HUGEPAGE_FLAG) ||	\
-	 (transparent_hugepage_flags &					\
-	  (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
-	  (__vma)->vm_flags & VM_HUGEPAGE))
+	((transparent_hugepage_flags &					\
+	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
+	  (transparent_hugepage_flags &					\
+	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
+	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
+	 !((__vma)->vm_flags & VM_NOHUGEPAGE))
 #define transparent_hugepage_defrag(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)) ||			\
@@ -103,7 +105,7 @@ extern void __split_huge_page_pmd(struct
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
-extern int hugepage_madvise(unsigned long *vm_flags);
+extern int hugepage_madvise(unsigned long *vm_flags, int advice);
 extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
@@ -141,7 +143,7 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
-static inline int hugepage_madvise(unsigned long *vm_flags)
+static inline int hugepage_madvise(unsigned long *vm_flags, int advice)
 {
 	BUG();
 	return 0;
diff -puN include/linux/khugepaged.h~thp-madvisemadv_nohugepage include/linux/khugepaged.h
--- a/include/linux/khugepaged.h~thp-madvisemadv_nohugepage
+++ a/include/linux/khugepaged.h
@@ -38,9 +38,10 @@ static inline void khugepaged_exit(struc
 static inline int khugepaged_enter(struct vm_area_struct *vma)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
-		if (khugepaged_always() ||
-		    (khugepaged_req_madv() &&
-		     vma->vm_flags & VM_HUGEPAGE))
+		if ((khugepaged_always() ||
+		     (khugepaged_req_madv() &&
+		      vma->vm_flags & VM_HUGEPAGE)) &&
+		    !(vma->vm_flags & VM_NOHUGEPAGE))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
diff -puN include/linux/mm.h~thp-madvisemadv_nohugepage include/linux/mm.h
--- a/include/linux/mm.h~thp-madvisemadv_nohugepage
+++ a/include/linux/mm.h
@@ -83,6 +83,7 @@ extern unsigned int kobjsize(const void 
 #define VM_GROWSUP	0x00000200
 #else
 #define VM_GROWSUP	0x00000000
+#define VM_NOHUGEPAGE	0x00000200	/* MADV_NOHUGEPAGE marked this vma */
 #endif
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
diff -puN mm/huge_memory.c~thp-madvisemadv_nohugepage mm/huge_memory.c
--- a/mm/huge_memory.c~thp-madvisemadv_nohugepage
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
+#include <linux/mman.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -1388,18 +1389,36 @@ out:
 	return ret;
 }
 
-int hugepage_madvise(unsigned long *vm_flags)
+int hugepage_madvise(unsigned long *vm_flags, int advice)
 {
-	/*
-	 * Be somewhat over-protective like KSM for now!
-	 */
-	if (*vm_flags & (VM_HUGEPAGE | VM_SHARED  | VM_MAYSHARE   |
-			 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
-			 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
-			 VM_MIXEDMAP | VM_SAO))
-		return -EINVAL;
-
-	*vm_flags |= VM_HUGEPAGE;
+	switch (advice) {
+	case MADV_HUGEPAGE:
+		/*
+		 * Be somewhat over-protective like KSM for now!
+		 */
+		if (*vm_flags & (VM_HUGEPAGE |
+				 VM_SHARED   | VM_MAYSHARE   |
+				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
+				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_MIXEDMAP | VM_SAO))
+			return -EINVAL;
+		*vm_flags &= ~VM_NOHUGEPAGE;
+		*vm_flags |= VM_HUGEPAGE;
+		break;
+	case MADV_NOHUGEPAGE:
+		/*
+		 * Be somewhat over-protective like KSM for now!
+		 */
+		if (*vm_flags & (VM_NOHUGEPAGE |
+				 VM_SHARED   | VM_MAYSHARE   |
+				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
+				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_MIXEDMAP | VM_SAO))
+			return -EINVAL;
+		*vm_flags &= ~VM_HUGEPAGE;
+		*vm_flags |= VM_NOHUGEPAGE;
+		break;
+	}
 
 	return 0;
 }
diff -puN mm/madvise.c~thp-madvisemadv_nohugepage mm/madvise.c
--- a/mm/madvise.c~thp-madvisemadv_nohugepage
+++ a/mm/madvise.c
@@ -72,7 +72,8 @@ static long madvise_behavior(struct vm_a
 			goto out;
 		break;
 	case MADV_HUGEPAGE:
-		error = hugepage_madvise(&new_flags);
+	case MADV_NOHUGEPAGE:
+		error = hugepage_madvise(&new_flags, behavior);
 		if (error)
 			goto out;
 		break;
@@ -290,6 +291,7 @@ madvise_behavior_valid(int behavior)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	case MADV_HUGEPAGE:
+	case MADV_NOHUGEPAGE:
 #endif
 		return 1;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

