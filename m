Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655FA18E345
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925284; cv=none; b=qLZs6+YTtvHbG2J2LkVC+z3I3n8yxI9C6EcnHHCzHNYGGe/Gw0iNjGdQLNwkU2li5826G7UguOUkPhLBuSNxMwE+nOR2jj+i7/k2rqz6DVx2rByYs6HzZRrbJbfz1HEfT9ZxwFwTHK+noeiri2Daa//KWvbNzQxPVJIj8kmTN4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925284; c=relaxed/simple;
	bh=x/SEnP7rJAjJ6Blv5svqL5nZBOPIigO/pQUYcGKhPHs=;
	h=Date:To:From:Subject:Message-Id; b=TiOhbur6M7KnKvCShAaGVTSPSKqx/d/3/i1DGew4KhfrLoIouINeXCgtSkqNto5gwyw2O+6M3tBtRNL6KA5yonMfrrzRwryHAuAu3Vgefe0YYsWo/rnMLxuB6obTKk5IgjVfiqGVUW7Tpp+a5e5WTqiBHWJKuRWz4eS/35mA+J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CastqcLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CastqcLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0DBC4CEC5;
	Mon,  9 Sep 2024 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925284;
	bh=x/SEnP7rJAjJ6Blv5svqL5nZBOPIigO/pQUYcGKhPHs=;
	h=Date:To:From:Subject:From;
	b=CastqcLCJ1g8JmvpEi00yU368dbMc1TqsHeyghTSQY2BCwpRwsQPjmPNQsbBFi0ty
	 XPaSNGS3tYZ2xz9PflbTufDSFPoT83NFF0vl81lBaT8a57Izg2gRhDADerMiW0DppF
	 XQ7LNnAEIxxveDOhEVKzRdbHqiC2As4BaXdJ5z5I=
Date: Mon, 09 Sep 2024 16:41:23 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-dictionary-support-to-lz4hc.patch removed from -mm tree
Message-Id: <20240909234124.3A0DBC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add dictionary support to lz4hc
has been removed from the -mm tree.  Its filename was
     zram-add-dictionary-support-to-lz4hc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add dictionary support to lz4hc
Date: Mon, 2 Sep 2024 19:56:09 +0900

Support pre-trained dictionary param.  Just like lz4, lz4hc doesn't
mandate specific format of the dictionary and zstd --train can be used to
train a dictionary for lz4, according to [1].

TEST
====

*** lz4hc
/sys/block/zram0/mm_stat
1750638592 608954620 621031424        0 621031424        1        0    34288    34288

*** lz4hc dict=/etc/lz4-dict-amd64
/sys/block/zram0/mm_stat
1750671360 505068582 514994176        0 514994176        1        0    34278    34278

[1] https://github.com/lz4/lz4/issues/557

Link: https://lkml.kernel.org/r/20240902105656.1383858-22-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_lz4hc.c |   75 ++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/backend_lz4hc.c~zram-add-dictionary-support-to-lz4hc
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -5,6 +5,13 @@
 
 #include "backend_lz4hc.h"
 
+struct lz4hc_ctx {
+	void *mem;
+
+	LZ4_streamDecode_t *dstrm;
+	LZ4_streamHC_t *cstrm;
+};
+
 static void lz4hc_release_params(struct zcomp_params *params)
 {
 }
@@ -19,25 +26,67 @@ static int lz4hc_setup_params(struct zco
 
 static void lz4hc_destroy(struct zcomp_ctx *ctx)
 {
-	vfree(ctx->context);
+	struct lz4hc_ctx *zctx = ctx->context;
+
+	if (!zctx)
+		return;
+
+	kfree(zctx->dstrm);
+	kfree(zctx->cstrm);
+	vfree(zctx->mem);
+	kfree(zctx);
 }
 
 static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
 {
-	ctx->context = vmalloc(LZ4HC_MEM_COMPRESS);
-	if (!ctx->context)
+	struct lz4hc_ctx *zctx;
+
+	zctx = kzalloc(sizeof(*zctx), GFP_KERNEL);
+	if (!zctx)
 		return -ENOMEM;
 
+	ctx->context = zctx;
+	if (params->dict_sz == 0) {
+		zctx->mem = vmalloc(LZ4HC_MEM_COMPRESS);
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
+	lz4hc_destroy(ctx);
+	return -EINVAL;
 }
 
 static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			  struct zcomp_req *req)
 {
+	struct lz4hc_ctx *zctx = ctx->context;
 	int ret;
 
-	ret = LZ4_compress_HC(req->src, req->dst, req->src_len, req->dst_len,
-			      params->level, ctx->context);
+	if (!zctx->cstrm) {
+		ret = LZ4_compress_HC(req->src, req->dst, req->src_len,
+				      req->dst_len, params->level,
+				      zctx->mem);
+	} else {
+		/* Cstrm needs to be reset */
+		LZ4_resetStreamHC(zctx->cstrm, params->level);
+		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
+				     params->dict_sz);
+		if (ret != params->dict_sz)
+			return -EINVAL;
+		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
+					       req->src_len, req->dst_len);
+	}
 	if (!ret)
 		return -EINVAL;
 	req->dst_len = ret;
@@ -47,10 +96,22 @@ static int lz4hc_compress(struct zcomp_p
 static int lz4hc_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			    struct zcomp_req *req)
 {
+	struct lz4hc_ctx *zctx = ctx->context;
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

zsmalloc-use-unique-zsmalloc-caches-names.patch

