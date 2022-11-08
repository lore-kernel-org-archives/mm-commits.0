Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15EAC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 20:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKHUDS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 15:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiKHUDQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 15:03:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4668294
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 12:03:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46F0D6176A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0425C433C1;
        Tue,  8 Nov 2022 20:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667937794;
        bh=BuRLNHqLjxsyBvtNm3mL9CkUEH3+Kb6AGG8tWW1NwwQ=;
        h=Date:To:From:Subject:From;
        b=WlOaO4aTFcNDuNPEqJ6pRKCU02/Yrbd3IqL9r5n9WzP3pNRJzKfFD5dMCT++7+9ZU
         39zuSrhD87TY+d7rn3PB1TXBb6sv+Uu/fKRjoKfU53KB3Abr9m7G9sUsV6GMywqN+O
         lgmGt+7AfhNbTlsHb2LjnfWTMY6ry6NU+Rutq6OA=
Date:   Tue, 08 Nov 2022 12:03:14 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch added to mm-unstable branch
Message-Id: <20221108200314.A0425C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add ops fields to zs_pool to store evict handlers
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch

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
Subject: zsmalloc: add ops fields to zs_pool to store evict handlers
Date: Tue, 8 Nov 2022 11:32:06 -0800

This adds fields to zs_pool to store evict handlers for writeback,
analogous to the zbud allocator.

Link: https://lkml.kernel.org/r/20221108193207.3297327-5-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers
+++ a/mm/zsmalloc.c
@@ -213,6 +213,12 @@ struct link_free {
 	};
 };
 
+struct zs_pool;
+
+struct zs_ops {
+	int (*evict)(struct zs_pool *pool, unsigned long handle);
+};
+
 struct zs_pool {
 	const char *name;
 
@@ -234,6 +240,12 @@ struct zs_pool {
 	/* List tracking the zspages in LRU order by most recently added object */
 	struct list_head lru;
 
+#ifdef CONFIG_ZPOOL
+	const struct zs_ops *ops;
+	struct zpool *zpool;
+	const struct zpool_ops *zpool_ops;
+#endif
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -371,6 +383,18 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
+static int zs_zpool_evict(struct zs_pool *pool, unsigned long handle)
+{
+	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
+		return pool->zpool_ops->evict(pool->zpool, handle);
+	else
+		return -ENOENT;
+}
+
+static const struct zs_ops zs_zpool_ops = {
+	.evict =	zs_zpool_evict
+};
+
 static void *zs_zpool_create(const char *name, gfp_t gfp,
 			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
@@ -380,7 +404,20 @@ static void *zs_zpool_create(const char
 	 * different contexts and its caller must provide a valid
 	 * gfp mask.
 	 */
-	return zs_create_pool(name, ZS_DEFAULT_PAGES_PER_ZSPAGE);
+	struct zs_pool *pool;
+
+	pool = zs_create_pool(name, ZS_DEFAULT_PAGES_PER_ZSPAGE);
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+
+		if (zpool_ops)
+			pool->ops = &zs_zpool_ops;
+		else
+			pool->ops = NULL;
+	}
+
+	return pool;
 }
 
 static void zs_zpool_destroy(void *pool)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-ops-fields-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

