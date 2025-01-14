Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7A62451FD
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837109; cv=none; b=tqcNXUqfGQkCTr+BmX2Xd7J7N5XqL/O9cqiCUUb2zIHmFv+E36OnPk1iyVnf1dFBn4LJxAfYBztzIRYP9VbWeIwDbsRtWdhw36cTPyhYy216qg6M3Yfyt2NnhoHykUrMmFuE4fYMC4Cb9HeF0PSOpC9BcYy0WidhExAjxcSxiu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837109; c=relaxed/simple;
	bh=/4l244tbfZyc2h1If3TR2/Xae6X+h2UDOaRsp9dQJk0=;
	h=Date:To:From:Subject:Message-Id; b=lgcPcPg+BlrSCXHnGT9B2z5zGqbJQJMu+f+Dy3w/Oq0PapUou96UFkq/aCHV28kA3fyxt1y9K1SnIse9t33ExU9eKnXhHlFzt3/1ETx7gNGnqhNsLFcPLl00gSpQbCj+IRtbWysh+rKPuLvzJ4cqSLx5bqqTZOR3yrlZI+tIe0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VdHHgaRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VdHHgaRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC5EC4CEDD;
	Tue, 14 Jan 2025 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837109;
	bh=/4l244tbfZyc2h1If3TR2/Xae6X+h2UDOaRsp9dQJk0=;
	h=Date:To:From:Subject:From;
	b=VdHHgaRA8ZITKp7XmaqCHGaGLXO+kKTwvQrrnEQRzhkXMOIIUbtEBSiqjdPmTf39s
	 ytVR7JdjOm7LwafgeKoRRZj12hFpsXyFiIoUUv8JCAciUM3rAOei6nDuNE7wJQi6Do
	 By9Cgtww/bjgR2DYH+ZLUTW36mvRjD35XX7FGEZA=
Date: Mon, 13 Jan 2025 22:45:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,david@redhat.com,chrisl@kernel.org,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-calls-to-lru_add_drain.patch removed from -mm tree
Message-Id: <20250114064508.EFC5EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unnecessary calls to lru_add_drain
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-calls-to-lru_add_drain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: remove unnecessary calls to lru_add_drain
Date: Thu, 19 Dec 2024 15:32:53 -0500

There seem to be several categories of calls to lru_add_drain and
lru_add_drain_all.

The first are code paths that recently allocated, swapped in, or otherwise
processed a batch of pages, and want them all on the LRU.  These drain
pages that were recently allocated, probably on the local CPU.

A second category are code paths that are actively trying to reclaim,
migrate, or offline memory.  These often use lru_add_drain_all, to drain
the caches on all CPUs.

However, there also seem to be some other callers where we aren't really
doing either.  They are calling lru_add_drain(), despite operating on
pages that may have been allocated long ago, and quite possibly on
different CPUs.

Those calls are not likely to be effective at anything but creating lock
contention on the LRU locks.

Remove the lru_add_drain calls in the latter category.

For detailed reasoning, see [1] and [2].

Link: https://lkml.kernel.org/r/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com [1]
Link: https://lkml.kernel.org/r/xxfhcjaq2xxcl5adastz5omkytenq7izo2e5f4q7e3ns4z6lko@odigjjc7hqrg [2]
Link: https://lkml.kernel.org/r/20241219153253.3da9e8aa@fangorn
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    1 -
 mm/mmap.c       |    2 --
 mm/swap_state.c |    1 -
 mm/vma.c        |    2 --
 4 files changed, 6 deletions(-)

--- a/mm/memory.c~mm-remove-unnecessary-calls-to-lru_add_drain
+++ a/mm/memory.c
@@ -2004,7 +2004,6 @@ void zap_page_range_single(struct vm_are
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
-	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
 	hugetlb_zap_begin(vma, &range.start, &range.end);
--- a/mm/mmap.c~mm-remove-unnecessary-calls-to-lru_add_drain
+++ a/mm/mmap.c
@@ -1336,7 +1336,6 @@ void exit_mmap(struct mm_struct *mm)
 		goto destroy;
 	}
 
-	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
@@ -1779,7 +1778,6 @@ int relocate_vma_down(struct vm_area_str
 				       vma, new_start, length, false, true))
 		return -ENOMEM;
 
-	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
 	next = vma_next(&vmi);
 	if (new_end > old_start) {
--- a/mm/swap_state.c~mm-remove-unnecessary-calls-to-lru_add_drain
+++ a/mm/swap_state.c
@@ -317,7 +317,6 @@ void free_pages_and_swap_cache(struct en
 	struct folio_batch folios;
 	unsigned int refs[PAGEVEC_SIZE];
 
-	lru_add_drain();
 	folio_batch_init(&folios);
 	for (int i = 0; i < nr; i++) {
 		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
--- a/mm/vma.c~mm-remove-unnecessary-calls-to-lru_add_drain
+++ a/mm/vma.c
@@ -430,7 +430,6 @@ void unmap_region(struct ma_state *mas,
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
 
-	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
@@ -1132,7 +1131,6 @@ static inline void vms_clear_ptes(struct
 	 * were isolated before we downgraded mmap_lock.
 	 */
 	mas_set(mas_detach, 1);
-	lru_add_drain();
 	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
 	update_hiwater_rss(vms->vma->vm_mm);
 	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
_

Patches currently in -mm which might be from riel@surriel.com are


