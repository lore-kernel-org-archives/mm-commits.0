Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5703F613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849215; cv=none; b=qAohezPK07Dnh9pH1x40B199AfNjFEB54j6Jq+AqGwFbWflt67WPdUNjZK3PK6GjsghctDvDaLRV7JCUrIQ2x9YdRtBA522WmL5DumKQ2RzVmjpwBrSzwceUnbCxFuPjHL//m/b395JLst0yT5fSfKQ2xZzHNsTq638js6bj0R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849215; c=relaxed/simple;
	bh=FxvXEh3XIzZWWJdpI7IHLo+uv2phaH84xsDPd4kvYxc=;
	h=Date:To:From:Subject:Message-Id; b=IePlUrYQ6Lntep85l/5KQV6YLx29PP5w9TnCXG9jfZJIM3OCS1424rxR5cn18v4LN3uQcnASwSUB0EqKm3ghw8GO5g0Vhjcr1g3eFJMPgqf94W1SnRdTv/iUa2/Hcc6iJuEGoZY3tteobd8Gisk6OegeI1zO/btsl5q7u5Ou+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iiqv3wSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iiqv3wSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02569C32781;
	Wed, 24 Jul 2024 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849215;
	bh=FxvXEh3XIzZWWJdpI7IHLo+uv2phaH84xsDPd4kvYxc=;
	h=Date:To:From:Subject:From;
	b=iiqv3wSSY8HYM0xLS9rK0jYrVoq0pxKVQtMVxbbrTeClBZRv3o8NEj+0ZeedGavXr
	 BpSuBl5QAl0jbUEehdL42enqKwBxAih+n9v0F6J4QfcVgVKAwv5531NVV5YwWvFkJs
	 WJ6dlnj6wVvrkt9qW+6oCOLA10fjhZ4cZ6VgtdBM=
Date: Wed, 24 Jul 2024 12:26:54 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-zcomp_req-structure.patch added to mm-unstable branch
Message-Id: <20240724192655.02569C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce zcomp_req structure
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-zcomp_req-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-zcomp_req-structure.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: introduce zcomp_req structure
Date: Fri, 12 Jul 2024 14:18:28 +0900

Encapsulate compression/decompression data in zcomp_req
structure.

Link: https://lkml.kernel.org/r/20240712051850.484318-18-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |   17 +++++++---------
 drivers/block/zram/backend_deflate.c |   26 ++++++++++---------------
 drivers/block/zram/backend_lz4.c     |   15 ++++++--------
 drivers/block/zram/backend_lz4hc.c   |   13 +++++-------
 drivers/block/zram/backend_lzo.c     |   12 +++++------
 drivers/block/zram/backend_lzorle.c  |   13 +++++-------
 drivers/block/zram/backend_zstd.c    |   15 ++++++--------
 drivers/block/zram/zcomp.c           |   23 +++++++++++++++-------
 drivers/block/zram/zcomp.h           |   15 +++++++++-----
 9 files changed, 77 insertions(+), 72 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_842.c
@@ -38,25 +38,24 @@ error:
 	return NULL;
 }
 
-static int compress_842(void *ctx, const unsigned char *src, size_t src_len,
-			unsigned char *dst, size_t *dst_len)
+static int compress_842(void *ctx, struct zcomp_req *req)
 {
 	struct sw842_ctx *zctx = ctx;
-	unsigned int dlen = *dst_len;
+	unsigned int dlen = req->dst_len;
 	int ret;
 
-	ret = sw842_compress(src, src_len, dst, &dlen, zctx->mem);
+	ret = sw842_compress(req->src, req->src_len, req->dst, &dlen,
+			     zctx->mem);
 	if (ret == 0)
-		*dst_len = dlen;
+		req->dst_len = dlen;
 	return ret;
 }
 
-static int decompress_842(void *ctx, const unsigned char *src, size_t src_len,
-			  unsigned char *dst, size_t dst_len)
+static int decompress_842(void *ctx, struct zcomp_req *req)
 {
-	unsigned int dlen = dst_len;
+	unsigned int dlen = req->dst_len;
 
-	return sw842_decompress(src, src_len, dst, &dlen);
+	return sw842_decompress(req->src, req->src_len, req->dst, &dlen);
 }
 
 const struct zcomp_ops backend_842 = {
--- a/drivers/block/zram/backend_deflate.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_deflate.c
@@ -74,9 +74,7 @@ error:
 	return NULL;
 }
 
-static int deflate_compress(void *ctx, const unsigned char *src,
-			    size_t src_len, unsigned char *dst,
-			    size_t *dst_len)
+static int deflate_compress(void *ctx, struct zcomp_req *req)
 {
 	struct deflate_ctx *zctx = ctx;
 	struct z_stream_s *deflate;
@@ -87,22 +85,20 @@ static int deflate_compress(void *ctx, c
 	if (ret != Z_OK)
 		return -EINVAL;
 
-	deflate->next_in = (u8 *)src;
-	deflate->avail_in = src_len;
-	deflate->next_out = (u8 *)dst;
-	deflate->avail_out = *dst_len;
+	deflate->next_in = (u8 *)req->src;
+	deflate->avail_in = req->src_len;
+	deflate->next_out = (u8 *)req->dst;
+	deflate->avail_out = req->dst_len;
 
 	ret = zlib_deflate(deflate, Z_FINISH);
 	if (ret != Z_STREAM_END)
 		return -EINVAL;
 
-	*dst_len = deflate->total_out;
+	req->dst_len = deflate->total_out;
 	return 0;
 }
 
-static int deflate_decompress(void *ctx, const unsigned char *src,
-			      size_t src_len, unsigned char *dst,
-			      size_t dst_len)
+static int deflate_decompress(void *ctx, struct zcomp_req *req)
 {
 	struct deflate_ctx *zctx = ctx;
 	struct z_stream_s *inflate;
@@ -114,10 +110,10 @@ static int deflate_decompress(void *ctx,
 	if (ret != Z_OK)
 		return -EINVAL;
 
-	inflate->next_in = (u8 *)src;
-	inflate->avail_in = src_len;
-	inflate->next_out = (u8 *)dst;
-	inflate->avail_out = dst_len;
+	inflate->next_in = (u8 *)req->src;
+	inflate->avail_in = req->src_len;
+	inflate->next_out = (u8 *)req->dst;
+	inflate->avail_out = req->dst_len;
 
 	ret = zlib_inflate(inflate, Z_SYNC_FLUSH);
 	if (ret != Z_STREAM_END)
--- a/drivers/block/zram/backend_lz4.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_lz4.c
@@ -41,26 +41,25 @@ error:
 	return NULL;
 }
 
-static int lz4_compress(void *ctx, const unsigned char *src, size_t src_len,
-			unsigned char *dst, size_t *dst_len)
+static int lz4_compress(void *ctx, struct zcomp_req *req)
 {
 	struct lz4_ctx *zctx = ctx;
 	int ret;
 
-	ret = LZ4_compress_fast(src, dst, src_len, *dst_len,
-				zctx->level, zctx->mem);
+	ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
+				req->dst_len, zctx->level, zctx->mem);
 	if (!ret)
 		return -EINVAL;
-	*dst_len = ret;
+	req->dst_len = ret;
 	return 0;
 }
 
-static int lz4_decompress(void *ctx, const unsigned char *src,
-			  size_t src_len, unsigned char *dst, size_t dst_len)
+static int lz4_decompress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	ret = LZ4_decompress_safe(req->src, req->dst, req->src_len,
+				  req->dst_len);
 	if (ret < 0)
 		return -EINVAL;
 	return 0;
--- a/drivers/block/zram/backend_lz4hc.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -41,26 +41,25 @@ error:
 	return NULL;
 }
 
-static int lz4hc_compress(void *ctx, const unsigned char *src, size_t src_len,
-			  unsigned char *dst, size_t *dst_len)
+static int lz4hc_compress(void *ctx, struct zcomp_req *req)
 {
 	struct lz4hc_ctx *zctx = ctx;
 	int ret;
 
-	ret = LZ4_compress_HC(src, dst, src_len, *dst_len,
+	ret = LZ4_compress_HC(req->src, req->dst, req->src_len, req->dst_len,
 			      zctx->level, zctx->mem);
 	if (!ret)
 		return -EINVAL;
-	*dst_len = ret;
+	req->dst_len = ret;
 	return 0;
 }
 
-static int lz4hc_decompress(void *ctx, const unsigned char *src,
-			    size_t src_len, unsigned char *dst, size_t dst_len)
+static int lz4hc_decompress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	ret = LZ4_decompress_safe(req->src, req->dst, req->src_len,
+				  req->dst_len);
 	if (ret < 0)
 		return -EINVAL;
 	return 0;
--- a/drivers/block/zram/backend_lzo.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_lzo.c
@@ -16,21 +16,21 @@ static void lzo_destroy(void *ctx)
 	kfree(ctx);
 }
 
-static int lzo_compress(void *ctx, const unsigned char *src, size_t src_len,
-			unsigned char *dst, size_t *dst_len)
+static int lzo_compress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = lzo1x_1_compress(src, src_len, dst, dst_len, ctx);
+	ret = lzo1x_1_compress(req->src, req->src_len, req->dst,
+			       &req->dst_len, ctx);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzo_decompress(void *ctx, const unsigned char *src, size_t src_len,
-			  unsigned char *dst, size_t dst_len)
+static int lzo_decompress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	ret = lzo1x_decompress_safe(req->src, req->src_len,
+				    req->dst, &req->dst_len);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
--- a/drivers/block/zram/backend_lzorle.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_lzorle.c
@@ -16,22 +16,21 @@ static void lzorle_destroy(void *ctx)
 	kfree(ctx);
 }
 
-static int lzorle_compress(void *ctx, const unsigned char *src, size_t src_len,
-			   unsigned char *dst, size_t *dst_len)
+static int lzorle_compress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = lzorle1x_1_compress(src, src_len, dst, dst_len, ctx);
+	ret = lzorle1x_1_compress(req->src, req->src_len, req->dst,
+				  &req->dst_len, ctx);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzorle_decompress(void *ctx, const unsigned char *src,
-			     size_t src_len, unsigned char *dst,
-			     size_t dst_len)
+static int lzorle_decompress(void *ctx, struct zcomp_req *req)
 {
 	int ret;
 
-	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	ret = lzo1x_decompress_safe(req->src, req->src_len,
+				    req->dst, &req->dst_len);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
--- a/drivers/block/zram/backend_zstd.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/backend_zstd.c
@@ -67,27 +67,26 @@ error:
 	return NULL;
 }
 
-static int zstd_compress(void *ctx, const unsigned char *src, size_t src_len,
-			 unsigned char *dst, size_t *dst_len)
+static int zstd_compress(void *ctx, struct zcomp_req *req)
 {
 	struct zstd_ctx *zctx = ctx;
 	size_t ret;
 
-	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
-				 src, src_len, &zctx->cprm);
+	ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
+				 req->src, req->src_len, &zctx->cprm);
 	if (zstd_is_error(ret))
 		return -EINVAL;
-	*dst_len = ret;
+	req->dst_len = ret;
 	return 0;
 }
 
-static int zstd_decompress(void *ctx, const unsigned char *src, size_t src_len,
-			   unsigned char *dst, size_t dst_len)
+static int zstd_decompress(void *ctx, struct zcomp_req *req)
 {
 	struct zstd_ctx *zctx = ctx;
 	size_t ret;
 
-	ret = zstd_decompress_dctx(zctx->dctx, dst, dst_len, src, src_len);
+	ret = zstd_decompress_dctx(zctx->dctx, req->dst, req->dst_len,
+				   req->src, req->src_len);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	return 0;
--- a/drivers/block/zram/zcomp.c~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/zcomp.c
@@ -118,22 +118,31 @@ void zcomp_stream_put(struct zcomp *comp
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len)
 {
-	/* The dst buffer should always be 2 * PAGE_SIZE */
-	size_t dlen = 2 * PAGE_SIZE;
+	struct zcomp_req req = {
+		.src = src,
+		.dst = zstrm->buffer,
+		.src_len = PAGE_SIZE,
+		.dst_len = 2 * PAGE_SIZE,
+	};
 	int ret;
 
-	ret = comp->ops->compress(zstrm->ctx, src, PAGE_SIZE,
-				  zstrm->buffer, &dlen);
+	ret = comp->ops->compress(zstrm->ctx, &req);
 	if (!ret)
-		*dst_len = dlen;
+		*dst_len = req.dst_len;
 	return ret;
 }
 
 int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		     const void *src, unsigned int src_len, void *dst)
 {
-	return comp->ops->decompress(zstrm->ctx, src, src_len,
-				     dst, PAGE_SIZE);
+	struct zcomp_req req = {
+		.src = src,
+		.dst = dst,
+		.src_len = src_len,
+		.dst_len = PAGE_SIZE,
+	};
+
+	return comp->ops->decompress(zstrm->ctx, &req);
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
--- a/drivers/block/zram/zcomp.h~zram-introduce-zcomp_req-structure
+++ a/drivers/block/zram/zcomp.h
@@ -21,12 +21,17 @@ struct zcomp_strm {
 	void *ctx;
 };
 
-struct zcomp_ops {
-	int (*compress)(void *ctx, const unsigned char *src, size_t src_len,
-			unsigned char *dst, size_t *dst_len);
+struct zcomp_req {
+	const unsigned char *src;
+	const size_t src_len;
+
+	unsigned char *dst;
+	size_t dst_len;
+};
 
-	int (*decompress)(void *ctx, const unsigned char *src, size_t src_len,
-			  unsigned char *dst, size_t dst_len);
+struct zcomp_ops {
+	int (*compress)(void *ctx, struct zcomp_req *req);
+	int (*decompress)(void *ctx, struct zcomp_req *req);
 
 	void *(*create_ctx)(struct zcomp_params *params);
 	void (*destroy_ctx)(void *ctx);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

