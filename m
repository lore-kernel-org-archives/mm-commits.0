Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C473B1A4E9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311944; cv=none; b=QN64Isp1tTo6u8oIlJ8n5gqL8ksn89PHeUJKL8KxLYZW4FwhdtCUQhufGG0hJ+7xOvW6Nsni8LnaN4DgdYXiCrYiJEDp0xd/KOQc+yeKPYSZcw2/y25UwFNtmAxZ9Zd/8Sf4Xu5eOUK376IjBHl+AmfMA7zoWHwKY08hpceXqyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311944; c=relaxed/simple;
	bh=lWtSaI2eGfxYup7IbPZ6KIbX/yo9va54GQzRZxpGAT0=;
	h=Date:To:From:Subject:Message-Id; b=do4x52I+teppLd00Nb8ejP8As5+h1Y10nYPASuurnN8gBN+xzeGx1Ca0DPe2ReRwiY6W+g+4Rrcusc+5FVbQjrR/4M/UaGmQyOuTN/V5GKQrDJl2Ebu2kLn1k1t1FFNL5z8v4X4iuCFQoYG8vZR0LwccDQaQfERnGdpnm9Z1/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bqo7+rto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bqo7+rto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9630BC4CEC2;
	Mon,  2 Sep 2024 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311944;
	bh=lWtSaI2eGfxYup7IbPZ6KIbX/yo9va54GQzRZxpGAT0=;
	h=Date:To:From:Subject:From;
	b=Bqo7+rtovmpb884eYKXcgd8I9ruObauHLpAlKB8EWK7WojtdvWmHm4wLxyiS+yiSQ
	 SUC7uY0iv9JLb6n5bHCcRf3NcU3rhTjQaUNvq4IoZBLEn6vA9YdBSp4HM17ISbnc8O
	 SyCuWj/yt7AIzrkejX+y16XyZzXfsvNOyfeDtlbo=
Date: Mon, 02 Sep 2024 14:19:04 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-dictionary-support-to-zstd-backend.patch added to mm-unstable branch
Message-Id: <20240902211904.9630BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add dictionary support to zstd backend
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-dictionary-support-to-zstd-backend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-dictionary-support-to-zstd-backend.patch

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
Subject: zram: add dictionary support to zstd backend
Date: Mon, 2 Sep 2024 19:56:10 +0900

This adds support for pre-trained zstd dictionaries [1] Dictionary is
setup in params once (per-comp) and loaded to Cctx and Dctx by reference,
so we don't allocate extra memory.

TEST
====

*** zstd
/sys/block/zram0/mm_stat
1750654976 504565092 514203648        0 514203648        1        0    34204    34204

*** zstd dict=/etc/zstd-dict-amd64
/sys/block/zram0/mm_stat
1750638592 465851259 475373568        0 475373568        1        0    34185    34185

*** zstd level=8 dict=/etc/zstd-dict-amd64
/sys/block/zram0/mm_stat
1750642688 430765171 439955456        0 439955456        1        0    34185    34185

[1] https://github.com/facebook/zstd/blob/dev/programs/zstd.1.md#dictionary-builder

Link: https://lkml.kernel.org/r/20240902105656.1383858-23-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |  150 +++++++++++++++++++++++-----
 1 file changed, 124 insertions(+), 26 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-add-dictionary-support-to-zstd-backend
+++ a/drivers/block/zram/backend_zstd.c
@@ -15,29 +15,87 @@ struct zstd_ctx {
 };
 
 struct zstd_params {
+	zstd_custom_mem custom_mem;
+	zstd_cdict *cdict;
+	zstd_ddict *ddict;
 	zstd_parameters cprm;
 };
 
+/*
+ * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
+ * which zstd uses internally to allocate/free memory when needed.
+ *
+ * This means that allocator.customAlloc() can be called from zcomp_compress()
+ * under local-lock (per-CPU compression stream), in which case we must use
+ * GFP_ATOMIC.
+ *
+ * Another complication here is that we can be configured as a swap device.
+ */
+static void *zstd_custom_alloc(void *opaque, size_t size)
+{
+	if (!preemptible())
+		return kvzalloc(size, GFP_ATOMIC);
+
+	return kvzalloc(size, __GFP_KSWAPD_RECLAIM | __GFP_NOWARN);
+}
+
+static void zstd_custom_free(void *opaque, void *address)
+{
+	kvfree(address);
+}
+
 static void zstd_release_params(struct zcomp_params *params)
 {
-	kfree(params->drv_data);
+	struct zstd_params *zp = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!zp)
+		return;
+
+	zstd_free_cdict(zp->cdict);
+	zstd_free_ddict(zp->ddict);
+	kfree(zp);
 }
 
 static int zstd_setup_params(struct zcomp_params *params)
 {
+	zstd_compression_parameters prm;
 	struct zstd_params *zp;
 
 	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
 	if (!zp)
 		return -ENOMEM;
 
+	params->drv_data = zp;
 	if (params->level == ZCOMP_PARAM_NO_LEVEL)
 		params->level = zstd_default_clevel();
 
 	zp->cprm = zstd_get_params(params->level, PAGE_SIZE);
-	params->drv_data = zp;
+
+	zp->custom_mem.customAlloc = zstd_custom_alloc;
+	zp->custom_mem.customFree = zstd_custom_free;
+
+	prm = zstd_get_cparams(params->level, PAGE_SIZE,
+			       params->dict_sz);
+
+	zp->cdict = zstd_create_cdict_byreference(params->dict,
+						  params->dict_sz,
+						  prm,
+						  zp->custom_mem);
+	if (!zp->cdict)
+		goto error;
+
+	zp->ddict = zstd_create_ddict_byreference(params->dict,
+						  params->dict_sz,
+						  zp->custom_mem);
+	if (!zp->ddict)
+		goto error;
 
 	return 0;
+
+error:
+	zstd_release_params(params);
+	return -EINVAL;
 }
 
 static void zstd_destroy(struct zcomp_ctx *ctx)
@@ -47,8 +105,23 @@ static void zstd_destroy(struct zcomp_ct
 	if (!zctx)
 		return;
 
-	vfree(zctx->cctx_mem);
-	vfree(zctx->dctx_mem);
+	/*
+	 * If ->cctx_mem and ->dctx_mem were allocated then we didn't use
+	 * C/D dictionary and ->cctx / ->dctx were "embedded" into these
+	 * buffers.
+	 *
+	 * If otherwise then we need to explicitly release ->cctx / ->dctx.
+	 */
+	if (zctx->cctx_mem)
+		vfree(zctx->cctx_mem);
+	else
+		zstd_free_cctx(zctx->cctx);
+
+	if (zctx->dctx_mem)
+		vfree(zctx->dctx_mem);
+	else
+		zstd_free_dctx(zctx->dctx);
+
 	kfree(zctx);
 }
 
@@ -63,28 +136,41 @@ static int zstd_create(struct zcomp_para
 		return -ENOMEM;
 
 	ctx->context = zctx;
-	prm = zstd_get_params(params->level, PAGE_SIZE);
-	sz = zstd_cctx_workspace_bound(&prm.cParams);
-	zctx->cctx_mem = vzalloc(sz);
-	if (!zctx->cctx_mem)
-		goto error;
-
-	zctx->cctx = zstd_init_cctx(zctx->cctx_mem, sz);
-	if (!zctx->cctx)
-		goto error;
-
-	sz = zstd_dctx_workspace_bound();
-	zctx->dctx_mem = vzalloc(sz);
-	if (!zctx->dctx_mem)
-		goto error;
-
-	zctx->dctx = zstd_init_dctx(zctx->dctx_mem, sz);
-	if (!zctx->dctx)
-		goto error;
+	if (params->dict_sz == 0) {
+		prm = zstd_get_params(params->level, PAGE_SIZE);
+		sz = zstd_cctx_workspace_bound(&prm.cParams);
+		zctx->cctx_mem = vzalloc(sz);
+		if (!zctx->cctx_mem)
+			goto error;
+
+		zctx->cctx = zstd_init_cctx(zctx->cctx_mem, sz);
+		if (!zctx->cctx)
+			goto error;
+
+		sz = zstd_dctx_workspace_bound();
+		zctx->dctx_mem = vzalloc(sz);
+		if (!zctx->dctx_mem)
+			goto error;
+
+		zctx->dctx = zstd_init_dctx(zctx->dctx_mem, sz);
+		if (!zctx->dctx)
+			goto error;
+	} else {
+		struct zstd_params *zp = params->drv_data;
+
+		zctx->cctx = zstd_create_cctx_advanced(zp->custom_mem);
+		if (!zctx->cctx)
+			goto error;
+
+		zctx->dctx = zstd_create_dctx_advanced(zp->custom_mem);
+		if (!zctx->dctx)
+			goto error;
+	}
 
 	return 0;
 
 error:
+	zstd_release_params(params);
 	zstd_destroy(ctx);
 	return -EINVAL;
 }
@@ -96,8 +182,14 @@ static int zstd_compress(struct zcomp_pa
 	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
 
-	ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
-				 req->src, req->src_len, &zp->cprm);
+	if (params->dict_sz == 0)
+		ret = zstd_compress_cctx(zctx->cctx, req->dst, req->dst_len,
+					 req->src, req->src_len, &zp->cprm);
+	else
+		ret = zstd_compress_using_cdict(zctx->cctx, req->dst,
+						req->dst_len, req->src,
+						req->src_len,
+						zp->cdict);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	req->dst_len = ret;
@@ -107,11 +199,17 @@ static int zstd_compress(struct zcomp_pa
 static int zstd_decompress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 			   struct zcomp_req *req)
 {
+	struct zstd_params *zp = params->drv_data;
 	struct zstd_ctx *zctx = ctx->context;
 	size_t ret;
 
-	ret = zstd_decompress_dctx(zctx->dctx, req->dst, req->dst_len,
-				   req->src, req->src_len);
+	if (params->dict_sz == 0)
+		ret = zstd_decompress_dctx(zctx->dctx, req->dst, req->dst_len,
+					   req->src, req->src_len);
+	else
+		ret = zstd_decompress_using_ddict(zctx->dctx, req->dst,
+						  req->dst_len, req->src,
+						  req->src_len, zp->ddict);
 	if (zstd_is_error(ret))
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

