Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9ADC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiD2UNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380539AbiD2UNc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F6C6358
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 433C061BED
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92590C385A4;
        Fri, 29 Apr 2022 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263009;
        bh=IccOC1fsiw44kEOft7QDM4w45u6IgOrfuYkm7Erp9Zs=;
        h=Date:To:From:Subject:From;
        b=ZHnYzTxeQ5oK7U1weUo20kac4FGQMmfWkC8SuS9bNQEZIqd0N+pxfP8kHa2T3h3Et
         nJNlqAh7odSAXSTpkrf3RMM1x4xuUhJcOY1fUMqFckuo3Gajvg9AIK1UTM5pfyC/DT
         kQ4JB9lmaXozMX4NHZqcTgAAy6b5KqIA+Tu1RE7s=
Date:   Fri, 29 Apr 2022 13:10:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch added to mm-unstable branch
Message-Id: <20220429201009.92590C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: convert shmem_alloc_hugepage() to use vma_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch

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
Subject: shmem: convert shmem_alloc_hugepage() to use vma_alloc_folio()

Patch series "Folio patches for 5.19".

 - Finish the conversion from alloc_pages_vma() to vma_alloc_folio()
 - Finish converting shrink_page_list() to folios
 - Start converting shmem from pages to folios (alas, not finished,
   I have simply run out of time with all the debugging/fixing needed
   for 5.18)


This patch (of 21):

For now, return the head page of the folio, but remove use of the old
alloc_pages_vma() API.

Link: https://lkml.kernel.org/r/20220429192329.3034378-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20220429192329.3034378-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio
+++ a/mm/shmem.c
@@ -1528,7 +1528,7 @@ static struct page *shmem_alloc_hugepage
 	struct vm_area_struct pvma;
 	struct address_space *mapping = info->vfs_inode.i_mapping;
 	pgoff_t hindex;
-	struct page *page;
+	struct folio *folio;
 
 	hindex = round_down(index, HPAGE_PMD_NR);
 	if (xa_find(&mapping->i_pages, &hindex, hindex + HPAGE_PMD_NR - 1,
@@ -1536,13 +1536,11 @@ static struct page *shmem_alloc_hugepage
 		return NULL;
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
-	page = alloc_pages_vma(gfp, HPAGE_PMD_ORDER, &pvma, 0, true);
+	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, &pvma, 0, true);
 	shmem_pseudo_vma_destroy(&pvma);
-	if (page)
-		prep_transhuge_page(page);
-	else
+	if (!folio)
 		count_vm_event(THP_FILE_FALLBACK);
-	return page;
+	return &folio->page;
 }
 
 static struct page *shmem_alloc_page(gfp_t gfp,
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

