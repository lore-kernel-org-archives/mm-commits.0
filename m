Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E04C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383819AbiEMTYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383820AbiEMTXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8B33D1CC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11F57B83196
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C3FC34100;
        Fri, 13 May 2022 19:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469721;
        bh=DDVJZG/sAH1XW9Kkr7mTFWADXhU1feL4qf/WnG7kPNo=;
        h=Date:To:From:Subject:From;
        b=Dde9J8svccQVB8jnhDxT+fD4TQmb5ylNKwK6q4MRz7mKY2We5DLOwyeqaFw6Q1lIW
         fHXVA8d2AfpnHhcE2zCuyBh6Nr6sjNHq0bWI+RjzEEw+AzTxKmqTNsrN6HQHJV83RO
         25BpZDKu3I1m8QAkR6WjY4eC4GVdNsLnlapb2oUc=
Date:   Fri, 13 May 2022 12:22:01 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220513192201.96C3FC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: convert shmem_alloc_and_acct_page to use a folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: convert shmem_alloc_and_acct_page to use a folio

Convert shmem_alloc_hugepage() to return the folio that it uses and use a
folio throughout shmem_alloc_and_acct_page().  Continue to return a page
from shmem_alloc_and_acct_page() for now.

Link: https://lkml.kernel.org/r/20220504182857.4013401-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
@@ -1568,7 +1568,7 @@ static struct page *shmem_alloc_and_acct
 		pgoff_t index, bool huge)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct page *page;
+	struct folio *folio;
 	int nr;
 	int err = -ENOSPC;
 
@@ -1580,13 +1580,13 @@ static struct page *shmem_alloc_and_acct
 		goto failed;
 
 	if (huge)
-		page = shmem_alloc_hugepage(gfp, info, index);
+		folio = shmem_alloc_hugefolio(gfp, info, index);
 	else
-		page = shmem_alloc_page(gfp, info, index);
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

