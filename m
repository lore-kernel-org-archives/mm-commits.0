From: akpm@linux-foundation.org
Subject: [patch 071/114] mm: pass vm_fault structure into
 do_page_mkwrite()
Date: Wed, 14 Dec 2016 15:07:30 -0800
Message-ID: <5851d0b2.qCI+3g2o3ul2F2gq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933626AbcLNXHb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: mm: pass vm_fault structure into do_page_mkwrite()

We will need more information in the ->page_mkwrite() helper for DAX to be
able to fully finish faults there.  Pass vm_fault structure to
do_page_mkwrite() and use it there so that information propagates properly
from upper layers.

Link: http://lkml.kernel.org/r/1479460644-25076-13-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~mm-pass-vm_fault-structure-into-do_page_mkwrite mm/memory.c
--- a/mm/memory.c~mm-pass-vm_fault-structure-into-do_page_mkwrite
+++ a/mm/memory.c
@@ -2034,20 +2034,17 @@ static gfp_t __get_fault_gfp_mask(struct
  *
  * We do this without the lock held, so that it can sleep if it needs to.
  */
-static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
-	       unsigned long address)
+static int do_page_mkwrite(struct vm_fault *vmf)
 {
-	struct vm_fault vmf;
 	int ret;
+	struct page *page = vmf->page;
+	unsigned int old_flags = vmf->flags;
 
-	vmf.address = address & PAGE_MASK;
-	vmf.pgoff = page->index;
-	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
-	vmf.gfp_mask = __get_fault_gfp_mask(vma);
-	vmf.page = page;
-	vmf.cow_page = NULL;
+	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 
-	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
+	ret = vmf->vma->vm_ops->page_mkwrite(vmf->vma, vmf);
+	/* Restore original flags so that caller is not surprised */
+	vmf->flags = old_flags;
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
@@ -2323,7 +2320,8 @@ static int wp_page_shared(struct vm_faul
 		int tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		tmp = do_page_mkwrite(vma, old_page, vmf->address);
+		vmf->page = old_page;
+		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(old_page);
@@ -3324,7 +3322,7 @@ static int do_shared_fault(struct vm_fau
 	 */
 	if (vma->vm_ops->page_mkwrite) {
 		unlock_page(vmf->page);
-		tmp = do_page_mkwrite(vma, vmf->page, vmf->address);
+		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp ||
 				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			put_page(vmf->page);
_
