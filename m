Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B4518E34C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925279; cv=none; b=nbBz/9ZBu01Zsaisj/seX7FCGUGt/Xu4H8csKHUb+T7eIfNr/xJetgR3nBMlgYhaX1UgKGNTpfScL4MMQx48RahBdyFhCEEXaKa6L00Wt1s2BHXy0frk+X7bX2Of4qGcXjKSSfi5R71DDmaBSpC+UVC8G2QG41xPmgctwba/ZjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925279; c=relaxed/simple;
	bh=zF5UfUhlYgW3Dpsljoub4sRAQ1WucVW/b2z89hm0O1g=;
	h=Date:To:From:Subject:Message-Id; b=KUq0/TGaZyEFsABQbr6Dpux6c3BbcN/zhWSfkVoYRwj0F22yA1h29yemUL7BLFKPPumIsotxAF5fY5fJO3zdAga2V8TCVhZ3TXbkktn06VAo4UUGb0vmYlXKlod99ozSXIbtegRjWWYHnAdRmrF72PDWVbz1HlOaDmT/K2j58Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H22Re9CI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H22Re9CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184F3C4CECA;
	Mon,  9 Sep 2024 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925279;
	bh=zF5UfUhlYgW3Dpsljoub4sRAQ1WucVW/b2z89hm0O1g=;
	h=Date:To:From:Subject:From;
	b=H22Re9CIvadZlTlY1uNuDEuWtqjiil42/PYfrmoe1XvwGvIZLiMBaKtJJXIA9YfTW
	 PYgC1fl/I097QMsiRSCLqso94HKiys+ZFq/BHGD3kfTlhX7OrcFSmmVC/D3JLtHMPY
	 kr1hbWZBaDbLl3NtG9Flk/KzURj8/wd/NiH6GqVY=
Date: Mon, 09 Sep 2024 16:41:18 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-introduce-zcomp_req-structure.patch removed from -mm tree
Message-Id: <20240909234119.184F3C4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: introduce zcomp_req structure
has been removed from the -mm tree.  Its filename was
     zram-introduce-zcomp_req-structure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: introduce zcomp_req structure
Date: Mon, 2 Sep 2024 19:56:05 +0900

Encapsulate compression/decompression data in zcomp_req structure.

Link: https://lkml.kernel.org/r/20240902105656.1383858-18-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
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
@@ -119,22 +119,31 @@ void zcomp_stream_put(struct zcomp *comp
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

zsmalloc-use-unique-zsmalloc-caches-names.patch

