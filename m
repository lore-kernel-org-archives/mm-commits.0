Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ED118E77E
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925271; cv=none; b=NN4zAfZ4TtCgmdbqKmSSF71joiT4vAqRlLd3wqyQjxUIjCj//Urp8WG3DzHkrP376QcyR1c0zzCtrrgGd9WdJ3Rj0U7V1rKYr1TLuiI6llWRTRmOlRY7nANcLzg3AiFqxEJ3WHqndT/WTxEhPeJqCGKCEHH9QDJhCY24rznLVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925271; c=relaxed/simple;
	bh=AWwE+ksC3WXf4NmNqxv4xXpeuVY6uqaouSt18u8fyVE=;
	h=Date:To:From:Subject:Message-Id; b=SLrvnWOaGAqg57/ekNmpTskbHNdHAMjyrWsyNSGSEb6NPhP2TJLrIGrtj4tYe16FnzW2N932Yh+f5KneaQ+iurJ0vm5ngV0yYeOpGPHQavnkF0aRY7o0ZVBxgt5qCft12YVzR/OUFA0iSRL2qkIIEpxxTi0JVtnAEyn1BxlSWZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcQpqRmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcQpqRmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C583C4CEC5;
	Mon,  9 Sep 2024 23:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925271;
	bh=AWwE+ksC3WXf4NmNqxv4xXpeuVY6uqaouSt18u8fyVE=;
	h=Date:To:From:Subject:From;
	b=mcQpqRmy1B4u2GDTS5H47r2V5vwTK2yObfWGsQx+UY0EqQsWFgN/rCWmLevT1hhaH
	 uRO8tIuUWXjoLrOZnGR+hW6fV37f/Jpg+ATLabUWboGlijgbojiKm6LWXVHfsKrzim
	 lVhxbRuQtCQFUTWuQ1tXGijiDnKprvG3UMxxyUAU=
Date: Mon, 09 Sep 2024 16:41:11 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-842-compression-backend-support.patch removed from -mm tree
Message-Id: <20240909234111.7C583C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add 842 compression backend support
has been removed from the -mm tree.  Its filename was
     zram-add-842-compression-backend-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add 842 compression backend support
Date: Mon, 2 Sep 2024 19:55:59 +0900

Add s/w 842 compression support.

Link: https://lkml.kernel.org/r/20240902105656.1383858-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig       |   11 ++++
 drivers/block/zram/Makefile      |    1 
 drivers/block/zram/backend_842.c |   68 +++++++++++++++++++++++++++++
 drivers/block/zram/backend_842.h |   10 ++++
 drivers/block/zram/zcomp.c       |    4 +
 5 files changed, 94 insertions(+)

diff --git a/drivers/block/zram/backend_842.c a/drivers/block/zram/backend_842.c
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_842.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/sw842.h>
+#include <linux/vmalloc.h>
+
+#include "backend_842.h"
+
+struct sw842_ctx {
+	void *mem;
+};
+
+static void destroy_842(void *ctx)
+{
+	struct sw842_ctx *zctx = ctx;
+
+	kfree(zctx->mem);
+	kfree(zctx);
+}
+
+static void *create_842(void)
+{
+	struct sw842_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	ctx->mem = kmalloc(SW842_MEM_COMPRESS, GFP_KERNEL);
+	if (!ctx->mem)
+		goto error;
+
+	return ctx;
+
+error:
+	destroy_842(ctx);
+	return NULL;
+}
+
+static int compress_842(void *ctx, const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len)
+{
+	struct sw842_ctx *zctx = ctx;
+	unsigned int dlen = *dst_len;
+	int ret;
+
+	ret = sw842_compress(src, src_len, dst, &dlen, zctx->mem);
+	if (ret == 0)
+		*dst_len = dlen;
+	return ret;
+}
+
+static int decompress_842(void *ctx, const unsigned char *src, size_t src_len,
+			  unsigned char *dst, size_t dst_len)
+{
+	unsigned int dlen = dst_len;
+
+	return sw842_decompress(src, src_len, dst, &dlen);
+}
+
+const struct zcomp_ops backend_842 = {
+	.compress	= compress_842,
+	.decompress	= decompress_842,
+	.create_ctx	= create_842,
+	.destroy_ctx	= destroy_842,
+	.name		= "842",
+};
diff --git a/drivers/block/zram/backend_842.h a/drivers/block/zram/backend_842.h
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_842.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_842_H__
+#define __BACKEND_842_H__
+
+#include "zcomp.h"
+
+extern const struct zcomp_ops backend_842;
+
+#endif /* __BACKEND_842_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-842-compression-backend-support
+++ a/drivers/block/zram/Kconfig
@@ -44,6 +44,12 @@ config ZRAM_BACKEND_DEFLATE
 	select ZLIB_DEFLATE
 	select ZLIB_INFLATE
 
+config ZRAM_BACKEND_842
+	bool "842 compression support"
+	depends on ZRAM
+	select 842_COMPRESS
+	select 842_DECOMPRESS
+
 choice
 	prompt "Default zram compressor"
 	default ZRAM_DEF_COMP_LZORLE
@@ -73,6 +79,10 @@ config ZRAM_DEF_COMP_DEFLATE
 	bool "deflate"
 	depends on ZRAM_BACKEND_DEFLATE
 
+config ZRAM_DEF_COMP_842
+	bool "842"
+	depends on ZRAM_BACKEND_842
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -83,6 +93,7 @@ config ZRAM_DEF_COMP
 	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
 	default "zstd" if ZRAM_DEF_COMP_ZSTD
 	default "deflate" if ZRAM_DEF_COMP_DEFLATE
+	default "842" if ZRAM_DEF_COMP_842
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-842-compression-backend-support
+++ a/drivers/block/zram/Makefile
@@ -7,5 +7,6 @@ zram-$(CONFIG_ZRAM_BACKEND_LZ4)		+= back
 zram-$(CONFIG_ZRAM_BACKEND_LZ4HC)	+= backend_lz4hc.o
 zram-$(CONFIG_ZRAM_BACKEND_ZSTD)	+= backend_zstd.o
 zram-$(CONFIG_ZRAM_BACKEND_DEFLATE)	+= backend_deflate.o
+zram-$(CONFIG_ZRAM_BACKEND_842)		+= backend_842.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-842-compression-backend-support
+++ a/drivers/block/zram/zcomp.c
@@ -18,6 +18,7 @@
 #include "backend_lz4hc.h"
 #include "backend_zstd.h"
 #include "backend_deflate.h"
+#include "backend_842.h"
 
 static const struct zcomp_ops *backends[] = {
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
@@ -36,6 +37,9 @@ static const struct zcomp_ops *backends[
 #if IS_ENABLED(CONFIG_ZRAM_BACKEND_DEFLATE)
 	&backend_deflate,
 #endif
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_842)
+	&backend_842,
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

