Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F093C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJCVHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJCVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CCA1EC52
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15960610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E80CC433C1;
        Mon,  3 Oct 2022 21:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831125;
        bh=OoEu0UISU4FwYp9pEcrM+6MqbwbTuOr3JobID1akJbQ=;
        h=Date:To:From:Subject:From;
        b=FwBHQ2XpCat4o4VDEu3WjAGhA9J8t1ceEmwGE1xN+wLpApmyDtUVUXf32lJZj+ETt
         fcJdy7BbiIpdJc3W9j6FM3OAtnb7675X2Xf/tDZDDVPNZQk53OcQRoJFfO8cKygj2D
         GvPOFXdITKrj5dPB1a67GCE2WXX+fl88J4f/Qm2Q=
Date:   Mon, 03 Oct 2022 14:05:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] madvise-convert-madvise_free_pte_range-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210525.6E80CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise: convert madvise_free_pte_range() to use a folio
has been removed from the -mm tree.  Its filename was
     madvise-convert-madvise_free_pte_range-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: madvise: convert madvise_free_pte_range() to use a folio
Date: Fri, 2 Sep 2022 20:46:39 +0100

Saves a lot of calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-44-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

--- a/mm/madvise.c~madvise-convert-madvise_free_pte_range-to-use-a-folio
+++ a/mm/madvise.c
@@ -601,6 +601,7 @@ static int madvise_free_pte_range(pmd_t
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *orig_pte, *pte, ptent;
+	struct folio *folio;
 	struct page *page;
 	int nr_swap = 0;
 	unsigned long next;
@@ -645,56 +646,56 @@ static int madvise_free_pte_range(pmd_t
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page || is_zone_device_page(page))
 			continue;
+		folio = page_folio(page);
 
 		/*
-		 * If pmd isn't transhuge but the page is THP and
+		 * If pmd isn't transhuge but the folio is large and
 		 * is owned by only this process, split it and
 		 * deactivate all pages.
 		 */
-		if (PageTransCompound(page)) {
-			if (page_mapcount(page) != 1)
+		if (folio_test_large(folio)) {
+			if (folio_mapcount(folio) != 1)
 				goto out;
-			get_page(page);
-			if (!trylock_page(page)) {
-				put_page(page);
+			folio_get(folio);
+			if (!folio_trylock(folio)) {
+				folio_put(folio);
 				goto out;
 			}
 			pte_unmap_unlock(orig_pte, ptl);
-			if (split_huge_page(page)) {
-				unlock_page(page);
-				put_page(page);
+			if (split_folio(folio)) {
+				folio_unlock(folio);
+				folio_put(folio);
 				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 				goto out;
 			}
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
 		}
 
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
-
-		if (PageSwapCache(page) || PageDirty(page)) {
-			if (!trylock_page(page))
+		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
+			if (!folio_trylock(folio))
 				continue;
 			/*
-			 * If page is shared with others, we couldn't clear
-			 * PG_dirty of the page.
+			 * If folio is shared with others, we mustn't clear
+			 * the folio's dirty flag.
 			 */
-			if (page_mapcount(page) != 1) {
-				unlock_page(page);
+			if (folio_mapcount(folio) != 1) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			if (PageSwapCache(page) && !try_to_free_swap(page)) {
-				unlock_page(page);
+			if (folio_test_swapcache(folio) &&
+			    !folio_free_swap(folio)) {
+				folio_unlock(folio);
 				continue;
 			}
 
-			ClearPageDirty(page);
-			unlock_page(page);
+			folio_clear_dirty(folio);
+			folio_unlock(folio);
 		}
 
 		if (pte_young(ptent) || pte_dirty(ptent)) {
@@ -712,7 +713,7 @@ static int madvise_free_pte_range(pmd_t
 			set_pte_at(mm, addr, pte, ptent);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 		}
-		mark_page_lazyfree(page);
+		mark_page_lazyfree(&folio->page);
 	}
 out:
 	if (nr_swap) {
_

Patches currently in -mm which might be from willy@infradead.org are


