Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0B4C43217
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380573AbiD2UOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380583AbiD2UOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D33A1A8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93E50B8377B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F662C385A4;
        Fri, 29 Apr 2022 20:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263045;
        bh=BipxhKsRSXSbqVwE5K+q8xLm5ixCFcNQUvRamgVehSc=;
        h=Date:To:From:Subject:From;
        b=EPagVoQf92TrQwrfqe5/N/7WJYt++RbpZ6YUb2AW9hYJe1xIBu5eSGIen+3hn9VVt
         dihc2mSagg007NQmwAM48sVT1NwQKnCXngg/eCyzsDOmBc//+zA8KT2cVSnrhL9h45
         WhSlhVpUFaS557o9lRPgvZo5yv/eLS8uYrIPqSLw=
Date:   Fri, 29 Apr 2022 13:10:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220429201045.4F662C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: convert shmem_alloc_and_acct_page to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch

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
Subject: mm/shmem: convert shmem_alloc_and_acct_page to use a folio

Convert shmem_alloc_hugepage() to return the folio that it uses and use a
folio throughout shmem_alloc_and_acct_page().  Continue to return a page
from shmem_alloc_and_acct_page() for now.

Link: https://lkml.kernel.org/r/20220429192329.3034378-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio
+++ a/mm/shmem.c
@@ -1523,7 +1523,7 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 	return result;
 }
 
-static struct page *shmem_alloc_hugepage(gfp_t gfp,
+static struct folio *shmem_alloc_hugefolio(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
@@ -1541,7 +1541,7 @@ static struct page *shmem_alloc_hugepage
 	shmem_pseudo_vma_destroy(&pvma);
 	if (!folio)
 		count_vm_event(THP_FILE_FALLBACK);
-	return &folio->page;
+	return folio;
 }
 
 static struct folio *shmem_alloc_folio(gfp_t gfp,
@@ -1562,7 +1562,7 @@ static struct page *shmem_alloc_and_acct
 		pgoff_t index, bool huge)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct page *page;
+	struct folio *folio;
 	int nr;
 	int err = -ENOSPC;
 
@@ -1574,13 +1574,13 @@ static struct page *shmem_alloc_and_acct
 		goto failed;
 
 	if (huge)
-		page = shmem_alloc_hugepage(gfp, info, index);
+		folio = shmem_alloc_hugefolio(gfp, info, index);
 	else
-		page = &shmem_alloc_folio(gfp, info, index)->page;
-	if (page) {
-		__SetPageLocked(page);
-		__SetPageSwapBacked(page);
-		return page;
+		folio = shmem_alloc_folio(gfp, info, index);
+	if (folio) {
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+		return &folio->page;
 	}
 
 	err = -ENOMEM;
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

