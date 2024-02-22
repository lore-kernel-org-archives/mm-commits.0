Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4C28EF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560118; cv=none; b=YWscV6EbDxGehuDrTQYMMnHSe8i1OH8FKYJrXicOZnL4EAhE4AG6SihXdYOF0DSIHdaGdKoADkkPFf5PuuO3fPHPfIAzyz54JC7wt/J+9Xk6jNf7rv7KdUZETsAqU6U85izq0v4KpOSbGvqxNCMM+60msDNpWJfLOZk/nPBxJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560118; c=relaxed/simple;
	bh=HzFL4oOrKvxpXdehStiQYF+f72YcWTmBS50xn5/l7tg=;
	h=Date:To:From:Subject:Message-Id; b=sPy6yxhqonrsWzAKacHZqzoMrlLRuNNfOCxCT9B7ncTz6xA33z9zU+wvfAWw4bWZE7F1IsG4Kqc8o/4vdq4E8zvMN6Vxvl3fD0RZHkAoOFNrnOU3UX/r/ZIhJyygK+6kQiJkVWfdlhIcI8wphsckvNgvWR9UJqCm8iZdPzvN08M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mTeTzeCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mTeTzeCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EC3C433C7;
	Thu, 22 Feb 2024 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560118;
	bh=HzFL4oOrKvxpXdehStiQYF+f72YcWTmBS50xn5/l7tg=;
	h=Date:To:From:Subject:From;
	b=mTeTzeCvBe1Wp4AmF61bD+HcPqwoSYIGto6+4MXzzIVJfvI3Zd/YeIvbsdWJ/Jjy7
	 uLScorL0Lqa5gBKhCUAe3IzUFOddM3OTHGmRF+VkGcZ9sq+ylcATxhx+T2RB+3AfBD
	 b2H4Obo5/lOZVguY9SDe//ifZDnJgfOa6cVa6HlA=
Date: Wed, 21 Feb 2024 16:01:57 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-break-out-zwap_compress.patch removed from -mm tree
Message-Id: <20240222000158.26EC3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: break out zwap_compress()
has been removed from the -mm tree.  Its filename was
     mm-zswap-break-out-zwap_compress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: break out zwap_compress()
Date: Mon, 29 Jan 2024 20:36:43 -0500

zswap_store() is long and mixes work at the zswap layer with work at
the backend and compression layer. Move compression & backend work to
zswap_compress(), mirroring zswap_decompress().

Link: https://lkml.kernel.org/r/20240130014208.565554-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  145 +++++++++++++++++++++++++++------------------------
 1 file changed, 77 insertions(+), 68 deletions(-)

--- a/mm/zswap.c~mm-zswap-break-out-zwap_compress
+++ a/mm/zswap.c
@@ -1315,6 +1315,79 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
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
 static void zswap_decompress(struct zswap_entry *entry, struct page *page)
 {
 	struct zpool *zpool = zswap_find_zpool(entry);
@@ -1471,18 +1544,11 @@ bool zswap_store(struct folio *folio)
 	struct page *page = &folio->page;
 	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry, *dupentry;
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
-	struct zpool *zpool;
-	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle, value;
-	char *buf;
-	u8 *src, *dst;
-	gfp_t gfp;
-	int ret;
+	unsigned long value;
+	u8 *src;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1568,65 +1634,10 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	/* compress */
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
-
-	if (ret) {
-		zswap_reject_compress_fail++;
-		goto put_dstmem;
-	}
-
-	/* store */
-	zpool = zswap_find_zpool(entry);
-	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
-	if (zpool_malloc_support_movable(zpool))
-		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
-	ret = zpool_malloc(zpool, dlen, gfp, &handle);
-	if (ret == -ENOSPC) {
-		zswap_reject_compress_poor++;
-		goto put_dstmem;
-	}
-	if (ret) {
-		zswap_reject_alloc_fail++;
-		goto put_dstmem;
-	}
-	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, dst, dlen);
-	zpool_unmap_handle(zpool, handle);
-	mutex_unlock(&acomp_ctx->mutex);
+	if (!zswap_compress(folio, entry))
+		goto put_pool;
 
-	/* populate entry */
 	entry->swpentry = swp;
-	entry->handle = handle;
-	entry->length = dlen;
 
 insert_entry:
 	entry->objcg = objcg;
@@ -1663,8 +1674,6 @@ insert_entry:
 
 	return true;
 
-put_dstmem:
-	mutex_unlock(&acomp_ctx->mutex);
 put_pool:
 	zswap_pool_put(entry->pool);
 freepage:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


