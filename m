Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131F5C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354921AbiD2HHz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354852AbiD2HHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C8DBE9C3
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C67161F5B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39FAC385A7;
        Fri, 29 Apr 2022 07:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215872;
        bh=MxWP2gk53WOEyPxftN/DlkvKoQYcJF3/irz6wi5DSWk=;
        h=Date:To:From:Subject:From;
        b=pwGHJ113IIKKQBUM0j+HIulyWULkDtekDljwNkOg6ugPBJHo6BEhdCSeAJ2tQgI96
         Zek9m8QZbesCYvA1QMpND4qUZNrWm2Fu8RNkx4kSl6md8GNnRoGsLNIqtSqxBOiM9Y
         mQHDCOFVE4enFQgd6TPGHQfNd4rR0L2Stx8rMDc8=
Date:   Fri, 29 Apr 2022 00:04:31 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch added to mm-unstable branch
Message-Id: <20220429070431.F39FAC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: always clear PAGE_CLAIMED under z3fold page lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch

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
Subject: mm/z3fold: always clear PAGE_CLAIMED under z3fold page lock

Think about the below race window:

CPU1				CPU2
z3fold_reclaim_page		z3fold_free
 test_and_set_bit PAGE_CLAIMED
 failed to reclaim page
 z3fold_page_lock(zhdr);
 add back to the lru list;
 z3fold_page_unlock(zhdr);
				 get_z3fold_header
				 page_claimed=test_and_set_bit PAGE_CLAIMED

 clear_bit(PAGE_CLAIMED, &page->private);

				 if (!page_claimed) /* it's false true */
				  free_handle is not called

free_handle won't be called in this case. So z3fold_buddy_slots will leak.
Fix it by always clear PAGE_CLAIMED under z3fold page lock.

Link: https://lkml.kernel.org/r/20220429064051.61552-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock
+++ a/mm/z3fold.c
@@ -1221,8 +1221,8 @@ static void z3fold_free(struct z3fold_po
 		return;
 	}
 	if (test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
-		put_z3fold_header(zhdr);
 		clear_bit(PAGE_CLAIMED, &page->private);
+		put_z3fold_header(zhdr);
 		return;
 	}
 	if (zhdr->cpu < 0 || !cpu_online(zhdr->cpu)) {
@@ -1424,8 +1424,8 @@ next:
 			spin_unlock(&pool->lock);
 			if (list_empty(&zhdr->buddy))
 				add_to_unbuddied(pool, zhdr);
-			z3fold_page_unlock(zhdr);
 			clear_bit(PAGE_CLAIMED, &page->private);
+			z3fold_page_unlock(zhdr);
 		}
 
 		/* We started off locked to we need to lock the pool back */
@@ -1577,8 +1577,8 @@ static int z3fold_page_migrate(struct ad
 	if (!z3fold_page_trylock(zhdr))
 		return -EAGAIN;
 	if (zhdr->mapped_count != 0 || zhdr->foreign_handles != 0) {
-		z3fold_page_unlock(zhdr);
 		clear_bit(PAGE_CLAIMED, &page->private);
+		z3fold_page_unlock(zhdr);
 		return -EBUSY;
 	}
 	if (work_pending(&zhdr->work)) {
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

