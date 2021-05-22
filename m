Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD52C4707E
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D10761182
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhEVTSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 15:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhEVTSD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 15:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F4F61073;
        Sat, 22 May 2021 19:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621710998;
        bh=Tj1gad+O/hqYlc0VH90kTw+ZSrLUUOQuN//0Z8sArKE=;
        h=Date:From:To:Subject:From;
        b=HWwV9gOf614dUOL+u2rWsuPqAVlhJkZWxIiAZa6F3bhg2wZNaZSW8krgoB6z8/fB6
         S/5HlctsngkSbiKymDH/v3+QQlb9+lwxc5YkRoIrzzwBJQWHkirMCY8GJhmYNtH09A
         go8SX1De/jbiTK1qUrm9uIoOR6rGag+V2R8/b7f0=
Date:   Sat, 22 May 2021 12:16:37 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  + mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
 added to -mm tree
Message-ID: <20210522191637.0LgOa71eA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: fix two bugs in zswap_writeback_entry()
has been added to the -mm tree.  Its filename is
     mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

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
Subject: mm/zswap.c: fix two bugs in zswap_writeback_entry()

In the ZSWAP_SWAPCACHE_FAIL and ZSWAP_SWAPCACHE_EXIST case, we forgot to
call zpool_unmap_handle() when zpool can't sleep. And we might sleep in
zswap_get_swap_cache_page() while zpool can't sleep. To fix all of these,
zpool_unmap_handle() should be done before zswap_get_swap_cache_page()
when zpool can't sleep.

Link: https://lkml.kernel.org/r/20210522092242.3233191-4-linmiaohe@huawei.com
Fixes: fc6697a89f56 ("mm/zswap: add the flag can_sleep_mapped")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Tian Tao <tiantao6@hisilicon.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/zswap.c~mm-zswapc-fix-two-bugs-in-zswap_writeback_entry
+++ a/mm/zswap.c
@@ -967,6 +967,13 @@ static int zswap_writeback_entry(struct
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
+	src = (u8 *)zhdr + sizeof(struct zswap_header);
+	if (!zpool_can_sleep_mapped(pool)) {
+		memcpy(tmp, src, entry->length);
+		src = tmp;
+		zpool_unmap_handle(pool, handle);
+	}
+
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
 	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
@@ -982,17 +989,7 @@ static int zswap_writeback_entry(struct
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-
 		dlen = PAGE_SIZE;
-		src = (u8 *)zhdr + sizeof(struct zswap_header);
-
-		if (!zpool_can_sleep_mapped(pool)) {
-
-			memcpy(tmp, src, entry->length);
-			src = tmp;
-
-			zpool_unmap_handle(pool, handle);
-		}
 
 		mutex_lock(acomp_ctx->mutex);
 		sg_init_one(&input, src, entry->length);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

