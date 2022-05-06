Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B9EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387951AbiEFBhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387960AbiEFBgt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C051261616
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B1C9B82E5D
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A5BC385A4;
        Fri,  6 May 2022 01:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800786;
        bh=5OLDG8MwAm1apZB9s8etcJgeZJWiWYEmEs2kyKnmkoA=;
        h=Date:To:From:Subject:From;
        b=lBXMawelPsaoo3yLkVW1/N7YO7E/goSxPrtJT0+DeeCB+uKk2J4sO6750WM+/uIUJ
         IzjOIuxB6qs5eWqnM+5vBgTcTXj6iigb5DkkNZD1Lnea8QX/0j14oxnsqkG3gTJ4eU
         3W5K6fCpSrEX5wQzXdoLJmm4FVSZCczdHZwTb+5w=
Date:   Thu, 05 May 2022 18:33:05 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch added to mm-unstable branch
Message-Id: <20220506013306.30A5BC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: convert the activate_locked portion of shrink_page_list to folios
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch

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
Subject: vmscan: convert the activate_locked portion of shrink_page_list to folios

This accounts the number of pages activated correctly for large folios.

Link: https://lkml.kernel.org/r/20220504182857.4013401-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios
+++ a/mm/vmscan.c
@@ -1946,15 +1946,16 @@ activate_locked_split:
 		}
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
-		if (PageSwapCache(page) && (mem_cgroup_swap_full(page) ||
-						PageMlocked(page)))
-			try_to_free_swap(page);
-		VM_BUG_ON_PAGE(PageActive(page), page);
-		if (!PageMlocked(page)) {
-			int type = page_is_file_lru(page);
-			SetPageActive(page);
+		if (folio_test_swapcache(folio) &&
+		    (mem_cgroup_swap_full(&folio->page) ||
+		     folio_test_mlocked(folio)))
+			try_to_free_swap(&folio->page);
+		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+		if (!folio_test_mlocked(folio)) {
+			int type = folio_is_file_lru(folio);
+			folio_set_active(folio);
 			stat->nr_activate[type] += nr_pages;
-			count_memcg_page_event(page, PGACTIVATE);
+			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
 		}
 keep_locked:
 		unlock_page(page);
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

