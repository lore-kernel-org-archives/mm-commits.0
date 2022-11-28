Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F52C4321E
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 21:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiK1Vjv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiK1Vju (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 16:39:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1712B618
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 13:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DEDCDCE1085
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 21:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6EBC433D7;
        Mon, 28 Nov 2022 21:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669671585;
        bh=Wl9jeM1pbDdr04CeJ15FZPczqwN26eNH5dzq24l6zs8=;
        h=Date:To:From:Subject:From;
        b=zg8z2KVixKtQcbGZ5FQdZwho9wSEH76QHECBa/vlzbEWob7HPD9XEO1pe8yaDlSB/
         3k6MXx0nupX49RFkTpo+XGvCYVcT3S1QQALMlLtxgkepd4JsXySepRGETlKhILN2Zo
         H0qrRh4J4Jtu9Jesl/DRXlZDmoEFIMFmbMtlxptQ=
Date:   Mon, 28 Nov 2022 13:39:44 -0800
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, ddstreet@ieee.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-fix-writeback-lock-ordering-for-zsmalloc.patch added to mm-unstable branch
Message-Id: <20221128213945.CD6EBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: fix writeback lock ordering for zsmalloc
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-fix-writeback-lock-ordering-for-zsmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-fix-writeback-lock-ordering-for-zsmalloc.patch

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
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch
zswap-fix-writeback-lock-ordering-for-zsmalloc.patch
zpool-clean-out-dead-code.patch

