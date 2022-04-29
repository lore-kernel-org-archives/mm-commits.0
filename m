Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175EFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380540AbiD2UNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380537AbiD2UNf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5616361
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A72CDB83792
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6627FC385AD;
        Fri, 29 Apr 2022 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263011;
        bh=NL5vzewuAhidStvCvJVdxdMP+ebfHopqsEK+dUMk+FI=;
        h=Date:To:From:Subject:From;
        b=h6mbffbggfZIdRl4PHSc2cdsZw+L2Cm5z+fXGpQl/1Z3nJzXHmThoz8orQKPB5yob
         QeTxVs8MZP4awwd1/lq4VPXXKfXEnN3HQKLlHLzqCI1+GXWKXynulQEGsCe7gl2u2H
         XFQts/G3w3nPo6nzAcoty3Urmvav7ZNXtKupSG4c=
Date:   Fri, 29 Apr 2022 13:10:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch added to mm-unstable branch
Message-Id: <20220429201011.6627FC385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: convert do_huge_pmd_anonymous_page() to use vma_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch

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
Subject: mm/huge_memory: convert do_huge_pmd_anonymous_page() to use vma_alloc_folio()

Remove the use of this old API, eliminating a call to
prep_transhuge_page().

Link: https://lkml.kernel.org/r/20220429192329.3034378-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio
+++ a/mm/huge_memory.c
@@ -726,7 +726,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 {
 	struct vm_area_struct *vma = vmf->vma;
 	gfp_t gfp;
-	struct page *page;
+	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
@@ -775,13 +775,12 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		return ret;
 	}
 	gfp = vma_thp_gfp_mask(vma);
-	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
-	if (unlikely(!page)) {
+	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
+	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	prep_transhuge_page(page);
-	return __do_huge_pmd_anonymous_page(vmf, page, gfp);
+	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
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

