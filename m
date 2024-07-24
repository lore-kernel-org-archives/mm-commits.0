Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5B613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849197; cv=none; b=XooyX2wewqnKCFrKLmiQfBmJW3oilFbcIDwz5V9n/b/ZIL7uEpRUmUSEUIlSxpk31K9cEp8FJXU7N/LdmphDaoBewYnyTERgbB1ukNMRWjlbaAGbKOUfYogO+Zg4aZ58303QmCStklRxnRjn2RCfi3OVIU80wOjH2mcw6qZTtvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849197; c=relaxed/simple;
	bh=KluGkHsJgKKaQ612mEVv+e+Vt0yCx3CHKEVfyyoEO2U=;
	h=Date:To:From:Subject:Message-Id; b=Cv7hyWFok+Vp27g/o7PNYtO+ZvZqZomXqxeVjcnKpwsV1xSX1l9mNRCPJma7mSBgykFycQ4vwUOw7HxeUTyyMN3XO35SOXRNuMZA4pjind6oNBeehFvwOS3otKAmUW0S6wHszrz82gjQMh4adtk16feGLgwPXIDMKvJF6cveR2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pum3F+4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pum3F+4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADF0C32781;
	Wed, 24 Jul 2024 19:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849197;
	bh=KluGkHsJgKKaQ612mEVv+e+Vt0yCx3CHKEVfyyoEO2U=;
	h=Date:To:From:Subject:From;
	b=pum3F+4JrpFIiqgnIDgScldO1cpSpn+46h7pJHabWE7q+kKDyQBtBEQ9Y23+s6ahz
	 FSmN29Nb0myHZ9FOEbLbquOCm1YGkCmduIrc6G9CS/S6AHqhZsIcfkN63XpIK3nmlE
	 OCqAdWFeKD/URqYRDP7mFjmZGgoYlgm54Tt+1swk=
Date: Wed, 24 Jul 2024 12:26:36 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-842-compression-backend-support.patch added to mm-unstable branch
Message-Id: <20240724192637.4ADF0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add 842 compression backend support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-842-compression-backend-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-842-compression-backend-support.patch

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
Subject: zram: add 842 compression backend support
Date: Fri, 12 Jul 2024 14:18:22 +0900

Add s/w 842 compression support.

Link: https://lkml.kernel.org/r/20240712051850.484318-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig       |   11 ++++
 drivers/block/zram/Makefile      |    1 
 drivers/block/zram/backend_842.c |   68 +++++++++++++++++++++++++++++
 drivers/block/zram/backend_842.h |   10 ++++
 drivers/block/zram/zcomp.c       |    4 +
 5 files changed, 94 insertions(+)

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
@@ -45,6 +45,12 @@ config ZRAM_BACKEND_DEFLATE
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
@@ -74,6 +80,10 @@ config ZRAM_DEF_COMP_DEFLATE
 	bool "deflate"
 	depends on ZRAM_BACKEND_DEFLATE
 
+config ZRAM_DEF_COMP_842
+	bool "842"
+	depends on ZRAM_BACKEND_842
+
 endchoice
 
 config ZRAM_DEF_COMP
@@ -84,6 +94,7 @@ config ZRAM_DEF_COMP
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

