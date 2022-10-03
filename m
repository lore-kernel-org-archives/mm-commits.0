Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB6FC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJCVHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJCVFs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E71AD89
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF8C3B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89164C433C1;
        Mon,  3 Oct 2022 21:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831119;
        bh=N2R3dkX6AfwGxv2whPFJWHi8SFu0RNHtmRHKFmB38Pc=;
        h=Date:To:From:Subject:From;
        b=YjU8BhsHnLH7CJs7hzgtTWtceCgki5hoTovOdKU9CLHzskGEmq7BffayS3I0VCpyQ
         re22y1pogp/5dSiqqQUzYpCRy93p+kAoBWu4/GJDxpn96KfkWvRxuxgcWmsUmb9/rB
         aPItUPCiakr/eXsbzBGp3JTb07UHkXhYC8sEGA58=
Date:   Mon, 03 Oct 2022 14:05:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-lookup_swap_cache.patch removed from -mm tree
Message-Id: <20221003210519.89164C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove lookup_swap_cache()
has been removed from the -mm tree.  Its filename was
     mm-remove-lookup_swap_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove lookup_swap_cache()
Date: Fri, 2 Sep 2022 20:46:34 +0100

All callers have now been converted to swap_cache_get_folio(), so we can
remove this wrapper.

Link: https://lkml.kernel.org/r/20220902194653.1739778-39-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/swap.h       |   10 ----------
 mm/swap_state.c |   12 +-----------
 3 files changed, 2 insertions(+), 22 deletions(-)

--- a/mm/memcontrol.c~mm-remove-lookup_swap_cache
+++ a/mm/memcontrol.c
@@ -5569,7 +5569,7 @@ static struct page *mc_handle_swap_pte(s
 		return NULL;
 
 	/*
-	 * Because lookup_swap_cache() updates some statistics counter,
+	 * Because swap_cache_get_folio() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
 	 */
 	page = find_get_page(swap_address_space(ent), swp_offset(ent));
--- a/mm/swap.h~mm-remove-lookup_swap_cache
+++ a/mm/swap.h
@@ -41,9 +41,6 @@ void clear_shadow_from_swap_cache(int ty
 				  unsigned long end);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
-struct page *lookup_swap_cache(swp_entry_t entry,
-			       struct vm_area_struct *vma,
-			       unsigned long addr);
 struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index);
 
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
@@ -106,13 +103,6 @@ static inline struct folio *swap_cache_g
 {
 	return NULL;
 }
-
-static inline struct page *lookup_swap_cache(swp_entry_t swp,
-					     struct vm_area_struct *vma,
-					     unsigned long addr)
-{
-	return NULL;
-}
 
 static inline
 struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
--- a/mm/swap_state.c~mm-remove-lookup_swap_cache
+++ a/mm/swap_state.c
@@ -369,16 +369,6 @@ struct folio *swap_cache_get_folio(swp_e
 	return folio;
 }
 
-struct page *lookup_swap_cache(swp_entry_t entry, struct vm_area_struct *vma,
-			       unsigned long addr)
-{
-	struct folio *folio = swap_cache_get_folio(entry, vma, addr);
-
-	if (!folio)
-		return NULL;
-	return folio_file_page(folio, swp_offset(entry));
-}
-
 /**
  * find_get_incore_page - Find and get a page from the page or swap caches.
  * @mapping: The address_space to search.
@@ -430,7 +420,7 @@ struct page *__read_swap_cache_async(swp
 		int err;
 		/*
 		 * First check the swap cache.  Since this is normally
-		 * called after lookup_swap_cache() failed, re-calling
+		 * called after swap_cache_get_folio() failed, re-calling
 		 * that would confuse statistics.
 		 */
 		si = get_swap_device(entry);
_

Patches currently in -mm which might be from willy@infradead.org are


