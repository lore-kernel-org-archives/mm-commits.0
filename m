From: akpm@linux-foundation.org
Subject: + mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:21:08 -0700
Message-ID: <20121030222108.C266D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43920 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab2J3WVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:21:09 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so91363yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:21:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, aarcange@redhat.com, cmetcalf@tilera.com, hannes@cmpxchg.org, kirill@shutemov.name, nizhan.chen@gmail.com


The patch titled
     Subject: mm: thp: set the accessed flag for old pages on access fault
has been added to the -mm tree.  Its filename is
     mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 mm/memory.c             |    7 ++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

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
@@ -947,6 +947,28 @@ out:
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
@@ -3648,12 +3648,14 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd) && !pmd_trans_splitting(orig_pmd)) {
+			unsigned int dirty = flags & FAULT_FLAG_WRITE;
+
 			if (pmd_numa(vma, orig_pmd)) {
 				do_huge_pmd_numa_page(mm, vma, address, pmd,
 						      flags, orig_pmd);
 			}
 
-			if ((flags & FAULT_FLAG_WRITE) && !pmd_write(orig_pmd)) {
+			if (dirty && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
 				/*
@@ -3663,6 +3665,9 @@ retry:
 				 */
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
+			} else {
+				huge_pmd_set_accessed(mm, vma, address, pmd,
+						      orig_pmd, dirty);
 			}
 
 			return ret;
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

