Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDD8148848
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417139; cv=none; b=Gr5hdytAefgV5lB+/3dgRM+pdtGAyvsVv4/pW73P47BekF0YOBpR5+yaQToTGTuISpts4WinGiytU4g8QVb70fLhScLmO9PQreBFoxqEzpJ8wHyByJyreVuq0/X3SZ6UUnxFqlph0b21qu/M46CsiK5DGZfv8nbORjaroX/cA5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417139; c=relaxed/simple;
	bh=xQE9TguMRi+7s6KH6+aM+kt5jt8nx8pWr4YHuv5fAnE=;
	h=Date:To:From:Subject:Message-Id; b=ImroaztGF+3V5RyBO7xnerjrlh7S9D15y8oMga3jNteehUFuTCSiZUnLdilqnILVcn5GbTizgLE2x0hR7M/GsLPkpmgqQlz7RD2h1n1F8qs5F88epNKfmw4sJts0gu8XnO+XOjhNzfN2tbqKbZHAosm5i8gxPZ9OkjCsm+o2FJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tX8krRUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tX8krRUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE43C2BBFC;
	Wed, 22 May 2024 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417139;
	bh=xQE9TguMRi+7s6KH6+aM+kt5jt8nx8pWr4YHuv5fAnE=;
	h=Date:To:From:Subject:From;
	b=tX8krRUkienCIzrrg+d5U4brkVy4rZRNsDuaTpTfc23R2jBdmxStydLxl023Mf+am
	 bQ8kNLA8mYTTF1kzM4M460Xzf0FOgzIIGmoXHZUlmu8nUv1EiafKzJ/EpussN5wQ9V
	 Q2mtlCpD5j07BW1QGtPmdVt0Vr2wWm8Lbtr4TtA4=
Date: Wed, 22 May 2024 15:32:18 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-dictionary-support-to-lz4.patch added to mm-unstable branch
Message-Id: <20240522223219.0FE43C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add dictionary support to lz4
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-dictionary-support-to-lz4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-dictionary-support-to-lz4.patch

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
Subject: zram: add dictionary support to lz4
Date: Wed, 15 May 2024 16:12:55 +0900

Support pre-trained dictionary param.  lz4 doesn't mandate specific format
of the dictionary and even zstd --train can be used to train a dictionary
for lz4, according to [1].

TEST
====

- default lz4

/sys/block/zram0/mm_stat
1750323200 664258735 676990976        0 676990976        2        0    34288    34288

- lz4 dict=/etc/dictionary

/sys/block/zram0/mm_stat
1750310912 620608254 632852480        0 632852480        1        0    34288    34288

[1] https://github.com/lz4/lz4/issues/557

Link: https://lkml.kernel.org/r/20240515071645.1788128-19-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_lz4.c |   54 +++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/backend_lz4.c~zram-add-dictionary-support-to-lz4
+++ a/drivers/block/zram/backend_lz4.c
@@ -8,6 +8,12 @@
 struct lz4_ctx {
 	void *mem;
 	s32 level;
+	LZ4_streamDecode_t *dstrm;
+	LZ4_stream_t *cstrm;
+
+	/* Shared between C/D streams */
+	void *dict;
+	size_t dict_sz;
 };
 
 static int lz4_init_config(struct zcomp_config *config)
@@ -26,6 +32,8 @@ static void lz4_destroy(void *ctx)
 {
 	struct lz4_ctx *zctx = ctx;
 
+	kfree(zctx->dstrm);
+	kfree(zctx->cstrm);
 	vfree(zctx->mem);
 	kfree(zctx);
 }
@@ -39,9 +47,22 @@ static void *lz4_create(struct zcomp_con
 		return NULL;
 
 	ctx->level = config->level;
-	ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
-	if (!ctx->mem)
-		goto error;
+	if (!config->dict) {
+		ctx->mem = vmalloc(LZ4_MEM_COMPRESS);
+		if (!ctx->mem)
+			goto error;
+	} else {
+		ctx->dstrm = kzalloc(sizeof(*ctx->dstrm), GFP_KERNEL);
+		if (!ctx->dstrm)
+			goto error;
+
+		ctx->cstrm = kzalloc(sizeof(*ctx->cstrm), GFP_KERNEL);
+		if (!ctx->cstrm)
+			goto error;
+
+		ctx->dict = config->dict;
+		ctx->dict_sz = config->dict_sz;
+	}
 
 	return ctx;
 error:
@@ -55,8 +76,18 @@ static int lz4_compress(void *ctx, const
 	struct lz4_ctx *zctx = ctx;
 	int ret;
 
-	ret = LZ4_compress_fast(src, dst, PAGE_SIZE, *dst_len,
-				zctx->level, zctx->mem);
+	if (!zctx->cstrm) {
+		ret = LZ4_compress_fast(src, dst, PAGE_SIZE, *dst_len,
+					zctx->level, zctx->mem);
+	} else {
+		/* Cstrm needs to be reset */
+		ret = LZ4_loadDict(zctx->cstrm, zctx->dict, zctx->dict_sz);
+		if (ret != zctx->dict_sz)
+			return -EINVAL;
+		ret = LZ4_compress_fast_continue(zctx->cstrm, src, dst,
+						 PAGE_SIZE, *dst_len,
+						 zctx->level);
+	}
 	if (!ret)
 		return -EINVAL;
 	*dst_len = ret;
@@ -66,10 +97,21 @@ static int lz4_compress(void *ctx, const
 static int lz4_decompress(void *ctx, const unsigned char *src,
 			  size_t src_len, unsigned char *dst)
 {
+	struct lz4_ctx *zctx = ctx;
 	int dst_len = PAGE_SIZE;
 	int ret;
 
-	ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	if (!zctx->dstrm) {
+		ret = LZ4_decompress_safe(src, dst, src_len, dst_len);
+	} else {
+		/* Dstrm needs to be reset */
+		ret = LZ4_setStreamDecode(zctx->dstrm, zctx->dict,
+					  zctx->dict_sz);
+		if (!ret)
+			return -EINVAL;
+		ret = LZ4_decompress_safe_continue(zctx->dstrm, src, dst,
+						   src_len, dst_len);
+	}
 	if (ret < 0)
 		return -EINVAL;
 	return 0;
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

