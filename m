Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8478634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188550; cv=none; b=qLfZku/TLNS7IKhoHZsOcjTz1OyNi/TLp87QwuCNZNzQE1jVoo8I+DMc44LVAhaGhFAhftcnXaIdV4QC3ZAIyrYZmlT9uWERjlWKNYAA2CMhBE+YazgDpXnk0c3vEB0cGUSOOQnnYKMOfD+Ggl35aWUlafNDYlo1mcxJK2fL4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188550; c=relaxed/simple;
	bh=fj5jjozrbijmcakNLFXfNkULzVvlthUDJIpyhLG+jbs=;
	h=Date:To:From:Subject:Message-Id; b=fpFhKT45b1dszWU3Ys5+7WYsCeDPOiSPRBTlrv1boJ8KAuaG4p31IWuc4mzZHI5RPFJqKBEeeipiAFCIcC0IIUm9+M+RZpYVAS1EXMFb3PexbZpMRdNS0X5ibl2c0KIgjKJJuFiRT5QQEQVB/u4O6Cr9kOiNgGj1lKi+KBMMEws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KkJQGB14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KkJQGB14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A442C4CEEC;
	Mon, 17 Mar 2025 05:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188550;
	bh=fj5jjozrbijmcakNLFXfNkULzVvlthUDJIpyhLG+jbs=;
	h=Date:To:From:Subject:From;
	b=KkJQGB14/MavVaOPAeuPcRu36SOZA/mUzHqgZ7KbzfgkPLOX3XgTz4XMMriG8aMst
	 kWvJTBVag5u0TFLyCpUKEtGp0PU+HwVpC9FnUJClHvrnNa7XZmIhBeV7wjpeUNEv0a
	 CMpikuts0ThXfq20wVycLsUj/jD9hPZdQoyGBxxk=
Date: Sun, 16 Mar 2025 22:15:49 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch removed from -mm tree
Message-Id: <20250317051550.0A442C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: use object read/write APIs instead of object mapping APIs
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zswap: use object read/write APIs instead of object mapping APIs
Date: Wed, 5 Mar 2025 06:11:30 +0000

Use the new object read/write APIs instead of mapping APIs.

On compress side, zpool_obj_write() is more concise and provides exactly
what zswap needs to write the compressed object to the zpool, instead of
map->copy->unmap.

On the decompress side, zpool_obj_read_begin() is sleepable, which
allows avoiding the memcpy() for zsmalloc and slightly simplifying the
code by:
- Avoiding checking if the zpool driver is sleepable, reducing special
  cases and shrinking the huge comment.
- Having a single zpool_obj_read_end() call rather than multiple
  conditional zpool_unmap_handle() calls.

The !virt_addr_valid() case can be removed in the future if the crypto API
supports kmap addresses or by using kmap_to_page(), completely eliminating
the memcpy() path in zswap_decompress().  This a step toward that.  In
that spirit, opportunistically make the comment more specific about the
kmap case instead of generic non-linear addresses.  This is the only case
that needs to be handled in practice, and the generic comment makes it
seem like a bigger problem that it actually is.

Link: https://lkml.kernel.org/r/20250305061134.4105762-3-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis
+++ a/mm/zswap.c
@@ -930,7 +930,6 @@ static bool zswap_compress(struct page *
 	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle;
 	struct zpool *zpool;
-	char *buf;
 	gfp_t gfp;
 	u8 *dst;
 
@@ -972,10 +971,7 @@ static bool zswap_compress(struct page *
 	if (alloc_ret)
 		goto unlock;
 
-	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, dst, dlen);
-	zpool_unmap_handle(zpool, handle);
-
+	zpool_obj_write(zpool, handle, dst, dlen);
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -996,24 +992,22 @@ static void zswap_decompress(struct zswa
 	struct zpool *zpool = entry->pool->zpool;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src;
+	u8 *src, *obj;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
+	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
+
 	/*
-	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
-	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
-	 * resort to copying the buffer to a temporary one.
-	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
-	 * such as a kmap address of high memory or even ever a vmap address.
-	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
-	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
+	 * zpool_obj_read_begin() might return a kmap address of highmem when
+	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
+	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
 	 */
-	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
-	    !virt_addr_valid(src)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
+	if (virt_addr_valid(obj)) {
+		src = obj;
+	} else {
+		WARN_ON_ONCE(obj == acomp_ctx->buffer);
+		memcpy(acomp_ctx->buffer, obj, entry->length);
 		src = acomp_ctx->buffer;
-		zpool_unmap_handle(zpool, entry->handle);
 	}
 
 	sg_init_one(&input, src, entry->length);
@@ -1023,8 +1017,7 @@ static void zswap_decompress(struct zswa
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 
-	if (src != acomp_ctx->buffer)
-		zpool_unmap_handle(zpool, entry->handle);
+	zpool_obj_read_end(zpool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 }
 
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are


