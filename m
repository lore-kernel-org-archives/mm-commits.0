Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF904C49EA5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B828E611AC
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWV6H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFWV6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD815611AD;
        Wed, 23 Jun 2021 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624485348;
        bh=1BcdANxBB1dZug4Q119HGxJ0Dh87sHxKo6nHxeFBgzQ=;
        h=Date:From:To:Subject:From;
        b=UjtZmqdZvPdErMsyGsTOZonng/Hp0K4yjX2L7lY1pnm57iNNSYCRzxRuNK3MxMHvE
         vCpbLbnzGgbDSUODqAztTXadTMWEoc7ULdbcTNfdHKHY3XN/xGJI0B6jMaGWJqNOJB
         skPw68BBWc3m3qb7qkNTdPS8+8l6offpabE+CZ2o=
Date:   Wed, 23 Jun 2021 14:55:47 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        vitaly.wool@konsulko.com
Subject:  +
 mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch added to -mm
 tree
Message-ID: <20210623215547.KfKk5Cz0N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: remove unused function handle_to_z3fold_header()
has been added to the -mm tree.  Its filename is
     mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch

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
Subject: mm/z3fold: remove unused function handle_to_z3fold_header()

handle_to_z3fold_header() is unused now.  So we can remove it.  As a
result, get_z3fold_header() becomes the only caller of
__get_z3fold_header() and the argument lock is always true.  Therefore we
could further fold the __get_z3fold_header() into get_z3fold_header() with
lock = true.

Link: https://lkml.kernel.org/r/20210619093151.1492174-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unused-function-handle_to_z3fold_header
+++ a/mm/z3fold.c
@@ -253,9 +253,8 @@ static inline void z3fold_page_unlock(st
 	spin_unlock(&zhdr->page_lock);
 }
 
-
-static inline struct z3fold_header *__get_z3fold_header(unsigned long handle,
-							bool lock)
+/* return locked z3fold page if it's not headless */
+static inline struct z3fold_header *get_z3fold_header(unsigned long handle)
 {
 	struct z3fold_buddy_slots *slots;
 	struct z3fold_header *zhdr;
@@ -269,13 +268,12 @@ static inline struct z3fold_header *__ge
 			read_lock(&slots->lock);
 			addr = *(unsigned long *)handle;
 			zhdr = (struct z3fold_header *)(addr & PAGE_MASK);
-			if (lock)
-				locked = z3fold_page_trylock(zhdr);
+			locked = z3fold_page_trylock(zhdr);
 			read_unlock(&slots->lock);
 			if (locked)
 				break;
 			cpu_relax();
-		} while (lock);
+		} while (true);
 	} else {
 		zhdr = (struct z3fold_header *)(handle & PAGE_MASK);
 	}
@@ -283,18 +281,6 @@ static inline struct z3fold_header *__ge
 	return zhdr;
 }
 
-/* Returns the z3fold page where a given handle is stored */
-static inline struct z3fold_header *handle_to_z3fold_header(unsigned long h)
-{
-	return __get_z3fold_header(h, false);
-}
-
-/* return locked z3fold page if it's not headless */
-static inline struct z3fold_header *get_z3fold_header(unsigned long h)
-{
-	return __get_z3fold_header(h, true);
-}
-
 static inline void put_z3fold_header(struct z3fold_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
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

