Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA9370D5A
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622932; cv=none; b=j0UZMllZ1ZGNz4AXBiBRxz5CDDfKXTeXFTifNKL4dkPwgGMh/Z66GRdKkShEydhgdp1akClSsOKvnftk3OivWOd1LByNhae30+XY2C2axEjyijTaLfaMEGDQv0xcwNROlOZZ7AwdR22f+QFFEqVbe0glApHden1AOR0laetiDUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622932; c=relaxed/simple;
	bh=8QbFPprW/Dy7lhUknRYqRNcWnCbUO5mGUAgPBUGL21A=;
	h=Date:To:From:Subject:Message-Id; b=uaepLebPMQoAeGClCmRJ5/0sh54jIZ0G9146W8cFtE+7dluPYgaIkpJzyJ3vVFnUxw079k0ug9jbfom35kkaDhA31pM4/BM894iymhnWbEoAf/IULt7O8URdGCffXNjeBgSY5Ad1Y1gtIYfBQwP9T3mPoP5ryvoIm3ZTRv102bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X11wQAEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X11wQAEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE4B1F000E9;
	Tue, 25 Aug 2026 01:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622931;
	bh=OfdMman07O4ts2gNvUwam1f9r/hWUTwpfwt0+16eHKw=;
	h=Date:To:From:Subject;
	b=X11wQAEX5qtdqOOZtHozRGsJOCqP/hiEtvUTYoutC68iPA+htDPK9pX8aZdw9ndZo
	 MtO34qcFu6f3Xsu9RiLC5jxHh0/fv49fzSFnaj+te2R4CMnnfWKDoKU/n5KKZmZlie
	 kTv5q291nvrFOt7uwKRA47YlImzVnm4spG/s6r44=
Date: Mon, 24 Aug 2026 18:55:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-introduce-a-count_collapse_event-helper.patch removed from -mm tree
Message-Id: <20260825015531.2CE4B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: introduce a count_collapse_event() helper
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-introduce-a-count_collapse_event-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: introduce a count_collapse_event() helper
Date: Tue, 11 Aug 2026 06:48:35 -0600

Provide a simple helper function to help reduce a often used, and
duplicate pattern across the khugepaged code.

When collapsing to a PMD we need to record a vm_event and the mTHP_stat
event.  When doing mTHP collapse we only update the mTHP stat.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-3-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-introduce-a-count_collapse_event-helper
+++ a/mm/khugepaged.c
@@ -682,6 +682,14 @@ static bool folio_pte_referenced(struct
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
 }
 
+static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
+		enum mthp_stat_item mthp_event)
+{
+	if (is_pmd_order(order))
+		count_vm_event(vm_event);
+	count_mthp_stat(order, mthp_event);
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
@@ -702,9 +710,8 @@ static enum scan_result __collapse_huge_
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				if (is_pmd_order(order))
-					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 			continue;
@@ -746,9 +753,8 @@ static enum scan_result __collapse_huge_
 			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				if (is_pmd_order(order))
-					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1258,15 +1264,12 @@ static enum scan_result alloc_charge_fol
 	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
 	if (!folio) {
 		*foliop = NULL;
-		if (is_pmd_order(order))
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
+		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
+				     MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	if (is_pmd_order(order))
-		count_vm_event(THP_COLLAPSE_ALLOC);
-	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
 
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
@@ -1656,9 +1659,8 @@ static enum scan_result collapse_scan_pm
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1666,9 +1668,8 @@ static enum scan_result collapse_scan_pm
 		if (!pte_present(pteval)) {
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1725,9 +1726,8 @@ static enum scan_result collapse_scan_pm
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				count_mthp_stat(HPAGE_PMD_ORDER,
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
+						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}
_

Patches currently in -mm which might be from nico.pache@linux.dev are


