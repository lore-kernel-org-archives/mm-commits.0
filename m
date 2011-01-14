From: akpm@linux-foundation.org
Subject: [merged] thp-khugepaged-make-khugepaged-aware-of-madvise.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:47 -0800
Message-ID: <201101142251.p0EMpbTk005533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1ANWvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     thp: khugepaged: make khugepaged aware about madvise
has been removed from the -mm tree.  Its filename was
     thp-khugepaged-make-khugepaged-aware-of-madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: khugepaged: make khugepaged aware about madvise
From: Andrea Arcangeli <aarcange@redhat.com>

MADV_HUGEPAGE and MADV_NOHUGEPAGE were fully effective only if run after
mmap and before touching the memory.  While this is enough for most
usages, it's little effort to make madvise more dynamic at runtime on an
existing mapping by making khugepaged aware about madvise.

MADV_HUGEPAGE: register in khugepaged immediately without waiting a page
fault (that may not ever happen if all pages are already mapped and the
"enabled" knob was set to madvise during the initial page faults).

MADV_NOHUGEPAGE: skip vmas marked VM_NOHUGEPAGE in khugepaged to stop
collapsing pages where not needed.

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ++++--
 mm/huge_memory.c        |   23 +++++++++++++++++++----
 mm/madvise.c            |    2 +-
 3 files changed, 24 insertions(+), 7 deletions(-)

diff -puN include/linux/huge_mm.h~thp-khugepaged-make-khugepaged-aware-of-madvise include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/include/linux/huge_mm.h
@@ -105,7 +105,8 @@ extern void __split_huge_page_pmd(struct
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
-extern int hugepage_madvise(unsigned long *vm_flags, int advice);
+extern int hugepage_madvise(struct vm_area_struct *vma,
+			    unsigned long *vm_flags, int advice);
 extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
@@ -143,7 +144,8 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
-static inline int hugepage_madvise(unsigned long *vm_flags, int advice)
+static inline int hugepage_madvise(struct vm_area_struct *vma,
+				   unsigned long *vm_flags, int advice)
 {
 	BUG();
 	return 0;
diff -puN mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise mm/huge_memory.c
--- a/mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/mm/huge_memory.c
@@ -1389,7 +1389,8 @@ out:
 	return ret;
 }
 
-int hugepage_madvise(unsigned long *vm_flags, int advice)
+int hugepage_madvise(struct vm_area_struct *vma,
+		     unsigned long *vm_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
@@ -1404,6 +1405,13 @@ int hugepage_madvise(unsigned long *vm_f
 			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
+		/*
+		 * If the vma become good for khugepaged to scan,
+		 * register it here without waiting a page fault that
+		 * may not happen any time soon.
+		 */
+		if (unlikely(khugepaged_enter_vma_merge(vma)))
+			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
 		/*
@@ -1417,6 +1425,11 @@ int hugepage_madvise(unsigned long *vm_f
 			return -EINVAL;
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
+		/*
+		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
+		 * this vma even if we leave the mm registered in khugepaged if
+		 * it got registered before VM_NOHUGEPAGE was set.
+		 */
 		break;
 	}
 
@@ -1784,7 +1797,8 @@ static void collapse_huge_page(struct mm
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
 		goto out;
 
-	if (!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
+	    (vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
 	/* VM_PFNMAP vmas may have vm_ops null but vm_file set */
@@ -2007,8 +2021,9 @@ static unsigned int khugepaged_scan_mm_s
 			break;
 		}
 
-		if (!(vma->vm_flags & VM_HUGEPAGE) &&
-		    !khugepaged_always()) {
+		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
+		     !khugepaged_always()) ||
+		    (vma->vm_flags & VM_NOHUGEPAGE)) {
 			progress++;
 			continue;
 		}
diff -puN mm/madvise.c~thp-khugepaged-make-khugepaged-aware-of-madvise mm/madvise.c
--- a/mm/madvise.c~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/mm/madvise.c
@@ -73,7 +73,7 @@ static long madvise_behavior(struct vm_a
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(&new_flags, behavior);
+		error = hugepage_madvise(vma, &new_flags, behavior);
 		if (error)
 			goto out;
 		break;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

