Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8D613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849220; cv=none; b=u4/vBqF6wXmdAU2dUDP4A0nGSnB62qit7x5TwAY04N0xbWRhiwQFyRYICUgEhL8ZLQuB8I0Ss+o25ApRNCXfZY39CG9InPuoBkYM5GcxwNMGCDQt5BxOr8N8hOapX+CjtudtI15ar00SXp4v2VBF7kgmAE4LY6sHBRZIZ2gZIdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849220; c=relaxed/simple;
	bh=QDxCDsmq58JEw17Idqm9P77Y572kshAFRx9Hk7KQW6w=;
	h=Date:To:From:Subject:Message-Id; b=skU5A39PllsqyjXAfc4ui/ETaN6Wko5lRLT/2kRD4xAkjeB3EquyTM/srHZhgNL7aVx0J15HHZVQzq6QTjzF2ehmhuGNDNzNFWd2l2/xRs7gbthq12cz3Q3yGPcR7pjKY6+H09FefOj2Ha3RgGiVd5MMeM5WbYkrpY5qSq2q/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jg+5GW4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jg+5GW4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009DEC32781;
	Wed, 24 Jul 2024 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849220;
	bh=QDxCDsmq58JEw17Idqm9P77Y572kshAFRx9Hk7KQW6w=;
	h=Date:To:From:Subject:From;
	b=jg+5GW4wgbvxZG3DR3u4atHub+QZj0YYHDrhU2LGHtHm6gfBYxqMgKwNMCXX3C4v4
	 Hk6KB0RSC0PMm4Naacs0CsLMoa4Wo15UYw6JjwDTOsafTaw+KUSXE9iEP/9j4TyA09
	 /ujiYx8OWjGOqRWMuSW8UmLX/VHymzWy3vNVm21M=
Date: Wed, 24 Jul 2024 12:26:59 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-zcomp_ctx-structure.patch added to mm-unstable branch
Message-Id: <20240724192700.009DEC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce zcomp_ctx structure
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-zcomp_ctx-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-zcomp_ctx-structure.patch

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
Subject: zram: introduce zcomp_ctx structure
Date: Fri, 12 Jul 2024 14:18:29 +0900

Keep run-time driver data (scratch buffers, etc.) in
zcomp_ctx structure.  This structure is allocated per-CPU
because drivers (backends) need to modify its content
during requests execution.

We will split mutable and immutable driver data, this is
a preparation path.

Link: https://lkml.kernel.org/r/20240712051850.484318-19-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |   39 ++++--------------
 drivers/block/zram/backend_deflate.c |   46 +++++++++++----------
 drivers/block/zram/backend_lz4.c     |   36 +++++++++-------
 drivers/block/zram/backend_lz4hc.c   |   36 +++++++++-------
 drivers/block/zram/backend_lzo.c     |   17 ++++---
 drivers/block/zram/backend_lzorle.c  |   17 ++++---
 drivers/block/zram/backend_zstd.c    |   54 +++++++++++++------------
 drivers/block/zram/zcomp.c           |   16 ++++---
 drivers/block/zram/zcomp.h           |   23 +++++++---
 9 files changed, 149 insertions(+), 135 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_842.c
@@ -7,51 +7,32 @@
 
 #include "backend_842.h"
 
-struct sw842_ctx {
-	void *mem;
-};
-
-static void destroy_842(void *ctx)
+static void destroy_842(struct zcomp_ctx *ctx)
 {
-	struct sw842_ctx *zctx = ctx;
-
-	kfree(zctx->mem);
-	kfree(zctx);
+	kfree(ctx->context);
 }
 
-static void *create_842(struct zcomp_params *params)
+static int create_842(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct sw842_ctx *ctx;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
-
-	ctx->mem = kmalloc(SW842_MEM_COMPRESS, GFP_KERNEL);
-	if (!ctx->mem)
-		goto error;
-
-	return ctx;
-
-error:
-	destroy_842(ctx);
-	return NULL;
+	ctx->context = kmalloc(SW842_MEM_COMPRESS, GFP_KERNEL);
+	if (!ctx->context)
+		return -ENOMEM;
+	return 0;
 }
 
-static int compress_842(void *ctx, struct zcomp_req *req)
+static int compress_842(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct sw842_ctx *zctx = ctx;
 	unsigned int dlen = req->dst_len;
 	int ret;
 
 	ret = sw842_compress(req->src, req->src_len, req->dst, &dlen,
-			     zctx->mem);
+			     ctx->context);
 	if (ret == 0)
 		req->dst_len = dlen;
 	return ret;
 }
 
-static int decompress_842(void *ctx, struct zcomp_req *req)
+static int decompress_842(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	unsigned int dlen = req->dst_len;
 
--- a/drivers/block/zram/backend_deflate.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_deflate.c
@@ -17,9 +17,12 @@ struct deflate_ctx {
 	s32 level;
 };
 
-static void deflate_destroy(void *ctx)
+static void deflate_destroy(struct zcomp_ctx *ctx)
 {
-	struct deflate_ctx *zctx = ctx;
+	struct deflate_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
 
 	if (zctx->cctx.workspace) {
 		zlib_deflateEnd(&zctx->cctx);
@@ -32,51 +35,52 @@ static void deflate_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *deflate_create(struct zcomp_params *params)
+static int deflate_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct deflate_ctx *ctx;
+	struct deflate_ctx *zctx;
 	size_t sz;
 	int ret;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
+		return -ENOMEM;
 
+	ctx->context = zctx;
 	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		ctx->level = params->level;
+		zctx->level = params->level;
 	else
-		ctx->level = Z_DEFAULT_COMPRESSION;
+		zctx->level = Z_DEFAULT_COMPRESSION;
 
 	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
-	ctx->cctx.workspace = vzalloc(sz);
-	if (!ctx->cctx.workspace)
+	zctx->cctx.workspace = vzalloc(sz);
+	if (!zctx->cctx.workspace)
 		goto error;
 
-	ret = zlib_deflateInit2(&ctx->cctx, ctx->level, Z_DEFLATED,
+	ret = zlib_deflateInit2(&zctx->cctx, zctx->level, Z_DEFLATED,
 				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
 				Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK)
 		goto error;
 
 	sz = zlib_inflate_workspacesize();
-	ctx->dctx.workspace = vzalloc(sz);
-	if (!ctx->dctx.workspace)
+	zctx->dctx.workspace = vzalloc(sz);
+	if (!zctx->dctx.workspace)
 		goto error;
 
-	ret = zlib_inflateInit2(&ctx->dctx, -DEFLATE_DEF_WINBITS);
+	ret = zlib_inflateInit2(&zctx->dctx, -DEFLATE_DEF_WINBITS);
 	if (ret != Z_OK)
 		goto error;
 
-	return ctx;
+	return 0;
 
 error:
 	deflate_destroy(ctx);
-	return NULL;
+	return -EINVAL;
 }
 
-static int deflate_compress(void *ctx, struct zcomp_req *req)
+static int deflate_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct deflate_ctx *zctx = ctx;
+	struct deflate_ctx *zctx = ctx->context;
 	struct z_stream_s *deflate;
 	int ret;
 
@@ -98,9 +102,9 @@ static int deflate_compress(void *ctx, s
 	return 0;
 }
 
-static int deflate_decompress(void *ctx, struct zcomp_req *req)
+static int deflate_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct deflate_ctx *zctx = ctx;
+	struct deflate_ctx *zctx = ctx->context;
 	struct z_stream_s *inflate;
 	int ret;
 
--- a/drivers/block/zram/backend_lz4.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_lz4.c
@@ -10,40 +10,44 @@ struct lz4_ctx {
 	s32 level;
 };
 
-static void lz4_destroy(void *ctx)
+static void lz4_destroy(struct zcomp_ctx *ctx)
 {
-	struct lz4_ctx *zctx = ctx;
+	struct lz4_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
 
 	vfree(zctx->mem);
 	kfree(zctx);
 }
 
-static void *lz4_create(struct zcomp_params *params)
+static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4_ctx *ctx;
+	struct lz4_ctx *zctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
+		return -ENOMEM;
 
+	ctx->context = zctx;
 	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		ctx->level = params->level;
+		zctx->level = params->level;
 	else
-		ctx->level = LZ4_ACCELERATION_DEFAULT;
+		zctx->level = LZ4_ACCELERATION_DEFAULT;
 
-	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
-	if (!ctx->mem)
+	zctx->mem = vmalloc(LZ4_MEM_COMPRESS);
+	if (!zctx->mem)
 		goto error;
 
-	return ctx;
+	return 0;
 error:
 	lz4_destroy(ctx);
-	return NULL;
+	return -EINVAL;
 }
 
-static int lz4_compress(void *ctx, struct zcomp_req *req)
+static int lz4_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct lz4_ctx *zctx = ctx;
+	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
 	ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
@@ -54,7 +58,7 @@ static int lz4_compress(void *ctx, struc
 	return 0;
 }
 
-static int lz4_decompress(void *ctx, struct zcomp_req *req)
+static int lz4_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
--- a/drivers/block/zram/backend_lz4hc.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -10,40 +10,44 @@ struct lz4hc_ctx {
 	s32 level;
 };
 
-static void lz4hc_destroy(void *ctx)
+static void lz4hc_destroy(struct zcomp_ctx *ctx)
 {
-	struct lz4hc_ctx *zctx = ctx;
+	struct lz4hc_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
 
 	vfree(zctx->mem);
 	kfree(zctx);
 }
 
-static void *lz4hc_create(struct zcomp_params *params)
+static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4hc_ctx *ctx;
+	struct lz4hc_ctx *zctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
+		return -ENOMEM;
 
+	ctx->context = zctx;
 	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		ctx->level = params->level;
+		zctx->level = params->level;
 	else
-		ctx->level = LZ4HC_DEFAULT_CLEVEL;
+		zctx->level = LZ4HC_DEFAULT_CLEVEL;
 
-	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
-	if (!ctx->mem)
+	zctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!zctx->mem)
 		goto error;
 
-	return ctx;
+	return 0;
 error:
 	lz4hc_destroy(ctx);
-	return NULL;
+	return -EINVAL;
 }
 
-static int lz4hc_compress(void *ctx, struct zcomp_req *req)
+static int lz4hc_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct lz4hc_ctx *zctx = ctx;
+	struct lz4hc_ctx *zctx = ctx->context;
 	int ret;
 
 	ret = LZ4_compress_HC(req->src, req->dst, req->src_len, req->dst_len,
@@ -54,7 +58,7 @@ static int lz4hc_compress(void *ctx, str
 	return 0;
 }
 
-static int lz4hc_decompress(void *ctx, struct zcomp_req *req)
+static int lz4hc_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
--- a/drivers/block/zram/backend_lzo.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_lzo.c
@@ -6,26 +6,29 @@
 
 #include "backend_lzo.h"
 
-static void *lzo_create(struct zcomp_params *params)
+static int lzo_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	ctx->context = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (!ctx->context)
+		return -ENOMEM;
+	return 0;
 }
 
-static void lzo_destroy(void *ctx)
+static void lzo_destroy(struct zcomp_ctx *ctx)
 {
-	kfree(ctx);
+	kfree(ctx->context);
 }
 
-static int lzo_compress(void *ctx, struct zcomp_req *req)
+static int lzo_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
 	ret = lzo1x_1_compress(req->src, req->src_len, req->dst,
-			       &req->dst_len, ctx);
+			       &req->dst_len, ctx->context);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzo_decompress(void *ctx, struct zcomp_req *req)
+static int lzo_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
--- a/drivers/block/zram/backend_lzorle.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_lzorle.c
@@ -6,26 +6,29 @@
 
 #include "backend_lzorle.h"
 
-static void *lzorle_create(struct zcomp_params *params)
+static int lzorle_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	ctx->context = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	if (!ctx->context)
+		return -ENOMEM;
+	return 0;
 }
 
-static void lzorle_destroy(void *ctx)
+static void lzorle_destroy(struct zcomp_ctx *ctx)
 {
-	kfree(ctx);
+	kfree(ctx->context);
 }
 
-static int lzorle_compress(void *ctx, struct zcomp_req *req)
+static int lzorle_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
 	ret = lzorle1x_1_compress(req->src, req->src_len, req->dst,
-				  &req->dst_len, ctx);
+				  &req->dst_len, ctx->context);
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzorle_decompress(void *ctx, struct zcomp_req *req)
+static int lzorle_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
 	int ret;
 
--- a/drivers/block/zram/backend_zstd.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/backend_zstd.c
@@ -16,60 +16,64 @@ struct zstd_ctx {
 	s32 level;
 };
 
-static void zstd_destroy(void *ctx)
+static void zstd_destroy(struct zcomp_ctx *ctx)
 {
-	struct zstd_ctx *zctx = ctx;
+	struct zstd_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
 
 	vfree(zctx->cctx_mem);
 	vfree(zctx->dctx_mem);
 	kfree(zctx);
 }
 
-static void *zstd_create(struct zcomp_params *params)
+static int zstd_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
+	struct zstd_ctx *zctx;
 	zstd_parameters prm;
-	struct zstd_ctx *ctx;
 	size_t sz;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
+		return -ENOMEM;
 
+	ctx->context = zctx;
 	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		ctx->level = params->level;
+		zctx->level = params->level;
 	else
-		ctx->level = zstd_default_clevel();
+		zctx->level = zstd_default_clevel();
 
-	prm = zstd_get_params(ctx->level, PAGE_SIZE);
-	ctx->cprm = zstd_get_params(ctx->level, PAGE_SIZE);
+	prm = zstd_get_params(zctx->level, PAGE_SIZE);
+	zctx->cprm = zstd_get_params(zctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&prm.cParams);
-	ctx->cctx_mem = vzalloc(sz);
-	if (!ctx->cctx_mem)
+	zctx->cctx_mem = vzalloc(sz);
+	if (!zctx->cctx_mem)
 		goto error;
 
-	ctx->cctx = zstd_init_cctx(ctx->cctx_mem, sz);
-	if (!ctx->cctx)
+	zctx->cctx = zstd_init_cctx(zctx->cctx_mem, sz);
+	if (!zctx->cctx)
 		goto error;
 
 	sz = zstd_dctx_workspace_bound();
-	ctx->dctx_mem = vzalloc(sz);
-	if (!ctx->dctx_mem)
+	zctx->dctx_mem = vzalloc(sz);
+	if (!zctx->dctx_mem)
 		goto error;
 
-	ctx->dctx = zstd_init_dctx(ctx->dctx_mem, sz);
-	if (!ctx->dctx)
+	zctx->dctx = zstd_init_dctx(zctx->dctx_mem, sz);
+	if (!zctx->dctx)
 		goto error;
 
-	return ctx;
+	return 0;
 
 error:
 	zstd_destroy(ctx);
-	return NULL;
+	return -EINVAL;
 }
 
-static int zstd_compress(void *ctx, struct zcomp_req *req)
+static int zstd_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct zstd_ctx *zctx = ctx;
+	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
@@ -80,9 +84,9 @@ static int zstd_compress(void *ctx, stru
 	return 0;
 }
 
-static int zstd_decompress(void *ctx, struct zcomp_req *req)
+static int zstd_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
 {
-	struct zstd_ctx *zctx = ctx;
+	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
 
 	ret = zstd_decompress_dctx(zctx->dctx, req->dst, req->dst_len,
--- a/drivers/block/zram/zcomp.c~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/zcomp.c
@@ -45,23 +45,25 @@ static const struct zcomp_ops *backends[
 
 static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	if (zstrm->ctx)
-		comp->ops->destroy_ctx(zstrm->ctx);
+	comp->ops->destroy_ctx(&zstrm->ctx);
 	vfree(zstrm->buffer);
-	zstrm->ctx = NULL;
 	zstrm->buffer = NULL;
 }
 
 static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	zstrm->ctx = comp->ops->create_ctx(comp->params);
+	int ret;
+
+	ret = comp->ops->create_ctx(comp->params, &zstrm->ctx);
+	if (ret)
+		return ret;
 
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
 	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (!zstrm->ctx || !zstrm->buffer) {
+	if (!zstrm->buffer) {
 		zcomp_strm_free(comp, zstrm);
 		return -ENOMEM;
 	}
@@ -126,7 +128,7 @@ int zcomp_compress(struct zcomp *comp, s
 	};
 	int ret;
 
-	ret = comp->ops->compress(zstrm->ctx, &req);
+	ret = comp->ops->compress(&zstrm->ctx, &req);
 	if (!ret)
 		*dst_len = req.dst_len;
 	return ret;
@@ -142,7 +144,7 @@ int zcomp_decompress(struct zcomp *comp,
 		.dst_len = PAGE_SIZE,
 	};
 
-	return comp->ops->decompress(zstrm->ctx, &req);
+	return comp->ops->decompress(&zstrm->ctx, &req);
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
--- a/drivers/block/zram/zcomp.h~zram-introduce-zcomp_ctx-structure
+++ a/drivers/block/zram/zcomp.h
@@ -13,12 +13,20 @@ struct zcomp_params {
 	s32 level;
 };
 
+/*
+ * Run-time driver context - scratch buffers, etc. It is modified during
+ * request execution (compression/decompression), cannot be shared, so
+ * it's in per-CPU area.
+ */
+struct zcomp_ctx {
+	void *context;
+};
+
 struct zcomp_strm {
-	/* The members ->buffer and ->tfm are protected by ->lock. */
 	local_lock_t lock;
-	/* compression/decompression buffer */
+	/* compression buffer */
 	void *buffer;
-	void *ctx;
+	struct zcomp_ctx ctx;
 };
 
 struct zcomp_req {
@@ -30,11 +38,12 @@ struct zcomp_req {
 };
 
 struct zcomp_ops {
-	int (*compress)(void *ctx, struct zcomp_req *req);
-	int (*decompress)(void *ctx, struct zcomp_req *req);
+	int (*compress)(struct zcomp_ctx *ctx, struct zcomp_req *req);
+	int (*decompress)(struct zcomp_ctx *ctx, struct zcomp_req *req);
 
-	void *(*create_ctx)(struct zcomp_params *params);
-	void (*destroy_ctx)(void *ctx);
+	int (*create_ctx)(struct zcomp_params *params,
+			  struct zcomp_ctx *ctx);
+	void (*destroy_ctx)(struct zcomp_ctx *ctx);
 
 	const char *name;
 };
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

