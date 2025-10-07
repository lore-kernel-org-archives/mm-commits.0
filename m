Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0472C9D
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 23:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759878223; cv=none; b=m1uZlcvWgEb/UT1K33MLQ7WXGrlcBtvkNVpIcg880WhKq0c9MU3iK73mao6ZO9TuXLiSGw1M63trm3f73I3ZUP0Q3Nm/gRx/mHAy29lkMvQRZLqXdirAGD0eP+rRMQLr6QIb9VztUsdQWVjPney0GRj9uo4Cb/pHLmRn2Msk1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759878223; c=relaxed/simple;
	bh=1eF0Vqplr+kxVGssmXT9peWPqDkenFZ7AdlllJo0FWE=;
	h=Date:To:From:Subject:Message-Id; b=Qt/b4R9FLM0PA9Bf+qaHDCDE7A8LqOP84lmA35ExTnc64NH0yDm+Y8Ad3cDM4IqQPOXtm0hi2EK7/AbovvdJ4kvcgsN163hmRahX/tmYjk2zyYJpBpzo2icRJvpKwjLi4i/CEArdT08ZIqq46nIF0hhCRAIODSrxLGehp7GPpVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjrQxyrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjrQxyrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E9BC4CEF1;
	Tue,  7 Oct 2025 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759878222;
	bh=1eF0Vqplr+kxVGssmXT9peWPqDkenFZ7AdlllJo0FWE=;
	h=Date:To:From:Subject:From;
	b=hjrQxyrEhgZC7s1M076XXAQPDK0CEzfurhfCWLxRx2Q1CEG5ql2tzdvIdP6wrB0su
	 sR0ENiZXP/bnKlXvhjUWVjyf74D25RKSZGZbo4pWBE8Aspv+Wb8e2UwmayPUzxbhss
	 OyTtB9gBEfK3r+PYoqXPSZaSGawqtBGVnTBEpfZQ=
Date: Tue, 07 Oct 2025 16:03:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,mpenttil@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch removed from -mm tree
Message-Id: <20251007230342.59E9BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: abort collapse scan on non-swap entries
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: abort collapse scan on non-swap entries
Date: Wed, 1 Oct 2025 11:22:51 +0800

Currently, special non-swap entries (like migration, hwpoison, or PTE
markers) are not caught early in hpage_collapse_scan_pmd(), leading to
failures deep in the swap-in logic.

hpage_collapse_scan_pmd()
 `- collapse_huge_page()
     `- __collapse_huge_page_swapin() -> fails!

As David suggested[1], this patch skips any such non-swap entries early. 
If any one is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work.


Link: https://lkml.kernel.org/r/20251001032251.85888-1-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com [1]
Link: https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local [2]
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-abort-collapse-scan-on-non-swap-entries
+++ a/mm/khugepaged.c
@@ -1281,7 +1281,23 @@ static int hpage_collapse_scan_pmd(struc
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (is_swap_pte(pteval)) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++none_or_zero;
+			if (!userfaultfd_armed(vma) &&
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
+				continue;
+			} else {
+				result = SCAN_EXCEED_NONE_PTE;
+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				goto out_unmap;
+			}
+		} else if (!pte_present(pteval)) {
+			if (non_swap_entry(pte_to_swp_entry(pteval))) {
+				result = SCAN_PTE_NON_PRESENT;
+				goto out_unmap;
+			}
+
 			++unmapped;
 			if (!cc->is_khugepaged ||
 			    unmapped <= khugepaged_max_ptes_swap) {
@@ -1290,7 +1306,7 @@ static int hpage_collapse_scan_pmd(struc
 				 * enabled swap entries.  Please see
 				 * comment below for pte_uffd_wp().
 				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
+				if (pte_swp_uffd_wp(pteval)) {
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
@@ -1301,18 +1317,6 @@ static int hpage_collapse_scan_pmd(struc
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out_unmap;
-			}
-		}
 		if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch

