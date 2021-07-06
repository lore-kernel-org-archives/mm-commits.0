Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B8EC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F90E61CA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhGFTXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTXO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E2D061C9C;
        Tue,  6 Jul 2021 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599234;
        bh=tB/I57kIgNuFdwx9FQcORW9tt0Ut+9kwJYSkurKCRqI=;
        h=Date:From:To:Subject:From;
        b=db9K3DhGy5YLIH0YlXwqrLSGqqlRiGLgPBRz9/FVOT0rYxVXEEsXM6B8CnyBz+PHW
         NFgO1WLq1zUi+SB/Q8eA5nE/BHfv15F1d0MJF/5KbP+fNvKbY+Ut35WIUe+RX/HaYq
         09bVTX+pkQHjUm1MTgez6ih2rjGDOX6Ml8npTQRE=
Date:   Tue, 06 Jul 2021 12:20:34 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch removed from -mm tree
Message-ID: <20210706192034.bJ6fs9YC_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: fix two bugs in zswap_writeback_entry()
has been removed from the -mm tree.  Its filename was
     mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

