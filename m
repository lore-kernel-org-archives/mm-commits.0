Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF8EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbiE0Qjk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350807AbiE0Qjh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:39:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CDCB41D2
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA0ABB825AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC3FC385B8;
        Fri, 27 May 2022 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669573;
        bh=KBRSKWfb1C+KhjayQlN5VwI43YC/Vo5Re3PbOf7z2g8=;
        h=Date:To:From:Subject:From;
        b=d2lsM25/NA+eZ22PH14bRA9+6b1ZhjEnTBu00hrbcKJlDd97o/rlKAwJCLSBswGDI
         +iyjENN5n3lRG3mCHf/AZ1DE4km+WhTVAcxR2CiiQQ+5tHkHX4P+eLGS/arS1PA37K
         4GAzTojASTyLfyUHdon2qEPqX/vdmEOnCulBbP2I=
Date:   Fri, 27 May 2022 09:39:32 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, rientjes@google.com,
        pasha.tatashin@soleen.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_table_check-fix-accessing-unmapped-ptep.patch removed from -mm tree
Message-Id: <20220527163933.7EC3FC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: fix accessing unmapped ptep
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-fix-accessing-unmapped-ptep.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_table_check: fix accessing unmapped ptep
Date: Thu, 26 May 2022 19:33:50 +0800

ptep is unmapped too early, so ptep could theoretically be accessed while
it's unmapped.  This might become a problem if/when CONFIG_HIGHPTE becomes
available on riscv.

Fix it by deferring pte_unmap() until page table checking is done.

[akpm@linux-foundation.org: account for ptep alteration, per Matthew]
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
+		pte_unmap(ptep - PTRS_PER_PTE);
 	}
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

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

