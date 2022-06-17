Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D197FCCA479
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbiFQXP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiFQXPB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:15:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2884463BD9
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFAB6B82BFC
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E09AC3411B;
        Fri, 17 Jun 2022 23:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507685;
        bh=iFFS0naSkYZu318XZN9o7Uuw6TP18cC5yjgNHSH2CNM=;
        h=Date:To:From:Subject:From;
        b=ej3IyNf9phGNZGhqFdAG0Sw6fNy4IEs4v9apLfXKmR524JMPU0Xsi96DaMpFxD3BK
         fFScFjV7/MlKzom1uK13/fSIEdOtl/nvIR3tczzPgLMaKR87Ci0xZ8Md1QczFmP+1l
         SxupooQ2KQoCW24RmA7OC4afkbHGy7phGlgbQtE0=
Date:   Fri, 17 Jun 2022 16:14:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-__put_compound_page-to-__folio_put_large.patch added to mm-unstable branch
Message-Id: <20220617231445.9E09AC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert __put_compound_page() to __folio_put_large()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-__put_compound_page-to-__folio_put_large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-__put_compound_page-to-__folio_put_large.patch

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
Subject: mm/swap: convert __put_compound_page() to __folio_put_large()
Date: Fri, 17 Jun 2022 18:50:15 +0100

All the callers now have a folio, so pass it in.  This doesn't
save any text, but it does save a call to compound_head() as
folio_test_hugetlb() does not contain a call like PageHuge() does.

Link: https://lkml.kernel.org/r/20220617175020.717127-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-swap-convert-__put_compound_page-to-__folio_put_large
+++ a/mm/swap.c
@@ -106,7 +106,7 @@ static void __folio_put_small(struct fol
 	free_unref_page(&folio->page, 0);
 }
 
-static void __put_compound_page(struct page *page)
+static void __folio_put_large(struct folio *folio)
 {
 	/*
 	 * __page_cache_release() is supposed to be called for thp, not for
@@ -114,9 +114,9 @@ static void __put_compound_page(struct p
 	 * (it's never listed to any LRU lists) and no memcg routines should
 	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
 	 */
-	if (!PageHuge(page))
-		__page_cache_release(page);
-	destroy_compound_page(page);
+	if (!folio_test_hugetlb(folio))
+		__page_cache_release(&folio->page);
+	destroy_compound_page(&folio->page);
 }
 
 void __folio_put(struct folio *folio)
@@ -124,7 +124,7 @@ void __folio_put(struct folio *folio)
 	if (unlikely(folio_is_zone_device(folio)))
 		free_zone_device_page(&folio->page);
 	else if (unlikely(folio_test_large(folio)))
-		__put_compound_page(&folio->page);
+		__folio_put_large(folio);
 	else
 		__folio_put_small(folio);
 }
@@ -147,7 +147,7 @@ void put_pages_list(struct list_head *pa
 		}
 		if (folio_test_large(folio)) {
 			list_del(&folio->lru);
-			__put_compound_page(&folio->page);
+			__folio_put_large(folio);
 			continue;
 		}
 		/* LRU flag must be clear because it's passed using the lru */
@@ -976,7 +976,7 @@ void release_pages(struct page **pages,
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			__put_compound_page(&folio->page);
+			__folio_put_large(folio);
 			continue;
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

