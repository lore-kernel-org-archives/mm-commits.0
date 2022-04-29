Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02E1C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354866AbiD2HHt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354893AbiD2HHr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667BFBE9C6
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F389761F5A
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A0C385A4;
        Fri, 29 Apr 2022 07:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215868;
        bh=vEulgyr4GfnleqZtURILRHj82UMz+Lft0OUP90e2k1s=;
        h=Date:To:From:Subject:From;
        b=on3pQkJIqLCSqdTz6wRRXqCInJ0HlPKMOFuWj11I83fO01CI8KBKW6dummC9D3F/4
         HzWXs3lturzEQaBnwiYW4gM20mrNx8VuHeO4e9M0zFKXTzqdxtAvCKdq8HHExGM97g
         fnxIB6hPy8HLP9xy11bHgw4btVYLxF206zVZahag=
Date:   Fri, 29 Apr 2022 00:04:27 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch added to mm-unstable branch
Message-Id: <20220429070428.5D1A0C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm/z3fold.c: allow __GFP_HIGHMEM in z3fold_alloc"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch

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
Subject: revert "mm/z3fold.c: allow __GFP_HIGHMEM in z3fold_alloc"

Revert commit f1549cb5ab2b ("mm/z3fold.c: allow __GFP_HIGHMEM in
z3fold_alloc").

z3fold can't support GFP_HIGHMEM page now.  page_address is used directly
at all places.  Moreover, z3fold_header is on per cpu unbuddied list which
could be access anytime.  So we should rid the support of GFP_HIGHMEM
allocation for z3fold.

Link: https://lkml.kernel.org/r/20220429064051.61552-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/z3fold.c~revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -212,10 +212,8 @@ static int size_to_chunks(size_t size)
 static inline struct z3fold_buddy_slots *alloc_slots(struct z3fold_pool *pool,
 							gfp_t gfp)
 {
-	struct z3fold_buddy_slots *slots;
-
-	slots = kmem_cache_zalloc(pool->c_handle,
-				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
+	struct z3fold_buddy_slots *slots = kmem_cache_zalloc(pool->c_handle,
+							     gfp);
 
 	if (slots) {
 		/* It will be freed separately in free_handle(). */
@@ -1075,7 +1073,7 @@ static int z3fold_alloc(struct z3fold_po
 	enum buddy bud;
 	bool can_sleep = gfpflags_allow_blocking(gfp);
 
-	if (!size)
+	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;
 
 	if (size > PAGE_SIZE)
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

