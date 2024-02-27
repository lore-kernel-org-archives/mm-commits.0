Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79550A73
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059692; cv=none; b=r2Kxf7Iwl2KVk02mOaS41vsYs0eUtiQVYisn8utlMgV2RqA9jFqJis3pLmG7hpd518lxsw3Oks0Uj4k0eAmCFcBehDj+XqgioJSfmAhOOI9VFlOlHjrdQSdRr0MmCBHNj51pk1CFnCmf43gLr9fwiEbQYeEOgmU4Yucw2O1y7+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059692; c=relaxed/simple;
	bh=STFwsQAHwJggHLB/kxqGoHIpWUzyx0OO5DATYBZ8nLc=;
	h=Date:To:From:Subject:Message-Id; b=aeWHsPghUihWVQwEoSfbItXiMTiq/A1e4Crfh6KTJlnYrocv2duN5XZ7jm+/O93qZen55KVtTsrzS/bYgBIl6KsFM0k12aPMXSUeE0VGgIfdgs9nN0la/TINPv0QYnXIbC/iEviLQSOL2EZV4OrmBXHLm3g0eNUtZ1tWQYlY920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWI4eawz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWI4eawz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F96C433C7;
	Tue, 27 Feb 2024 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059692;
	bh=STFwsQAHwJggHLB/kxqGoHIpWUzyx0OO5DATYBZ8nLc=;
	h=Date:To:From:Subject:From;
	b=VWI4eawzrZpTXJAYvFEcBiesPsQNKhfGuZbizO+iiFuqcriE8BstnuGPSmEftEZHC
	 5E7Gm/tXny8hz6/5Q/VwUC8U0YSTMCxiVxojUvJYW4nwPpzGkJK7wvkmWEcdm1qN5H
	 MnGjlDVCTFKTaBDGzDE0USX8sgkWTNOVrh1M56ac=
Date: Tue, 27 Feb 2024 10:48:11 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch added to mm-unstable branch
Message-Id: <20240227184812.71F96C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use a folio in __collapse_huge_page_copy_succeeded()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch

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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

