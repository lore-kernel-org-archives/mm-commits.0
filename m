From: akpm@linux-foundation.org
Subject: + mm-trim-__do_fault-arguments.patch added to -mm tree
Date: Tue, 22 Nov 2016 16:15:08 -0800
Message-ID: <5834df8c.EQ/hSd/WniJXgpiX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbcKWAPI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trim __do_fault() arguments
has been added to the -mm tree.  Its filename is
     mm-trim-__do_fault-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-trim-__do_fault-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-trim-__do_fault-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: trim __do_fault() arguments

Use vm_fault structure to pass cow_page, page, and entry in and out of the
function.  That reduces number of __do_fault() arguments from 4 to 1.

Link: http://lkml.kernel.org/r/1479460644-25076-6-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   67 +++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 38 deletions(-)

diff -puN mm/memory.c~mm-trim-__do_fault-arguments mm/memory.c
--- a/mm/memory.c~mm-trim-__do_fault-arguments
+++ a/mm/memory.c
@@ -2844,26 +2844,22 @@ oom:
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
-static int __do_fault(struct vm_fault *vmf, struct page *cow_page,
-		      struct page **page, void **entry)
+static int __do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	int ret;
 
-	vmf->cow_page = cow_page;
-
 	ret = vma->vm_ops->fault(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
-	if (ret & VM_FAULT_DAX_LOCKED) {
-		*entry = vmf->entry;
+	if (ret & VM_FAULT_DAX_LOCKED)
 		return ret;
-	}
 
 	if (unlikely(PageHWPoison(vmf->page))) {
 		if (ret & VM_FAULT_LOCKED)
 			unlock_page(vmf->page);
 		put_page(vmf->page);
+		vmf->page = NULL;
 		return VM_FAULT_HWPOISON;
 	}
 
@@ -2872,7 +2868,6 @@ static int __do_fault(struct vm_fault *v
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
 
-	*page = vmf->page;
 	return ret;
 }
 
@@ -3208,7 +3203,6 @@ out:
 static int do_read_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page;
 	int ret = 0;
 
 	/*
@@ -3222,54 +3216,52 @@ static int do_read_fault(struct vm_fault
 			return ret;
 	}
 
-	ret = __do_fault(vmf, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	ret |= alloc_set_pte(vmf, NULL, vmf->page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-	unlock_page(fault_page);
+	unlock_page(vmf->page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		put_page(fault_page);
+		put_page(vmf->page);
 	return ret;
 }
 
 static int do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page, *new_page;
-	void *fault_entry;
 	struct mem_cgroup *memcg;
 	int ret;
 
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
-	if (!new_page)
+	vmf->cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
+	if (!vmf->cow_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_try_charge(new_page, vma->vm_mm, GFP_KERNEL,
+	if (mem_cgroup_try_charge(vmf->cow_page, vma->vm_mm, GFP_KERNEL,
 				&memcg, false)) {
-		put_page(new_page);
+		put_page(vmf->cow_page);
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vmf, new_page, &fault_page, &fault_entry);
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
 	if (!(ret & VM_FAULT_DAX_LOCKED))
-		copy_user_highpage(new_page, fault_page, vmf->address, vma);
-	__SetPageUptodate(new_page);
+		copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
+	__SetPageUptodate(vmf->cow_page);
 
-	ret |= alloc_set_pte(vmf, memcg, new_page);
+	ret |= alloc_set_pte(vmf, memcg, vmf->cow_page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
-		unlock_page(fault_page);
-		put_page(fault_page);
+		unlock_page(vmf->page);
+		put_page(vmf->page);
 	} else {
 		dax_unlock_mapping_entry(vma->vm_file->f_mapping, vmf->pgoff);
 	}
@@ -3277,20 +3269,19 @@ static int do_cow_fault(struct vm_fault
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	mem_cgroup_cancel_charge(new_page, memcg, false);
-	put_page(new_page);
+	mem_cgroup_cancel_charge(vmf->cow_page, memcg, false);
+	put_page(vmf->cow_page);
 	return ret;
 }
 
 static int do_shared_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *fault_page;
 	struct address_space *mapping;
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vmf, NULL, &fault_page, NULL);
+	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3299,26 +3290,26 @@ static int do_shared_fault(struct vm_fau
 	 * about to become writable
 	 */
 	if (vma->vm_ops->page_mkwrite) {
-		unlock_page(fault_page);
-		tmp = do_page_mkwrite(vma, fault_page, vmf->address);
+		unlock_page(vmf->page);
+		tmp = do_page_mkwrite(vma, vmf->page, vmf->address);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(fault_page);
+			put_page(vmf->page);
 			return tmp;
 		}
 	}
 
-	ret |= alloc_set_pte(vmf, NULL, fault_page);
+	ret |= alloc_set_pte(vmf, NULL, vmf->page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 					VM_FAULT_RETRY))) {
-		unlock_page(fault_page);
-		put_page(fault_page);
+		unlock_page(vmf->page);
+		put_page(vmf->page);
 		return ret;
 	}
 
-	if (set_page_dirty(fault_page))
+	if (set_page_dirty(vmf->page))
 		dirtied = 1;
 	/*
 	 * Take a local copy of the address_space - page.mapping may be zeroed
@@ -3326,8 +3317,8 @@ static int do_shared_fault(struct vm_fau
 	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = page_rmapping(fault_page);
-	unlock_page(fault_page);
+	mapping = page_rmapping(vmf->page);
+	unlock_page(vmf->page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
 		/*
 		 * Some device drivers do not set page.mapping but still
_

Patches currently in -mm which might be from jack@suse.cz are

mm-join-struct-fault_env-and-vm_fault.patch
mm-use-vmf-address-instead-of-of-vmf-virtual_address.patch
mm-use-pgoff-in-struct-vm_fault-instead-of-passing-it-separately.patch
mm-use-passed-vm_fault-structure-in-__do_fault.patch
mm-trim-__do_fault-arguments.patch
mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared.patch
mm-add-orig_pte-field-into-vm_fault.patch
mm-allow-full-handling-of-cow-faults-in-fault-handlers.patch
mm-factor-out-functionality-to-finish-page-faults.patch
mm-move-handling-of-cow-faults-into-dax-code.patch
mm-factor-out-common-parts-of-write-fault-handling.patch
mm-pass-vm_fault-structure-into-do_page_mkwrite.patch
mm-use-vmf-page-during-wp-faults.patch
mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch
mm-provide-helper-for-finishing-mkwrite-faults.patch
mm-change-return-values-of-finish_mkwrite_fault.patch
mm-export-follow_pte.patch
dax-make-cache-flushing-protected-by-entry-lock.patch
dax-protect-pte-modification-on-wp-fault-by-radix-tree-entry-lock.patch
dax-clear-dirty-entry-tags-on-cache-flush.patch

