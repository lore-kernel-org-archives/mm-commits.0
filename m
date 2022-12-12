Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D15FC10F1E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiLLCOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiLLCN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE8463F3
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF2C0B80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA8C433EF;
        Mon, 12 Dec 2022 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811234;
        bh=sAAqCYPkDZ7j9RaAFwwOIQ9PvefnR3LjgiQ+0GHL0AM=;
        h=Date:To:From:Subject:From;
        b=cEzZfhD/oLFrvO48Wk/g7rc5VciB9oLwNYyDlKJD3U7KT0kVDev9RdLLHnya/+In/
         NfOt93iwDLMUKe0E5vgiYPVGMrLRiOh5XnoYKymIPETCyribqLPTZK8mjChp59JHpP
         9NVlnL9LIMtvPbpxkyWwADqiL4RDnkg07ynFtXYU=
Date:   Sun, 11 Dec 2022 18:13:53 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch removed from -mm tree
Message-Id: <20221212021354.81FA8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add zpool_ops field to zs_pool to store evict handlers
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add zpool_ops field to zs_pool to store evict handlers
Date: Mon, 28 Nov 2022 11:16:14 -0800

This adds a new field to zs_pool to store evict handlers for writeback,
analogous to the zbud allocator.

Link: https://lkml.kernel.org/r/20221128191616.1261026-6-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers
+++ a/mm/zsmalloc.c
@@ -242,6 +242,8 @@ struct zs_pool {
 #ifdef CONFIG_ZPOOL
 	/* List tracking the zspages in LRU order by most recently added object */
 	struct list_head lru;
+	struct zpool *zpool;
+	const struct zpool_ops *zpool_ops;
 #endif
 
 #ifdef CONFIG_ZSMALLOC_STAT
@@ -382,7 +384,14 @@ static void *zs_zpool_create(const char
 	 * different contexts and its caller must provide a valid
 	 * gfp mask.
 	 */
-	return zs_create_pool(name);
+	struct zs_pool *pool = zs_create_pool(name);
+
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+	}
+
+	return pool;
 }
 
 static void zs_zpool_destroy(void *pool)
_

Patches currently in -mm which might be from nphamcs@gmail.com are


