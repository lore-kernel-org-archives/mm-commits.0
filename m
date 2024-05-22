Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E71487C5
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417142; cv=none; b=OlPU+geD4HWvqiDS7xDZwKaDyTZbU+tJI4AGv+owvZ7c0fkEuqrP6GGB83HroEHOzNE6MeFMvxrRpPeoqVIRt7BNUoIdS8xc8h2SvJElw0Zk84Uziut4OubAVxd0L3m6tfL1ruLkLQog4YF+ZWOaewu0mgMEIIqPP+MtRNoyPmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417142; c=relaxed/simple;
	bh=wT1Mts0rv5f3qPBtu470A5jbERt0P63BaHaRoZA3RiA=;
	h=Date:To:From:Subject:Message-Id; b=YC2ssNeSjrraS3HDw9uEeeV9hiteC0v1d3dh63UzXu7b8QTnsj4EjA5wFIWtEaY2nLThz7Nx60wDnO1/iNMDDdXiHliQxdNGd6w/9NuDJuShXxmi+8U16VNkzR7LOw4412p9ObNr5u1ltJc0gwYOd8nhE5rbm5kEoQKx4RR8o1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EGgYqtSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EGgYqtSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B4EC2BBFC;
	Wed, 22 May 2024 22:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417142;
	bh=wT1Mts0rv5f3qPBtu470A5jbERt0P63BaHaRoZA3RiA=;
	h=Date:To:From:Subject:From;
	b=EGgYqtSaAquhMjtz3x0g83oI1p0t2Ea9T08pp7WTXwdH4YDj+1tcDUyC3Vhk4xMDn
	 rZYi7FN2owwokssmlzUiz541BlmxFeTkl8x8F9PAeYLZnGLNfVUrw4fupDtpSLjsR/
	 al0bGTYSDqQzRleiOdr24EWFeCLeIxmPuDTFawPo=
Date: Wed, 22 May 2024 15:32:21 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-dictionary-support-to-lz4hc.patch added to mm-unstable branch
Message-Id: <20240522223221.E2B4EC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add dictionary support to lz4hc
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-dictionary-support-to-lz4hc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-dictionary-support-to-lz4hc.patch

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
Subject: zram: add dictionary support to lz4hc
Date: Wed, 15 May 2024 16:12:57 +0900

Support pre-trained dictionary param.  Just like lz4, lz4hc doesn't
mandate specific format of the dictionary and zstd --train can be used to
train a dictionary for lz4, according to [1].

TEST
====

- default lz4hc

/sys/block/zram0/mm_stat
1750315008 609010918 621006848        0 621006848        2        0    34288    34288

- lz4hc dict=/etc/dictionary

/sys/block/zram0/mm_stat
1750319104 499629401 509485056        0 509485056        1        0    34288    34288

[1] https://github.com/lz4/lz4/issues/557

Link: https://lkml.kernel.org/r/20240515071645.1788128-21-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_lz4hc.c |   54 ++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/backend_lz4hc.c~zram-add-dictionary-support-to-lz4hc
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -8,6 +8,12 @@
 struct lz4hc_ctx {
 	void *mem;
 	s32 level;
+	LZ4_streamDecode_t *dstrm;
+	LZ4_streamHC_t *cstrm;
+
+	/* Shared between C/D streams */
+	void *dict;
+	size_t dict_sz;
 };
 
 static int lz4hc_init_config(struct zcomp_config *config)
@@ -26,6 +32,8 @@ static void lz4hc_destroy(void *ctx)
 {
 	struct lz4hc_ctx *zctx = ctx;
 
+	kfree(zctx->dstrm);
+	kfree(zctx->cstrm);
 	vfree(zctx->mem);
 	kfree(zctx);
 }
@@ -39,9 +47,22 @@ static void *lz4hc_create(struct zcomp_c
 		return NULL;
 
 	ctx->level = config->level;
-	ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
-	if (!ctx->mem)
-		goto error;
+	if (!config->dict) {
+		ctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
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
@@ -55,8 +76,18 @@ static int lz4hc_compress(void *ctx, con
 	struct lz4hc_ctx *zctx = ctx;
 	int ret;
 
-	ret = LZ4_compress_HC(src, dst, PAGE_SIZE, *dst_len,
-			      zctx->level, zctx->mem);
+	if (!zctx->cstrm) {
+		ret = LZ4_compress_HC(src, dst, PAGE_SIZE, *dst_len,
+				      zctx->level, zctx->mem);
+	} else {
+		/* Cstrm needs to be reset */
+		LZ4_resetStreamHC(zctx->cstrm, zctx->level);
+		ret = LZ4_loadDictHC(zctx->cstrm, zctx->dict, zctx->dict_sz);
+		if (ret != zctx->dict_sz)
+			return -EINVAL;
+		ret = LZ4_compress_HC_continue(zctx->cstrm, src, dst,
+					       PAGE_SIZE, *dst_len);
+	}
 	if (!ret)
 		return -EINVAL;
 	*dst_len = ret;
@@ -66,10 +97,21 @@ static int lz4hc_compress(void *ctx, con
 static int lz4hc_decompress(void *ctx, const unsigned char *src,
 			    size_t src_len, unsigned char *dst)
 {
+	struct lz4hc_ctx *zctx = ctx;
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

