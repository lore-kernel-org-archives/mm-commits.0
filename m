From: akpm@linux-foundation.org
Subject: [merged] mm-use-passed-vm_fault-structure-in-__do_fault.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:23 -0800
Message-ID: <5852e53b.loMyZy6F4WSQ55EL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756371AbcLOSrY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use passed vm_fault structure in __do_fault()
has been removed from the -mm tree.  Its filename was
     mm-use-passed-vm_fault-structure-in-__do_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


