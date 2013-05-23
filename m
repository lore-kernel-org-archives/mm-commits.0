From: akpm@linux-foundation.org
Subject: + mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch added to -mm tree
Date: Thu, 23 May 2013 16:40:21 -0700
Message-ID: <519ea8e5.Zlh20crmk+dc1wkO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898Ab3EWXkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mel@csn.ul.ie, kosaki.motohiro@gmail.com, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, dsterba@suse.cz, dave.hansen@intel.com, aarcange@redhat.com, cpw@sgi.com

Subject: + mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch added to -mm tree
To: cpw@sgi.com,aarcange@redhat.com,dave.hansen@intel.com,dsterba@suse.cz,hannes@cmpxchg.org,kirill.shutemov@linux.intel.com,kosaki.motohiro@gmail.com,mel@csn.ul.ie,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:40:21 -0700


The patch titled
     Subject: mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
has been added to the -mm tree.  Its filename is
     mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cliff Wickman <cpw@sgi.com>
Subject: mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

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

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   65 ++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff -puN mm/pagewalk.c~mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas
+++ a/mm/pagewalk.c
@@ -127,22 +127,6 @@ static int walk_hugetlb_range(struct vm_
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
 static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
 {
@@ -198,30 +182,53 @@ int walk_page_range(unsigned long addr,
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

mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas.patch

