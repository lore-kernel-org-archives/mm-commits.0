Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7720B142910
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417123; cv=none; b=PW/oxaX1+zSPGGPfXT+hPUwRnkjQx5vTSd1XtGtc5LCAeu9D2sltXFcE4YGygjBXi6nJt/rUWcSpMurkJX382CU1rEGyIEXGXAY7as0yIo/n9qJT+Q7h/7eomz68EQQKrxZoKEc4oMCVoX7BbsPYu5+kt+3NekK0csaV+EHqfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417123; c=relaxed/simple;
	bh=Cki+muecOsmvxq5beljmBwprEarK8gDDBKjSe5vj1Qo=;
	h=Date:To:From:Subject:Message-Id; b=FxXBBYy9lYcc7SzoXgia0W8Jk9L69hOsUpclKL/dc/H38faxZExwq8advh3V+f5usXKLr41rqkT3KLyRQYFNodKZFVDNvmsuvbcIxxlwGvmxuwa+0T1x9zxAHO5PFZCbUYTSXDwLIzfnTgd4a6ftr0TzUXybLfKBLpZDavN1Sqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IPvNyH7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IPvNyH7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3135C2BBFC;
	Wed, 22 May 2024 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417123;
	bh=Cki+muecOsmvxq5beljmBwprEarK8gDDBKjSe5vj1Qo=;
	h=Date:To:From:Subject:From;
	b=IPvNyH7KMsVk7ymLclmiHea4OlmXNbQei+y3GmBPdXtd0NlDfyHV9F8ALsvs40dKa
	 9pNvU6sbpRbRNc+HRnthE7drG8VTE2EZciNu9+vV2P2twq1xf+KM5DmI2YdQUKEq3r
	 ywD5zgydX6cUzQdwufMhIT3crJBzP8yJL4huPHBs=
Date: Wed, 22 May 2024 15:32:02 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-zcomp_config-structure.patch added to mm-unstable branch
Message-Id: <20240522223202.E3135C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: introduce zcomp_config structure
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-zcomp_config-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-zcomp_config-structure.patch

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
Subject: zram: introduce zcomp_config structure
Date: Wed, 15 May 2024 16:12:47 +0900

We will store a per-algorithm parameters there (compression level,
dictionary, dictionary size, etc.).

Link: https://lkml.kernel.org/r/20240515071645.1788128-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |    2 +-
 drivers/block/zram/backend_deflate.c |    9 ++++++---
 drivers/block/zram/backend_lz4.c     |    9 ++++++---
 drivers/block/zram/backend_lz4hc.c   |    9 ++++++---
 drivers/block/zram/backend_lzo.c     |    2 +-
 drivers/block/zram/backend_lzorle.c  |    2 +-
 drivers/block/zram/backend_zstd.c    |    8 ++++++--
 drivers/block/zram/zcomp.c           |    5 +++--
 drivers/block/zram/zcomp.h           |   14 ++++++++++++--
 drivers/block/zram/zram_drv.c        |   20 +++++++++++++++++++-
 drivers/block/zram/zram_drv.h        |    1 +
 11 files changed, 62 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_842.c
@@ -19,7 +19,7 @@ static void destroy_842(void *ctx)
 	kfree(zctx);
 }
 
-static void *create_842(void)
+static void *create_842(struct zcomp_config *config)
 {
 	struct sw842_ctx *ctx;
 
--- a/drivers/block/zram/backend_deflate.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_deflate.c
@@ -32,7 +32,7 @@ static void deflate_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *deflate_create(void)
+static void *deflate_create(struct zcomp_config *config)
 {
 	struct deflate_ctx *ctx;
 	size_t sz;
@@ -42,8 +42,11 @@ static void *deflate_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded Z_DEFAULT_COMPRESSION for now */
-	ctx->level = Z_DEFAULT_COMPRESSION;
+	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
+		ctx->level = config->level;
+	else
+		ctx->level = Z_DEFAULT_COMPRESSION;
+
 	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
 	ctx->cctx.workspace = vzalloc(sz);
 	if (!ctx->cctx.workspace)
--- a/drivers/block/zram/backend_lz4.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_lz4.c
@@ -18,7 +18,7 @@ static void lz4_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *lz4_create(void)
+static void *lz4_create(struct zcomp_config *config)
 {
 	struct lz4_ctx *ctx;
 
@@ -26,8 +26,11 @@ static void *lz4_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded LZ4_ACCELERATION_DEFAULT for now */
-	ctx->level = LZ4_ACCELERATION_DEFAULT;
+	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
+		ctx->level = config->level;
+	else
+		ctx->level = LZ4_ACCELERATION_DEFAULT;
+
 	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
--- a/drivers/block/zram/backend_lz4hc.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -18,7 +18,7 @@ static void lz4hc_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *lz4hc_create(void)
+static void *lz4hc_create(struct zcomp_config *config)
 {
 	struct lz4hc_ctx *ctx;
 
@@ -26,8 +26,11 @@ static void *lz4hc_create(void)
 	if (!ctx)
 		return NULL;
 
-	/* @FIXME: using a hardcoded LZ4HC_DEFAULT_CLEVEL for now */
-	ctx->level = LZ4HC_DEFAULT_CLEVEL;
+	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
+		ctx->level = config->level;
+	else
+		ctx->level = LZ4HC_DEFAULT_CLEVEL;
+
 	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
--- a/drivers/block/zram/backend_lzo.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_lzo.c
@@ -6,7 +6,7 @@
 
 #include "backend_lzo.h"
 
-static void *lzo_create(void)
+static void *lzo_create(struct zcomp_config *config)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 }
--- a/drivers/block/zram/backend_lzorle.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_lzorle.c
@@ -6,7 +6,7 @@
 
 #include "backend_lzorle.h"
 
-static void *lzorle_create(void)
+static void *lzorle_create(struct zcomp_config *config)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
 }
--- a/drivers/block/zram/backend_zstd.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/backend_zstd.c
@@ -24,7 +24,7 @@ static void zstd_destroy(void *ctx)
 	kfree(zctx);
 }
 
-static void *zstd_create(void)
+static void *zstd_create(struct zcomp_config *config)
 {
 	zstd_parameters params;
 	struct zstd_ctx *ctx;
@@ -34,7 +34,11 @@ static void *zstd_create(void)
 	if (!ctx)
 		return NULL;
 
-	ctx->level = zstd_default_clevel();
+	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
+		ctx->level = config->level;
+	else
+		ctx->level = zstd_default_clevel();
+
 	params = zstd_get_params(ctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&params.cParams);
 	ctx->cctx_mem = vzalloc(sz);
--- a/drivers/block/zram/zcomp.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/zcomp.c
@@ -61,7 +61,7 @@ static void zcomp_strm_free(struct zcomp
  */
 static int zcomp_strm_init(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	zstrm->ctx = comp->backend->create_ctx();
+	zstrm->ctx = comp->backend->create_ctx(comp->config);
 
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
@@ -204,7 +204,7 @@ void zcomp_destroy(struct zcomp *comp)
 	kfree(comp);
 }
 
-struct zcomp *zcomp_create(const char *alg)
+struct zcomp *zcomp_create(const char *alg, struct zcomp_config *config)
 {
 	struct zcomp *comp;
 	int error;
@@ -221,6 +221,7 @@ struct zcomp *zcomp_create(const char *a
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
+	comp->config = config;
 	comp->backend = lookup_backend(alg);
 	if (!comp->backend) {
 		kfree(comp);
--- a/drivers/block/zram/zcomp.h~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/zcomp.h
@@ -5,6 +5,7 @@
 
 #ifndef _ZCOMP_H_
 #define _ZCOMP_H_
+
 #include <linux/local_lock.h>
 
 struct zcomp_strm {
@@ -15,6 +16,14 @@ struct zcomp_strm {
 	void *ctx;
 };
 
+#define ZCOMP_CONFIG_NO_LEVEL	INT_MIN
+
+struct zcomp_config {
+	s32 level;
+	size_t dict_sz;
+	void *dict;
+};
+
 struct zcomp_backend {
 	int (*compress)(void *ctx, const unsigned char *src,
 			unsigned char *dst, size_t *dst_len);
@@ -22,7 +31,7 @@ struct zcomp_backend {
 	int (*decompress)(void *ctx, const unsigned char *src, size_t src_len,
 			  unsigned char *dst);
 
-	void *(*create_ctx)(void);
+	void *(*create_ctx)(struct zcomp_config *config);
 	void (*destroy_ctx)(void *ctx);
 
 	const char *name;
@@ -32,6 +41,7 @@ struct zcomp_backend {
 struct zcomp {
 	struct zcomp_strm __percpu *stream;
 	struct zcomp_backend *backend;
+	struct zcomp_config *config;
 	struct hlist_node node;
 };
 
@@ -40,7 +50,7 @@ int zcomp_cpu_dead(unsigned int cpu, str
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_config *config);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
--- a/drivers/block/zram/zram_drv.c~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/zram_drv.c
@@ -1979,6 +1979,20 @@ static void zram_slot_free_notify(struct
 	zram_slot_unlock(zram, index);
 }
 
+static void zram_reset_comp_configs(struct zram *zram)
+{
+	u32 prio;
+
+	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+		struct zcomp_config *config = &zram->configs[prio];
+
+		vfree(config->dict);
+		config->level = ZCOMP_CONFIG_NO_LEVEL;
+		config->dict_sz = 0;
+		config->dict = NULL;
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
+	zram_reset_comp_configs(zram);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2049,7 +2065,8 @@ static ssize_t disksize_store(struct dev
 		if (!zram->comp_algs[prio])
 			continue;
 
-		comp = zcomp_create(zram->comp_algs[prio]);
+		comp = zcomp_create(zram->comp_algs[prio],
+				    &zram->configs[prio]);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
@@ -2256,6 +2273,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
+	zram_reset_comp_configs(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
 	zram_debugfs_register(zram);
--- a/drivers/block/zram/zram_drv.h~zram-introduce-zcomp_config-structure
+++ a/drivers/block/zram/zram_drv.h
@@ -107,6 +107,7 @@ struct zram {
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
 	struct zcomp *comps[ZRAM_MAX_COMPS];
+	struct zcomp_config configs[ZRAM_MAX_COMPS];
 	struct gendisk *disk;
 	/* Prevent concurrent execution of device init */
 	struct rw_semaphore init_lock;
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

