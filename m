Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BCA1EB31
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E02279ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F10C433C8;
	Wed, 13 Dec 2023 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702499662;
	bh=Q5nEo79Sp1GRR7J8X4NjaZZysXdoVUbZhbayAHmhWi0=;
	h=Date:To:From:Subject:From;
	b=E02279caQdu2cBjCHRKZu5s4BD/PNDTcJwrvazxxg298hOeRkFABCB2Mp5eEmn55F
	 xdiNpJRLYuZ0F5wb7ieBHC4ZAB2TVWHk5nMA49o61KkeZIjiRWcz48CoSQEyn09tp4
	 c/0xCZFErCNObxJr7AfuyEzPkKCdp+LiMXKIVrqw=
Date: Wed, 13 Dec 2023 12:34:21 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-refactor-out-__zswap_load.patch added to mm-unstable branch
Message-Id: <20231213203421.E7F10C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: refactor out __zswap_load()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-refactor-out-__zswap_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-refactor-out-__zswap_load.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: refactor out __zswap_load()
Date: Wed, 13 Dec 2023 04:18:00 +0000

zswap_load() and zswap_writeback_entry() have the same part that
decompress the data from zswap_entry to page, so refactor out the common
part as __zswap_load(entry, page).

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v1-3-896763369d04@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chriscli@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  107 ++++++++++++++++++---------------------------------
 1 file changed, 38 insertions(+), 69 deletions(-)

--- a/mm/zswap.c~mm-zswap-refactor-out-__zswap_load
+++ a/mm/zswap.c
@@ -1392,6 +1392,41 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
+static void __zswap_load(struct zswap_entry *entry, struct page *page)
+{
+	struct scatterlist input, output;
+	unsigned int dlen = PAGE_SIZE;
+	struct crypto_acomp_ctx *acomp_ctx;
+	struct zpool *zpool;
+	u8 *src;
+	int ret;
+
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(acomp_ctx->mutex);
+
+	zpool = zswap_find_zpool(entry);
+	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
+	if (!zpool_can_sleep_mapped(zpool)) {
+		memcpy(acomp_ctx->dstmem, src, entry->length);
+		src = acomp_ctx->dstmem;
+		zpool_unmap_handle(zpool, entry->handle);
+	}
+
+	sg_init_one(&input, src, entry->length);
+	sg_init_table(&output, 1);
+	sg_set_page(&output, page, PAGE_SIZE, 0);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	mutex_unlock(acomp_ctx->mutex);
+
+	if (zpool_can_sleep_mapped(zpool))
+		zpool_unmap_handle(zpool, entry->handle);
+
+	BUG_ON(ret);
+	BUG_ON(dlen != PAGE_SIZE);
+}
+
 /*********************************
 * writeback code
 **********************************/
@@ -1413,23 +1448,12 @@ static int zswap_writeback_entry(struct
 	swp_entry_t swpentry = entry->swpentry;
 	struct page *page;
 	struct mempolicy *mpol;
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct zpool *pool = zswap_find_zpool(entry);
 	bool page_was_allocated;
-	u8 *src, *tmp = NULL;
-	unsigned int dlen;
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
 
-	if (!zpool_can_sleep_mapped(pool)) {
-		tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!tmp)
-			return -ENOMEM;
-	}
-
 	/* try to allocate swap cache page */
 	mpol = get_task_policy(current);
 	page = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
@@ -1462,33 +1486,7 @@ static int zswap_writeback_entry(struct
 	}
 	spin_unlock(&tree->lock);
 
-	/* decompress */
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	dlen = PAGE_SIZE;
-
-	src = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(pool)) {
-		memcpy(tmp, src, entry->length);
-		src = tmp;
-		zpool_unmap_handle(pool, entry->handle);
-	}
-
-	mutex_lock(acomp_ctx->mutex);
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
-	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-	mutex_unlock(acomp_ctx->mutex);
-
-	if (!zpool_can_sleep_mapped(pool))
-		kfree(tmp);
-	else
-		zpool_unmap_handle(pool, entry->handle);
-
-	BUG_ON(ret);
-	BUG_ON(dlen != PAGE_SIZE);
+	__zswap_load(entry, page);
 
 	/* page is up to date */
 	SetPageUptodate(page);
@@ -1503,9 +1501,6 @@ static int zswap_writeback_entry(struct
 	return ret;
 
 fail:
-	if (!zpool_can_sleep_mapped(pool))
-		kfree(tmp);
-
 	/*
 	 * If we get here because the page is already in swapcache, a
 	 * load may be happening concurrently. It is safe and okay to
@@ -1764,11 +1759,7 @@ bool zswap_load(struct folio *folio)
 	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
-	unsigned int dlen = PAGE_SIZE;
-	u8 *src, *dst;
-	struct zpool *zpool;
+	u8 *dst;
 	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1790,29 +1781,7 @@ bool zswap_load(struct folio *folio)
 		goto stats;
 	}
 
-	/* decompress */
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	mutex_lock(acomp_ctx->mutex);
-
-	zpool = zswap_find_zpool(entry);
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(zpool)) {
-		memcpy(acomp_ctx->dstmem, src, entry->length);
-		src = acomp_ctx->dstmem;
-		zpool_unmap_handle(zpool, entry->handle);
-	}
-
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
-	if (crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait))
-		WARN_ON(1);
-	mutex_unlock(acomp_ctx->mutex);
-
-	if (zpool_can_sleep_mapped(zpool))
-		zpool_unmap_handle(zpool, entry->handle);
-
+	__zswap_load(entry, page);
 	ret = true;
 stats:
 	count_vm_event(ZSWPIN);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_reclaim_entry.patch

