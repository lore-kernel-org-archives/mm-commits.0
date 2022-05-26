Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53031C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 18:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbiEZSQZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 14:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiEZSQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 14:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7691DBF
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 11:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A73F261204
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 18:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BDCC385A9;
        Thu, 26 May 2022 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653588979;
        bh=16TqlE5ZE0fSZCApBdjmV9SQ1loqU9Crb0PELmApy6U=;
        h=Date:To:From:Subject:From;
        b=kvgpzp4GbCTWBPWfx4LbNm5s5tMeeWqMqoKKcyfDC4oh/tGZPD/AeyjFOqYprT0/8
         He1uUCVlFCmc4fKwbV7Z7fTLPPnRy6SrnBO1MhH/4ZnAF7ZbtEC2QKjWJX8ugcK9LX
         yJJBYLEknuQM9BtNHgIsJRZF+nv3hcoK27Kpydeo=
Date:   Thu, 26 May 2022 11:16:19 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, rientjes@google.com,
        pasha.tatashin@soleen.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-fix-accessing-unmapped-ptep.patch added to mm-hotfixes-unstable branch
Message-Id: <20220526181619.D7BDCC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: fix accessing unmapped ptep
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_table_check-fix-accessing-unmapped-ptep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-fix-accessing-unmapped-ptep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/page_table_check: fix accessing unmapped ptep
Date: Thu, 26 May 2022 19:33:50 +0800

ptep is unmapped too early, so ptep could theoretically be accessed while
it's unmapped.  This might become a problem if/when CONFIG_HIGHPTE becomes
available on riscv.

Fix it by deferring pte_unmap() until page table checking is done.

Link: https://lkml.kernel.org/r/20220526113350.30806-1-linmiaohe@huawei.com
Fixes: 80110bbfbba6 ("mm/page_table_check: check entries at pmd levels")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_table_check-fix-accessing-unmapped-ptep
+++ a/mm/page_table_check.c
@@ -251,11 +251,11 @@ void __page_table_check_pte_clear_range(
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
-		pte_unmap(ptep);
 		for (i = 0; i < PTRS_PER_PTE; i++) {
 			__page_table_check_pte_clear(mm, addr, *ptep);
 			addr += PAGE_SIZE;
 			ptep++;
 		}
+		pte_unmap(ptep);
 	}
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_table_check-fix-accessing-unmapped-ptep.patch
mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

