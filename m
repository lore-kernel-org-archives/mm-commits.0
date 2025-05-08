Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A623184E
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 23:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746747411; cv=none; b=E7ZhqTB7H6IEWDso8yE60JJL9IYO++n67MU3desUZZ1nVLHBiAT3a11wjpyPNIF2ic65Ucz/TLkasaNHUQFgSco0lT/QSLdD0kPMYv4xty+6fEssNfmeRQk7UGbvdr4CfcgNFkSV/A8m7PKh90eTBnttZfTgi2HUUyJSC95vxDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746747411; c=relaxed/simple;
	bh=V3yYTI4RnJ+1fThrjlc6YFkD2c+VOCB3xYegdS3YYXQ=;
	h=Date:To:From:Subject:Message-Id; b=CN5b9/BwLs1rld8I0nmfmcZvFIPU927dRGkv9PZRdSLeTdnHSwHJ+kYZb8nP2qGH688pyfrlNd5wLCLu/aIPi7mbSDL4TeQAalGhNQhKyEuxSB+9GdWdwD7OtBQjWax7DYCICdIDc5LtWv1Ti5SPoo8pMKrBHG0lEMFY8ym7L/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLlD3bzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLlD3bzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5646EC4CEE7;
	Thu,  8 May 2025 23:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746747410;
	bh=V3yYTI4RnJ+1fThrjlc6YFkD2c+VOCB3xYegdS3YYXQ=;
	h=Date:To:From:Subject:From;
	b=gLlD3bzA1V9DRfjkDA5t4qVI/0tiiereFF3eWjz8CCI5gAFTVvubrSlsQLwU32wOu
	 txTzoyPBFqqLJmnk1J2+ZCfDdreVIxZJ5kKW/5sDemBfKi0T1dWh2TV90I7Y9ePdoV
	 KXLPAxXTvU6X7oaTn3+kkWCriV6PpLnrlQh4u1nA=
Date: Thu, 08 May 2025 16:36:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lorenzo.stoakes@oracle.com,libang.li@antgroup.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-optimize-mremap-by-pte-batching.patch removed from -mm tree
Message-Id: <20250508233650.5646EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize mremap() by PTE batching
has been removed from the -mm tree.  Its filename was
     mm-optimize-mremap-by-pte-batching.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: optimize mremap() by PTE batching
Date: Wed, 7 May 2025 11:32:56 +0530

To use PTE batching, we want to determine whether the folio mapped by the
PTE is large, thus requiring the use of vm_normal_folio().  We want to
avoid the cost of vm_normal_folio() if the code path doesn't already
require the folio.  For arm64, pte_batch_hint() does the job.  To
generalize this hint, add a helper which will determine whether two
consecutive PTEs point to consecutive PFNs, in which case there is a high
probability that the underlying folio is large.

Next, use folio_pte_batch() to optimize move_ptes().  On arm64, if the
ptes are painted with the contig bit, then ptep_get() will iterate through
all 16 entries to collect a/d bits.  Hence this optimization will result
in a 16x reduction in the number of ptep_get() calls.  Next,
ptep_get_and_clear() will eventually call contpte_try_unfold() on every
contig block, thus flushing the TLB for the complete large folio range. 
Instead, use get_and_clear_full_ptes() so as to elide TLBIs on each contig
block, and only do them on the starting and ending contig block.

Link: https://lkml.kernel.org/r/20250507060256.78278-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: bibo mao <maobibo@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   29 +++++++++++++++++++++++++++++
 mm/mremap.c             |   37 ++++++++++++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 7 deletions(-)

--- a/include/linux/pgtable.h~mm-optimize-mremap-by-pte-batching
+++ a/include/linux/pgtable.h
@@ -369,6 +369,35 @@ static inline pgd_t pgdp_get(pgd_t *pgdp
 }
 #endif
 
+/**
+ * maybe_contiguous_pte_pfns - Hint whether the page mapped by the pte belongs
+ * to a large folio.
+ * @ptep: Pointer to the page table entry.
+ * @pte: The page table entry.
+ *
+ * This helper is invoked when the caller wants to batch over a set of ptes
+ * mapping a large folio, but the concerned code path does not already have
+ * the folio. We want to avoid the cost of vm_normal_folio() only to find that
+ * the underlying folio was small; i.e keep the small folio case as fast as
+ * possible.
+ *
+ * The caller must ensure that ptep + 1 exists.
+ */
+static inline bool maybe_contiguous_pte_pfns(pte_t *ptep, pte_t pte)
+{
+	pte_t *next_ptep, next_pte;
+
+	if (pte_batch_hint(ptep, pte) != 1)
+		return true;
+
+	next_ptep = ptep + 1;
+	next_pte = ptep_get(next_ptep);
+	if (!pte_present(next_pte))
+		return false;
+
+	return unlikely(pte_pfn(next_pte) - pte_pfn(pte) == 1);
+}
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
--- a/mm/mremap.c~mm-optimize-mremap-by-pte-batching
+++ a/mm/mremap.c
@@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t p
 	return pte;
 }
 
+/* mremap a batch of PTEs mapping the same large folio */
+static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pte_t pte, int max_nr)
+{
+	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	struct folio *folio;
+	int nr = 1;
+
+	if ((max_nr != 1) && maybe_contiguous_pte_pfns(ptep, pte)) {
+		folio = vm_normal_folio(vma, addr, pte);
+		if (folio && folio_test_large(folio))
+			nr = folio_pte_batch(folio, addr, ptep, pte, max_nr,
+					     flags, NULL, NULL, NULL);
+	}
+	return nr;
+}
+
 static int move_ptes(struct pagetable_move_control *pmc,
 		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -177,7 +194,7 @@ static int move_ptes(struct pagetable_mo
 	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_ptep, *new_ptep;
-	pte_t pte;
+	pte_t old_pte, pte;
 	pmd_t dummy_pmdval;
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
@@ -186,6 +203,7 @@ static int move_ptes(struct pagetable_mo
 	unsigned long old_end = old_addr + extent;
 	unsigned long len = old_end - old_addr;
 	int err = 0;
+	int max_nr;
 
 	/*
 	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
@@ -236,12 +254,13 @@ static int move_ptes(struct pagetable_mo
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 
-	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
-				   new_ptep++, new_addr += PAGE_SIZE) {
-		if (pte_none(ptep_get(old_ptep)))
+	for (int nr = 1; old_addr < old_end; old_ptep += nr, old_addr += nr * PAGE_SIZE,
+				   new_ptep += nr, new_addr += nr * PAGE_SIZE) {
+		max_nr = (old_end - old_addr) >> PAGE_SHIFT;
+		old_pte = ptep_get(old_ptep);
+		if (pte_none(old_pte))
 			continue;
 
-		pte = ptep_get_and_clear(mm, old_addr, old_ptep);
 		/*
 		 * If we are remapping a valid PTE, make sure
 		 * to flush TLB before we drop the PTL for the
@@ -253,8 +272,12 @@ static int move_ptes(struct pagetable_mo
 		 * the TLB entry for the old mapping has been
 		 * flushed.
 		 */
-		if (pte_present(pte))
+		if (pte_present(old_pte)) {
+			nr = mremap_folio_pte_batch(vma, old_addr, old_ptep,
+						    old_pte, max_nr);
 			force_flush = true;
+		}
+		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr, 0);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
@@ -267,7 +290,7 @@ static int move_ptes(struct pagetable_mo
 				else if (is_swap_pte(pte))
 					pte = pte_swp_clear_uffd_wp(pte);
 			}
-			set_pte_at(mm, new_addr, new_ptep, pte);
+			set_ptes(mm, new_addr, new_ptep, pte, nr);
 		}
 	}
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

mempolicy-optimize-queue_folios_pte_range-by-pte-batching.patch

