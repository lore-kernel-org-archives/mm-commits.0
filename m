Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1564B80BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104162; cv=none; b=mXk/oGupHKz6LnLwzqg3LM8RBu9Z9DJ6kTS7QM8OIgrgEwJujeQ/6DgyaIhqfXs6Cxs9FCMII8tFwPm0UOftDKdQf+EwIFdKi6w5hu3BQ529EwOCjqxzHMucVedJlrhbYpdMp0PhLS7i6ttL7NHbMYNknExoEqynww8MLqFhFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104162; c=relaxed/simple;
	bh=Y8QTCnm4sPN0LYEoYS6bU4lnssmw2iuYVCvC+X4ta4g=;
	h=Date:To:From:Subject:Message-Id; b=TE3UJi4behfLtl3DXQFSeopyDatEW/LJ9mD1ggXrb1+usKYSI+r5fMLgnfykoDN3WsOHrurtpb/zac2JR9YS+A1KNwj1f0LUksw5kaIyXrsJL0K1qmpRMVfh0AAXEYsoqF9lzeBFXic11Nhdrh8aiT7gEAeX8UwHv5xlBfEVdtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZ+Mz6pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZ+Mz6pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA40C113CD;
	Fri, 26 Apr 2024 04:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104162;
	bh=Y8QTCnm4sPN0LYEoYS6bU4lnssmw2iuYVCvC+X4ta4g=;
	h=Date:To:From:Subject:From;
	b=pZ+Mz6pqyBBhgNvEwdpAYaMgvy82aO+M7S1nkR19Zm+Fn2ZZw1dpQgMFm4CrYcbDa
	 g2wI/5im/eUKRZ0HikCeOO0sO9bA1hV4dYmxbMz3j2pPo8t158875ilAMTAbIK3wOi
	 pOfTTfF0HwOgoojrKomBaK8wLW7oNa7a1qlF5/hw=
Date: Thu, 25 Apr 2024 21:02:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch removed from -mm tree
Message-Id: <20240426040241.DCA40C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: convert hugetlb_fault() to use struct vm_fault
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   84 +++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 43 deletions(-)

--- a/mm/hugetlb.c~hugetlb-convert-hugetlb_fault-to-use-struct-vm_fault
+++ a/mm/hugetlb.c
@@ -6427,8 +6427,6 @@ u32 hugetlb_fault_mutex_hash(struct addr
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
-	pte_t *ptep, entry;
-	spinlock_t *ptl;
 	vm_fault_t ret;
 	u32 hash;
 	struct folio *folio = NULL;
@@ -6436,13 +6434,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6462,22 +6460,22 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
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
@@ -6492,20 +6490,20 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6514,9 +6512,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6530,13 +6528,13 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6544,17 +6542,17 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6564,18 +6562,18 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6585,24 +6583,24 @@ vm_fault_t hugetlb_fault(struct mm_struc
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


