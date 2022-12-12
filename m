Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB9C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiLLCOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiLLCNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99E3DED3
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69EF560EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38ADC433EF;
        Mon, 12 Dec 2022 02:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811228;
        bh=P1wQ8QWWX54UZlEl/7XkHth2rXSa4bZ+RGausuKmRe0=;
        h=Date:To:From:Subject:From;
        b=fAVu65m48EDieXU+6QMSEEL3jYv6FjPwltUHopeTRxpENTPg+m6bzXGNPfJ0yzWz1
         nNXVbBhTLbNZMOT10Q2yGNIu4lGalEKyXAUvvM9yn/8tH60WhxM8jQMQb6ppYCKzNx
         71tLQjAehoVhFSeN8Z+UQjRMnmQ4Y34InP9wrJbU=
Date:   Sun, 11 Dec 2022 18:13:48 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, ddstreet@ieee.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zswap-fix-writeback-lock-ordering-for-zsmalloc.patch removed from -mm tree
Message-Id: <20221212021348.C38ADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap: fix writeback lock ordering for zsmalloc
has been removed from the -mm tree.  Its filename was
     zswap-fix-writeback-lock-ordering-for-zsmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: zswap: fix writeback lock ordering for zsmalloc
Date: Mon, 28 Nov 2022 11:16:10 -0800

Patch series "Implement writeback for zsmalloc", v7.

Unlike other zswap allocators such as zbud or z3fold, zsmalloc currently
lacks the writeback mechanism.  This means that when the zswap pool is
full, it will simply reject further allocations, and the pages will be
written directly to swap.

This series of patches implements writeback for zsmalloc. When the zswap
pool becomes full, zsmalloc will attempt to evict all the compressed
objects in the least-recently used zspages.


This patch (of 6):

zswap's customary lock order is tree->lock before pool->lock, because the
tree->lock protects the entries' refcount, and the free callbacks in the
backends acquire their respective pool locks to dispatch the backing
object.  zsmalloc's map callback takes the pool lock, so zswap must not
grab the tree->lock while a handle is mapped.  This currently only happens
during writeback, which isn't implemented for zsmalloc.  In preparation
for it, move the tree->lock section out of the mapped entry section

Link: https://lkml.kernel.org/r/20221128191616.1261026-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20221128191616.1261026-2-nphamcs@gmail.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/zswap.c~zswap-fix-writeback-lock-ordering-for-zsmalloc
+++ a/mm/zswap.c
@@ -968,6 +968,7 @@ static int zswap_writeback_entry(struct
 	swpentry = zhdr->swpentry; /* here */
 	tree = zswap_trees[swp_type(swpentry)];
 	offset = swp_offset(swpentry);
+	zpool_unmap_handle(pool, handle);
 
 	/* find and ref zswap entry */
 	spin_lock(&tree->lock);
@@ -975,20 +976,12 @@ static int zswap_writeback_entry(struct
 	if (!entry) {
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
-		zpool_unmap_handle(pool, handle);
 		kfree(tmp);
 		return 0;
 	}
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
-	src = (u8 *)zhdr + sizeof(struct zswap_header);
-	if (!zpool_can_sleep_mapped(pool)) {
-		memcpy(tmp, src, entry->length);
-		src = tmp;
-		zpool_unmap_handle(pool, handle);
-	}
-
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
 	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
@@ -1006,6 +999,14 @@ static int zswap_writeback_entry(struct
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 		dlen = PAGE_SIZE;
 
+		zhdr = zpool_map_handle(pool, handle, ZPOOL_MM_RO);
+		src = (u8 *)zhdr + sizeof(struct zswap_header);
+		if (!zpool_can_sleep_mapped(pool)) {
+			memcpy(tmp, src, entry->length);
+			src = tmp;
+			zpool_unmap_handle(pool, handle);
+		}
+
 		mutex_lock(acomp_ctx->mutex);
 		sg_init_one(&input, src, entry->length);
 		sg_init_table(&output, 1);
@@ -1015,6 +1016,11 @@ static int zswap_writeback_entry(struct
 		dlen = acomp_ctx->req->dlen;
 		mutex_unlock(acomp_ctx->mutex);
 
+		if (!zpool_can_sleep_mapped(pool))
+			kfree(tmp);
+		else
+			zpool_unmap_handle(pool, handle);
+
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -1045,7 +1051,11 @@ static int zswap_writeback_entry(struct
 		zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	goto end;
+	return ret;
+
+fail:
+	if (!zpool_can_sleep_mapped(pool))
+		kfree(tmp);
 
 	/*
 	* if we get here due to ZSWAP_SWAPCACHE_EXIST
@@ -1054,17 +1064,10 @@ static int zswap_writeback_entry(struct
 	* if we free the entry in the following put
 	* it is also okay to return !0
 	*/
-fail:
 	spin_lock(&tree->lock);
 	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-end:
-	if (zpool_can_sleep_mapped(pool))
-		zpool_unmap_handle(pool, handle);
-	else
-		kfree(tmp);
-
 	return ret;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


