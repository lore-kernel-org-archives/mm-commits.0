Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2BCC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiKWTdI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239030AbiKWTcz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:32:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294EA11474
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:32:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0B0161ED3
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D4AC433C1;
        Wed, 23 Nov 2022 19:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669231970;
        bh=IH4mIO5YqgVlWolUYY+DwDVkjaKo8UQKrervpVHCNoY=;
        h=Date:To:From:Subject:From;
        b=zWEx8zW2iIbDc9Hh6gUbB+V1mx6vvSYkdOhe+lG3QmEDwBp1/36s5+vOtabGQajfg
         rGBqCuC6LIf7iJqer8lYj4T9xE5kI3kQAwgmCjJVbAvl99r5CabyqwwqgCPdS/c9sp
         exr/su1iYoWetfSTiAqkgX+XP2b/p+b1FJycsFGA=
Date:   Wed, 23 Nov 2022 11:32:49 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        hannes@cmpxchg.org, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch added to mm-unstable branch
Message-Id: <20221123193250.11D4AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order (fix)
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order (fix)
Date: Wed, 23 Nov 2022 11:17:02 -0800

Add a comment explaining the mapping check for LRU update.

Link: https://lkml.kernel.org/r/20221123191703.2902079-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix
+++ a/mm/zsmalloc.c
@@ -1289,7 +1289,23 @@ void *zs_map_object(struct zs_pool *pool
 	zspage = get_zspage(page);
 
 #ifdef CONFIG_ZPOOL
-	/* Move the zspage to front of pool's LRU */
+	/*
+	 * Move the zspage to front of pool's LRU.
+	 *
+	 * Note that this is swap-specific, so by definition there are no ongoing
+	 * accesses to the memory while the page is swapped out that would make
+	 * it "hot". A new entry is hot, then ages to the tail until it gets either
+	 * written back or swaps back in.
+	 *
+	 * Furthermore, map is also called during writeback. We must not put an
+	 * isolated page on the LRU mid-reclaim.
+	 *
+	 * As a result, only update the LRU when the page is mapped for write
+	 * when it's first instantiated.
+	 *
+	 * This is a deviation from the other backends, which perform this update
+	 * in the allocation function (zbud_alloc, z3fold_alloc).
+	 */
 	if (mm == ZS_MM_WO) {
 		if (!list_empty(&zspage->lru))
 			list_del(&zspage->lru);
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

