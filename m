Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163943C07
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560127; cv=none; b=cEczY3RAcjlwFLRMMZFfTlSkQn3FZijQDwwdfpF74ci2e7IXpVbKKq7y+WqAZ4abxO1Tp8TqLOyvup16ECZBOzpEjNdvnGSX3L9HXKerEbWs+VGOBD1lZ3EQg4uinouvZNSNtqd8LGuGsUX0IuafJrL0UutOCOQceWVB9GsHC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560127; c=relaxed/simple;
	bh=mh7krcQnU33SuhlTmNBUCwVmCTu5vypmfj9IsbDK+Rk=;
	h=Date:To:From:Subject:Message-Id; b=CPPXIBpklZ+F0F/a9dp75OydcDzyRChDVecxxSa/mYnzN5ZnS9GU5KsM9JcQgGeMPFvuj+F1VM9uvXoEcRKAzPDrZUdXMvQHd3Jq5E25gfhA1tnY5TcykZ7ACdvWmBE1IjbgXv2hcQ3p5Iuk8tOkUZBHsB8JJsU61mSTuJlR6Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pa312o8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pa312o8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBB5C43394;
	Thu, 22 Feb 2024 00:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560127;
	bh=mh7krcQnU33SuhlTmNBUCwVmCTu5vypmfj9IsbDK+Rk=;
	h=Date:To:From:Subject:From;
	b=pa312o8s6wjmcDiIiA3rGlokQdMYExWDBVRO1MGMz6gj3vupmcwHo3QAXcc3y3CE1
	 dgOIqO1sb/+2Il053bhmYopCFEcVg2FsDZ+9i2LFQ0FHRNqyjkqgWrdDE7TvJCi12r
	 LFl0/BTQi+LCzRLlh0V0tON/P8d6LyU9n15Ay7bQ=
Date: Wed, 21 Feb 2024 16:02:06 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-compress-decompress-functions.patch removed from -mm tree
Message-Id: <20240222000206.DDBB5C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: compress & decompress functions
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-compress-decompress-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: compress & decompress functions
Date: Mon, 29 Jan 2024 20:36:53 -0500

Writeback needs to decompress. Move the (de)compression API above what
will be the consolidated shrinking/writeback code.

Link: https://lkml.kernel.org/r/20240130014208.565554-18-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  207 +++++++++++++++++++++++++--------------------------
 1 file changed, 105 insertions(+), 102 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-compress-decompress-functions
+++ a/mm/zswap.c
@@ -993,6 +993,111 @@ static void zswap_invalidate_entry(struc
 }
 
 /*********************************
+* compressed storage functions
+**********************************/
+static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
+{
+	struct crypto_acomp_ctx *acomp_ctx;
+	struct scatterlist input, output;
+	unsigned int dlen = PAGE_SIZE;
+	unsigned long handle;
+	struct zpool *zpool;
+	char *buf;
+	gfp_t gfp;
+	int ret;
+	u8 *dst;
+
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+
+	mutex_lock(&acomp_ctx->mutex);
+
+	dst = acomp_ctx->buffer;
+	sg_init_table(&input, 1);
+	sg_set_page(&input, &folio->page, PAGE_SIZE, 0);
+
+	/*
+	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
+	 * and hardware-accelerators may won't check the dst buffer size, so
+	 * giving the dst buffer with enough length to avoid buffer overflow.
+	 */
+	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+
+	/*
+	 * it maybe looks a little bit silly that we send an asynchronous request,
+	 * then wait for its completion synchronously. This makes the process look
+	 * synchronous in fact.
+	 * Theoretically, acomp supports users send multiple acomp requests in one
+	 * acomp instance, then get those requests done simultaneously. but in this
+	 * case, zswap actually does store and load page by page, there is no
+	 * existing method to send the second page before the first page is done
+	 * in one thread doing zwap.
+	 * but in different threads running on different cpu, we have different
+	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 */
+	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	if (ret) {
+		zswap_reject_compress_fail++;
+		goto unlock;
+	}
+
+	zpool = zswap_find_zpool(entry);
+	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
+	if (zpool_malloc_support_movable(zpool))
+		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
+	ret = zpool_malloc(zpool, dlen, gfp, &handle);
+	if (ret == -ENOSPC) {
+		zswap_reject_compress_poor++;
+		goto unlock;
+	}
+	if (ret) {
+		zswap_reject_alloc_fail++;
+		goto unlock;
+	}
+
+	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
+	memcpy(buf, dst, dlen);
+	zpool_unmap_handle(zpool, handle);
+
+	entry->handle = handle;
+	entry->length = dlen;
+
+unlock:
+	mutex_unlock(&acomp_ctx->mutex);
+	return ret == 0;
+}
+
+static void zswap_decompress(struct zswap_entry *entry, struct page *page)
+{
+	struct zpool *zpool = zswap_find_zpool(entry);
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
+	u8 *src;
+
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
+	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
+	if (!zpool_can_sleep_mapped(zpool)) {
+		memcpy(acomp_ctx->buffer, src, entry->length);
+		src = acomp_ctx->buffer;
+		zpool_unmap_handle(zpool, entry->handle);
+	}
+
+	sg_init_one(&input, src, entry->length);
+	sg_init_table(&output, 1);
+	sg_set_page(&output, page, PAGE_SIZE, 0);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
+	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
+	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
+	mutex_unlock(&acomp_ctx->mutex);
+
+	if (zpool_can_sleep_mapped(zpool))
+		zpool_unmap_handle(zpool, entry->handle);
+}
+
+/*********************************
 * shrinker functions
 **********************************/
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
@@ -1317,108 +1422,6 @@ resched:
 	zswap_pool_put(pool);
 }
 
-static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
-{
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle;
-	struct zpool *zpool;
-	char *buf;
-	gfp_t gfp;
-	int ret;
-	u8 *dst;
-
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-
-	mutex_lock(&acomp_ctx->mutex);
-
-	dst = acomp_ctx->buffer;
-	sg_init_table(&input, 1);
-	sg_set_page(&input, &folio->page, PAGE_SIZE, 0);
-
-	/*
-	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
-	 * and hardware-accelerators may won't check the dst buffer size, so
-	 * giving the dst buffer with enough length to avoid buffer overflow.
-	 */
-	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
-
-	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zwap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
-	 */
-	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-	if (ret) {
-		zswap_reject_compress_fail++;
-		goto unlock;
-	}
-
-	zpool = zswap_find_zpool(entry);
-	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
-	if (zpool_malloc_support_movable(zpool))
-		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
-	ret = zpool_malloc(zpool, dlen, gfp, &handle);
-	if (ret == -ENOSPC) {
-		zswap_reject_compress_poor++;
-		goto unlock;
-	}
-	if (ret) {
-		zswap_reject_alloc_fail++;
-		goto unlock;
-	}
-
-	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, dst, dlen);
-	zpool_unmap_handle(zpool, handle);
-
-	entry->handle = handle;
-	entry->length = dlen;
-
-unlock:
-	mutex_unlock(&acomp_ctx->mutex);
-	return ret == 0;
-}
-
-static void zswap_decompress(struct zswap_entry *entry, struct page *page)
-{
-	struct zpool *zpool = zswap_find_zpool(entry);
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src;
-
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
-
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(zpool)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
-		src = acomp_ctx->buffer;
-		zpool_unmap_handle(zpool, entry->handle);
-	}
-
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
-	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
-	mutex_unlock(&acomp_ctx->mutex);
-
-	if (zpool_can_sleep_mapped(zpool))
-		zpool_unmap_handle(zpool, entry->handle);
-}
-
 /*********************************
 * writeback code
 **********************************/
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


