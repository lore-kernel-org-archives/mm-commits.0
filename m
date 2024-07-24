Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A921613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849230; cv=none; b=Axu0COZ/75AywSY7hUaBcMwnT/rl6D3GGkt872hyzR5QaJ25okIFc8hb8iWxoXjlIAD7hsTnPAQOthlJXrPcJRjpuHR4+u/d/E4D6Ch/AtSN85iRDRekslMwQtP3d4DI43v3pFdBL0KrdYjaZEtJXj5jqhu9+emRHIsa48NIsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849230; c=relaxed/simple;
	bh=ND7fmQOZ1PTt5jt+dbIj7+wLbEunFy4vn6mu7Lfko98=;
	h=Date:To:From:Subject:Message-Id; b=s0NGJwkKKhsyWBIEncFRzEb9CMUO1fnQ50Jw84OdbDxY/86K+K57KzA0q3qyaqYeHbNkGAbItHdpR1a+8zWQ5/JXShR1nk73sHsivJOz5FBNgYhyEQVPCaRgTdkxrpiUzJexfaszUcluT9kmfwXDZmO4UnNSbdW2TIh9S28MGi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lbg5VHz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lbg5VHz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D6C32781;
	Wed, 24 Jul 2024 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849230;
	bh=ND7fmQOZ1PTt5jt+dbIj7+wLbEunFy4vn6mu7Lfko98=;
	h=Date:To:From:Subject:From;
	b=Lbg5VHz3ondNE/wNaDhgh7DDKN09Ki2iTw3IrByEgJAOR3Eu2XI5YqOYjS3iwYCgV
	 xnqZWlIpb/jNnesnSV3b9Yoc6RzCWAbX8BFHq7yPxvFUVbrVYBBHw/Mlc1ZQ1KU0Ak
	 aGqVdK9BnnzaIj6GupZssPze+q5v0VZbifkX4+sM=
Date: Wed, 24 Jul 2024 12:27:09 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-dictionary-support-to-lz4.patch added to mm-unstable branch
Message-Id: <20240724192710.475D6C32781@smtp.kernel.org>
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
Date: Fri, 12 Jul 2024 14:18:31 +0900

Support pre-trained dictionary param. lz4 doesn't
mandate specific format of the dictionary and even
zstd --train can be used to train a dictionary for
lz4, according to [1].

TEST
====
*** lz4
/sys/block/zram0/mm_stat
1750654976 664188565 676864000        0 676864000        1        0    34288    34288

*** lz4 dict=/home/ss/lz4-dict-amd64
/sys/block/zram0/mm_stat
1750638592 619891141 632053760        0 632053760        1        0    34278    34278

*** lz4 level=5 dict=/home/ss/lz4-dict-amd64
/sys/block/zram0/mm_stat
1750638592 727174243 740810752        0 740810752        1        0    34437    34437

[1] https://github.com/lz4/lz4/issues/557

Link: https://lkml.kernel.org/r/20240712051850.484318-21-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_lz4.c |   74 ++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/backend_lz4.c~zram-add-dictionary-support-to-lz4
+++ a/drivers/block/zram/backend_lz4.c
@@ -5,6 +5,13 @@
 
 #include "backend_lz4.h"
 
+struct lz4_ctx {
+	void *mem;
+
+	LZ4_streamDecode_t *dstrm;
+	LZ4_stream_t *cstrm;
+};
+
 static void lz4_release_params(struct zcomp_params *params)
 {
 }
@@ -19,25 +26,66 @@ static int lz4_setup_params(struct zcomp
 
 static void lz4_destroy(struct zcomp_ctx *ctx)
 {
-	vfree(ctx->context);
+	struct lz4_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
+
+	vfree(zctx->mem);
+	kfree(zctx->dstrm);
+	kfree(zctx->cstrm);
+	kfree(zctx);
 }
 
 static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	ctx->context = vmalloc(LZ4_MEM_COMPRESS);
-	if (!ctx->context)
+	struct lz4_ctx *zctx;
+
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
 		return -ENOMEM;
 
+	ctx->context = zctx;
+	if (params->dict_sz == 0) {
+		zctx->mem = vmalloc(LZ4_MEM_COMPRESS);
+		if (!zctx->mem)
+			goto error;
+	} else {
+		zctx->dstrm = kzalloc(sizeof(*zctx->dstrm), GFP_KERNEL);
+		if (!zctx->dstrm)
+			goto error;
+
+		zctx->cstrm = kzalloc(sizeof(*zctx->cstrm), GFP_KERNEL);
+		if (!zctx->cstrm)
+			goto error;
+	}
+
 	return 0;
+
+error:
+	lz4_destroy(ctx);
+	return -ENOMEM;
 }
 
 static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			struct zcomp_req *req)
 {
+	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
-	ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
-				req->dst_len, params->level, ctx->context);
+	if (!zctx->cstrm) {
+		ret = LZ4_compress_fast(req->src, req->dst, req->src_len,
+					req->dst_len, params->level,
+					zctx->mem);
+	} else {
+		/* Cstrm needs to be reset */
+		ret = LZ4_loadDict(zctx->cstrm, params->dict, params->dict_sz);
+		if (ret != params->dict_sz)
+			return -EINVAL;
+		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
+						 req->dst, req->src_len,
+						 req->dst_len, params->level);
+	}
 	if (!ret)
 		return -EINVAL;
 	req->dst_len = ret;
@@ -47,10 +95,22 @@ static int lz4_compress(struct zcomp_par
 static int lz4_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			  struct zcomp_req *req)
 {
+	struct lz4_ctx *zctx = ctx->context;
 	int ret;
 
-	ret = LZ4_decompress_safe(req->src, req->dst, req->src_len,
-				  req->dst_len);
+	if (!zctx->dstrm) {
+		ret = LZ4_decompress_safe(req->src, req->dst, req->src_len,
+					  req->dst_len);
+	} else {
+		/* Dstrm needs to be reset */
+		ret = LZ4_setStreamDecode(zctx->dstrm, params->dict,
+					  params->dict_sz);
+		if (!ret)
+			return -EINVAL;
+		ret = LZ4_decompress_safe_continue(zctx->dstrm, req->src,
+						   req->dst, req->src_len,
+						   req->dst_len);
+	}
 	if (ret < 0)
 		return -EINVAL;
 	return 0;
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

