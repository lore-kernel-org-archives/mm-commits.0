Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1214418E053
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925264; cv=none; b=eIgrvb6jRHvmTcdRg9MklO+1nwkkWBYRm/0fJ7jd7g8zbZsSF/NpG9HYqKPJUtIT2ei6bNKy19DBMg/AWb1kbw54/XShUBcLA27L+m3OKIiln2xyUv7u5cMgTFuwD7wyAv24hTKKdfimKd6Eury8LKctsawwoxocn2P35jr0btk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925264; c=relaxed/simple;
	bh=YB3LB+2X6g8cUgEuwyMY9u7mvKfRHw/S+Po6LMfIaEo=;
	h=Date:To:From:Subject:Message-Id; b=NsJk+fgZyrj8L6qLoC4ROSHkDiW9b+lHIaVTa4qRX8CsWKz8idJlKYn7Q88GXMfWHEnWAfZL1pDzXJX7cubqUEGjpq7QYcB0Zy4EGKM1R83PeqcOTa2NGQq53H+FZyrAE9FsVFwXfK8MamrhBWpkCW+gF5zYmECiRyAnWMnKxsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tBvLSUSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tBvLSUSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC48EC4CEC5;
	Mon,  9 Sep 2024 23:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925263;
	bh=YB3LB+2X6g8cUgEuwyMY9u7mvKfRHw/S+Po6LMfIaEo=;
	h=Date:To:From:Subject:From;
	b=tBvLSUSQRngyUonOTjgDuXOrORdW8Nntbej12iXx79JUvEBYg+7mN2MmR6L3yfsdU
	 f8f44hTTykWCONCTWDgnP+fRkQdXQV88HTmIMy42zpkYgVvvCwLUScm5ICxJtXfU9H
	 NAyv37Iu6Ikv0IZhxx+HTWONr6IpI2fiwkz1ZHw4=
Date: Mon, 09 Sep 2024 16:41:03 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-lzo-and-lzorle-compression-backends-support.patch removed from -mm tree
Message-Id: <20240909234103.DC48EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add lzo and lzorle compression backends support
has been removed from the -mm tree.  Its filename was
     zram-add-lzo-and-lzorle-compression-backends-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add lzo and lzorle compression backends support
Date: Mon, 2 Sep 2024 19:55:53 +0900

Add s/w lzo/lzorle compression support.

Link: https://lkml.kernel.org/r/20240902105656.1383858-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig          |   23 +++++++++++++
 drivers/block/zram/Makefile         |    3 +
 drivers/block/zram/backend_lzo.c    |   43 +++++++++++++++++++++++++
 drivers/block/zram/backend_lzo.h    |   10 +++++
 drivers/block/zram/backend_lzorle.c |   44 ++++++++++++++++++++++++++
 drivers/block/zram/backend_lzorle.h |   10 +++++
 drivers/block/zram/zcomp.c          |    7 ++++
 7 files changed, 140 insertions(+)

diff --git a/drivers/block/zram/backend_lzo.c a/drivers/block/zram/backend_lzo.c
new file mode 100644
--- /dev/null
+++ a/drivers/block/zram/backend_lzo.c
@@ -0,0 +1,43 @@
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
+static int lzo_compress(void *ctx, const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len)
+{
+	int ret;
+
+	ret = lzo1x_1_compress(src, src_len, dst, dst_len, ctx);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+static int lzo_decompress(void *ctx, const unsigned char *src, size_t src_len,
+			  unsigned char *dst, size_t dst_len)
+{
+	int ret;
+
+	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+const struct zcomp_ops backend_lzo = {
+	.compress	= lzo_compress,
+	.decompress	= lzo_decompress,
+	.create_ctx	= lzo_create,
+	.destroy_ctx	= lzo_destroy,
+	.name		= "lzo",
+};
diff --git a/drivers/block/zram/backend_lzo.h a/drivers/block/zram/backend_lzo.h
new file mode 100644
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
+extern const struct zcomp_ops backend_lzo;
+
+#endif /* __BACKEND_LZO_H__ */
diff --git a/drivers/block/zram/backend_lzorle.c a/drivers/block/zram/backend_lzorle.c
new file mode 100644
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
+static int lzorle_compress(void *ctx, const unsigned char *src, size_t src_len,
+			   unsigned char *dst, size_t *dst_len)
+{
+	int ret;
+
+	ret = lzorle1x_1_compress(src, src_len, dst, dst_len, ctx);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+static int lzorle_decompress(void *ctx, const unsigned char *src,
+			     size_t src_len, unsigned char *dst,
+			     size_t dst_len)
+{
+	int ret;
+
+	ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
+	return ret == LZO_E_OK ? 0 : ret;
+}
+
+const struct zcomp_ops backend_lzorle = {
+	.compress	= lzorle_compress,
+	.decompress	= lzorle_decompress,
+	.create_ctx	= lzorle_create,
+	.destroy_ctx	= lzorle_destroy,
+	.name		= "lzo-rle",
+};
diff --git a/drivers/block/zram/backend_lzorle.h a/drivers/block/zram/backend_lzorle.h
new file mode 100644
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
+extern const struct zcomp_ops backend_lzorle;
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
@@ -12,7 +12,14 @@
 
 #include "zcomp.h"
 
+#include "backend_lzo.h"
+#include "backend_lzorle.h"
+
 static const struct zcomp_ops *backends[] = {
+#if IS_ENABLED(CONFIG_ZRAM_BACKEND_LZO)
+	&backend_lzorle,
+	&backend_lzo,
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

