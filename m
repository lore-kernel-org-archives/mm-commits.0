Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF35134A9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HEKBSnjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7879CC433CA;
	Fri, 29 Dec 2023 19:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879987;
	bh=4QcDQLDuBV9gAyldbRnrt25AQtIqGyN8rhyHJS0VXsw=;
	h=Date:To:From:Subject:From;
	b=HEKBSnjgmRDCOwgJ5I7ZSZPhl4H64Q0ig0Ik1wHIseRULWCOcX4Tsk1GD3Mi4fiwo
	 pNuguR+Fo/O5I6w2bo1pC8ltcThum44h/idtYe/nARlT6OuLuROC0FArtF/pMsZLdz
	 kcfcL6ofNj46e+sa8rG6AK53qUujakfD5Wq5D8rQ=
Date: Fri, 29 Dec 2023 11:59:47 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-collapse_huge_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231229195947.7879CC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert collapse_huge_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-collapse_huge_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert collapse_huge_page() to use a folio
Date: Mon, 11 Dec 2023 16:22:13 +0000

Replace three calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20231211162214.2146080-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-convert-collapse_huge_page-to-use-a-folio
+++ a/mm/khugepaged.c
@@ -1090,6 +1090,7 @@ static int collapse_huge_page(struct mm_
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
+	struct folio *folio;
 	struct page *hpage;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
@@ -1212,13 +1213,13 @@ static int collapse_huge_page(struct mm_
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
+	folio = page_folio(hpage);
 	/*
-	 * spin_lock() below is not the equivalent of smp_wmb(), but
-	 * the smp_wmb() inside __SetPageUptodate() can be reused to
-	 * avoid the copy_huge_page writes to become visible after
-	 * the set_pmd_at() write.
+	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
+	 * copy_huge_page writes become visible before the set_pmd_at()
+	 * write.
 	 */
-	__SetPageUptodate(hpage);
+	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
 	_pmd = mk_huge_pmd(hpage, vma->vm_page_prot);
@@ -1226,8 +1227,8 @@ static int collapse_huge_page(struct mm_
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	page_add_new_anon_rmap(hpage, vma, address);
-	lru_cache_add_inactive_or_unevictable(hpage, vma);
+	folio_add_new_anon_rmap(folio, vma, address);
+	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

