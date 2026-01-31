Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3203720CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898235; cv=none; b=uoreOvqp5zPys8UigJ5RhvGHYiiQv/xL8SytUEdqs96Pi5yyAw2bIG1IuwEl1tNDM2a5lUDMo5gUbLr+jJvagU/8loV1UH9YGe+PJ+lWqZiclW3Z0GnuSNiLeNaPJvCKxUNKkprWiGPFfCSDnii/D4Bfs7tOGZ+bZIbNrCFMVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898235; c=relaxed/simple;
	bh=oBUVM6UVUK6eepBiPRPEYWrFq+ElS54T9Ox+25Gf2zU=;
	h=Date:To:From:Subject:Message-Id; b=ILLgTYZDwTt2Tqops6nwLIGSPDhNpvfFImvHDu1o7v2a/52l/isXjPmpISCMwpY2MgWIH5YtFSiyDUtCyx2gvX4F12I+Vrj/JP3UG+ij2VbMkpE5ClpNQCbg8jJBwrdgkGsxOYcr5TW6FFh8Gh2pPIY59vHQrGNfHujJseMM+74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+Ba8pCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+Ba8pCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB499C4CEF1;
	Sat, 31 Jan 2026 22:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898235;
	bh=oBUVM6UVUK6eepBiPRPEYWrFq+ElS54T9Ox+25Gf2zU=;
	h=Date:To:From:Subject:From;
	b=M+Ba8pCgPI4E/A6MAf5ihKdz/x9WaThreqZxoI0tqgsSZultSVdjGceJXcUops7sY
	 ljZ5DzRXssyMZoxyAXibBUlMyzJT2haRQ0LplytX+tk4EyhwgTvFADuwXWMP3FOc1T
	 TI+r6abbPgShDm10S1sWHBq6IB7aoYgO7fL9QZ+4=
Date: Sat, 31 Jan 2026 14:23:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch removed from -mm tree
Message-Id: <20260131222354.EB499C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: change collapse_pte_mapped_thp() to return void
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: change collapse_pte_mapped_thp() to return void
Date: Sun, 18 Jan 2026 19:22:57 +0000

The only external caller of collapse_pte_mapped_thp() is uprobe, which
ignores the return value.  Change the external API to return void to
simplify the interface.

Introduce try_collapse_pte_mapped_thp() for internal use that preserves
the return value.  This prepares for future patch that will convert the
return type to use enum scan_result.

Link: https://lkml.kernel.org/r/20260118192253.9263-10-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    9 +++----
 mm/khugepaged.c            |   40 ++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 22 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void
+++ a/include/linux/khugepaged.h
@@ -17,8 +17,8 @@ extern void khugepaged_enter_vma(struct
 				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-				   bool install_pmd);
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -42,10 +42,9 @@ static inline void khugepaged_enter_vma(
 					vm_flags_t vm_flags)
 {
 }
-static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
-					  unsigned long addr, bool install_pmd)
+static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
+		unsigned long addr, bool install_pmd)
 {
-	return 0;
 }
 
 static inline void khugepaged_min_free_kbytes_update(void)
--- a/mm/khugepaged.c~mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void
+++ a/mm/khugepaged.c
@@ -1477,20 +1477,8 @@ static int set_huge_pmd(struct vm_area_s
 	return SCAN_SUCCEED;
 }
 
-/**
- * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
- * address haddr.
- *
- * @mm: process address space where collapse happens
- * @addr: THP collapse address
- * @install_pmd: If a huge PMD should be installed
- *
- * This function checks whether all the PTEs in the PMD are pointing to the
- * right THP. If so, retract the page table so the THP can refault in with
- * as pmd-mapped. Possibly install a huge PMD mapping the THP.
- */
-int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-			    bool install_pmd)
+static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
 {
 	int nr_mapped_ptes = 0, result = SCAN_FAIL;
 	unsigned int nr_batch_ptes;
@@ -1711,6 +1699,24 @@ drop_folio:
 	return result;
 }
 
+/**
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
+ * @install_pmd: If a huge PMD should be installed
+ *
+ * This function checks whether all the PTEs in the PMD are pointing to the
+ * right THP. If so, retract the page table so the THP can refault in with
+ * as pmd-mapped. Possibly install a huge PMD mapping the THP.
+ */
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
+{
+	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
+}
+
 /* Can we retract page tables for this file-backed VMA? */
 static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 {
@@ -2227,7 +2233,7 @@ immap_locked:
 
 	/*
 	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp().
+	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
 	 */
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
@@ -2479,7 +2485,7 @@ static unsigned int khugepaged_scan_mm_s
 					mmap_read_lock(mm);
 					if (hpage_collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
-					*result = collapse_pte_mapped_thp(mm,
+					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
 						*result = SCAN_SUCCEED;
@@ -2844,7 +2850,7 @@ handle_result:
 		case SCAN_PTE_MAPPED_HUGEPAGE:
 			BUG_ON(mmap_locked);
 			mmap_read_lock(mm);
-			result = collapse_pte_mapped_thp(mm, addr, true);
+			result = try_collapse_pte_mapped_thp(mm, addr, true);
 			mmap_read_unlock(mm);
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
_

Patches currently in -mm which might be from shivankg@amd.com are


