Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3811718
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600579; cv=none; b=cjERmQ3SDWSjqaR+GIz8KrmBKZZsy7VOUMIWX8oLAlRl7lMhJWDEviA+uahOp8qmpZXvX21X0LEvN78eWNaDb3zWm0Kna+GlexvyVpVpdLBbyVYA63bh3z3bFxW262OtRHiYKM4ZCl55VxhaEM6LFrLxvuQotxmFUyvQCzWN0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600579; c=relaxed/simple;
	bh=Kr60tKmB5H0yZRRhiehBb7PrJzBe/V1J2IHq+U4X3/o=;
	h=Date:To:From:Subject:Message-Id; b=DiJsf5zzSGnbFyFaCyWf687/3vGh+zNRiD5YDwlVzYWZxHrLAYyS1iUb56va9tO4ipfTsHdCTOuN7aIfuwPzCTUGiw5XcfCyvS07Rs+41GvROWzyrQsdcfMPO1A6bpI7NimTgJwKFGS6zPg4NPxf7p/WTrxtqSZZCcqNpMmiV4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c6RMdtU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6RMdtU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C869DC433F1;
	Tue,  5 Mar 2024 01:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600578;
	bh=Kr60tKmB5H0yZRRhiehBb7PrJzBe/V1J2IHq+U4X3/o=;
	h=Date:To:From:Subject:From;
	b=c6RMdtU2hUjRtA54mPHJSODb+AVXcuaGjrm6psbYMgb7Qtyod2HX9hXm5ZXVXLAgt
	 /aNpSsgbuMmtwoSU21FVqD7rdLBbevJ0Lj/T0qpbG+jiGnca+EvPw93Ej3neX4Lpnk
	 OZYzpS8ayUwYqdQya4v03TLzeX7xSq5SkfwzE2Xs=
Date: Mon, 04 Mar 2024 17:02:58 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-free_swap_cache-to-take-a-folio.patch removed from -mm tree
Message-Id: <20240305010258.C869DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert free_swap_cache() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-free_swap_cache-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3452,7 +3452,7 @@ static vm_fault_t wp_page_copy(struct vm
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

