Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C8C3A1CD
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962260; cv=none; b=r/OdP5h6dvB3kSDhwlveMQrxgZnTpfdnTWZd+9Q3TJ3CdpKMo/SfcpcFaD7O0WMMiPSmHDMfkPg+HR5ZEbUVsVD4Z/Cu7jXINUu+BQi/n0b6FDTT5/HXgLM7zCiukFq9iboiztHU9zz+MzlaryitH1GRfFcj4/A/4b32xS10qXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962260; c=relaxed/simple;
	bh=aSna70iAud1AHyObZbJ7AtD95kkfhjfxGf+SW1+1dUI=;
	h=Date:To:From:Subject:Message-Id; b=RMFMmZ9vT/dxzWxTm2EHJ/aqJWgfptFehWgWzqFKARZGxgHuPtxpIPuwDInL4Fa2hN7fkGMDogP0mbt+nhebZIfr8n4SPlVYy2Kkjfc1K/1Kd+Yv/lqz7cxZzyYnr2IDIDmf3WSdijrAeuVZYDE5dyFoge8r/0LYefLKfHVVdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hU53Ohih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hU53Ohih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4AEC4CEFB;
	Sun, 28 Dec 2025 22:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962258;
	bh=aSna70iAud1AHyObZbJ7AtD95kkfhjfxGf+SW1+1dUI=;
	h=Date:To:From:Subject:From;
	b=hU53Ohihv3/jVD75JMBFSgYz5+GyMcMX80mraG3BZhM+BPjRQWo7c1Oym0y5wyy+I
	 6cFybtfoagF7eLEmmUxcMHo/BHGjgLp8u/jShEmAD/aQb6Ghd2wqwhVA3dH4/zlqjL
	 9/Hg+kIW3kQLrihCyFPadAfZjt2XcDRcuAqvVkNk=
Date: Sun, 28 Dec 2025 14:50:58 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch added to mm-new branch
Message-Id: <20251228225058.AE4AEC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: change collapse_pte_mapped_thp() to return void
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: change collapse_pte_mapped_thp() to return void
Date: Wed, 24 Dec 2025 11:13:55 +0000

The only external caller of collapse_pte_mapped_thp() is uprobe, which
ignores the return value.  Change the external API to return void to
simplify the interface.

Introduce try_collapse_pte_mapped_thp() for internal use that preserves
the return value.  This prepares for future patch that will convert the
return type to use enum scan_result.

Link: https://lkml.kernel.org/r/20251224111351.41042-10-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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
+extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+				    bool install_pmd);
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -42,10 +42,9 @@ static inline void khugepaged_enter_vma(
 					vm_flags_t vm_flags)
 {
 }
-static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
-					  unsigned long addr, bool install_pmd)
+static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
+					   unsigned long addr, bool install_pmd)
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
+				       bool install_pmd)
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
+			     bool install_pmd)
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
@@ -2480,7 +2486,7 @@ static unsigned int khugepaged_scan_mm_s
 					mmap_read_lock(mm);
 					if (hpage_collapse_test_exit_or_disable(mm))
 						goto breakouterloop;
-					*result = collapse_pte_mapped_thp(mm,
+					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
 						*result = SCAN_SUCCEED;
@@ -2870,7 +2876,7 @@ handle_result:
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

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-count-small-vmas-towards-scan-limit.patch
mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

