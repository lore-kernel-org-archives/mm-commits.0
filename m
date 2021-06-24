Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389C9C49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA23613D1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhFXUtk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232578AbhFXUtj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E660B613C3;
        Thu, 24 Jun 2021 20:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624567640;
        bh=E9ynY6RAJgXyLfW01DZ33qEg1SuGADxo4w28LPU35KI=;
        h=Date:From:To:Subject:From;
        b=If44+GxUyG7XWt/ipFYqOioyTZf6B6GyU5nEN45dnhmN46TY6K/Sc/FwvWUCBOfJP
         hYDbIbSUiVDp5go8XXBY5l4Qd0+iMsDQgl+bMgHp6dhH4tChLr28t/v6HH7HXM0P5L
         axMnc0BiUaRblUoQXCTJ3gaIdlyzizdgKOw6tU3E=
Date:   Thu, 24 Jun 2021 13:47:19 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  + mm-zsmallocc-remove-confusing-code-in-obj_free.patch
 added to -mm tree
Message-ID: <20210624204719.nxg9-Ns68%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: remove confusing code in obj_free()
has been added to the -mm tree.  Its filename is
     mm-zsmallocc-remove-confusing-code-in-obj_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmallocc-remove-confusing-code-in-obj_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmallocc-remove-confusing-code-in-obj_free.patch

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
Subject: mm/zsmalloc.c: remove confusing code in obj_free()

Patch series "Cleanup for zsmalloc".

This series contains cleanups to remove confusing code in obj_free(),
combine two atomic ops and improve readability for async_free_zspage(). 
More details can be found in the respective changelogs.


This patch (of 3):

OBJ_ALLOCATED_TAG is only set for handle to indicate allocated object. 
It's irrelevant with obj.  So remove this misleading code to improve
readability.

Link: https://lkml.kernel.org/r/20210624123930.1769093-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210624123930.1769093-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-remove-confusing-code-in-obj_free
+++ a/mm/zsmalloc.c
@@ -1471,7 +1471,6 @@ static void obj_free(struct size_class *
 	unsigned int f_objidx;
 	void *vaddr;
 
-	obj &= ~OBJ_ALLOCATED_TAG;
 	obj_to_location(obj, &f_page, &f_objidx);
 	f_offset = (class->size * f_objidx) & ~PAGE_MASK;
 	zspage = get_zspage(f_page);
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

