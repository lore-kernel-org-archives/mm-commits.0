Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34055C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiJSXFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJSXFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:05:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C628215A335
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFB48B82565
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C47C433C1;
        Wed, 19 Oct 2022 23:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220681;
        bh=iK043TF029VYfdtXOes0sbtZMGJTG3A6WZYG6YK9Prw=;
        h=Date:To:From:Subject:From;
        b=G/p/TRM7Bzk78PJTZCiAiJjDdzhzo5NWc5u1XDCjVki52x0VpfkJrD6TUkUNL1pvF
         IPgWm8ZPC40qmtvmSeMzCRatfTFmtUGnR9iqgbp16OJBrACLAKAM7RrXs9fWPe0wPx
         BX+FrXbbBYQdL5G4vfFEYKt3nffQGTnwowJaiEwk=
Date:   Wed, 19 Oct 2022 16:04:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch added to mm-unstable branch
Message-Id: <20221019230441.93C47C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert find_get_incore_page() to filemap_get_incore_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch

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
Subject: mm: convert find_get_incore_page() to filemap_get_incore_folio()
Date: Wed, 19 Oct 2022 19:33:31 +0100

Return the containing folio instead of the precise page.  One of the
callers wants the folio and the other can do the folio->page conversion
itself.  Nets 442 bytes of text size reduction, 478 bytes removed and 36
bytes added.

Link: https://lkml.kernel.org/r/20221019183332.2802139-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++++---
 mm/mincore.c    |   10 +++++-----
 mm/swap.h       |    8 +++++---
 mm/swap_state.c |   15 +++++++--------
 4 files changed, 26 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-convert-find_get_incore_page-to-filemap_get_incore_folio
+++ a/mm/memcontrol.c
@@ -5648,15 +5648,21 @@ static struct page *mc_handle_swap_pte(s
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent)
 {
+	unsigned long index;
+	struct folio *folio;
+
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
 	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
-	/* page is moved even if it's not RSS of this task(page-faulted). */
+	/* folio is moved even if it's not RSS of this task(page-faulted). */
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	return find_get_incore_page(vma->vm_file->f_mapping,
-			linear_page_index(vma, addr));
+	index = linear_page_index(vma, addr);
+	folio = filemap_get_incore_folio(vma->vm_file->f_mapping, index);
+	if (!folio)
+		return NULL;
+	return folio_file_page(folio, index);
 }
 
 /**
--- a/mm/mincore.c~mm-convert-find_get_incore_page-to-filemap_get_incore_folio
+++ a/mm/mincore.c
@@ -52,7 +52,7 @@ static int mincore_hugetlb(pte_t *pte, u
 static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
 	unsigned char present = 0;
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * When tmpfs swaps out a page from a file, any process mapping that
@@ -60,10 +60,10 @@ static unsigned char mincore_page(struct
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	page = find_get_incore_page(mapping, index);
-	if (page) {
-		present = PageUptodate(page);
-		put_page(page);
+	folio = filemap_get_incore_folio(mapping, index);
+	if (folio) {
+		present = folio_test_uptodate(folio);
+		folio_put(folio);
 	}
 
 	return present;
--- a/mm/swap.h~mm-convert-find_get_incore_page-to-filemap_get_incore_folio
+++ a/mm/swap.h
@@ -41,7 +41,8 @@ void clear_shadow_from_swap_cache(int ty
 				  unsigned long end);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
-struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index);
+struct folio *filemap_get_incore_folio(struct address_space *mapping,
+		pgoff_t index);
 
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				   struct vm_area_struct *vma,
@@ -105,9 +106,10 @@ static inline struct folio *swap_cache_g
 }
 
 static inline
-struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
+struct folio *filemap_get_incore_folio(struct address_space *mapping,
+		pgoff_t index)
 {
-	return find_get_page(mapping, index);
+	return filemap_get_folio(mapping, index);
 }
 
 static inline bool add_to_swap(struct folio *folio)
--- a/mm/swap_state.c~mm-convert-find_get_incore_page-to-filemap_get_incore_folio
+++ a/mm/swap_state.c
@@ -373,16 +373,17 @@ struct folio *swap_cache_get_folio(swp_e
 }
 
 /**
- * find_get_incore_page - Find and get a page from the page or swap caches.
+ * filemap_get_incore_folio - Find and get a folio from the page or swap caches.
  * @mapping: The address_space to search.
  * @index: The page cache index.
  *
- * This differs from find_get_page() in that it will also look for the
- * page in the swap cache.
+ * This differs from filemap_get_folio() in that it will also look for the
+ * folio in the swap cache.
  *
- * Return: The found page or %NULL.
+ * Return: The found folio or %NULL.
  */
-struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
+struct folio *filemap_get_incore_folio(struct address_space *mapping,
+		pgoff_t index)
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
@@ -405,9 +406,7 @@ struct page *find_get_incore_page(struct
 	folio = filemap_get_folio(swap_address_space(swp), index);
 	put_swap_device(si);
 out:
-	if (!folio)
-		return NULL;
-	return folio_file_page(folio, index);
+	return folio;
 }
 
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-huge_memory-convert-split_huge_pages_in_file-to-use-a-folio.patch
mm-swap-convert-find_get_incore_page-to-use-folios.patch
mm-convert-find_get_incore_page-to-filemap_get_incore_folio.patch
mm-remove-fgp_head.patch

