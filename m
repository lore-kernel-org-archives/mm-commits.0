Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B561C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387953AbiEFBgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387951AbiEFBgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE195D5C1
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 268C76201E
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F33C385A4;
        Fri,  6 May 2022 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800778;
        bh=ciOcn+ygy4D3PrR+7cdgAn85ofTxC0LoHPQDlnR2Ai8=;
        h=Date:To:From:Subject:From;
        b=YUVugC1Y8iNR7Op0NuusdvJJXCGqODUj2oqRELyIy/iTFRfqGz8hMfOqcd5/Z5Qms
         3SKMDE2N8NfDtk+T0D45d50GvLe+hG0x9rDGjULVZ00WS5dwlkSmLlbuuaJWT49b4l
         rF80qNWxk0WYdpj7NkE1t7AkaJTUNV5sCv5fsXeo=
Date:   Thu, 05 May 2022 18:32:57 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-dirty-page-handling-to-folios.patch added to mm-unstable branch
Message-Id: <20220506013258.79F33C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: convert dirty page handling to folios
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-convert-dirty-page-handling-to-folios.patch

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
Subject: vmscan: convert dirty page handling to folios

Mostly this just eliminates calls to compound_head(), but
NR_VMSCAN_IMMEDIATE was being incremented by 1 instead of by nr_pages.

Link: https://lkml.kernel.org/r/20220504182857.4013401-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c~vmscan-convert-dirty-page-handling-to-folios
+++ a/mm/vmscan.c
@@ -1787,28 +1787,31 @@ retry:
 			}
 		}
 
-		if (PageDirty(page)) {
+		if (folio_test_dirty(folio)) {
 			/*
-			 * Only kswapd can writeback filesystem pages
+			 * Only kswapd can writeback filesystem folios
 			 * to avoid risk of stack overflow. But avoid
-			 * injecting inefficient single-page IO into
+			 * injecting inefficient single-folio I/O into
 			 * flusher writeback as much as possible: only
-			 * write pages when we've encountered many
-			 * dirty pages, and when we've already scanned
-			 * the rest of the LRU for clean pages and see
-			 * the same dirty pages again (PageReclaim).
+			 * write folios when we've encountered many
+			 * dirty folios, and when we've already scanned
+			 * the rest of the LRU for clean folios and see
+			 * the same dirty folios again (with the reclaim
+			 * flag set).
 			 */
-			if (page_is_file_lru(page) &&
-			    (!current_is_kswapd() || !PageReclaim(page) ||
+			if (folio_is_file_lru(folio) &&
+			    (!current_is_kswapd() ||
+			     !folio_test_reclaim(folio) ||
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
-				 * Similar in principal to deactivate_page()
-				 * except we already have the page isolated
+				 * Similar in principle to deactivate_page()
+				 * except we already have the folio isolated
 				 * and know it's dirty
 				 */
-				inc_node_page_state(page, NR_VMSCAN_IMMEDIATE);
-				SetPageReclaim(page);
+				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
+						nr_pages);
+				folio_set_reclaim(folio);
 
 				goto activate_locked;
 			}
@@ -1821,8 +1824,8 @@ retry:
 				goto keep_locked;
 
 			/*
-			 * Page is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after IO
+			 * Folio is dirty. Flush the TLB if a writable entry
+			 * potentially exists to avoid CPU writes after I/O
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
@@ -1834,23 +1837,24 @@ retry:
 			case PAGE_SUCCESS:
 				stat->nr_pageout += nr_pages;
 
-				if (PageWriteback(page))
+				if (folio_test_writeback(folio))
 					goto keep;
-				if (PageDirty(page))
+				if (folio_test_dirty(folio))
 					goto keep;
 
 				/*
 				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the page.
+				 * ahead and try to reclaim the folio.
 				 */
-				if (!trylock_page(page))
+				if (!folio_trylock(folio))
 					goto keep;
-				if (PageDirty(page) || PageWriteback(page))
+				if (folio_test_dirty(folio) ||
+				    folio_test_writeback(folio))
 					goto keep_locked;
-				mapping = page_mapping(page);
+				mapping = folio_mapping(folio);
 				fallthrough;
 			case PAGE_CLEAN:
-				; /* try to free the page below */
+				; /* try to free the folio below */
 			}
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

