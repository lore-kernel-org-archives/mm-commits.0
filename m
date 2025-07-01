Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15AC433A5;
	Tue,  1 Jul 2025 01:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751331855; cv=none; b=aUFVMCb9UHP/fZUJUikqEQt6MxKiOE65007+MM59Ui0XPpyOMQ3P012l4zofQQSMVW7rUTWjBTAT1LKSJiFbUvFHVN9i0jG3Nb2XqEf48wpGRZN+XzgU2/d2ZIm+VvIgxWt8gc5kKk6ZqX9U9U6JdjsfRZY6fWo7brSShw2OvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751331855; c=relaxed/simple;
	bh=0Cwn85ERz8QjxvuUguS+RaHbcN2zy61QAW7DYQRus0E=;
	h=Date:To:From:Subject:Message-Id; b=D57i0Y3+ExnlT4ZWCqknnA+9+bDW9DWP+1ei5nYrb7MCIotuzVCD9XlXNykqA4OFbHBo750BiWvfwS/OhZyiH4uKg2ROoguvj0uMIOeDO/rkep5BoY0mJHUkRV2oZooSkYIwV9o/FFpNyVAYYhAL2foIk9AE6ag+IjAUUg+DWMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFeSk+OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFeSk+OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3908C4CEE3;
	Tue,  1 Jul 2025 01:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751331854;
	bh=0Cwn85ERz8QjxvuUguS+RaHbcN2zy61QAW7DYQRus0E=;
	h=Date:To:From:Subject:From;
	b=yFeSk+OXjRFbBwWJwb1R97ZnPdLV6iYDlnB/b9+p8pMDh+H2kjUGP8XKNftDqKuZV
	 40QdfFRHJVcjo56HKV5ZLk92rH0a4Fa4NKUBnDfhsZaRXRmDVvKuG+gFzb+3L8X+94
	 WfKA6xeGXyrUZUvZcSytzzo0y3a0q2uCvcapyrpo=
Date: Mon, 30 Jun 2025 18:04:14 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,mingzhe.yang@ly.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kasong@tencent.com,huang.ying.caritas@gmail.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250701010414.B3908C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix potential out-of-bounds page table access during batched unmap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20250630011305.23754-1-lance.yang@linux.dev
Link: https://lkml.kernel.org/r/20250627062319.84936-1-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/a694398c-9f03-4737-81b9-7e49c857fcbe@redhat.com [1]
Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Barry Song <baohua@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

mm-rmap-fix-potential-out-of-bounds-page-table-access-during-batched-unmap.patch

