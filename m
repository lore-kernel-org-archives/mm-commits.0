Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244B9C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiGDBMm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiGDBLP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7075E63FB
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11368B80CEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6F3C341C6;
        Mon,  4 Jul 2022 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897047;
        bh=iEiLo6lxrl1yhkemn2lvTI/MYiKiUTfqICLEAg61IfY=;
        h=Date:To:From:Subject:From;
        b=SG3jN4sWm2plYZ9bOE36ifs+npf3P/zlZMxbv4dPP+6xo78jQ9nz9xbCet7WAEkJL
         dFLafAMN8ydXqXxLfTji6YsH0mCSHFKzmbEhnHsDXhHw+j6STrC7Y11V8QmEN/c5FA
         LBS9YVFAix2V0AarsK6gDDiJSJJYfTIOqfsowhvg=
Date:   Sun, 03 Jul 2022 18:10:47 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch removed from -mm tree
Message-Id: <20220704011047.AD6F3C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: minor cleanup for swapin_walk_pmd_entry()
has been removed from the -mm tree.  Its filename was
     mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: minor cleanup for swapin_walk_pmd_entry()
Date: Sat, 18 Jun 2022 17:05:27 +0800

Passing index to pte_offset_map_lock() directly so the below calculation
can be avoided. Rename orig_pte to ptep as it's not changed. Also use
helper is_swap_pte() to improve the readability. No functional change
intended.

[akpm@linux-foundation.org: reduce scope of `ptep']
Link: https://lkml.kernel.org/r/20220618090527.37843-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry
+++ a/mm/madvise.c
@@ -195,7 +195,6 @@ success:
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *orig_pte;
 	struct vm_area_struct *vma = walk->private;
 	unsigned long index;
 	struct swap_iocb *splug = NULL;
@@ -208,12 +207,13 @@ static int swapin_walk_pmd_entry(pmd_t *
 		swp_entry_t entry;
 		struct page *page;
 		spinlock_t *ptl;
+		pte_t *ptep;
 
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

mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

