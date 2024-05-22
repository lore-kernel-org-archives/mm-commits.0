Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4448142910
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417130; cv=none; b=pCTZYIqCjDCrH04yHhfYT+nFtHB4NNsT4oMDXkbNYJH79LCBZOAcXsMCmdlj+e0wUgQjl0zimvhDUrFoy2bc9sZ7j7lSAIrIiyOJ1jdNdy+RuzewNDcSDiHwbtm2/HxU7e8ALvvv9hLeFBSXse1E7NceehewAC6a+VvBIHx/KZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417130; c=relaxed/simple;
	bh=Fjd7d9X5vT+B2s0MTqr3JkA+1HSDNPFkyjhl4SCDXDY=;
	h=Date:To:From:Subject:Message-Id; b=TGKYLG+cPwTnvxhe+icvjS9Fm7IRSKyyxwmFiZLb6b4VXiUdLx3HmZ6IJNLxCofLfz6un4Ktbh9NX8rrhJWHhX84Q73RpSMDLwqD1lF5++1+6XAjHo1KC53GFClEewJja22vsdx5Aw6RmK46jwKD61VolAHJ5Vw7dExsTbm6qPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HjJAXQ4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HjJAXQ4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BEAC2BBFC;
	Wed, 22 May 2024 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417130;
	bh=Fjd7d9X5vT+B2s0MTqr3JkA+1HSDNPFkyjhl4SCDXDY=;
	h=Date:To:From:Subject:From;
	b=HjJAXQ4M8xHHYhZcuqXdjS622MVf81QfVFQgvX0aoRcdQK7Xf5GnUUQVrATt6Wfai
	 Sj5YHD/gS2u8emaLOdXjIlz2KDoX1SsruUehBsw+VmZdemhry1NscsP9a0HvPiReML
	 LtvhlyXQ+6UCKAQ2BcYNa/2KI2nWmPvbcj9XLQ9I=
Date: Wed, 22 May 2024 15:32:09 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zstd-export-api-needed-for-dictionary-support.patch added to mm-unstable branch
Message-Id: <20240522223210.59BEAC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/zstd: export API needed for dictionary support
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
Subject: lib/zstd: export API needed for dictionary support
Date: Wed, 15 May 2024 16:12:51 +0900

We need to export a number of API functions that enable advanced zstd
usage - C/D dictionaries, dictionaries sharing between contexts, etc.

Link: https://lkml.kernel.org/r/20240515071645.1788128-15-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zstd.h              |  165 ++++++++++++++++++++++++++++
 lib/zstd/zstd_compress_module.c   |   52 ++++++++
 lib/zstd/zstd_decompress_module.c |   38 ++++++
 3 files changed, 255 insertions(+)

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
@@ -180,6 +217,70 @@ zstd_cctx *zstd_init_cctx(void *workspac
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
+ * zstd_create_cdict_advanced() - Create compression dictionary
+ * @dict:              Pointer to dictionary buffer.
+ * @dict_size:         Size of the dictionary buffer.
+ * @dict_load_method:  Dictionary load method.
+ * @dict_content_type: Dictionary content type.
+ * @custom_mem:        Memory allocator.
+ *
+ * Return:             NULL on error, pointer to compression dictionary
+ *                     otherwise.
+ */
+zstd_cdict *zstd_create_cdict_advanced(const void *dict, size_t dict_size,
+				       zstd_dict_load_method dict_load_method,
+				       zstd_dict_content_type dict_content_type,
+				       zstd_compression_parameters cparams,
+				       zstd_custom_mem custom_mem);
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
@@ -220,6 +321,70 @@ zstd_dctx *zstd_init_dctx(void *workspac
 size_t zstd_decompress_dctx(zstd_dctx *dctx, void *dst, size_t dst_capacity,
 	const void *src, size_t src_size);
 
+/**
+ * struct zstd_ddict - Decompression dictionary.
+ * See zstd_lib.h.
+ */
+typedef ZSTD_DDict zstd_ddict;
+
+/**
+ * zstd_create_ddict_advanced() - Create decompression dictionary
+ * @dict:              Pointer to dictionary buffer.
+ * @dict_size:         Size of the dictionary buffer.
+ * @dict_load_method:  Dictionary load method.
+ * @dict_content_type: Dictionary content type.
+ * @custom_mem:        Memory allocator.
+ *
+ * Return:             NULL on error, pointer to decompression dictionary
+ *                     otherwise.
+ */
+zstd_ddict *zstd_create_ddict_advanced(const void *dict, size_t dict_size,
+				       zstd_dict_load_method dict_load_method,
+				       zstd_dict_content_type dict_content_type,
+				       zstd_custom_mem custom_mem);
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
@@ -93,6 +106,36 @@ zstd_cctx *zstd_init_cctx(void *workspac
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
+zstd_cdict *zstd_create_cdict_advanced(const void *dict, size_t dict_size,
+				       zstd_dict_load_method dict_load_method,
+				       zstd_dict_content_type dict_content_type,
+				       zstd_compression_parameters cparams,
+				       zstd_custom_mem custom_mem)
+{
+	return ZSTD_createCDict_advanced(dict, dict_size, dict_load_method,
+					 dict_content_type, cparams,
+					 custom_mem);
+}
+EXPORT_SYMBOL(zstd_create_cdict_advanced);
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
@@ -101,6 +144,15 @@ size_t zstd_compress_cctx(zstd_cctx *cct
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
@@ -44,6 +44,35 @@ size_t zstd_dctx_workspace_bound(void)
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
+zstd_ddict *zstd_create_ddict_advanced(const void *dict, size_t dict_size,
+                                      zstd_dict_load_method dict_load_method,
+                                      zstd_dict_content_type dict_content_type,
+                                      zstd_custom_mem custom_mem)
+{
+	return ZSTD_createDDict_advanced(dict, dict_size, dict_load_method,
+					 dict_content_type, custom_mem);
+
+}
+EXPORT_SYMBOL(zstd_create_ddict_advanced);
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
@@ -59,6 +88,15 @@ size_t zstd_decompress_dctx(zstd_dctx *d
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

