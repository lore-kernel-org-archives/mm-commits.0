Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8FD111A5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600578; cv=none; b=HmBZWBCf6C/vpo/lHQUqUxMwLiM0mnJ+xNKVf6mgWhpFYgfEhynqnT+dHeJw2ckW/pm91XstBpogzb8lbthi+VM6lQAdmOCC4eRMr8NGIY7HbgKhHfMYy+fyN/imT2DIVJBFe3ab3TjG8XgD8zpQ9S0V8hqmIznNpzp7kItK5SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600578; c=relaxed/simple;
	bh=WDzNXGHAdXclLvQCk0jqgsH1BUN0hBOVZEGemgpTGjo=;
	h=Date:To:From:Subject:Message-Id; b=Pr62BSpFuYdVpufksWbU1h8BZeThJe0NQ3iqAc5tcsFk1exXMeiFrD62R4FVoq8MeFesJ/WII0N1GyNMoXY6qFQrfrj15VzCkz/WnV4sw3zGR1xi5eYVNZjoMRZFy4X39LMOeLaMPsz+CfRz0DciO1F7l5FONLqHVqOurNE6YMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G8g2d3zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G8g2d3zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D4C433C7;
	Tue,  5 Mar 2024 01:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600577;
	bh=WDzNXGHAdXclLvQCk0jqgsH1BUN0hBOVZEGemgpTGjo=;
	h=Date:To:From:Subject:From;
	b=G8g2d3zCi56Ov4KJVkVwuPoGwaqCztaN3fNHW+5BFMGA89mKk8vgC3WYmHbUHOxSp
	 eSGqIt4PcJq4n/yMLUNqZdsbq73P7q93Draft+QIjMxM/G6Lt1BZ3Fdy0iaDAHSG7f
	 HYFZfVrEX80qCral9cK71OUnxleSQcdBUZgccbEc=
Date: Mon, 04 Mar 2024 17:02:57 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch removed from -mm tree
Message-Id: <20240305010257.C34D4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use a folio in __collapse_huge_page_copy_succeeded()
has been removed from the -mm tree.  Its filename was
     mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use a folio in __collapse_huge_page_copy_succeeded()
Date: Tue, 27 Feb 2024 17:42:51 +0000

These pages are all chained together through the lru list, so we know
they're folios.  Use the folio APIs to save three hidden calls to
compound_head().

Link: https://lkml.kernel.org/r/20240227174254.710559-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-use-a-folio-in-__collapse_huge_page_copy_succeeded
+++ a/mm/khugepaged.c
@@ -689,9 +689,7 @@ static void __collapse_huge_page_copy_su
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
-	struct folio *src_folio;
-	struct page *src_page;
-	struct page *tmp;
+	struct folio *src, *tmp;
 	pte_t *_pte;
 	pte_t pteval;
 
@@ -710,10 +708,11 @@ static void __collapse_huge_page_copy_su
 				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
 			}
 		} else {
-			src_page = pte_page(pteval);
-			src_folio = page_folio(src_page);
-			if (!folio_test_large(src_folio))
-				release_pte_folio(src_folio);
+			struct page *src_page = pte_page(pteval);
+
+			src = page_folio(src_page);
+			if (!folio_test_large(src))
+				release_pte_folio(src);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
@@ -721,20 +720,19 @@ static void __collapse_huge_page_copy_su
 			 */
 			spin_lock(ptl);
 			ptep_clear(vma->vm_mm, address, _pte);
-			folio_remove_rmap_pte(src_folio, src_page, vma);
+			folio_remove_rmap_pte(src, src_page, vma);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
 	}
 
-	list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
-		list_del(&src_page->lru);
-		mod_node_page_state(page_pgdat(src_page),
-				    NR_ISOLATED_ANON + page_is_file_lru(src_page),
-				    -compound_nr(src_page));
-		unlock_page(src_page);
-		free_swap_cache(src_page);
-		putback_lru_page(src_page);
+	list_for_each_entry_safe(src, tmp, compound_pagelist, lru) {
+		list_del(&src->lru);
+		node_stat_sub_folio(src, NR_ISOLATED_ANON +
+				folio_is_file_lru(src));
+		folio_unlock(src);
+		free_swap_cache(&src->page);
+		folio_putback_lru(src);
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

