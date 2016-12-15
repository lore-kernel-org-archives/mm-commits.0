From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared.patch removed from
 -mm tree
Date: Thu, 15 Dec 2016 10:47:29 -0800
Message-ID: <5852e541.aolR8azRiRb6G1FP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbcLOSra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use passed vm_fault structure for in wp_pfn_shared()
has been removed from the -mm tree.  Its filename was
     mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: use passed vm_fault structure for in wp_pfn_shared()

Instead of creating another vm_fault structure, use the one passed to
wp_pfn_shared() for passing arguments into pfn_mkwrite handler.

Link: http://lkml.kernel.org/r/1479460644-25076-7-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared mm/memory.c
--- a/mm/memory.c~mm-use-passed-vm_fault-structure-for-in-wp_pfn_shared
+++ a/mm/memory.c
@@ -2273,16 +2273,11 @@ static int wp_pfn_shared(struct vm_fault
 	struct vm_area_struct *vma = vmf->vma;
 
 	if (vma->vm_ops && vma->vm_ops->pfn_mkwrite) {
-		struct vm_fault vmf2 = {
-			.page = NULL,
-			.pgoff = vmf->pgoff,
-			.address = vmf->address,
-			.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE,
-		};
 		int ret;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		ret = vma->vm_ops->pfn_mkwrite(vma, &vmf2);
+		vmf->flags |= FAULT_FLAG_MKWRITE;
+		ret = vma->vm_ops->pfn_mkwrite(vma, vmf);
 		if (ret & VM_FAULT_ERROR)
 			return ret;
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
_

Patches currently in -mm which might be from jack@suse.cz are


