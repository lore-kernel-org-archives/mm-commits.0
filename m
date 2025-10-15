Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34841917FB
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489869; cv=none; b=ZnjWdXDkjmZJKBfTpuH2t0OCt36Sn3fyIyogUNqQoft/1Zm7U9s4b15MeyRxT6NuAigLNpeCguNivJDV8+Gcuv6N1pDcoMV+fyKml3H/5EdftgkbiFRpjv1eSYBGLYQrqYyKzlFHX9ifWXh1Pd5lVGwagbzoEwhi6qglHchHoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489869; c=relaxed/simple;
	bh=hA3PlZCWcIUjGvoP2G5UdgzQ+TPWRzxAo2rurGSBYsI=;
	h=Date:To:From:Subject:Message-Id; b=HCl+jyYihrxUuDaXE/yG9SdqWDBwKa/UmFG8Ff7eIvXmyQqVheNKnoz7FkQm9GUMISj1eNTF2NTwfLSffljNWGMVlvBpiG3ch25epO2+jU2LWRbYCcNo27BCC8Op+1W1lumsIjaQLInkhhvDAPcdzfSgEZJuYT1i0BGH0vaND9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZZ9Ek6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZZ9Ek6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD38FC4CEE7;
	Wed, 15 Oct 2025 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489867;
	bh=hA3PlZCWcIUjGvoP2G5UdgzQ+TPWRzxAo2rurGSBYsI=;
	h=Date:To:From:Subject:From;
	b=TZZ9Ek6hXGA8D0/Hk5BX4ZFHF65RVcK56Z/JjoFwhilRP3H7KXwpSCy783C9EDSta
	 5UQD9xyVSMq2xRD2cJaDF/Qx2ZqNPB2y4f4Ej1y04nIxBf6J4NUntAXI0+gjl0H7MM
	 WM1+b3G1PuKB1Qpfmqo6niH2sr3UUO59XWP0ykB4=
Date: Tue, 14 Oct 2025 17:57:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch removed from -mm tree
Message-Id: <20251015005747.CD38FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: merge PTE scanning logic into a new helper
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: merge PTE scanning logic into a new helper
Date: Wed, 8 Oct 2025 12:37:48 +0800

As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate() was almost duplicated.

This patch cleans things up by moving all the common PTE checking logic
into a new shared helper, thp_collapse_check_pte().  While at it, we use
vm_normal_folio() instead of vm_normal_page().

Link: https://lkml.kernel.org/r/20251008043748.45554-4-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  243 ++++++++++++++++++++++++----------------------
 1 file changed, 130 insertions(+), 113 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper
+++ a/mm/khugepaged.c
@@ -61,6 +61,12 @@ enum scan_result {
 	SCAN_PAGE_FILLED,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_CONTINUE,
+	PTE_CHECK_FAIL,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+/*
+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
+ * @pte:           The PTE to check
+ * @vma:           The VMA the PTE belongs to
+ * @addr:          The virtual address corresponding to this PTE
+ * @foliop:        On success, used to return a pointer to the folio
+ *                 Must be non-NULL
+ * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
+ * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
+ * @shared:        Counter for shared pages. Must be non-NULL
+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
+ *                 PTE_CHECK_FAIL return. Must be non-NULL
+ * @cc:            Collapse control settings
+ *
+ * Returns:
+ *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
+ *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
+ *   PTE_CHECK_FAIL     - Abort collapse scan
+ */
+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio **foliop, int *none_or_zero,
+		int *unmapped, int *shared, int *scan_result,
+		struct collapse_control *cc)
+{
+	struct folio *folio = NULL;
+
+	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
+		(*none_or_zero)++;
+		if (!userfaultfd_armed(vma) &&
+		    (!cc->is_khugepaged ||
+		     *none_or_zero <= khugepaged_max_ptes_none)) {
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_NONE_PTE;
+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (!pte_present(pte)) {
+		if (!unmapped) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		if (non_swap_entry(pte_to_swp_entry(pte))) {
+			*scan_result = SCAN_PTE_NON_PRESENT;
+			return PTE_CHECK_FAIL;
+		}
+
+		(*unmapped)++;
+		if (!cc->is_khugepaged ||
+		    *unmapped <= khugepaged_max_ptes_swap) {
+			/*
+			 * Always be strict with uffd-wp enabled swap
+			 * entries. Please see comment below for
+			 * pte_uffd_wp().
+			 */
+			if (pte_swp_uffd_wp(pte)) {
+				*scan_result = SCAN_PTE_UFFD_WP;
+				return PTE_CHECK_FAIL;
+			}
+			return PTE_CHECK_CONTINUE;
+		} else {
+			*scan_result = SCAN_EXCEED_SWAP_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	} else if (pte_uffd_wp(pte)) {
+		/*
+		 * Don't collapse the page if any of the small PTEs are
+		 * armed with uffd write protection. Here we can also mark
+		 * the new huge pmd as write protected if any of the small
+		 * ones is marked but that could bring unknown userfault
+		 * messages that falls outside of the registered range.
+		 * So, just be simple.
+		 */
+		*scan_result = SCAN_PTE_UFFD_WP;
+		return PTE_CHECK_FAIL;
+	}
+
+	folio = vm_normal_folio(vma, addr, pte);
+	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
+		*scan_result = SCAN_PAGE_NULL;
+		return PTE_CHECK_FAIL;
+	}
+
+	if (!folio_test_anon(folio)) {
+		VM_WARN_ON_FOLIO(true, folio);
+		*scan_result = SCAN_PAGE_ANON;
+		return PTE_CHECK_FAIL;
+	}
+
+	/*
+	 * We treat a single page as shared if any part of the THP
+	 * is shared.
+	 */
+	if (folio_maybe_mapped_shared(folio)) {
+		(*shared)++;
+		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
+			*scan_result = SCAN_EXCEED_SHARED_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+			return PTE_CHECK_FAIL;
+		}
+	}
+
+	*foliop = folio;
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long start_addr,
 					pte_t *pte,
 					struct collapse_control *cc,
 					struct list_head *compound_pagelist)
 {
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int pte_check_res;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out;
-			}
-		} else if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		} else if (pte_uffd_wp(pteval)) {
-			result = SCAN_PTE_UFFD_WP;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
 
-		folio = page_folio(page);
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
-			goto out;
-		}
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
+					&folio, &none_or_zero, NULL, &shared,
+					&result, cc);
 
-		/* See hpage_collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out;
-			}
-		}
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
+			goto out;
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
@@ -1264,11 +1347,11 @@ static int hpage_collapse_scan_pmd(struc
 	pte_t *pte, *_pte;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
+	int pte_check_res;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1287,81 +1370,15 @@ static int hpage_collapse_scan_pmd(struc
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
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
-		} else if (!pte_present(pteval)) {
-			if (non_swap_entry(pte_to_swp_entry(pteval))) {
-				result = SCAN_PTE_NON_PRESENT;
-				goto out_unmap;
-			}
 
-			++unmapped;
-			if (!cc->is_khugepaged ||
-			    unmapped <= khugepaged_max_ptes_swap) {
-				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
-				 */
-				if (pte_swp_uffd_wp(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
-					goto out_unmap;
-				}
-				continue;
-			} else {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				goto out_unmap;
-			}
-		} else if (pte_uffd_wp(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD_WP;
-			goto out_unmap;
-		}
-
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
+		pte_check_res = thp_collapse_check_pte(pteval, vma, addr,
+					&folio, &none_or_zero, &unmapped,
+					&shared, &result, cc);
 
-		if (!folio_test_anon(folio)) {
-			VM_WARN_ON_FOLIO(true, folio);
-			result = SCAN_PAGE_ANON;
+		if (pte_check_res == PTE_CHECK_CONTINUE)
+			continue;
+		else if (pte_check_res == PTE_CHECK_FAIL)
 			goto out_unmap;
-		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
-				goto out_unmap;
-			}
-		}
 
 		/*
 		 * Record which node the original page is from and save this
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-khugepaged-abort-collapse-scan-on-non-swap-entries.patch

