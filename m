Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE4C1487C5
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417137; cv=none; b=CCQ2aJ1QV9Y6+KFMbOzW06FI0mtX6EBlg/ZfJhk2GNYzoJXCckBu1DtBQaEH+AAwAkJVPqgXI6rMqekwmlnrvYzqjZivasJyvsxNm2SmdfM2Pi63mPXrjIJNh0vFPE6AukDrS3BTlcYvNrUsGzX0ui2NGMWp3NvGigqILn1D5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417137; c=relaxed/simple;
	bh=KJG7h7NNp4zH9evhyBLan4WTwes3Pf5owq8bus4g9ao=;
	h=Date:To:From:Subject:Message-Id; b=nU12/mNJDtp+8vE/XOQTMOqRlJVtB4TM9nAt3RqGPLDhTBjGzc7+QjTMy+WTDXKputVY025rTHBHc0LbqwP9nhlvLhpMwMebyBQijxzWaCkH2Cio3PV6Wvm6A0cWigPaVPFB3qqS3cWDOK1Sgn7OZCbG0vEBdfnI5XoU0A1zGv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gh6g+YRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gh6g+YRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4E7C3277B;
	Wed, 22 May 2024 22:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417137;
	bh=KJG7h7NNp4zH9evhyBLan4WTwes3Pf5owq8bus4g9ao=;
	h=Date:To:From:Subject:From;
	b=Gh6g+YRhSX7dM2XgMLyjVDwkZFWt07utmyeUQINQwHrXKHX0TSEomaVMAJSkU9uhi
	 C/5IrN6kh+NrDUFoCjtHwv7NQ/r7M29BqRMQE7q048XCq/Y4jOSxjK1UNfyXS94mKC
	 X3qbM1dEZ3xfq5h4Uc+Hmcl056guhyB9inM6vgSE=
Date: Wed, 22 May 2024 15:32:16 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-share-dictionaries-between-per-cpu-contexts.patch added to mm-unstable branch
Message-Id: <20240522223217.6E4E7C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: share dictionaries between per-CPU contexts
has been added to the -mm mm-unstable branch.  Its filename is
     zram-share-dictionaries-between-per-cpu-contexts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-share-dictionaries-between-per-cpu-contexts.patch

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
Subject: zram: share dictionaries between per-CPU contexts
Date: Wed, 15 May 2024 16:12:54 +0900

zstd's CDict and DDict are accessed read-only during compression and
decompression, so instead of allocation per-context dictionaries we can
create just one CDict and DDict in init_config() and make per-CPU contexts
use them.  This saves quite a lot of memory: on my system CDict requires
408128 bytes and DDict requires 27352 bytes.

Link: https://lkml.kernel.org/r/20240515071645.1788128-18-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |  108 ++++++++++++++++++----------
 1 file changed, 72 insertions(+), 36 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-share-dictionaries-between-per-cpu-contexts
+++ a/drivers/block/zram/backend_zstd.c
@@ -7,14 +7,18 @@
 
 #include "backend_zstd.h"
 
+struct zstd_ctx_data {
+	zstd_custom_mem ctx_mem;
+	zstd_cdict *cdict;
+	zstd_ddict *ddict;
+};
+
 struct zstd_ctx {
 	zstd_cctx *cctx;
 	zstd_dctx *dctx;
 	void *cctx_mem;
 	void *dctx_mem;
-	zstd_custom_mem ctx_mem;
-	zstd_cdict *cdict;
-	zstd_ddict *ddict;
+	struct zstd_ctx_data *ctx_data;
 	s32 level;
 };
 
@@ -38,32 +42,81 @@ static void zstd_ctx_free(void *opaque,
 
 static int zstd_init_config(struct zcomp_config *config)
 {
+	struct zstd_ctx_data *ctx_data = config->private;
+	zstd_compression_parameters params;
+
+	/* Already initialized */
+	if (ctx_data)
+		return 0;
+
 	if (config->level == ZCOMP_CONFIG_NO_LEVEL)
 		config->level = zstd_default_clevel();
 
+	if (config->dict_sz == 0)
+		return 0;
+
+	ctx_data = kzalloc(sizeof(*ctx_data), GFP_KERNEL);
+	if (!ctx_data)
+		return -ENOMEM;
+
+	ctx_data->ctx_mem.customAlloc = zstd_ctx_alloc;
+	ctx_data->ctx_mem.customFree = zstd_ctx_free;
+
+	params = zstd_get_cparams(config->level, PAGE_SIZE, config->dict_sz);
+
+	ctx_data->cdict = zstd_create_cdict_advanced(config->dict,
+						     config->dict_sz,
+						     ZSTD_dlm_byRef,
+						     ZSTD_dct_auto,
+						     params,
+						     ctx_data->ctx_mem);
+	if (!ctx_data->cdict)
+		goto error;
+
+	ctx_data->ddict = zstd_create_ddict_advanced(config->dict,
+						     config->dict_sz,
+						     ZSTD_dlm_byRef,
+						     ZSTD_dct_auto,
+						     ctx_data->ctx_mem);
+	if (!ctx_data->ddict)
+		goto error;
+
+	config->private = ctx_data;
 	return 0;
+
+error:
+	zstd_free_cdict(ctx_data->cdict);
+	zstd_free_ddict(ctx_data->ddict);
+	kfree(ctx_data);
+	return -EINVAL;
 }
 
 static void zstd_release_config(struct zcomp_config *config)
 {
+	struct zstd_ctx_data *ctx_data = config->private;
+
+	if (!ctx_data)
+		return;
+
+	config->private = NULL;
+	zstd_free_cdict(ctx_data->cdict);
+	zstd_free_ddict(ctx_data->ddict);
+	kfree(ctx_data);
 }
 
 static void zstd_destroy(void *ctx)
 {
 	struct zstd_ctx *zctx = ctx;
 
+	/* Don't free zctx->ctx_data, it's done in release_config() */
 	if (zctx->cctx_mem)
 		vfree(zctx->cctx_mem);
 	else
 		zstd_free_cctx(zctx->cctx);
-
 	if (zctx->dctx_mem)
 		vfree(zctx->dctx_mem);
 	else
 		zstd_free_dctx(zctx->dctx);
-
-	zstd_free_cdict(zctx->cdict);
-	zstd_free_ddict(zctx->ddict);
 	kfree(zctx);
 }
 
@@ -75,9 +128,8 @@ static void *zstd_create(struct zcomp_co
 	if (!ctx)
 		return NULL;
 
+	ctx->ctx_data = config->private;
 	ctx->level = config->level;
-	ctx->ctx_mem.customAlloc = zstd_ctx_alloc;
-	ctx->ctx_mem.customFree = zstd_ctx_free;
 
 	if (config->dict_sz == 0) {
 		zstd_parameters params;
@@ -102,35 +154,15 @@ static void *zstd_create(struct zcomp_co
 		if (!ctx->dctx)
 			goto error;
 	} else {
-		zstd_compression_parameters params;
+		struct zstd_ctx_data *ctx_data = ctx->ctx_data;
 
-		ctx->cctx = zstd_create_cctx_advanced(ctx->ctx_mem);
+		ctx->cctx = zstd_create_cctx_advanced(ctx_data->ctx_mem);
 		if (!ctx->cctx)
 			goto error;
 
-		ctx->dctx = zstd_create_dctx_advanced(ctx->ctx_mem);
+		ctx->dctx = zstd_create_dctx_advanced(ctx_data->ctx_mem);
 		if (!ctx->dctx)
 			goto error;
-
-		params = zstd_get_cparams(ctx->level, PAGE_SIZE,
-					  config->dict_sz);
-
-		ctx->cdict = zstd_create_cdict_advanced(config->dict,
-							config->dict_sz,
-							ZSTD_dlm_byRef,
-							ZSTD_dct_auto,
-							params,
-							ctx->ctx_mem);
-		if (!ctx->cdict)
-			goto error;
-
-		ctx->ddict = zstd_create_ddict_advanced(config->dict,
-							config->dict_sz,
-							ZSTD_dlm_byRef,
-							ZSTD_dct_auto,
-							ctx->ctx_mem);
-		if (!ctx->ddict)
-			goto error;
 	}
 
 	return ctx;
@@ -144,15 +176,17 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
+	struct zstd_ctx_data *ctx_data = zctx->ctx_data;
 	const zstd_parameters params = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
-	if (!zctx->cdict)
+	if (!ctx_data)
 		ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
 					 src, PAGE_SIZE, &params);
 	else
 		ret = zstd_compress_using_cdict(zctx->cctx, dst, *dst_len,
-						src, PAGE_SIZE, zctx->cdict);
+						src, PAGE_SIZE,
+						ctx_data->cdict);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	*dst_len = ret;
@@ -163,14 +197,16 @@ static int zstd_decompress(void *ctx, co
 			   unsigned char *dst)
 {
 	struct zstd_ctx *zctx = ctx;
+	struct zstd_ctx_data *ctx_data = zctx->ctx_data;
 	size_t ret;
 
-	if (!zctx->ddict)
+	if (!ctx_data)
 		ret = zstd_decompress_dctx(zctx->dctx, dst, PAGE_SIZE,
 					   src, src_len);
 	else
 		ret = zstd_decompress_using_ddict(zctx->dctx, dst, PAGE_SIZE,
-						  src, src_len, zctx->ddict);
+						  src, src_len,
+						  ctx_data->ddict);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	return 0;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-move-from-crypto-api-to-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_config-structure.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-support-compression-level-comp-config.patch
zram-add-support-for-dict-comp-config.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
zram-add-dictionary-support-to-zstd-backend.patch
zram-add-config-init-release-backend-callbacks.patch
zram-share-dictionaries-between-per-cpu-contexts.patch
zram-add-dictionary-support-to-lz4.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
zram-add-dictionary-support-to-lz4hc.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

