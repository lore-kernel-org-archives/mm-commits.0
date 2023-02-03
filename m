Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A525CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjBCGgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjBCGfo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E3B8B320
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5F27DCE2EC6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FEBC433EF;
        Fri,  3 Feb 2023 06:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406139;
        bh=JIC/G10p2MICc2GeGd8nWjyotRjlTjfK60Atic0nlF4=;
        h=Date:To:From:Subject:From;
        b=j01C71u7bGVT36iLRtM+71oGNb1XnYduTqlQLm2zY6T+/oP3mZqTrFSaIqMcv5wl1
         yQ7f3+oQ7ISijUi2yz14ba3R/2hWjvPvAsplbRH+7KYIhbt96beTeC+MmZN6vNnSRO
         iCeJ2RmeeT5ClEKs2qgv3sgIMCit6B+qtKtfEe4I=
Date:   Thu, 02 Feb 2023 22:35:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch removed from -mm tree
Message-Id: <20230203063539.80FEBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_add_file_rmap() to use a folio internally
has been removed from the -mm tree.  Its filename was
     mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_add_file_rmap() to use a folio internally
Date: Wed, 11 Jan 2023 14:28:53 +0000

The API for page_add_file_rmap() needs to be page-based, because we can
add mappings of individual pages.  But inside the function, we want to
only call compound_head() once and then use the folio APIs instead of the
page APIs that each call compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/rmap.c~mm-convert-page_add_file_rmap-to-use-a-folio-internally
+++ a/mm/rmap.c
@@ -1309,10 +1309,11 @@ void page_add_new_anon_rmap(struct page
  *
  * The caller needs to hold the pte lock.
  */
-void page_add_file_rmap(struct page *page,
-	struct vm_area_struct *vma, bool compound)
+void page_add_file_rmap(struct page *page, struct vm_area_struct *vma,
+		bool compound)
 {
-	atomic_t *mapped;
+	struct folio *folio = page_folio(page);
+	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int nr = 0, nr_pmdmapped = 0;
 	bool first;
 
@@ -1322,20 +1323,18 @@ void page_add_file_rmap(struct page *pag
 	if (likely(!compound)) {
 		first = atomic_inc_and_test(&page->_mapcount);
 		nr = first;
-		if (first && PageCompound(page)) {
-			mapped = subpages_mapcount_ptr(compound_head(page));
+		if (first && folio_test_large(folio)) {
 			nr = atomic_inc_return_relaxed(mapped);
 			nr = (nr < COMPOUND_MAPPED);
 		}
-	} else if (PageTransHuge(page)) {
+	} else if (folio_test_pmd_mappable(folio)) {
 		/* That test is redundant: it's for safety or to optimize out */
 
-		first = atomic_inc_and_test(compound_mapcount_ptr(page));
+		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (first) {
-			mapped = subpages_mapcount_ptr(page);
 			nr = atomic_add_return_relaxed(COMPOUND_MAPPED, mapped);
 			if (likely(nr < COMPOUND_MAPPED + COMPOUND_MAPPED)) {
-				nr_pmdmapped = thp_nr_pages(page);
+				nr_pmdmapped = folio_nr_pages(folio);
 				nr = nr_pmdmapped - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
@@ -1348,10 +1347,10 @@ void page_add_file_rmap(struct page *pag
 	}
 
 	if (nr_pmdmapped)
-		__mod_lruvec_page_state(page, PageSwapBacked(page) ?
+		__lruvec_stat_mod_folio(folio, folio_test_swapbacked(folio) ?
 			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
 	if (nr)
-		__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
 	mlock_vma_page(page, vma, compound);
 }
_

Patches currently in -mm which might be from willy@infradead.org are


