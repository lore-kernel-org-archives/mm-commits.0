Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E90321FF3B;
	Thu, 10 Jul 2025 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120552; cv=none; b=hKwpXrxX73LnnUWCWdLAOLbR0F2hQMJgF4UU60c9mQWzQjaVoc7sC8oLlJDTT4bgfV5W/pLTUuTuRE87siBrI7mRTz/1J/L00YVtw/tTSt6oCD+QQUV/H6vzheaOBOt3daT2sPMvkvHMq/Y/f3KOmTzC/JV80NH3kzijmnt63z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120552; c=relaxed/simple;
	bh=rymEoL51MRzsnAS9ZpvjiVb+apckSTAKtmAz69IKIpM=;
	h=Date:To:From:Subject:Message-Id; b=d4lc4R3shM+E59DDAQh+bviuSNxAXbwFAZB8AiUigyi2JC7Z3uP86qg980ZDvw/vbXh1NmumNFlK6i2zXcHHUp+xXs+2rjR8kRRaIeYvqKoc1Qllk79KZhHHr/y+syQPScJaRBynb1NC7d4mOp5iQyIEqPhymnffZUqnOHOt8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEz8QX02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEz8QX02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009E1C4CEE3;
	Thu, 10 Jul 2025 04:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120552;
	bh=rymEoL51MRzsnAS9ZpvjiVb+apckSTAKtmAz69IKIpM=;
	h=Date:To:From:Subject:From;
	b=TEz8QX022ZmNyjPVUc8UJZ8W2+289GJDxW0mNyAUZqttjiWhaYm612XVMhaYwcPnV
	 cQuF0zIxRccFPBesrp+yP9oNvnSk/aRBKOx+aGEa+RBjDlr8gIz8Cg4lx1Xa/S+SBM
	 bFBuhzj8zNG7KDyZ5kCDTaI4uE0C3TOgEZh4rlqM=
Date: Wed, 09 Jul 2025 21:09:11 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,mingzhe.yang@ly.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kasong@tencent.com,huang.ying.caritas@gmail.com,harry.yoo@oracle.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch removed from -mm tree
Message-Id: <20250710040912.009E1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix potential out-of-bounds page table access during batched unmap
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/rmap: fix potential out-of-bounds page table access during batched unmap
Date: Fri, 27 Jun 2025 14:23:19 +0800

As pointed out by David[1], the batched unmap logic in
try_to_unmap_one() may read past the end of a PTE table when a large
folio's PTE mappings are not fully contained within a single page
table.

While this scenario might be rare, an issue triggerable from userspace
must be fixed regardless of its likelihood.  This patch fixes the
out-of-bounds access by refactoring the logic into a new helper,
folio_unmap_pte_batch().

The new helper correctly calculates the safe batch size by capping the
scan at both the VMA and PMD boundaries.  To simplify the code, it also
supports partial batching (i.e., any number of pages from 1 up to the
calculated safe maximum), as there is no strong reason to special-case
for fully mapped folios.

Link: https://lkml.kernel.org/r/20250701143100.6970-1-lance.yang@linux.dev
Link: https://lkml.kernel.org/r/20250630011305.23754-1-lance.yang@linux.dev
Link: https://lkml.kernel.org/r/20250627062319.84936-1-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/a694398c-9f03-4737-81b9-7e49c857fcbe@redhat.com [1]
Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/a694398c-9f03-4737-81b9-7e49c857fcbe@redhat.com
Suggested-by: Barry Song <baohua@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap
+++ a/mm/rmap.c
@@ -1845,23 +1845,32 @@ void folio_remove_rmap_pud(struct folio
 #endif
 }
 
-/* We support batch unmapping of PTEs for lazyfree large folios */
-static inline bool can_batch_unmap_folio_ptes(unsigned long addr,
-			struct folio *folio, pte_t *ptep)
+static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
+			struct page_vma_mapped_walk *pvmw,
+			enum ttu_flags flags, pte_t pte)
 {
 	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
-	int max_nr = folio_nr_pages(folio);
-	pte_t pte = ptep_get(ptep);
+	unsigned long end_addr, addr = pvmw->address;
+	struct vm_area_struct *vma = pvmw->vma;
+	unsigned int max_nr;
+
+	if (flags & TTU_HWPOISON)
+		return 1;
+	if (!folio_test_large(folio))
+		return 1;
+
+	/* We may only batch within a single VMA and a single page table. */
+	end_addr = pmd_addr_end(addr, vma->vm_end);
+	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
+	/* We only support lazyfree batching for now ... */
 	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
-		return false;
+		return 1;
 	if (pte_unused(pte))
-		return false;
-	if (pte_pfn(pte) != folio_pfn(folio))
-		return false;
+		return 1;
 
-	return folio_pte_batch(folio, addr, ptep, pte, max_nr, fpb_flags, NULL,
-			       NULL, NULL) == max_nr;
+	return folio_pte_batch(folio, addr, pvmw->pte, pte, max_nr, fpb_flags,
+			       NULL, NULL, NULL);
 }
 
 /*
@@ -2024,9 +2033,7 @@ static bool try_to_unmap_one(struct foli
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
 		} else if (likely(pte_present(pteval))) {
-			if (folio_test_large(folio) && !(flags & TTU_HWPOISON) &&
-			    can_batch_unmap_folio_ptes(address, folio, pvmw.pte))
-				nr_pages = folio_nr_pages(folio);
+			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
 			flush_cache_range(vma, address, end_addr);
 
@@ -2206,13 +2213,16 @@ discard:
 			hugetlb_remove_rmap(folio);
 		} else {
 			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-			folio_ref_sub(folio, nr_pages - 1);
 		}
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-		folio_put(folio);
-		/* We have already batched the entire folio */
-		if (nr_pages > 1)
+		folio_put_refs(folio, nr_pages);
+
+		/*
+		 * If we are sure that we batched the entire folio and cleared
+		 * all PTEs, we can just optimize and stop right here.
+		 */
+		if (nr_pages == folio_nr_pages(folio))
 			goto walk_done;
 		continue;
 walk_abort:
_

Patches currently in -mm which might be from lance.yang@linux.dev are

locking-rwsem-make-owner-helpers-globally-available.patch
hung_task-extend-hung-task-blocker-tracking-to-rwsems.patch

