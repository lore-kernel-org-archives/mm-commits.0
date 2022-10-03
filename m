Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB40C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJCVF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJCVFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0046111C25
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911DF610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6758C433D6;
        Mon,  3 Oct 2022 21:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831098;
        bh=fzh6vX4QwHfxXq245G5cOBy1qfT58DrUD8GGQ9BFqxo=;
        h=Date:To:From:Subject:From;
        b=O4c0pQ2dydylBAvU9ClnEbPUKNO8w/ZI1884PEHrQx94PAhbyXhRqPOiRsBp01rFO
         smYAkSiYtTH84DaOoND3ZfqmLIkU8kWAAHSdWvEZmVoUOTMtbwdiL5pLpqCGgegXvw
         8vfVEdjXYajOb1T+rRqtfHSO9b/t3U/1rOadTdR8=
Date:   Mon, 03 Oct 2022 14:04:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-add-swap_cache_get_folio.patch removed from -mm tree
Message-Id: <20221003210457.E6758C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: add swap_cache_get_folio()
has been removed from the -mm tree.  Its filename was
     swap-add-swap_cache_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: add swap_cache_get_folio()
Date: Fri, 2 Sep 2022 20:46:15 +0100

Convert lookup_swap_cache() into swap_cache_get_folio() and add a
lookup_swap_cache() wrapper around it.

[akpm@linux-foundation.org: add CONFIG_SWAP=n stub for swap_cache_get_folio()]
Link: https://lkml.kernel.org/r/20220902194653.1739778-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    8 ++++++++
 mm/swap_state.c |   32 +++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 11 deletions(-)

--- a/mm/swap.h~swap-add-swap_cache_get_folio
+++ a/mm/swap.h
@@ -39,6 +39,8 @@ void __delete_from_swap_cache(struct fol
 void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
+struct folio *swap_cache_get_folio(swp_entry_t entry,
+		struct vm_area_struct *vma, unsigned long addr);
 struct page *lookup_swap_cache(swp_entry_t entry,
 			       struct vm_area_struct *vma,
 			       unsigned long addr);
@@ -99,6 +101,12 @@ static inline int swap_writepage(struct
 	return 0;
 }
 
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct page *lookup_swap_cache(swp_entry_t swp,
 					     struct vm_area_struct *vma,
 					     unsigned long addr)
--- a/mm/swap_state.c~swap-add-swap_cache_get_folio
+++ a/mm/swap_state.c
@@ -317,24 +317,24 @@ static inline bool swap_use_vma_readahea
 }
 
 /*
- * Lookup a swap entry in the swap cache. A found page will be returned
+ * Lookup a swap entry in the swap cache. A found folio will be returned
  * unlocked and with its refcount incremented - we rely on the kernel
- * lock getting page table operations atomic even if we drop the page
+ * lock getting page table operations atomic even if we drop the folio
  * lock before returning.
  */
-struct page *lookup_swap_cache(swp_entry_t entry, struct vm_area_struct *vma,
-			       unsigned long addr)
+struct folio *swap_cache_get_folio(swp_entry_t entry,
+		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page;
+	struct folio *folio;
 	struct swap_info_struct *si;
 
 	si = get_swap_device(entry);
 	if (!si)
 		return NULL;
-	page = find_get_page(swap_address_space(entry), swp_offset(entry));
+	folio = filemap_get_folio(swap_address_space(entry), swp_offset(entry));
 	put_swap_device(si);
 
-	if (page) {
+	if (folio) {
 		bool vma_ra = swap_use_vma_readahead();
 		bool readahead;
 
@@ -342,10 +342,10 @@ struct page *lookup_swap_cache(swp_entry
 		 * At the moment, we don't support PG_readahead for anon THP
 		 * so let's bail out rather than confusing the readahead stat.
 		 */
-		if (unlikely(PageTransCompound(page)))
-			return page;
+		if (unlikely(folio_test_large(folio)))
+			return folio;
 
-		readahead = TestClearPageReadahead(page);
+		readahead = folio_test_clear_readahead(folio);
 		if (vma && vma_ra) {
 			unsigned long ra_val;
 			int win, hits;
@@ -366,7 +366,17 @@ struct page *lookup_swap_cache(swp_entry
 		}
 	}
 
-	return page;
+	return folio;
+}
+
+struct page *lookup_swap_cache(swp_entry_t entry, struct vm_area_struct *vma,
+			       unsigned long addr)
+{
+	struct folio *folio = swap_cache_get_folio(entry, vma, addr);
+
+	if (!folio)
+		return NULL;
+	return folio_file_page(folio, swp_offset(entry));
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


