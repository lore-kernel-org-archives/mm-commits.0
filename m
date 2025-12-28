Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9B526FD93
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766952178; cv=none; b=eKFpbQ0fIaHIzniZADHBqIl15d6c0phNr43Hug33JmMTRqZqRpw01T1qyVs/IE9hKJCr8Ibezrr2AujlrElvCN/08L6AsH36/hp3EbMazvD437Bnf/yix3H4mgj5zIMfK+bhgkGISHmuI82gsJILax3lnf4+dddo3/74Kuy2Xe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766952178; c=relaxed/simple;
	bh=2zOowdCOLBRFSl8NMKgGc/yVOftiaeMrwP5dMgG3SiM=;
	h=Date:To:From:Subject:Message-Id; b=aOkqrNWWD+uz7WiP75XQBLLn/8sgAApDYS1gPDnZxDMgfuhpNwR50TJNZ6VfDFymii22vo7v+4DMZhDcK+ITOdW8aqNmH81kG4HLXz3Eukox8nf2xgw8EX59ws7IihTwNgyX8P6j3c6vxMXZzvEdObJ5D2fAxGwXy8t7SpY0SiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cTW1YH0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cTW1YH0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50965C4CEFB;
	Sun, 28 Dec 2025 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766952178;
	bh=2zOowdCOLBRFSl8NMKgGc/yVOftiaeMrwP5dMgG3SiM=;
	h=Date:To:From:Subject:From;
	b=cTW1YH0gvOAM3N3KRcDBI/JfDnzDgIfUMukp53/R0MWYv9TdmEkx+JACZAltHl5Nc
	 iu2aLgVIPyur5+r0Jl3SevUH4xSNdUhJHZL9eZ87dDc7OZVBYeBERaUM7tAkf+kGrN
	 nTiWlBeKs127orklS5NM1w3YqkdW0iOUnB1adGaU=
Date: Sun, 28 Dec 2025 12:02:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch added to mm-new branch
Message-Id: <20251228200258.50965C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: support batched checks of the references for large folios
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch

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
Subject: mm: rmap: support batched checks of the references for large folios
Date: Fri, 26 Dec 2025 14:07:55 +0800

Patch series "support batch checking of references and unmapping for large
folios", v5.

Currently, folio_referenced_one() always checks the young flag for each
PTE sequentially, which is inefficient for large folios.  This
inefficiency is especially noticeable when reclaiming clean file-backed
large folios, where folio_referenced() is observed as a significant
performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is
already an optimization to clear the young flags for PTEs within a
contiguous range.  However, this is not sufficient.  We can extend this to
perform batched operations for the entire large folio (which might exceed
the contiguous range: CONT_PTE_SIZE).

Similar to folio_referenced_one(), we can also apply batched unmapping for
large file folios to optimize the performance of file folio reclamation. 
By supporting batched checking of the young flags, flushing TLB entries,
and unmapping, I can observed a significant performance improvements in my
performance tests for file folios reclamation.  Please check the
performance data in the commit message of each patch.


This patch (of 5):

Currently, folio_referenced_one() always checks the young flag for each
PTE sequentially, which is inefficient for large folios.  This
inefficiency is especially noticeable when reclaiming clean file-backed
large folios, where folio_referenced() is observed as a significant
performance hotspot.

Moreover, on Arm64 architecture, which supports contiguous PTEs, there is
already an optimization to clear the young flags for PTEs within a
contiguous range.  However, this is not sufficient.  We can extend this to
perform batched operations for the entire large folio (which might exceed
the contiguous range: CONT_PTE_SIZE).

Introduce a new API: clear_flush_young_ptes() to facilitate batched
checking of the young flags and flushing TLB entries, thereby improving
performance during large folio reclamation.  And it will be overridden by
the architecture that implements a more efficient batch operation in the
following patches.

While we are at it, rename ptep_clear_flush_young_notify() to
clear_flush_young_ptes_notify() to indicate that this is a batch
operation.

Link: https://lkml.kernel.org/r/cover.1766631066.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/18b3eb9c730d16756e5d23c7be22efe2f6219911.1766631066.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    9 +++++----
 include/linux/pgtable.h      |   31 +++++++++++++++++++++++++++++++
 mm/rmap.c                    |   31 ++++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 7 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-rmap-support-batched-checks-of-the-references-for-large-folios
+++ a/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_in
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
 ({									\
 	int __young;							\
 	struct vm_area_struct *___vma = __vma;				\
 	unsigned long ___address = __address;				\
-	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
+	unsigned int ___nr = __nr;					\
+	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
 	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
 						  ___address,		\
 						  ___address +		\
-							PAGE_SIZE);	\
+						  ___nr * PAGE_SIZE);	\
 	__young;							\
 })
 
@@ -650,7 +651,7 @@ static inline void mmu_notifier_subscrip
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define clear_flush_young_ptes_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
--- a/include/linux/pgtable.h~mm-rmap-support-batched-checks-of-the-references-for-large-folios
+++ a/include/linux/pgtable.h
@@ -1087,6 +1087,37 @@ static inline void wrprotect_ptes(struct
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+/**
+ * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
+ *			    that map consecutive pages of the same folio.
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear access bit.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_clear_flush_young().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	int i, young = 0;
+
+	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
--- a/mm/rmap.c~mm-rmap-support-batched-checks-of-the-references-for-large-folios
+++ a/mm/rmap.c
@@ -828,9 +828,11 @@ static bool folio_referenced_one(struct
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -875,9 +877,24 @@ static bool folio_referenced_one(struct
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			if (folio_test_large(folio)) {
+				unsigned long end_addr =
+					pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr =
+					(end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte,
+						     pteval, max_nr);
+			}
+
+			ptes += nr;
+			if (clear_flush_young_ptes_notify(vma, address,
+						pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -887,7 +904,15 @@ static bool folio_referenced_one(struct
 			WARN_ON_ONCE(1);
 		}
 
-		pra->mapcount--;
+		pra->mapcount -= nr;
+		/*
+		 * If we are sure that we batched the entire folio,
+		 * we can just optimize and stop right here.
+		 */
+		if (ptes == pvmw.nr_pages) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
 	}
 
 	if (referenced)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch

