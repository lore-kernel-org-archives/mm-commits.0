Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE9EC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387956AbiEFBgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387955AbiEFBgd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848305D5C1
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 330ECB831CD
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7E6C385A8;
        Fri,  6 May 2022 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800769;
        bh=vPdW6sPeGPxs8c2viL5t9iQ+MfwWqIMNS6qk8D2welI=;
        h=Date:To:From:Subject:From;
        b=uywyw+v3/5XGq2iTalT6eWp8yzGl5kkQaLGuuoklVdFUigqLkXVrxF5wmZX6pQK7Z
         yMUAxbhjBnNBIuLEnC1izzChZ05jlF8EN3PA49DL0lKuBTncLQFd+YrdgAU9TGcx6i
         jvBnNQOn8lKm8Gy7qsRSb9GzteB+a5MFcjhL4USQ=
Date:   Thu, 05 May 2022 18:32:48 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-use-folio_mapped-in-shrink_page_list.patch added to mm-unstable branch
Message-Id: <20220506013248.DD7E6C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: use folio_mapped() in shrink_page_list()
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-use-folio_mapped-in-shrink_page_list.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: vmscan: use folio_mapped() in shrink_page_list()

Remove some legacy function calls.

Link: https://lkml.kernel.org/r/20220504182857.4013401-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~vmscan-use-folio_mapped-in-shrink_page_list
+++ a/mm/vmscan.c
@@ -1572,7 +1572,7 @@ retry:
 		if (unlikely(!page_evictable(page)))
 			goto activate_locked;
 
-		if (!sc->may_unmap && page_mapped(page))
+		if (!sc->may_unmap && folio_mapped(folio))
 			goto keep_locked;
 
 		/*
@@ -1761,21 +1761,21 @@ retry:
 		}
 
 		/*
-		 * The page is mapped into the page tables of one or more
+		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (page_mapped(page)) {
+		if (folio_mapped(folio)) {
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = PageSwapBacked(page);
+			bool was_swapbacked = folio_test_swapbacked(folio);
 
-			if (PageTransHuge(page) &&
-					thp_order(page) >= HPAGE_PMD_ORDER)
+			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
 
 			try_to_unmap(folio, flags);
-			if (page_mapped(page)) {
+			if (folio_mapped(folio)) {
 				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked && PageSwapBacked(page))
+				if (!was_swapbacked &&
+				    folio_test_swapbacked(folio))
 					stat->nr_lazyfree_fail += nr_pages;
 				goto activate_locked;
 			}
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

