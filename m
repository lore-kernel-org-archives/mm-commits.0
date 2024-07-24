Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A85613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849187; cv=none; b=g7rijMgcv/vCEEodDmKgoS4MEx/UUgC+wiIYJYl/2Pfb/v/kUYoS+BtfA4KNlpQ/BsDT2I4AYH1AshgqWJIUdAInL+r2AhYlnfOd8CQmtT7GooRoPzf3EcYT15Ihg1Zz+31Z/k3nu3eVujPvzoTF/AgWv9J4Nzm6cazaBp7VBKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849187; c=relaxed/simple;
	bh=CRf8l+KPjVZwv33hec51NGwUicLIY1+yXVaVp4+1TX8=;
	h=Date:To:From:Subject:Message-Id; b=SbIIo7nZ+ugNxv3mBre50ut2/fWsui49FrtkoX1yq6Y6BOiWwzMF/Ortc6tZigI0S/p6e8q0c+YJGgWJhj3cI9gOJlvbuJdvThxt9/MgJbSC/ByX6vap4bCvKE2/gTFyLWZ+BotJoTG0lmx9Xo9aTMAIdovMAwskogzQSuzi968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENApa/nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENApa/nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D53C32781;
	Wed, 24 Jul 2024 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849187;
	bh=CRf8l+KPjVZwv33hec51NGwUicLIY1+yXVaVp4+1TX8=;
	h=Date:To:From:Subject:From;
	b=ENApa/nYmGetRDuf/6aZtjBhKsFJzYzJGe4ufpx+O3iyY8f09QNi/UUXtofhriTir
	 FZ2B5R4VKG8+2YT47tEG6hNBt+MNvS3CGFzUzwasIi7dRkB0nQaZL3mGmkh7dqv0Pu
	 PD7vZey47m0FAnzynVEi9m7+jnuB9K3G3bWy8Blo=
Date: Wed, 24 Jul 2024 12:26:26 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-zstd-compression-backend-support.patch added to mm-unstable branch
Message-Id: <20240724192627.68D53C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add zstd compression backend support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-zstd-compression-backend-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-zstd-compression-backend-support.patch

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
Subject: zram: add zstd compression backend support
Date: Fri, 12 Jul 2024 14:18:19 +0900

Add s/w zstd compression.

Link: https://lkml.kernel.org/r/20240712051850.484318-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig        |   11 +++
 drivers/block/zram/Makefile       |    1 
 drivers/block/zram/backend_zstd.c |   97 ++++++++++++++++++++++++++++
 drivers/block/zram/backend_zstd.h |   10 ++
 drivers/block/zram/zcomp.c        |    4 +
 5 files changed, 123 insertions(+)

--- /dev/null
+++ a/drivers/block/zram/backend_zstd.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/zstd.h>
+
+#include "backend_zstd.h"
+
+struct zstd_ctx {
+	zstd_cctx *cctx;
+	zstd_dctx *dctx;
+	void *cctx_mem;
+	void *dctx_mem;
+	s32 level;
+};
+
+static void zstd_destroy(void *ctx)
+{
+	struct zstd_ctx *zctx = ctx;
+
+	vfree(zctx->cctx_mem);
+	vfree(zctx->dctx_mem);
+	kfree(zctx);
+}
+
+static void *zstd_create(void)
+{
+	zstd_parameters params;
+	struct zstd_ctx *ctx;
+	size_t sz;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->level = zstd_default_clevel();
+	params = zstd_get_params(ctx->level, 0);
+	sz = zstd_cctx_workspace_bound(&params.cParams);
+	ctx->cctx_mem = vzalloc(sz);
+	if (!ctx->cctx_mem)
+		goto error;
+
+	ctx->cctx = zstd_init_cctx(ctx->cctx_mem, sz);
+	if (!ctx->cctx)
+		goto error;
+
+	sz = zstd_dctx_workspace_bound();
+	ctx->dctx_mem = vzalloc(sz);
+	if (!ctx->dctx_mem)
+		goto error;
+
+	ctx->dctx = zstd_init_dctx(ctx->dctx_mem, sz);
+	if (!ctx->dctx)
+		goto error;
+
+	return ctx;
+
+error:
+	zstd_destroy(ctx);
+	return NULL;
+}
+
+static int zstd_compress(void *ctx, const unsigned char *src, size_t src_len,
+			 unsigned char *dst, size_t *dst_len)
+{
+	struct zstd_ctx *zctx = ctx;
+	const zstd_parameters params = zstd_get_params(zctx->level, 0);
+	size_t ret;
+
+	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
+				 src, src_len, &params);
+	if (zstd_is_error(ret))
+		return -EINVAL;
+	*dst_len = ret;
+	return 0;
+}
+
+static int zstd_decompress(void *ctx, const unsigned char *src, size_t src_len,
+			   unsigned char *dst, size_t dst_len)
+{
+	struct zstd_ctx *zctx = ctx;
+	size_t ret;
+
+	ret = zstd_decompress_dctx(zctx->dctx, dst, dst_len, src, src_len);
+	if (zstd_is_error(ret))
+		return -EINVAL;
+	return 0;
+}
+
+const struct zcomp_ops backend_zstd = {
+	.compress	= zstd_compress,
+	.decompress	= zstd_decompress,
+	.create_ctx	= zstd_create,
+	.destroy_ctx	= zstd_destroy,
+	.name		= "zstd",
+};
--- /dev/null
+++ a/drivers/block/zram/backend_zstd.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_ZSTD_H__
+#define __BACKEND_ZSTD_H__
+
+#include "zcomp.h"
+
+extern const struct zcomp_ops backend_zstd;
+
+#endif /* __BACKEND_ZSTD_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-zstd-compression-backend-support
+++ a/drivers/block/zram/Kconfig
@@ -33,6 +33,12 @@ config ZRAM_BACKEND_LZ4HC
 	select LZ4HC_COMPRESS
 	select LZ4_DECOMPRESS
 
+config ZRAM_BACKEND_ZSTD
+	bool "zstd compression support"
+	depends on ZRAM
+	select ZSTD_COMPRESS
+	select ZSTD_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
@@ -54,6 +60,10 @@ config ZRAM_DEF_COMP_LZ4HC
 	bool "lz4hc"
 	depends on ZRAM_BACKEND_LZ4HC
 
+config ZRAM_DEF_COMP_ZSTD
+	bool "zstd"
+	depends on ZRAM_BACKEND_ZSTD
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -62,6 +72,7 @@ config ZRAM_DEF_COMP
 	default "lzo" if ZRAM_DEF_COMP_LZO
 	default "lz4" if ZRAM_DEF_COMP_LZ4
 	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
+	default "zstd" if ZRAM_DEF_COMP_ZSTD
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-zstd-compression-backend-support
+++ a/drivers/block/zram/Makefile
@@ -5,5 +5,6 @@ zram-y	:=	zcomp.o zram_drv.o
 zram-$(CONFIG_ZRAM_BACKEND_LZO)		+= backend_lzorle.o backend_lzo.o
 zram-$(CONFIG_ZRAM_BACKEND_LZ4)		+= backend_lz4.o
 zram-$(CONFIG_ZRAM_BACKEND_LZ4HC)	+= backend_lz4hc.o
+zram-$(CONFIG_ZRAM_BACKEND_ZSTD)	+= backend_zstd.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-zstd-compression-backend-support
+++ a/drivers/block/zram/zcomp.c
@@ -16,6 +16,7 @@
 #include "backend_lzorle.h"
 #include "backend_lz4.h"
 #include "backend_lz4hc.h"
+#include "backend_zstd.h"
 
 static const struct zcomp_ops *backends[] = {
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
@@ -28,6 +29,9 @@ static const struct zcomp_ops *backends[
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZ4HC)
 	&backend_lz4hc,
 #endif
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_ZSTD)
+	&backend_zstd,
+#endif
 	NULL
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

