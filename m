Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8B1C696
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 02:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712196440; cv=none; b=uWlvereKbXKk3IdVAeCfEqtBUlWmalAW+TkLAhudpLRA2rhERZAcDPXcx7X1UIG98xjZcotWEXXkAolaem/gi7kSPLNIBiB4FmqM1+G/PcFH/9oznHRN2jGYTq5szdqgAtqSCZ7KPZDLRKEfaRYc6mcoo9Zhwj15kYuvI+RUGkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712196440; c=relaxed/simple;
	bh=fds0tZ5FBVBlNsl8KAloS7SFtfs9qDyPr/I2Ugbo2Yk=;
	h=Date:To:From:Subject:Message-Id; b=qbE9+ek6pvZJSo7to9znHtBkqTp18947lASl1C6ulcFlgJB3kuH1BJBifHMkQ1f6SQMy7ya2fy/2CuywLl5Fi4Tt/P4FcfG8EjcqdfQriwh6W9eJn0jKSq5t1FvLrfXSKknE+C+V7A7tfKs+117e9DxkCqmINh/nM5CsQvZelRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wi+/Pm/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wi+/Pm/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6321C433F1;
	Thu,  4 Apr 2024 02:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712196439;
	bh=fds0tZ5FBVBlNsl8KAloS7SFtfs9qDyPr/I2Ugbo2Yk=;
	h=Date:To:From:Subject:From;
	b=Wi+/Pm/eW6lZ/fWlQFkGZEMVN1ExeEhZaOr3D9Z1VK/KHelajEzwjb6ZFROG+QgWZ
	 9leHSy9fnif80eY1WMN4PIjftECUMdI7cNJdVBMayKlCXQahxP7bcflIrqUbZ4OX56
	 oWDTX4IQ+aBgmPeF/wiaNUkVAhgYbdDo2xcksKEU=
Date: Wed, 03 Apr 2024 19:07:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch added to mm-unstable branch
Message-Id: <20240404020719.B6321C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: convert hugetlb_fault() to use struct vm_fault
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: convert hugetlb_fault() to use struct vm_fault
Date: Mon, 1 Apr 2024 13:26:49 -0700

Patch series "Hugetlb fault path to use struct vm_fault", v2.

This patchset converts the hugetlb fault path to use struct vm_fault. 
This helps make the code more readable, and alleviates the stack by
allowing us to consolidate many fault-related variables into an individual
pointer.


This patch (of 3):

Now that hugetlb_fault() has a vm_fault available for fault tracking, use
it throughout.  This cleans up the code by removing 2 variables, and
prepares hugetlb_fault() to take in a struct vm_fault argument.

Link: https://lkml.kernel.org/r/20240401202651.31440-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20240401202651.31440-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   84 +++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 43 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault
+++ a/mm/hugetlb.c
@@ -6421,8 +6421,6 @@ u32 hugetlb_fault_mutex_hash(struct addr
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
-	pte_t *ptep, entry;
-	spinlock_t *ptl;
 	vm_fault_t ret;
 	u32 hash;
 	struct folio *folio = NULL;
@@ -6430,13 +6428,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
-	unsigned long haddr = address & huge_page_mask(h);
 	struct vm_fault vmf = {
 		.vma = vma,
-		.address = haddr,
+		.address = address & huge_page_mask(h),
 		.real_address = address,
 		.flags = flags,
-		.pgoff = vma_hugecache_offset(h, vma, haddr),
+		.pgoff = vma_hugecache_offset(h, vma,
+				address & huge_page_mask(h)),
 		/* TODO: Track hugetlb faults using vm_fault */
 
 		/*
@@ -6456,22 +6454,22 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	/*
 	 * Acquire vma lock before calling huge_pte_alloc and hold
-	 * until finished with ptep.  This prevents huge_pmd_unshare from
-	 * being called elsewhere and making the ptep no longer valid.
+	 * until finished with vmf.pte.  This prevents huge_pmd_unshare from
+	 * being called elsewhere and making the vmf.pte no longer valid.
 	 */
 	hugetlb_vma_lock_read(vma);
-	ptep = huge_pte_alloc(mm, vma, haddr, huge_page_size(h));
-	if (!ptep) {
+	vmf.pte = huge_pte_alloc(mm, vma, vmf.address, huge_page_size(h));
+	if (!vmf.pte) {
 		hugetlb_vma_unlock_read(vma);
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return VM_FAULT_OOM;
 	}
 
-	entry = huge_ptep_get(ptep);
-	if (huge_pte_none_mostly(entry)) {
-		if (is_pte_marker(entry)) {
+	vmf.orig_pte = huge_ptep_get(vmf.pte);
+	if (huge_pte_none_mostly(vmf.orig_pte)) {
+		if (is_pte_marker(vmf.orig_pte)) {
 			pte_marker marker =
-				pte_marker_get(pte_to_swp_entry(entry));
+				pte_marker_get(pte_to_swp_entry(vmf.orig_pte));
 
 			if (marker & PTE_MARKER_POISONED) {
 				ret = VM_FAULT_HWPOISON_LARGE;
@@ -6486,20 +6484,20 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * mutex internally, which make us return immediately.
 		 */
 		return hugetlb_no_page(mm, vma, mapping, vmf.pgoff, address,
-					ptep, entry, flags, &vmf);
+					vmf.pte, vmf.orig_pte, flags, &vmf);
 	}
 
 	ret = 0;
 
 	/*
-	 * entry could be a migration/hwpoison entry at this point, so this
-	 * check prevents the kernel from going below assuming that we have
-	 * an active hugepage in pagecache. This goto expects the 2nd page
-	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
-	 * properly handle it.
+	 * vmf.orig_pte could be a migration/hwpoison vmf.orig_pte at this
+	 * point, so this check prevents the kernel from going below assuming
+	 * that we have an active hugepage in pagecache. This goto expects
+	 * the 2nd page fault, and is_hugetlb_entry_(migration|hwpoisoned)
+	 * check will properly handle it.
 	 */
-	if (!pte_present(entry)) {
-		if (unlikely(is_hugetlb_entry_migration(entry))) {
+	if (!pte_present(vmf.orig_pte)) {
+		if (unlikely(is_hugetlb_entry_migration(vmf.orig_pte))) {
 			/*
 			 * Release the hugetlb fault lock now, but retain
 			 * the vma lock, because it is needed to guard the
@@ -6508,9 +6506,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 			 * be released there.
 			 */
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			migration_entry_wait_huge(vma, ptep);
+			migration_entry_wait_huge(vma, vmf.pte);
 			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
+		} else if (unlikely(is_hugetlb_entry_hwpoisoned(vmf.orig_pte)))
 			ret = VM_FAULT_HWPOISON_LARGE |
 			    VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
@@ -6524,13 +6522,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * determine if a reservation has been consumed.
 	 */
 	if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
-	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(entry)) {
-		if (vma_needs_reservation(h, vma, haddr) < 0) {
+	    !(vma->vm_flags & VM_MAYSHARE) && !huge_pte_write(vmf.orig_pte)) {
+		if (vma_needs_reservation(h, vma, vmf.address) < 0) {
 			ret = VM_FAULT_OOM;
 			goto out_mutex;
 		}
 		/* Just decrements count, does not deallocate */
-		vma_end_reservation(h, vma, haddr);
+		vma_end_reservation(h, vma, vmf.address);
 
 		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping,
 							     vmf.pgoff);
@@ -6538,17 +6536,17 @@ vm_fault_t hugetlb_fault(struct mm_struc
 			pagecache_folio = NULL;
 	}
 
-	ptl = huge_pte_lock(h, mm, ptep);
+	vmf.ptl = huge_pte_lock(h, mm, vmf.pte);
 
 	/* Check for a racing update before calling hugetlb_wp() */
-	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
+	if (unlikely(!pte_same(vmf.orig_pte, huge_ptep_get(vmf.pte))))
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
-	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
+	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(vmf.pte)) &&
+	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
 		if (!userfaultfd_wp_async(vma)) {
-			spin_unlock(ptl);
+			spin_unlock(vmf.ptl);
 			if (pagecache_folio) {
 				folio_unlock(pagecache_folio);
 				folio_put(pagecache_folio);
@@ -6558,18 +6556,18 @@ vm_fault_t hugetlb_fault(struct mm_struc
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
-		entry = huge_pte_clear_uffd_wp(entry);
-		set_huge_pte_at(mm, haddr, ptep, entry,
+		vmf.orig_pte = huge_pte_clear_uffd_wp(vmf.orig_pte);
+		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));
 		/* Fallthrough to CoW */
 	}
 
 	/*
-	 * hugetlb_wp() requires page locks of pte_page(entry) and
+	 * hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) and
 	 * pagecache_folio, so here we need take the former one
 	 * when folio != pagecache_folio or !pagecache_folio.
 	 */
-	folio = page_folio(pte_page(entry));
+	folio = page_folio(pte_page(vmf.orig_pte));
 	if (folio != pagecache_folio)
 		if (!folio_trylock(folio)) {
 			need_wait_lock = 1;
@@ -6579,24 +6577,24 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	folio_get(folio);
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
-		if (!huge_pte_write(entry)) {
-			ret = hugetlb_wp(mm, vma, address, ptep, flags,
-					 pagecache_folio, ptl, &vmf);
+		if (!huge_pte_write(vmf.orig_pte)) {
+			ret = hugetlb_wp(mm, vma, address, vmf.pte, flags,
+					 pagecache_folio, vmf.ptl, &vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
-			entry = huge_pte_mkdirty(entry);
+			vmf.orig_pte = huge_pte_mkdirty(vmf.orig_pte);
 		}
 	}
-	entry = pte_mkyoung(entry);
-	if (huge_ptep_set_access_flags(vma, haddr, ptep, entry,
+	vmf.orig_pte = pte_mkyoung(vmf.orig_pte);
+	if (huge_ptep_set_access_flags(vma, vmf.address, vmf.pte, vmf.orig_pte,
 						flags & FAULT_FLAG_WRITE))
-		update_mmu_cache(vma, haddr, ptep);
+		update_mmu_cache(vma, vmf.address, vmf.pte);
 out_put_page:
 	if (folio != pagecache_folio)
 		folio_unlock(folio);
 	folio_put(folio);
 out_ptl:
-	spin_unlock(ptl);
+	spin_unlock(vmf.ptl);
 
 	if (pagecache_folio) {
 		folio_unlock(pagecache_folio);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_no_page-to-use-struct-vm_fault.patch
hugetlb-convert-hugetlb_wp-to-use-struct-vm_fault.patch

