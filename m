From: akpm@linux-foundation.org
Subject: [merged] mm-provide-helper-for-finishing-mkwrite-faults.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:48 -0800
Message-ID: <5852e554.EfC2Db2+ZBueXczZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbcLOSrt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide helper for finishing mkwrite faults
has been removed from the -mm tree.  Its filename was
     mm-provide-helper-for-finishing-mkwrite-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: provide helper for finishing mkwrite faults

Provide a helper function for finishing write faults due to PTE being
read-only.  The helper will be used by DAX to avoid the need of
complicating generic MM code with DAX locking specifics.

Link: http://lkml.kernel.org/r/1479460644-25076-16-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/memory.c        |   67 +++++++++++++++++++++++++------------------
 2 files changed, 41 insertions(+), 27 deletions(-)

diff -puN include/linux/mm.h~mm-provide-helper-for-finishing-mkwrite-faults include/linux/mm.h
--- a/include/linux/mm.h~mm-provide-helper-for-finishing-mkwrite-faults
+++ a/include/linux/mm.h
@@ -615,6 +615,7 @@ static inline pte_t maybe_mkwrite(pte_t
 int alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
 		struct page *page);
 int finish_fault(struct vm_fault *vmf);
+int finish_mkwrite_fault(struct vm_fault *vmf);
 #endif
 
 /*
diff -puN mm/memory.c~mm-provide-helper-for-finishing-mkwrite-faults mm/memory.c
--- a/mm/memory.c~mm-provide-helper-for-finishing-mkwrite-faults
+++ a/mm/memory.c
@@ -2269,6 +2269,38 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+/**
+ * finish_mkwrite_fault - finish page fault for a shared mapping, making PTE
+ *			  writeable once the page is prepared
+ *
+ * @vmf: structure describing the fault
+ *
+ * This function handles all that is needed to finish a write page fault in a
+ * shared mapping due to PTE being read-only once the mapped page is prepared.
+ * It handles locking of PTE and modifying it. The function returns
+ * VM_FAULT_WRITE on success, 0 when PTE got changed before we acquired PTE
+ * lock.
+ *
+ * The function expects the page to be locked or other protection against
+ * concurrent faults / writeback (such as DAX radix tree locks).
+ */
+int finish_mkwrite_fault(struct vm_fault *vmf)
+{
+	WARN_ON_ONCE(!(vmf->vma->vm_flags & VM_SHARED));
+	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd, vmf->address,
+				       &vmf->ptl);
+	/*
+	 * We might have raced with another page fault while we released the
+	 * pte_offset_map_lock.
+	 */
+	if (!pte_same(*vmf->pte, vmf->orig_pte)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	wp_page_reuse(vmf);
+	return VM_FAULT_WRITE;
+}
+
 /*
  * Handle write page faults for VM_MIXEDMAP or VM_PFNMAP for a VM_SHARED
  * mapping
@@ -2285,16 +2317,7 @@ static int wp_pfn_shared(struct vm_fault
 		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
 		if (ret & VM_FAULT_ERROR)
 			return ret;
-		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				vmf->address, &vmf->ptl);
-		/*
-		 * We might have raced with another page fault while we
-		 * released the pte_offset_map_lock.
-		 */
-		if (!pte_same(*vmf->pte, vmf->orig_pte)) {
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			return 0;
-		}
+		return finish_mkwrite_fault(vmf);
 	}
 	wp_page_reuse(vmf);
 	return VM_FAULT_WRITE;
@@ -2304,7 +2327,6 @@ static int wp_page_shared(struct vm_faul
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	int page_mkwrite = 0;
 
 	get_page(vmf->page);
 
@@ -2318,26 +2340,17 @@ static int wp_page_shared(struct vm_faul
 			put_page(vmf->page);
 			return tmp;
 		}
-		/*
-		 * Since we dropped the lock we need to revalidate
-		 * the PTE as someone else may have changed it.  If
-		 * they did, we just return, as we can count on the
-		 * MMU to tell us if they didn't also make it writable.
-		 */
-		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-						vmf->address, &vmf->ptl);
-		if (!pte_same(*vmf->pte, vmf->orig_pte)) {
+		tmp = finish_mkwrite_fault(vmf);
+		if (unlikely(!tmp || (tmp &
+				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			unlock_page(vmf->page);
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			put_page(vmf->page);
-			return 0;
+			return tmp;
 		}
-		page_mkwrite = 1;
-	}
