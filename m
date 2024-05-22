Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5101487C5
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417134; cv=none; b=OzC93z+ok83a0l3OAqgH286XeKNJAzhv524sDP08mg2rLhh+qiVtwKCQ5eC7ylZ3yR0cDKV0/OIDj3quAYnXXgwE0qAZ5TGMNnATULamogv0wnzOwSCPv8ucqq+6iHaVEHx0u9YfIgT1XawF4uOlZk+epUvH1hGHZ0FePN0BdkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417134; c=relaxed/simple;
	bh=8Lic/zJjHl7TVHIbF7i8VFq3fEfH3fMHtvwVWuKKZl4=;
	h=Date:To:From:Subject:Message-Id; b=t046LoZyH4+34CK/7fS+fLsHJZxNW9Y7dsE0KMLmmN16gReeeyct8ENnTt1r0DDYWCzyQ6APwHThButpvcmofew1O1ZGVh0JJQWNxJ7HZOKGHfZU4yk4YBeMXF2c0AEsAU+CIDCL72juLPeJKm6YK8i2c5hpFBvaIMRHDiRutII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tDaBYN0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tDaBYN0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5188BC3277B;
	Wed, 22 May 2024 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417134;
	bh=8Lic/zJjHl7TVHIbF7i8VFq3fEfH3fMHtvwVWuKKZl4=;
	h=Date:To:From:Subject:From;
	b=tDaBYN0sc+hamPYukvOzCB0bfXOUtndN11ZWPLzIOwJljtmJcXYSDC9uwbR1f5sI/
	 7CwJZ+nbGcNv8NCu4TkEdjzBX+zVU90+GxMSCru7bj77SqfJQPn4hbSo3YUh589v7s
	 QTLW41gtk1365n9IbfCVTDfgaaPTj0aJ814QaXYU=
Date: Wed, 22 May 2024 15:32:13 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-config-init-release-backend-callbacks.patch added to mm-unstable branch
Message-Id: <20240522223214.5188BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add config init/release backend callbacks
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-config-init-release-backend-callbacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-config-init-release-backend-callbacks.patch

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
Subject: zram: add config init/release backend callbacks
Date: Wed, 15 May 2024 16:12:53 +0900

Some backends can create a backend-specific private data for comp config,
e.g.  parse a dictionary and use it to init all of the ctx-s later on. 
Introduce two zcomp_config callbacks to create and destroy per-config
backend private data.  This is also the place where config can be
validated.

Link: https://lkml.kernel.org/r/20240515071645.1788128-17-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |   11 +++++++++++
 drivers/block/zram/backend_deflate.c |   20 +++++++++++++++-----
 drivers/block/zram/backend_lz4.c     |   20 +++++++++++++++-----
 drivers/block/zram/backend_lz4hc.c   |   20 +++++++++++++++-----
 drivers/block/zram/backend_lzo.c     |   11 +++++++++++
 drivers/block/zram/backend_lzorle.c  |   11 +++++++++++
 drivers/block/zram/backend_zstd.c    |   20 +++++++++++++++-----
 drivers/block/zram/zcomp.c           |    6 ++++++
 drivers/block/zram/zcomp.h           |    4 ++++
 drivers/block/zram/zram_drv.c        |    3 +++
 10 files changed, 106 insertions(+), 20 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_842.c
@@ -11,6 +11,15 @@ struct sw842_ctx {
 	void *mem;
 };
 
+static int init_config_842(struct zcomp_config *config)
+{
+	return 0;
+}
+
+static void release_config_842(struct zcomp_config *config)
+{
+}
+
 static void destroy_842(void *ctx)
 {
 	struct sw842_ctx *zctx = ctx;
@@ -64,5 +73,7 @@ struct zcomp_backend backend_842 = {
 	.decompress	= decompress_842,
 	.create_ctx	= create_842,
 	.destroy_ctx	= destroy_842,
+	.init_config	= init_config_842,
+	.release_config	= release_config_842,
 	.name		= "842",
 };
--- a/drivers/block/zram/backend_deflate.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_deflate.c
@@ -17,6 +17,18 @@ struct deflate_ctx {
 	s32 level;
 };
 
+static int deflate_init_config(struct zcomp_config *config)
+{
+	if (config->level == ZCOMP_CONFIG_NO_LEVEL)
+		config->level = Z_DEFAULT_COMPRESSION;
+
+	return 0;
+}
+
+static void deflate_release_config(struct zcomp_config *config)
+{
+}
+
 static void deflate_destroy(void *ctx)
 {
 	struct deflate_ctx *zctx = ctx;
@@ -42,11 +54,7 @@ static void *deflate_create(struct zcomp
 	if (!ctx)
 		return NULL;
 
-	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
-		ctx->level = config->level;
-	else
-		ctx->level = Z_DEFAULT_COMPRESSION;
-
+	ctx->level = config->level;
 	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
 	ctx->cctx.workspace = vzalloc(sz);
 	if (!ctx->cctx.workspace)
@@ -129,5 +137,7 @@ struct zcomp_backend backend_deflate = {
 	.decompress	= deflate_decompress,
 	.create_ctx	= deflate_create,
 	.destroy_ctx	= deflate_destroy,
+	.init_config	= deflate_init_config,
+	.release_config	= deflate_release_config,
 	.name		= "deflate",
 };
--- a/drivers/block/zram/backend_lz4.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_lz4.c
@@ -10,6 +10,18 @@ struct lz4_ctx {
 	s32 level;
 };
 
+static int lz4_init_config(struct zcomp_config *config)
+{
+	if (config->level == ZCOMP_CONFIG_NO_LEVEL)
+		config->level = LZ4_ACCELERATION_DEFAULT;
+
+	return 0;
+}
+
+static void lz4_release_config(struct zcomp_config *config)
+{
+}
+
 static void lz4_destroy(void *ctx)
 {
 	struct lz4_ctx *zctx = ctx;
@@ -26,11 +38,7 @@ static void *lz4_create(struct zcomp_con
 	if (!ctx)
 		return NULL;
 
-	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
-		ctx->level = config->level;
-	else
-		ctx->level = LZ4_ACCELERATION_DEFAULT;
-
+	ctx->level = config->level;
 	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
@@ -72,5 +80,7 @@ struct zcomp_backend backend_lz4 = {
 	.decompress	= lz4_decompress,
 	.create_ctx	= lz4_create,
 	.destroy_ctx	= lz4_destroy,
+	.init_config	= lz4_init_config,
+	.release_config	= lz4_release_config,
 	.name		= "lz4",
 };
--- a/drivers/block/zram/backend_lz4hc.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -10,6 +10,18 @@ struct lz4hc_ctx {
 	s32 level;
 };
 
+static int lz4hc_init_config(struct zcomp_config *config)
+{
+	if (config->level == ZCOMP_CONFIG_NO_LEVEL)
+		config->level = LZ4HC_DEFAULT_CLEVEL;
+
+	return 0;
+}
+
+static void lz4hc_release_config(struct zcomp_config *config)
+{
+}
+
 static void lz4hc_destroy(void *ctx)
 {
 	struct lz4hc_ctx *zctx = ctx;
@@ -26,11 +38,7 @@ static void *lz4hc_create(struct zcomp_c
 	if (!ctx)
 		return NULL;
 
-	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
-		ctx->level = config->level;
-	else
-		ctx->level = LZ4HC_DEFAULT_CLEVEL;
-
+	ctx->level = config->level;
 	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
 	if (!ctx->mem)
 		goto error;
@@ -72,5 +80,7 @@ struct zcomp_backend backend_lz4hc = {
 	.decompress	= lz4hc_decompress,
 	.create_ctx	= lz4hc_create,
 	.destroy_ctx	= lz4hc_destroy,
+	.init_config	= lz4hc_init_config,
+	.release_config	= lz4hc_release_config,
 	.name		= "lz4hc",
 };
--- a/drivers/block/zram/backend_lzo.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_lzo.c
@@ -6,6 +6,15 @@
 
 #include "backend_lzo.h"
 
+static int lzo_init_config(struct zcomp_config *config)
+{
+	return 0;
+}
+
+static void lzo_release_config(struct zcomp_config *config)
+{
+}
+
 static void *lzo_create(struct zcomp_config *config)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
@@ -40,5 +49,7 @@ struct zcomp_backend backend_lzo = {
 	.decompress	= lzo_decompress,
 	.create_ctx	= lzo_create,
 	.destroy_ctx	= lzo_destroy,
+	.init_config	= lzo_init_config,
+	.release_config	= lzo_release_config,
 	.name		= "lzo",
 };
--- a/drivers/block/zram/backend_lzorle.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_lzorle.c
@@ -6,6 +6,15 @@
 
 #include "backend_lzorle.h"
 
+static int lzorle_init_config(struct zcomp_config *config)
+{
+	return 0;
+}
+
+static void lzorle_release_config(struct zcomp_config *config)
+{
+}
+
 static void *lzorle_create(struct zcomp_config *config)
 {
 	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
@@ -40,5 +49,7 @@ struct zcomp_backend backend_lzorle = {
 	.decompress	= lzorle_decompress,
 	.create_ctx	= lzorle_create,
 	.destroy_ctx	= lzorle_destroy,
+	.init_config	= lzorle_init_config,
+	.release_config	= lzorle_release_config,
 	.name		= "lzo-rle",
 };
--- a/drivers/block/zram/backend_zstd.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/backend_zstd.c
@@ -36,6 +36,18 @@ static void zstd_ctx_free(void *opaque,
 	kvfree(address);
 }
 
+static int zstd_init_config(struct zcomp_config *config)
+{
+	if (config->level == ZCOMP_CONFIG_NO_LEVEL)
+		config->level = zstd_default_clevel();
+
+	return 0;
+}
+
+static void zstd_release_config(struct zcomp_config *config)
+{
+}
+
 static void zstd_destroy(void *ctx)
 {
 	struct zstd_ctx *zctx = ctx;
@@ -63,11 +75,7 @@ static void *zstd_create(struct zcomp_co
 	if (!ctx)
 		return NULL;
 
-	if (config->level != ZCOMP_CONFIG_NO_LEVEL)
-		ctx->level = config->level;
-	else
-		ctx->level = zstd_default_clevel();
-
+	ctx->level = config->level;
 	ctx->ctx_mem.customAlloc = zstd_ctx_alloc;
 	ctx->ctx_mem.customFree = zstd_ctx_free;
 
@@ -173,5 +181,7 @@ struct zcomp_backend backend_zstd = {
 	.decompress	= zstd_decompress,
 	.create_ctx	= zstd_create,
 	.destroy_ctx	= zstd_destroy,
+	.init_config	= zstd_init_config,
+	.release_config	= zstd_release_config,
 	.name		= "zstd",
 };
--- a/drivers/block/zram/zcomp.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/zcomp.c
@@ -187,18 +187,24 @@ static int zcomp_init(struct zcomp *comp
 	if (!comp->stream)
 		return -ENOMEM;
 
+	ret = comp->backend->init_config(comp->config);
+	if (ret)
+		goto cleanup;
+
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
 		goto cleanup;
 	return 0;
 
 cleanup:
+	comp->backend->release_config(comp->config);
 	free_percpu(comp->stream);
 	return ret;
 }
 
 void zcomp_destroy(struct zcomp *comp)
 {
+	comp->backend->release_config(comp->config);
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	free_percpu(comp->stream);
 	kfree(comp);
--- a/drivers/block/zram/zcomp.h~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/zcomp.h
@@ -22,6 +22,7 @@ struct zcomp_config {
 	s32 level;
 	size_t dict_sz;
 	void *dict;
+	void *private;
 };
 
 struct zcomp_backend {
@@ -34,6 +35,9 @@ struct zcomp_backend {
 	void *(*create_ctx)(struct zcomp_config *config);
 	void (*destroy_ctx)(void *ctx);
 
+	int (*init_config)(struct zcomp_config *config);
+	void (*release_config)(struct zcomp_config *config);
+
 	const char *name;
 };
 
--- a/drivers/block/zram/zram_drv.c~zram-add-config-init-release-backend-callbacks
+++ a/drivers/block/zram/zram_drv.c
@@ -1003,6 +1003,9 @@ static void __reset_comp_config(struct z
 {
 	struct zcomp_config *config = &zram->configs[prio];
 
+	/* config->private should be freed by the backend */
+	WARN_ON_ONCE(config->private);
+
 	vfree(config->dict);
 	config->level = ZCOMP_CONFIG_NO_LEVEL;
 	config->dict_sz = 0;
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

