Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9801CC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA3361C9D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhGFTXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6865161C9E;
        Tue,  6 Jul 2021 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599238;
        bh=OEUjms4esUC4B57D+dGLqrRxqM/OYLFsHJuNlcIAv30=;
        h=Date:From:To:Subject:From;
        b=sjmCpuaW5piQjwqsRcRaZzs8R5j6Im2fOHZ1L3RTNrNmvcHUg6ZHNqPalhNtEoJDR
         jd11hNPIl4OR69i2plHaa7zDVIvURGS1El0t2tvIMVPg5pQI6QTmkLnT3VADxFkCqr
         mK4sseW9N5WYAuxknIApWHhCWXVWAuvcaraJD3qo=
Date:   Tue, 06 Jul 2021 12:20:38 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  [merged]
 mm-zsmallocc-improve-readability-for-async_free_zspage.patch removed from
 -mm tree
Message-ID: <20210706192038.l8WXTjAOT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: improve readability for async_free_zspage()
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-improve-readability-for-async_free_zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: improve readability for async_free_zspage()

The class is extracted from pool->size_class[class_idx] again before
calling __free_zspage().  It looks like class will change after we fetch
the class lock.  But this is misleading as class will stay unchanged.

Link: https://lkml.kernel.org/r/20210624123930.1769093-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-improve-readability-for-async_free_zspage
+++ a/mm/zsmalloc.c
@@ -2162,7 +2162,7 @@ static void async_free_zspage(struct wor
 		VM_BUG_ON(fullness != ZS_EMPTY);
 		class = pool->size_class[class_idx];
 		spin_lock(&class->lock);
-		__free_zspage(pool, pool->size_class[class_idx], zspage);
+		__free_zspage(pool, class, zspage);
 		spin_unlock(&class->lock);
 	}
 };
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

