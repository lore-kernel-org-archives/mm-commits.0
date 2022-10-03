Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AD0C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJCVGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27971A048
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB8846118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19919C433C1;
        Mon,  3 Oct 2022 21:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831117;
        bh=RkEdf0rCmTQDBbThcvxrKGgx81vGAiuZNyzLPeQ6NPU=;
        h=Date:To:From:Subject:From;
        b=GUXQCQIetgTajNxxge/90F8LPhyWyD3tZzap92AyxNJZWD8Hz14GXt5pBIIID6RnU
         2dEauGtqjykuDXN0OZtj4jamf6EuF8mr/ulns2pnU9juxamuzZua5xsf3tDe+L+JZW
         gFBuwt7s8wfvwUSLiUKPV8ARBrNE+LJV+mhwyCT4=
Date:   Mon, 03 Oct 2022 14:05:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swapfile-convert-unuse_pte_range-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210517.19919C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swapfile: convert unuse_pte_range() to use a folio
has been removed from the -mm tree.  Its filename was
     swapfile-convert-unuse_pte_range-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swapfile: convert unuse_pte_range() to use a folio
Date: Fri, 2 Sep 2022 20:46:32 +0100

Delay fetching the precise page from the folio until we're in unuse_pte().
Saves many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-37-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~swapfile-convert-unuse_pte_range-to-use-a-folio
+++ a/mm/swapfile.c
@@ -1758,8 +1758,9 @@ static inline int pte_same_as_swp(pte_t
  * force COW, vm_page_prot omits write permission from any private vma.
  */
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, swp_entry_t entry, struct page *page)
+		unsigned long addr, swp_entry_t entry, struct folio *folio)
 {
+	struct page *page = folio_file_page(folio, swp_offset(entry));
 	struct page *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte;
@@ -1831,17 +1832,18 @@ static int unuse_pte_range(struct vm_are
 			unsigned long addr, unsigned long end,
 			unsigned int type)
 {
-	struct page *page;
 	swp_entry_t entry;
 	pte_t *pte;
 	struct swap_info_struct *si;
-	unsigned long offset;
 	int ret = 0;
 	volatile unsigned char *swap_map;
 
 	si = swap_info[type];
 	pte = pte_offset_map(pmd, addr);
 	do {
+		struct folio *folio;
+		unsigned long offset;
+
 		if (!is_swap_pte(*pte))
 			continue;
 
@@ -1852,8 +1854,9 @@ static int unuse_pte_range(struct vm_are
 		offset = swp_offset(entry);
 		pte_unmap(pte);
 		swap_map = &si->swap_map[offset];
-		page = lookup_swap_cache(entry, vma, addr);
-		if (!page) {
+		folio = swap_cache_get_folio(entry, vma, addr);
+		if (!folio) {
+			struct page *page;
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
@@ -1863,25 +1866,27 @@ static int unuse_pte_range(struct vm_are
 
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						&vmf);
+			if (page)
+				folio = page_folio(page);
 		}
-		if (!page) {
+		if (!folio) {
 			if (*swap_map == 0 || *swap_map == SWAP_MAP_BAD)
 				goto try_next;
 			return -ENOMEM;
 		}
 
-		lock_page(page);
-		wait_on_page_writeback(page);
-		ret = unuse_pte(vma, pmd, addr, entry, page);
+		folio_lock(folio);
+		folio_wait_writeback(folio);
+		ret = unuse_pte(vma, pmd, addr, entry, folio);
 		if (ret < 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			goto out;
 		}
 
-		try_to_free_swap(page);
-		unlock_page(page);
-		put_page(page);
+		folio_free_swap(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 try_next:
 		pte = pte_offset_map(pmd, addr);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
_

Patches currently in -mm which might be from willy@infradead.org are


