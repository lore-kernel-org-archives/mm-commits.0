From: akpm@linux-foundation.org
Subject: + mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups.patch added to -mm tree
Date: Tue, 19 Apr 2011 11:37:30 -0700
Message-ID: <201104191837.p3JIbUWQ016132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab1DSSi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 14:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, bugs@casparzhang.com, mel@csn.ul.ie, riel@redhat.com, stable@kernel.org


The patch titled
     mm: thp: fix /dev/zero MAP_PRIVATE and vm_flags cleanups
has been added to the -mm tree.  Its filename is
     mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: thp: fix /dev/zero MAP_PRIVATE and vm_flags cleanups
From: Andrea Arcangeli <aarcange@redhat.com>

The huge_memory.c THP page fault was allowed to run if vm_ops was null
(which would succeed for /dev/zero MAP_PRIVATE, as the f_op->mmap wouldn't
setup a special vma->vm_ops and it would fallback to regular anonymous
memory) but other THP logics weren't fully activated for vmas with vm_file
not NULL (/dev/zero has a not NULL vma->vm_file).

So this removes the vm_file checks so that /dev/zero also can safely use
THP (the other albeit safer approach to fix this bug would have been to
prevent the THP initial page fault to run if vm_file was set).

After removing the vm_file checks, this also makes huge_memory.c stricter
in khugepaged for the DEBUG_VM=y case.  It doesn't replace the vm_file
check with a is_pfn_mapping check (but it keeps checking for VM_PFNMAP
under VM_BUG_ON) because for a is_cow_mapping() mapping VM_PFNMAP should
only be allowed to exist before the first page fault, and in turn when
vma->anon_vma is null (so preventing khugepaged registration).  So I tend
to think the previous comment saying if vm_file was set, VM_PFNMAP might
have been set and we could still be registered in khugepaged (despite
anon_vma was not NULL to be registered in khugepaged) was too paranoid. 
The is_linear_pfn_mapping check is also I think superfluous (as described
by comment) but under DEBUG_VM it is safe to stay.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=33682

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Caspar Zhang <bugs@casparzhang.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 -
 include/linux/mm.h      |    3 +-
 mm/huge_memory.c        |   43 +++++++++++++++++++++-----------------
 3 files changed, 27 insertions(+), 21 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups
+++ a/include/linux/huge_mm.h
@@ -117,7 +117,7 @@ static inline void vma_adjust_trans_huge
 					 unsigned long end,
 					 long adjust_next)
 {
-	if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+	if (!vma->anon_vma || vma->vm_ops)
 		return;
 	__vma_adjust_trans_huge(vma, start, end, adjust_next);
 }
diff -puN include/linux/mm.h~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups
+++ a/include/linux/mm.h
@@ -137,7 +137,8 @@ extern unsigned int kobjsize(const void 
 #define VM_RandomReadHint(v)		((v)->vm_flags & VM_RAND_READ)
 
 /*
- * special vmas that are non-mergable, non-mlock()able
+ * Special vmas that are non-mergable, non-mlock()able.
+ * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_RESERVED | VM_PFNMAP)
 
diff -puN mm/huge_memory.c~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-dev-zero-map_private-and-vm_flags-cleanups
+++ a/mm/huge_memory.c
@@ -1408,6 +1408,9 @@ out:
 	return ret;
 }
 
+#define VM_NO_THP (VM_SPECIAL|VM_INSERTPAGE|VM_MIXEDMAP|VM_SAO| \
+		   VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
@@ -1416,11 +1419,7 @@ int hugepage_madvise(struct vm_area_stru
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
-		if (*vm_flags & (VM_HUGEPAGE |
-				 VM_SHARED   | VM_MAYSHARE   |
-				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
-				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
-				 VM_MIXEDMAP | VM_SAO))
+		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
@@ -1436,11 +1435,7 @@ int hugepage_madvise(struct vm_area_stru
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
-		if (*vm_flags & (VM_NOHUGEPAGE |
-				 VM_SHARED   | VM_MAYSHARE   |
-				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
-				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
-				 VM_MIXEDMAP | VM_SAO))
+		if (*vm_flags & (VM_NOHUGEPAGE | VM_NO_THP))
 			return -EINVAL;
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
@@ -1574,10 +1569,14 @@ int khugepaged_enter_vma_merge(struct vm
 		 * page fault if needed.
 		 */
 		return 0;
-	if (vma->vm_file || vma->vm_ops)
+	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || is_pfn_mapping(vma));
+	/*
+	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
+	 * true too, verify it here.
+	 */
+	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
@@ -1828,12 +1827,15 @@ static void collapse_huge_page(struct mm
 	    (vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
-	/* VM_PFNMAP vmas may have vm_ops null but vm_file set */
-	if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+	if (!vma->anon_vma || vma->vm_ops)
 		goto out;
 	if (is_vma_temporary_stack(vma))
 		goto out;
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || is_pfn_mapping(vma));
+	/*
+	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
+	 * true too, verify it here.
+	 */
+	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -2066,13 +2068,16 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			continue;
 		}
-		/* VM_PFNMAP vmas may have vm_ops null but vm_file set */
-		if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+		if (!vma->anon_vma || vma->vm_ops)
 			goto skip;
 		if (is_vma_temporary_stack(vma))
 			goto skip;
