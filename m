From: akpm@linux-foundation.org
Subject: [merged] mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:38 -0800
Message-ID: <20121212195838.C2B9E820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:49455 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:39 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so117766yen.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, aarcange@redhat.com, cmetcalf@tilera.com, hannes@cmpxchg.org, kirill@shutemov.name, nizhan.chen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: set the accessed flag for old pages on access fault
has been removed from the -mm tree.  Its filename was
     mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm: thp: set the accessed flag for old pages on access fault

On x86 memory accesses to pages without the ACCESSED flag set result in
the ACCESSED flag being set automatically.  With the ARM architecture a
page access fault is raised instead (and it will continue to be raised
until the ACCESSED flag is set for the appropriate PTE/PMD).

For normal memory pages, handle_pte_fault will call pte_mkyoung
(effectively setting the ACCESSED flag).  For transparent huge pages,
pmd_mkyoung will only be called for a write fault.

This patch ensures that faults on transparent hugepages which do not
result in a CoW update the access flags for the faulting pmd.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++++
 mm/huge_memory.c        |   22 ++++++++++++++++++++++
 mm/memory.c             |    8 ++++++--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/include/linux/huge_mm.h
@@ -8,6 +8,10 @@ extern int do_huge_pmd_anonymous_page(st
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 			 struct vm_area_struct *vma);
+extern void huge_pmd_set_accessed(struct mm_struct *mm,
+				  struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd,
+				  pmd_t orig_pmd, int dirty);
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
diff -puN mm/huge_memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/mm/huge_memory.c
@@ -784,6 +784,28 @@ out:
 	return ret;
 }
 
+void huge_pmd_set_accessed(struct mm_struct *mm,
+			   struct vm_area_struct *vma,
+			   unsigned long address,
+			   pmd_t *pmd, pmd_t orig_pmd,
+			   int dirty)
+{
+	pmd_t entry;
+	unsigned long haddr;
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, orig_pmd)))
+		goto unlock;
+
+	entry = pmd_mkyoung(orig_pmd);
+	haddr = address & HPAGE_PMD_MASK;
+	if (pmdp_set_access_flags(vma, haddr, pmd, entry, dirty))
+		update_mmu_cache_pmd(vma, address, pmd);
+
+unlock:
+	spin_unlock(&mm->page_table_lock);
+}
+
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
diff -puN mm/memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault mm/memory.c
--- a/mm/memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/mm/memory.c
@@ -3537,8 +3537,9 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
-			    !pmd_write(orig_pmd) &&
+			unsigned int dirty = flags & FAULT_FLAG_WRITE;
+
+			if (dirty && !pmd_write(orig_pmd) &&
 			    !pmd_trans_splitting(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
@@ -3550,6 +3551,9 @@ retry:
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
 				return ret;
+			} else {
+				huge_pmd_set_accessed(mm, vma, address, pmd,
+						      orig_pmd, dirty);
 			}
 			return 0;
 		}
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

