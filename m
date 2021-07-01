Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01740C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82DF6105A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhGABze (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238501AbhGABze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D442B61468;
        Thu,  1 Jul 2021 01:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104385;
        bh=eYEx21DF4KneT+T4IkxLcj2uBlslKKRnWzc2TU2u6Z8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ggxm7ZGcS5lGzcj4UWczdGAAqwlVxz3UKhYvbG/oKlyioorewaV0lMXS446j+wgeM
         vzHm21xIF5jKXDKR234z8HRe2u6K2M8t4WfDC8QNvAZ7y/p1Q7gCY/TFAwQP9hTuSF
         oI47TlC/6aHYzfqKGyyjQtb9FRSEML8dgRLf+58g=
Date:   Wed, 30 Jun 2021 18:53:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        ngupta@vflare.org, senozhatsky@chromium.org,
        torvalds@linux-foundation.org
Subject:  [patch 110/192] mm/zsmalloc.c: improve readability for
 async_free_zspage()
Message-ID: <20210701015304.6sZ8amjNt%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
