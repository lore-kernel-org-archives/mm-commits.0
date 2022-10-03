Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0601C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJCVHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJCVFs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200591B7AC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4B1611D9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC6FC433D7;
        Mon,  3 Oct 2022 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831123;
        bh=DBImqrSPLj3KMaijHdHgHdn8flqI8N1weQAFo74YqcM=;
        h=Date:To:From:Subject:From;
        b=ZfiXGNeUcoR4k03XR/i2hZENu7D49jYnigdCeOBMbFNfljA725oCQF3Rq6XnqJXIf
         pa8h1K79SvqA7t2iXyGcqFJ/fw58tSpzX78/IUFWFpRKWisNIMnQ2+uSAL3i7sFe5L
         YAv579helgotzEhIjUN1Dgp/Oy7tcuerbjTHZbKM=
Date:   Mon, 03 Oct 2022 14:05:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_wp_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210523.0AC6FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_wp_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_wp_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_wp_page() to use a folio
Date: Fri, 2 Sep 2022 20:46:37 +0100

Saves many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-42-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/mm/memory.c~mm-convert-do_wp_page-to-use-a-folio
+++ a/mm/memory.c
@@ -3368,6 +3368,7 @@ static vm_fault_t do_wp_page(struct vm_f
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 
 	VM_BUG_ON(unshare && (vmf->flags & FAULT_FLAG_WRITE));
 	VM_BUG_ON(!unshare && !(vmf->flags & FAULT_FLAG_WRITE));
@@ -3414,48 +3415,47 @@ static vm_fault_t do_wp_page(struct vm_f
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
 	 */
-	if (PageAnon(vmf->page)) {
-		struct page *page = vmf->page;
-
+	folio = page_folio(vmf->page);
+	if (folio_test_anon(folio)) {
 		/*
 		 * If the page is exclusive to this process we must reuse the
 		 * page without further checks.
 		 */
-		if (PageAnonExclusive(page))
+		if (PageAnonExclusive(vmf->page))
 			goto reuse;
 
 		/*
-		 * We have to verify under page lock: these early checks are
-		 * just an optimization to avoid locking the page and freeing
+		 * We have to verify under folio lock: these early checks are
+		 * just an optimization to avoid locking the folio and freeing
 		 * the swapcache if there is little hope that we can reuse.
 		 *
-		 * PageKsm() doesn't necessarily raise the page refcount.
+		 * KSM doesn't necessarily raise the folio refcount.
 		 */
-		if (PageKsm(page) || page_count(page) > 3)
+		if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
 			goto copy;
-		if (!PageLRU(page))
+		if (!folio_test_lru(folio))
 			/*
 			 * Note: We cannot easily detect+handle references from
-			 * remote LRU pagevecs or references to PageLRU() pages.
+			 * remote LRU pagevecs or references to LRU folios.
 			 */
 			lru_add_drain();
-		if (page_count(page) > 1 + PageSwapCache(page))
+		if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
 			goto copy;
-		if (!trylock_page(page))
+		if (!folio_trylock(folio))
 			goto copy;
-		if (PageSwapCache(page))
-			try_to_free_swap(page);
-		if (PageKsm(page) || page_count(page) != 1) {
-			unlock_page(page);
+		if (folio_test_swapcache(folio))
+			folio_free_swap(folio);
+		if (folio_test_ksm(folio) || folio_ref_count(folio) != 1) {
+			folio_unlock(folio);
 			goto copy;
 		}
 		/*
-		 * Ok, we've got the only page reference from our mapping
-		 * and the page is locked, it's dark out, and we're wearing
+		 * Ok, we've got the only folio reference from our mapping
+		 * and the folio is locked, it's dark out, and we're wearing
 		 * sunglasses. Hit it.
 		 */
-		page_move_anon_rmap(page, vma);
-		unlock_page(page);
+		page_move_anon_rmap(vmf->page, vma);
+		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from willy@infradead.org are


