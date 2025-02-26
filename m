Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448DC26BD86
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740607631; cv=none; b=mN8pAH/n3mraWLNBbmoOD4cGTSUCZ7qkZk5lQvUNla5a747hIauy0Xfi8c3xt0u7tIzPSYFhJgaSQkxcRRzhOTxbZD+DzwfLqWdiCVbMh4A/fya+TExyiWlMvULVhls0U6XVmo+OPRxnDZc2ZWC5niIyRhS59H/c+IIjjkuHkV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740607631; c=relaxed/simple;
	bh=Jkfi6rKgWYKsK4COhXAdeWtZxTGOU9gbMH3UD1QWnQY=;
	h=Date:To:From:Subject:Message-Id; b=mBV0Q2/PrT9iukQ8jNdClNoyABArxWlplPlUvqCOZBk6+WBDmcmSe0aRQYbfVMCHspozNuJRJw1Xe15+bfz+pXGyT+qsBFEARHSNvI7ZPS4ar4atZ7i4VWCVxVnnyX2iiIPwace+jrV+yA6tDcBXKQFEB4BUveaFsuqdnEigDcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0flyUMqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0flyUMqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A315FC4CED6;
	Wed, 26 Feb 2025 22:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740607629;
	bh=Jkfi6rKgWYKsK4COhXAdeWtZxTGOU9gbMH3UD1QWnQY=;
	h=Date:To:From:Subject:From;
	b=0flyUMqZe15/UbDnqNsuKs3ShYNF4O2w51Wnh8rjwUUVU79zcWih/raNeX7hK9F/3
	 dyoQKnbvq2hxCNN6q4eYvIasTbO51t0ihzvEPAwhp2UZoAfMNYF/NIxqT1A2jzwXdr
	 TT7HaDmcybYLnMkH/t8G3yp3I8NFNRIVq1kvoOXw=
Date: Wed, 26 Feb 2025 14:07:09 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch added to mm-unstable branch
Message-Id: <20250226220709.A315FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: pass folio and pte to restore_exclusive_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: pass folio and pte to restore_exclusive_pte()
Date: Wed, 26 Feb 2025 14:22:55 +0100

Let's pass the folio and the pte to restore_exclusive_pte(), so we can
avoid repeated page_folio() and ptep_get().  To do that, pass the pte to
try_restore_exclusive_pte() and use a folio in there already.

While at it, just avoid the "swp_entry_t entry" variable in
try_restore_exclusive_pte() and add a folio-locked check to
restore_exclusive_pte().

Link: https://lkml.kernel.org/r/20250226132257.2826043-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-memory-pass-folio-and-pte-to-restore_exclusive_pte
+++ a/mm/memory.c
@@ -719,14 +719,13 @@ struct folio *vm_normal_folio_pmd(struct
 #endif
 
 static void restore_exclusive_pte(struct vm_area_struct *vma,
-				  struct page *page, unsigned long address,
-				  pte_t *ptep)
+		struct folio *folio, struct page *page, unsigned long address,
+		pte_t *ptep, pte_t orig_pte)
 {
-	struct folio *folio = page_folio(page);
-	pte_t orig_pte;
 	pte_t pte;
 
-	orig_pte = ptep_get(ptep);
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
@@ -753,16 +752,15 @@ static void restore_exclusive_pte(struct
  * Tries to restore an exclusive pte if the page lock can be acquired without
  * sleeping.
  */
-static int
-try_restore_exclusive_pte(pte_t *src_pte, struct vm_area_struct *vma,
-			unsigned long addr)
+static int try_restore_exclusive_pte(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t orig_pte)
 {
-	swp_entry_t entry = pte_to_swp_entry(ptep_get(src_pte));
-	struct page *page = pfn_swap_entry_to_page(entry);
+	struct page *page = pfn_swap_entry_to_page(pte_to_swp_entry(orig_pte));
+	struct folio *folio = page_folio(page);
 
-	if (trylock_page(page)) {
-		restore_exclusive_pte(vma, page, addr, src_pte);
-		unlock_page(page);
+	if (folio_trylock(folio)) {
+		restore_exclusive_pte(vma, folio, page, addr, ptep, orig_pte);
+		folio_unlock(folio);
 		return 0;
 	}
 
@@ -868,7 +866,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * (ie. COW) mappings.
 		 */
 		VM_BUG_ON(!is_cow_mapping(src_vma->vm_flags));
-		if (try_restore_exclusive_pte(src_pte, src_vma, addr))
+		if (try_restore_exclusive_pte(src_vma, addr, src_pte, orig_pte))
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
@@ -4030,7 +4028,8 @@ static vm_fault_t remove_device_exclusiv
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 				&vmf->ptl);
 	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte)))
-		restore_exclusive_pte(vma, vmf->page, vmf->address, vmf->pte);
+		restore_exclusive_pte(vma, folio, vmf->page, vmf->address,
+				      vmf->pte, vmf->orig_pte);
 
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch
lib-test_hmm-make-dmirror_atomic_map-consume-a-single-page.patch
mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch
mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch
mm-memory-document-restore_exclusive_pte.patch
mm-mmu_notifier-use-mmu_notify_clear-in-remove_device_exclusive_entry.patch

