Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5992AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380557AbiD2UOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380562AbiD2UOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D415A08
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D741B83792
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD38C385A4;
        Fri, 29 Apr 2022 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263030;
        bh=W2PHX/G5e8CtkJQl9xL/gy5ha3pfmrfrwb00Gmw8+EA=;
        h=Date:To:From:Subject:From;
        b=vP+LFJ2VL+oBcBsnCLnutN6KLeOnE3KPoQ9xOFzexStxOGpKc3HaxQKqRLf9fJCl+
         fIKf7xt97+WR3D+pazWz9ivxRPJ6HpNKwu/bRTdQWOudmuPOG48q0Ha1/WGLRzAzC5
         L6i5pMLZImBIBTOG9YM8y7LBYzZmX7l1bY6gEwJg=
Date:   Fri, 29 Apr 2022 13:10:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-move-initialisation-of-mapping-down.patch added to mm-unstable branch
Message-Id: <20220429201030.BAD38C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: move initialisation of mapping down
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-move-initialisation-of-mapping-down.patch

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
Subject: vmscan: move initialisation of mapping down

Now that we don't interrogate the BDI for congestion, we can delay looking
up the folio's mapping until we've got further through the function,
reducing register pressure and saving a call to folio_mapping for folios
we're adding to the swap cache.

Link: https://lkml.kernel.org/r/20220429192329.3034378-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~vmscan-move-initialisation-of-mapping-down
+++ a/mm/vmscan.c
@@ -1588,12 +1588,11 @@ retry:
 			stat->nr_unqueued_dirty += nr_pages;
 
 		/*
-		 * Treat this page as congested if the underlying BDI is or if
+		 * Treat this page as congested if
 		 * pages are cycling through the LRU so quickly that the
 		 * pages marked for immediate reclaim are making it to the
 		 * end of the LRU a second time.
 		 */
-		mapping = page_mapping(page);
 		if (writeback && PageReclaim(page))
 			stat->nr_congested += nr_pages;
 
@@ -1744,9 +1743,6 @@ retry:
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
 				}
-
-				/* Adding to swap updated mapping */
-				mapping = page_mapping(page);
 			}
 		} else if (PageSwapBacked(page) && PageTransHuge(page)) {
 			/* Split shmem THP */
@@ -1787,6 +1783,7 @@ retry:
 			}
 		}
 
+		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			/*
 			 * Only kswapd can writeback filesystem folios
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

