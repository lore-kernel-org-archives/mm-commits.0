Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7FC613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849204; cv=none; b=UMgNBvVzreg6wxRm/Q158jif98ieJJxNkb1dyhG9kRjUstkdQkwo5OIsH/cs8ENmhGQmWA6N5jDTB7S6nYhm5EVNHUEv+vgG89SNgA0d5yKyA9RwXtLMa4J6AtAtgohSTiTMuB6qirTP+v681nBd6Fe0mG0ZRE81tnFkPrxMaM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849204; c=relaxed/simple;
	bh=Ree9jrIydhhsBeyzrfSPed4rxlwqcw8bdESongjycWs=;
	h=Date:To:From:Subject:Message-Id; b=g8oEm+M0Q7qBfrjEMoo/+IoXwswLJWUXEuttCP0WBoOfRKP4b4t+cU7GXspPlfkDP5ixz301Kl5FQPmGau2VLRBS2Y4XS+Xu1eYXhkgy6IAX1pS1t4QGxMxU0vUAfpdDaVvhxyZ5b+omfMIM+YCSY79qbNvezHBGTEvDsYX9Oxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQc3C6pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQc3C6pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BABC32781;
	Wed, 24 Jul 2024 19:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849203;
	bh=Ree9jrIydhhsBeyzrfSPed4rxlwqcw8bdESongjycWs=;
	h=Date:To:From:Subject:From;
	b=XQc3C6pcBZ3hiOqdmcYU3EnhkDN4LLTY2obTKrCOeP2+G8t5USFQgoFB2exWb2Axf
	 3C69esdnPXXaXr13DRdtHBfjeRzyU51oXQdLp6B50ALQkB7ZcdGOV8XjSe+tgEVOmA
	 otkCksM/EL3H5aALHDPuRXsmH2uv9fyhSWpevzyo=
Date: Wed, 24 Jul 2024 12:26:42 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-zcomp_params-structure.patch added to mm-unstable branch
Message-Id: <20240724192643.79BABC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce zcomp_params structure
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-zcomp_params-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-zcomp_params-structure.patch

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
Subject: zram: introduce zcomp_params structure
Date: Fri, 12 Jul 2024 14:18:24 +0900

We will store a per-algorithm parameters there (compression level,
dictionary, dictionary size, etc.).

Link: https://lkml.kernel.org/r/20240712051850.484318-14-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |    2 +-
 drivers/block/zram/backend_deflate.c |    9 ++++++---
 drivers/block/zram/backend_lz4.c     |    9 ++++++---
 drivers/block/zram/backend_lz4hc.c   |    9 ++++++---
 drivers/block/zram/backend_lzo.c     |    2 +-
 drivers/block/zram/backend_lzorle.c  |    2 +-
 drivers/block/zram/backend_zstd.c    |   18 +++++++++++-------
 drivers/block/zram/zcomp.c           |    5 +++--
 drivers/block/zram/zcomp.h           |   14 ++++++++++++--
 drivers/block/zram/zram_drv.c        |   20 +++++++++++++++++++-
 drivers/block/zram/zram_drv.h        |    1 +
 11 files changed, 67 insertions(+), 24 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_842.c
@@ -19,7 +19,7 @@ static void destroy_842(void *ctx)
 	kfree(zctx);
 }
 
-static void *create_842(void)
+static void *create_842(struct zcomp_params *params)
 {
 	struct sw842_ctx *ctx;
 
--- a/drivers/block/zram/backend_deflate.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_deflate.c
@@ -32,7 +32,7 @@ static void deflate_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *deflate_create(void)
+static void *deflate_create(struct zcomp_params *params)
 {
 	struct deflate_ctx *ctx;
 	size_t sz;
@@ -42,8 +42,11 @@ static void *deflate_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded Z_DEFAULT_COMPRESSION for now */
-	ctx->level = Z_DEFAULT_COMPRESSION;
+	if (params->level != ZCOMP_PARAM_NO_LEVEL)
+		ctx->level = params->level;
+	else
+		ctx->level = Z_DEFAULT_COMPRESSION;
+
 	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
 	ctx->cctx.workspace = vzalloc(sz);
 	if (!ctx->cctx.workspace)
--- a/drivers/block/zram/backend_lz4.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_lz4.c
@@ -18,7 +18,7 @@ static void lz4_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *lz4_create(void)
+static void *lz4_create(struct zcomp_params *params)
 {
 	struct lz4_ctx *ctx;
 
@@ -26,8 +26,11 @@ static void *lz4_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded LZ4_ACCELERATION_DEFAULT for now */
-	ctx->level = LZ4_ACCELERATION_DEFAULT;
+	if (params->level != ZCOMP_PARAM_NO_LEVEL)
+		ctx->level = params->level;
+	else
+		ctx->level = LZ4_ACCELERATION_DEFAULT;
+
 	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
--- a/drivers/block/zram/backend_lz4hc.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -18,7 +18,7 @@ static void lz4hc_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *lz4hc_create(void)
+static void *lz4hc_create(struct zcomp_params *params)
 {
 	struct lz4hc_ctx *ctx;
 
@@ -26,8 +26,11 @@ static void *lz4hc_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded LZ4HC_DEFAULT_CLEVEL for now */
-	ctx->level = LZ4HC_DEFAULT_CLEVEL;
+	if (params->level != ZCOMP_PARAM_NO_LEVEL)
+		ctx->level = params->level;
+	else
+		ctx->level = LZ4HC_DEFAULT_CLEVEL;
+
 	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
--- a/drivers/block/zram/backend_lzo.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_lzo.c
@@ -6,7 +6,7 @@
 
 #include "backend_lzo.h"
 
-static void *lzo_create(void)
+static void *lzo_create(struct zcomp_params *params)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 }
--- a/drivers/block/zram/backend_lzorle.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_lzorle.c
@@ -6,7 +6,7 @@
 
 #include "backend_lzorle.h"
 
-static void *lzorle_create(void)
+static void *lzorle_create(struct zcomp_params *params)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 }
--- a/drivers/block/zram/backend_zstd.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/backend_zstd.c
@@ -24,9 +24,9 @@ static void zstd_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *zstd_create(void)
+static void *zstd_create(struct zcomp_params *params)
 {
-	zstd_parameters params;
+	zstd_parameters prm;
 	struct zstd_ctx *ctx;
 	size_t sz;
 
@@ -34,9 +34,13 @@ static void *zstd_create(void)
 	if (!ctx)
 		return NULL;
 
-	ctx->level = zstd_default_clevel();
-	params = zstd_get_params(ctx->level, PAGE_SIZE);
-	sz = zstd_cctx_workspace_bound(&params.cParams);
+	if (params->level != ZCOMP_PARAM_NO_LEVEL)
+		ctx->level = params->level;
+	else
+		ctx->level = zstd_default_clevel();
+
+	prm = zstd_get_params(ctx->level, PAGE_SIZE);
+	sz = zstd_cctx_workspace_bound(&prm.cParams);
 	ctx->cctx_mem = vzalloc(sz);
 	if (!ctx->cctx_mem)
 		goto error;
@@ -65,11 +69,11 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters params = zstd_get_params(zctx->level, PAGE_SIZE);
+	const zstd_parameters prm = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
-				 src, src_len, &params);
+				 src, src_len, &prm);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	*dst_len = ret;
--- a/drivers/block/zram/zcomp.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/zcomp.c
@@ -54,7 +54,7 @@ static void zcomp_strm_free(struct zcomp
 
 static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	zstrm->ctx = comp->ops->create_ctx();
+	zstrm->ctx = comp->ops->create_ctx(comp->params);
 
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
@@ -186,7 +186,7 @@ void zcomp_destroy(struct zcomp *comp)
 	kfree(comp);
 }
 
-struct zcomp *zcomp_create(const char *alg)
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 {
 	struct zcomp *comp;
 	int error;
@@ -203,6 +203,7 @@ struct zcomp *zcomp_create(const char *a
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
+	comp->params = params;
 	comp->ops = lookup_backend_ops(alg);
 	if (!comp->ops) {
 		kfree(comp);
--- a/drivers/block/zram/zcomp.h~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/zcomp.h
@@ -2,8 +2,17 @@
 
 #ifndef _ZCOMP_H_
 #define _ZCOMP_H_
+
 #include <linux/local_lock.h>
 
+#define ZCOMP_PARAM_NO_LEVEL	INT_MIN
+
+struct zcomp_params {
+	void *dict;
+	size_t dict_sz;
+	s32 level;
+};
+
 struct zcomp_strm {
 	/* The members ->buffer and ->tfm are protected by ->lock. */
 	local_lock_t lock;
@@ -19,7 +28,7 @@ struct zcomp_ops {
 	int (*decompress)(void *ctx, const unsigned char *src, size_t src_len,
 			  unsigned char *dst, size_t dst_len);
 
-	void *(*create_ctx)(void);
+	void *(*create_ctx)(struct zcomp_params *params);
 	void (*destroy_ctx)(void *ctx);
 
 	const char *name;
@@ -29,6 +38,7 @@ struct zcomp_ops {
 struct zcomp {
 	struct zcomp_strm __percpu *stream;
 	const struct zcomp_ops *ops;
+	struct zcomp_params *params;
 	struct hlist_node node;
 };
 
@@ -37,7 +47,7 @@ int zcomp_cpu_dead(unsigned int cpu, str
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
--- a/drivers/block/zram/zram_drv.c~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/zram_drv.c
@@ -1979,6 +1979,20 @@ static void zram_slot_free_notify(struct
 	zram_slot_unlock(zram, index);
 }
 
+static void zram_reset_comp_params(struct zram *zram)
+{
+	u32 prio;
+
+	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+		struct zcomp_params *params = &zram->params[prio];
+
+		vfree(params->dict);
+		params->level = ZCOMP_PARAM_NO_LEVEL;
+		params->dict_sz = 0;
+		params->dict = NULL;
+	}
+}
+
 static void zram_destroy_comps(struct zram *zram)
 {
 	u32 prio;
@@ -1992,6 +2006,8 @@ static void zram_destroy_comps(struct zr
 		zcomp_destroy(comp);
 		zram->num_active_comps--;
 	}
+
+	zram_reset_comp_params(zram);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2049,7 +2065,8 @@ static ssize_t disksize_store(struct dev
 		if (!zram->comp_algs[prio])
 			continue;
 
-		comp = zcomp_create(zram->comp_algs[prio]);
+		comp = zcomp_create(zram->comp_algs[prio],
+				    &zram->params[prio]);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
@@ -2254,6 +2271,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
+	zram_reset_comp_params(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
 	zram_debugfs_register(zram);
--- a/drivers/block/zram/zram_drv.h~zram-introduce-zcomp_params-structure
+++ a/drivers/block/zram/zram_drv.h
@@ -107,6 +107,7 @@ struct zram {
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
 	struct zcomp *comps[ZRAM_MAX_COMPS];
+	struct zcomp_params params[ZRAM_MAX_COMPS];
 	struct gendisk *disk;
 	/* Prevent concurrent execution of device init */
 	struct rw_semaphore init_lock;
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

