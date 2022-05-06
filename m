Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAB2C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387982AbiEFBhH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387970AbiEFBhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:37:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D81362129
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B82CB83211
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F087C385A8;
        Fri,  6 May 2022 01:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800791;
        bh=Js6HqKE3KFl3PcT+5iGhA5MwqcPG2h+3CehBfrnx4XY=;
        h=Date:To:From:Subject:From;
        b=gecJ7v018cHrHjxAqbsaEhHNDLQQQVHxUoDdbylzl33ZrGpvtTX+XCvSbuvTv74O3
         6X8HCdA/LKmeRBAu3qYex68YwRuOuNdD4vOg8RZfwUkvVGpKOK78sarpZiLw5PDUAH
         vJV32YS+7XHjvETy9nCJ1zN0QxoGy/r/v+p1/AsE=
Date:   Thu, 05 May 2022 18:33:11 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch added to mm-unstable branch
Message-Id: <20220506013311.9F087C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: use a folio in shmem_unused_huge_shrink
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch

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
Subject: mm/shmem: use a folio in shmem_unused_huge_shrink

When calling split_huge_page() we usually have to find the precise page,
but that's not necessary here because we only need to unlock and put the
folio afterwards.  Saves 231 bytes of text (20% of this function).

Link: https://lkml.kernel.org/r/20220504182857.4013401-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-a-folio-in-shmem_unused_huge_shrink
+++ a/mm/shmem.c
@@ -554,7 +554,7 @@ static unsigned long shmem_unused_huge_s
 	LIST_HEAD(to_remove);
 	struct inode *inode;
 	struct shmem_inode_info *info;
-	struct page *page;
+	struct folio *folio;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
 	int split = 0;
 
@@ -598,6 +598,7 @@ next:
 
 	list_for_each_safe(pos, next, &list) {
 		int ret;
+		pgoff_t index;
 
 		info = list_entry(pos, struct shmem_inode_info, shrinklist);
 		inode = &info->vfs_inode;
@@ -605,14 +606,14 @@ next:
 		if (nr_to_split && split >= nr_to_split)
 			goto move_back;
 
-		page = find_get_page(inode->i_mapping,
-				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
-		if (!page)
+		index = (inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT;
+		folio = filemap_get_folio(inode->i_mapping, index);
+		if (!folio)
 			goto drop;
 
 		/* No huge page at the end of the file: nothing to split */
-		if (!PageTransHuge(page)) {
-			put_page(page);
+		if (!folio_test_large(folio)) {
+			folio_put(folio);
 			goto drop;
 		}
 
@@ -623,14 +624,14 @@ next:
 		 * Waiting for the lock may lead to deadlock in the
 		 * reclaim path.
 		 */
-		if (!trylock_page(page)) {
-			put_page(page);
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			goto move_back;
 		}
 
-		ret = split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
+		ret = split_huge_page(&folio->page);
+		folio_unlock(folio);
+		folio_put(folio);
 
 		/* If split failed move the inode on the list back to shrinklist */
 		if (ret)
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

