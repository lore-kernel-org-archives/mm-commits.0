From: akpm@linux-foundation.org
Subject: + mm-use-vmf-page-during-wp-faults.patch added to -mm tree
Date: Tue, 22 Nov 2016 16:15:26 -0800
Message-ID: <5834df9e.bRptDUr3FY5taX5q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755690AbcKWAP0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vmf->page during WP faults
has been added to the -mm tree.  Its filename is
     mm-use-vmf-page-during-wp-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-vmf-page-during-wp-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-vmf-page-during-wp-faults.patch

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
Subject: mm: use vmf->page during WP faults

So far we set vmf->page during WP faults only when we needed to pass it to
the ->page_mkwrite handler.  Set it in all the cases now and use that
instead of passing page pointer explicitly around.

Link: http://lkml.kernel.org/r/1479460644-25076-14-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   58 +++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN mm/memory.c~mm-use-vmf-page-during-wp-faults mm/memory.c
--- a/mm/memory.c~mm-use-vmf-page-during-wp-faults
+++ a/mm/memory.c
@@ -2102,11 +2102,12 @@ static void fault_dirty_shared_page(stru
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline int wp_page_reuse(struct vm_fault *vmf, struct page *page,
+static inline int wp_page_reuse(struct vm_fault *vmf,
 				int page_mkwrite, int dirty_shared)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct page *page = vmf->page;
 	pte_t entry;
 	/*
 	 * Clear the pages cpupid information as the existing
@@ -2150,10 +2151,11 @@ static inline int wp_page_reuse(struct v
  *   held to the old page, as well as updating the rmap.
  * - In any case, unlock the PTL and drop the reference we took to the old page.
  */
-static int wp_page_copy(struct vm_fault *vmf, struct page *old_page)
+static int wp_page_copy(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
+	struct page *old_page = vmf->page;
 	struct page *new_page = NULL;
 	pte_t entry;
 	int page_copied = 0;
@@ -2305,26 +2307,25 @@ static int wp_pfn_shared(struct vm_fault
 			return 0;
 		}
 	}
-	return wp_page_reuse(vmf, NULL, 0, 0);
+	return wp_page_reuse(vmf, 0, 0);
 }
 
-static int wp_page_shared(struct vm_fault *vmf, struct page *old_page)
+static int wp_page_shared(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	int page_mkwrite = 0;
 
-	get_page(old_page);
+	get_page(vmf->page);
 
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		int tmp;
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		vmf->page = old_page;
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(old_page);
+			put_page(vmf->page);
 			return tmp;
 		}
 		/*
@@ -2336,15 +2337,15 @@ static int wp_page_shared(struct vm_faul
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 						vmf->address, &vmf->ptl);
 		if (!pte_same(*vmf->pte, vmf->orig_pte)) {
-			unlock_page(old_page);
+			unlock_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			put_page(old_page);
+			put_page(vmf->page);
 			return 0;
 		}
 		page_mkwrite = 1;
 	}
 
-	return wp_page_reuse(vmf, old_page, page_mkwrite, 1);
+	return wp_page_reuse(vmf, page_mkwrite, 1);
 }
 
 /*
@@ -2369,10 +2370,9 @@ static int do_wp_page(struct vm_fault *v
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *old_page;
 
-	old_page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
-	if (!old_page) {
+	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
+	if (!vmf->page) {
 		/*
 		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
 		 * VM_PFNMAP VMA.
@@ -2385,30 +2385,30 @@ static int do_wp_page(struct vm_fault *v
 			return wp_pfn_shared(vmf);
 
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return wp_page_copy(vmf, old_page);
+		return wp_page_copy(vmf);
 	}
 
 	/*
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
 	 */
-	if (PageAnon(old_page) && !PageKsm(old_page)) {
+	if (PageAnon(vmf->page) && !PageKsm(vmf->page)) {
 		int total_mapcount;
-		if (!trylock_page(old_page)) {
-			get_page(old_page);
+		if (!trylock_page(vmf->page)) {
+			get_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			lock_page(old_page);
+			lock_page(vmf->page);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
 			if (!pte_same(*vmf->pte, vmf->orig_pte)) {
-				unlock_page(old_page);
+				unlock_page(vmf->page);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
-				put_page(old_page);
+				put_page(vmf->page);
 				return 0;
 			}
-			put_page(old_page);
+			put_page(vmf->page);
 		}
-		if (reuse_swap_page(old_page, &total_mapcount)) {
+		if (reuse_swap_page(vmf->page, &total_mapcount)) {
 			if (total_mapcount == 1) {
 				/*
 				 * The page is all ours. Move it to
@@ -2417,24 +2417,24 @@ static int do_wp_page(struct vm_fault *v
 				 * Protected against the rmap code by
 				 * the page lock.
 				 */
-				page_move_anon_rmap(old_page, vma);
+				page_move_anon_rmap(vmf->page, vma);
 			}
-			unlock_page(old_page);
-			return wp_page_reuse(vmf, old_page, 0, 0);
+			unlock_page(vmf->page);
+			return wp_page_reuse(vmf, 0, 0);
 		}
-		unlock_page(old_page);
+		unlock_page(vmf->page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
-		return wp_page_shared(vmf, old_page);
+		return wp_page_shared(vmf);
 	}
 
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-	get_page(old_page);
+	get_page(vmf->page);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	return wp_page_copy(vmf, old_page);
+	return wp_page_copy(vmf);
 }
 
 static void unmap_mapping_range_vma(struct vm_area_struct *vma,
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

