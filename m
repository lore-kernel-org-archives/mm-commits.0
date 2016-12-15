From: akpm@linux-foundation.org
Subject: [merged] mm-change-return-values-of-finish_mkwrite_fault.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:47:51 -0800
Message-ID: <5852e557.i7UDrohhEB14S3FO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754262AbcLOSrw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change return values of finish_mkwrite_fault()
has been removed from the -mm tree.  Its filename was
     mm-change-return-values-of-finish_mkwrite_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: change return values of finish_mkwrite_fault()

Currently finish_mkwrite_fault() returns 0 when PTE got changed before
we acquired PTE lock and VM_FAULT_WRITE when we succeeded in modifying
the PTE. This is somewhat confusing since 0 generally means success, it
is also inconsistent with finish_fault() which returns 0 on success.
Change finish_mkwrite_fault() to return 0 on success and VM_FAULT_NOPAGE
when PTE changed. Practically, there should be no behavioral difference
since we bail out from the fault the same way regardless whether we
return 0, VM_FAULT_NOPAGE, or VM_FAULT_WRITE. Also note that
VM_FAULT_WRITE has no effect for shared mappings since the only two
places that check it - KSM and GUP - care about private mappings only.
Generally the meaning of VM_FAULT_WRITE for shared mappings is not well
defined and we should probably clean that up.

Link: http://lkml.kernel.org/r/1479460644-25076-17-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-change-return-values-of-finish_mkwrite_fault mm/memory.c
--- a/mm/memory.c~mm-change-return-values-of-finish_mkwrite_fault
+++ a/mm/memory.c
@@ -2295,10 +2295,10 @@ int finish_mkwrite_fault(struct vm_fault
 	 */
 	if (!pte_same(*vmf->pte, vmf->orig_pte)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
+		return VM_FAULT_NOPAGE;
 	}
 	wp_page_reuse(vmf);
-	return VM_FAULT_WRITE;
+	return 0;
 }
 
 /*
@@ -2341,8 +2341,7 @@ static int wp_page_shared(struct vm_faul
 			return tmp;
 		}
 		tmp = finish_mkwrite_fault(vmf);
-		if (unlikely(!tmp || (tmp &
-				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+		if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
 			unlock_page(vmf->page);
 			put_page(vmf->page);
 			return tmp;
_

Patches currently in -mm which might be from jack@suse.cz are


