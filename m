Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D154D5A4
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5FlK84l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63860C433CA;
	Mon, 11 Dec 2023 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315427;
	bh=WIQhgIYm+hOHnPKV/GhK49+vENSSr9yOfOjiRIx0wVM=;
	h=Date:To:From:Subject:From;
	b=q5FlK84lS4Le58YtaD8QRFTt/vGx196cQ0TzZ4YABxjWNbmqtgmc1tFJ/7tR5n+3M
	 jMgC5Hr5/7ZIbvMwDtkictO+xUrRwuZY8URu3mgfx1yr/QpvHhpK23/raNFNvKM7oM
	 xWI8VQvbJJ8Zf7cz0Kh6/7jQFSqZZa7wCt3nLj5I=
Date: Mon, 11 Dec 2023 09:23:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-collapse_huge_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231211172347.63860C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert collapse_huge_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-collapse_huge_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-collapse_huge_page-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert collapse_huge_page() to use a folio
Date: Mon, 11 Dec 2023 16:22:13 +0000

Replace three calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20231211162214.2146080-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-simplify-the-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

