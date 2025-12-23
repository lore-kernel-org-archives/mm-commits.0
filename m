Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F6A145348
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766514333; cv=none; b=cXRgDnYA+HZOp9gKIEip2lnMDSP7uSTPi8qzrxERYO/5wxgx4scF5dX4s+wrwoiPOIPCMt3bH+ZAiHXlQQM175g0hhR35IboyLj/QxnBl47dqG8q+nn9MdwLqXl+ngDs781PFo4+pb9bk5iQ1pVGKBaZiCzf+dgks+3rCnL/kgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766514333; c=relaxed/simple;
	bh=4lLmi4NKCMZJI6Q0Rqd2QP927RAIbR3M3hGSRv7NR7I=;
	h=Date:To:From:Subject:Message-Id; b=cDcHM9kKVZOvrUjSNEt3iaF6R5OzVMY1ZeqOG/Q0LZT8saUpRdQxbCFDIZ3VP2A5NCVPwG43/YiVHbB4m0hjH4JtfLcrEq7S8JXxMDZQECaBSfdr1IKxPWFDqATr3c9D7+ki8bj1quiBeuV3dNPHDgSwjwjCr3UaBZPdqksNL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KT+5XKpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KT+5XKpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597FAC113D0;
	Tue, 23 Dec 2025 18:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766514332;
	bh=4lLmi4NKCMZJI6Q0Rqd2QP927RAIbR3M3hGSRv7NR7I=;
	h=Date:To:From:Subject:From;
	b=KT+5XKpcYYh6oR1NYtYwxzTTAtrt9BF3DRT38SGFmNNJnyoWRuPJvu2H+OeizQHz4
	 VNPv6w1VdAqYqnxBrPP/PNZZZrTLojoT0+UFw2o2MQn74YSDBoNnP7SrXGH5nN1BUk
	 uf98BHJg3XEN1sqALQTJK2u82tWAhq66PdPiBz/A=
Date: Tue, 23 Dec 2025 10:25:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch added to mm-new branch
Message-Id: <20251223182532.597FAC113D0@smtp.kernel.org>
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
Date: Tue, 23 Dec 2025 13:48:35 +0800

Patch series "support batch checking of references and unmapping for large
folios", v4.

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

Patch 1: Add a new generic batched PTE helper that supports batched checks of
the references for large folios.
Patch 2 - 3: Preparation patches.
patch 4: Implement the Arm64 arch-specific clear_flush_young_ptes().
Patch 5: Support batched unmapping for file large folios.


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

Link: https://lkml.kernel.org/r/cover.1766455377.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/e9ff5fa689740f3b6f3ed1c1ec0e3244f20c1f06.1766455378.git.baolin.wang@linux.alibaba.com
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

 include/linux/mmu_notifier.h |    9 ++++----
 include/linux/pgtable.h      |   35 +++++++++++++++++++++++++++++++++
 mm/rmap.c                    |   29 +++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 6 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-rmap-support-batched-checks-of-the-references-for-large-folios
+++ a/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_in
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
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
+#define ptep_clear_flush_young_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
--- a/include/linux/pgtable.h~mm-rmap-support-batched-checks-of-the-references-for-large-folios
+++ a/include/linux/pgtable.h
@@ -1087,6 +1087,41 @@ static inline void wrprotect_ptes(struct
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
+	int young;
+
+	young = ptep_clear_flush_young(vma, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		young |= ptep_clear_flush_young(vma, addr, ptep);
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
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
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

