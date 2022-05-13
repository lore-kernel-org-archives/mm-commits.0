Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D24AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383836AbiEMTYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383842AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ADB3C4AA
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 271AB62263
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E29C34100;
        Fri, 13 May 2022 19:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469716;
        bh=SYy9upIPdQjTiPFcfG0cW+HlHmffEv7auz9D37OYyKM=;
        h=Date:To:From:Subject:From;
        b=2AvT252g0qPTzlk2F1UzMk+tzG+N7mu/bZGKGoQ7KdAwgZ1uZi/EtHx4irLpdkiof
         VQ+pVfUOFyUMUMAuT4NEyscNc6OFuoS8i/eKx17/uRxX1t1WUUBZnfxlJnnf0cfO5u
         o5g3+ncHYB5bribSAmIPPpd4C4Oa8OxohzIXahNs=
Date:   Fri, 13 May 2022 12:21:55 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch removed from -mm tree
Message-Id: <20220513192156.81E29C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: use a folio in shmem_unused_huge_shrink
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: use a folio in shmem_unused_huge_shrink

When calling split_huge_page() we usually have to find the precise page,
but that's not necessary here because we only need to unlock and put the
folio afterwards.  Saves 231 bytes of text (20% of this function).

Link: https://lkml.kernel.org/r/20220504182857.4013401-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-a-folio-in-shmem_unused_huge_shrink
+++ a/mm/shmem.c
@@ -554,7 +554,7 @@ static unsigned long shmem_unused_huge_s
 	LIST_HEAD(to_remove);
 	struct inode *inode;
 	struct shmem_inode_info *info;
-	struct page *page;
+	struct folio *folio;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
 	int split = 0;
 
@@ -598,6 +598,7 @@ next:
 
 	list_for_each_safe(pos, next, &list) {
 		int ret;
+		pgoff_t index;
 
 		info = list_entry(pos, struct shmem_inode_info, shrinklist);
 		inode = &info->vfs_inode;
@@ -605,14 +606,14 @@ next:
 		if (nr_to_split && split >= nr_to_split)
 			goto move_back;
 
-		page = find_get_page(inode->i_mapping,
-				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
-		if (!page)
+		index = (inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT;
+		folio = filemap_get_folio(inode->i_mapping, index);
+		if (!folio)
 			goto drop;
 
 		/* No huge page at the end of the file: nothing to split */
-		if (!PageTransHuge(page)) {
-			put_page(page);
+		if (!folio_test_large(folio)) {
+			folio_put(folio);
 			goto drop;
 		}
 
@@ -623,14 +624,14 @@ next:
 		 * Waiting for the lock may lead to deadlock in the
 		 * reclaim path.
 		 */
-		if (!trylock_page(page)) {
-			put_page(page);
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			goto move_back;
 		}
 
-		ret = split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
+		ret = split_huge_page(&folio->page);
+		folio_unlock(folio);
+		folio_put(folio);
 
 		/* If split failed move the inode on the list back to shrinklist */
 		if (ret)
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

