Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D50DF6C
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759970533; cv=none; b=BW8l7h/X9bhuJBGSAfEr6tIrtxLz3TD9vFk0Z6+R0OiZxfEXjQfyWwstG6bXYlgK2ixqVxsqoH9HyPTXf7vWmKujASZzJa5Yp/bTHTPyhsNEeyAf2KUwFh7JqUNac+74IjgOSXAPvOhWrtG8ztH1jCZkK0V7FuMNcu4SlmgkFFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759970533; c=relaxed/simple;
	bh=2Pv4FYVwpPojnFrK8M6dLx0iSqEHigIOFXTpup/Gx2A=;
	h=Date:To:From:Subject:Message-Id; b=eZv4efJ7evxrHp+IlrC0WllWR1aWlWG5Z2oBTm+8HBir+F9cx+H0/sYJR1FbSRoyRdRaNCt5un7GEICtWCGcXA9dkXJCkq8HdNQmL0kGfIJ6OYG8G93cuHlytC1XpF2iThTv5q0lXQhLzWyHOxygtLMxfJiaBVoO7d+B19vCht0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fEWNSMC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fEWNSMC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BAEC4CEE7;
	Thu,  9 Oct 2025 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759970532;
	bh=2Pv4FYVwpPojnFrK8M6dLx0iSqEHigIOFXTpup/Gx2A=;
	h=Date:To:From:Subject:From;
	b=fEWNSMC2U82HM7f3JG8j5iYnXKEnT0+XMBLbi1vmYKpM/8u1kqdBJBr4Oq3LYFtu8
	 exmppmkPoOFIUcS6jo5v2IViN0xgkPsNcERYXONXOA0v+Crt1BC8qqH2O0JSgBAPYH
	 xI/AZ1LLZXezHdZ1I1BGfai3sweOTg/LO9lGCIio=
Date: Wed, 08 Oct 2025 17:42:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,mpenttil@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch added to mm-new branch
Message-Id: <20251009004211.E4BAEC4CEE7@smtp.kernel.org>
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
Date: Wed, 8 Oct 2025 11:26:57 +0800

Currently, special non-swap entries (like PTE markers) are not caught
early in hpage_collapse_scan_pmd(), leading to failures deep in the
swap-in logic.

A function that is called __collapse_huge_page_swapin() and documented to
"Bring missing pages in from swap" will handle other types as well.

As analyzed by David[1], we could have ended up with the following entry
types right before do_swap_page():

  (1) Migration entries. We would have waited.
      -> Maybe worth it to wait, maybe not. We suspect we don't stumble
         into that frequently such that we don't care. We could always
         unlock this separately later.

  (2) Device-exclusive entries. We would have converted to non-exclusive.
      -> See make_device_exclusive(), we cannot tolerate PMD entries and
         have to split them through FOLL_SPLIT_PMD. As popped up during
         a recent discussion, collapsing here is actually
         counter-productive, because the next conversion will PTE-map
         it again.
      -> Ok to not collapse.

  (3) Device-private entries. We would have migrated to RAM.
      -> Device-private still does not support THPs, so collapsing right
         now just means that the next device access would split the
         folio again.
      -> Ok to not collapse.

  (4) HWPoison entries
      -> Cannot collapse

  (5) Markers
      -> Cannot collapse

First, this patch adds an early check for these non-swap entries.  If any
one is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work.  While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
since we are in the swap pte branch.

Second, as Wei pointed out[3], we may have a chance to get a non-swap
entry, since we will drop and re-acquire the mmap lock before
__collapse_huge_page_swapin().  To handle this, we also add a
non_swap_entry() check there.

Note that we can unlock later what we really need, and not account it
towards max_swap_ptes.

Link: https://lkml.kernel.org/r/20251008032657.72406-1-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com [1]
Link: https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local [2]
Link: https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master [3]
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-abort-collapse-scan-on-non-swap-entries
+++ a/mm/khugepaged.c
@@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(s
 		if (!is_swap_pte(vmf.orig_pte))
 			continue;
 
+		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struc
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
@@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struc
 				 * enabled swap entries.  Please see
 				 * comment below for pte_uffd_wp().
 				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
+				if (pte_swp_uffd_wp(pteval)) {
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
@@ -1301,18 +1322,6 @@ static int hpage_collapse_scan_pmd(struc
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
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

