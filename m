Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0313C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiGDBMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiGDBLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8237F63A1
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F34B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5111C341C7;
        Mon,  4 Jul 2022 01:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897039;
        bh=ibRhcWdvvNOJYtoCTIvULUlOvhBeBxRT5Sswc70Bs5c=;
        h=Date:To:From:Subject:From;
        b=s76rRfAXiMcNHF8o/28GtoqsP88M0xJKnsSFCE6wczYvLF3B1pNFg2bEQ1xW2pQnO
         5rqMazbAakeSjEtUboTy+2zcGYVWCrsWPoZXmmERetYZ29Rf3zlGBOogxiS42eBHKO
         bb3DpZRsdB3NrwYeSn7TbmdYq9z8xZiI1lG7bMxI=
Date:   Sun, 03 Jul 2022 18:10:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-destroy_compound_page-to-destroy_large_folio.patch removed from -mm tree
Message-Id: <20220704011039.D5111C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert destroy_compound_page() to destroy_large_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-destroy_compound_page-to-destroy_large_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert destroy_compound_page() to destroy_large_folio()
Date: Fri, 17 Jun 2022 18:50:17 +0100

All callers now have a folio, so push the folio->page conversion
down to this function.

[akpm@linux-foundation.org: uninline destroy_large_folio() to fix build issue]
Link: https://lkml.kernel.org/r/20220617175020.717127-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +-----
 mm/page_alloc.c    |    8 ++++++++
 mm/swap.c          |    2 +-
 mm/vmscan.c        |    4 ++--
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-convert-destroy_compound_page-to-destroy_large_folio
+++ a/include/linux/mm.h
@@ -892,11 +892,7 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline void destroy_compound_page(struct page *page)
-{
-	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
-	compound_page_dtors[page[1].compound_dtor](page);
-}
+void destroy_large_folio(struct folio *folio);
 
 static inline int head_compound_pincount(struct page *head)
 {
--- a/mm/page_alloc.c~mm-convert-destroy_compound_page-to-destroy_large_folio
+++ a/mm/page_alloc.c
@@ -744,6 +744,14 @@ void prep_compound_page(struct page *pag
 	prep_compound_head(page, order);
 }
 
+void destroy_large_folio(struct folio *folio)
+{
+	enum compound_dtor_id dtor = folio_page(folio, 1)->compound_dtor;
+
+	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
+	compound_page_dtors[dtor](&folio->page);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
 
--- a/mm/swap.c~mm-convert-destroy_compound_page-to-destroy_large_folio
+++ a/mm/swap.c
@@ -115,7 +115,7 @@ static void __folio_put_large(struct fol
 	 */
 	if (!folio_test_hugetlb(folio))
 		__page_cache_release(folio);
-	destroy_compound_page(&folio->page);
+	destroy_large_folio(folio);
 }
 
 void __folio_put(struct folio *folio)
--- a/mm/vmscan.c~mm-convert-destroy_compound_page-to-destroy_large_folio
+++ a/mm/vmscan.c
@@ -1979,7 +1979,7 @@ free_it:
 		 * appear not as the counts should be low
 		 */
 		if (unlikely(folio_test_large(folio)))
-			destroy_compound_page(&folio->page);
+			destroy_large_folio(folio);
 		else
 			list_add(&folio->lru, &free_pages);
 		continue;
@@ -2348,7 +2348,7 @@ static unsigned int move_pages_to_lru(st
 
 			if (unlikely(folio_test_large(folio))) {
 				spin_unlock_irq(&lruvec->lru_lock);
-				destroy_compound_page(&folio->page);
+				destroy_large_folio(folio);
 				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&folio->lru, &folios_to_free);
_

Patches currently in -mm which might be from willy@infradead.org are

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

