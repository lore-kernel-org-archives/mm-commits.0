Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AB42D3EF1
	for <mm-commits@vger.kernel.org>; Wed,  1 Oct 2025 21:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352760; cv=none; b=swGKIqhrfj8/BkX0sSCx2nfak3dWeFKFZj/8FliYe0JkoJ/1bozhIHnZIyJoyHwlL+iEwMEy7U95Pg7IXZw4ykk1PvP4WSuN3lP5TMmOLQ6uQHs4CO0RDOMs+IYRytP4aTt/RFAcDJ3y48GySLgzWVWnHp372NNS9OWSm5y7SWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352760; c=relaxed/simple;
	bh=6QIoJbNrFUE3j7dZvtF4doSUxvz5ycSo2YYfDBkPbno=;
	h=Date:To:From:Subject:Message-Id; b=tPso9jkGQvMKFyrEZHk4AgrjBhX0fOCH0uLunpmQx81UGeV90F3L+kqHJjyswUxIkxpCuQWUrLy2wenmxi7WPaAXqxykv4u/HrOiZVL1oNScpphJTENXGtpDMP4D0pwtaLFpmVeZVkgzEZFo1HWEe/9UPk4S9vqu2dJbGu1TPGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZHFi4G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZHFi4G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D8FC4CEF1;
	Wed,  1 Oct 2025 21:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759352759;
	bh=6QIoJbNrFUE3j7dZvtF4doSUxvz5ycSo2YYfDBkPbno=;
	h=Date:To:From:Subject:From;
	b=cZHFi4G7p5rAtXze6KTbuQB63/hFFWsUSgv70J3QbvWeoA6A6WdMboqMH5FOBsGat
	 BfjpvM27oq8dOLCEupnFUtMuTOPvP6aWd8PwkBEuhCqdBcmMh+SLOtiP0HpZVpU35s
	 DCq7aRq14Zyzp2qAfKau+tRqt6UCU8wHWRIME73k=
Date: Wed, 01 Oct 2025 14:05:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,mpenttil@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch added to mm-new branch
Message-Id: <20251001210559.47D8FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: abort collapse scan on non-swap entries
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

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
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch
mm-clean-up-is_guard_pte_marker.patch
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

