Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F7CCCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiGDBMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiGDBLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A756363A5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C3C1B80CEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135EBC341C6;
        Mon,  4 Jul 2022 01:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897041;
        bh=g4HzpLToXCd7gZ8lhKuAJbFcc5udLaztEZQ7Eg27FA0=;
        h=Date:To:From:Subject:From;
        b=Qid+stlylsHzWyxECFYWh5loSIEYPhDJQCte0GKCS7fyuk/erRhc5qPHYqBI2HO+k
         ARyFtP2G47WMVnZzCQKDEvN2upGZ0P8+GSieroyABunrUrC5tw/bXy+WUzuYopy/X8
         N88Y6249SDXMR1DK0DPsdWnbsolQOVr/AV1SXaME=
Date:   Sun, 03 Jul 2022 18:10:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_swap_flags-to-folio_swap_flags.patch removed from -mm tree
Message-Id: <20220704011041.135EBC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_swap_flags to folio_swap_flags
has been removed from the -mm tree.  Its filename was
     mm-convert-page_swap_flags-to-folio_swap_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_swap_flags to folio_swap_flags
Date: Fri, 17 Jun 2022 18:50:18 +0100

The only caller already has a folio, so push the folio->page conversion
down a level.

Link: https://lkml.kernel.org/r/20220617175020.717127-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h   |    6 +++---
 mm/vmscan.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swap.h~mm-convert-page_swap_flags-to-folio_swap_flags
+++ a/mm/swap.h
@@ -61,9 +61,9 @@ struct page *swap_cluster_readahead(swp_
 struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
 			      struct vm_fault *vmf);
 
-static inline unsigned int page_swap_flags(struct page *page)
+static inline unsigned int folio_swap_flags(struct folio *folio)
 {
-	return page_swap_info(page)->flags;
+	return page_swap_info(&folio->page)->flags;
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
@@ -149,7 +149,7 @@ static inline void clear_shadow_from_swa
 {
 }
 
-static inline unsigned int page_swap_flags(struct page *page)
+static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
 }
--- a/mm/vmscan.c~mm-convert-page_swap_flags-to-folio_swap_flags
+++ a/mm/vmscan.c
@@ -1572,7 +1572,7 @@ static bool may_enter_fs(struct folio *f
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
-	return !data_race(page_swap_flags(&folio->page) & SWP_FS_OPS);
+	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
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
mips-rename-pmd_order-to-pmd_table_order.patch

