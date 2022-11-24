Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C168C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 03:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKXDnd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiKXDnS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 22:43:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D167654DE
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D53A1B8269E
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 03:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F30C433C1;
        Thu, 24 Nov 2022 03:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669261394;
        bh=A4AbJjekZmvSpvjBlIGQozdt3rZ1eV3Q9bQu3C3H1Bo=;
        h=Date:To:From:Subject:From;
        b=2fpHuptmk55K6pq4GeIjNU49T+CWWBIhZ7ESR1ujlcaYLdmEleTx1zw701vFEhgss
         8Jw5mUuu5elwqN4o1kV0uSu/GEHGIOUaRGsL1xsXXmI187sYjcjHKoA6Ye/m4M4xeY
         FUQXgXt4+oqCefhfBMDhgyiI5vzY1BhHlc4cV4QE=
Date:   Wed, 23 Nov 2022 19:43:13 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        hannes@cmpxchg.org, nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch removed from -mm tree
Message-Id: <20221124034314.81F30C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add a LRU to zs_pool to keep track of zspages in LRU order (fix)
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order-fix.patch

This patch was dropped because it was folded into zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch

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
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc-fix.patch

