Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380559AbiD2UOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380580AbiD2UOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2ACB85C
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4FC6168B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8647EC385A7;
        Fri, 29 Apr 2022 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263043;
        bh=D9OazdW3MTV3riqwYkjsxQEqZsm3UV+JV2xsw2qB6Q8=;
        h=Date:To:From:Subject:From;
        b=1AERuoi4fzrvU43IyZqETgPgfERGsIuCjH5+G3Jyo5gEINAFy6KVImy2dHHKUQa8M
         Jt4vm17rERoI5h/IzFTYZ+z41rBlOia17pzk4mtsih+8Tb47Ku/Tano1ua2M+V1/JM
         j+dLQnyYAR0GRxq4jCLsvFpF/OrAYmOqJa+pZ4mU=
Date:   Fri, 29 Apr 2022 13:10:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch added to mm-unstable branch
Message-Id: <20220429201043.8647EC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: turn shmem_alloc_page() into shmem_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch

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
Subject: mm/shmem: turn shmem_alloc_page() into shmem_alloc_folio()

Call vma_alloc_folio() directly instead of alloc_page_vma().  It's a bit
messy in the callers, but they're about to be cleaned up when they get
converted to folios.

Link: https://lkml.kernel.org/r/20220429192329.3034378-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio
+++ a/mm/shmem.c
@@ -1544,17 +1544,17 @@ static struct page *shmem_alloc_hugepage
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
 }
 
 static struct page *shmem_alloc_and_acct_page(gfp_t gfp,
@@ -1576,7 +1576,7 @@ static struct page *shmem_alloc_and_acct
 	if (huge)
 		page = shmem_alloc_hugepage(gfp, info, index);
 	else
-		page = shmem_alloc_page(gfp, info, index);
+		page = &shmem_alloc_folio(gfp, info, index)->page;
 	if (page) {
 		__SetPageLocked(page);
 		__SetPageSwapBacked(page);
@@ -1626,7 +1626,7 @@ static int shmem_replace_page(struct pag
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	newpage = shmem_alloc_page(gfp, info, index);
+	newpage = &shmem_alloc_folio(gfp, info, index)->page;
 	if (!newpage)
 		return -ENOMEM;
 
@@ -2351,7 +2351,6 @@ int shmem_mfill_atomic_pte(struct mm_str
 
 	if (!*pagep) {
 		ret = -ENOMEM;
-		page = shmem_alloc_page(gfp, info, pgoff);
 		if (!page)
 			goto out_unacct_blocks;
 
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

