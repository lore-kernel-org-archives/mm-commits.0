Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A7186E36
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311894; cv=none; b=MSyBd6FJMT/xgCMz1mBHNhyIxghfPT1WviJy1TRKciOrDwFe2kyq6qGfRrCXBtgDaX+5IUCijTtQtCa4b834TdiRwzZy4NJyDOCg7nKzCI46B6ohT4hNL6bZI4VeowFkPri6w/+eJ7POjOK541xXY9e8gY+mkHl7GbqFcb7qvO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311894; c=relaxed/simple;
	bh=Jy+Sxii7iwl91rya/bvk8Re0l1fVgu4CsjFQH97Fl/A=;
	h=Date:To:From:Subject:Message-Id; b=uk9gbGmPLWRSiqzMPoZfB3YkAEMN3I8Txr29nGNbTZ+wfcn/d4pgNQ7zcEZZoRo1rcj6l/HCAaGUIlrm4w2XptIiPcq3FHTz8j3KngDxipFh72LzdKSMWIeY3J/n37aMtGomA2keveiWVtdlW30F4GCevHDSlzkrD+WO5noQSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKK6OuoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKK6OuoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB9C4CEC2;
	Mon,  2 Sep 2024 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311893;
	bh=Jy+Sxii7iwl91rya/bvk8Re0l1fVgu4CsjFQH97Fl/A=;
	h=Date:To:From:Subject:From;
	b=IKK6OuoNhmZQekcksr4X6mpYmhAxdZAF/ER7jC7zFcAEz9W/vl3iS2X48YY0oocb4
	 0yfDupP/UFo8596aMruFjeDT/Db02kgQQv4E960YxnpucJYYJmB6nUenTJVe2EEYDh
	 GVnw0iyyXZLCXReKsKCGxZPszAhKBJmS/ryXqeAs=
Date: Mon, 02 Sep 2024 14:18:13 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-lz4hc-compression-backend-support.patch added to mm-unstable branch
Message-Id: <20240902211813.BDAB9C4CEC2@smtp.kernel.org>
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
Date: Mon, 2 Sep 2024 19:55:55 +0900

Add s/w lz4hc compression support.

Link: https://lkml.kernel.org/r/20240902105656.1383858-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig         |   11 ++++
 drivers/block/zram/Makefile        |    5 +
 drivers/block/zram/backend_lz4hc.c |   72 +++++++++++++++++++++++++++
 drivers/block/zram/backend_lz4hc.h |   10 +++
 drivers/block/zram/zcomp.c         |    4 +
 5 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c a/drivers/block/zram/backend_lz4hc.c
new file mode 100644
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
diff --git a/drivers/block/zram/backend_lz4hc.h a/drivers/block/zram/backend_lz4hc.h
new file mode 100644
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
@@ -26,6 +26,12 @@ config ZRAM_BACKEND_LZ4
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
@@ -43,6 +49,10 @@ config ZRAM_DEF_COMP_LZ4
 	bool "lz4"
 	depends on ZRAM_BACKEND_LZ4
 
+config ZRAM_DEF_COMP_LZ4HC
+	bool "lz4hc"
+	depends on ZRAM_BACKEND_LZ4HC
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -50,6 +60,7 @@ config ZRAM_DEF_COMP
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

