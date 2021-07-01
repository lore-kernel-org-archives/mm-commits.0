Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFE3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6D561477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhGABz0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4186105A;
        Thu,  1 Jul 2021 01:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104376;
        bh=6MWdX56fY3D94DuzhXP11oAIC2y/aPv8BRRKi5jD3bA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kQRCOUQ5EWJ7OZjQPf4cCk1xaALDzsKIr5GQTW5tIWdPTyzUhTUiRdpjEISKzzKBn
         Okm9eHf9aDgqpqVjgQ0wHkB6+jd28tA4E5pzCEYULp+ZvRalTWuLCTqB2PzklkhCF8
         70Jllkk5+JduW7BgWFWVJJW7V5WHGx7gAgnFrNj4=
Date:   Wed, 30 Jun 2021 18:52:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        colin.king@canonical.com, ddstreet@ieee.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        sjenning@redhat.com, tiantao6@hisilicon.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 107/192] mm/zswap.c: fix two bugs in
 zswap_writeback_entry()
Message-ID: <20210701015255.wWKmg3P-p%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
