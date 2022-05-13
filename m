Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A94C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383746AbiEMTXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383749AbiEMTWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191133206F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C429EB83174
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75278C34100;
        Fri, 13 May 2022 19:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469712;
        bh=yZAfz4mCF/vbWr18y2D6CLflgzKYnrIYMUYDM/ytWdw=;
        h=Date:To:From:Subject:From;
        b=ACY47QNCclyQ2NB4KuH4FBtRfLRQrCPDhHffeCJ7e72q5lMeBugByOBT0Cj2jw9Bz
         /9KwpfTmuZckmJ0PgapSEX37rYSUjP/fZDWcr+CtTKjsQRYe+NMmx0xOfJLJZN0t/+
         5EMyMc5ROoE/uPfPI6PSj5TyUiYp30nn5Ca6GPvQ=
Date:   Fri, 13 May 2022 12:21:51 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-move-initialisation-of-mapping-down.patch removed from -mm tree
Message-Id: <20220513192152.75278C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: move initialisation of mapping down
has been removed from the -mm tree.  Its filename was
     vmscan-move-initialisation-of-mapping-down.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: move initialisation of mapping down

Now that we don't interrogate the BDI for congestion, we can delay looking
up the folio's mapping until we've got further through the function,
reducing register pressure and saving a call to folio_mapping for folios
we're adding to the swap cache.

Link: https://lkml.kernel.org/r/20220504182857.4013401-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~vmscan-move-initialisation-of-mapping-down
+++ a/mm/vmscan.c
@@ -1588,12 +1588,11 @@ retry:
 			stat->nr_unqueued_dirty += nr_pages;
 
 		/*
-		 * Treat this page as congested if the underlying BDI is or if
+		 * Treat this page as congested if
 		 * pages are cycling through the LRU so quickly that the
 		 * pages marked for immediate reclaim are making it to the
 		 * end of the LRU a second time.
 		 */
-		mapping = page_mapping(page);
 		if (writeback && PageReclaim(page))
 			stat->nr_congested += nr_pages;
 
@@ -1744,9 +1743,6 @@ retry:
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
 				}
-
-				/* Adding to swap updated mapping */
-				mapping = page_mapping(page);
 			}
 		} else if (PageSwapBacked(page) && PageTransHuge(page)) {
 			/* Split shmem THP */
@@ -1787,6 +1783,7 @@ retry:
 			}
 		}
 
+		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			/*
 			 * Only kswapd can writeback filesystem folios
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

