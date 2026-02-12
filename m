Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326532ED872
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939859; cv=none; b=gYYME6l71Y3W3xpQtFLSi9EFSJ/Q1p9y3XI+FfcQsI59A2H8vMXxr+yDNlO76n+qvMfPlN+NdMMKxIa1JGOydFFnjjELRsd9EWlr5siA1AdSQDCbjDFybWdo27QjD4XmYqQ4Ph+vkdUxiL8hKI7knOsF5jNfQBYsv704sMxgfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939859; c=relaxed/simple;
	bh=F+ld7peB5Y5kdZCyxUX/y0cktVrU4OSLYddVZ9LsIvM=;
	h=Date:To:From:Subject:Message-Id; b=Su17HQm/u0M2k9qYGHc7281voy+hTx8BrSKHpqpzl+S7yMu0ATG4t8eRJMfwZ7BU7zBiOrxZV6is7aWASWDiGB6aCg36HXTcsvKv0gZzZVSS01j6Rkj2a7xnpsUd0cSc53PIwaLNrXPU0/lsV7dw04RBQDrVyTAlKtCXgIHGJZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPQ9ERw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPQ9ERw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BE5C4CEF7;
	Thu, 12 Feb 2026 23:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939858;
	bh=F+ld7peB5Y5kdZCyxUX/y0cktVrU4OSLYddVZ9LsIvM=;
	h=Date:To:From:Subject:From;
	b=lPQ9ERw4u3dKnffeiIdyJ/px6vnETelc3LfC5ovt0sIIS1BYhlkpLwtCdFlQW9Y7A
	 V+0SgRov5/9EQOCOltOcXZQhKap+MV10RLe9yjuD3VO5AZdfnqsJVg6Zc8mT9O//Dy
	 Ulg3p/iv5sEargrjGbbUVxXEAyfF4YLra7AxMswc=
Date: Thu, 12 Feb 2026 15:44:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch removed from -mm tree
Message-Id: <20260212234418.B9BE5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rmap: support batched checks of the references for large folios
has been removed from the -mm tree.  Its filename was
     mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: support batched checks of the references for large folios
Date: Mon, 9 Feb 2026 22:07:24 +0800

Patch series "support batch checking of references and unmapping for large
folios", v6.


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

Link: https://lkml.kernel.org/r/cover.1770645603.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    9 ++++----
 include/linux/pgtable.h      |   35 +++++++++++++++++++++++++++++++++
 mm/rmap.c                    |   28 +++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 7 deletions(-)

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
@@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+/**
+ * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			    folio as old and flush the TLB.
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
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_clear_flush_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
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
@@ -913,9 +913,11 @@ static bool folio_referenced_one(struct
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -960,9 +962,21 @@ static bool folio_referenced_one(struct
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			if (folio_test_large(folio)) {
+				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte,
+						     pteval, max_nr);
+			}
+
+			ptes += nr;
+			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -972,7 +986,15 @@ static bool folio_referenced_one(struct
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


