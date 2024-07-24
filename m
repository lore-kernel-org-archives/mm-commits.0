Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E469613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849225; cv=none; b=hWx6dmiT92QCH8u/jaPNUaqCebYiCII5PbxyinuB1NbJZbuqlqi3S9sxJwcIt5qnRy3h0Aewngz24WXGHQVw+PLXuw1FgJgxtsWvRtm4pM4HhoFvXruhSJJtk3rKNPtwWBOOjad+sjhxO3tQLvhAtapu4QxKa4Z/qzyw17Ly4v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849225; c=relaxed/simple;
	bh=iOavHDrwlZXyWbGTeXMRrMTneLoZaksdHNXQ8I8a1dg=;
	h=Date:To:From:Subject:Message-Id; b=SWCFgWHKCTLIjA/ylyhuRDalbdsEkycgPrmTtgOXRBbkxKLFb4i354Wn0bCgyZntZeAlx13Sd/FccrtqxrALlX5UquO67+e2Ae/jPMf4HhZ6VxskjmTRbgvke9rlv9yIQWAfxxFBVFMS2vYxar+lJw+3l6rsB+c2xGbKMnwLswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxHYEJax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxHYEJax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F92C32781;
	Wed, 24 Jul 2024 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849225;
	bh=iOavHDrwlZXyWbGTeXMRrMTneLoZaksdHNXQ8I8a1dg=;
	h=Date:To:From:Subject:From;
	b=IxHYEJaxwp1bBfKqvvw7EToFOEWaoVhlVvyliGSfurMvkaMxqwua5Cd5jVGcJzMEl
	 jlyTxDatl1nQWLDctIUyYGnTaz6EXEnEEdCGuoSq/7E8cwRghJ+FLAMHI6blBwJuoM
	 UCf1E0Qbg1zm6EUBBn77oGl3/pWrCADrsE2zxJPg=
Date: Wed, 24 Jul 2024 12:27:04 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-immutable-comp-params-away-from-per-cpu-context.patch added to mm-unstable branch
Message-Id: <20240724192705.20F92C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: move immutable comp params away from per-CPU context
has been added to the -mm mm-unstable branch.  Its filename is
     zram-move-immutable-comp-params-away-from-per-cpu-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-immutable-comp-params-away-from-per-cpu-context.patch

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
Subject: zram: move immutable comp params away from per-CPU context
Date: Fri, 12 Jul 2024 14:18:30 +0900

Immutable params never change once comp has been allocated
and setup, so we don't need to store multiple copies of
them in each per-CPU backend context.  Move those to
per-comp zcomp_params and pass it to backends callbacks
for requests execution.  Basically, this means parameters
sharing between different contexts.

Also introduce two new backends callbacks: setup_params()
and release_params().  First, we need to validate params
in a driver-specific way; second, driver may want to
allocate its specific representation of the params which
is needed to execute requests.

Link: https://lkml.kernel.org/r/20240712051850.484318-20-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |   17 +++++++-
 drivers/block/zram/backend_deflate.c |   29 +++++++++-----
 drivers/block/zram/backend_lz4.c     |   51 +++++++++----------------
 drivers/block/zram/backend_lz4hc.c   |   51 +++++++++----------------
 drivers/block/zram/backend_lzo.c     |   17 +++++++-
 drivers/block/zram/backend_lzorle.c  |   17 +++++++-
 drivers/block/zram/backend_zstd.c    |   47 +++++++++++++++++------
 drivers/block/zram/zcomp.c           |   17 +++++---
 drivers/block/zram/zcomp.h           |   20 +++++++--
 9 files changed, 168 insertions(+), 98 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_842.c
@@ -7,6 +7,15 @@
 
 #include "backend_842.h"
 
+static void release_params_842(struct zcomp_params *params)
+{
+}
+
+static int setup_params_842(struct zcomp_params *params)
+{
+	return 0;
+}
+
 static void destroy_842(struct zcomp_ctx *ctx)
 {
 	kfree(ctx->context);
@@ -20,7 +29,8 @@ static int create_842(struct zcomp_param
 	return 0;
 }
 
-static int compress_842(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int compress_842(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			struct zcomp_req *req)
 {
 	unsigned int dlen = req->dst_len;
 	int ret;
@@ -32,7 +42,8 @@ static int compress_842(struct zcomp_ctx
 	return ret;
 }
 
-static int decompress_842(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int decompress_842(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			  struct zcomp_req *req)
 {
 	unsigned int dlen = req->dst_len;
 
@@ -44,5 +55,7 @@ const struct zcomp_ops backend_842 = {
 	.decompress	= decompress_842,
 	.create_ctx	= create_842,
 	.destroy_ctx	= destroy_842,
+	.setup_params	= setup_params_842,
+	.release_params	= release_params_842,
 	.name		= "842",
 };
--- a/drivers/block/zram/backend_deflate.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_deflate.c
@@ -14,9 +14,20 @@
 struct deflate_ctx {
 	struct z_stream_s cctx;
 	struct z_stream_s dctx;
-	s32 level;
 };
 
+static void deflate_release_params(struct zcomp_params *params)
+{
+}
+
+static int deflate_setup_params(struct zcomp_params *params)
+{
+	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+		params->level = Z_DEFAULT_COMPRESSION;
+
+	return 0;
+}
+
 static void deflate_destroy(struct zcomp_ctx *ctx)
 {
 	struct deflate_ctx *zctx = ctx->context;
@@ -46,17 +57,12 @@ static int deflate_create(struct zcomp_p
 		return -ENOMEM;
 
 	ctx->context = zctx;
-	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		zctx->level = params->level;
-	else
-		zctx->level = Z_DEFAULT_COMPRESSION;
-
 	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
 	zctx->cctx.workspace = vzalloc(sz);
 	if (!zctx->cctx.workspace)
 		goto error;
 
-	ret = zlib_deflateInit2(&zctx->cctx, zctx->level, Z_DEFLATED,
+	ret = zlib_deflateInit2(&zctx->cctx, params->level, Z_DEFLATED,
 				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
 				Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK)
@@ -78,7 +84,8 @@ error:
 	return -EINVAL;
 }
 
-static int deflate_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int deflate_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			    struct zcomp_req *req)
 {
 	struct deflate_ctx *zctx = ctx->context;
 	struct z_stream_s *deflate;
@@ -102,7 +109,9 @@ static int deflate_compress(struct zcomp
 	return 0;
 }
 
-static int deflate_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int deflate_decompress(struct zcomp_params *params,
+			      struct zcomp_ctx *ctx,
+			      struct zcomp_req *req)
 {
 	struct deflate_ctx *zctx = ctx->context;
 	struct z_stream_s *inflate;
@@ -131,5 +140,7 @@ const struct zcomp_ops backend_deflate =
 	.decompress	= deflate_decompress,
 	.create_ctx	= deflate_create,
 	.destroy_ctx	= deflate_destroy,
+	.setup_params	= deflate_setup_params,
+	.release_params	= deflate_release_params,
 	.name		= "deflate",
 };
--- a/drivers/block/zram/backend_lz4.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_lz4.c
@@ -5,60 +5,47 @@
 
 #include "backend_lz4.h"
 
-struct lz4_ctx {
-	void *mem;
-	s32 level;
-};
+static void lz4_release_params(struct zcomp_params *params)
+{
+}
 
-static void lz4_destroy(struct zcomp_ctx *ctx)
+static int lz4_setup_params(struct zcomp_params *params)
 {
-	struct lz4_ctx *zctx = ctx->context;
+	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+		params->level = LZ4_ACCELERATION_DEFAULT;
 
-	if (!zctx)
-		return;
+	return 0;
+}
 
-	vfree(zctx->mem);
-	kfree(zctx);
+static void lz4_destroy(struct zcomp_ctx *ctx)
+{
+	vfree(ctx->context);
 }
 
 static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4_ctx *zctx;
-
-	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
-	if (!zctx)
+	ctx->context = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx->context)
 		return -ENOMEM;
 
-	ctx->context = zctx;
-	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		zctx->level = params->level;
-	else
-		zctx->level = LZ4_ACCELERATION_DEFAULT;
-
-	zctx->mem = vmalloc(LZ4_MEM_COMPRESS);
-	if (!zctx->mem)
-		goto error;
-
 	return 0;
-error:
-	lz4_destroy(ctx);
-	return -EINVAL;
 }
 
-static int lz4_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			struct zcomp_req *req)
 {
-	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
 	ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
-				req->dst_len, zctx->level, zctx->mem);
+				req->dst_len, params->level, ctx->context);
 	if (!ret)
 		return -EINVAL;
 	req->dst_len = ret;
 	return 0;
 }
 
-static int lz4_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lz4_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			  struct zcomp_req *req)
 {
 	int ret;
 
@@ -74,5 +61,7 @@ const struct zcomp_ops backend_lz4 = {
 	.decompress	= lz4_decompress,
 	.create_ctx	= lz4_create,
 	.destroy_ctx	= lz4_destroy,
+	.setup_params	= lz4_setup_params,
+	.release_params	= lz4_release_params,
 	.name		= "lz4",
 };
--- a/drivers/block/zram/backend_lz4hc.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -5,60 +5,47 @@
 
 #include "backend_lz4hc.h"
 
-struct lz4hc_ctx {
-	void *mem;
-	s32 level;
-};
+static void lz4hc_release_params(struct zcomp_params *params)
+{
+}
 
-static void lz4hc_destroy(struct zcomp_ctx *ctx)
+static int lz4hc_setup_params(struct zcomp_params *params)
 {
-	struct lz4hc_ctx *zctx = ctx->context;
+	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+		params->level = LZ4HC_DEFAULT_CLEVEL;
 
-	if (!zctx)
-		return;
+	return 0;
+}
 
-	vfree(zctx->mem);
-	kfree(zctx);
+static void lz4hc_destroy(struct zcomp_ctx *ctx)
+{
+	vfree(ctx->context);
 }
 
 static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	struct lz4hc_ctx *zctx;
-
-	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
-	if (!zctx)
+	ctx->context = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx->context)
 		return -ENOMEM;
 
-	ctx->context = zctx;
-	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		zctx->level = params->level;
-	else
-		zctx->level = LZ4HC_DEFAULT_CLEVEL;
-
-	zctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
-	if (!zctx->mem)
-		goto error;
-
 	return 0;
-error:
-	lz4hc_destroy(ctx);
-	return -EINVAL;
 }
 
-static int lz4hc_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			  struct zcomp_req *req)
 {
-	struct lz4hc_ctx *zctx = ctx->context;
 	int ret;
 
 	ret = LZ4_compress_HC(req->src, req->dst, req->src_len, req->dst_len,
-			      zctx->level, zctx->mem);
+			      params->level, ctx->context);
 	if (!ret)
 		return -EINVAL;
 	req->dst_len = ret;
 	return 0;
 }
 
-static int lz4hc_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lz4hc_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			    struct zcomp_req *req)
 {
 	int ret;
 
@@ -74,5 +61,7 @@ const struct zcomp_ops backend_lz4hc = {
 	.decompress	= lz4hc_decompress,
 	.create_ctx	= lz4hc_create,
 	.destroy_ctx	= lz4hc_destroy,
+	.setup_params	= lz4hc_setup_params,
+	.release_params	= lz4hc_release_params,
 	.name		= "lz4hc",
 };
--- a/drivers/block/zram/backend_lzo.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_lzo.c
@@ -6,6 +6,15 @@
 
 #include "backend_lzo.h"
 
+static void lzo_release_params(struct zcomp_params *params)
+{
+}
+
+static int lzo_setup_params(struct zcomp_params *params)
+{
+	return 0;
+}
+
 static int lzo_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
 	ctx->context = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
@@ -19,7 +28,8 @@ static void lzo_destroy(struct zcomp_ctx
 	kfree(ctx->context);
 }
 
-static int lzo_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lzo_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			struct zcomp_req *req)
 {
 	int ret;
 
@@ -28,7 +38,8 @@ static int lzo_compress(struct zcomp_ctx
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzo_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lzo_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			  struct zcomp_req *req)
 {
 	int ret;
 
@@ -42,5 +53,7 @@ const struct zcomp_ops backend_lzo = {
 	.decompress	= lzo_decompress,
 	.create_ctx	= lzo_create,
 	.destroy_ctx	= lzo_destroy,
+	.setup_params	= lzo_setup_params,
+	.release_params	= lzo_release_params,
 	.name		= "lzo",
 };
--- a/drivers/block/zram/backend_lzorle.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_lzorle.c
@@ -6,6 +6,15 @@
 
 #include "backend_lzorle.h"
 
+static void lzorle_release_params(struct zcomp_params *params)
+{
+}
+
+static int lzorle_setup_params(struct zcomp_params *params)
+{
+	return 0;
+}
+
 static int lzorle_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
 	ctx->context = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
@@ -19,7 +28,8 @@ static void lzorle_destroy(struct zcomp_
 	kfree(ctx->context);
 }
 
-static int lzorle_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lzorle_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			   struct zcomp_req *req)
 {
 	int ret;
 
@@ -28,7 +38,8 @@ static int lzorle_compress(struct zcomp_
 	return ret == LZO_E_OK ? 0 : ret;
 }
 
-static int lzorle_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int lzorle_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			     struct zcomp_req *req)
 {
 	int ret;
 
@@ -42,5 +53,7 @@ const struct zcomp_ops backend_lzorle =
 	.decompress	= lzorle_decompress,
 	.create_ctx	= lzorle_create,
 	.destroy_ctx	= lzorle_destroy,
+	.setup_params	= lzorle_setup_params,
+	.release_params	= lzorle_release_params,
 	.name		= "lzo-rle",
 };
--- a/drivers/block/zram/backend_zstd.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/backend_zstd.c
@@ -10,12 +10,36 @@
 struct zstd_ctx {
 	zstd_cctx *cctx;
 	zstd_dctx *dctx;
-	zstd_parameters cprm;
 	void *cctx_mem;
 	void *dctx_mem;
-	s32 level;
 };
 
+struct zstd_params {
+	zstd_parameters cprm;
+};
+
+static void zstd_release_params(struct zcomp_params *params)
+{
+	kfree(params->drv_data);
+}
+
+static int zstd_setup_params(struct zcomp_params *params)
+{
+	struct zstd_params *zp;
+
+	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
+	if (!zp)
+		return -ENOMEM;
+
+	if (params->level == ZCOMP_PARAM_NO_LEVEL)
+		params->level = zstd_default_clevel();
+
+	zp->cprm = zstd_get_params(params->level, PAGE_SIZE);
+	params->drv_data = zp;
+
+	return 0;
+}
+
 static void zstd_destroy(struct zcomp_ctx *ctx)
 {
 	struct zstd_ctx *zctx = ctx->context;
@@ -39,13 +63,7 @@ static int zstd_create(struct zcomp_para
 		return -ENOMEM;
 
 	ctx->context = zctx;
-	if (params->level != ZCOMP_PARAM_NO_LEVEL)
-		zctx->level = params->level;
-	else
-		zctx->level = zstd_default_clevel();
-
-	prm = zstd_get_params(zctx->level, PAGE_SIZE);
-	zctx->cprm = zstd_get_params(zctx->level, PAGE_SIZE);
+	prm = zstd_get_params(params->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&prm.cParams);
 	zctx->cctx_mem = vzalloc(sz);
 	if (!zctx->cctx_mem)
@@ -71,20 +89,23 @@ error:
 	return -EINVAL;
 }
 
-static int zstd_compress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int zstd_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			 struct zcomp_req *req)
 {
+	struct zstd_params *zp = params->drv_data;
 	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
-				 req->src, req->src_len, &zctx->cprm);
+				 req->src, req->src_len, &zp->cprm);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	req->dst_len = ret;
 	return 0;
 }
 
-static int zstd_decompress(struct zcomp_ctx *ctx, struct zcomp_req *req)
+static int zstd_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			   struct zcomp_req *req)
 {
 	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
@@ -101,5 +122,7 @@ const struct zcomp_ops backend_zstd = {
 	.decompress	= zstd_decompress,
 	.create_ctx	= zstd_create,
 	.destroy_ctx	= zstd_destroy,
+	.setup_params	= zstd_setup_params,
+	.release_params	= zstd_release_params,
 	.name		= "zstd",
 };
--- a/drivers/block/zram/zcomp.c~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/zcomp.c
@@ -128,7 +128,7 @@ int zcomp_compress(struct zcomp *comp, s
 	};
 	int ret;
 
-	ret = comp->ops->compress(&zstrm->ctx, &req);
+	ret = comp->ops->compress(comp->params, &zstrm->ctx, &req);
 	if (!ret)
 		*dst_len = req.dst_len;
 	return ret;
@@ -144,7 +144,7 @@ int zcomp_decompress(struct zcomp *comp,
 		.dst_len = PAGE_SIZE,
 	};
 
-	return comp->ops->decompress(&zstrm->ctx, &req);
+	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
@@ -172,7 +172,7 @@ int zcomp_cpu_dead(unsigned int cpu, str
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 {
 	int ret;
 
@@ -180,12 +180,19 @@ static int zcomp_init(struct zcomp *comp
 	if (!comp->stream)
 		return -ENOMEM;
 
+	comp->params = params;
+	ret = comp->ops->setup_params(comp->params);
+	if (ret)
+		goto cleanup;
+
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
 		goto cleanup;
+
 	return 0;
 
 cleanup:
+	comp->ops->release_params(comp->params);
 	free_percpu(comp->stream);
 	return ret;
 }
@@ -193,6 +200,7 @@ cleanup:
 void zcomp_destroy(struct zcomp *comp)
 {
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
+	comp->ops->release_params(comp->params);
 	free_percpu(comp->stream);
 	kfree(comp);
 }
@@ -214,14 +222,13 @@ struct zcomp *zcomp_create(const char *a
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
-	comp->params = params;
 	comp->ops = lookup_backend_ops(alg);
 	if (!comp->ops) {
 		kfree(comp);
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp);
+	error = zcomp_init(comp, params);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
--- a/drivers/block/zram/zcomp.h~zram-move-immutable-comp-params-away-from-per-cpu-context
+++ a/drivers/block/zram/zcomp.h
@@ -7,10 +7,18 @@
 
 #define ZCOMP_PARAM_NO_LEVEL	INT_MIN
 
+/*
+ * Immutable driver (backend) parameters. The driver may attach private
+ * data to it (e.g. driver representation of the dictionary, etc.).
+ *
+ * This data is kept per-comp and is shared among execution contexts.
+ */
 struct zcomp_params {
 	void *dict;
 	size_t dict_sz;
 	s32 level;
+
+	void *drv_data;
 };
 
 /*
@@ -38,13 +46,17 @@ struct zcomp_req {
 };
 
 struct zcomp_ops {
-	int (*compress)(struct zcomp_ctx *ctx, struct zcomp_req *req);
-	int (*decompress)(struct zcomp_ctx *ctx, struct zcomp_req *req);
+	int (*compress)(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			struct zcomp_req *req);
+	int (*decompress)(struct zcomp_params *params, struct zcomp_ctx *ctx,
+			  struct zcomp_req *req);
 
-	int (*create_ctx)(struct zcomp_params *params,
-			  struct zcomp_ctx *ctx);
+	int (*create_ctx)(struct zcomp_params *params, struct zcomp_ctx *ctx);
 	void (*destroy_ctx)(struct zcomp_ctx *ctx);
 
+	int (*setup_params)(struct zcomp_params *params);
+	void (*release_params)(struct zcomp_params *params);
+
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

