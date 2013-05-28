From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch removed
 from -mm tree
Date: Tue, 28 May 2013 12:37:23 -0700
Message-ID: <51a50773.WaLOflqSAETmLSF7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3E1ThY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mel@csn.ul.ie, kosaki.motohiro@gmail.com, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, dsterba@suse.cz, dave.hansen@intel.com, aarcange@redhat.com, cpw@sgi.com

Subject: [merged] mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch removed from -mm tree
To: cpw@sgi.com,aarcange@redhat.com,dave.hansen@intel.com,dsterba@suse.cz,hannes@cmpxchg.org,kirill.shutemov@linux.intel.com,kosaki.motohiro@gmail.com,mel@csn.ul.ie,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:23 -0700


The patch titled
     Subject: mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
has been removed from the -mm tree.  Its filename was
     mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cliff Wickman <cpw@sgi.com>
Subject: mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

A panic can be caused by simply cat'ing /proc/<pid>/smaps while an
application has a VM_PFNMAP range.  It happened in-house when a
benchmarker was trying to decipher the memory layout of his program.


/proc/<pid>/smaps and similar walks through a user page table should not
be looking at VM_PFNMAP areas.

Certain tests in walk_page_range() (specifically split_huge_page_pmd())
assume that all the mapped PFN's are backed with page structures.  And
this is not usually true for VM_PFNMAP areas.  This can result in panics
on kernel page faults when attempting to address those page structures.

There are a half dozen callers of walk_page_range() that walk through a
task's entire page table (as N.  Horiguchi pointed out).  So rather than
change all of them, this patch changes just walk_page_range() to ignore
VM_PFNMAP areas.

The logic of hugetlb_vma() is moved back into walk_page_range(), as we
want to test any vma in the range.

VM_PFNMAP areas are used by:
- graphics memory manager   gpu/drm/drm_gem.c
- global reference unit     sgi-gru/grufile.c
- sgi special memory        char/mspec.c
- and probably several out-of-tree modules

[akpm@linux-foundation.org: remove now-unused hugetlb_vma() stub]
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   70 ++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff -puN mm/pagewalk.c~mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas
+++ a/mm/pagewalk.c
@@ -127,28 +127,7 @@ static int walk_hugetlb_range(struct vm_
 	return 0;
 }
 
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	struct vm_area_struct *vma;
-
-	/* We don't need vma lookup at all. */
-	if (!walk->hugetlb_entry)
-		return NULL;
-
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
-	vma = find_vma(walk->mm, addr);
-	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
-		return vma;
-
-	return NULL;
-}
-
 #else /* CONFIG_HUGETLB_PAGE */
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	return NULL;
-}
-
 static int walk_hugetlb_range(struct vm_area_struct *vma,
 			      unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
@@ -198,30 +177,53 @@ int walk_page_range(unsigned long addr,
 	if (!walk->mm)
 		return -EINVAL;
 
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *vma;
+		struct vm_area_struct *vma = NULL;
 
 		next = pgd_addr_end(addr, end);
 
 		/*
-		 * handle hugetlb vma individually because pagetable walk for
-		 * the hugetlb page is dependent on the architecture and
-		 * we can't handled it in the same manner as non-huge pages.
+		 * This function was not intended to be vma based.
+		 * But there are vma special cases to be handled:
+		 * - hugetlb vma's
+		 * - VM_PFNMAP vma's
 		 */
-		vma = hugetlb_vma(addr, walk);
+		vma = find_vma(walk->mm, addr);
 		if (vma) {
-			if (vma->vm_end < next)
+			/*
+			 * There are no page structures backing a VM_PFNMAP
+			 * range, so do not allow split_huge_page_pmd().
+			 */
+			if ((vma->vm_start <= addr) &&
+			    (vma->vm_flags & VM_PFNMAP)) {
 				next = vma->vm_end;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 			/*
-			 * Hugepage is very tightly coupled with vma, so
-			 * walk through hugetlb entries within a given vma.
+			 * Handle hugetlb vma individually because pagetable
+			 * walk for the hugetlb page is dependent on the
+			 * architecture and we can't handled it in the same
+			 * manner as non-huge pages.
 			 */
-			err = walk_hugetlb_range(vma, addr, next, walk);
-			if (err)
-				break;
-			pgd = pgd_offset(walk->mm, next);
-			continue;
+			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
+			    is_vm_hugetlb_page(vma)) {
+				if (vma->vm_end < next)
+					next = vma->vm_end;
+				/*
+				 * Hugepage is very tightly coupled with vma,
+				 * so walk through hugetlb entries within a
+				 * given vma.
+				 */
+				err = walk_hugetlb_range(vma, addr, next, walk);
+				if (err)
+					break;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 		}
 
 		if (pgd_none_or_clear_bad(pgd)) {
_

Patches currently in -mm which might be from cpw@sgi.com are


