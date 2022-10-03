Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356FAC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJCVFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJCVFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C425F5B4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36DBB811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A461CC433B5;
        Mon,  3 Oct 2022 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831088;
        bh=36BhSnFeCJ5kJL2MyWTzehYmqNAMMyotTlLa5PjRzE4=;
        h=Date:To:From:Subject:From;
        b=MSX+Q1fCvH/UvqPt1yjG8PTWL/3FsugjT3ln5Y5de4w5qFPVutR9BS/knuYPBnPBF
         8RhNBFjalJo24ug5NeS8kQqGZl848B8wLxMYbBs50/TZ7Ihxe8KevRO1YJSHOZcD5R
         OaaWgVotcuPUmTrOUT4p/FxMMfJJGBH9QTreO8Cw=
Date:   Mon, 03 Oct 2022 14:04:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210448.A461CC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert __read_swap_cache_async() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert __read_swap_cache_async() to use a folio
Date: Fri, 2 Sep 2022 20:46:07 +0100

Remove a few hidden (and one visible) calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/swap_state.c~mm-swap-convert-__read_swap_cache_async-to-use-a-folio
+++ a/mm/swap_state.c
@@ -411,7 +411,7 @@ struct page *__read_swap_cache_async(swp
 			bool *new_page_allocated)
 {
 	struct swap_info_struct *si;
-	struct page *page;
+	struct folio *folio;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
@@ -426,11 +426,11 @@ struct page *__read_swap_cache_async(swp
 		si = get_swap_device(entry);
 		if (!si)
 			return NULL;
-		page = find_get_page(swap_address_space(entry),
-				     swp_offset(entry));
+		folio = filemap_get_folio(swap_address_space(entry),
+						swp_offset(entry));
 		put_swap_device(si);
-		if (page)
-			return page;
+		if (folio)
+			return folio_file_page(folio, swp_offset(entry));
 
 		/*
 		 * Just skip read ahead for unused swap slot.
@@ -448,8 +448,8 @@ struct page *__read_swap_cache_async(swp
 		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
 		 * cause any racers to loop around until we add it to cache.
 		 */
-		page = alloc_page_vma(gfp_mask, vma, addr);
-		if (!page)
+		folio = vma_alloc_folio(gfp_mask, 0, vma, addr, false);
+		if (!folio)
 			return NULL;
 
 		/*
@@ -459,7 +459,7 @@ struct page *__read_swap_cache_async(swp
 		if (!err)
 			break;
 
-		put_page(page);
+		folio_put(folio);
 		if (err != -EEXIST)
 			return NULL;
 
@@ -477,30 +477,30 @@ struct page *__read_swap_cache_async(swp
 	 * The swap entry is ours to swap in. Prepare the new page.
 	 */
 
-	__SetPageLocked(page);
-	__SetPageSwapBacked(page);
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
 
-	if (mem_cgroup_swapin_charge_page(page, NULL, gfp_mask, entry))
+	if (mem_cgroup_swapin_charge_page(&folio->page, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (add_to_swap_cache(&folio->page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	mem_cgroup_swapin_uncharge_swap(entry);
 
 	if (shadow)
-		workingset_refault(page_folio(page), shadow);
+		workingset_refault(folio, shadow);
 
-	/* Caller will initiate read into locked page */
-	lru_cache_add(page);
+	/* Caller will initiate read into locked folio */
+	folio_add_lru(folio);
 	*new_page_allocated = true;
-	return page;
+	return &folio->page;
 
 fail_unlock:
-	put_swap_page(page, entry);
-	unlock_page(page);
-	put_page(page);
+	put_swap_page(&folio->page, entry);
+	folio_unlock(folio);
+	folio_put(folio);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


