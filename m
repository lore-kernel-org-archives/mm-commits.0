Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34E0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383850AbiEMTWh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383804AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE323B022
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D7BCCE3313
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0726BC34113;
        Fri, 13 May 2022 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469701;
        bh=hgzE/o9B3BhN2tHberhJh9a/QTaQtsu+LyxWfL9XvBY=;
        h=Date:To:From:Subject:From;
        b=LCggIbXezyZOn9Vuv0qLBMO4A3LO3QntTdEn8gyQyJkxm/awl0LmTwfzcF1z59hTb
         5carxBNmE9HIM8qlpPG9289BmS8njy4ntjAx4meb7zJJxFFaDqIZSYfOqwtP40ltWK
         nR2p1yJuinBH5D/c1oh0bUUBGr/R1czHYeDLy1u0=
Date:   Fri, 13 May 2022 12:21:40 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, hch@lst.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch removed from -mm tree
Message-Id: <20220513192141.0726BC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_alloc_hugepage() to use vma_alloc_folio()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_alloc_hugepage() to use vma_alloc_folio()

Patch series "Folio patches for 5.19", v2.


This patch (of 26):

For now, return the head page of the folio, but remove use of the old
alloc_pages_vma() API.

Link: https://lkml.kernel.org/r/20220504182857.4013401-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20220504182857.4013401-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

