Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63D0C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiKUWgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiKUWgD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:36:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11466AECC
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D6B6B816D6
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514DBC433C1;
        Mon, 21 Nov 2022 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669070157;
        bh=a8+vkbkkxmyqwm32wzhlBMfFqebtuIwszoj+oFUr5rs=;
        h=Date:To:From:Subject:From;
        b=1uxi5j6NRxx4X1392eUommVSK8aYL/ATHm6RvTyD1XCRPZCFxjR8PS8OIsSGDDlmz
         oOUXBq6kKhTKb/ytj09L417HFRhE9QyFT8qdkbJGK9EO9kA+puFrPWvPCWc2v8aA2u
         YBgJpssxDmUs3Jyi6MqVemjUeX7I/Ft0Ei6KmEF0=
Date:   Mon, 21 Nov 2022 14:35:56 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        nphamcs@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch added to mm-unstable branch
Message-Id: <20221121223557.514DBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add zpool_ops field to zs_pool to store evict handlers
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch

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

zsmalloc-consolidate-zs_pools-migrate_lock-and-size_classs-locks.patch
zsmalloc-add-a-lru-to-zs_pool-to-keep-track-of-zspages-in-lru-order.patch
zsmalloc-add-zpool_ops-field-to-zs_pool-to-store-evict-handlers.patch
zsmalloc-implement-writeback-mechanism-for-zsmalloc.patch

