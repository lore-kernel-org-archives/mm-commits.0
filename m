Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF70C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382529AbiEMTWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383710AbiEMTWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90F3B3C4
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D35F46225E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F64C34100;
        Fri, 13 May 2022 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469706;
        bh=fiJxnM/0ko7gYyOl963sQnzsd6Zw4ZwmHxRjo6f5H4k=;
        h=Date:To:From:Subject:From;
        b=nnQuZ6zO57icqq/Mw5UFbs8g4dzrHw/OoaDzd5pDceJrFPwZhu792aXijfB+11ox1
         o37PWZokd5sCT0qBDBDtL+jzSXYrtFWqElGjhAc8ZY+MAjyYLQ1l/q+RDG39zifIEl
         51dvtZM/UMjoiIBC8vK4+q65xxeNkwA5AuVEcltY=
Date:   Fri, 13 May 2022 12:21:45 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch removed from -mm tree
Message-Id: <20220513192146.38F64C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: convert the writeback handling in shrink_page_list() to folios
has been removed from the -mm tree.  Its filename was
     vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: convert the writeback handling in shrink_page_list() to folios

Slightly more efficient due to fewer calls to compound_head().

Link: https://lkml.kernel.org/r/20220504182857.4013401-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 		 *
-		 * 2) Global or new memcg reclaim encounters a page that is
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
@@ -1639,38 +1641,42 @@ retry:
 		 * memory pressure on the cache working set any longer than it
 		 * takes to write them to disk.
 		 */
-		if (PageWriteback(page)) {
+		if (folio_test_writeback(folio)) {
 			/* Case 1 above */
 			if (current_is_kswapd() &&
-			    PageReclaim(page) &&
+			    folio_test_reclaim(folio) &&
 			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
 				stat->nr_immediate += nr_pages;
 				goto activate_locked;
 
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

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

