Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953E1C4321E
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387973AbiEFBhI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387977AbiEFBhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED7562A00
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E1FA6201F
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4614C385A4;
        Fri,  6 May 2022 01:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800799;
        bh=bTtfOSdmrw5Z8j1QRj7w1/UZn9ipbOGv/UPz24pSKW0=;
        h=Date:To:From:Subject:From;
        b=R8ORMGy2xzMyq6ZydkyXuM7UosLUn7n1ZWAEVi7a0KUkeUCIsZpMgM+bZJz1oji8p
         D3sBTDzttnZmouhxU4rcCMS614Dpp0RRB5+sOeYa0RDbMF2iaYU4hJ0uLIHRgklIao
         Az56EFG8JDpxWq3072iYXZ4smF8dd7sz0lruh0iY=
Date:   Thu, 05 May 2022 18:33:18 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-shmem_alloc_folio.patch added to mm-unstable branch
Message-Id: <20220506013318.E4614C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: add shmem_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-shmem_alloc_folio.patch

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
Subject: mm/shmem: add shmem_alloc_folio()

Call vma_alloc_folio() directly instead of alloc_page_vma().  Add a
shmem_alloc_page() wrapper to avoid changing the callers.

Link: https://lkml.kernel.org/r/20220504182857.4013401-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-shmem_alloc_folio
+++ a/mm/shmem.c
@@ -1544,17 +1544,23 @@ static struct page *shmem_alloc_hugepage
 	return &folio->page;
 }
 
-static struct page *shmem_alloc_page(gfp_t gfp,
+static struct folio *shmem_alloc_folio(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
-	struct page *page;
+	struct folio *folio;
 
 	shmem_pseudo_vma_init(&pvma, info, index);
-	page = alloc_page_vma(gfp, &pvma, 0);
+	folio = vma_alloc_folio(gfp, 0, &pvma, 0, false);
 	shmem_pseudo_vma_destroy(&pvma);
 
-	return page;
+	return folio;
+}
+
+static struct page *shmem_alloc_page(gfp_t gfp,
+			struct shmem_inode_info *info, pgoff_t index)
+{
+	return &shmem_alloc_folio(gfp, info, index)->page;
 }
 
 static struct page *shmem_alloc_and_acct_page(gfp_t gfp,
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

