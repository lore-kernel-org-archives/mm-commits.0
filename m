Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B652C21D8
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490032; cv=none; b=JNCIPkyjOH608oSV/PVpmgqoQFPO/gwfZynTLNGjUSFfpG/B1IXkQ5F9a4u/o02Uxo9//qkoqJYgNatUssfcMd+ksllvxo6A9bLVo27dMM02o7il0+w2wZTuqwil1JZ39oUZ/rzi/mijHNfRCe3gEDZ2hgkp4R2Ai9KrrbDEHas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490032; c=relaxed/simple;
	bh=Yv+f7Te8RFDeadNaLcpbJyo1vmkrSRrjNQFqhy2ByRw=;
	h=Date:To:From:Subject:Message-Id; b=SeDkj9Z+5NuN5XR1q3ZPx0At3NOxWERWT1UIXtjrzAiFLrfsKu1eAVUOumnmBtWIOh4uB0XoFk/SJLJYn9oOEkX/imllJ+JC7X114mVKa1iM1cUQuy1b+nqSxof+7WNDsEjip5fnP95xBmI4IrS3XaFOOi1wDFrvK/p3gq5W/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hCFn4YS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCFn4YS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EEDC4CEE7;
	Sun, 21 Sep 2025 21:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490032;
	bh=Yv+f7Te8RFDeadNaLcpbJyo1vmkrSRrjNQFqhy2ByRw=;
	h=Date:To:From:Subject:From;
	b=hCFn4YS2Bf3/AX5WJ9bO7+fTQapTkZHai/ds1+iN7zxq5GcI8cAApiH5nunoyAssl
	 dQbIDqKz1feqvcBttRju/0T3IZlMR0qpnyw968BfBouBXse6xovkxjLCr9LMMFXJcz
	 KY+AzdZl8fBpcYUbpG5AyNn5TBHtIdDInOJOdW4w=
Date: Sun, 21 Sep 2025 14:27:12 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-all-references-of-writable-and-scan_page_ro.patch removed from -mm tree
Message-Id: <20250921212712.A8EEDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop all references of writable and SCAN_PAGE_RO
has been removed from the -mm tree.  Its filename was
     mm-drop-all-references-of-writable-and-scan_page_ro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: drop all references of writable and SCAN_PAGE_RO
Date: Mon, 8 Sep 2025 13:20:28 +0530

Now that all actionable outcomes from checking pte_write() are gone, drop
the related references.

Link: https://lkml.kernel.org/r/20250908075028.38431-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   19 ++++++-------------
 mm/khugepaged.c                    |   14 +++-----------
 2 files changed, 9 insertions(+), 24 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-drop-all-references-of-writable-and-scan_page_ro
+++ a/include/trace/events/huge_memory.h
@@ -19,7 +19,6 @@
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
 	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
-	EM( SCAN_PAGE_RO,		"no_writable_page")		\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
 	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
@@ -55,15 +54,14 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable,
+	TP_PROTO(struct mm_struct *mm, struct folio *folio,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, pfn)
-		__field(bool, writable)
 		__field(int, referenced)
 		__field(int, none_or_zero)
 		__field(int, status)
@@ -73,17 +71,15 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->pfn = folio ? folio_pfn(folio) : -1;
-		__entry->writable = writable;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
 		__entry->unmapped = unmapped;
 	),
 
-	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
+	TP_printk("mm=%p, scan_pfn=0x%lx, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
 		__entry->mm,
 		__entry->pfn,
-		__entry->writable,
 		__entry->referenced,
 		__entry->none_or_zero,
 		__print_symbolic(__entry->status, SCAN_STATUS),
@@ -117,15 +113,14 @@ TRACE_EVENT(mm_collapse_huge_page,
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct folio *folio, int none_or_zero,
-		 int referenced, bool  writable, int status),
+		 int referenced, int status),
 
-	TP_ARGS(folio, none_or_zero, referenced, writable, status),
+	TP_ARGS(folio, none_or_zero, referenced, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(int, none_or_zero)
 		__field(int, referenced)
-		__field(bool, writable)
 		__field(int, status)
 	),
 
@@ -133,15 +128,13 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
-		__entry->writable = writable;
 		__entry->status = status;
 	),
 
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
 		__entry->pfn,
 		__entry->none_or_zero,
 		__entry->referenced,
-		__entry->writable,
 		__print_symbolic(__entry->status, SCAN_STATUS))
 );
 
--- a/mm/khugepaged.c~mm-drop-all-references-of-writable-and-scan_page_ro
+++ a/mm/khugepaged.c
@@ -39,7 +39,6 @@ enum scan_result {
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PTE_UFFD_WP,
 	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_PAGE_RO,
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
 	SCAN_SCAN_ABORT,
@@ -557,7 +556,6 @@ static int __collapse_huge_page_isolate(
 	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
-	bool writable = false;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
@@ -671,9 +669,6 @@ next:
 		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
 								     address)))
 			referenced++;
-
-		if (pte_write(pteval))
-			writable = true;
 	}
 
 	if (unlikely(cc->is_khugepaged && !referenced)) {
@@ -681,13 +676,13 @@ next:
 	} else {
 		result = SCAN_SUCCEED;
 		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, writable, result);
+						    referenced, result);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, writable, result);
+					    referenced, result);
 	return result;
 }
 
@@ -1280,7 +1275,6 @@ static int hpage_collapse_scan_pmd(struc
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
-	bool writable = false;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1344,8 +1338,6 @@ static int hpage_collapse_scan_pmd(struc
 			result = SCAN_PTE_UFFD_WP;
 			goto out_unmap;
 		}
-		if (pte_write(pteval))
-			writable = true;
 
 		page = vm_normal_page(vma, _address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
@@ -1435,7 +1427,7 @@ out_unmap:
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-remove-pmd-alignment-constraint-in-execmem_vmalloc.patch

