Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A59C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354844AbiD2HH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiD2HH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF22BE9C8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A81B361F5B
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C66C385A7;
        Fri, 29 Apr 2022 07:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215849;
        bh=1xWdXAbsD5ujvngU/BApCkvJYnoNfrk0EUFlOVtQRYo=;
        h=Date:To:From:Subject:From;
        b=WwUYDDFa8gdhcNFU3cO4UhQcaNuXrvMCGb7ukazOaJDTmivbB9ok3KlfdFursZiVs
         yMyYKknAgklcw6FH0Q0cmno+Ha6Qh3TY3FqsZCEshaWFHirti6qgXaIaPA33P3G6SO
         k1o41SrnqffuBlkZbWOZb0OrC5MyFBnzLRN0vBnQ=
Date:   Fri, 29 Apr 2022 00:04:08 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-fix-sheduling-while-atomic.patch added to mm-unstable branch
Message-Id: <20220429070409.09C66C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: fix sheduling while atomic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-fix-sheduling-while-atomic.patch

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
Subject: mm/z3fold: fix sheduling while atomic

Patch series "A few fixup patches for z3fold".

This series contains a few fixup patches to fix sheduling while atomic,
fix possible null pointer dereferencing, fix various race conditions and
so on. More details can be found in the respective changelogs.


This patch (of 9):

z3fold's page_lock is always held when calling alloc_slots.  So gfp should
be GFP_ATOMIC to avoid "scheduling while atomic" bug.

Link: https://lkml.kernel.org/r/20220429064051.61552-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220429064051.61552-2-linmiaohe@huawei.com
Fixes: fc5488651c7d ("z3fold: simplify freeing slots")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-sheduling-while-atomic
+++ a/mm/z3fold.c
@@ -941,8 +941,7 @@ lookup:
 	}
 
 	if (zhdr && !zhdr->slots)
-		zhdr->slots = alloc_slots(pool,
-					can_sleep ? GFP_NOIO : GFP_ATOMIC);
+		zhdr->slots = alloc_slots(pool, GFP_ATOMIC);
 	return zhdr;
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

