Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D991CD2B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311875; cv=none; b=p7NaEl7xQQA08+Y/NPM5+AavyXJCmPScvhFjN5v5PFIHEZz2nyU/lYs7kZW+ReEm/eW9hRTaMCfG3PU0owRjJ15eyl11M7iRO2gSyig+KCtQZXMhR1RRucaGR7JjqVJw34qPUwEQlUgI61wT6mVpzMdp69QMSvsFmJNmF60avbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311875; c=relaxed/simple;
	bh=MJ/R0bMeTIrjfrnBkojOM2eR/jGvcJMinCKgBPSMTjA=;
	h=Date:To:From:Subject:Message-Id; b=NJw2/ncDlyIezOh1x1wRU3aWdv+Jx9PVVhiuvm/t96MmIs30r0Q2qeLoUK1jmeEwWCo3psckHpufYuOKeK/xpxm49SRPaTgnOu8BQ/T5h3LYeKj5lEYRV4tgY7hbcgrBZnu/MSrzINYqZqGXcrSJ8SIDy+R+gb89BOSTAaYAi+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YoB1Ktcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YoB1Ktcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA269C4CEC8;
	Mon,  2 Sep 2024 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311874;
	bh=MJ/R0bMeTIrjfrnBkojOM2eR/jGvcJMinCKgBPSMTjA=;
	h=Date:To:From:Subject:From;
	b=YoB1KtcfJJlP24E4UgVKW/+T74a3MMkj3V1PbWe+vODMR0p3aaq0Q4dVfTLfJkFrd
	 SvthDqrOsth2TV5l+y7os/zd81aali9jK3wb/mo82NKj2L3q1aIGAVj+gwVDKYRkWK
	 I5PEyjsHaueEYi4Ij2T0r6y/5HC1VDk/+4NI7gAY=
Date: Mon, 02 Sep 2024 14:17:54 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zstd-export-api-needed-for-dictionary-support.patch added to mm-unstable branch
Message-Id: <20240902211754.CA269C4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: zstd: export API needed for dictionary support
has been added to the -mm mm-unstable branch.  Its filename is
     lib-zstd-export-api-needed-for-dictionary-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zstd-export-api-needed-for-dictionary-support.patch

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
Subject: lib: zstd: export API needed for dictionary support
Date: Mon, 2 Sep 2024 19:55:49 +0900

Patch series "zram: introduce custom comp backends API", v7.

This series introduces support for run-time compression algorithms tuning,
so users, for instance, can adjust compression/acceleration levels and
provide pre-trained compression/decompression dictionaries which certain
algorithms support.

At this point we stop supporting (old/deprecated) comp API.  We may add
new acomp API support in the future, but before that zram needs to undergo
some major rework (we are not ready for async compression).

Some benchmarks for reference (look at column #2)

*** init zstd
/sys/block/zram0/mm_stat
1750659072 504622188 514355200        0 514355200        1        0    34204    34204

*** init zstd dict=/home/ss/zstd-dict-amd64
/sys/block/zram0/mm_stat
1750650880 465908890 475398144        0 475398144        1        0    34185    34185

*** init zstd level=8 dict=/home/ss/zstd-dict-amd64
/sys/block/zram0/mm_stat
1750654976 430803319 439873536        0 439873536        1        0    34185    34185

*** init lz4
/sys/block/zram0/mm_stat
1750646784 664266564 677060608        0 677060608        1        0    34288    34288

*** init lz4 dict=/home/ss/lz4-dict-amd64
/sys/block/zram0/mm_stat
1750650880 619990300 632102912        0 632102912        1        0    34278    34278

*** init lz4hc
/sys/block/zram0/mm_stat
1750630400 609023822 621232128        0 621232128        1        0    34288    34288

*** init lz4hc dict=/home/ss/lz4-dict-amd64
/sys/block/zram0/mm_stat
1750659072 505133172 515231744        0 515231744        1        0    34278    34278


Recompress
init zram zstd (prio=0), zstd level=5 (prio 1), zstd with dict (prio 2)

*** zstd
/sys/block/zram0/mm_stat
1750982656 504630584 514269184        0 514269184        1        0    34204    34204

*** idle recompress priority=1 (zstd level=5)
/sys/block/zram0/mm_stat
1750982656 488645601 525438976        0 514269184        1        0    34204    34204

*** idle recompress priority=2 (zstd dict)
/sys/block/zram0/mm_stat
1750982656 460869640 517914624        0 514269184        1        0    34185    34204


This patch (of 24):

We need to export a number of API functions that enable advanced zstd
usage - C/D dictionaries, dictionaries sharing between contexts, etc.

Link: https://lkml.kernel.org/r/20240902105656.1383858-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240902105656.1383858-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zstd.h              |  167 ++++++++++++++++++++++++++++
 lib/zstd/zstd_compress_module.c   |   49 ++++++++
 lib/zstd/zstd_decompress_module.c |   36 ++++++
 3 files changed, 252 insertions(+)

--- a/include/linux/zstd.h~lib-zstd-export-api-needed-for-dictionary-support
+++ a/include/linux/zstd.h
@@ -77,6 +77,30 @@ int zstd_min_clevel(void);
  */
 int zstd_max_clevel(void);
 
+/**
+ * zstd_default_clevel() - default compression level
+ *
+ * Return: Default compression level.
+ */
+int zstd_default_clevel(void);
+
+/**
+ * struct zstd_custom_mem - custom memory allocation
+ */
+typedef ZSTD_customMem zstd_custom_mem;
+
+/**
+ * struct zstd_dict_load_method - Dictionary load method.
+ * See zstd_lib.h.
+ */
+typedef ZSTD_dictLoadMethod_e zstd_dict_load_method;
+
+/**
+ * struct zstd_dict_content_type - Dictionary context type.
+ * See zstd_lib.h.
+ */
+typedef ZSTD_dictContentType_e zstd_dict_content_type;
+
 /* ======   Parameter Selection   ====== */
 
 /**
@@ -136,6 +160,19 @@ typedef ZSTD_parameters zstd_parameters;
 zstd_parameters zstd_get_params(int level,
 	unsigned long long estimated_src_size);
 
+
+/**
+ * zstd_get_cparams() - returns zstd_compression_parameters for selected level
+ * @level:              The compression level
+ * @estimated_src_size: The estimated source size to compress or 0
+ *                      if unknown.
+ * @dict_size:          Dictionary size.
+ *
+ * Return:              The selected zstd_compression_parameters.
+ */
+zstd_compression_parameters zstd_get_cparams(int level,
+	unsigned long long estimated_src_size, size_t dict_size);
+
 /* ======   Single-pass Compression   ====== */
 
 typedef ZSTD_CCtx zstd_cctx;
@@ -180,6 +217,71 @@ zstd_cctx *zstd_init_cctx(void *workspac
 size_t zstd_compress_cctx(zstd_cctx *cctx, void *dst, size_t dst_capacity,
 	const void *src, size_t src_size, const zstd_parameters *parameters);
 
+/**
+ * zstd_create_cctx_advanced() - Create compression context
+ * @custom_mem:   Custom allocator.
+ *
+ * Return:        NULL on error, pointer to compression context otherwise.
+ */
+zstd_cctx *zstd_create_cctx_advanced(zstd_custom_mem custom_mem);
+
+/**
+ * zstd_free_cctx() - Free compression context
+ * @cdict:        Pointer to compression context.
+ *
+ * Return:        Always 0.
+ */
+size_t zstd_free_cctx(zstd_cctx* cctx);
+
+/**
+ * struct zstd_cdict - Compression dictionary.
+ * See zstd_lib.h.
+ */
+typedef ZSTD_CDict zstd_cdict;
+
+/**
+ * zstd_create_cdict_byreference() - Create compression dictionary
+ * @dict:              Pointer to dictionary buffer.
+ * @dict_size:         Size of the dictionary buffer.
+ * @dict_load_method:  Dictionary load method.
+ * @dict_content_type: Dictionary content type.
+ * @custom_mem:        Memory allocator.
+ *
+ * Note, this uses @dict by reference (ZSTD_dlm_byRef), so it should be
+ * free before zstd_cdict is destroyed.
+ *
+ * Return:             NULL on error, pointer to compression dictionary
+ *                     otherwise.
+ */
+zstd_cdict *zstd_create_cdict_byreference(const void *dict, size_t dict_size,
+					  zstd_compression_parameters cparams,
+					  zstd_custom_mem custom_mem);
+
+/**
+ * zstd_free_cdict() - Free compression dictionary
+ * @cdict:        Pointer to compression dictionary.
+ *
+ * Return:        Always 0.
+ */
+size_t zstd_free_cdict(zstd_cdict* cdict);
+
+/**
+ * zstd_compress_using_cdict() - compress src into dst using a dictionary
+ * @cctx:         The context. Must have been initialized with zstd_init_cctx().
+ * @dst:          The buffer to compress src into.
+ * @dst_capacity: The size of the destination buffer. May be any size, but
+ *                ZSTD_compressBound(srcSize) is guaranteed to be large enough.
+ * @src:          The data to compress.
+ * @src_size:     The size of the data to compress.
+ * @cdict:        The dictionary to be used.
+ *
+ * Return:        The compressed size or an error, which can be checked using
+ *                zstd_is_error().
+ */
+size_t zstd_compress_using_cdict(zstd_cctx *cctx, void *dst,
+	size_t dst_capacity, const void *src, size_t src_size,
+	const zstd_cdict *cdict);
+
 /* ======   Single-pass Decompression   ====== */
 
 typedef ZSTD_DCtx zstd_dctx;
@@ -220,6 +322,71 @@ zstd_dctx *zstd_init_dctx(void *workspac
 size_t zstd_decompress_dctx(zstd_dctx *dctx, void *dst, size_t dst_capacity,
 	const void *src, size_t src_size);
 
+/**
+ * struct zstd_ddict - Decompression dictionary.
+ * See zstd_lib.h.
+ */
+typedef ZSTD_DDict zstd_ddict;
+
+/**
+ * zstd_create_ddict_byreference() - Create decompression dictionary
+ * @dict:              Pointer to dictionary buffer.
+ * @dict_size:         Size of the dictionary buffer.
+ * @dict_load_method:  Dictionary load method.
+ * @dict_content_type: Dictionary content type.
+ * @custom_mem:        Memory allocator.
+ *
+ * Note, this uses @dict by reference (ZSTD_dlm_byRef), so it should be
+ * free before zstd_ddict is destroyed.
+ *
+ * Return:             NULL on error, pointer to decompression dictionary
+ *                     otherwise.
+ */
+zstd_ddict *zstd_create_ddict_byreference(const void *dict, size_t dict_size,
+					  zstd_custom_mem custom_mem);
+/**
+ * zstd_free_ddict() - Free decompression dictionary
+ * @dict:         Pointer to the dictionary.
+ *
+ * Return:        Always 0.
+ */
+size_t zstd_free_ddict(zstd_ddict *ddict);
+
+/**
+ * zstd_create_dctx_advanced() - Create decompression context
+ * @custom_mem:   Custom allocator.
+ *
+ * Return:        NULL on error, pointer to decompression context otherwise.
+ */
+zstd_dctx *zstd_create_dctx_advanced(zstd_custom_mem custom_mem);
+
+/**
+ * zstd_free_dctx() -- Free decompression context
+ * @dctx:         Pointer to decompression context.
+ * Return:        Always 0.
+ */
+size_t zstd_free_dctx(zstd_dctx *dctx);
+
+/**
+ * zstd_decompress_using_ddict() - decompress src into dst using a dictionary
+ * @dctx:         The decompression context.
+ * @dst:          The buffer to decompress src into.
+ * @dst_capacity: The size of the destination buffer. Must be at least as large
+ *                as the decompressed size. If the caller cannot upper bound the
+ *                decompressed size, then it's better to use the streaming API.
+ * @src:          The zstd compressed data to decompress. Multiple concatenated
+ *                frames and skippable frames are allowed.
+ * @src_size:     The exact size of the data to decompress.
+ * @ddict:        The dictionary to be used.
+ *
+ * Return:        The decompressed size or an error, which can be checked using
+ *                zstd_is_error().
+ */
+size_t zstd_decompress_using_ddict(zstd_dctx *dctx,
+	void *dst, size_t dst_capacity, const void *src, size_t src_size,
+	const zstd_ddict *ddict);
+
+
 /* ======   Streaming Buffers   ====== */
 
 /**
--- a/lib/zstd/zstd_compress_module.c~lib-zstd-export-api-needed-for-dictionary-support
+++ a/lib/zstd/zstd_compress_module.c
@@ -66,6 +66,12 @@ int zstd_max_clevel(void)
 }
 EXPORT_SYMBOL(zstd_max_clevel);
 
+int zstd_default_clevel(void)
+{
+	return ZSTD_defaultCLevel();
+}
+EXPORT_SYMBOL(zstd_default_clevel);
+
 size_t zstd_compress_bound(size_t src_size)
 {
 	return ZSTD_compressBound(src_size);
@@ -79,6 +85,13 @@ zstd_parameters zstd_get_params(int leve
 }
 EXPORT_SYMBOL(zstd_get_params);
 
+zstd_compression_parameters zstd_get_cparams(int level,
+	unsigned long long estimated_src_size, size_t dict_size)
+{
+	return ZSTD_getCParams(level, estimated_src_size, dict_size);
+}
+EXPORT_SYMBOL(zstd_get_cparams);
+
 size_t zstd_cctx_workspace_bound(const zstd_compression_parameters *cparams)
 {
 	return ZSTD_estimateCCtxSize_usingCParams(*cparams);
@@ -93,6 +106,33 @@ zstd_cctx *zstd_init_cctx(void *workspac
 }
 EXPORT_SYMBOL(zstd_init_cctx);
 
+zstd_cctx *zstd_create_cctx_advanced(zstd_custom_mem custom_mem)
+{
+	return ZSTD_createCCtx_advanced(custom_mem);
+}
+EXPORT_SYMBOL(zstd_create_cctx_advanced);
+
+size_t zstd_free_cctx(zstd_cctx *cctx)
+{
+	return ZSTD_freeCCtx(cctx);
+}
+EXPORT_SYMBOL(zstd_free_cctx);
+
+zstd_cdict *zstd_create_cdict_byreference(const void *dict, size_t dict_size,
+					  zstd_compression_parameters cparams,
+					  zstd_custom_mem custom_mem)
+{
+	return ZSTD_createCDict_advanced(dict, dict_size, ZSTD_dlm_byRef,
+					 ZSTD_dct_auto, cparams, custom_mem);
+}
+EXPORT_SYMBOL(zstd_create_cdict_byreference);
+
+size_t zstd_free_cdict(zstd_cdict *cdict)
+{
+	return ZSTD_freeCDict(cdict);
+}
+EXPORT_SYMBOL(zstd_free_cdict);
+
 size_t zstd_compress_cctx(zstd_cctx *cctx, void *dst, size_t dst_capacity,
 	const void *src, size_t src_size, const zstd_parameters *parameters)
 {
@@ -101,6 +141,15 @@ size_t zstd_compress_cctx(zstd_cctx *cct
 }
 EXPORT_SYMBOL(zstd_compress_cctx);
 
+size_t zstd_compress_using_cdict(zstd_cctx *cctx, void *dst,
+	size_t dst_capacity, const void *src, size_t src_size,
+	const ZSTD_CDict *cdict)
+{
+	return ZSTD_compress_usingCDict(cctx, dst, dst_capacity,
+					src, src_size, cdict);
+}
+EXPORT_SYMBOL(zstd_compress_using_cdict);
+
 size_t zstd_cstream_workspace_bound(const zstd_compression_parameters *cparams)
 {
 	return ZSTD_estimateCStreamSize_usingCParams(*cparams);
--- a/lib/zstd/zstd_decompress_module.c~lib-zstd-export-api-needed-for-dictionary-support
+++ a/lib/zstd/zstd_decompress_module.c
@@ -44,6 +44,33 @@ size_t zstd_dctx_workspace_bound(void)
 }
 EXPORT_SYMBOL(zstd_dctx_workspace_bound);
 
+zstd_dctx *zstd_create_dctx_advanced(zstd_custom_mem custom_mem)
+{
+	return ZSTD_createDCtx_advanced(custom_mem);
+}
+EXPORT_SYMBOL(zstd_create_dctx_advanced);
+
+size_t zstd_free_dctx(zstd_dctx *dctx)
+{
+	return ZSTD_freeDCtx(dctx);
+}
+EXPORT_SYMBOL(zstd_free_dctx);
+
+zstd_ddict *zstd_create_ddict_byreference(const void *dict, size_t dict_size,
+					  zstd_custom_mem custom_mem)
+{
+	return ZSTD_createDDict_advanced(dict, dict_size, ZSTD_dlm_byRef,
+					 ZSTD_dct_auto, custom_mem);
+
+}
+EXPORT_SYMBOL(zstd_create_ddict_byreference);
+
+size_t zstd_free_ddict(zstd_ddict *ddict)
+{
+	return ZSTD_freeDDict(ddict);
+}
+EXPORT_SYMBOL(zstd_free_ddict);
+
 zstd_dctx *zstd_init_dctx(void *workspace, size_t workspace_size)
 {
 	if (workspace == NULL)
@@ -59,6 +86,15 @@ size_t zstd_decompress_dctx(zstd_dctx *d
 }
 EXPORT_SYMBOL(zstd_decompress_dctx);
 
+size_t zstd_decompress_using_ddict(zstd_dctx *dctx,
+	void *dst, size_t dst_capacity, const void* src, size_t src_size,
+	const zstd_ddict* ddict)
+{
+	return ZSTD_decompress_usingDDict(dctx, dst, dst_capacity, src,
+					  src_size, ddict);
+}
+EXPORT_SYMBOL(zstd_decompress_using_ddict);
+
 size_t zstd_dstream_workspace_bound(size_t max_window_size)
 {
 	return ZSTD_estimateDStreamSize(max_window_size);
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

