Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B44C48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D5E611AC
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWV6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFWV6A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7A56100A;
        Wed, 23 Jun 2021 21:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624485342;
        bh=kyDn5wJMqvsHTm+Fx9bLXl7116S4hfahBOZ+omlysos=;
        h=Date:From:To:Subject:From;
        b=kOHD67Q1AXDWKVzwejf+iutnwq55+bVifUaMfKakmdlgSffeEjgj9SWyyGcZ4fo0n
         hMRyCKqi3OA2f1YyjEdYKJgRJCUm6wm471Oo25NN+YAn6KuPpEn5GnkulQoD4jL2io
         W0l7wIIThbON957DvL1scXti+efKNIR+BuuPE6s4=
Date:   Wed, 23 Jun 2021 14:55:41 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch added to
 -mm tree
Message-ID: <20210623215541.AEHtVGFta%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: define macro NCHUNKS as TOTAL_CHUNKS - ZHDR_CHUNKS
has been added to the -mm tree.  Its filename is
     mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch

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
Subject: mm/z3fold: define macro NCHUNKS as TOTAL_CHUNKS - ZHDR_CHUNKS

Patch series "Cleanup and fixup for z3fold".

This series contains cleanups to remove unused function, redefine macro to
improve readability and so on.  Also this fixes several bugs in z3fold,
such as memory leak in z3fold_destroy_pool().  More details can be found
in the respective changelogs.


This patch (of 6):

To improve code readability, we could define macro NCHUNKS as TOTAL_CHUNKS
- ZHDR_CHUNKS.  No functional change intended.

Link: https://lkml.kernel.org/r/20210619093151.1492174-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210619093151.1492174-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks
+++ a/mm/z3fold.c
@@ -62,7 +62,7 @@
 #define ZHDR_SIZE_ALIGNED round_up(sizeof(struct z3fold_header), CHUNK_SIZE)
 #define ZHDR_CHUNKS	(ZHDR_SIZE_ALIGNED >> CHUNK_SHIFT)
 #define TOTAL_CHUNKS	(PAGE_SIZE >> CHUNK_SHIFT)
-#define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
+#define NCHUNKS		(TOTAL_CHUNKS - ZHDR_CHUNKS)
 
 #define BUDDY_MASK	(0x3)
 #define BUDDY_SHIFT	2
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

