Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAF9C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380537AbiD2UNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380541AbiD2UNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13286DFCE
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 907F0B8377B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43181C385A4;
        Fri, 29 Apr 2022 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263017;
        bh=xbJzC6e1eiZJoFCcBqHZZ2sZDG8ElK9E7L6vjRcP5AY=;
        h=Date:To:From:Subject:From;
        b=prXWOgpODMhAEIkrwrTHMYqdiBbCtBaR1n8za95vQxHTdsQE95NyIQfVXtrN3jdDv
         E4aJrzuukMWEJNEoasa+pCBDleDxdBzp5BhloQ2Q+r4GSxJ35h1UTK3o88dRrkL2AO
         5mXuxcoNi9skBY17cRqNp1O7eapvaE0RbHbCPodw=
Date:   Fri, 29 Apr 2022 13:10:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch added to mm-unstable branch
Message-Id: <20220429201017.43181C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: convert the writeback handling in shrink_page_list() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch

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
Subject: vmscan: convert the writeback handling in shrink_page_list() to folios

Slightly more efficient due to fewer calls to compound_head().

Link: https://lkml.kernel.org/r/20220429192329.3034378-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   78 ++++++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

--- a/mm/vmscan.c~vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios
+++ a/mm/vmscan.c
@@ -1598,40 +1598,42 @@ retry:
 			stat->nr_congested += nr_pages;
 
 		/*
-		 * If a page at the tail of the LRU is under writeback, there
+		 * If a folio at the tail of the LRU is under writeback, there
 		 * are three cases to consider.
 		 *
-		 * 1) If reclaim is encountering an excessive number of pages
-		 *    under writeback and this page is both under writeback and
-		 *    PageReclaim then it indicates that pages are being queued
-		 *    for IO but are being recycled through the LRU before the
-		 *    IO can complete. Waiting on the page itself risks an
-		 *    indefinite stall if it is impossible to writeback the
-		 *    page due to IO error or disconnected storage so instead
-		 *    note that the LRU is being scanned too quickly and the
-		 *    caller can stall after page list has been processed.
-		 *
-		 * 2) Global or new memcg reclaim encounters a page that is
+		 * 1) If reclaim is encountering an excessive number of folios
+		 *    under writeback and this folio is both under
+		 *    writeback and has the reclaim flag set then it
+		 *    indicates that folios are being queued for I/O but
+		 *    are being recycled through the LRU before the I/O
+		 *    can complete. Waiting on the folio itself risks an
+		 *    indefinite stall if it is impossible to writeback
+		 *    the folio due to I/O error or disconnected storage
+		 *    so instead note that the LRU is being scanned too
+		 *    quickly and the caller can stall after the folio
+		 *    list has been processed.
+		 #
+		 * 2) Global or new memcg reclaim encounters a folio that is
 		 *    not marked for immediate reclaim, or the caller does not
 		 *    have __GFP_FS (or __GFP_IO if it's simply going to swap,
-		 *    not to fs). In this case mark the page for immediate
+		 *    not to fs). In this case mark the folio for immediate
 		 *    reclaim and continue scanning.
 		 *
 		 *    Require may_enter_fs() because we would wait on fs, which
-		 *    may not have submitted IO yet. And the loop driver might
-		 *    enter reclaim, and deadlock if it waits on a page for
+		 *    may not have submitted I/O yet. And the loop driver might
+		 *    enter reclaim, and deadlock if it waits on a folio for
 		 *    which it is needed to do the write (loop masks off
 		 *    __GFP_IO|__GFP_FS for this reason); but more thought
 		 *    would probably show more reasons.
 		 *
-		 * 3) Legacy memcg encounters a page that is already marked
-		 *    PageReclaim. memcg does not have any dirty pages
+		 * 3) Legacy memcg encounters a folio that already has the
+		 *    reclaim flag set. memcg does not have any dirty folio
 		 *    throttling so we could easily OOM just because too many
-		 *    pages are in writeback and there is nothing else to
+		 *    folios are in writeback and there is nothing else to
 		 *    reclaim. Wait for the writeback to complete.
 		 *
-		 * In cases 1) and 2) we activate the pages to get them out of
-		 * the way while we continue scanning for clean pages on the
+		 * In cases 1) and 2) we activate the folios to get them out of
+		 * the way while we continue scanning for clean folios on the
 		 * inactive list and refilling from the active list. The
 		 * observation here is that waiting for disk writes is more
 		 * expensive than potentially causing reloads down the line.
@@ -1639,7 +1641,7 @@ retry:
 		 * memory pressure on the cache working set any longer than it
 		 * takes to write them to disk.
 		 */
-		if (PageWriteback(page)) {
+		if (folio_test_writeback(folio)) {
 			/* Case 1 above */
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
@@ -1649,28 +1651,32 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    !PageReclaim(page) || !may_enter_fs(page, sc->gfp_mask)) {
+			    !folio_test_reclaim(folio) ||
+			    !may_enter_fs(page, sc->gfp_mask)) {
 				/*
-				 * This is slightly racy - end_page_writeback()
-				 * might have just cleared PageReclaim, then
-				 * setting PageReclaim here end up interpreted
-				 * as PageReadahead - but that does not matter
-				 * enough to care.  What we do want is for this
-				 * page to have PageReclaim set next time memcg
-				 * reclaim reaches the tests above, so it will
-				 * then wait_on_page_writeback() to avoid OOM;
-				 * and it's also appropriate in global reclaim.
+				 * This is slightly racy -
+				 * folio_end_writeback() might have just
+				 * cleared the reclaim flag, then setting
+				 * reclaim here ends up interpreted as
+				 * the readahead flag - but that does
+				 * not matter enough to care.  What we
+				 * do want is for this folio to have
+				 * the reclaim flag set next time memcg
+				 * reclaim reaches the tests above, so
+				 * it will then folio_wait_writeback()
+				 * to avoid OOM; and it's also appropriate
+				 * in global reclaim.
 				 */
-				SetPageReclaim(page);
+				folio_set_reclaim(folio);
 				stat->nr_writeback += nr_pages;
 				goto activate_locked;
 
 			/* Case 3 above */
 			} else {
-				unlock_page(page);
-				wait_on_page_writeback(page);
-				/* then go back and try same page again */
-				list_add_tail(&page->lru, page_list);
+				folio_unlock(folio);
+				folio_wait_writeback(folio);
+				/* then go back and try same folio again */
+				list_add_tail(&folio->lru, page_list);
 				continue;
 			}
 		}
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
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
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

