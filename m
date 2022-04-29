Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AF3C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354874AbiD2HH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354902AbiD2HHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31604BE9C5
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49D5B832F9
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97284C385A7;
        Fri, 29 Apr 2022 07:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215875;
        bh=SKnzvpxJRm1MAx3vvzm9knJNR93+EdyaXGCw6OIB3LA=;
        h=Date:To:From:Subject:From;
        b=bT4gVWz9XkJ3tYDtC9Kgn3YN+XlWh4OAPVwFbfmTUNZaU/3ooQJrNcJXg6GkhcDrS
         /w8wv6+HSpA/xNxfu25APkZv7+ComtnfQqzQt89mRoLwfD2x5vB6g0AOsiiY7XJaXO
         GFk4pXwAZdEwvQcVrFjAr/id1t0BzkBs7wDr0uEk=
Date:   Fri, 29 Apr 2022 00:04:34 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch added to mm-unstable branch
Message-Id: <20220429070435.97284C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: fix z3fold_page_migrate races with z3fold_map
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch

This patch should soon appear in the mm-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix z3fold_page_migrate races with z3fold_map

Think about the below scenario:

CPU1				CPU2
 z3fold_page_migrate		z3fold_map
  z3fold_page_trylock
  ...
  z3fold_page_unlock
  /* slots still points to old zhdr*/
				 get_z3fold_header
				  get slots from handle
				  get old zhdr from slots
				  z3fold_page_trylock
				  return *old* zhdr
  encode_handle(new_zhdr, FIRST|LAST|MIDDLE)
  put_page(page) /* zhdr is freed! */
				 but zhdr is still used by caller!

z3fold_map can map freed z3fold page and lead to use-after-free bug.  To
fix it, we add PAGE_MIGRATED to indicate z3fold page is migrated and soon
to be released.  So get_z3fold_header won't return such page.

Link: https://lkml.kernel.org/r/20220429064051.61552-10-linmiaohe@huawei.com
Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map
+++ a/mm/z3fold.c
@@ -181,6 +181,7 @@ enum z3fold_page_flags {
 	NEEDS_COMPACTING,
 	PAGE_STALE,
 	PAGE_CLAIMED, /* by either reclaim or free */
+	PAGE_MIGRATED, /* page is migrated and soon to be released */
 };
 
 /*
@@ -270,8 +271,13 @@ static inline struct z3fold_header *get_
 			zhdr = (struct z3fold_header *)(addr & PAGE_MASK);
 			locked = z3fold_page_trylock(zhdr);
 			read_unlock(&slots->lock);
-			if (locked)
-				break;
+			if (locked) {
+				struct page *page = virt_to_page(zhdr);
+
+				if (!test_bit(PAGE_MIGRATED, &page->private))
+					break;
+				z3fold_page_unlock(zhdr);
+			}
 			cpu_relax();
 		} while (true);
 	} else {
@@ -389,6 +395,7 @@ static struct z3fold_header *init_z3fold
 	clear_bit(NEEDS_COMPACTING, &page->private);
 	clear_bit(PAGE_STALE, &page->private);
 	clear_bit(PAGE_CLAIMED, &page->private);
+	clear_bit(PAGE_MIGRATED, &page->private);
 	if (headless)
 		return zhdr;
 
@@ -1576,7 +1583,7 @@ static int z3fold_page_migrate(struct ad
 	new_zhdr = page_address(newpage);
 	memcpy(new_zhdr, zhdr, PAGE_SIZE);
 	newpage->private = page->private;
-	page->private = 0;
+	set_bit(PAGE_MIGRATED, &page->private);
 	z3fold_page_unlock(zhdr);
 	spin_lock_init(&new_zhdr->page_lock);
 	INIT_WORK(&new_zhdr->work, compact_page_work);
@@ -1606,7 +1613,8 @@ static int z3fold_page_migrate(struct ad
 
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
-	clear_bit(PAGE_CLAIMED, &page->private);
+	/* PAGE_CLAIMED and PAGE_MIGRATED are cleared now. */
+	page->private = 0;
 	put_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch

