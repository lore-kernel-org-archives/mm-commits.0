From: akpm@linux-foundation.org
Subject: + mm-use-passed-vm_fault-structure-in-__do_fault.patch added to
 -mm tree
Date: Tue, 22 Nov 2016 16:15:06 -0800
Message-ID: <5834df8a.mmbPc8lmwV9RDxKh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbcKWAPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use passed vm_fault structure in __do_fault()
has been added to the -mm tree.  Its filename is
     mm-use-passed-vm_fault-structure-in-__do_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-passed-vm_fault-structure-in-__do_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-passed-vm_fault-structure-in-__do_fault.patch

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
Subject: mm: use passed vm_fault structure in __do_fault()

Instead of creating another vm_fault structure, use the one passed to
__do_fault() for passing arguments into fault handler.

Link: http://lkml.kernel.org/r/1479460644-25076-5-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN mm/memory.c~mm-use-passed-vm_fault-structure-in-__do_fault mm/memory.c
--- a/mm/memory.c~mm-use-passed-vm_fault-structure-in-__do_fault
+++ a/mm/memory.c
@@ -2848,37 +2848,31 @@ static int __do_fault(struct vm_fault *v
 		      struct page **page, void **entry)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct vm_fault vmf2;
 	int ret;
 
-	vmf2.address = vmf->address;
-	vmf2.pgoff = vmf->pgoff;
-	vmf2.flags = vmf->flags;
-	vmf2.page = NULL;
-	vmf2.gfp_mask = __get_fault_gfp_mask(vma);
-	vmf2.cow_page = cow_page;
+	vmf->cow_page = cow_page;
 
-	ret = vma->vm_ops->fault(vma, &vmf2);
+	ret = vma->vm_ops->fault(vma, vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 	if (ret & VM_FAULT_DAX_LOCKED) {
-		*entry = vmf2.entry;
+		*entry = vmf->entry;
 		return ret;
 	}
 
-	if (unlikely(PageHWPoison(vmf2.page))) {
+	if (unlikely(PageHWPoison(vmf->page))) {
 		if (ret & VM_FAULT_LOCKED)
-			unlock_page(vmf2.page);
-		put_page(vmf2.page);
+			unlock_page(vmf->page);
+		put_page(vmf->page);
 		return VM_FAULT_HWPOISON;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf2.page);
+		lock_page(vmf->page);
 	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf2.page), vmf2.page);
+		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
 
-	*page = vmf2.page;
+	*page = vmf->page;
 	return ret;
 }
 
@@ -3614,6 +3608,7 @@ static int __handle_mm_fault(struct vm_a
 		.address = address & PAGE_MASK,
 		.flags = flags,
 		.pgoff = linear_page_index(vma, address),
+		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
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

