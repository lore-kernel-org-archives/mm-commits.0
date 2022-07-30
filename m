Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CF8C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiG3BIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbiG3BIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BB1820F4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0983761C50
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B902C433D6;
        Sat, 30 Jul 2022 01:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143303;
        bh=epzeoL0YjLsTL7Oc6IgvOfE/uZLQAt8DtE/moywtD38=;
        h=Date:To:From:Subject:From;
        b=qvy8a5rNLmhaVDWUEaW3X7H+Z4nn57P/X19CXtR0yPVTma9sucoPTH89est+vB5Sp
         u75I/PHLW4P8A8ulbvNJUtP6UJJwRYmpbTe7KP78PC+Mm6vdYjje4k23HPiX0EWm9r
         Pes+Mz6CsoxQM1J9RyK2gBj44hAv/Z7b6Dl/gr9s=
Date:   Fri, 29 Jul 2022 18:08:22 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, axboe@kernel.dk,
        teawater@antgroup.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-zs_malloc-return-err_ptr-if-fail.patch removed from -mm tree
Message-Id: <20220730010823.5B902C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: zs_malloc: return ERR_PTR on failure
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_malloc-return-err_ptr-if-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <teawater@antgroup.com>
Subject: zsmalloc: zs_malloc: return ERR_PTR on failure
Date: Thu, 14 Jul 2022 16:07:57 +0800

zs_malloc returns 0 if it fails.  zs_zpool_malloc will return -1 when
zs_malloc return 0.  But -1 makes the return value unclear.

For example, when zswap_frontswap_store calls zs_malloc through
zs_zpool_malloc, it will return -1 to its caller.  The other return value
is -EINVAL, -ENODEV or something else.

This commit changes zs_malloc to return ERR_PTR on failure.  It didn't
just let zs_zpool_malloc return -ENOMEM becaue zs_malloc has two types of
failure:

- size is not OK return -EINVAL
- memory alloc fail return -ENOMEM.

Link: https://lkml.kernel.org/r/20220714080757.12161-1-teawater@gmail.com
Signed-off-by: Hui Zhu <teawater@antgroup.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 mm/zsmalloc.c                 |   13 ++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zsmalloc-zs_malloc-return-err_ptr-if-fail
+++ a/drivers/block/zram/zram_drv.c
@@ -1389,9 +1389,9 @@ static int __zram_bvec_write(struct zram
 			__GFP_HIGHMEM |
 			__GFP_MOVABLE);
 
-	if (unlikely(!handle)) {
+	if (IS_ERR((void *)handle)) {
 		zcomp_stream_put(zram->comp);
-		return -ENOMEM;
+		return PTR_ERR((void *)handle);
 	}
 
 	alloced_pages = zs_get_total_pages(zram->mem_pool);
--- a/mm/zsmalloc.c~zsmalloc-zs_malloc-return-err_ptr-if-fail
+++ a/mm/zsmalloc.c
@@ -399,7 +399,10 @@ static int zs_zpool_malloc(void *pool, s
 			unsigned long *handle)
 {
 	*handle = zs_malloc(pool, size, gfp);
-	return *handle ? 0 : -1;
+
+	if (IS_ERR((void *)(*handle)))
+		return PTR_ERR((void *)*handle);
+	return 0;
 }
 static void zs_zpool_free(void *pool, unsigned long handle)
 {
@@ -1400,7 +1403,7 @@ static unsigned long obj_malloc(struct z
  * @gfp: gfp flags when allocating object
  *
  * On success, handle to the allocated object is returned,
- * otherwise 0.
+ * otherwise an ERR_PTR().
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
@@ -1411,11 +1414,11 @@ unsigned long zs_malloc(struct zs_pool *
 	struct zspage *zspage;
 
 	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
-		return 0;
+		return (unsigned long)ERR_PTR(-EINVAL);
 
 	handle = cache_alloc_handle(pool, gfp);
 	if (!handle)
-		return 0;
+		return (unsigned long)ERR_PTR(-ENOMEM);
 
 	/* extra space in chunk to keep the handle */
 	size += ZS_HANDLE_SIZE;
@@ -1440,7 +1443,7 @@ unsigned long zs_malloc(struct zs_pool *
 	zspage = alloc_zspage(pool, class, gfp);
 	if (!zspage) {
 		cache_free_handle(pool, handle);
-		return 0;
+		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
 	spin_lock(&class->lock);
_

Patches currently in -mm which might be from teawater@antgroup.com are


