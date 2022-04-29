Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05417C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354893AbiD2HH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354874AbiD2HHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C34BE9C2
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D783B832F4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D2BC385A4;
        Fri, 29 Apr 2022 07:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215870;
        bh=SHh469JfeW7+UhHER6l+MGDkdfpDJte4Aa/GWF6iU2w=;
        h=Date:To:From:Subject:From;
        b=A4JYKmZGFHt74q0lIG5t5Siv9nM7tW3ln8I6TkAYVeyUIy+UWhVqKvqC/AmE/yWLN
         4Jnijbyi1Z6WAORQ4Ar3qN5bfja8XLZewmrNra6JztOwtgUz+jy4/7+63Hl+PAoLoh
         +A9NNJP3aILRPnv778eKaQFTVa7S3pMcA1pAT7aU=
Date:   Fri, 29 Apr 2022 00:04:29 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch added to mm-unstable branch
Message-Id: <20220429070430.34D2BC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: put z3fold page back into unbuddied list when reclaim or migration fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch

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
Subject: mm/z3fold: put z3fold page back into unbuddied list when reclaim or migration fails

When doing z3fold page reclaim or migration, the page is removed from
unbuddied list.  If reclaim or migration succeeds, it's fine as page is
released.  But in case it fails, the page is not put back into unbuddied
list now.  The page will be leaked until next compaction work, reclaim or
migration is done.

Link: https://lkml.kernel.org/r/20220429064051.61552-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/z3fold.c~mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails
+++ a/mm/z3fold.c
@@ -1422,6 +1422,8 @@ next:
 			spin_lock(&pool->lock);
 			list_add(&page->lru, &pool->lru);
 			spin_unlock(&pool->lock);
+			if (list_empty(&zhdr->buddy))
+				add_to_unbuddied(pool, zhdr);
 			z3fold_page_unlock(zhdr);
 			clear_bit(PAGE_CLAIMED, &page->private);
 		}
@@ -1638,6 +1640,8 @@ static void z3fold_page_putback(struct p
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
 	spin_unlock(&pool->lock);
+	if (list_empty(&zhdr->buddy))
+		add_to_unbuddied(pool, zhdr);
 	clear_bit(PAGE_CLAIMED, &page->private);
 	z3fold_page_unlock(zhdr);
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

