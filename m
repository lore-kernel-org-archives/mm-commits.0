Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D51C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0198861872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhKKCul (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhKKCul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D2AC61108;
        Thu, 11 Nov 2021 02:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598872;
        bh=8jUOwHQPWn1tA24mm7TnWknfG8YcRlFj/MyMCF3LXjo=;
        h=Date:From:To:Subject:From;
        b=Z3+OvpPbPcRCNZODA4hEUW8VFbeOP3+YBYTLSLzQzKp9/awxlyV7LRd53LMprTt+G
         eTvH1qKftWHRLNEvltH9VIYV5afp2JdT2eL+ZfhKjuol2wnsBl0g7v+qri1cQI0K0y
         /vFE6IlaumR5fLm4u0Y3fLkdOOzGn3/zb7JOTz14=
Date:   Wed, 10 Nov 2021 18:47:52 -0800
From:   akpm@linux-foundation.org
To:     henryburns@google.com, linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, senozhatsky@chromium.org
Subject:  [merged]
 =?US-ASCII?Q?mm-zsmallocc-close-race-window-between-zs=5Fpool=5Fdec=5Fis?=
 =?US-ASCII?Q?olated-and-zs=5Funregister=5Fmigration.patch?= removed from
 -mm tree
Message-ID: <20211111024752.nhnZLctbj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: close race window between zs_pool_dec_isolated() and zs_unregister_migration()
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


