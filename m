From: akpm@linux-foundation.org
Subject: [failures] mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch removed from -mm tree
Date: Fri, 19 Oct 2012 11:50:10 -0700
Message-ID: <20121019185011.369AE1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43860 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2JSSuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Oct 2012 14:50:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so86468qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 19 Oct 2012 11:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, aarcange@redhat.com, cmetcalf@tilera.com, davem@davemloft.net, kirill@shutemov.name, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: et the accessed flag for old pages on access fault
has been removed from the -mm tree.  Its filename was
     mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm: thp: et the accessed flag for old pages on access fault

On x86 memory accesses to pages without the ACCESSED flag set result in
the ACCESSED flag being set automatically.  With the ARM architecture a
page access fault is raised instead (and it will continue to be raised
until the ACCESSED flag is set for the appropriate PTE/PMD).

For normal memory pages, handle_pte_fault will call pte_mkyoung
(effectively setting the ACCESSED flag).  For transparent huge pages,
pmd_mkyoung will only be called for a write fault.

This patch ensures that faults on transparent hugepages which do not
result in a CoW update the access flags for the faulting pmd.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    8 ++++++++
 mm/memory.c             |    9 ++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/include/linux/huge_mm.h
@@ -8,6 +8,8 @@ extern int do_huge_pmd_anonymous_page(st
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 			 struct vm_area_struct *vma);
+extern void huge_pmd_set_accessed(struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmd, int dirty);
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
diff -puN mm/huge_memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/mm/huge_memory.c
@@ -879,6 +879,14 @@ out_free_pages:
 	goto out;
 }
 
+void huge_pmd_set_accessed(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmd, int dirty)
+{
+	pmd_t entry = pmd_mkyoung(*pmd);
+	if (pmdp_set_access_flags(vma, address & HPAGE_PMD_MASK, pmd, entry, dirty))
+		update_mmu_cache_pmd(vma, address, pmd);
+}
+
 int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd)
 {
diff -puN mm/memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault mm/memory.c
--- a/mm/memory.c~mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault
+++ a/mm/memory.c
@@ -3539,7 +3539,8 @@ retry:
 
 		barrier();
 		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
+			unsigned int dirty = flags & FAULT_FLAG_WRITE;
+			if (dirty &&
 			    !pmd_write(orig_pmd) &&
 			    !pmd_trans_splitting(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
@@ -3552,7 +3553,13 @@ retry:
 				if (unlikely(ret & VM_FAULT_OOM))
 					goto retry;
 				return ret;
+			} else if (pmd_trans_huge_lock(pmd, vma) == 1) {
+				if (likely(pmd_same(*pmd, orig_pmd)))
+					huge_pmd_set_accessed(vma, address, pmd,
+							      dirty);
+				spin_unlock(&mm->page_table_lock);
 			}
+
 			return 0;
 		}
 	}
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch

