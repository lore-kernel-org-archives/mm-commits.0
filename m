Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653ABC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383710AbiEMTWk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383814AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7EC33EB4
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C06A862245
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273D0C34113;
        Fri, 13 May 2022 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469705;
        bh=k8mA+rISScEJEiHvcbWwzc+bYkNhOF2hzon4MRuQ7K8=;
        h=Date:To:From:Subject:From;
        b=pnZv++TBSP/W5klbS6StHntUEYM7u50jM98CyvBfJGRivS+rEG1mwbKvuKpxfCKhl
         OfnIgmEsThR0OeuHlGyTDG88Ovl+pR8HjhMbjEVM5PocDjeIgqIElW/NMgVO6QyRvt
         K1NuSlafbymWNMMcSSX8IqDGR2lSkOx0b3DDpXuc=
Date:   Fri, 13 May 2022 12:21:44 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-use-folio_mapped-in-shrink_page_list.patch removed from -mm tree
Message-Id: <20220513192145.273D0C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: use folio_mapped() in shrink_page_list()
has been removed from the -mm tree.  Its filename was
     vmscan-use-folio_mapped-in-shrink_page_list.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: use folio_mapped() in shrink_page_list()

Remove some legacy function calls.

Link: https://lkml.kernel.org/r/20220504182857.4013401-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~vmscan-use-folio_mapped-in-shrink_page_list
+++ a/mm/vmscan.c
@@ -1572,7 +1572,7 @@ retry:
 		if (unlikely(!page_evictable(page)))
 			goto activate_locked;
 
-		if (!sc->may_unmap && page_mapped(page))
+		if (!sc->may_unmap && folio_mapped(folio))
 			goto keep_locked;
 
 		/*
@@ -1761,21 +1761,21 @@ retry:
 		}
 
 		/*
-		 * The page is mapped into the page tables of one or more
+		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (page_mapped(page)) {
+		if (folio_mapped(folio)) {
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = PageSwapBacked(page);
+			bool was_swapbacked = folio_test_swapbacked(folio);
 
-			if (PageTransHuge(page) &&
-					thp_order(page) >= HPAGE_PMD_ORDER)
+			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
 
 			try_to_unmap(folio, flags);
-			if (page_mapped(page)) {
+			if (folio_mapped(folio)) {
 				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked && PageSwapBacked(page))
+				if (!was_swapbacked &&
+				    folio_test_swapbacked(folio))
 					stat->nr_lazyfree_fail += nr_pages;
 				goto activate_locked;
 			}
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

