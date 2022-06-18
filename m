Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C03C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 18 Jun 2022 18:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiFRS7S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 18 Jun 2022 14:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiFRS7R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 18 Jun 2022 14:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E705DF45
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 11:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F216760B4E
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 18:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C4C3411A;
        Sat, 18 Jun 2022 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655578755;
        bh=83a1Qqdsnl98NHP5WHYZmtuhmdJ30FzJA44J3FrNUIw=;
        h=Date:To:From:Subject:From;
        b=yRpykkvOKzELarc5pyzFTfBsylN8WX2hFnm5iDsRvZkUnQ8333OYh53cjBp9IY/kD
         e9ltowaNxv9fDigGesi81JBEjK7fKpYbxQgjpooANxJYrjGfXMbSz14Q91FNgZAoZk
         aNDRU64pMz8gcm8x9E4wbtB0pAD+y6WYjC9Jd4OM=
Date:   Sat, 18 Jun 2022 11:59:14 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch added to mm-unstable branch
Message-Id: <20220618185915.544C4C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: minor cleanup for swapin_walk_pmd_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

This patch will later appear in the mm-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: minor cleanup for swapin_walk_pmd_entry()
Date: Sat, 18 Jun 2022 17:05:27 +0800

Passing index to pte_offset_map_lock() directly so the below calculation
can be avoided. Rename orig_pte to ptep as it's not changed. Also use
helper is_swap_pte() to improve the readability. No functional change
intended.

Link: https://lkml.kernel.org/r/20220618090527.37843-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry
+++ a/mm/madvise.c
@@ -195,7 +195,7 @@ success:
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *orig_pte;
+	pte_t *ptep;
 	struct vm_area_struct *vma = walk->private;
 	unsigned long index;
 	struct swap_iocb *splug = NULL;
@@ -209,11 +209,11 @@ static int swapin_walk_pmd_entry(pmd_t *
 		struct page *page;
 		spinlock_t *ptl;
 
-		orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
-		pte_unmap_unlock(orig_pte, ptl);
+		ptep = pte_offset_map_lock(vma->vm_mm, pmd, index, &ptl);
+		pte = *ptep;
+		pte_unmap_unlock(ptep, ptl);
 
-		if (pte_present(pte) || pte_none(pte))
+		if (!is_swap_pte(pte))
 			continue;
 		entry = pte_to_swp_entry(pte);
 		if (unlikely(non_swap_entry(entry)))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

