From: akpm@linux-foundation.org
Subject: [merged] mm-factor-out-functionality-to-finish-page-faults.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:35 -0800
Message-ID: <5852e547.VEkC863Y8xfXJtz6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932261AbcLOSrg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out functionality to finish page faults
has been removed from the -mm tree.  Its filename was
     mm-factor-out-functionality-to-finish-page-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: factor out functionality to finish page faults

Introduce finish_fault() as a helper function for finishing page faults. 
It is rather thin wrapper around alloc_set_pte() but since we'd want to
call this from DAX code or filesystems, it is still useful to avoid some
boilerplate code.

Link: http://lkml.kernel.org/r/1479460644-25076-10-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/memory.c        |   44 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-factor-out-functionality-to-finish-page-faults include/linux/mm.h
--- a/include/linux/mm.h~mm-factor-out-functionality-to-finish-page-faults
+++ a/include/linux/mm.h
@@ -620,6 +620,7 @@ static inline pte_t maybe_mkwrite(pte_t
 
 int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 		struct page *page);
+int finish_fault(struct vm_fault *vmf);
 #endif
 
 /*
diff -puN mm/memory.c~mm-factor-out-functionality-to-finish-page-faults mm/memory.c
--- a/mm/memory.c~mm-factor-out-functionality-to-finish-page-faults
+++ a/mm/memory.c
@@ -3074,6 +3074,38 @@ fault_handled:
 	return ret;
 }
 
+
+/**
+ * finish_fault - finish page fault once we have prepared the page to fault
+ *
+ * @vmf: structure describing the fault
+ *
+ * This function handles all that is needed to finish a page fault once the
+ * page to fault in is prepared. It handles locking of PTEs, inserts PTE for
+ * given page, adds reverse page mapping, handles memcg charges and LRU
+ * addition. The function returns 0 on success, VM_FAULT_ code in case of
+ * error.
+ *
+ * The function expects the page to be locked and on success it consumes a
+ * reference of a page being mapped (for the PTE which maps it).
+ */
+int finish_fault(struct vm_fault *vmf)
+{
+	struct page *page;
+	int ret;
+
+	/* Did we COW the page? */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !(vmf->vma->vm_flags & VM_SHARED))
+		page = vmf->cow_page;
+	else
+		page = vmf->page;
+	ret = alloc_set_pte(vmf, vmf->memcg, page);
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return ret;
+}
+
 static unsigned long fault_around_bytes __read_mostly =
 	rounddown_pow_of_two(65536);
 
@@ -3213,9 +3245,7 @@ static int do_read_fault(struct vm_fault
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	ret |= alloc_set_pte(vmf, NULL, vmf->page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	unlock_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		put_page(vmf->page);
@@ -3250,9 +3280,7 @@ static int do_cow_fault(struct vm_fault
 		copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
 	__SetPageUptodate(vmf->cow_page);
 
-	ret |= alloc_set_pte(vmf, vmf->memcg, vmf->cow_page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
 		unlock_page(vmf->page);
 		put_page(vmf->page);
@@ -3293,9 +3321,7 @@ static int do_shared_fault(struct vm_fau
 		}
 	}
 
-	ret |= alloc_set_pte(vmf, NULL, vmf->page);
-	if (vmf->pte)
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	ret |= finish_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
 		unlock_page(vmf->page);
_

Patches currently in -mm which might be from jack@suse.cz are


