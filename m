Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909151028
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059694; cv=none; b=phiKS8oPnBcG/K10XO4hfBWUg8SZxdf4h8wGhxNWWk7c+CUhGO5h3RMCOR2Zf1t3QXJ0zsh57YFfSfn66n4DfqYn9Tx1+pIv9B6wM4bxy+LbKwPvvUU8g17fvkYvs85+1y8c6HWsMiA1Av4CFz+JIHemx2x+SbIFLcdsg0eDbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059694; c=relaxed/simple;
	bh=x0XLEi8fB7y8L0NwwRgLQ1TXAiO7Jc/p0ad+wnz5rG4=;
	h=Date:To:From:Subject:Message-Id; b=gUfL5NSjaAa4QUI7LrX1Pl7ddrxlvkJp3ZFK87J3xVsdlggZ0XIiwQAE5laKtp8r6Nsckxw5C79S5Jrkp8bOGtxKOmXGYC/68YxlUFYBhOZw1oLzi6VpVdcSfSWNQuekTxh1izTClwNa/qY0Fy6aSEgZgmtHUy61FVwI8jpKPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sDVBptOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDVBptOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C17C43394;
	Tue, 27 Feb 2024 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059693;
	bh=x0XLEi8fB7y8L0NwwRgLQ1TXAiO7Jc/p0ad+wnz5rG4=;
	h=Date:To:From:Subject:From;
	b=sDVBptOXsCyo1pANtVp6TglyBvrVNCbSc+4j++o02pJX4LGhb34DbzBieLuboJKr7
	 KrVoNTWWVihMWOlcW9bJc12t5Vja9kjWmK3KDvsj1w/V2AFoziSiNA5LI7J1jhbLH5
	 YgQV3N6ZaIAN6XSA4MNJcRx/Cn0bmagxK2aYB/ek=
Date: Tue, 27 Feb 2024 10:48:13 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_swap_cache-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20240227184813.B3C17C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert free_swap_cache() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_swap_cache-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_swap_cache-to-take-a-folio.patch

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
Subject: mm: convert free_swap_cache() to take a folio
Date: Tue, 27 Feb 2024 17:42:52 +0000

All but one caller already has a folio, so convert
free_page_and_swap_cache() to have a folio and remove the call to
page_folio().

Link: https://lkml.kernel.org/r/20240227174254.710559-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++++----
 mm/khugepaged.c      |    2 +-
 mm/memory.c          |    2 +-
 mm/swap_state.c      |   12 ++++++------
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/swap.h~mm-convert-free_swap_cache-to-take-a-folio
+++ a/include/linux/swap.h
@@ -447,9 +447,9 @@ static inline unsigned long total_swapca
 	return global_node_page_state(NR_SWAPCACHE);
 }
 
-extern void free_swap_cache(struct page *page);
-extern void free_page_and_swap_cache(struct page *);
-extern void free_pages_and_swap_cache(struct encoded_page **, int);
+void free_swap_cache(struct folio *folio);
+void free_page_and_swap_cache(struct page *);
+void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
@@ -531,7 +531,7 @@ static inline void put_swap_device(struc
 /* used to sanity check ptes in zap_pte_range when CONFIG_SWAP=0 */
 #define free_swap_and_cache(e) is_pfn_swap_entry(e)
 
-static inline void free_swap_cache(struct page *page)
+static inline void free_swap_cache(struct folio *folio)
 {
 }
 
--- a/mm/khugepaged.c~mm-convert-free_swap_cache-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -731,7 +731,7 @@ static void __collapse_huge_page_copy_su
 		node_stat_sub_folio(src, NR_ISOLATED_ANON +
 				folio_is_file_lru(src));
 		folio_unlock(src);
-		free_swap_cache(&src->page);
+		free_swap_cache(src);
 		folio_putback_lru(src);
 	}
 }
--- a/mm/memory.c~mm-convert-free_swap_cache-to-take-a-folio
+++ a/mm/memory.c
@@ -3376,7 +3376,7 @@ static vm_fault_t wp_page_copy(struct vm
 		folio_put(new_folio);
 	if (old_folio) {
 		if (page_copied)
-			free_swap_cache(&old_folio->page);
+			free_swap_cache(old_folio);
 		folio_put(old_folio);
 	}
 
--- a/mm/swap_state.c~mm-convert-free_swap_cache-to-take-a-folio
+++ a/mm/swap_state.c
@@ -283,10 +283,8 @@ void clear_shadow_from_swap_cache(int ty
  * folio_free_swap() _with_ the lock.
  * 					- Marcelo
  */
-void free_swap_cache(struct page *page)
+void free_swap_cache(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	if (folio_test_swapcache(folio) && !folio_mapped(folio) &&
 	    folio_trylock(folio)) {
 		folio_free_swap(folio);
@@ -300,9 +298,11 @@ void free_swap_cache(struct page *page)
  */
 void free_page_and_swap_cache(struct page *page)
 {
-	free_swap_cache(page);
+	struct folio *folio = page_folio(page);
+
+	free_swap_cache(folio);
 	if (!is_huge_zero_page(page))
-		put_page(page);
+		folio_put(folio);
 }
 
 /*
@@ -319,7 +319,7 @@ void free_pages_and_swap_cache(struct en
 	for (int i = 0; i < nr; i++) {
 		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
 
-		free_swap_cache(&folio->page);
+		free_swap_cache(folio);
 		refs[folios.nr] = 1;
 		if (unlikely(encoded_page_flags(pages[i]) &
 			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
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

