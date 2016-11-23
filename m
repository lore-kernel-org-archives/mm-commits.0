From: akpm@linux-foundation.org
Subject: + mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch
 added to -mm tree
Date: Tue, 22 Nov 2016 16:15:28 -0800
Message-ID: <5834dfa0.53Us7VWLRYHadkrC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755690AbcKWAP2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move part of wp_page_reuse() into the single call site
has been added to the -mm tree.  Its filename is
     mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-part-of-wp_page_reuse-into-the-single-call-site.patch

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
Subject: mm: move part of wp_page_reuse() into the single call site

wp_page_reuse() handles write shared faults which is needed only in
wp_page_shared().  Move the handling only into that location to make
wp_page_reuse() simpler and avoid a strange situation when we sometimes
pass in locked page, sometimes unlocked etc.

Link: http://lkml.kernel.org/r/1479460644-25076-15-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN mm/memory.c~mm-move-part-of-wp_page_reuse-into-the-single-call-site mm/memory.c
--- a/mm/memory.c~mm-move-part-of-wp_page_reuse-into-the-single-call-site
+++ a/mm/memory.c
@@ -2102,8 +2102,7 @@ static void fault_dirty_shared_page(stru
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct vm_fault *vmf,
-				int page_mkwrite, int dirty_shared)
+static inline void wp_page_reuse(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -2123,16 +2122,6 @@ static inline int wp_page_reuse(struct v
 	if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
 		update_mmu_cache(vma, vmf->address, vmf->pte);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-
-	if (dirty_shared) {
-		if (!page_mkwrite)
-			lock_page(page);
-
-		fault_dirty_shared_page(vma, page);
-		put_page(page);
-	}
-
-	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2307,7 +2296,8 @@ static int wp_pfn_shared(struct vm_fault
 			return 0;
 		}
 	}
-	return wp_page_reuse(vmf, 0, 0);
+	wp_page_reuse(vmf);
+	return VM_FAULT_WRITE;
 }
 
 static int wp_page_shared(struct vm_fault *vmf)
@@ -2345,7 +2335,13 @@ static int wp_page_shared(struct vm_faul
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(vmf, page_mkwrite, 1);
+	wp_page_reuse(vmf);
+	if (!page_mkwrite)
+		lock_page(vmf->page);
+	fault_dirty_shared_page(vma, vmf->page);
+	put_page(vmf->page);
+
+	return VM_FAULT_WRITE;
 }
 
 /*
@@ -2420,7 +2416,8 @@ static int do_wp_page(struct vm_fault *v
 				page_move_anon_rmap(vmf->page, vma);
 			}
 			unlock_page(vmf->page);
-			return wp_page_reuse(vmf, 0, 0);
+			wp_page_reuse(vmf);
+			return VM_FAULT_WRITE;
 		}
 		unlock_page(vmf->page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
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

