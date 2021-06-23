Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFAAC48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4BBE611AD
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFWV6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFWV6K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB21261002;
        Wed, 23 Jun 2021 21:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624485352;
        bh=Kny90QFcWVU4nnYuPM9J/75F9pHG2JtUsIDevZKVGYs=;
        h=Date:From:To:Subject:From;
        b=V1Wk1TjkS6X/iVZqXcLW3on4Tf4sPAVopvP5PAUKJgzVmzs/IvWUNCTH2W9NZJjAh
         SBWKihYxfAqXuKIKOGHJeBHpEunlCxmTKd4SHgeNqBSogbYL4xLEvT79f7dE//N4y3
         lOPj/oreBJ25Qgv8eKzqkfd7IHaF4S4gg37BaCjI=
Date:   Wed, 23 Jun 2021 14:55:51 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 =?US-ASCII?Q?mm-z3fold-use-release=5Fz3fold=5Fpage=5Flocked-to-release-?=
 =?US-ASCII?Q?locked-z3fold-page.patch?= added to -mm tree
Message-ID: <20210623215551.A6PZIVWGk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page
has been added to the -mm tree.  Its filename is
     mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page

We should use release_z3fold_page_locked() to release z3fold page when
it's locked, although it looks harmless to use release_z3fold_page() now.

Link: https://lkml.kernel.org/r/20210619093151.1492174-7-linmiaohe@huawei.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page
+++ a/mm/z3fold.c
@@ -1370,7 +1370,7 @@ static int z3fold_reclaim_page(struct z3
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
 				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
+						release_z3fold_page_locked))
 					atomic64_dec(&pool->pages_nr);
 				else
 					z3fold_page_unlock(zhdr);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch
mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch
mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

