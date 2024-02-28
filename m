Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F940869
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146751; cv=none; b=lckLbG7CzosLSKnK+7N55+Tbjgr7hwcOxgi5mAT0KUIy1oGaFXyzARXynR4435+l7QXwMkmxxuhJAeXRPvDA2WCD29rw8eML5iqM+gjGFr8t7MozgE1kEe9y0MN1+d2hwlUaIIGhq5Wsc5e/z6pRW9IatFBXizeASJXCVnx+7Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146751; c=relaxed/simple;
	bh=yzouKdiDr1XlGrqvxSsJtUH/5dsVoyVe3nMYBkgInDQ=;
	h=Date:To:From:Subject:Message-Id; b=qz3w6wU7mZUKE0OohzidsOlf3OdITmJsHidjpNRlkJtxgcmu3t8f+4KMWNHO8Kcu6WS9EzSvKh5b3/pglUAea8nDtOxnAbcB+zRfD83MllS/XxDn9J2mQckLI/q3NtaYV4iI4hy3L4HEcZiAC/SIYiG2gg715UhM29PWeVii2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=miX/G3vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="miX/G3vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D93AC433F1;
	Wed, 28 Feb 2024 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146751;
	bh=yzouKdiDr1XlGrqvxSsJtUH/5dsVoyVe3nMYBkgInDQ=;
	h=Date:To:From:Subject:From;
	b=miX/G3vt/wK7Zxju9rx+xxlX4Sx5iuCc98Z2fyonk8F4UddynuQ4Ey6PxYCMcqJyF
	 Q1sGC9zHaUy+FPv7zMudFZHhkTftcQsWzAZbxMrcjkKOofoB9766fx+3pF/JTbjof3
	 EjsYyJc6ixt6qgFvmeys/xX7AZs4xjGDk9E+yASc=
Date: Wed, 28 Feb 2024 10:59:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__dump_folio.patch added to mm-unstable branch
Message-Id: <20240228185911.4D93AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add __dump_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__dump_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__dump_folio.patch

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
Subject: mm: add __dump_folio()
Date: Tue, 27 Feb 2024 19:23:31 +0000

Turn __dump_page() into a wrapper around __dump_folio().  Snapshot the
page & folio into a stack variable so we don't hit BUG_ON() if an
allocation is freed under us and what was a folio pointer becomes a
pointer to a tail page.

Link: https://lkml.kernel.org/r/20240227192337.757313-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |  118 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 53 deletions(-)

--- a/mm/debug.c~mm-add-__dump_folio
+++ a/mm/debug.c
@@ -51,84 +51,96 @@ const struct trace_print_flags vmaflag_n
 	{0, NULL}
 };
 
-static void __dump_page(struct page *page)
+static void __dump_folio(struct folio *folio, struct page *page,
+		unsigned long pfn, unsigned long idx)
 {
-	struct folio *folio = page_folio(page);
-	struct page *head = &folio->page;
-	struct address_space *mapping;
-	bool compound = PageCompound(page);
-	/*
-	 * Accessing the pageblock without the zone lock. It could change to
-	 * "isolate" again in the meantime, but since we are just dumping the
-	 * state for debugging, it should be fine to accept a bit of
-	 * inaccuracy here due to racing.
-	 */
-	bool page_cma = is_migrate_cma_page(page);
-	int mapcount;
+	struct address_space *mapping = folio_mapping(folio);
+	bool page_cma;
+	int mapcount = 0;
 	char *type = "";
 
-	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
-		/*
-		 * Corrupt page, so we cannot call page_mapping. Instead, do a
-		 * safe subset of the steps that page_mapping() does. Caution:
-		 * this will be misleading for tail pages, PageSwapCache pages,
-		 * and potentially other situations. (See the page_mapping()
-		 * implementation for what's missing here.)
-		 */
-		unsigned long tmp = (unsigned long)page->mapping;
-
-		if (tmp & PAGE_MAPPING_ANON)
-			mapping = NULL;
-		else
-			mapping = (void *)(tmp & ~PAGE_MAPPING_FLAGS);
-		head = page;
-		folio = (struct folio *)page;
-		compound = false;
-	} else {
-		mapping = page_mapping(page);
-	}
-
 	/*
-	 * Avoid VM_BUG_ON() in page_mapcount().
-	 * page->_mapcount space in struct page is used by sl[aou]b pages to
-	 * encode own info.
+	 * page->_mapcount space in struct page is used by slab pages to
+	 * encode own info, and we must avoid calling page_folio() again.
 	 */
-	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
+	if (!folio_test_slab(folio)) {
+		mapcount = atomic_read(&page->_mapcount) + 1;
+		if (folio_test_large(folio))
+			mapcount += folio_entire_mapcount(folio);
+	}
 
-	pr_warn("page:%p refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
-			page, page_ref_count(head), mapcount, mapping,
-			page_to_pgoff(page), page_to_pfn(page));
-	if (compound) {
-		pr_warn("head:%p order:%u entire_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
-				head, compound_order(head),
+	pr_warn("page: refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
+			folio_ref_count(folio), mapcount, mapping,
+			folio->index + idx, pfn);
+	if (folio_test_large(folio)) {
+		pr_warn("head: order:%u entire_mapcount:%d nr_pages_mapped:%d pincount:%d\n",
+				folio_order(folio),
 				folio_entire_mapcount(folio),
 				folio_nr_pages_mapped(folio),
 				atomic_read(&folio->_pincount));
 	}
 
 #ifdef CONFIG_MEMCG
-	if (head->memcg_data)
-		pr_warn("memcg:%lx\n", head->memcg_data);
+	if (folio->memcg_data)
+		pr_warn("memcg:%lx\n", folio->memcg_data);
 #endif
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		type = "ksm ";
-	else if (PageAnon(page))
+	else if (folio_test_anon(folio))
 		type = "anon ";
 	else if (mapping)
 		dump_mapping(mapping);
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
-	pr_warn("%sflags: %pGp%s\n", type, &head->flags,
+	/*
+	 * Accessing the pageblock without the zone lock. It could change to
+	 * "isolate" again in the meantime, but since we are just dumping the
+	 * state for debugging, it should be fine to accept a bit of
+	 * inaccuracy here due to racing.
+	 */
+	page_cma = is_migrate_cma_page(page);
+	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
 		page_cma ? " CMA" : "");
-	pr_warn("page_type: %pGt\n", &head->page_type);
+	pr_warn("page_type: %pGt\n", &folio->page.page_type);
 
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
 			sizeof(struct page), false);
-	if (head != page)
+	if (folio_test_large(folio))
 		print_hex_dump(KERN_WARNING, "head: ", DUMP_PREFIX_NONE, 32,
-			sizeof(unsigned long), head,
-			sizeof(struct page), false);
+			sizeof(unsigned long), folio,
+			2 * sizeof(struct page), false);
+}
+
+static void __dump_page(const struct page *page)
+{
+	struct folio *foliop, folio;
+	struct page precise;
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long idx, nr_pages = 1;
+	int loops = 5;
+
+again:
+	memcpy(&precise, page, sizeof(*page));
+	foliop = page_folio(&precise);
+	idx = folio_page_idx(foliop, page);
+	if (idx != 0) {
+		if (idx < (1UL << PUD_ORDER)) {
+			memcpy(&folio, foliop, 2 * sizeof(struct page));
+			nr_pages = folio_nr_pages(&folio);
+		}
+
+		if (idx > nr_pages) {
+			if (loops-- > 0)
+				goto again;
+			printk("page does not match folio\n");
+			precise.compound_head &= ~1UL;
+			foliop = (struct folio *)&precise;
+			idx = 0;
+		}
+	}
+
+	__dump_folio(foliop, &precise, pfn, idx);
 }
 
 void dump_page(struct page *page, const char *reason)
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
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

