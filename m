Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9235027F75C
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 20:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766952186; cv=none; b=HKpJFlVfWEwBkbGteeWWiW7vrehFJmR/6fiZbhvuFSExfhd0383lfzanhgwRrYJdIg/9wCkFnC6Xf4QCkCUevsfQb0lc3VsxG9zVlf97IUg8TlZDXRa6loFBpx9MrNlGVWGTND1DjX5yqoMUnHyK4hZCJG9D3xlKxwbLO1NBdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766952186; c=relaxed/simple;
	bh=oDWySWfWGqALcmaiOqpK4+TFlmgZSd2/ZI5eGuQ/u38=;
	h=Date:To:From:Subject:Message-Id; b=CCEIB/0XqYGUQ+6KtNjKlJoRSXzK7fYk1r/A9mEiO58JIYO8q1LUNzU5efVmnHcWbBu0KBP+u6VY6GrcpHfUEljT+1mjUN5HQL3R/W8McnbZpVbS7xNkhKGZVMJaQCwMnBayQjb2+OTSsv3nx9MDp90KWDDWliEmq1vfaTqMXeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzqjSpy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzqjSpy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB194C4CEFB;
	Sun, 28 Dec 2025 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766952183;
	bh=oDWySWfWGqALcmaiOqpK4+TFlmgZSd2/ZI5eGuQ/u38=;
	h=Date:To:From:Subject:From;
	b=MzqjSpy08AF1PGOOQ8vqidfYRxs5znVEmfQ6x4qNAcTFYiD44RXN5cEeMZyAh8bxn
	 0ukDQPAeXEo/flvYRB/UHAe5wb2+6GZnK2c6rXCzlagaue8HpvOJ0Uo0aKDK3MD03q
	 kKKL+dc/9KrfdubItEh5B1uFUpukmMsm5giGlX8Q=
Date: Sun, 28 Dec 2025 12:03:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch added to mm-new branch
Message-Id: <20251228200303.AB194C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: support batch clearing of the young flag for large folios
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64: mm: support batch clearing of the young flag for large folios
Date: Fri, 26 Dec 2025 14:07:57 +0800

Currently, contpte_ptep_test_and_clear_young() and
contpte_ptep_clear_flush_young() only clear the young flag and flush TLBs
for PTEs within the contiguous range.  To support batch PTE operations for
other sized large folios in the following patches, adding a new parameter
to specify the number of PTEs that map consecutive pages of the same large
folio in a single VMA and a single page table.

While we are at it, rename the functions to maintain consistency with
other contpte_*() functions.

Link: https://lkml.kernel.org/r/a5138065a70a7588904d0bcfc569a5d856dcc65e.1766631066.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   12 +++++-----
 arch/arm64/mm/contpte.c          |   33 ++++++++++++++++-------------
 2 files changed, 25 insertions(+), 20 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(stru
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
 				unsigned int nr, int full);
-extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
-extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep);
+int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
+int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep, unsigned int nr);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_yo
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
 
-	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
-	return contpte_ptep_clear_flush_young(vma, addr, ptep);
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
 }
 
 #define wrprotect_ptes wrprotect_ptes
--- a/arch/arm64/mm/contpte.c~arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios
+++ a/arch/arm64/mm/contpte.c
@@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(st
 }
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
-int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
 {
 	/*
 	 * ptep_clear_flush_young() technically requires us to clear the access
@@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(st
 	 * contig range when the range is covered by a single folio, we can get
 	 * away with clearing young for the whole contig range here, so we avoid
 	 * having to unfold.
+	 *
+	 * The 'nr' means consecutive (present) PTEs that map consecutive pages
+	 * of the same large folio in a single VMA and a single page table.
 	 */
 
+	unsigned long end = addr + nr * PAGE_SIZE;
 	int young = 0;
-	int i;
 
-	ptep = contpte_align_down(ptep);
-	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-
-	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
+	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
+	for (; addr != end; ptep++, addr += PAGE_SIZE)
 		young |= __ptep_test_and_clear_young(vma, addr, ptep);
 
 	return young;
 }
-EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
+EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
 
-int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep)
+int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr)
 {
 	int young;
 
-	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
+	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
 
 	if (young) {
+		unsigned long end = addr + nr * PAGE_SIZE;
+
+		contpte_align_addr_ptep(&addr, &end, ptep, nr);
 		/*
 		 * See comment in __ptep_clear_flush_young(); same rationale for
 		 * eliding the trailing DSB applies here.
 		 */
-		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
-		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
+		__flush_tlb_range_nosync(vma->vm_mm, addr, end,
 					 PAGE_SIZE, true, 3);
 	}
 
 	return young;
 }
-EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
+EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
 
 void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch

