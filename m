Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08406CCA485
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiFQXP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbiFQXPD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A74A65D06
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6286174E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5199FC3411B;
        Fri, 17 Jun 2022 23:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507689;
        bh=PT3W+0E/lxZZsj7HbTv+X0YShmaGlKsWeEh7wnHfKME=;
        h=Date:To:From:Subject:From;
        b=tvrsAvWtslLr3Offd9X5L6sCpH1AIDzdJHl8udyZ3RIrdxDN+wNCHT4m9ArH0ByPe
         ai+8KbufCSfYfBeDSKG2d44xQ6zDMhdNJfBYl6r6gGT18o61xaCru/fHXXU0avKgro
         wcrr7JhnS1VLmFA/aIdQoUmQpw4SC8j/rZxhJA6Y=
Date:   Fri, 17 Jun 2022 16:14:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-destroy_compound_page-to-destroy_large_folio.patch added to mm-unstable branch
Message-Id: <20220617231449.5199FC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert destroy_compound_page() to destroy_large_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-destroy_compound_page-to-destroy_large_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-destroy_compound_page-to-destroy_large_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert destroy_compound_page() to destroy_large_folio()
Date: Fri, 17 Jun 2022 18:50:17 +0100

All callers now have a folio, so push the folio->page conversion
down to this function.

Link: https://lkml.kernel.org/r/20220617175020.717127-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 +++++---
 mm/swap.c          |    2 +-
 mm/vmscan.c        |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-convert-destroy_compound_page-to-destroy_large_folio
+++ a/include/linux/mm.h
@@ -923,10 +923,12 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline void destroy_compound_page(struct page *page)
+static inline void destroy_large_folio(struct folio *folio)
 {
-	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
-	compound_page_dtors[page[1].compound_dtor](page);
+	enum compound_dtor_id dtor = folio_page(folio, 1)->compound_dtor;
+
+	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
+	compound_page_dtors[dtor](&folio->page);
 }
 
 static inline int head_compound_pincount(struct page *head)
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
@@ -1985,7 +1985,7 @@ free_it:
 		 * appear not as the counts should be low
 		 */
 		if (unlikely(folio_test_large(folio)))
-			destroy_compound_page(&folio->page);
+			destroy_large_folio(folio);
 		else
 			list_add(&folio->lru, &free_pages);
 		continue;
@@ -2354,7 +2354,7 @@ static unsigned int move_pages_to_lru(st
 
 			if (unlikely(folio_test_large(folio))) {
 				spin_unlock_irq(&lruvec->lru_lock);
-				destroy_compound_page(&folio->page);
+				destroy_large_folio(folio);
 				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&folio->lru, &folios_to_free);
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
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch
mm-add-folios_put.patch
mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
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

