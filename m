From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/7] mm: avoid data corruption on CoW fault into
 PFN-mapped VMA
Date: Thu, 05 Mar 2020 22:28:32 -0800
Message-ID: <20200306062832.Eauf-skRC%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCFG2e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:34 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, jmoyer@redhat.com, Justin.He@arm.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, linux-mm@kvack.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm: avoid data corruption on CoW fault into PFN-mapped VMA

Jeff Moyer has reported that one of xfstests triggers a warning when run
on DAX-enabled filesystem:

	WARNING: CPU: 76 PID: 51024 at mm/memory.c:2317 wp_page_copy+0xc40/0xd50
	...
	wp_page_copy+0x98c/0xd50 (unreliable)
	do_wp_page+0xd8/0xad0
	__handle_mm_fault+0x748/0x1b90
	handle_mm_fault+0x120/0x1f0
	__do_page_fault+0x240/0xd70
	do_page_fault+0x38/0xd0
	handle_page_fault+0x10/0x30

The warning happens on failed __copy_from_user_inatomic() which tries to
copy data into a CoW page.

This happens because of race between MADV_DONTNEED and CoW page fault:

	CPU0					CPU1
 handle_mm_fault()
   do_wp_page()
     wp_page_copy()
       do_wp_page()
					madvise(MADV_DONTNEED)
					  zap_page_range()
					    zap_pte_range()
					      ptep_get_and_clear_full()
					      <TLB flush>
	 __copy_from_user_inatomic()
	 sees empty PTE and fails
	 WARN_ON_ONCE(1)
	 clear_page()

The solution is to re-try __copy_from_user_inatomic() under PTL after
checking that PTE is matches the orig_pte.

The second copy attempt can still fail, like due to non-readable PTE, but
there's nothing reasonable we can do about, except clearing the CoW page.

Link: http://lkml.kernel.org/r/20200218154151.13349-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Justin He <Justin.He@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-avoid-data-corruption-on-cow-fault-into-pfn-mapped-vma
+++ a/mm/memory.c
@@ -2257,7 +2257,7 @@ static inline bool cow_user_page(struct
 	bool ret;
 	void *kaddr;
 	void __user *uaddr;
-	bool force_mkyoung;
+	bool locked = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = vmf->address;
@@ -2282,11 +2282,11 @@ static inline bool cow_user_page(struct
 	 * On architectures with software "accessed" bits, we would
 	 * take a double page fault, so mark it accessed here.
 	 */
-	force_mkyoung = arch_faults_on_old_pte() && !pte_young(vmf->orig_pte);
-	if (force_mkyoung) {
+	if (arch_faults_on_old_pte() && !pte_young(vmf->orig_pte)) {
 		pte_t entry;
 
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+		locked = true;
 		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 			/*
 			 * Other thread has already handled the fault
@@ -2310,18 +2310,37 @@ static inline bool cow_user_page(struct
 	 * zeroes.
 	 */
 	if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+		if (locked)
+			goto warn;
+
+		/* Re-validate under PTL if the page is still mapped */
+		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+		locked = true;
+		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+			/* The PTE changed under us. Retry page fault. */
+			ret = false;
+			goto pte_unlock;
+		}
+
 		/*
-		 * Give a warn in case there can be some obscure
-		 * use-case
+		 * The same page can be mapped back since last copy attampt.
+		 * Try to copy again under PTL.
 		 */
-		WARN_ON_ONCE(1);
-		clear_page(kaddr);
+		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+			/*
+			 * Give a warn in case there can be some obscure
+			 * use-case
+			 */
+warn:
+			WARN_ON_ONCE(1);
+			clear_page(kaddr);
+		}
 	}
 
 	ret = true;
 
 pte_unlock:
-	if (force_mkyoung)
+	if (locked)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	kunmap_atomic(kaddr);
 	flush_dcache_page(dst);
_
