Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23703BA53
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560082; cv=none; b=jj52c7jQrd5xNDX8OCyi1F7uNq055trflnoHUrYXnG/vjuKQx3g+ey7T+SFuGr/zhFvxRw0jsVqziT5ONSn7NmgHbM5ALDpDGnDTG7OT/EFC8PCFeXP6qVCcfYqeO36Zj97o0yW+/TAP6A3jcY7wFE3ZeRxTTIrzgEt8zfTx3oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560082; c=relaxed/simple;
	bh=bkTro1V8c9B7BFLy3GtRky4fRm1fK1BR+D9kjyiibeo=;
	h=Date:To:From:Subject:Message-Id; b=K+AH3DvXcH94ZY7eQeXpeBZIucWQ/GnB5IFJN85aq3QBB1wk4pE+jD9rJhbcXd1+n5FrD9y78Dv8R77OcEXTO6fT7d5WlIz73XMivLDmMAQF7d31Qe2rCzh9S0J6OpRF/tDWlkIzITsxzjqMIrM5n+vUxdr1MXPw6Ze263GgAeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uUMmMBPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uUMmMBPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBC2C43394;
	Thu, 22 Feb 2024 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560081;
	bh=bkTro1V8c9B7BFLy3GtRky4fRm1fK1BR+D9kjyiibeo=;
	h=Date:To:From:Subject:From;
	b=uUMmMBPvZDEQ8q4I/ONmBuc0A09C3D/JViaKDEaRXqsvsc6H6evWJYEzAZyRFWqG0
	 HnDrQloYkA+m6NScuU/BMCZtHLKJ6WZWPoIJcDfRCKq4Qbd78oM1+F00KHyirgn0QD
	 U1uVKzsd19dLkyUqAs1hcouPQyWGotFOQXUMrW4s=
Date: Wed, 21 Feb 2024 16:01:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-mm_counter_file-to-take-a-folio.patch removed from -mm tree
Message-Id: <20240222000121.9EBC2C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert mm_counter_file() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-mm_counter_file-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert mm_counter_file() to take a folio
Date: Thu, 11 Jan 2024 15:24:29 +0000

Now all callers of mm_counter_file() have a folio, convert
mm_counter_file() to take a folio.  Saves a call to compound_head() hidden
inside PageSwapBacked().

Link: https://lkml.kernel.org/r/20240111152429.3374566-11-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    8 ++++----
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    4 ++--
 mm/khugepaged.c         |    4 ++--
 mm/memory.c             |   10 +++++-----
 mm/rmap.c               |    2 +-
 6 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-mm_counter_file-to-take-a-folio
+++ a/include/linux/mm.h
@@ -2595,10 +2595,10 @@ static inline void dec_mm_counter(struct
 	mm_trace_rss_stat(mm, member);
 }
 
-/* Optimized variant when page is already known not to be PageAnon */
-static inline int mm_counter_file(struct page *page)
+/* Optimized variant when folio is already known not to be anon */
+static inline int mm_counter_file(struct folio *folio)
 {
-	if (PageSwapBacked(page))
+	if (folio_test_swapbacked(folio))
 		return MM_SHMEMPAGES;
 	return MM_FILEPAGES;
 }
@@ -2607,7 +2607,7 @@ static inline int mm_counter(struct foli
 {
 	if (folio_test_anon(folio))
 		return MM_ANONPAGES;
-	return mm_counter_file(&folio->page);
+	return mm_counter_file(folio);
 }
 
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
--- a/kernel/events/uprobes.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/kernel/events/uprobes.c
@@ -188,7 +188,7 @@ static int __replace_page(struct vm_area
 		dec_mm_counter(mm, MM_ANONPAGES);
 
 	if (!folio_test_anon(old_folio)) {
-		dec_mm_counter(mm, mm_counter_file(old_page));
+		dec_mm_counter(mm, mm_counter_file(old_folio));
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
--- a/mm/huge_memory.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -1931,7 +1931,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		} else {
 			if (arch_needs_pgtable_deposit())
 				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(&folio->page),
+			add_mm_counter(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
 		}
 
@@ -2456,7 +2456,7 @@ static void __split_huge_pmd_locked(stru
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}
-		add_mm_counter(mm, mm_counter_file(&folio->page), -HPAGE_PMD_NR);
+		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;
 	}
 
--- a/mm/khugepaged.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -1634,7 +1634,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_ptes) {
 		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1665,7 +1665,7 @@ abort:
 	if (nr_ptes) {
 		flush_tlb_mm(mm);
 		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(&folio->page), -nr_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
 	}
 	if (start_pte)
 		pte_unmap_unlock(start_pte, ptl);
--- a/mm/memory.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/memory.c
@@ -966,7 +966,7 @@ copy_present_pte(struct vm_area_struct *
 	} else if (page) {
 		folio_get(folio);
 		folio_dup_file_rmap_pte(folio, page);
-		rss[mm_counter_file(page)]++;
+		rss[mm_counter_file(folio)]++;
 	}
 
 	/*
@@ -1873,7 +1873,7 @@ static int insert_page_into_pte_locked(s
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
 	folio_get(folio);
-	inc_mm_counter(vma->vm_mm, mm_counter_file(page));
+	inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
 	folio_add_file_rmap_pte(folio, page, vma);
 	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
@@ -3178,7 +3178,7 @@ static vm_fault_t wp_page_copy(struct vm
 	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
 		if (old_folio) {
 			if (!folio_test_anon(old_folio)) {
-				dec_mm_counter(mm, mm_counter_file(&old_folio->page));
+				dec_mm_counter(mm, mm_counter_file(old_folio));
 				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else {
@@ -4483,7 +4483,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (write)
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
-	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
+	add_mm_counter(vma->vm_mm, mm_counter_file(folio), HPAGE_PMD_NR);
 	folio_add_file_rmap_pmd(folio, page, vma);
 
 	/*
@@ -4546,7 +4546,7 @@ void set_pte_range(struct vm_fault *vmf,
 		folio_add_new_anon_rmap(folio, vma, addr);
 		folio_add_lru_vma(folio, vma);
 	} else {
-		add_mm_counter(vma->vm_mm, mm_counter_file(page), nr);
+		add_mm_counter(vma->vm_mm, mm_counter_file(folio), nr);
 		folio_add_file_rmap_ptes(folio, page, nr, vma);
 	}
 	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr);
--- a/mm/rmap.c~mm-convert-mm_counter_file-to-take-a-folio
+++ a/mm/rmap.c
@@ -1903,7 +1903,7 @@ static bool try_to_unmap_one(struct foli
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(&folio->page));
+			dec_mm_counter(mm, mm_counter_file(folio));
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio)))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

