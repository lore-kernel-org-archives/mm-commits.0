Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A97C001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjG0Qcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjG0Qcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAEB30FB
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 09:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9478E61ED5
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 16:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7945C433C7;
        Thu, 27 Jul 2023 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690475493;
        bh=H0k047Ngk/hCNOuc+NONt4gRQ+st4sgfUI4qYpqiLvQ=;
        h=Date:To:From:Subject:From;
        b=HZmxS6UbTg8a22sF9MwxDVC0GQiPsEHAZhtHSIbnvJZRuS10ft47qzSsmwZYn2nUt
         otruTEuBgcJ/PY/21gbE6YB0Pk2Jv686CMkFwX6gKhvuz/78Hg2//l+lZ/Z/BkUeQQ
         WTCJstJmwoplsx4w3IEVjZNHHd1IHFr3WHuW42TY=
Date:   Thu, 27 Jul 2023 09:31:32 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, song.bao.hua@hisilicon.com,
        sjenning@redhat.com, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-kill-zswap_get_swap_cache_page.patch added to mm-unstable branch
Message-Id: <20230727163132.E7945C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: kill zswap_get_swap_cache_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-kill-zswap_get_swap_cache_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-kill-zswap_get_swap_cache_page.patch

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
Subject: mm: zswap: kill zswap_get_swap_cache_page()
Date: Thu, 27 Jul 2023 12:22:25 -0400

The __read_swap_cache_async() interface isn't more difficult to understand
than what the helper abstracts.  Save the indirection and a level of
indentation for the primary work of the writeback func.

Link: https://lkml.kernel.org/r/20230727162343.1415598-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>

Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  146 +++++++++++++++++++--------------------------------
 1 file changed, 55 insertions(+), 91 deletions(-)

--- a/mm/zswap.c~mm-zswap-kill-zswap_get_swap_cache_page
+++ a/mm/zswap.c
@@ -1039,43 +1039,6 @@ static int zswap_enabled_param_set(const
 /*********************************
 * writeback code
 **********************************/
-/* return enum for zswap_get_swap_cache_page */
-enum zswap_get_swap_ret {
-	ZSWAP_SWAPCACHE_NEW,
-	ZSWAP_SWAPCACHE_EXIST,
-	ZSWAP_SWAPCACHE_FAIL,
-};
-
-/*
- * zswap_get_swap_cache_page
- *
- * This is an adaption of read_swap_cache_async()
- *
- * This function tries to find a page with the given swap entry
- * in the swapper_space address space (the swap cache).  If the page
- * is found, it is returned in retpage.  Otherwise, a page is allocated,
- * added to the swap cache, and returned in retpage.
- *
- * If success, the swap cache page is returned in retpage
- * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
- * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated,
- *     the new page is added to swapcache and locked
- * Returns ZSWAP_SWAPCACHE_FAIL on error
- */
-static int zswap_get_swap_cache_page(swp_entry_t entry,
-				struct page **retpage)
-{
-	bool page_was_allocated;
-
-	*retpage = __read_swap_cache_async(entry, GFP_KERNEL,
-			NULL, 0, &page_was_allocated);
-	if (page_was_allocated)
-		return ZSWAP_SWAPCACHE_NEW;
-	if (!*retpage)
-		return ZSWAP_SWAPCACHE_FAIL;
-	return ZSWAP_SWAPCACHE_EXIST;
-}
-
 /*
  * Attempts to free an entry by adding a page to the swap cache,
  * decompressing the entry data into the page, and issuing a
@@ -1096,7 +1059,7 @@ static int zswap_writeback_entry(struct
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct zpool *pool = zswap_find_zpool(entry);
-
+	bool page_was_allocated;
 	u8 *src, *tmp = NULL;
 	unsigned int dlen;
 	int ret;
@@ -1111,66 +1074,67 @@ static int zswap_writeback_entry(struct
 	}
 
 	/* try to allocate swap cache page */
-	switch (zswap_get_swap_cache_page(swpentry, &page)) {
-	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
+	page = __read_swap_cache_async(swpentry, GFP_KERNEL, NULL, 0,
+				       &page_was_allocated);
+	if (!page) {
 		ret = -ENOMEM;
 		goto fail;
+	}
 
-	case ZSWAP_SWAPCACHE_EXIST:
-		/* page is already in the swap cache, ignore for now */
+	/* Found an existing page, we raced with load/swapin */
+	if (!page_was_allocated) {
 		put_page(page);
 		ret = -EEXIST;
 		goto fail;
+	}
 
-	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
-		/*
-		 * Having a local reference to the zswap entry doesn't exclude
-		 * swapping from invalidating and recycling the swap slot. Once
-		 * the swapcache is secured against concurrent swapping to and
-		 * from the slot, recheck that the entry is still current before
-		 * writing.
-		 */
-		spin_lock(&tree->lock);
-		if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
-			spin_unlock(&tree->lock);
-			delete_from_swap_cache(page_folio(page));
-			ret = -ENOMEM;
-			goto fail;
-		}
+	/*
+	 * Page is locked, and the swapcache is now secured against
+	 * concurrent swapping to and from the slot. Verify that the
+	 * swap entry hasn't been invalidated and recycled behind our
+	 * backs (our zswap_entry reference doesn't prevent that), to
+	 * avoid overwriting a new swap page with old compressed data.
+	 */
+	spin_lock(&tree->lock);
+	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
+		delete_from_swap_cache(page_folio(page));
+		ret = -ENOMEM;
+		goto fail;
+	}
+	spin_unlock(&tree->lock);
 
-		/* decompress */
-		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-		dlen = PAGE_SIZE;
-
-		src = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
-		if (!zpool_can_sleep_mapped(pool)) {
-			memcpy(tmp, src, entry->length);
-			src = tmp;
-			zpool_unmap_handle(pool, entry->handle);
-		}
-
-		mutex_lock(acomp_ctx->mutex);
-		sg_init_one(&input, src, entry->length);
-		sg_init_table(&output, 1);
-		sg_set_page(&output, page, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
-		ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-		dlen = acomp_ctx->req->dlen;
-		mutex_unlock(acomp_ctx->mutex);
-
-		if (!zpool_can_sleep_mapped(pool))
-			kfree(tmp);
-		else
-			zpool_unmap_handle(pool, entry->handle);
-
-		BUG_ON(ret);
-		BUG_ON(dlen != PAGE_SIZE);
+	/* decompress */
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	dlen = PAGE_SIZE;
 
-		/* page is up to date */
-		SetPageUptodate(page);
+	src = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
+	if (!zpool_can_sleep_mapped(pool)) {
+		memcpy(tmp, src, entry->length);
+		src = tmp;
+		zpool_unmap_handle(pool, entry->handle);
 	}
 
+	mutex_lock(acomp_ctx->mutex);
+	sg_init_one(&input, src, entry->length);
+	sg_init_table(&output, 1);
+	sg_set_page(&output, page, PAGE_SIZE, 0);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	mutex_unlock(acomp_ctx->mutex);
+
+	if (!zpool_can_sleep_mapped(pool))
+		kfree(tmp);
+	else
+		zpool_unmap_handle(pool, entry->handle);
+
+	BUG_ON(ret);
+	BUG_ON(dlen != PAGE_SIZE);
+
+	/* page is up to date */
+	SetPageUptodate(page);
+
 	/* move it to the tail of the inactive list after end_writeback */
 	SetPageReclaim(page);
 
@@ -1180,16 +1144,16 @@ static int zswap_writeback_entry(struct
 	zswap_written_back_pages++;
 
 	return ret;
+
 fail:
 	if (!zpool_can_sleep_mapped(pool))
 		kfree(tmp);
 
 	/*
-	* if we get here due to ZSWAP_SWAPCACHE_EXIST
-	* a load may be happening concurrently.
-	* it is safe and okay to not free the entry.
-	* it is also okay to return !0
-	*/
+	 * If we get here because the page is already in swapcache, a
+	 * load may be happening concurrently. It is safe and okay to
+	 * not free the entry. It is also okay to return !0.
+	 */
 	return ret;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch

