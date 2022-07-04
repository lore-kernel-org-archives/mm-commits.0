Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF0CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiGDBL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiGDBLE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC57636F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927CC61303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73EEC341C7;
        Mon,  4 Jul 2022 01:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897035;
        bh=nkVbOJ2wtKkA4DuXvLnn1mfqcqpNDwh2EOGe6KCa+Ro=;
        h=Date:To:From:Subject:From;
        b=en0Jm6x9lh2UTkk8FnwctGlvmsskJAIQP0H/HXedS7JFuCmhgBBBdptN0czXodxAn
         ml1aYxS8cs97hoqJb7Qyv6zWk9kONw7HvWeTj6oLsHiDDR9vhm0CMQTW5fyqVEh7eY
         wuZBpjjqb02p9P/LdpbTeWHWLgESCWlhJ7xo6o9Q=
Date:   Sun, 03 Jul 2022 18:10:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-put_pages_list-to-use-folios.patch removed from -mm tree
Message-Id: <20220704011034.E73EEC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert put_pages_list to use folios
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-put_pages_list-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert put_pages_list to use folios
Date: Fri, 17 Jun 2022 18:50:12 +0100

Pages linked through the LRU list cannot be tail pages as ->compound_head
is in a union with one of the words of the list_head, and they cannot
be ZONE_DEVICE pages as ->pgmap is in a union with the same word.
Saves 60 bytes of text by removing a call to page_is_fake_head().

Link: https://lkml.kernel.org/r/20220617175020.717127-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/swap.c~mm-swap-convert-put_pages_list-to-use-folios
+++ a/mm/swap.c
@@ -138,19 +138,19 @@ EXPORT_SYMBOL(__put_page);
  */
 void put_pages_list(struct list_head *pages)
 {
-	struct page *page, *next;
+	struct folio *folio, *next;
 
-	list_for_each_entry_safe(page, next, pages, lru) {
-		if (!put_page_testzero(page)) {
-			list_del(&page->lru);
+	list_for_each_entry_safe(folio, next, pages, lru) {
+		if (!folio_put_testzero(folio)) {
+			list_del(&folio->lru);
 			continue;
 		}
-		if (PageHead(page)) {
-			list_del(&page->lru);
-			__put_compound_page(page);
+		if (folio_test_large(folio)) {
+			list_del(&folio->lru);
+			__put_compound_page(&folio->page);
 			continue;
 		}
-		/* Cannot be PageLRU because it's passed to us using the lru */
+		/* LRU flag must be clear because it's passed using the lru */
 	}
 
 	free_unref_page_list(pages);
_

Patches currently in -mm which might be from willy@infradead.org are

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

