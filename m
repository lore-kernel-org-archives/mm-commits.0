Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6C6613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849184; cv=none; b=f1JybFIccs+HJL8gn6o5yowpKH5cScwHZvatQ6GSlzFvL19MW36LawERawkVfMyXHwXkk6o06u7g8PQsiUcxA3Pvitjnn2H3Ci7Oi9z6N0QsICasoEeUMDLa0AKcslQ8M2ZYt6pFcxCYn2rOwWcDxAcbkEb9SLNcFdhC3jOk/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849184; c=relaxed/simple;
	bh=sjPdMnENhnDVC5C4XmwsMK/vwsyw0Ue7G2w91OyNd+s=;
	h=Date:To:From:Subject:Message-Id; b=WX0nfxSsfZOile8nhpzUIunEN6M6TpZlJWa4ocLcy0UOu9ImFhWtHTWfCl4Wppqq2BkhIRWjz8uAD6ATVfAp7G6bTdLAOvKm/02fxUirfXaZlgC82CTh37A4KaLs2/YrKSq9Ron6rYRcQj6t/dzys1/LhgX0VBmszv5dIrRwi3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a4SUGnk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a4SUGnk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B59C32781;
	Wed, 24 Jul 2024 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849184;
	bh=sjPdMnENhnDVC5C4XmwsMK/vwsyw0Ue7G2w91OyNd+s=;
	h=Date:To:From:Subject:From;
	b=a4SUGnk9tKf7BQPg0Iee3DxVsF7YSwHNFzy94U/4ByEe4g0LQd1I6frGahItptaCs
	 gSLJOg8Vesnj9pOBOaVtxVGW2kdqlgZ+QXnWaKxL5Jo9/Mow/AtPV2d83kBMjDkpFy
	 CSZ5HVFxmffi/h3StJcq5a7j0YCVMN469v5t+yX4=
Date: Wed, 24 Jul 2024 12:26:23 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-lz4hc-compression-backend-support.patch added to mm-unstable branch
Message-Id: <20240724192624.18B59C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add lz4hc compression backend support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-lz4hc-compression-backend-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-lz4hc-compression-backend-support.patch

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
Subject: zram: add lz4hc compression backend support
Date: Fri, 12 Jul 2024 14:18:18 +0900

Add s/w lz4hc compression support.

Link: https://lkml.kernel.org/r/20240712051850.484318-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig         |   11 ++++
 drivers/block/zram/Makefile        |    5 +
 drivers/block/zram/backend_lz4hc.c |   72 +++++++++++++++++++++++++++
 drivers/block/zram/backend_lz4hc.h |   10 +++
 drivers/block/zram/zcomp.c         |    4 +
 5 files changed, 100 insertions(+), 2 deletions(-)

--- /dev/null
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -0,0 +1,72 @@
+#include <linux/kernel.h>
+#include <linux/lz4.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "backend_lz4hc.h"
+
+struct lz4hc_ctx {
+	void *mem;
+	s32 level;
+};
+
+static void lz4hc_destroy(void *ctx)
+{
+	struct lz4hc_ctx *zctx = ctx;
+
+	vfree(zctx->mem);
+	kfree(zctx);
+}
+
+static void *lz4hc_create(void)
+{
+	struct lz4hc_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	/* @FIXME: using a hardcoded LZ4HC_DEFAULT_CLEVEL for now */
+	ctx->level = LZ4HC_DEFAULT_CLEVEL;
+	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
+	if (!ctx->mem)
+		goto error;
+
+	return ctx;
+error:
+	lz4hc_destroy(ctx);
+	return NULL;
+}
+
+static int lz4hc_compress(void *ctx, const unsigned char *src, size_t src_len,
+			  unsigned char *dst, size_t *dst_len)
+{
+	struct lz4hc_ctx *zctx = ctx;
+	int ret;
+
+	ret = LZ4_compress_HC(src, dst, src_len, *dst_len,
+			      zctx->level, zctx->mem);
+	if (!ret)
+		return -EINVAL;
+	*dst_len = ret;
+	return 0;
+}
+
+static int lz4hc_decompress(void *ctx, const unsigned char *src,
+			    size_t src_len, unsigned char *dst, size_t dst_len)
+{
+	int ret;
+
+	ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	if (ret < 0)
+		return -EINVAL;
+	return 0;
+}
+
+const struct zcomp_ops backend_lz4hc = {
+	.compress	= lz4hc_compress,
+	.decompress	= lz4hc_decompress,
+	.create_ctx	= lz4hc_create,
+	.destroy_ctx	= lz4hc_destroy,
+	.name		= "lz4hc",
+};
--- /dev/null
+++ a/drivers/block/zram/backend_lz4hc.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_LZ4HC_H__
+#define __BACKEND_LZ4HC_H__
+
+#include "zcomp.h"
+
+extern const struct zcomp_ops backend_lz4hc;
+
+#endif /* __BACKEND_LZ4HC_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-lz4hc-compression-backend-support
+++ a/drivers/block/zram/Kconfig
@@ -27,6 +27,12 @@ config ZRAM_BACKEND_LZ4
 	select LZ4_COMPRESS
 	select LZ4_DECOMPRESS
 
+config ZRAM_BACKEND_LZ4HC
+	bool "lz4hc compression support"
+	depends on ZRAM
+	select LZ4HC_COMPRESS
+	select LZ4_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
@@ -44,6 +50,10 @@ config ZRAM_DEF_COMP_LZ4
 	bool "lz4"
 	depends on ZRAM_BACKEND_LZ4
 
+config ZRAM_DEF_COMP_LZ4HC
+	bool "lz4hc"
+	depends on ZRAM_BACKEND_LZ4HC
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -51,6 +61,7 @@ config ZRAM_DEF_COMP
 	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
 	default "lzo" if ZRAM_DEF_COMP_LZO
 	default "lz4" if ZRAM_DEF_COMP_LZ4
+	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-lz4hc-compression-backend-support
+++ a/drivers/block/zram/Makefile
@@ -2,7 +2,8 @@
 
 zram-y	:=	zcomp.o zram_drv.o
 
-zram-$(CONFIG_ZRAM_BACKEND_LZO)	+= backend_lzorle.o backend_lzo.o
-zram-$(CONFIG_ZRAM_BACKEND_LZ4)	+= backend_lz4.o
+zram-$(CONFIG_ZRAM_BACKEND_LZO)		+= backend_lzorle.o backend_lzo.o
+zram-$(CONFIG_ZRAM_BACKEND_LZ4)		+= backend_lz4.o
+zram-$(CONFIG_ZRAM_BACKEND_LZ4HC)	+= backend_lz4hc.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-lz4hc-compression-backend-support
+++ a/drivers/block/zram/zcomp.c
@@ -15,6 +15,7 @@
 #include "backend_lzo.h"
 #include "backend_lzorle.h"
 #include "backend_lz4.h"
+#include "backend_lz4hc.h"
 
 static const struct zcomp_ops *backends[] = {
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
@@ -24,6 +25,9 @@ static const struct zcomp_ops *backends[
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZ4)
 	&backend_lz4,
 #endif
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZ4HC)
+	&backend_lz4hc,
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

