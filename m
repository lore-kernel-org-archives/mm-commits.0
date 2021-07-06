Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38341C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BCC61C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhGFTXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhGFTXL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7164B61C9A;
        Tue,  6 Jul 2021 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599232;
        bh=+Jcxgwosb4bBKo4M7EFwWecEwYRaFSyQv49K1PB9hiE=;
        h=Date:From:To:Subject:From;
        b=bSfVVbDA9TjzTCRCA7gOIWru3XRawB7aq1vMR1xZsSMNim50hD5OIiQoHGwshs5EV
         M2zGssD41yvV/lT8L61inLQjvSuyJyxJa8rRk5U+60uEdxE9i7Sytr/vh52MhnsMTK
         OXhd0qJdh0yvQQvNRy/n2iPBn0iZ23lgjfQQsU7w=
Date:   Tue, 06 Jul 2021 12:20:32 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  [merged]
 mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch removed from -mm tree
Message-ID: <20210706192032.NvT8zLXxJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: avoid unnecessary copy-in at map time
has been removed from the -mm tree.  Its filename was
     mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

