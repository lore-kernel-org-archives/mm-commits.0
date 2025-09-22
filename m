Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB0C1D63F3
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758576590; cv=none; b=DGOdR5cim3CFjh/HHnRjy6dvxAR8MFQUY/HprtA7lUUg5F8G5ihLgyf1H4m+RXeRSR6PB4k1MKTj/MwdcnztC/93QQAMNHeRKg27iy0P1D8x5ZvbN1a3jNiUoVOuckZuU694bHWoMnP3woGRkabq5xl/CaI8TiYpnHoyFzcqZYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758576590; c=relaxed/simple;
	bh=x4Dchfow7sgoU+R+3sVL5Oktzm+7ATwtFXwIABTJJAw=;
	h=Date:To:From:Subject:Message-Id; b=uofmgJ1MnN/WOlX+0BPDBoIXFR1uFv30UhLTFeWUmhuMivFWv6iBfJ33KKimVUotMldrDpW4trd27fFJR++m+d/tJlXtTbFOUyCCLDUtiZscPi58Ef6+/yLq8C5X95+X0Pb4YkjiIiETMTxwLX7+KqzqPDlJiCrfauc8EkiHmb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPUnXHU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPUnXHU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C09C4CEF0;
	Mon, 22 Sep 2025 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758576589;
	bh=x4Dchfow7sgoU+R+3sVL5Oktzm+7ATwtFXwIABTJJAw=;
	h=Date:To:From:Subject:From;
	b=RPUnXHU/HOmUTh7Cw4CrGnTg1Uf7avhf6s/t0TXZ2ghjjZrkrXh0aLTFm9rL3DGqS
	 iZpqxZIww36ckm2wbWCZI3syJcPGuwtMIWYuqtmc3atobg9+/Np2FAMezLRDKKaA1T
	 qLoleGqTU68i9R7YJTOVGtkbPe+uL+b/Sm5rfctw=
Date: Mon, 22 Sep 2025 14:29:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-start_addr-addr-for-better-reading.patch added to mm-new branch
Message-Id: <20250922212949.C7C09C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use start_addr/addr for improved readability
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-use-start_addr-addr-for-better-reading.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-start_addr-addr-for-better-reading.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: use start_addr/addr for improved readability
Date: Mon, 22 Sep 2025 14:09:38 +0000

When collapsing a pmd, there are two address in use:

  * address points to the start of pmd
  * address points to each individual page

Current naming makes it difficult to distinguish these two and is hence
error prone.

Considering the plan to collapse mTHP, name the first one `start_addr' and
the second `addr' for better readability and consistency.

Link: https://lkml.kernel.org/r/20250922140938.27343-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-start_addr-addr-for-better-reading
+++ a/mm/khugepaged.c
@@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte
 }
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long address,
+					unsigned long start_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none(pteval) || (pte_present(pteval) &&
 				is_zero_pfn(pte_pfn(pteval)))) {
@@ -571,7 +572,7 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
-		page = vm_normal_page(vma, address, pteval);
+		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
@@ -656,8 +657,8 @@ next:
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     address)))
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
 
@@ -986,21 +987,21 @@ static int check_pmd_still_valid(struct
  */
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
 				       struct vm_area_struct *vma,
-				       unsigned long haddr, pmd_t *pmd,
+				       unsigned long start_addr, pmd_t *pmd,
 				       int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
-	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
 	int result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
-	for (address = haddr; address < end; address += PAGE_SIZE) {
+	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
 		struct vm_fault vmf = {
 			.vma = vma,
-			.address = address,
-			.pgoff = linear_page_index(vma, address),
+			.address = addr,
+			.pgoff = linear_page_index(vma, addr),
 			.flags = FAULT_FLAG_ALLOW_RETRY,
 			.pmd = pmd,
 		};
@@ -1010,7 +1011,7 @@ static int __collapse_huge_page_swapin(s
 			 * Here the ptl is only used to check pte_same() in
 			 * do_swap_page(), so readonly version is enough.
 			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, address, &ptl);
+			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
@@ -1253,7 +1254,7 @@ out_nolock:
 
 static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
-				   unsigned long address, bool *mmap_locked,
+				   unsigned long start_addr, bool *mmap_locked,
 				   struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1262,26 +1263,26 @@ static int hpage_collapse_scan_pmd(struc
 	int none_or_zero = 0, shared = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
-	unsigned long _address;
+	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, _address += PAGE_SIZE) {
+	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
 			++unmapped;
@@ -1329,7 +1330,7 @@ static int hpage_collapse_scan_pmd(struc
 			goto out_unmap;
 		}
 
-		page = vm_normal_page(vma, _address, pteval);
+		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
@@ -1398,7 +1399,7 @@ static int hpage_collapse_scan_pmd(struc
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
 		     folio_test_referenced(folio) ||
-		     mmu_notifier_test_young(vma->vm_mm, _address)))
+		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
 	if (cc->is_khugepaged &&
@@ -1411,7 +1412,7 @@ static int hpage_collapse_scan_pmd(struc
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		result = collapse_huge_page(mm, address, referenced,
+		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
 		*mmap_locked = false;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch

