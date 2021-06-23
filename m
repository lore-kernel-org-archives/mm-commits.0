Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FAEC49EA5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257C661166
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWV6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFWV6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9E2611AC;
        Wed, 23 Jun 2021 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624485344;
        bh=PdGVLkWD/TzMVh3cRv3CRJpCZsIXdzHa3uOY0y0MCfI=;
        h=Date:From:To:Subject:From;
        b=Bnq0RT5ESM9P9K9JQIMHDy6Eo0IbtTqOOGIP6fCKuikMhi81jckEX9KcZ1zWW9rzK
         2sxNZVeQ3KZbssV4ljvyPAbdsYMuT93lS8sQMbfyThguStgsoI+ipchQOGW/ope+Pf
         vLhOqbEkTdQoBulXpT3K0ctWSerdWB+m/aJQIVTE=
Date:   Wed, 23 Jun 2021 14:55:43 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch added to -mm tree
Message-ID: <20210623215543.IqsPI1V2p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: avoid possible underflow in z3fold_alloc()
has been added to the -mm tree.  Its filename is
     mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch

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
Subject: mm/z3fold: avoid possible underflow in z3fold_alloc()

It is not enough to just make sure the z3fold header is not larger than
the page size.  When z3fold header is equal to PAGE_SIZE, we would
underflow when check alloc size against PAGE_SIZE - ZHDR_SIZE_ALIGNED -
CHUNK_SIZE in z3fold_alloc().  Make sure there has remaining spaces for
its buddy to fix this theoretical issue.

Link: https://lkml.kernel.org/r/20210619093151.1492174-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-avoid-possible-underflow-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1803,8 +1803,11 @@ static int __init init_z3fold(void)
 {
 	int ret;
 
-	/* Make sure the z3fold header is not larger than the page size */
-	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE);
+	/*
+	 * Make sure the z3fold header is not larger than the page size and
+	 * there has remaining spaces for its buddy.
+	 */
+	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE - CHUNK_SIZE);
 	ret = z3fold_mount();
 	if (ret)
 		return ret;
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

