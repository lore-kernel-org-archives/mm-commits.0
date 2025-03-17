Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C31217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188484; cv=none; b=CRpxWTfVGI4i3Sv5JVozoj2+QMNMP91UWQXsIG+wzSBpbf4LBeGa5t1txpPyUSuNWsbcBC5Cfv6uaHBmYgVAnQM0ZFgI4uggRtp9B1BjSbjhdtcyunGIStsbu2hCqpqq/cvr2VPXUPPRF3OATfReCAgaKcLaAny1eak2tOq8lsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188484; c=relaxed/simple;
	bh=NAWPdS5FEJ65538SeGVJQjWp6lAhZQzySKpyZpEMwoY=;
	h=Date:To:From:Subject:Message-Id; b=IPeKVwNrgeQCzZM6GhDoQmasMtQP5nNV90uVWF5seOmb8xwizRBpVquJvDS8aE9rVm8TW9PRKC9b0XKS0BI4SBEYw02AHOrrMaxkK3hiwfOwBXYpJf3A+QMwk//wUpbKVoU2xnsOpz9s9bBl5xsmROZ8fFBZT1OSIVowWgbEEsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+V/Xia7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+V/Xia7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2B5C4CEEC;
	Mon, 17 Mar 2025 05:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188484;
	bh=NAWPdS5FEJ65538SeGVJQjWp6lAhZQzySKpyZpEMwoY=;
	h=Date:To:From:Subject:From;
	b=t+V/Xia7VeN+cO8bY/S0IecqYNHqWP9B+NVjNnJqOYISf0fDF2MyE+ByHGpzSEkPN
	 10/fqE7ySy8GAgq3SsGPb6/uTbCrzQ8xgwvWXj71d9yajdyR/G/mi9+7oKipYSLekb
	 rtdKwnKTnq3rlrQ7vMkZHk2uidH7H39zsANS81zo=
Date: Sun, 16 Mar 2025 22:14:43 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch removed from -mm tree
Message-Id: <20250317051444.4E2B5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: pass folio and pte to restore_exclusive_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-pass-folio-and-pte-to-restore_exclusive_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -717,14 +717,13 @@ struct folio *vm_normal_folio_pmd(struct
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
@@ -751,16 +750,15 @@ static void restore_exclusive_pte(struct
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
 
@@ -866,7 +864,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * (ie. COW) mappings.
 		 */
 		VM_BUG_ON(!is_cow_mapping(src_vma->vm_flags));
-		if (try_restore_exclusive_pte(src_pte, src_vma, addr))
+		if (try_restore_exclusive_pte(src_vma, addr, src_pte, orig_pte))
 			return -EBUSY;
 		return -ENOENT;
 	} else if (is_pte_marker_entry(entry)) {
@@ -3987,7 +3985,8 @@ static vm_fault_t remove_device_exclusiv
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

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

