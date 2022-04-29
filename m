Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C50C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380542AbiD2UNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380539AbiD2UNg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070B2B85C
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09AC060C8F
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62570C385A4;
        Fri, 29 Apr 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263015;
        bh=MGuMMxx9TK65S2s0Y+yjuo1lEnHRb45dnxrUqbRHyNk=;
        h=Date:To:From:Subject:From;
        b=W97AZF56x3wHvYQNmInMXTY5s93asByjpKnO5tATuN8fCpUYT+lUIoa68kM/G4Kip
         2vOYluwoT/7pg4KNmN5flOrvcAVVY7wq3u51CWkuFa4fzwFCmt/tvL9375knEYoKAr
         R5FQErTerP2qB8xuzH+mvUzBrUHMYuWKUZaKonHQ=
Date:   Fri, 29 Apr 2022 13:10:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-use-folio_mapped-in-shrink_page_list.patch added to mm-unstable branch
Message-Id: <20220429201015.62570C385A4@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/20220429192329.3034378-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

