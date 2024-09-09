Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F83C18E04D
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925265; cv=none; b=hWCtKQA3FJ5FCm/P9A+caY5uPBLQ1uU6mJTMR7l8mqKlTL6w99/aMeBshFx4jGxpMPzz6M/hic+AYIye/ngmNsQ5ZpIcJAevh1z23tuDadDqrVLu0Z1VRT8jJjwfxGlbZkUdb1TRGxRtJW6Y0FenI0qP8idfjzp2kKbY87RhKEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925265; c=relaxed/simple;
	bh=2/Athqp2yFOwprY7vhSFjdSNz82k6ODVQ7BLYZ4hOpw=;
	h=Date:To:From:Subject:Message-Id; b=Vv6Ps02+0cKG3WXW+AxWGq7d6r8l0DeuonNu/+WW7h8L05THWryS74osmf7CKKJ8xOmbZJIku7igki2MERqosl2V1KeheDNOJnYi2hJYnYFfY6NjccoOemjrqBPGxFVj9BV2bRfdvi6htDvJeN2oASK/VLKIOequPl1moFYfkYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqEXEZcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqEXEZcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D6FC4CEC5;
	Mon,  9 Sep 2024 23:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925265;
	bh=2/Athqp2yFOwprY7vhSFjdSNz82k6ODVQ7BLYZ4hOpw=;
	h=Date:To:From:Subject:From;
	b=cqEXEZcVIh/z8FWBGNgEgftBqDc5bJbmoR1aPpb//aodHE3ak4hdB1z7Pt3FhBWAS
	 ubV46Bzh//pbEKCeRFJBEmo7vY9aMAAN1ypfqmsj5PBcqw2x4+IaEY6DOrwtyD6K5Y
	 fqInwDgCocS2wbKY3Jw050cQwLcG1MHmV6walH4w=
Date: Mon, 09 Sep 2024 16:41:04 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-lz4-compression-backend-support.patch removed from -mm tree
Message-Id: <20240909234105.26D6FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add lz4 compression backend support
has been removed from the -mm tree.  Its filename was
     zram-add-lz4-compression-backend-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add lz4 compression backend support
Date: Mon, 2 Sep 2024 19:55:54 +0900

Add s/w lz4 compression support.

Link: https://lkml.kernel.org/r/20240902105656.1383858-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig       |   11 ++++
 drivers/block/zram/Makefile      |    1 
 drivers/block/zram/backend_lz4.c |   72 +++++++++++++++++++++++++++++
 drivers/block/zram/backend_lz4.h |   10 ++++
 drivers/block/zram/zcomp.c       |    4 +
 5 files changed, 98 insertions(+)

diff --git a/drivers/block/zram/backend_lz4.c a/drivers/block/zram/backend_lz4.c
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_lz4.c
@@ -0,0 +1,72 @@
+#include <linux/kernel.h>
+#include <linux/lz4.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "backend_lz4.h"
+
+struct lz4_ctx {
+	void *mem;
+	s32 level;
+};
+
+static void lz4_destroy(void *ctx)
+{
+	struct lz4_ctx *zctx = ctx;
+
+	vfree(zctx->mem);
+	kfree(zctx);
+}
+
+static void *lz4_create(void)
+{
+	struct lz4_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	/* @FIXME: using a hardcoded LZ4_ACCELERATION_DEFAULT for now */
+	ctx->level = LZ4_ACCELERATION_DEFAULT;
+	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
+	if (!ctx->mem)
+		goto error;
+
+	return ctx;
+error:
+	lz4_destroy(ctx);
+	return NULL;
+}
+
+static int lz4_compress(void *ctx, const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len)
+{
+	struct lz4_ctx *zctx = ctx;
+	int ret;
+
+	ret = LZ4_compress_fast(src, dst, src_len, *dst_len,
+				zctx->level, zctx->mem);
+	if (!ret)
+		return -EINVAL;
+	*dst_len = ret;
+	return 0;
+}
+
+static int lz4_decompress(void *ctx, const unsigned char *src,
+			  size_t src_len, unsigned char *dst, size_t dst_len)
+{
+	int ret;
+
+	ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	if (ret < 0)
+		return -EINVAL;
+	return 0;
+}
+
+const struct zcomp_ops backend_lz4 = {
+	.compress	= lz4_compress,
+	.decompress	= lz4_decompress,
+	.create_ctx	= lz4_create,
+	.destroy_ctx	= lz4_destroy,
+	.name		= "lz4",
+};
diff --git a/drivers/block/zram/backend_lz4.h a/drivers/block/zram/backend_lz4.h
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_lz4.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_LZ4_H__
+#define __BACKEND_LZ4_H__
+
+#include "zcomp.h"
+
+extern const struct zcomp_ops backend_lz4;
+
+#endif /* __BACKEND_LZ4_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-lz4-compression-backend-support
+++ a/drivers/block/zram/Kconfig
@@ -20,6 +20,12 @@ config ZRAM_BACKEND_LZO
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 
+config ZRAM_BACKEND_LZ4
+	bool "lz4 compression support"
+	depends on ZRAM
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
@@ -33,12 +39,17 @@ config ZRAM_DEF_COMP_LZO
 	bool "lzo"
 	depends on ZRAM_BACKEND_LZO
 
+config ZRAM_DEF_COMP_LZ4
+	bool "lz4"
+	depends on ZRAM_BACKEND_LZ4
+
 endchoice
 
 config ZRAM_DEF_COMP
 	string
 	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
 	default "lzo" if ZRAM_DEF_COMP_LZO
+	default "lz4" if ZRAM_DEF_COMP_LZ4
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-lz4-compression-backend-support
+++ a/drivers/block/zram/Makefile
@@ -3,5 +3,6 @@
 zram-y	:=	zcomp.o zram_drv.o
 
 zram-$(CONFIG_ZRAM_BACKEND_LZO)	+= backend_lzorle.o backend_lzo.o
+zram-$(CONFIG_ZRAM_BACKEND_LZ4)	+= backend_lz4.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-lz4-compression-backend-support
+++ a/drivers/block/zram/zcomp.c
@@ -14,12 +14,16 @@
 
 #include "backend_lzo.h"
 #include "backend_lzorle.h"
+#include "backend_lz4.h"
 
 static const struct zcomp_ops *backends[] = {
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
 	&backend_lzorle,
 	&backend_lzo,
 #endif
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZ4)
+	&backend_lz4,
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

