Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACAAC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383847AbiEMTY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383814AbiEMTW6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883D732EC6
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C58CB83174
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9735DC34113;
        Fri, 13 May 2022 19:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469720;
        bh=2xJYnQt/WhQOqsdhlRjWd4t8UkoLc4tITLwMInpztwc=;
        h=Date:To:From:Subject:From;
        b=Te3YCrhUXMn+TKpyz726604q9UGFzgZ9d21XYl25Wof9pIJHrwVLxGVdGCHPosLbH
         yNR+dEit9hmfkPs5YGvNg7knkSU+j3Bdj2F8UJk1w8us4FPLTxEuRSMNVinJLwNoKt
         kVBVY5pR6Zy+nRyP6EyZ5UEnu/DInfLn+C8mk7RI=
Date:   Fri, 13 May 2022 12:22:00 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-shmem_alloc_folio.patch removed from -mm tree
Message-Id: <20220513192200.9735DC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: add shmem_alloc_folio()
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-shmem_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

