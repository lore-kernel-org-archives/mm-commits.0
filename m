From: akpm@linux-foundation.org
Subject: + mm-change-return-values-of-finish_mkwrite_fault.patch added to
 -mm tree
Date: Tue, 22 Nov 2016 16:15:32 -0800
Message-ID: <5834dfa4.YMs9en6CEPO+s7JU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36616 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755690AbcKWAPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change return values of finish_mkwrite_fault()
has been added to the -mm tree.  Its filename is
     mm-change-return-values-of-finish_mkwrite_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-return-values-of-finish_mkwrite_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-return-values-of-finish_mkwrite_fault.patch

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

