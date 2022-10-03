Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED8EC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiJCVHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJCVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3246422BFB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74F78CE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4A2C433D7;
        Mon,  3 Oct 2022 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831124;
        bh=h31Ob1vQiN3cdVvoxPQAK3zphLm2Cf9i3uw90XbY6RQ=;
        h=Date:To:From:Subject:From;
        b=y3MrzV44pRnJrsa5vREilJDbpyQTstMiXRPgOSxqKYrqwj9/zjUtis/XseTas0Qe2
         3OK8OCl4zu27JpMe58JJW5xoqhLenN8AUsnYFLVruKNGoEGsEz0usCw1/EWK+su8hU
         ZATYR+m8bSRBH79pTrM72UYllEB/nZf7DwWkgzqY=
Date:   Mon, 03 Oct 2022 14:05:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210524.4A4A2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: huge_memory: convert do_huge_pmd_wp_page() to use a folio
has been removed from the -mm tree.  Its filename was
     huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: huge_memory: convert do_huge_pmd_wp_page() to use a folio
Date: Fri, 2 Sep 2022 20:46:38 +0100

Removes many calls to compound_head().  Does not remove the assumption
that a folio may not be larger than a PMD.

Link: https://lkml.kernel.org/r/20220902194653.1739778-43-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -1305,6 +1305,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t orig_pmd = vmf->orig_pmd;
@@ -1326,46 +1327,48 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	}
 
 	page = pmd_page(orig_pmd);
+	folio = page_folio(page);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	/* Early check when only holding the PT lock. */
 	if (PageAnonExclusive(page))
 		goto reuse;
 
-	if (!trylock_page(page)) {
-		get_page(page);
+	if (!folio_trylock(folio)) {
+		folio_get(folio);
 		spin_unlock(vmf->ptl);
-		lock_page(page);
+		folio_lock(folio);
 		spin_lock(vmf->ptl);
 		if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
 			spin_unlock(vmf->ptl);
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return 0;
 		}
-		put_page(page);
+		folio_put(folio);
 	}
 
 	/* Recheck after temporarily dropping the PT lock. */
 	if (PageAnonExclusive(page)) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto reuse;
 	}
 
 	/*
-	 * See do_wp_page(): we can only reuse the page exclusively if there are
-	 * no additional references. Note that we always drain the LRU
-	 * pagevecs immediately after adding a THP.
+	 * See do_wp_page(): we can only reuse the folio exclusively if
+	 * there are no additional references. Note that we always drain
+	 * the LRU pagevecs immediately after adding a THP.
 	 */
-	if (page_count(page) > 1 + PageSwapCache(page) * thp_nr_pages(page))
+	if (folio_ref_count(folio) >
+			1 + folio_test_swapcache(folio) * folio_nr_pages(folio))
 		goto unlock_fallback;
-	if (PageSwapCache(page))
-		try_to_free_swap(page);
-	if (page_count(page) == 1) {
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
+	if (folio_ref_count(folio) == 1) {
 		pmd_t entry;
 
 		page_move_anon_rmap(page, vma);
-		unlock_page(page);
+		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
 			spin_unlock(vmf->ptl);
@@ -1380,7 +1383,7 @@ reuse:
 	}
 
 unlock_fallback:
-	unlock_page(page);
+	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
 	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
_

Patches currently in -mm which might be from willy@infradead.org are


