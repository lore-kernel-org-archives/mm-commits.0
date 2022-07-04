Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FEECCA47C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiGDBLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiGDBKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294D76360
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F2A61305
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE2C341C7;
        Mon,  4 Jul 2022 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897033;
        bh=QeyPSpbothxUC97UnN9Sl0MN0Rn8DDMnqDUIt/tGgjE=;
        h=Date:To:From:Subject:From;
        b=DlENeMWsYkzxz1P08XMQ13B3hk0esvT+ixU7bWASMqvBsnZa3em0zCvCLAj9lz9fe
         UQsU01pHC9Rbe60jMZDj9Wb82DZ/pFZnnts0pB/VntY+M+tUpJXmjDn1BlSpcSbmou
         Teg/E6vpPbnGGwOPqAznl+y2R6iuHD1LLBW8kiyg=
Date:   Sun, 03 Jul 2022 18:10:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-try_to_free_swap-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011032.ECBE2C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert try_to_free_swap to use a folio
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-try_to_free_swap-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert try_to_free_swap to use a folio
Date: Fri, 17 Jun 2022 18:50:10 +0100

Save a few calls to compound_head by converting the passed page to
a folio.  Reduces kernel text size by 74 bytes.

Link: https://lkml.kernel.org/r/20220617175020.717127-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/swapfile.c~mm-swap-convert-try_to_free_swap-to-use-a-folio
+++ a/mm/swapfile.c
@@ -1568,16 +1568,15 @@ unlock_out:
 	return ret;
 }
 
-static bool page_swapped(struct page *page)
+static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si;
 
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!PageTransCompound(page)))
-		return page_swapcount(page) != 0;
+	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
+		return page_swapcount(&folio->page) != 0;
 
-	page = compound_head(page);
-	entry.val = page_private(page);
+	entry = folio_swap_entry(folio);
 	si = _swap_info_get(entry);
 	if (si)
 		return swap_page_trans_huge_swapped(si, entry);
@@ -1590,13 +1589,14 @@ static bool page_swapped(struct page *pa
  */
 int try_to_free_swap(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	struct folio *folio = page_folio(page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (!PageSwapCache(page))
+	if (!folio_test_swapcache(folio))
 		return 0;
-	if (PageWriteback(page))
+	if (folio_test_writeback(folio))
 		return 0;
-	if (page_swapped(page))
+	if (folio_swapped(folio))
 		return 0;
 
 	/*
@@ -1617,9 +1617,8 @@ int try_to_free_swap(struct page *page)
 	if (pm_suspended_storage())
 		return 0;
 
-	page = compound_head(page);
-	delete_from_swap_cache(page);
-	SetPageDirty(page);
+	delete_from_swap_cache(&folio->page);
+	folio_set_dirty(folio);
 	return 1;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
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

