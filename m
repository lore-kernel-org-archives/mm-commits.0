Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE6FC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAAE611AD
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEVTSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 15:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhEVTSC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 15:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D1961175;
        Sat, 22 May 2021 19:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621710996;
        bh=f0MhBCPrJC07YOslyw8y4UTciGIEsXDc35I+JvIlNaU=;
        h=Date:From:To:Subject:From;
        b=Y7M2Ff038l1p+79rqU35QirlPPjAF9kjJ6Mgb2GDrVqfAzjm4auItVH0aeEynL0dN
         OyjIx1nTpCLmd4uLyCup0nERl6FLnVXiTI/ko7xy+gmVO08nBFQrCDqQXI03FpS3x1
         N8o/wxE+xhtjjTEyqDgmsHn87THvnuZGA490Bc7M=
Date:   Sat, 22 May 2021 12:16:35 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  + mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
 added to -mm tree
Message-ID: <20210522191635.dhqhY3WuZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: avoid unnecessary copy-in at map time
has been added to the -mm tree.  Its filename is
     mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch

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
Subject: mm/zswap.c: avoid unnecessary copy-in at map time

The buf mapped via zpool_map_handle() is only used to store compressed
page buffer and there is no information to extract from it. So we could
use ZPOOL_MM_WO instead to avoid unnecessary copy-in at map time.

Link: https://lkml.kernel.org/r/20210522092242.3233191-3-linmiaohe@huawei.com
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

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswapc-avoid-unnecessary-copy-in-at-map-time
+++ a/mm/zswap.c
@@ -1203,7 +1203,7 @@ static int zswap_frontswap_store(unsigne
 		zswap_reject_alloc_fail++;
 		goto put_dstmem;
 	}
-	buf = zpool_map_handle(entry->pool->zpool, handle, ZPOOL_MM_RW);
+	buf = zpool_map_handle(entry->pool->zpool, handle, ZPOOL_MM_WO);
 	memcpy(buf, &zhdr, hlen);
 	memcpy(buf + hlen, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
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

