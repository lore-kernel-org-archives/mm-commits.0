Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54921A4E9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311903; cv=none; b=gIu1nsoNOBLUOcvABZQsgIw7Vi9qE6Q0drQoJsRI7LuxT5A2ffelA2HfOOeKmnBO21kTmdRzT59LraUXeWl7Sgy9GZdBzgHusGghB34lI5LfhsYnqn8OYQOxjLG8pyDdTsr7CJptSW5Or5MhpFlIqyMthbIjMZ37RiBVB0H60sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311903; c=relaxed/simple;
	bh=M7HvPwn18K8BwO16HRR9v2KCNek6Z+I8VkTo8iiwJdE=;
	h=Date:To:From:Subject:Message-Id; b=WtEsegZSlp56Q18z2LVuM2B7C5NCo10q4YosD3eKnng1admHtF/1ppFu8BPoBT3mCGkoM+S2puE3dlk7T21w7Kr9IgwpNTzi9ItnJI+lasvY9e9Hb6hCOuptWV6Tw6B4iKgza9v5OsyeW9hEsdx7EzR9zKG74zj8R6Hn7g37+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=So5p1ftg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="So5p1ftg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD97C4CEC2;
	Mon,  2 Sep 2024 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311903;
	bh=M7HvPwn18K8BwO16HRR9v2KCNek6Z+I8VkTo8iiwJdE=;
	h=Date:To:From:Subject:From;
	b=So5p1ftgDL7SHI8PQBd/psi4ogDCflAU6nRyRpaDk4qlW9FYAMSq2THGQFGf0jcb+
	 x1Ex4Hk8VniWpDEvuHa343oCukFpPRm1lM+P5mW7sesABdNzu3PELrH+gG5n4iNZJB
	 LvaP1yb1aNiOWexTlo/dPlgiZrJctyNQ8NWJj43c=
Date: Mon, 02 Sep 2024 14:18:22 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-zlib-compression-backend-support.patch added to mm-unstable branch
Message-Id: <20240902211823.2CD97C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add zlib compression backend support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-zlib-compression-backend-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-zlib-compression-backend-support.patch

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
Subject: zram: add zlib compression backend support
Date: Mon, 2 Sep 2024 19:55:58 +0900

Add s/w zlib (inflate/deflate) compression.

Link: https://lkml.kernel.org/r/20240902105656.1383858-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig           |   11 ++
 drivers/block/zram/Makefile          |    1 
 drivers/block/zram/backend_deflate.c |  132 +++++++++++++++++++++++++
 drivers/block/zram/backend_deflate.h |   10 +
 drivers/block/zram/zcomp.c           |    4 
 5 files changed, 158 insertions(+)

diff --git a/drivers/block/zram/backend_deflate.c a/drivers/block/zram/backend_deflate.c
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_deflate.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/zlib.h>
+
+#include "backend_deflate.h"
+
+/* Use the same value as crypto API */
+#define DEFLATE_DEF_WINBITS		11
+#define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
+
+struct deflate_ctx {
+	struct z_stream_s cctx;
+	struct z_stream_s dctx;
+	s32 level;
+};
+
+static void deflate_destroy(void *ctx)
+{
+	struct deflate_ctx *zctx = ctx;
+
+	if (zctx->cctx.workspace) {
+		zlib_deflateEnd(&zctx->cctx);
+		vfree(zctx->cctx.workspace);
+	}
+	if (zctx->dctx.workspace) {
+		zlib_inflateEnd(&zctx->dctx);
+		vfree(zctx->dctx.workspace);
+	}
+	kfree(zctx);
+}
+
+static void *deflate_create(void)
+{
+	struct deflate_ctx *ctx;
+	size_t sz;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	/* @FIXME: using a hardcoded Z_DEFAULT_COMPRESSION for now */
+	ctx->level = Z_DEFAULT_COMPRESSION;
+	sz = zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL);
+	ctx->cctx.workspace = vzalloc(sz);
+	if (!ctx->cctx.workspace)
+		goto error;
+
+	ret = zlib_deflateInit2(&ctx->cctx, ctx->level, Z_DEFLATED,
+				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
+				Z_DEFAULT_STRATEGY);
+	if (ret != Z_OK)
+		goto error;
+
+	sz = zlib_inflate_workspacesize();
+	ctx->dctx.workspace = vzalloc(sz);
+	if (!ctx->dctx.workspace)
+		goto error;
+
+	ret = zlib_inflateInit2(&ctx->dctx, -DEFLATE_DEF_WINBITS);
+	if (ret != Z_OK)
+		goto error;
+
+	return ctx;
+
+error:
+	deflate_destroy(ctx);
+	return NULL;
+}
+
+static int deflate_compress(void *ctx, const unsigned char *src,
+			    size_t src_len, unsigned char *dst,
+			    size_t *dst_len)
+{
+	struct deflate_ctx *zctx = ctx;
+	struct z_stream_s *deflate;
+	int ret;
+
+	deflate = &zctx->cctx;
+	ret = zlib_deflateReset(deflate);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	deflate->next_in = (u8 *)src;
+	deflate->avail_in = src_len;
+	deflate->next_out = (u8 *)dst;
+	deflate->avail_out = *dst_len;
+
+	ret = zlib_deflate(deflate, Z_FINISH);
+	if (ret != Z_STREAM_END)
+		return -EINVAL;
+
+	*dst_len = deflate->total_out;
+	return 0;
+}
+
+static int deflate_decompress(void *ctx, const unsigned char *src,
+			      size_t src_len, unsigned char *dst,
+			      size_t dst_len)
+{
+	struct deflate_ctx *zctx = ctx;
+	struct z_stream_s *inflate;
+	int ret;
+
+	inflate = &zctx->dctx;
+
+	ret = zlib_inflateReset(inflate);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	inflate->next_in = (u8 *)src;
+	inflate->avail_in = src_len;
+	inflate->next_out = (u8 *)dst;
+	inflate->avail_out = dst_len;
+
+	ret = zlib_inflate(inflate, Z_SYNC_FLUSH);
+	if (ret != Z_STREAM_END)
+		return -EINVAL;
+
+	return 0;
+}
+
+const struct zcomp_ops backend_deflate = {
+	.compress	= deflate_compress,
+	.decompress	= deflate_decompress,
+	.create_ctx	= deflate_create,
+	.destroy_ctx	= deflate_destroy,
+	.name		= "deflate",
+};
diff --git a/drivers/block/zram/backend_deflate.h a/drivers/block/zram/backend_deflate.h
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_deflate.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_DEFLATE_H__
+#define __BACKEND_DEFLATE_H__
+
+#include "zcomp.h"
+
+extern const struct zcomp_ops backend_deflate;
+
+#endif /* __BACKEND_DEFLATE_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-zlib-compression-backend-support
+++ a/drivers/block/zram/Kconfig
@@ -38,6 +38,12 @@ config ZRAM_BACKEND_ZSTD
 	select ZSTD_COMPRESS
 	select ZSTD_DECOMPRESS
 
+config ZRAM_BACKEND_DEFLATE
+	bool "deflate compression support"
+	depends on ZRAM
+	select ZLIB_DEFLATE
+	select ZLIB_INFLATE
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
@@ -63,6 +69,10 @@ config ZRAM_DEF_COMP_ZSTD
 	bool "zstd"
 	depends on ZRAM_BACKEND_ZSTD
 
+config ZRAM_DEF_COMP_DEFLATE
+	bool "deflate"
+	depends on ZRAM_BACKEND_DEFLATE
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -72,6 +82,7 @@ config ZRAM_DEF_COMP
 	default "lz4" if ZRAM_DEF_COMP_LZ4
 	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
 	default "zstd" if ZRAM_DEF_COMP_ZSTD
+	default "deflate" if ZRAM_DEF_COMP_DEFLATE
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-zlib-compression-backend-support
+++ a/drivers/block/zram/Makefile
@@ -6,5 +6,6 @@ zram-$(CONFIG_ZRAM_BACKEND_LZO)		+= back
 zram-$(CONFIG_ZRAM_BACKEND_LZ4)		+= backend_lz4.o
 zram-$(CONFIG_ZRAM_BACKEND_LZ4HC)	+= backend_lz4hc.o
 zram-$(CONFIG_ZRAM_BACKEND_ZSTD)	+= backend_zstd.o
+zram-$(CONFIG_ZRAM_BACKEND_DEFLATE)	+= backend_deflate.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-zlib-compression-backend-support
+++ a/drivers/block/zram/zcomp.c
@@ -17,6 +17,7 @@
 #include "backend_lz4.h"
 #include "backend_lz4hc.h"
 #include "backend_zstd.h"
+#include "backend_deflate.h"
 
 static const struct zcomp_ops *backends[] = {
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
@@ -32,6 +33,9 @@ static const struct zcomp_ops *backends[
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_ZSTD)
 	&backend_zstd,
 #endif
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_DEFLATE)
+	&backend_deflate,
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
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

