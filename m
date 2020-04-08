From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-wp-apply-_page_uffd_wp-bit.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:57:54 -0700
Message-ID: <20200408015754.5kJRiycAq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgDHB54 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@openvz.org


The patch titled
     Subject: userfaultfd: wp: apply _PAGE_UFFD_WP bit
has been removed from the -mm tree.  Its filename was
     userfaultfd-wp-apply-_page_uffd_wp-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: wp: apply _PAGE_UFFD_WP bit

Firstly, introduce two new flags MM_CP_UFFD_WP[_RESOLVE] for
change_protection() when used with uffd-wp and make sure the two new flags
are exclusively used.  Then,

  - For MM_CP_UFFD_WP: apply the _PAGE_UFFD_WP bit and remove _PAGE_RW
    when a range of memory is write protected by uffd

  - For MM_CP_UFFD_WP_RESOLVE: remove the _PAGE_UFFD_WP bit and recover
    _PAGE_RW when write protection is resolved from userspace

And use this new interface in mwriteprotect_range() to replace the old
MM_CP_DIRTY_ACCT.

Do this change for both PTEs and huge PMDs.  Then we can start to identify
which PTE/PMD is write protected by general (e.g., COW or soft dirty
tracking), and which is for userfaultfd-wp.

Since we should keep the _PAGE_UFFD_WP when doing pte_modify(), add it
into _PAGE_CHG_MASK as well.  Meanwhile, since we have this new bit, we
can be even more strict when detecting uffd-wp page faults in either
do_wp_page() or wp_huge_pmd().

After we're with _PAGE_UFFD_WP, a special case is when a page is both
protected by the general COW logic and also userfault-wp.  Here the
userfault-wp will have higher priority and will be handled first.  Only
after the uffd-wp bit is cleared on the PTE/PMD will we continue to handle
the general COW.  These are the steps on what will happen with such a
page:

  1. CPU accesses write protected shared page (so both protected by
     general COW and uffd-wp), blocked by uffd-wp first because in
     do_wp_page we'll handle uffd-wp first, so it has higher priority
     than general COW.

  2. Uffd service thread receives the request, do UFFDIO_WRITEPROTECT
     to remove the uffd-wp bit upon the PTE/PMD.  However here we
     still keep the write bit cleared.  Notify the blocked CPU.

  3. The blocked CPU resumes the page fault process with a fault
     retry, during retry it'll notice it was not with the uffd-wp bit
     this time but it is still write protected by general COW, then
     it'll go though the COW path in the fault handler, copy the page,
     apply write bit where necessary, and retry again.

  4. The CPU will be able to access this page with write bit set.

Link: http://lkml.kernel.org/r/20200220163112.11409-8-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 mm/huge_memory.c   |   18 +++++++++++++++++-
 mm/memory.c        |    4 ++--
 mm/mprotect.c      |   17 +++++++++++++++++
 mm/userfaultfd.c   |    8 ++++++--
 5 files changed, 47 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~userfaultfd-wp-apply-_page_uffd_wp-bit
+++ a/include/linux/mm.h
@@ -1782,6 +1782,11 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_DIRTY_ACCT                  (1UL << 0)
 /* Whether this protection change is for NUMA hints */
 #define  MM_CP_PROT_NUMA                   (1UL << 1)
+/* Whether this change is for write protecting */
+#define  MM_CP_UFFD_WP                     (1UL << 2) /* do wp */
+#define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
+#define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
+					    MM_CP_UFFD_WP_RESOLVE)
 
 extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
--- a/mm/huge_memory.c~userfaultfd-wp-apply-_page_uffd_wp-bit
+++ a/mm/huge_memory.c
@@ -1987,6 +1987,8 @@ int change_huge_pmd(struct vm_area_struc
 	bool preserve_write;
 	int ret;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
@@ -2053,6 +2055,17 @@ int change_huge_pmd(struct vm_area_struc
 	entry = pmd_modify(entry, newprot);
 	if (preserve_write)
 		entry = pmd_mk_savedwrite(entry);
+	if (uffd_wp) {
+		entry = pmd_wrprotect(entry);
+		entry = pmd_mkuffd_wp(entry);
+	} else if (uffd_wp_resolve) {
+		/*
+		 * Leave the write bit to be handled by PF interrupt
+		 * handler, then things like COW could be properly
+		 * handled.
+		 */
+		entry = pmd_clear_uffd_wp(entry);
+	}
 	ret = HPAGE_PMD_NR;
 	set_pmd_at(mm, addr, pmd, entry);
 	BUG_ON(vma_is_anonymous(vma) && !preserve_write && pmd_write(entry));
@@ -2201,7 +2214,7 @@ static void __split_huge_pmd_locked(stru
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
-	bool young, write, soft_dirty, pmd_migration = false;
+	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
 	unsigned long addr;
 	int i;
 
@@ -2283,6 +2296,7 @@ static void __split_huge_pmd_locked(stru
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
+		uffd_wp = pmd_uffd_wp(old_pmd);
 	}
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	page_ref_add(page, HPAGE_PMD_NR - 1);
@@ -2316,6 +2330,8 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_mkold(entry);
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
+			if (uffd_wp)
+				entry = pte_mkuffd_wp(entry);
 		}
 		pte = pte_offset_map(&_pmd, addr);
 		BUG_ON(!pte_none(*pte));
--- a/mm/memory.c~userfaultfd-wp-apply-_page_uffd_wp-bit
+++ a/mm/memory.c
@@ -2752,7 +2752,7 @@ static vm_fault_t do_wp_page(struct vm_f
 {
 	struct vm_area_struct *vma = vmf->vma;
 
-	if (userfaultfd_wp(vma)) {
+	if (userfaultfd_pte_wp(vma, *vmf->pte)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return handle_userfault(vmf, VM_UFFD_WP);
 	}
@@ -3954,7 +3954,7 @@ static inline vm_fault_t create_huge_pmd
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	if (vma_is_anonymous(vmf->vma)) {
-		if (userfaultfd_wp(vmf->vma))
+		if (userfaultfd_huge_pmd_wp(vmf->vma, orig_pmd))
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
 	}
--- a/mm/mprotect.c~userfaultfd-wp-apply-_page_uffd_wp-bit
+++ a/mm/mprotect.c
@@ -45,6 +45,8 @@ static unsigned long change_pte_range(st
 	int target_node = NUMA_NO_NODE;
 	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
 	/*
 	 * Can be called with only the mmap_sem for reading by
@@ -116,6 +118,19 @@ static unsigned long change_pte_range(st
 			if (preserve_write)
 				ptent = pte_mk_savedwrite(ptent);
 
+			if (uffd_wp) {
+				ptent = pte_wrprotect(ptent);
+				ptent = pte_mkuffd_wp(ptent);
+			} else if (uffd_wp_resolve) {
+				/*
+				 * Leave the write bit to be handled
+				 * by PF interrupt handler, then
+				 * things like COW could be properly
+				 * handled.
+				 */
+				ptent = pte_clear_uffd_wp(ptent);
+			}
+
 			/* Avoid taking write faults for known dirty pages */
 			if (dirty_accountable && pte_dirty(ptent) &&
 					(pte_soft_dirty(ptent) ||
@@ -336,6 +351,8 @@ unsigned long change_protection(struct v
 {
 	unsigned long pages;
 
+	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);
 	else
--- a/mm/userfaultfd.c~userfaultfd-wp-apply-_page_uffd_wp-bit
+++ a/mm/userfaultfd.c
@@ -101,8 +101,12 @@ static int mcopy_atomic_pte(struct mm_st
 		goto out_release;
 
 	_dst_pte = pte_mkdirty(mk_pte(page, dst_vma->vm_page_prot));
-	if ((dst_vma->vm_flags & VM_WRITE) && !wp_copy)
-		_dst_pte = pte_mkwrite(_dst_pte);
+	if (dst_vma->vm_flags & VM_WRITE) {
+		if (wp_copy)
+			_dst_pte = pte_mkuffd_wp(_dst_pte);
+		else
+			_dst_pte = pte_mkwrite(_dst_pte);
+	}
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 	if (dst_vma->vm_file) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
