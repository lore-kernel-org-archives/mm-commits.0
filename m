Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98334C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83C7861362
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhKEUrp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhKEUro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D0C6136F;
        Fri,  5 Nov 2021 20:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145104;
        bh=CdHMF4pxm2GhLSh8VjYZRSZM1GSBQRNTbC6EcG4WsYI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UrwAWra0MwwPZA9wxDW8fTNgXS6x89ectA9lcuSUaRjHkFTWavWaKVlL7H8sRQppJ
         yJ/bhqFLUOU5z/pUg/Xkak0qt97+LkJntuS05xo4re2iktjhW010zST6dBfyUSiiSU
         nSMQ+sUt398MgDhCglfCzdQGxR3fAy9jPqkKgIWM=
Date:   Fri, 05 Nov 2021 13:45:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, henryburns@google.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        torvalds@linux-foundation.org
Subject:  [patch 198/262] mm/zsmalloc.c: close race window between
 zs_pool_dec_isolated() and zs_unregister_migration()
Message-ID: <20211105204503.cVz6sXG8I%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()

There is one possible race window between zs_pool_dec_isolated() and
zs_unregister_migration() because wait_for_isolated_drain() checks the
isolated count without holding class->lock and there is no order inside
zs_pool_dec_isolated().  Thus the below race window could be possible:

zs_pool_dec_isolated		zs_unregister_migration
  check pool->destroying != 0
				  pool->destroying = true;
				  smp_mb();
				  wait_for_isolated_drain()
				    wait for pool->isolated_pages == 0
  atomic_long_dec(&pool->isolated_pages);
  atomic_long_read(&pool->isolated_pages) == 0

Since we observe the pool->destroying (false) before atomic_long_dec() for
pool->isolated_pages, waking pool->migration_wait up is missed.

Fix this by ensure checking pool->destroying happens after the
atomic_long_dec(&pool->isolated_pages).

Link: https://lkml.kernel.org/r/20210708115027.7557-1-linmiaohe@huawei.com
Fixes: 701d678599d0 ("mm/zsmalloc.c: fix race condition in zs_destroy_pool")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Henry Burns <henryburns@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration
+++ a/mm/zsmalloc.c
@@ -1830,10 +1830,11 @@ static inline void zs_pool_dec_isolated(
 	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
 	atomic_long_dec(&pool->isolated_pages);
 	/*
-	 * There's no possibility of racing, since wait_for_isolated_drain()
-	 * checks the isolated count under &class->lock after enqueuing
-	 * on migration_wait.
+	 * Checking pool->destroying must happen after atomic_long_dec()
+	 * for pool->isolated_pages above. Paired with the smp_mb() in
+	 * zs_unregister_migration().
 	 */
+	smp_mb__after_atomic();
 	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
 		wake_up_all(&pool->migration_wait);
 }
_
