Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F907C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGQAoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQAoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:44:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C141511153
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69D96B80D22
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D7DC3411C;
        Sun, 17 Jul 2022 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018657;
        bh=GHXht3wd+p8WNHLtlBplAazJoCeSakviorb6PZbJdlI=;
        h=Date:To:From:Subject:From;
        b=m2LkVO7l5N6w8JUsEDPfMrnalmDYb7Y2Tv1RTPCA6q3zZLaywRNG04ZPOS9e7Z/FO
         m6DPa7SZsUQvJaQhaXKa8drGp15+vNA1ftyTdUaRF5NQ4KCmBQJYlM+gDmajuIpXZa
         uVYxEQe7TwRfhlKXKpz8jF6sBrJG9wSnXUYpP1dQ=
Date:   Sat, 16 Jul 2022 17:44:16 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, axboe@kernel.dk,
        teawater@antgroup.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_malloc-return-err_ptr-if-fail.patch added to mm-unstable branch
Message-Id: <20220717004417.17D7DC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zs_malloc: return ERR_PTR on failure
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zs_malloc-return-err_ptr-if-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_malloc-return-err_ptr-if-fail.patch

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

zsmalloc-zs_malloc-return-err_ptr-if-fail.patch

