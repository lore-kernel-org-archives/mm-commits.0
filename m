Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F837CF25
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417103; cv=none; b=lRuWYpz66tDOOebSLP6YvQSIFpVS7A2LblHCIJWQmc4IlpGYR/7Gd/WBWdO6JRIOgRjX7zy4BXDrb4HKuUKvhJuco0Bn9fgnBPigD4N3s2X1soxbs9SJWHoFwJtf/AaTTFct40X05JsCPiGW/ql09h3zOXL05VpOdkU0AfQI/T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417103; c=relaxed/simple;
	bh=rs9GCFP3NJO5iMkaJ71JVciuIF1n3+rkiKRHxwMw5is=;
	h=Date:To:From:Subject:Message-Id; b=oBi5laXXaBbCHwctA0YfYQ8iJg9oMfraSg7yBlvI5KZ8aVYQ+MUpVf8LP6npEJydyinA0/S0gK6octXt1YZIdSmt6TuXi3HQfArySQ8gXbbfk5Clhl/DrV7s5e8c+zfPt1/U/wn+aenmoQGcx3N3UWsf51zrg8w2+3KOFFNbER8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RfkK4KDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RfkK4KDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41315C2BBFC;
	Wed, 22 May 2024 22:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417103;
	bh=rs9GCFP3NJO5iMkaJ71JVciuIF1n3+rkiKRHxwMw5is=;
	h=Date:To:From:Subject:From;
	b=RfkK4KDPVw1JpClVVpBc2ZHO7Qnpomne5Pwii0fftOH3pvADaSzoJb1M1MauVzmki
	 CvEBYeDbXF9bDnSuHMIpEfHLebBMJwVa3l/ui56ok85PsftSrIiwVjmOSbKQ5Kc54E
	 4JFnVyTDTz03srOWEZOTw3sxQ/qiXpsNkzzqCOgI=
Date: Wed, 22 May 2024 15:31:42 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-lzo-and-lzorle-compression-backends-support.patch added to mm-unstable branch
Message-Id: <20240522223143.41315C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add lzo and lzorle compression backends support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-lzo-and-lzorle-compression-backends-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-lzo-and-lzorle-compression-backends-support.patch

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
Subject: zram: add lzo and lzorle compression backends support
Date: Wed, 15 May 2024 16:12:39 +0900

Add s/w lzo/lzorle compression support.

Link: https://lkml.kernel.org/r/20240515071645.1788128-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig          |   23 +++++++++++++
 drivers/block/zram/Makefile         |    3 +
 drivers/block/zram/backend_lzo.c    |   44 ++++++++++++++++++++++++++
 drivers/block/zram/backend_lzo.h    |   10 +++++
 drivers/block/zram/backend_lzorle.c |   44 ++++++++++++++++++++++++++
 drivers/block/zram/backend_lzorle.h |   10 +++++
 drivers/block/zram/zcomp.c          |    7 ++++
 7 files changed, 141 insertions(+)

--- /dev/null
+++ a/drivers/block/zram/backend_lzo.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lzo.h>
+
+#include "backend_lzo.h"
+
+static void *lzo_create(void)
+{
+	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void lzo_destroy(void *ctx)
+{
+	kfree(ctx);
+}
+
+static int lzo_compress(void *ctx, const unsigned char *src,
+			unsigned char *dst, size_t *dst_len)
+{
+	int ret;
+
+	ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, ctx);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+static int lzo_decompress(void *ctx, const unsigned char *src, size_t src_len,
+			  unsigned char *dst)
+{
+	size_t dst_len = PAGE_SIZE;
+	int ret;
+
+	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+struct zcomp_backend backend_lzo = {
+	.compress	= lzo_compress,
+	.decompress	= lzo_decompress,
+	.create_ctx	= lzo_create,
+	.destroy_ctx	= lzo_destroy,
+	.name		= "lzo",
+};
--- /dev/null
+++ a/drivers/block/zram/backend_lzo.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_LZO_H__
+#define __BACKEND_LZO_H__
+
+#include "zcomp.h"
+
+extern struct zcomp_backend backend_lzo;
+
+#endif /* __BACKEND_LZO_H__ */
--- /dev/null
+++ a/drivers/block/zram/backend_lzorle.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lzo.h>
+
+#include "backend_lzorle.h"
+
+static void *lzorle_create(void)
+{
+	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void lzorle_destroy(void *ctx)
+{
+	kfree(ctx);
+}
+
+static int lzorle_compress(void *ctx, const unsigned char *src,
+			   unsigned char *dst, size_t *dst_len)
+{
+	int ret;
+
+	ret = lzorle1x_1_compress(src, PAGE_SIZE, dst, dst_len, ctx);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+static int lzorle_decompress(void *ctx, const unsigned char *src,
+			     size_t src_len, unsigned char *dst)
+{
+	size_t dst_len = PAGE_SIZE;
+	int ret;
+
+	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+struct zcomp_backend backend_lzorle = {
+	.compress	= lzorle_compress,
+	.decompress	= lzorle_decompress,
+	.create_ctx	= lzorle_create,
+	.destroy_ctx	= lzorle_destroy,
+	.name		= "lzo-rle",
+};
--- /dev/null
+++ a/drivers/block/zram/backend_lzorle.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#ifndef __BACKEND_LZORLE_H__
+#define __BACKEND_LZORLE_H__
+
+#include "zcomp.h"
+
+extern struct zcomp_backend backend_lzorle;
+
+#endif /* __BACKEND_LZORLE_H__ */
--- a/drivers/block/zram/Kconfig~zram-add-lzo-and-lzorle-compression-backends-support
+++ a/drivers/block/zram/Kconfig
@@ -14,8 +14,31 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
+config ZRAM_BACKEND_LZO
+	bool "lzo and lzo-rle compression support"
+	depends on ZRAM
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+
+choice
+	prompt "Default zram compressor"
+	default ZRAM_DEF_COMP_LZORLE
+	depends on ZRAM
+
+config ZRAM_DEF_COMP_LZORLE
+	bool "lzo-rle"
+	depends on ZRAM_BACKEND_LZO
+
+config ZRAM_DEF_COMP_LZO
+	bool "lzo"
+	depends on ZRAM_BACKEND_LZO
+
+endchoice
+
 config ZRAM_DEF_COMP
 	string
+	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
+	default "lzo" if ZRAM_DEF_COMP_LZO
 	default "unset-value"
 
 config ZRAM_WRITEBACK
--- a/drivers/block/zram/Makefile~zram-add-lzo-and-lzorle-compression-backends-support
+++ a/drivers/block/zram/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
 zram-y	:=	zcomp.o zram_drv.o
 
+zram-$(CONFIG_ZRAM_BACKEND_LZO)	+= backend_lzorle.o backend_lzo.o
+
 obj-$(CONFIG_ZRAM)	+=	zram.o
--- a/drivers/block/zram/zcomp.c~zram-add-lzo-and-lzorle-compression-backends-support
+++ a/drivers/block/zram/zcomp.c
@@ -15,7 +15,14 @@
 
 #include "zcomp.h"
 
+#include "backend_lzo.h"
+#include "backend_lzorle.h"
+
 static struct zcomp_backend *backends[] = {
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
+	&backend_lzorle,
+	&backend_lzo,
+#endif
 	NULL
 };
 
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

