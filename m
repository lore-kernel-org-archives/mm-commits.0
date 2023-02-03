Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B86C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjBCGgB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBCGfk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9668B7D7
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31E6361D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89104C4339B;
        Fri,  3 Feb 2023 06:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406137;
        bh=/+f3//RGm3bwRvm3/5X9I/a4TCbdjwF2NuODOQ7qiCc=;
        h=Date:To:From:Subject:From;
        b=csyZAQlZijwoIoWmZ0xO69dfyg1irwMKB8RPOgp6R8VTUaWVfC/H1pDVR/FccjsDz
         Q7gWav7aWtL/gbJTDdP9YH+1Bbjt29ZhvrJXdkvFr7pzrYCXoUWJ7R2lEkdPVlUZI6
         V2tKyAZ51uAJlDG3k/y3LfDe+QcJf+3SUt4G4ZaA=
Date:   Thu, 02 Feb 2023 22:35:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_remove_rmap-to-use-a-folio-internally.patch removed from -mm tree
Message-Id: <20230203063537.89104C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_remove_rmap() to use a folio internally
has been removed from the -mm tree.  Its filename was
     mm-convert-page_remove_rmap-to-use-a-folio-internally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_remove_rmap() to use a folio internally
Date: Wed, 11 Jan 2023 14:28:51 +0000

The API for page_remove_rmap() needs to be page-based, because we can
remove mappings of pages individually.  But inside the function, we want
to only call compound_head() once and then use the folio APIs instead of
the page APIs that each call compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/rmap.c~mm-convert-page_remove_rmap-to-use-a-folio-internally
+++ a/mm/rmap.c
@@ -1365,19 +1365,21 @@ void page_add_file_rmap(struct page *pag
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page,
-	struct vm_area_struct *vma, bool compound)
+void page_remove_rmap(struct page *page, struct vm_area_struct *vma,
+		bool compound)
 {
-	atomic_t *mapped;
+	struct folio *folio = page_folio(page);
+	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool last;
+	enum node_stat_item idx;
 
 	VM_BUG_ON_PAGE(compound && !PageHead(page), page);
 
 	/* Hugetlb pages are not counted in NR_*MAPPED */
-	if (unlikely(PageHuge(page))) {
+	if (unlikely(folio_test_hugetlb(folio))) {
 		/* hugetlb pages are always mapped with pmds */
-		atomic_dec(compound_mapcount_ptr(page));
+		atomic_dec(&folio->_entire_mapcount);
 		return;
 	}
 
@@ -1385,20 +1387,18 @@ void page_remove_rmap(struct page *page,
 	if (likely(!compound)) {
 		last = atomic_add_negative(-1, &page->_mapcount);
 		nr = last;
-		if (last && PageCompound(page)) {
-			mapped = subpages_mapcount_ptr(compound_head(page));
+		if (last && folio_test_large(folio)) {
 			nr = atomic_dec_return_relaxed(mapped);
 			nr = (nr < COMPOUND_MAPPED);
 		}
-	} else if (PageTransHuge(page)) {
+	} else if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
-		last = atomic_add_negative(-1, compound_mapcount_ptr(page));
+		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
-			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_sub_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED)) {
-				nr_pmdmapped = thp_nr_pages(page);
+				nr_pmdmapped = folio_nr_pages(folio);
 				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
@@ -1411,21 +1411,26 @@ void page_remove_rmap(struct page *page,
 	}
 
 	if (nr_pmdmapped) {
-		__mod_lruvec_page_state(page, PageAnon(page) ? NR_ANON_THPS :
-				(PageSwapBacked(page) ? NR_SHMEM_PMDMAPPED :
-				NR_FILE_PMDMAPPED), -nr_pmdmapped);
+		if (folio_test_anon(folio))
+			idx = NR_ANON_THPS;
+		else if (folio_test_swapbacked(folio))
+			idx = NR_SHMEM_PMDMAPPED;
+		else
+			idx = NR_FILE_PMDMAPPED;
+		__lruvec_stat_mod_folio(folio, idx, -nr_pmdmapped);
 	}
 	if (nr) {
-		__mod_lruvec_page_state(page, PageAnon(page) ? NR_ANON_MAPPED :
-				NR_FILE_MAPPED, -nr);
+		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
+		__lruvec_stat_mod_folio(folio, idx, -nr);
+
 		/*
-		 * Queue anon THP for deferred split if at least one small
-		 * page of the compound page is unmapped, but at least one
-		 * small page is still mapped.
+		 * Queue anon THP for deferred split if at least one
+		 * page of the folio is unmapped and at least one page
+		 * is still mapped.
 		 */
-		if (PageTransCompound(page) && PageAnon(page))
+		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
-				deferred_split_huge_page(compound_head(page));
+				deferred_split_huge_page(&folio->page);
 	}
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are


