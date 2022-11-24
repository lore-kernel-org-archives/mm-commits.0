Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD92C352A1
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 03:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiKXDoz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiKXDox (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 22:44:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CFD5F54
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62BD361FAF
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 03:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68A4C433C1;
        Thu, 24 Nov 2022 03:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669261491;
        bh=ytCLqlMoxVnMs0ZMSIknUWdY9aPb2XzkZW6faXt6DRk=;
        h=Date:To:From:Subject:From;
        b=og99E06cltYmSwZVcaEnzrb952CoU6iir5zKX+uurmgbfme82NfTdGpSrt9F0ajd0
         Jp5VeaW8V2eYuPi01ZWFi8umuq10X8rNh9MNhkWHezBFYeksAaV5tibwBixkQZ71lr
         JgT8hdgtBZO0Do6qAGQI7wayp5UCBG/o+rW+/Wsw=
Date:   Wed, 23 Nov 2022 19:44:50 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch removed from -mm tree
Message-Id: <20221124034451.B68A4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: add zpool_ops field to zs_pool to store evict handlers
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zsmalloc: add zpool_ops field to zs_pool to store evict handlers
Date: Fri, 18 Nov 2022 16:15:35 -0800

This adds a new field to zs_pool to store evict handlers for writeback,
analogous to the zbud allocator.

Link: https://lkml.kernel.org/r/20221119001536.2086599-6-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

