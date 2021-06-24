Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB6AC49EA7
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576A6613EA
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhFXUto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhFXUtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9357613C5;
        Thu, 24 Jun 2021 20:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624567642;
        bh=i7XoLK4xitNwA5aSTzsqcdkZ+JqtzqVm+BhH2Fn4DmI=;
        h=Date:From:To:Subject:From;
        b=P1xed81PKJuehny0vTE5t/eet4YdqOuoc+nDRCf+57x7aKw6sRLnOm/2M6nHXyfc0
         1s2Is2+D6S6J5EKTu3eJZS//i7a2go5bXuymdQfmFV78vFHmt8dMBLPAeGpca1W4aY
         6yObvk0+rvdHRkUUKvv9sDWvM8bG/SylrLCDw8jI=
Date:   Thu, 24 Jun 2021 13:47:21 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  +
 mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch added to
 -mm tree
Message-ID: <20210624204721.9-x-zXoRA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: combine two atomic ops in zs_pool_dec_isolated()
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

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
Subject: mm/zsmalloc.c: combine two atomic ops in zs_pool_dec_isolated()

atomic_long_dec_and_test() is equivalent to atomic_long_dec() and
atomic_long_read() == 0.  Use it to make code more succinct.

Link: https://lkml.kernel.org/r/20210624123930.1769093-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated
+++ a/mm/zsmalloc.c
@@ -1828,13 +1828,12 @@ static void putback_zspage_deferred(stru
 static inline void zs_pool_dec_isolated(struct zs_pool *pool)
 {
 	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
-	atomic_long_dec(&pool->isolated_pages);
 	/*
 	 * There's no possibility of racing, since wait_for_isolated_drain()
 	 * checks the isolated count under &class->lock after enqueuing
 	 * on migration_wait.
 	 */
-	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
+	if (atomic_long_dec_and_test(&pool->isolated_pages) && pool->destroying)
 		wake_up_all(&pool->migration_wait);
 }
 
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
mm-zbud-dont-export-any-zbud-api-fix.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
mm-zsmallocc-remove-confusing-code-in-obj_free.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch
mm-zsmallocc-improve-readability-for-async_free_zspage.patch

