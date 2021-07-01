Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB59C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 027CF61481
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhGABzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C89736147D;
        Thu,  1 Jul 2021 01:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104373;
        bh=AuzkxrQVo8R8WrkG+pnqM9i67wekf2KlHU1uS/jlPIQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ILKSKGVsyj+9F1ktVGspZpsLsZByqik1j2gsFNLJ7U36WhN6so7MioOUsb8Rl9fhF
         4jDcx2oCqcaLn6Pii3r+2283ioLqTWbHbSOYHyyKvuugtZLSObWv24fkue9bXD2HtS
         hYZuMTN0FK1JbCaMnBovKWmM/7jIyP6uJe8065cA=
Date:   Wed, 30 Jun 2021 18:52:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        colin.king@canonical.com, ddstreet@ieee.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        sjenning@redhat.com, tiantao6@hisilicon.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com
Subject:  [patch 106/192] mm/zswap.c: avoid unnecessary copy-in at
 map time
Message-ID: <20210701015252.gEmynGXv0%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
