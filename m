Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFDD285061
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126282; cv=none; b=jCdt1ZSNUWPRNfHUOv5N/B4pX91qJGWzlwlcbkgemlW/GDpvB8rO6JUhqe2jtbU9bpQNH+LYgUwIcrLTcJnPeDdKiDYeZ0GITQCe/0kApdnXzKsEg+xDm5+xa7L0cdPCCcLJEcQz5iX8Jtoyya5fTK7Mkx2Ph0bPUk0oXhqIQ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126282; c=relaxed/simple;
	bh=DSv5Cv/4UCF+dS6nr4W24uxgn1DIyr4Okf/ChpmmU1I=;
	h=Date:To:From:Subject:Message-Id; b=YCn+Y4j0CRIGHzlQI2IGmhQo+vzFS/eXb9wiNageXNMOGOvp5dDzBM+MJkV7fL6Y50YYajlGWOgdFqN2hkKaFFf3lApBiJXCHgSAivyC6V4fQQi02mlwlh3jTHGSXzKasRYaapztbJqMmeGuSx/r409sK6RExmj91PebgVbVF7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxYMTLLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxYMTLLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB560C4CEE3;
	Thu, 10 Jul 2025 05:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126281;
	bh=DSv5Cv/4UCF+dS6nr4W24uxgn1DIyr4Okf/ChpmmU1I=;
	h=Date:To:From:Subject:From;
	b=cxYMTLLA8kfEHytfVa1y5HqWzLjaGFO3js4s8Iq/PhcoP4UnF2FKWZaaMBm5Cp7Hi
	 TpuwvM6SIPiQwWACF4qWJqyQv+/DgkQ8tulmuOd4JH6goG7cNtPtBNmXvjUk1jHEVx
	 fETY8IenDeKXREPddUammJwTrH1wrSSucnYR/Rjs=
Date: Wed, 09 Jul 2025 22:44:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,pfalcato@suse.de,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lorenzo.stoakes@oracle.com,libang.li@antgroup.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimize-mremap-by-pte-batching.patch removed from -mm tree
Message-Id: <20250710054441.BB560C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize mremap() by PTE batching
has been removed from the -mm tree.  Its filename was
     mm-optimize-mremap-by-pte-batching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: optimize mremap() by PTE batching
Date: Tue, 10 Jun 2025 09:20:43 +0530

Use folio_pte_batch() to optimize move_ptes().  On arm64, if the ptes are
painted with the contig bit, then ptep_get() will iterate through all 16
entries to collect a/d bits.  Hence this optimization will result in a 16x
reduction in the number of ptep_get() calls.  Next, ptep_get_and_clear()
will eventually call contpte_try_unfold() on every contig block, thus
flushing the TLB for the complete large folio range.  Instead, use
get_and_clear_full_ptes() so as to elide TLBIs on each contig block, and
only do them on the starting and ending contig block.

For split folios, there will be no pte batching; nr_ptes will be 1.  For
pagetable splitting, the ptes will still point to the same large folio;
for arm64, this results in the optimization described above, and for other
arches (including the general case), a minor improvement is expected due
to a reduction in the number of function calls.

Link: https://lkml.kernel.org/r/20250610035043.75448-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: bibo mao <maobibo@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-optimize-mremap-by-pte-batching
+++ a/mm/mremap.c
@@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t p
 	return pte;
 }
 
+static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pte_t pte, int max_nr)
+{
+	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	struct folio *folio;
+
+	if (max_nr == 1)
+		return 1;
+
+	folio = vm_normal_folio(vma, addr, pte);
+	if (!folio || !folio_test_large(folio))
+		return 1;
+
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr, flags, NULL,
+			       NULL, NULL);
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
@@ -185,6 +202,8 @@ static int move_ptes(struct pagetable_mo
 	unsigned long new_addr = pmc->new_addr;
 	unsigned long old_end = old_addr + extent;
 	unsigned long len = old_end - old_addr;
+	int max_nr_ptes;
+	int nr_ptes;
 	int err = 0;
 
 	/*
@@ -236,14 +255,16 @@ static int move_ptes(struct pagetable_mo
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 
-	for (; old_addr < old_end; old_ptep++, old_addr += PAGE_SIZE,
-				   new_ptep++, new_addr += PAGE_SIZE) {
+	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
+		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
 		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
 
-		if (pte_none(ptep_get(old_ptep)))
+		nr_ptes = 1;
+		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
+		old_pte = ptep_get(old_ptep);
+		if (pte_none(old_pte))
 			continue;
 
-		pte = ptep_get_and_clear(mm, old_addr, old_ptep);
 		/*
 		 * If we are remapping a valid PTE, make sure
 		 * to flush TLB before we drop the PTL for the
@@ -255,8 +276,12 @@ static int move_ptes(struct pagetable_mo
 		 * the TLB entry for the old mapping has been
 		 * flushed.
 		 */
-		if (pte_present(pte))
+		if (pte_present(old_pte)) {
+			nr_ptes = mremap_folio_pte_batch(vma, old_addr, old_ptep,
+							 old_pte, max_nr_ptes);
 			force_flush = true;
+		}
+		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
@@ -269,7 +294,7 @@ static int move_ptes(struct pagetable_mo
 				else if (is_swap_pte(pte))
 					pte = pte_swp_clear_uffd_wp(pte);
 			}
-			set_pte_at(mm, new_addr, new_ptep, pte);
+			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 		}
 	}
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

maple-tree-add-some-comments.patch
khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch
khugepaged-generalize-alloc_charge_folio.patch

