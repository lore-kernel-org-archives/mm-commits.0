Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BB1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380563AbiD2UOQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380551AbiD2UNr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9D314011
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC21B8377B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02462C385A4;
        Fri, 29 Apr 2022 20:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263025;
        bh=KxnoGtYupBjLfMEuqBZzx5X14GIb2SRjjP/e/xI/dQw=;
        h=Date:To:From:Subject:From;
        b=poKP6kMKxNv5wCCOrjPWpP2xvgr/A5JMgMXEuxuVBA7gjQT7m+9ertblwK2PeH0uj
         Enh0uriOSiKuvDVVFIIJ/1Y/HJnka0Z6nwRCwIs1hOqCkJl/af3VbVpRX94lQn6+i5
         yTz32hy85oozyEmtDVmYfZ0G7bTocpWguoL57Gd0=
Date:   Fri, 29 Apr 2022 13:10:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-dirty-page-handling-to-folios.patch added to mm-unstable branch
Message-Id: <20220429201025.02462C385A4@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/20220429192329.3034378-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

